module ForemanSnapshot
  module Concerns
    module HostgroupsControllerExtension
      extend Apipie::DSL::Concern
      extend ActiveSupport::Concern

      included do
        before_filter :find_resource, :only => %w{snapshot}
      end

      api :GET, "/hostgroups/:id/snapshot", "Snapshot a hostgroup."
      param :id, :identifier, :required => true
      param :host, Hash do
        param :name,                String
        param :compute_resource_id, :number
        param :hostgroup_id,        :number
        param :build,               :bool
        param :managed,             :bool
        param :compute_attributes, Hash do
          param :flavor_ref, :number
          param :network,    String
          param :image_ref,  String
        end
      end
      def snapshot
        # To avoid possible DNS conflicts with recent previous builds
        # use a semi-random hostname
        num = (Random.rand * 100 ).to_i
        hash = HashWithIndifferentAccess.new({
          :name                => "#{@hostgroup.name.downcase}#{num}",
          :compute_resource_id => ::ComputeResource.first.id,
          :hostgroup_id        => @hostgroup.id,
          :build               => 1,
          :managed             => true,
          :compute_attributes  => { :start => "1" }
        })
        # TODO: why doesn't :start work?


        hash.deep_merge!(params[:host]) if params[:host].present?

        # Override any user_supplied or hostgroup password because we have
        # no way to get it back in unencrypted form
        hash[:root_pass] = 'password'

        if hash[:compute_profile_id].present?
          # can't use profiles directly until #4250 is done, so hack it here
          c = ComputeResource.find(hash[:compute_resource_id])
          p = c.compute_attributes.find_by_compute_profile_id(hash[:compute_profile_id])
          hash = HashWithIndifferentAccess.new({:compute_attributes => p.vm_attrs}).deep_merge(hash)
        end
        
        # Use Dynflow for webrick or other single-threaded servers as
        # Snapshot needs to call Puppet while the host creation is still
        # in progress (which could be a server-blocking action)
        if defined? ForemanTasks
          task = ::ForemanTasks.async_task(::Actions::Foreman::Hostgroup::Snapshot, hash)
          render :json => {:task_id => task.id}, :status => 202
        else
          status = ::Hostgroup.snapshot!(hash)
          logger.debug status.inspect
          if status.nil?
            render :json => {'message' => 'Foreman::Snapshot failed!'}, :status => 500
          else
            render :json => {'message' => "Foreman::Snapshot created #{status.name}"}, :status => 200
          end
        end

      rescue ::Foreman::Exception => e
        render :json => {'message'=>e.to_s}, :status => :unprocessable_entity
      end

      def action_permission
        case params[:action]
        when 'snapshot'
          :edit
        else
          super
        end
      end

    end
  end
end

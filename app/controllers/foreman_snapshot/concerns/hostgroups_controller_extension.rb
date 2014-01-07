module ForemanSnapshot
  module Concerns
    module HostgroupsControllerExtension
      extend ActiveSupport::Concern

      included do
        before_filter :find_resource, :only => %w{snapshot}

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

      end

      def snapshot
        hash = HashWithIndifferentAccess.new({
          :name                => @hostgroup.name.downcase,
          :compute_resource_id => ::ComputeResource.first.id,
          :hostgroup_id        => @hostgroup.id,
          :build               => 1,
          :managed             => true,
          :compute_attributes  => {
            :flavor_ref          => 1,
            :network             => "public",
            :image_ref           => ::ComputeResource.first.images.first.uuid
          }
        })

        hash.merge!(params[:host]) if params[:host].present?

        task = ::ForemanTasks.async_task(::Actions::Foreman::Hostgroup::Snapshot, hash)

        render :json => {:task_id => task.id}, :status => 202
      rescue ::Foreman::Exception => e
        render :json => {'message'=>e.to_s}, :status => :unprocessable_entity
      end

    end
  end
end

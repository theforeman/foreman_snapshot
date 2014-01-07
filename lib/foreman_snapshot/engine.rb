module ForemanSnapshot
  class Engine < ::Rails::Engine
    engine_name "foreman_snapshot"

    initializer 'foreman_snapshot.register_plugin', :after=> :finisher_hook do |app|
      Foreman::Plugin.register :foreman_snapshot do
        requires_foreman '> 1.3'
      end
    end

    initializer "foreman_snapshot.register_actions" do |app|
      ForemanTasks.dynflow.require!
      ForemanTasks.dynflow.config.eager_load_paths.concat(%W[#{ForemanTasks::Engine.root}/app/lib/actions])
    end

    config.to_prepare do
      ::Host::Base.send :include, Host::BaseExtensions
      ::Hostgroup.send :include, HostgroupExtensions
      ::ComputeResource.send :include, ComputeResourceExtensions
      ::Foreman::Model::Openstack.send :include, OpenstackExtensions
      ::Api::V2::HostgroupsController.send :include, ForemanSnapshot::Concerns::HostgroupsControllerExtension
    end

  end

  def use_relative_model_naming
    true
  end
end

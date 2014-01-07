module ForemanSnapshot
  class Snapshot
    include Foreman::Renderer

    attr_reader :host

    delegate :compute_resource, :hostgroup, :compute_object, :image, :to => :host
    delegate :logger, :to => :Rails
    alias_method :vm, :compute_object

    def initialize(opts = {})
      @host = opts[:host]
      raise "must provide a host" unless @host.present?
    end

    # takes an existing Host, and convert it into an image based on his HG.
    def create
      template = template_file  # workaround to ensure tempfile sticks around a bit longer
      client = Foreman::Provision::SSH.new ip, image.username, { :template => template.path }.merge(credentials)

      # we have a puppet cert already, thanks to this being a built host
      # Just need to ensure the template has "puppet agent -tv" inside to get a full run
      if client.deploy!
        # Built the image, so snapshot it, and get the response from Fog
        name = "#{hostgroup.label} - #{DateTime.now.strftime("%m/%d/%Y")}"
        title = "Foreman Hostgroup #{hostgroup.label} Image"
        snapshot = compute_resource.snapshot_vm(host.uuid, title)
        raise "failed to snapshot #{snapshot}" unless snapshot
        wait_for_active(snapshot)
        # Create a new Image in Foreman that links to it
        Image.find_or_create_by_name(
          :name                => name,
          :compute_resource_id => compute_resource.id,
          :operatingsystem_id  => image.operatingsystem_id,
          :architecture_id     => image.architecture_id,
          :hostgroup_id        => hostgroup.id,
          :username            => image.username,
          :uuid                => snapshot
        )
      end
    ensure
      template.unlink
    end

    private

    def ip
      vm.floating_ip_address
    end

    def credentials
      { :key_data => [compute_resource.key_pair.secret] }
    end

    def cleanup_template
      ConfigTemplate.find_by_name('Imagify').try(:template) || raise('unable to find template Imagify')
    end

    def template_file
      unattended_render_to_temp_file(cleanup_template, hostgroup.id.to_s)
    end

    def wait_for_active id
      # We can't delete the underlying Host until the image has finished saving
      until compute_resource.snapshot_status(id) == "ACTIVE"
        sleep 1
      end
    end

  end
end

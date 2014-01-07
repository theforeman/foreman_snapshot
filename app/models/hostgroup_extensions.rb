module HostgroupExtensions
  extend ActiveSupport::Concern

  module ClassMethods 
    def snapshot!(host_hash)
      # check if a host already exists, i.e. a snapshot is in progress already
      # need to search without the domain
      return true unless Host.where("name LIKE ?","#{host_hash[:name]}%").empty?

      if @host=::Host::Managed.create!(host_hash)
        @host.snapshot!
        raise unless @host.destroy
      end
    end
  end

end

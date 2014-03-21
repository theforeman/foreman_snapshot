module HostgroupExtensions
  extend ActiveSupport::Concern

  module ClassMethods 
    def snapshot!(host_hash)
      image = nil

      # This could be run from Dynflow or directly, so we need
      # to use uncached{} to be able to detect the change in build state
      begin
        if @host=::Host::Managed.create!(host_hash)
          until @host.build == false
            logger.debug "Sleeping for host build state: #{@host.build}"
            sleep 10
            # Reload cache for next sleep check
            @host = uncached { Host.find(@host.id) }
          end
          logger.debug "Done waiting - #{@host.build}"
          image = @host.snapshot!
          raise unless @host.destroy
        end
      rescue Exception => e
        logger.debug e.message
        raise e
      end

      return image
    end
  end

end

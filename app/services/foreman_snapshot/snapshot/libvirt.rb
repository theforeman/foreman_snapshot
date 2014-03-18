module ForemanSnapshot
  class Snapshot
    class Libvirt < ForemanSnapshot::Snapshot

      def ip
        @host.ip
      end

      def credentials
        # TODO: Force the password to match here - for now ensure the HG
        # is set to use 'password'
        { :password => 'password', :auth_methods => ["password"] }
      end

      def username
        # While a user could be created in the PXE process, we have no
        # way to find it out, so we assume root-access for PXE
        "root"
      end

      def image_hash
        {
            :operatingsystem_id  => @host.operatingsystem_id,
            :architecture_id     => @host.architecture_id,
            :password            => 'password',
            :username            => username,
        }
      end

    end
  end
end

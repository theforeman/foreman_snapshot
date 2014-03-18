module ForemanSnapshot
  class Snapshot
    class Libvirt < ForemanSnapshot::Snapshot

      def ip
        @host.ip
      end

      def credentials
        { :key_data => [compute_resource.key_pair.secret] }
      end

      def username
        image.username
      end

      def image_hash
        {
            :operatingsystem_id  => image.operatingsystem_id,
            :architecture_id     => image.architecture_id,
            :username            => username,
        }
      end

    end
  end
end

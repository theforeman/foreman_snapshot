module Actions
  module Foreman
    module Hostgroup

      class Snapshot < Actions::EntryAction

        def resource_locks
          :snapshot
        end

        #def plan(hostgroup_id, user_id, host_hash)
        #  action_subject(hostgroup_id, user_id, host_hash)
        #end

        def run
          ::User.as :admin do
            output[:state] = ::Hostgroup.snapshot!(input)
          end
        end

        def humanized_name
          _("Create Snapshot: ")
        end

        def humanized_input
          input[:hostgroup_id] && ::Hostgroup.find(input[:hostgroup_id]).to_label
        end

      end
    end
  end
end


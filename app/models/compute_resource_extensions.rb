module ComputeResourceExtensions
  extend ActiveSupport::Concern

  def snapshot_vm uuid, title = nil
    raise _("Not implemented for this provider")
  end

  def snapshot_status uuid
    raise _("Not implemented for this provider")
  end

end

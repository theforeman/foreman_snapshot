module ComputeResourceExtensions
  extend ActiveSupport::Concern

  def snapshot_vm uuid, title = nil
    raise _("Not implemented for this provider")
  end

end

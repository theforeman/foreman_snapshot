module LibvirtExtensions
  extend ActiveSupport::Concern

  def snapshot_vm uuid, title = nil
    vm       = find_vm_by_uuid(uuid)
    vol_name = title.downcase.gsub(' ','_') + '.img'
    # TODO: We're assuming the first volume is the rootvol
    snapshot = vm.volumes.first.clone_volume(vol_name)
    # The return from clone_volume is the original vol, so re-find the new one
    vol      = client.volumes.detect{|n| n.name == vol_name}
    return false unless snapshot && vol
    return false unless vol
    vol.path
  end

  def snapshot_status uuid
    # clone_volume is a blocking call so this is automatically true
    "ACTIVE"
  end

end

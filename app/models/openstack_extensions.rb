module OpenstackExtensions
  extend ActiveSupport::Concern

  def snapshot_vm uuid, title = nil
    vm = find_vm_by_uuid(uuid)
    snapshot = vm.create_image(title)
    return false unless snapshot.data[:body]['image']['id'].present?
    # todo, this should return a volume object
    snapshot[:body]['image']['id']
  end

  def snapshot_status uuid
    available_images.find {|i| i.id == uuid}.status
  end

end

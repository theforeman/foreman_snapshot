module Host::BaseExtensions
  extend ActiveSupport::Concern

  def snapshot!
    return false if compute_resource_id.nil? or !compute_resource.capabilities.include?(:image)
    ForemanSnapshot::Snapshot.new(:host => self).create
  end

end

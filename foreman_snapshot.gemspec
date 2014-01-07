$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "foreman_snapshot/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = %q{foreman_snapshot}
  s.version     = ForemanSnapshot::VERSION
  s.authors = ["Greg Sutcliffe"]
  s.email = %q{gsutclif@redhat.com}
  s.description = %q{Plugin to enable snapshots on Openstack/EC2/oVirt/etc}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = Dir["{app,extra,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
  s.homepage = %q{http://github.com/theforeman/foreman_snapshot}
  s.licenses = ["GPL-3"]
  s.summary = %q{Snapshot Plugin for Foreman}

end

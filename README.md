# Foreman Snapshot
---

A plugin to create images from Hostgroups

## Installation

Please see the Foreman wiki for appropriate instructions:

* [Foreman: How to Install a Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Plugin)

The gem name is "foreman_snapshot".

RPM users can install the "ruby193-rubygem-foreman_snapshot" or
"rubygem-foreman_snapshot" packages. DEB users can install "ruby-foreman-snapshot"

## Compatibility

| Foreman Version | Plugin Version |
| --------------- | --------------:|
| <= 1.4          | not supported  |
| >  1.4          | 0.1.0          |

| Supported Compute Resources |
| --------------------------- |
| [Openstack](#openstack)     |
| [Libvirt](#libvirt)         |

# Usage

The plugin has no UI as yet, so send an API request to
`/api/v2/hostgroups/:id/snapshot`. Replace :id with the hostgroup id as normal.
See the sections below for examples for each compute resource.

The request will block until complete (unless using [Dynflow &
ForemanTasks](#optional-set-up-foreman-tasks), see below). This can take over
10 minutes for something like Libvirt, so be patient.

## Openstack

Send an API request like this:

```
{
  "host": {
    "compute_resource_id": 7,
    "compute_attributes": {
      "flavor_ref": 1,
      "network": "public",
      "image_ref": "9c9d4946-3e33-4f6e-92f0-f3527ef42862"
    }
  }
}
```

## Libvirt

For Libvirt you will need fog >= 1.21 for `clone_volume` support. Then send an API
request like this:

```
{
  "host": {
    "compute_resource_id": 3,
    "compute_profile_id": 1,
    "compute_attributes": {
      "image_id": "",
      "image_ref": ""
    }
  }
}
```

Unsetting the image id/ref is important, otherwise the VM may boot with a
backing volume instead of doing a fresh PXE install. You could specify
compute_attributes explicitly instead of using a compute profile.

# Optional: Set up Foreman Tasks

This plugin can use Dynflow & ForemanTasks to offload the slow process
of building, configuring, and snapshotting the image.

To use this, first configure [Foreman-Tasks](https://github.com/iNecas/foreman-tasks/)
and then continue with the normal opertion.

The API call should immediately return a Tasks id, and you should be
able to view it in /foreman_tasks/tasks.

# TODO

* More Compute Resources (ovirt, ec2, etc)
* Add Tests
* Add UI

# Copyright

Copyright (c) 2014 Red Hat

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

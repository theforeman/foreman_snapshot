# Foreman Snapshot
---

A plugin to create images from Hostgroups

| Supported Compute Resources |
| ------------------ |
| Openstack          |

# Setup

First configure [Foreman-Tasks](https://github.com/iNecas/foreman-tasks/)

Now add this plugin to the Gemfile as well, restart Rails, and send an API
request like this:

```
POST /api/v2/hostgroups/:id/snapshot
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

Replace the hostgroup :id in the URL, the flavor_ref, and the image_ref as required.

The API call should immediately return a Tasks id, and you should be
able to view it in /foreman_tasks/tasks

# TODO

* More Compute Resources (ovirt, ec2, etc)
* Add Tests

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

#!/bin/bash
#
# Export the orctest project from StreamLab

curl http://localhost:5585/_project_export/user/orctest
curl -o orctest.slab http://localhost:5585/_download/user/orctest

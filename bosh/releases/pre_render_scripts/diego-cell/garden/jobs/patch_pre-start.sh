#!/usr/bin/env bash

set -o errexit -o nounset

target="/var/vcap/all-releases/jobs-src/garden-runc/garden/templates/bin/pre-start"
sentinel="${target}.patch_sentinel"
if [[ -f "${sentinel}" ]]; then
  if sha256sum --check "${sentinel}" ; then
    echo "Patch already applied. Skipping"
    exit 0
  fi
  echo "Sentinel mismatch, re-patching"
fi

patch --verbose "${target}" <<'EOT'
--- jobs/garden/templates/bin/pre-start
+++ jobs/garden/templates/bin/pre-start
@@ -1,7 +1,3 @@
 #!/bin/bash

 set -e
-
-source /var/vcap/packages/greenskeeper/bin/system-preparation
-
-permit_device_control
EOT

sha256sum "${target}" > "${sentinel}"


#!/bin/bash
set -e
set +x

until catalina stop; do sleep 5; done
until catalina start; do sleep 1; done

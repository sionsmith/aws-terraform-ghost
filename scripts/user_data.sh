#!/bin/bash -x
set +e

#log output from this user_data script
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

sudo yum install docker

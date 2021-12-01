#!/bin/env bash

sed -i.clean "s/\${masterAddr}/$(terraform output | grep "master_ip" | cut -d '=' -f 2 | cut -d '"' -f 2)/g" inventory.ini

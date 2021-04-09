#!/bin/bash
set -em

HOME=$(/opt/get-app-dir.sh) /usr/lib/rabbitmq/bin/rabbitmq-server start &

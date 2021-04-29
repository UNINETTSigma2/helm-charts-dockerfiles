#!/bin/bash
set -em

HOME=/home/${SYSTEM_USER} /usr/lib/rabbitmq/bin/rabbitmq-server start &

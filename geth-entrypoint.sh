#!/bin/bash
set -e

echo "Starting Geth with the provided parameters..."
exec geth "$@"
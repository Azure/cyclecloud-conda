#!/bin/bash

set -x
set -e

CLUSTER_NAME=$( jetpack config cyclecloud.cluster.name )

# TODO: Generate based on Node status query, enable IB

mkdir -p /etc/dask
cat <<EOF > /etc/dask/jobqueue.yaml
# Basic defaults that should work for test jobs but should be over-ridden in user's ~/.config/dask/jobqueue.yaml
# or in the programatically via Cluster definition
jobqueue:
  lsf:
    name: dask-worker

    # Dask worker options
    cores: 2                    # Total number of cores per job
    memory: 4GB                 # Total amount of memory per job (total 328GB per node)
    processes: 1                # Number of Python processes per job


    # LSF resource manager options
    queue: cloud

    project: ${CLUSTER_NAME}  # choose project other than default


  pbs:
    name: dask-worker

    # Dask worker options
    cores: 2                    # Total number of cores per job
    memory: 4GB                 # Total amount of memory per job (total 328GB per node)
    processes: 1                # Number of Python processes per job


    # PBS resource manager options
    queue: workq
    resource-spec: "select=1:ncpus=2:mem=4GB"

    project: ${CLUSTER_NAME}  # choose project other than default


  slurm:
    name: dask-worker

    # Dask worker options
    cores: 2                   # Total number of cores per job
    memory: 4GB                 # Total amount of memory per job (total 328GB per node)
    processes: 1                # Number of Python processes per job


    # SLURM resource manager options
    queue: debug

    project: ${CLUSTER_NAME}  # choose project other than default

EOF

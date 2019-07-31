#!/bin/bash
source /etc/profile.d/anaconda-env.sh

set -x

DASK_SERVICE_ENABLED=$( jetpack config dask.start_services | tr '[:upper:]' '[:lower:]' )
if [ "${DASK_SERVICE_ENABLED}" != "true" ]; then    
    exit 0
fi
echo "Starting Dask system services..."

CLUSTER_NAME=$( jetpack config cyclecloud.cluster.name )
IS_SCHEDULER=$( jetpack config dask.is_scheduler | tr '[:upper:]' '[:lower:]' )
DASK_UI_PORT=$( jetpack config dask.dashboard.port )
if [ "${DASK_UI_PORT}" == "" ]; then
    DASK_UI_PORT='8787'
fi
SCHEDULER_PORT=$( jetpack config dask.scheduler.port )
if [ "${SCHEDULER_PORT}" == "" ]; then
    SCHEDULER_PORT='8786'
fi
NUM_SLOTS=$( jetpack config dask.slot_count )
if [ "${NUM_SLOTS}" == "" ]; then
   if [ "${IS_SCHEDULER}" == "true" ]; then
       # Default to 1 slots on the scheduler node
       NUM_SLOTS=1
   else
       NUM_SLOTS=$( jetpack config cpu.total )
   fi
fi

if [ "${IS_SCHEDULER}" == "true" ]; then
    SCHEDULER_ADDR='127.0.0.1'

else
    SCHEDULER_ADDR=$( jetpack config dask.scheduler_addr )
fi

set -e

yum install -y jq
CLUSTER_OWNER=$( jetpack users --owner --json | jq -r '.name' )

SCHEDULER_PATH=$( type -p dask-scheduler )
WORKER_PATH=$( type -p dask-worker )

WORKER_WORKDIR=/mnt/resource/daskworker/
mkdir -p ${WORKER_WORKDIR}
chown ${CLUSTER_OWNER}:${CLUSTER_OWNER} ${WORKER_WORKDIR}

if [ "${IS_SCHEDULER}" == "true" ]; then
    cat <<EOF > /etc/systemd/system/dask-scheduler.service
[Unit]
Description=Dask Scheduler Service
Documentation=https://docs.dask.org/en/latest/setup/cli.html

[Install]
WantedBy=multi-user.target

[Service]
PIDFile=/var/tmp/dask-scheduler.pid
Type=simple
ExecStart=${SCHEDULER_PATH} --pid-file=/var/tmp/dask-scheduler.pid --port ${SCHEDULER_PORT} --bokeh-port ${DASK_UI_PORT}
User=${CLUSTER_OWNER}
Group=${CLUSTER_OWNER}
RestartSec=3
Restart=always
EOF

fi

cat <<EOF > /etc/systemd/system/dask-worker.service
[Unit]
Description=Dask Worker Service
Documentation=https://docs.dask.org/en/latest/setup/cli.html

[Install]
WantedBy=multi-user.target

[Service]
PIDFile=/var/tmp/dask-worker.pid
Type=simple
ExecStart=${WORKER_PATH} --pid-file=/var/tmp/dask-worker.pid --nprocs=${NUM_SLOTS} --local-directory=${WORKER_WORKDIR} ${SCHEDULER_ADDR}:${SCHEDULER_PORT} 
User=${CLUSTER_OWNER}
Group=${CLUSTER_OWNER}
RestartSec=3
Restart=always
EOF


systemctl daemon-reload
if [ "${IS_SCHEDULER}" == "true" ]; then
    echo "Starting Dask Scheduler..."
    systemctl start dask-scheduler.service
fi

echo "Starting Dask Worker $N..."
systemctl start dask-worker.service


#!/bin/bash
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
 
set -x

source /etc/profile.d/anaconda-env.sh

ANACONDA_HOME=$( jetpack config anaconda.home )

ANACONDA_ENVIRONMENTS=$( jetpack config anaconda.env_files )

set -e

if [ ! -z "${ANACONDA_ENVIRONMENTS}" ] && [ "${ANACONDA_ENVIRONMENTS}" != "None" ]; then

    for YML in ${ANACONDA_ENVIRONMENTS}; do
	     TARGET_PATH=${CYCLECLOUD_SPEC_PATH}/files/conda_envs/${YML}
	     jetpack download ${YML} ${TARGET_PATH}

	     ENV_NAME=$( basename ${YML%.yml} )
	
	     echo "Creating conda env: ${ENV_NAME}"
	     if conda info --envs | grep -q ${ENV_NAME}; then
            echo "Skipping $YML - conda environment already exists."
            conda info --envs
	     else
            conda env create -f ${TARGET_PATH}
	     fi
    done


fi
    



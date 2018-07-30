#!/bin/bash
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

set -x

source /etc/profile.d/anaconda-env.sh

ANACONDA_HOME=$( jetpack config anaconda.home )


ANACONDA_CHANNELS=$( jetpack config anaconda.channels )
if [ -z "${ANACONDA_CHANNELS}" ] || [ "${ANACONDA_CHANNELS}" == "None" ]; then
    ANACONDA_CHANNELS="bioconda conda-forge defaults r"
fi

set -e


echo "Configuring conda channels : ${ANACONDA_CHANNELS}"
cat > ${ANACONDA_HOME}/.condarc << 'CONDA'
channels:
CONDA

for CHANNEL in ${ANACONDA_CHANNELS}; do
    echo "  - ${CHANNEL}" >> ${ANACONDA_HOME}/.condarc
done

cat >> ${ANACONDA_HOME}/.condarc << 'CONDA'

conda-build:
    skip_existing: true

CONDA



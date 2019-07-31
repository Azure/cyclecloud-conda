#!/bin/bash
#
# See: https://docs.dask.org/en/stable/install.html
#
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
source /etc/profile.d/anaconda-env.sh

set -x
set -e

# conda update --all


# Setup Channels
conda config --add channels conda-forge
conda config --add channels defaults
conda config --add channels bokeh

# Create the default environments
for PKG in bokeh dask distributed dask-jobqueue jupyter-server-proxy; do
    conda install -y ${PKG}
done

conda create -n dask bokeh dask distributed dask-jobqueue jupyter-server-proxy




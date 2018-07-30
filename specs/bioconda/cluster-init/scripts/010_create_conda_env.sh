#!/bin/bash
#
# See: https://bioconda.github.io/
#
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
source /etc/profile.d/anaconda-env.sh

# Setup Channels
conda config --add channels conda-forge
conda config --add channels defaults
conda config --add channels r
conda config --add channels bioconda

# Create the default environments
for PKG in bwa bowtie hisat2 star; do
    conda install ${PKG}
done

conda create -n aligners bwa bowtie hisat2 star



#!/bin/bash
set -xeo pipefail

export PYTHONUNBUFFERED=1
# export FEEDSTOCK_ROOT="${FEEDSTOCK_ROOT:-/home/conda/feedstock_root}"
export FEEDSTOCK_ROOT=$(cd "$(dirname "$0")/.."; pwd;)
export CONFIG_FILE="${FEEDSTOCK_ROOT}/linux_armv7l_config.yaml"
export YUM_REQUIREMENTS="${FEEDSTOCK_ROOT}/recipe/yum_requirements.txt"

if [ -e "${YUM_REQUIREMENTS}" ]; then
    echo "Install yum requirements"
    cat "${YUM_REQUIREMENTS}" | xargs sudo yum -y install
fi

echo "set anaconda upload"
conda config --set anaconda_upload yes

mkdir -p ${HOME}/.continuum/anaconda-client/
touch ${HOME}/.continuum/anaconda-client/config.yaml
anaconda config --set upload_user e8035669acarmv7

echo "Who am I"
anaconda -v whoami

echo "Start build conda package"
conda mambabuild -m "${CONFIG_FILE}" "${FEEDSTOCK_ROOT}"
# conda build -m "${CONFIG_FILE}" "${FEEDSTOCK_ROOT}"


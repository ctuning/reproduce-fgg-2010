#! /bin/bash

#
# Installation script for CK packages.
#
# See CK LICENSE.txt for licensing details.
# See CK Copyright.txt for copyright details.
#
# Developer(s): Grigori Fursin, 2015
#

# PACKAGE_DIR
# INSTALL_DIR

export PACKAGE_NAME=pocc-1.2
export SRC_DIR=${INSTALL_DIR}/${PACKAGE_NAME}

#
echo ""
echo "Copying package files ..."

cd ${INSTALL_DIR}
cp ${PACKAGE_DIR}/${PACKAGE_NAME}-full.tar.gz .
gzip -d ${PACKAGE_NAME}-full.tar.gz
tar xvf ${PACKAGE_NAME}-full.tar
rm ${PACKAGE_NAME}-full.tar

cd ${SRC_DIR}

# Build
echo ""
echo "Building ..."
echo ""

. ./install.sh
if [ "${?}" != "0" ] ; then
  echo "Error: Compilation failed in $PWD!" 
  exit 1
fi

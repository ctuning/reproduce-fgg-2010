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

export PACKAGE_NAME=pluto-0.11.3
export SRC_DIR=${INSTALL_DIR}/${PACKAGE_NAME}

#
echo ""
echo "Copying package files ..."

cd ${INSTALL_DIR}
cp ${PACKAGE_DIR}/${PACKAGE_NAME}.tar.gz .
gzip -d ${PACKAGE_NAME}.tar.gz
tar xvf ${PACKAGE_NAME}.tar
rm ${PACKAGE_NAME}.tar

cd ${SRC_DIR}

#
echo ""
echo "Configuring ..."
echo ""

./configure
if [ "${?}" != "0" ] ; then
  echo "Error: Configuration failed in $PWD!"
  exit 1
fi

# Build
echo ""
echo "Building ..."
echo ""

make
if [ "${?}" != "0" ] ; then
  echo "Error: Compilation failed in $PWD!" 
  exit 1
fi

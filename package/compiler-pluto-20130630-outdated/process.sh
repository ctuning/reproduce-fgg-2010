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

export PACKAGE_NAME=pluto-from-git-20130630-with-new-orio
export SRC_DIR=${INSTALL_DIR}/${PACKAGE_NAME}

#
echo ""
echo "Copying package files ..."

cd ${INSTALL_DIR}
cp ${PACKAGE_DIR}/${PACKAGE_NAME}.tar.bz2 .
bzip2 -d ${PACKAGE_NAME}.tar.bz2
tar xvf ${PACKAGE_NAME}.tar
rm ${PACKAGE_NAME}.tar

cd ${SRC_DIR}

#if ["$LIBRARY_PATH" -eq ""]
#then
# export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu
#else
# export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LIBRARY_PATH
#fi

#
echo ""
echo "Bootstrapping ..."
echo ""

./bootstrap.sh
if [ "${?}" != "0" ] ; then
  echo "Error: Configuration failed in $PWD!"
  exit 1
fi

#
echo ""
echo "Configuring ..."
echo ""

./configure --prefix=${INSTALL_DIR}
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

# Install
echo ""
echo "Installing ..."
echo ""

make install
if [ "${?}" != "0" ] ; then
  echo "Error: Compilation failed in $PWD!" 
  exit 1
fi

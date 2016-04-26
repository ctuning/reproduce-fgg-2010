#!/bin/bash

#
# Installation script for cM packages.
# Part of Collective Mind Infrastructure (cM).
#
# See cM LICENSE.txt for licensing details.
# See cM Copyright.txt for copyright details.
#
# Developer(s): Grigori Fursin, started on 2011.09
#

echo ""
echo "Executing local installation script ..."
echo ""

# Checking vars
if [ "$CM_INSTALL_OBJ_DIR" != "" ] ; then mkdir -p $CM_INSTALL_OBJ_DIR; fi

pj=""
if [ "${CM_PARALLEL_JOB_NUMBER}" != "" ] ; then
  pj="-j ${CM_PARALLEL_JOB_NUMBER}"
fi


if [ "${CM_SKIP_BUILD}" != "yes" ] ; then

 #
 echo ""
 echo "Bootstrapping ..."

 echo ""
 cd ${CM_LOCAL_SRC_DIR}
 ./bootstrap.sh
 if [ "${?}" != "0" ] ; then
   echo "Error: Configuration failed in $PWD!"
   exit 1
 fi

 #
 echo ""
 echo "Configuring ..."

 echo ""
 ./configure --prefix=${CM_INSTALL_DIR}
 if [ "${?}" != "0" ] ; then
   echo "Error: Configuration failed in $PWD!"
   exit 1
 fi

 # Build
 echo ""
 echo "Building ..."
 echo ""
 make $pj
  if [ "${?}" != "0" ] ; then
    echo "Error: Compilation failed in $PWD!" 
    exit 1
  fi

 # Install
 echo ""
 echo "Installing ..."
 echo ""

 make install $pj
  if [ "${?}" != "0" ] ; then
    echo "Error: Compilation failed in $PWD!" 
    exit 1
  fi

fi

# Preparing environment
echo "" >> ${CM_CODE_ENV_FILE}
echo "# Environment variables" >> ${CM_CODE_ENV_FILE}
echo "export CM_${CM_CODE_UID}_INSTALL=${CM_INSTALL_DIR}" >> ${CM_CODE_ENV_FILE}
echo "export CM_${CM_CODE_UID}_BIN=\$CM_${CM_CODE_UID}_INSTALL/bin" >> ${CM_CODE_ENV_FILE}
if [ "${CM_PROCESSOR_BITS}" == "64" ] ; then
  # On some 64-bit OS GMP still installs itself to lib instead of lib64 - check that
  if [ -d ${CM_INSTALL_DIR}/lib64 ]; then
     echo "export CM_${CM_CODE_UID}_LIB=\$CM_${CM_CODE_UID}_INSTALL/${CM_OS_LIB_DIR}" >> ${CM_CODE_ENV_FILE}
     echo "export CM_${CM_CODE_UID}_LIBS=\$CM_${CM_CODE_UID}_INSTALL/${CM_OS_LIB_DIR}:\$CM_${CM_CODE_UID}_INSTALL/lib" >> ${CM_CODE_ENV_FILE}
  else
     echo "export CM_${CM_CODE_UID}_LIB=\$CM_${CM_CODE_UID}_INSTALL/lib" >> ${CM_CODE_ENV_FILE}
     echo "export CM_${CM_CODE_UID}_LIBS=\$CM_${CM_CODE_UID}_INSTALL/lib" >> ${CM_CODE_ENV_FILE}
  fi
else
  echo "export CM_${CM_CODE_UID}_LIB=\$CM_${CM_CODE_UID}_INSTALL/lib" >> ${CM_CODE_ENV_FILE}
  echo "export CM_${CM_CODE_UID}_LIBS=\$CM_${CM_CODE_UID}_INSTALL/${CM_OS_LIB_DIR}" >> ${CM_CODE_ENV_FILE}
fi
echo "export CM_${CM_CODE_UID}_INCLUDE=\$CM_${CM_CODE_UID}_INSTALL/include" >> ${CM_CODE_ENV_FILE}
echo "" >> ${CM_CODE_ENV_FILE}
echo "export PATH=\$CM_${CM_CODE_UID}_BIN:\$PATH" >> ${CM_CODE_ENV_FILE}
echo "export LD_LIBRARY_PATH=\$CM_${CM_CODE_UID}_LIBS:\$LD_LIBRARY_PATH" >> ${CM_CODE_ENV_FILE}
echo "" >> ${CM_CODE_ENV_FILE}
echo "export PLUTO_CC=polycc" >> ${CM_CODE_ENV_FILE}
echo "export PLUTO_TUNE=plutune" >> ${CM_CODE_ENV_FILE}

chmod 755 ${CM_CODE_ENV_FILE}

# Cleaning directories if needed
echo ""
echo "Cleaning directories if needed ..."
echo ""

if [ "${CM_INSTALL_DELETE_SRC_DIR}" == "yes" ] ; then rm -rf ${CM_LOCAL_SRC_DIR}; fi
if [ "${CM_INSTALL_DELETE_OBJ_DIR}" == "yes" ] ; then rm -rf ${CM_INSTALL_OBJ_DIR}; fi

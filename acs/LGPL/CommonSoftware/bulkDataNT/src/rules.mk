#*******************************************************************************
# ALMA - Atacama Large Millimeter Array
# Copyright (c) Associated Universities Inc., 2020
# (in the framework of the ALMA collaboration).
# All rights reserved.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
#*******************************************************************************

#*******************************************************************************
# This Makefile follows ACS Standards (see Makefile(5) for more).
#*******************************************************************************
# REMARKS
#    None
#-------------------------------------------------------------------------------

# at this moment we use bulk data (NT) just in C++, and there is just C++ implementation
#MAKE_ONLY=C++,Python
MAKE_NOIFR_CHECK = on # it is DDS IDL, and we do not need to check it

################################################################################
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#  the code from here till  ... endif
#  will built just if NDDSHOME is defeined i.e. RTI DDS is isntalled !!!!!!!
################################################################################
ifdef NDDSHOME

ARCH:=$(shell uname -m)
GCC_VERSION:=$(if $(filter 0,$(shell gcc -dumpfullversion &> /dev/null; echo $$?)),$(shell gcc -dumpfullversion),$(shell gcc -dumpversion))
RTIDDS_GCC_AVAILABLE:=$(sort $(foreach ver,$(filter-out %jdk,$(wildcard $(NDDSHOME)/lib/x64Linux*gcc*)),$(lastword $(subst gcc, ,$(ver)))))
RTIDDS_GCC_VER:=$(lastword $(foreach rti,$(RTIDDS_GCC_AVAILABLE),$(if $(filter $(rti),$(word 1,$(sort $(GCC_VERSION) $(rti)))),$(rti),)))
$(if $(RTIDDS_GCC_VER),,$(error not supported gcc version for RTI DDS: $(GCC_VERSION)))

##################################################################
# Common paramters for both C++ and Java BulkData implementation.
##################################################################

# Root of include directory for C++ header files.
INC_ROOT=../include

# Directory where IDL files for BulkData are stored.
IDL_DIR=../idl

# IDL file that defines RTI DDS interface.
DDS_IDL=$(IDL_DIR)/bulkDataNT.idl

# IDL module name for DDS. This must match the root module name
# of $(DDS_IDL).
DDS_IDL_MODULE_NAME=ACSBulkData

##################################################################
# Parameters for Java implementation: packag ename, source
# directoreis, etc.
##################################################################

# Base Java package name.
JAVA_PKG_NAME=alma.acs.bulkdata

# Directry where Java source files reside.
JAVA_PKG_SRC_DIR=$(subst .,/,$(JAVA_PKG_NAME))

# Directory where "rtiddsgen" command generates Java source
# files from $(DDS_IDL).
JAVA_DDS_GEN_DIR=$(JAVA_PKG_SRC_DIR)/$(DDS_IDL_MODULE_NAME)

# List of Java source files generated by "rtiddsgen" command.
# This list must be updated when $(DDS_IDL) is edited.
JAVA_DDS_GEN_FILES=BD_DATA.java \
BD_PARAM.java \
BD_STOP.java \
BulkDataNTFrameDataReader.java \
BulkDataNTFrameDataWriter.java \
BulkDataNTFrame.java \
BulkDataNTFrameSeq.java \
BulkDataNTFrameTypeCode.java \
BulkDataNTFrameTypeSupport.java \
DataTypeTypeCode.java \
FRAME_MAX_LEN.java

JAVA_DDS_GEN_FILES_PATH=$(addprefix $(JAVA_DDS_GEN_DIR)/,$(JAVA_DDS_GEN_FILES))

# Output directory for Javadoc.
JAVADOC_DIR=../doc/api/html

##################################################################
# Parameters for C++ implementation.
##################################################################

# user definable C-compilation flags
USER_CFLAGS = -DRTI_UNIX -DRTI_LINUX -g -O0

# C++ source and header files generated by "rtiddsgen" command.
CPP_DDS_GEN_FILES_PATH=bulkDataNT.cpp bulkDataNTSupport.cpp bulkDataNTPlugin.cpp $(INC_ROOT)/bulkDataNT.h $(INC_ROOT)/bulkDataNTSupport.h $(INC_ROOT)/bulkDataNTPlugin.h

#
# additional include and library search paths
USER_INC = -I$(NDDSHOME)/include -I$(NDDSHOME)/include/ndds
ifeq ($(ARCH),x86_64)
	USER_LIB = -L$(NDDSHOME)/lib/x64Linux2.6gcc$(RTIDDS_GCC_VER)
else
	USER_LIB = -L$(NDDSHOME)/lib/i86Linux2.6gcc$(RTIDDS_GCC_VER)
endif

#
# MODULE CODE DESCRIPTION:
# ------------------------
# As a general rule:  public file are "cleaned" and "installed"  
#                     local (_L) are not "installed".

#
# C programs (public and local)
# -----------------------------
EXECUTABLES     =  bulkDataNTGenSender bulkDataNTGenReceiver bulkDataNTGenReceiverSender ddsPubTest ddsSubTest
EXECUTABLES_L   = 

bulkDataNTGenSender_OBJECTS = bulkDataNTGenSender
bulkDataNTGenSender_LIBS= bulkDataNTSender acsnc bulkDataStubs nddscpp nddsc nddscore

bulkDataNTGenReceiver_OBJECTS = bulkDataNTGenReceiver
bulkDataNTGenReceiver_LIBS= bulkDataNTReceiver nddscpp nddsc nddscore

bulkDataNTGenReceiverSender_OBJECTS = bulkDataNTGenReceiverSender bulkDataNTArrayThread bulkDataNTGenStreamerThread
bulkDataNTGenReceiverSender_LIBS= bulkDataNTSender bulkDataNTReceiver bulkDataNTThreadUtils bulkDataNTEx acsnc nddscpp nddsc nddscore

ddsPubTest_OBJECTS=ddsPublisher 
ddsPubTest_LIBS=nddscpp nddsc nddscore pthread ACSErrTypeCommon

ddsSubTest_OBJECTS=ddsSubscriber
ddsSubTest_LIBS=nddscpp nddsc nddscore pthread ACSErrTypeCommon

#
# Includes (.h) files (public only)
# ---------------------------------
INCLUDES        = bulkDataNTCallback.h bulkDataNTDDS.h bulkDataNTDDSPublisher.h bulkDataNTDDSSubscriber.h \
				bulkDataNT.h bulkDataNTPlugin.h bulkDataNTReaderListener.h bulkDataNTReceiverFlow.h \
				bulkDataNTReceiverImpl.h bulkDataNTReceiverImpl.i bulkDataNTReceiverStream.h bulkDataNTReceiverStream.i \
				bulkDataNTSenderFlow.h bulkDataNTSenderImpl.h bulkDataNTSenderStream.h bulkDataNTStream.h bulkDataNTSupport.h \
				bulkDataNTFlow.h bulkDataNTWriterListener.h bulkDataNTDDSLoggable.h bulkDataNTSenderFlowCallback.h \
				bulkDataNTConfiguration.h bulkDataNTConfigurationParser.h \
				bulkDataNTArrayThread.h bulkDataNTPosixHelper.h bulkDataNTThreadSyncGuard.h \
				bulkDataNTGenEx.h bulkDataNTProcessQueue.h


#
# Libraries (public and local)
# ----------------------------
LIBRARIES       = bulkDataNT bulkDataNTSender bulkDataNTReceiver bulkDataNTSenderImpl bulkDataNTThreadUtils bulkDataNTEx	
LIBRARIES_L     =

#
# <brief description of lllll library>
bulkDataNT_OBJECTS   = bulkDataNTDDS bulkDataNTStream bulkDataNTConfiguration bulkDataNTConfigurationParser \
						bulkDataNT bulkDataNTSupport bulkDataNTPlugin bulkDataNTDDSLoggable bulkDataNTLibMgmt
bulkDataNT_LIBS = ACSErrTypeCommon ACS_BD_Errors ACS_DDS_Errors xerces-c  nddscpp nddsc nddscore acsnc

bulkDataNTSender_OBJECTS    = bulkDataNTSenderStream bulkDataNTSenderFlow bulkDataNTDDSPublisher \
							  bulkDataNTWriterListener bulkDataNTSenderFlowCallback
bulkDataNTSender_LIBS = bulkDataNT bulkDataSenderStubs baci acsnc

bulkDataNTSenderImpl_OBJECTS = bulkDataNTSenderImpl
bulkDataNTSenderImpl_LIBS = bulkDataNTSender acsnc

bulkDataNTThreadUtils_OBJECTS = bulkDataNTPosixHelper bulkDataNTThreadSyncGuard
bulkDataNTThreadUtils_LIBS = pthread ACE logging acsThread acstime

bulkDataNTEx_OBJECTS = bulkDataNTGenEx
bulkDataNTEx_LD_FLAGS = 
bulkDataNTEx_LIBS = acsnc 

bulkDataNTReceiver_OBJECTS   = bulkDataNTReceiverFlow bulkDataNTDDSSubscriber \
							   bulkDataNTReaderListener bulkDataNTCallback bulkDataNTProcessQueue
bulkDataNTReceiver_LIBS = bulkDataNT RepeatGuard bulkDataStubs


#
# Scripts (public and local)
# ----------------------------
SCRIPTS         = bulkDataNTGenSenderJava bulkDataNTJavaEnv
SCRIPTS_L       =

#
# TCL scripts (public and local)
# ------------------------------
TCL_SCRIPTS     =
TCL_SCRIPTS_L   =

#
# Python stuff (public and local)
# ----------------------------
PY_SCRIPTS         = bulkDataNTremoteTest
PY_SCRIPTS_L       =

PY_MODULES         =
PY_MODULES_L       =

PY_PACKAGES        =
PY_PACKAGES_L      =
pppppp_MODULES	   =

#
# <brief description of tttttt tcl-script>
tttttt_OBJECTS  =
tttttt_TCLSH    = 
tttttt_LIBS     = 

#
# TCL libraries (public and local)
# ------------------------------
TCL_LIBRARIES   =
TCL_LIBRARIES_L =

#
# <brief description of tttlll library>
tttlll_OBJECTS  = 

endif #ifdef NDDSHOME
################################################################################
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#  the code from ifdef NDDSHOME till  here
#  .... will built just if NDDSHOME is defeined i.e. RTI DDS is isntalled !!!!!!!
################################################################################

#
# Configuration Database Files
# ----------------------------
CDB_SCHEMAS = BulkDataNTReceiver BulkDataNTSender acs_rti_dds_qos_profiles

# 
# IDL Files and flags
# 
IDL_FILES = bulkData bulkDataReceiver bulkDataSender bulkDataDistributer
TAO_IDLFLAGS =
USER_IDL =

bulkDataStubs_LIBS = TAO_AV

bulkDataReceiverStubs_LIBS = baciStubs ACSBulkDataError ACSBulkDataStatus bulkDataStubs

bulkDataSenderStubs_LIBS = baciStubs ACSBulkDataError bulkDataStubs bulkDataReceiverStubs

bulkDataDistributerStubs_LIBS = baciStubs ACSErrTypeCommon ACSBulkDataError bulkDataStubs bulkDataReceiverStubs bulkDataSenderStubs

#
# Jarfiles and their directories
#
JARFILES=jBulkData
jBulkData_DIRS=alma
jBulkData_EXTRAS=
jBulkData_EXTRA_SRCS=$(JAVA_DDS_GEN_FILES_PATH)
jBulkData_JFLAGS=-Xlint:unchecked

ACSERRDEF = ACS_BD_Errors ACS_DDS_Errors ACSBulkDataError ACSBulkDataStatus

#
# java sources in Jarfile on/off
DEBUG= 
#
# ACS XmlIdl generation on/off
#
XML_IDL= 
#
# Java Component Helper Classes generation on/off
#
COMPONENT_HELPERS=
#
# Java Entity Classes generation on/off
#
XSDBIND=
#
# Schema Config files for the above
#
XSDBIND_INCLUDE=
# man pages to be done
# --------------------
MANSECTIONS =
MAN1 =
MAN3 =
MAN5 =
MAN7 =
MAN8 =

#
# local man pages
# ---------------
MANl =

#
# ASCII file to be converted into Framemaker-MIF
# --------------------
ASCII_TO_MIF = 

#
# other files to be installed
#----------------------------
INSTALL_FILES =

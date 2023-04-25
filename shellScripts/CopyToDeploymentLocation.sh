#!/bin/bash

if [ $# -ne 2 ]
then
        echo "StageForContainer.sh called with incorrect number of arguments."
        echo "StageForContainer.sh <unitPaht> <StageBaseDir>"
        echo "For example; StageForContainer.sh /plm/pnnas/ppic/users/<unit_name> /plm/pnnas/ppic/users/<stage_dir>"
        exit 1
fi

UNIT_PATH=$1
STAGE_BASE_DIR=$2

INIT_DEF_FILE=${UNIT_PATH}/init.def
stringarray=(`grep DMS_PARENT_BASELINE ${INIT_DEF_FILE} || { exit 1;}`)
RELEASE_IP=${stringarray[1]}
orig=${RELEASE_IP}
IFS=. read -r nxVersion IP <<< ${RELEASE_IP}

#copy the staging folder to common location
FolderName=${orig//'.'/'_TranslatorWorker.'}
commonLocation=//plm/pnnas/ppic/Data_Exchange/SaaS_distributions/NXJT/${FolderName}/
if [ ! -d ${commonLocation} ]
then
	echo "Creating common location directory ${commonLocation}"
	mkdir -p ${commonLocation} || { exit 1;}
	chmod -R 0777 ${commonLocation} || { exit 1;}
	mkdir -p ${commonLocation}/lnx64 || { exit 1;}
fi
cp -r ${STAGE_BASE_DIR}/* ${commonLocation}/lnx64/
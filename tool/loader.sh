#!/bin/bash

set -eu
set -o pipefail

trap 'echo "error:$0($LINENO) \"$BASH_COMMAND\" \"$@\""' ERR


SCRIPT_DIR=$(cd $(dirname $0); pwd)
ROOT_DIR=${SCRIPT_DIR}/..
ASSETS_DIR=${ROOT_DIR}/app/src/main/assets
LINA_DICTO_ASSETS_DIR=${ASSETS_DIR}/lina_dicto

LOADER_PATH=$1
TMP_LOADER_PATH=${LOADER_PATH}.tmp

echo "file:${TMP_LOADER_PATH}"
rm -f ${TMP_LOADER_PATH}

regexp="^(.+) = read_textfile\('(.+)'\);$"
while read line; do
	if [[ "$line" =~ $regexp ]] ; then
		# echo "M :$line"
		VALNAME=${BASH_REMATCH[1]}
		FPATH=${BASH_REMATCH[2]}
		FPATH="${LINA_DICTO_ASSETS_DIR}/${FPATH}"
		# ** browserifyで連結する際に"`"があると壊れるので対処
		sed -i 's/`/\\\`/g' ${FPATH}
		# 読み込み時に'"'のエスケープが効かないので対処
		sed -i 's/\\\"/”/g' ${FPATH}
		#sed -i 's/\`/\\\`/g' ${FPATH} # for macosx
		CONTENT=$(cat ${FPATH})
		echo "${VALNAME} = \`${CONTENT}\`;" >> ${TMP_LOADER_PATH}
	else
		# echo "UN:$line"
		echo "$line" >> ${TMP_LOADER_PATH}
	fi
done < ${LOADER_PATH}

mv ${TMP_LOADER_PATH} ${LOADER_PATH}


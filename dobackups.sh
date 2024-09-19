#!/usr/bin/env sh

set -e

source /.env

# default storage class to standard if not provided
S3_STORAGE_CLASS=${S3_STORAGE_CLASS:-STANDARD}

# Check if TARGET variable is set
if [ -z "${TARGET}" ]; then
    echo "TARGET env var is not set so we use the default value (/data)"
    TARGET=/data
else
    echo "TARGET env var is set"
fi

if [ -z "${S3_ENDPOINT}" ]; then
  AWS_ARGS=""
else
  AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
fi

for dir in ${TARGET}/*/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"

    # generate file name for tar
    FILE_NAME="${dir##*/}"                  # remove everything before the last /
    FILE_NAME=${FILE_NAME:-/}     
    FILE_NAME=${FILE_NAME}-$(date "+%Y-%m-%d_%H-%M-%S").tar.gz
    FULL_FILE_NAME=${TARGET}/${FILE_NAME}

    echo "Creating archive ${FILE_NAME}"
    tar -zcvf "${FULL_FILE_NAME}" -C "${dir}" .
    echo "Uploading archive to S3 [${FILE_NAME}, storage class - ${S3_STORAGE_CLASS}]"
    echo "s3cmd put "${FULL_FILE_NAME}" "s3://${S3_BUCKET}/${FILE_NAME}""
    s3cmd put "${FULL_FILE_NAME}" "s3://${S3_BUCKET}/${FILE_NAME}"
    echo "Removing local archive"
    rm "${FULL_FILE_NAME}"
    echo "done"

done
#!/usr/bin/env sh

set -e

cat << EOF > /.env
export TARGET=${TARGET}
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_REGION=${AWS_REGION}
export S3_BUCKET_URL=${S3_BUCKET_URL}
export S3_ENDPOINT=${S3_ENDPOINT}
EOF

echo "configuring s3cmd"

echo "[default]" >> ~/.s3cfg
echo "access_key = ${AWS_ACCESS_KEY_ID}" >> ~/.s3cfg
echo "secret_key = ${AWS_SECRET_ACCESS_KEY}" >> ~/.s3cfg
echo "bucket_location = ${AWS_REGION}" >> ~/.s3cfg
echo "host_base = ${S3_ENDPOINT}" >> ~/.s3cfg
echo "host_bucket = ${S3_ENDPOINT}" >> ~/.s3cfg
echo "enable_multipart = False" >> ~/.s3cfg

echo "creating crontab"

# Configure cron
mkdir /etc/cron
echo "${CRON_SCHEDULE} /dobackups.sh" > /etc/cron/crontab
echo "# empty line" >> /etc/cron/crontab

# Init cron
crontab /etc/cron/crontab

echo "starting $@"
exec "$@"
# Docker Backup Volumes to S3

## What is it?
A container that creates a *.tar.gz archive per each folder in the specified directory and then upload them to an S3-compatible storage.

## How do I use it?
The container is configured via a set of required environment variables:
- AWS_REGION=Region of the bucket
- AWS_ACCESS_KEY_ID= Access Key Id
- AWS_SECRET_ACCESS_KEY= Access Secret
- S3_ENDPOINT=S3 endpoint
- S3_BUCKET=S3 bucket name
- AWS_REGION=S3 region
- CRON_SCHEDULE=* * * * * # run every hour
- TARGET= Folder to which volumes are attacched

### Directly via Docker
```
docker run \
  -e AWS_REGION=<your-aws-region> \
  -e AWS_ACCESS_KEY_ID=<your-access-key-id> \
  -e AWS_SECRET_ACCESS_KEY=<your-access-secret> \
  -e S3_ENDPOINT=<your-s3-endpoint> \
  -e S3_BUCKET=<your-bucket-name> \
  -e CRON_SCHEDULE="* * * * *"  \
  -e TARGET=/data \
  -v volume1:/data/volume1:ro \
  -v volume2:/data/volume1:ro \
  -v volume3:/data/volume1:ro \
  nicoladonati/docker-backup-to-s3
```

### Docker-compose
```
# docker-compose.yml
version: '3.8'

services:
  my-backup-unit:
    image: nicoladonati/docker-backup-to-s3
    environment:
      - AWS_REGION=auto
      - AWS_ACCESS_KEY_ID=a1ee47c9e72b343ce829811951be0659
      - AWS_SECRET_ACCESS_KEY=ec216c8a88e90407bea33c63a215173743ac3f6a9727386c93bdcca9ee250463
      - S3_ENDPOINT=b74f477d938dc2a88ffb316c20529a42.eu.r2.cloudflarestorage.com
      - S3_BUCKET=backups
      - AWS_REGION=us-east-1
      - CRON_SCHEDULE=* * * * * # run every hour
      - TARGET=/data
    volumes:
      - volume1:/data/volume1:ro
      - volume2:/data/volume1:ro
      - volume3:/data/volume1:ro
    restart: always
```
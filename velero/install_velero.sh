#!/bin/bash
kubectl create ns velero

GSA_NAME=velero
BUCKET=velero-nurlan
PROJECT_ID=nurlanpremiumproject

velero install \
    --provider gcp \
    --plugins velero/velero-plugin-for-gcp:v1.0.1 \
    --no-secret \
    --sa-annotations iam.gke.io/gcp-service-account=${GSA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
    --backup-location-config serviceAccount=${GSA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
    --bucket ${BUCKET}

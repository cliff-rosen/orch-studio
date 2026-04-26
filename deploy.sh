#!/bin/bash
set -e

# Zone convention (source of truth: this script):
#   articles/   production zone — deployed, linked from Insights tab in index.html
#   staging/    staging zone    — deployed, NOT linked in nav (reachable only by URL)
#   working/    working zone    — NOT deployed, drafts and exploration only
# Anything not explicitly listed below does not deploy.

BUCKET="s3://orchestratorstudios.com"
DIST_ID="E3IQ5B4FKKJX25"

echo "Deploying to $BUCKET..."

# Upload HTML files
aws s3 cp index.html "$BUCKET/index.html" --content-type "text/html"
aws s3 sync articles/ "$BUCKET/articles/" --content-type "text/html" --exclude "botbeam-reach-continuum.html"
aws s3 sync staging/ "$BUCKET/staging/" --content-type "text/html"

# Upload assets
aws s3 cp favicon.svg "$BUCKET/favicon.svg" --content-type "image/svg+xml"

echo "Invalidating CloudFront cache..."
aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "/*" --query "Invalidation.Id" --output text

echo "Done. Changes will be live in ~1-2 minutes."

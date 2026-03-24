#!/bin/bash
set -e

BUCKET="s3://orchestratorstudios.com"
DIST_ID="E3IQ5B4FKKJX25"

echo "Deploying to $BUCKET..."

# Upload HTML files
aws s3 cp index.html "$BUCKET/index.html" --content-type "text/html"
aws s3 sync articles/ "$BUCKET/articles/" --content-type "text/html" --exclude "botbeam-reach-continuum.html"

# Upload assets
aws s3 cp favicon.svg "$BUCKET/favicon.svg" --content-type "image/svg+xml"

echo "Invalidating CloudFront cache..."
aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "/*" --query "Invalidation.Id" --output text

echo "Done. Changes will be live in ~1-2 minutes."

#!/bin/bash 

RELEASE_DATE=$(date +%Y%m%d%H%M%S)

rsync -av --delete ./dist/ sol@10.70.0.46:/app/sol-cooperative-frontend/production/releases/$RELEASE_DATE

ssh sol@10.70.0.46 "cd /app/sol-cooperative-frontend/production && unlink current && ln -s releases/$RELEASE_DATE/ current"
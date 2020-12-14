#!/usr/bin/env bash
DATE=$(date +%Y%m%d%H%M%S)
echo -e "\n$DATE \"$1\" \n">> README.md
git add .
git commit -m "$DATE $1"
git push origin main
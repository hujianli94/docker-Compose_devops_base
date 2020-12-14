#!/bin/sh
#
# Expose Gitee enterprise snapshot execute status metrics.
#
# Usage: add this to crontab:
#
# 0 0 * * 7 git /bin/bash /opt/promExporters/node_exporter/textfile_collector_scripts/enterprise_snapshot_status.sh > /opt/promExporters/node_exporter/textfiles/enterprise_snapshot_status.prom
#
# Author: atompi <atomissionpi@gmail.com>
echo "# HELP enterprise_snapshot_status Gitee enterprise snapshot status"
echo "# TYPE enterprise_snapshot_status gauge"

backup_date=$(date '+%Y-%m-%d' -d "-2 days")
backup_process_count=$(ps -ef | grep /home/git/enterprise-backup/backup.sh | grep -v grep | wc -l)
backup_success_count=$(cat /home/git/enterprise-backup/backstatus$backup_date.log | grep "backup success path_with_namespace is" | wc -l)
ebaklist_modified_date=$(date -r /home/git/ebaklist.txt '+%Y-%m-%d')

if [[ $backup_date == $ebaklist_modified_date && 1 == $backup_process_count && $backup_success_count -gt 1 ]]; then
    echo 1
else
    echo 0
fi

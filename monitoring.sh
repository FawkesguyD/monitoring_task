#!/bin/bash
set -e

# Script: the script checks the monitoring server for availability and also looks at the test process, if the process has been restarted it is written to a log file

#Log file
log_file="/var/log/monitoring.log"
#Process
process_name="test"
#Monitoring server
url="https://test.com/monitoring/test/api"
#Time watch file 
tmp="/tmp/monitoring"

#Log date formatter
log() {
    echo "[$(date +'%c')]: $@" >> "${log_file}"
}

#Create file if it doesn't exist
if [[ ! -f "${tmp}" ]]; then
    touch "${tmp}"
fi

pid=$(pgrep -x "${process_name}" | head -n 1)

if [[ -n "${pid}" ]]; then
    current_time=$(
        ps -eo pid,lstart \
        | awk -v pid="${pid}" '$1 == pid {print}'
    )
    tmp_time=$(cat "${tmp}")

    #Check for restarted process
    if [[ -z "${tmp_time}" ]]; then
        echo "${current_time}" > "${tmp}"

    elif [[ "${current_time}" != "${tmp_time}" ]]; then
        echo "${current_time}" > "${tmp}"
        log "the process ${process_name}(PID:${pid}) was restared"
    fi

    #Check for access server
    responce=$(curl -Is --fail --max-time 10 "${url}" | head -n 1 | awk '{print $2}')

    if [[ ${responce} != 200 ]]; then
        log "monitoring server (${url}) is unavailable. Responce: ${responce}"
    fi
fi

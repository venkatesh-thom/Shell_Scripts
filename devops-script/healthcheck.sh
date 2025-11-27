#!/bin/bash
# ==========================================
# 🌐 EC2 Multi-Server Health Check Script
# ==========================================

servers=("107.21.157.14" "3.85.205.198")
key="/Users/vthomma/Desktop/test.pem"
user="ec2-user"

# 🎨 Colors for Output
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
PURPLE="\033[0;35m"
NC="\033[0m"

# 📂 Logs
mkdir -p ./health-reports
LOG_FILE="./health-reports/report-$(date +%F-%H%M).log"

health_check() {
    local host=$1
    echo -e "\n🔎 Checking $host ..." | tee -a "$LOG_FILE"

    ssh -i "$key" -o ConnectTimeout=5 -o StrictHostKeyChecking=no $user@$host "
        echo -e '${PURPLE}📂 Disk Usage:${NC}'
        df -h /
        echo -e '${PURPLE}🧠 Memory Usage:${NC}'
        free -h 
        echo -e '${PURPLE}⚡ CPU & Uptime:${NC}'
        uptime
        echo -e '${PURPLE}🔥 Top 3 Processes:${NC}'
        ps -eo pid,cmd,%cpu,%mem --sort=-%cpu | head -4
    " 2>&1 | tee -a "$LOG_FILE"

    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo -e "${GREEN}✅ $host is healthy${NC}" | tee -a "$LOG_FILE"
        return 0
    else
        echo -e "${RED}❌ $host is unreachable${NC}" | tee -a "$LOG_FILE"
        return 1
    fi
}

# 🔁 Run checks
up=0; down=0
for h in "${servers[@]}"
do
    if health_check "$h"; then 
        ((up++))
    else 
       ((down++))
    fi
done

# 📊 Final Summary
echo -e "\n📊 ${YELLOW}Summary:${NC}" | tee -a "$LOG_FILE"
echo -e "✅ UP: $up" | tee -a "$LOG_FILE"
echo -e "❌ DOWN: $down" | tee -a "$LOG_FILE"
echo -e "📝 Log saved: $LOG_FILE\n"
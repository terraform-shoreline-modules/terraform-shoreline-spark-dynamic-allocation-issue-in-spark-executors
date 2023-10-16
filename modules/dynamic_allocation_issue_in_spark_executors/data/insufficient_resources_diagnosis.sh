

#!/bin/bash



# This script will diagnose insufficient resources such as memory and CPU on the Spark cluster causing the dynamic allocation to fail.



# Check if there is enough memory available on the cluster

free_mem=$(free -m | awk 'NR==2{print $7}')

if [ $free_mem -lt ${MINIMUM_MEMORY_THRESHOLD} ]; then

    echo "Insufficient memory available on the cluster"

fi



# Check if there is enough CPU available on the cluster

cpu_usage=$(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}')

cpu_cores=$(nproc)

cpu_available=$(echo "$cpu_cores-$cpu_usage" | bc)

if [ $cpu_available -lt ${MINIMUM_CPU_THRESHOLD} ]; then

    echo "Insufficient CPU available on the cluster"

fi
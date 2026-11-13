#!/bin/bash

lshw_cmd=$(lshw)

echo "========== Machine Information =========="
machine_desc=$(echo "$lshw_cmd" | head | grep desc | awk -F ": " '{print $2}')
machine_vendor=$(echo "$lshw_cmd" | head | grep vendor | awk -F ": " '{print $2}')
machine_product=$(echo "$lshw_cmd" | head | grep product | awk -F ": " '{print $2}')
echo "$machine_vendor $machine_product ($machine_desc)"

echo ""
echo "========== Linux CPU Information =========="
cpu_cmd=$(cat /proc/cpuinfo)
cpu_name=$(echo "$cpu_cmd" | grep 'model name' | head -n 1 | awk -F ": " '{print $2}' | sed -r s/^[[:blank:]]*//)
cpu_cpus=$(echo "$cpu_cmd" | grep 'physical id' | uniq -c | wc -l)
cpu_cores=$(echo "$cpu_cmd" | grep 'cpu cores' | cut -f 2 -d ":" | uniq | sed -r s/^[[:blank:]]*// | sed -r s/[[:blank:]]*$//)
cpu_cpus=$(echo "$cpu_cmd" | grep 'physical id' | uniq -c | wc -l)
cpu_processor=$(echo "$cpu_cmd" | grep "processor"| wc -l)
cpu_arch_flag=$(echo "$cpu_cmd" | grep " lm "| wc -l)
if [ $cpu_arch_flag > 0 ]; then
	cpu_arch="64 Bit"
else
	cpu_arch="32 Bit"
fi
echo -e "$cpu_name ($cpu_arch)\n$cpu_cpus CPU(s) $cpu_cores Core(s) $cpu_processor Processor(s)"

echo ""
echo "========== Linux Memory Information =========="
mem_cmd=$(cat /proc/meminfo)
mem_total=$(echo "$mem_cmd" | grep 'MemTotal' | awk -F ": " '{print $2}' | sed -r s/^[[:blank:]]// | awk -F " " '{print $1}')
mem_total_str=$(echo "scale=2;$mem_total/1024" | bc)
mem_avai=$(echo "$mem_cmd" | grep 'MemAvailable' | awk -F ": " '{print $2}' | sed -r s/^[[:blank:]]// | awk -F " " '{print $1}')
mem_avai_str=$(echo "scale=2;$mem_avai/1024" | bc)
mem_free=$(echo "$mem_cmd" | grep 'MemFree' | awk -F ": " '{print $2}' | sed -r s/^[[:blank:]]// | awk -F " " '{print $1}')
mem_free_str=$(echo "scale=2;$mem_free/1024" | bc)
mem_buffers=$(echo "$mem_cmd" | grep 'Buffers' | awk -F ": " '{print $2}' | sed -r s/^[[:blank:]]// | awk -F " " '{print $1}')
mem_buffers_str=$(echo "scale=2;$mem_buffers/1024" | bc)
mem_cache=$(echo "$mem_cmd" | grep '^Cached' | awk -F ": " '{print $2}' | sed -r s/^[[:blank:]]// | awk -F " " '{print $1}')
mem_cache_str=$(echo "scale=2;$mem_cache/1024" | bc)
mem_slab=$(echo "$mem_cmd" | grep 'Slab' | awk -F ": " '{print $2}' | sed -r s/^[[:blank:]]// | awk -F " " '{print $1}')
mem_slab_str=$(echo "scale=2;$mem_slab/1024" | bc)
mem_used_str=$(echo "scale=2;$mem_total_str-$mem_free_str-$mem_buffers_str-$mem_cache_str-$mem_slab_str" | bc)
echo "Total: $mem_total_str MB    Used: $mem_used_str MB    Available: $mem_avai_str MB"

echo ""
echo "========== Linux Kernel Information =========="
uname -rm

echo ""
echo "========== Disk Information =========="
df -h

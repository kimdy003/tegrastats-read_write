#!/bin/bash

#Change the Mode of Xavier
sudo echo "***** nvpmodel *****"
sudo nvpmodel -m 0
sudo nvpmodel -q
sudo echo

#Turn on All Cores
sudo echo "***** Turn on all cores *****"
sudo echo "- Previous list of online cores"
sudo cat /sys/devices/system/cpu/online
sudo echo

sudo echo 1 > /sys/devices/system/cpu/cpu1/online
sudo echo 1 > /sys/devices/system/cpu/cpu2/online
sudo echo 1 > /sys/devices/system/cpu/cpu3/online
sudo echo 1 > /sys/devices/system/cpu/cpu4/online
sudo echo 1 > /sys/devices/system/cpu/cpu5/online
sudo echo 1 > /sys/devices/system/cpu/cpu6/online
sudo echo 1 > /sys/devices/system/cpu/cpu7/online

sudo echo "- Changed list of online cores"
sudo cat /sys/devices/system/cpu/online
sudo echo

# Set CPU frequency to maximum
sudo echo "***** Set CPU frequency to maximum *****"
sudo echo "- Previous frequency of cores"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq
sudo echo "- Previous CPU governor of cores"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
sudo echo

sudo echo "- The list of available frequencies"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_frequencies

sudo echo userspace > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
sudo echo 2265600 > /sys/devices/system/cpu/cpufreq/policy0/scaling_setspeed

sudo echo 2265600 > /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq
sudo echo 2265600 > /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq

sudo echo
sudo echo "- Changed frequency of cores"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq
sudo echo "- Changed CPU governor of cores"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor

# Set GPU frequency to maximum
sudo echo "***** Set GPU frequency to maximum *****"
sudo echo "- Previous frequency of GPU"
sudo cat /sys/devices/17000000.gv11b/devfreq/17000000.gv11b/cur_freq
sudo echo

sudo echo "- The list of available frequencies"
sudo cat /sys/devices/17000000.gv11b/devfreq/17000000.gv11b/available_frequencies

sudo echo 1377000000 > /sys/devices/17000000.gv11b/devfreq/17000000.gv11b/max_freq
sudo echo 1377000000 > /sys/devices/17000000.gv11b/devfreq/17000000.gv11b/min_freq
sudo echo
sudo echo "- Changed frequency of GPU"
sudo cat /sys/devices/17000000.gv11b/devfreq/17000000.gv11b/cur_freq

# Set EMC frequency to maximum
sudo echo "***** Set EMC frequency to maximum *****"
sudo echo "- Previous frequency of EMC"
sudo cat /sys/kernel/debug/bpmp/debug/clk/emc/rate

sudo echo
sudo echo 1 > /sys/kernel/debug/bpmp/debug/clk/emc/mrq_rate_locked
sudo echo 1 > /sys/kernel/debug/bpmp/debug/clk/emc/state
sudo cat /sys/kernel/debug/bpmp/debug/clk/emc/max_rate
sudo echo 2133000000 > /sys/kernel/debug/bpmp/debug/clk/emc/rate
sudo echo "- Changed frequency of EMC"
sudo cat /sys/kernel/debug/bpmp/debug/clk/emc/rate

echo ""
echo "sudo -i"
echo "echo -1 > /proc/sys/kernel/perf_event_paranoid"

#!/bin/sh
# Created by yrmt.
e="echo"    
c0="\033[0m"    # Reset
c1="\033[1;31m" # RED

OS=$(sw_vers|awk -F"\:\t" '{printf "%s ",$2}')
CPU=$(sysctl -n machdep.cpu.brand_string) 
RAM=$(sysctl -n hw.memsize|awk '{printf("%d", $1/1e+06)}')
MOD=$(sysctl -n hw.model) 
VCARD=$(system_profiler SPDisplaysDataType|awk -F"\:\ " '/Chipset|VRAM/{printf "%s ",$2}')
DISK_USAGE=$(df | awk '/disk0s2/{print$5}')
PORTS=$(pkg_info|awk 'END {gsub(/\ /, "");print NR}')

$e "${c1}OS:     ${c0}$OS"
$e "${c1}Kernel: ${c0}`uname -rms`"
$e "${c1}Packs:  ${c0}$PORTS"
$e "${c1}Shell:  ${c0}`echo $SHELL`"
$e "${c1}Theme:  ${c0}`whoami`"
$e "${c1}Ram:    ${c0}$RAM MB"
$e "${c1}Cpu:    ${c0}$CPU"
$e "${c1}VRam:   ${c0}$VCARD"
$e "${c1}Model:  ${c0}$MOD"
$e "${c1}Disk:   ${c0}$DISK_USAGE"
$e "${c1}Term:   ${c0}`echo $TERM`"

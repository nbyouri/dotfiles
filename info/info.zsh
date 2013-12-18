#!/bin/zsh
# Color and echo
# created my yrmt.
           
c0="\033[0m"    # Reset
c1="\033[0;32m" # Green
c2="\033[0;33m" # Yellow
c3="\033[1;31m" # RED
c4="\033[0;31m" # Red
c5="\033[0;35m" # Purple
c6="\033[0;36m" # Blue

# OS information
OS=$(sw_vers|awk -F"\:\t" '{printf "%s ",$2}')
RAM=$(sysctl -n hw.memsize|awk '{printf("%d", $1/1e+06)}')
CPU=$(sysctl -n machdep.cpu.brand_string) 
MODEL=$(sysctl -n hw.model) 
DISK_USAGE=$(df | awk '/disk0s2/{print$5}')
PACKAGES=$(pkg_info|awk 'END {gsub(/\ /, "");print NR}')
UPTIME=$(uptime|awk -F"\,\ " '{print $1}')
# Printing the apple

echo -e "${c1}                :++++.         "   "${c3}`users`${c5}@${c3}`hostname`"
echo -e "${c1}               /+++/.          "   "${c3}OS: ${c0}$OS"
echo -e "${c1}       .:-::- .+/:-\`\`.::-    "   "  ${c3}Kernel: ${c0}`uname -mrs`"
echo -e "${c1}    .:/++++++/::::/++++++/:\`  "   " ${c3}Uptime: ${c0}$UPTIME" 
echo -e "${c2}  .:///////////////////////:\` "   " ${c3}Packages: ${c0}$PACKAGES"
echo -e "${c2}  ////////////////////////\`   "   " ${c3}Shell: ${c0}`echo SHELL`"
echo -e "${c3} -+++++++++++++++++++++++\`    "   " ${c3}Ram: ${c0}$RAM"
echo -e "${c3} /++++++++++++++++++++++/      "   "${c3}Cpu: ${c0}$CPU"
echo -e "${c4} /sssssssssssssssssssssss.     "   "${c3}Model: ${c0}$MODEL"
echo -e "${c4} :ssssssssssssssssssssssss-    "   "${c3}Disk Usage: ${c0}$DISK_USAGE"
echo -e "${c5}  osssssssssssssssssssssssso/\\"   " ${c3}Term: ${c0}`echo $TERM`"
echo -e "${c5}  \`syyyyyyyyyyyyyyyyyyyyyyyy+\\"   
echo -e "${c6}   \`ossssssssssssssssssssss/   "  
echo -e "${c6}     :ooooooooooooooooooo+.    "   
echo -e "${c6}      \`:+oo+/:-..-:/+o+/-   "     

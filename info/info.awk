#!/usr/bin/awk -f
# Created by yrmt.

function os() {
    FS="\:\t"
    while("sw_vers"|getline) {
        printf("%s ", $2);
    }
    printf("\n");
}
function cpu() {
    while("sysctl -n machdep.cpu.brand_string"|getline) {
        print;
    }
}
function ram() {
    while("sysctl -n hw.memsize"|getline) {
        printf("%d MB\n",$1/1e+06);
    }
}
function model() {
    while("sysctl -n hw.model"|getline) {
        print;
    }
}
function disk() {
    FS="\ "
    while("df -h"|getline) {
        if(/disk0s2/) {
            print $5;
        }
    }
}
function gpu() {
    FS="\:\ "
    while("system_profiler SPDisplaysDataType"|getline) {
        if(/Chipset/) {
            chipset=$2;
        }
        if(/VRAM/) {
            vram=$2;
        }
    }
    print chipset " @ "  vram
}
function pkg() {
    while("pkgin ls|wc -l"|getline) {
        gsub(/\ /, "");
        print;
    }
}
function shell() {
    print ENVIRON["SHELL"];
}
function term() {
    print ENVIRON["TERM"];
}
function kernel() {
    while("uname -rms"|getline) {
        print;
    }
}
function uptime() {
    FS=","
    while("uptime"|getline) {
        print $1;
    }
}
function main() {
    n="\033[0m"         # Reset
    r="\033[1;31m"      # RED
    printf(r"OS:        "n);os();
    printf(r"Kernel:    "n);kernel();
    printf(r"Model:     "n);model();
    printf(r"Processor: "n);cpu();
    printf(r"Graphics:  "n);gpu();
    printf(r"Disk:      "n);disk();
    printf(r"Ram:       "n);ram();
    printf(r"Packages:  "n);pkg();
    printf(r"Shell:     "n);shell();
    printf(r"Terminal:  "n);term();
    printf(r"Uptime:    "n);uptime();
}
BEGIN {
    main();
}


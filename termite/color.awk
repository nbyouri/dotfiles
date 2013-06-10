#!/usr/bin/awk -f

BEGIN {
    cmd = "cat ~/.Xdefaults"
    print "[colors]"
    while(cmd|getline) {
        if(/\*color/&&!/^!/) {
            gsub(/\*color/, "color", $1);
            gsub(/\:/, " =", $1);
            print
        }
        if(/^\*foreground|^\*background/) {
            gsub(/\*/, "", $1);
            gsub(/\:/, " =", $1);
            print
        }
    }
}

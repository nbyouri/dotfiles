#!/usr/bin/awk -f
# This is a Xdefaults 
# color to termite converter.
# ./color.awk >> .termite.conf

BEGIN {
    print "[colors]"
    while(getline < (ENVIRON["HOME"] "/.Xdefaults")) {
        if(/\*color/&&!/^!/) {
            gsub(/\*color/, "color", $1);
            gsub(/\:/, " =", $1);
            print
        }
        if(/^\*[fore|back]ground/) {
            gsub(/\*/, "", $1);
            gsub(/\:/, " =", $1);
            print
        }
    }
}

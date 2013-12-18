#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/sysctl.h>
#include <sys/statvfs.h>
#include <sqlite3.h>

#define NOR  "\x1B[0m"
#define RED  "\x1B[31m"

static const struct {
    const char *ctls;
    const char *names;
} values[] = {
    { "hw.model", "Model" },
    { "machdep.cpu.brand_string", "Processor" },
    { "hw.memsize", "Memory" },
    { "kern.ostype", "OS" },
    { "kern.osrelease", "Kernel" },
    { "kern.hostname", "Hostname" },
    { "SHELL", "Shell" },
    { "TERM", "Terminal" },
    { "system_profiler SPDisplaysDataType", "Graphics" },
};
void sysctls(void) {
    size_t len;
    uint64_t value64;
    for(int i=0;i<6;i++) {
        if(i == 2) {
            sysctlbyname(values[i].ctls, &value64, &len, NULL, 0);
            printf(RED"%-10s: "NOR"%.f MB\n", values[i].names, value64/1e+06);
        } else {
            sysctlbyname(values[i].ctls, NULL, &len, NULL, 0);
            char *type = malloc(len);
            sysctlbyname(values[i].ctls, type, &len, NULL, 0);
            printf(RED"%-10s: "NOR"%s\n", values[i].names, type);
            free(type);
        }
    }
}
void envs(void) {
    char *type;
    char *dummy;
    for(int i=6;i<8;i++) {
        type = getenv(values[i].ctls);
        printf(RED"%-10s: "NOR"%s\n", values[i].names, type);
    }
}
void pkg(void) {
    sqlite3 *db;
    int pkgs;
    sqlite3_stmt *s;
    char *sql = "SELECT COUNT (*) FROM LOCAL_PKG";

    if (sqlite3_open("/var/db/pkgin/pkgin.db", &db) != SQLITE_OK) {
        fprintf(stderr, "cannot open db");
    }

    if (sqlite3_prepare_v2(db, sql, -1, &s, NULL) == SQLITE_OK) {
        if (sqlite3_step(s) == SQLITE_ERROR) {
            fprintf(stderr, "error querying db");
        }

        pkgs = sqlite3_column_int(s,0);
    }
    printf(RED"Packages  :"NOR" %d\n", pkgs);
}
void gpu(void) {
    FILE *fp;
    char path[256];
    fp = popen(values[9].ctls, "r");
    if(!fp) {
        printf("failed to get gpu info");
    } else while(fgets(path,sizeof(path), fp)) {
        if(strstr(path,"Chipset")) {
            char *type = path + 21;
            type[strlen(type)-1] = '\0';
            printf(RED"%-10s:"NOR" %s @ ", values[9].names, type);
        } else if(strstr(path, "VRAM")) {
            char *type = path + 20;
            printf("%s", type);
        }
    }
    pclose(fp);
}
void disk(void) {
    struct statvfs info;
    if (-1 == statvfs("/", &info))
        printf("failed to get disk info");
    else {
        unsigned long left  = (info.f_bavail * info.f_frsize);
        unsigned long total = (info.f_files * info.f_frsize);
        unsigned long used  = total - left;
        float perc  = (float)used / (float)total;
        printf(RED"Disk usage:"NOR" %.2f%%\n", perc * 100);
    }
}
static void print_uptime(time_t *nowp)
{
    struct timeval boottime;
    time_t uptime;
    int days, hrs, mins, secs;
    int mib[2];
    size_t size;
    char buf[256];

    if (strftime(buf, sizeof(buf), NULL, localtime(nowp)) != 0)
        mib[0] = CTL_KERN;
    mib[1] = KERN_BOOTTIME;
    size = sizeof(boottime);
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && 
            boottime.tv_sec != 0) {
        uptime = *nowp - boottime.tv_sec;
        if (uptime > 60)
            uptime += 30;
        days = uptime / 86400;
        uptime %= 86400;
        hrs = uptime / 3600;
        uptime %= 3600;
        mins = uptime / 60;
        secs = uptime % 60;
        printf(RED"Uptime    :"NOR);
        if (days > 0)
            (void)printf("%d day%s", days, days > 1 ? "s" : "");
        if (hrs > 0 && mins > 0)
            (void)printf("%2d:%02d", hrs, mins);
        else if (hrs > 0)
            (void)printf("%d hr%s", hrs, hrs > 1 ? "s" : "");
        else if (mins > 0)
            (void)printf("%d min%s", mins, mins > 1 ? "s" : "");
        else
            (void)printf("%d sec%s", secs, secs > 1 ? "s" : "");
        printf("\n");
    }
}
int main(void) {
    time_t now;
    (void)time(&now);
    sysctls();
    envs();
    disk();
    pkg();
    print_uptime(&now);
    //gpu();
}

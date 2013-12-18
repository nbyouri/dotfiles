#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/sysctl.h>
#include <sys/statvfs.h>

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
    { "pkgin ls", "Packages" },
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
    FILE *fp;
    static const int BUF = 256;
    char path[BUF];
    int count = 0;
    fp = popen(values[8].ctls, "r");
    if(!fp) {
        printf("failed to get package list");
    } else while(fgets(path, BUF,fp)) {
        count++;
    }
    printf(RED"%-10s:"NOR" %d\n", values[8].names, count);
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
    printf(RED"Total     :"NOR" %.2f GB\n", ((info.f_bavail * info.f_frsize) / 1024e+06));
  }
}
int main(void) {
    sysctls();
    envs();
    disk();
    pkg();
    gpu();
}

#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <mach/mach_host.h>
#include <unistd.h>

static void cpu_percent(uint64_t ticks, uint64_t totalticks,
                        uint64_t *whole, uint64_t *part) {
    *whole = UINT64_C(100) * ticks / totalticks;
    *part = (((UINT64_C(100) * ticks) - (*whole * totalticks)) * UINT64_C(100))
	/ totalticks;
}

int main(int argc, char *argv[])
{
    host_t Host = mach_host_self();
    host_cpu_load_info_data_t CPULoad, CPULoadLater;
    
    host_statistics(Host, HOST_CPU_LOAD_INFO, (host_info_t)&CPULoad, &(mach_msg_type_number_t){ HOST_CPU_LOAD_INFO_COUNT });
    
    sleep(1);
    
    host_statistics(Host, HOST_CPU_LOAD_INFO, (host_info_t)&CPULoadLater, &(mach_msg_type_number_t){ HOST_CPU_LOAD_INFO_COUNT });
    
    uint64_t UserTicks = (CPULoadLater.cpu_ticks[CPU_STATE_USER] + CPULoadLater.cpu_ticks[CPU_STATE_NICE]) - (CPULoad.cpu_ticks[CPU_STATE_USER] + CPULoad.cpu_ticks[CPU_STATE_NICE]);
    uint64_t SystemTicks = CPULoadLater.cpu_ticks[CPU_STATE_SYSTEM] - CPULoad.cpu_ticks[CPU_STATE_SYSTEM];
    uint64_t IdleTicks = CPULoadLater.cpu_ticks[CPU_STATE_IDLE] - CPULoad.cpu_ticks[CPU_STATE_IDLE];
    
    uint64_t TotalTicks = UserTicks + SystemTicks + IdleTicks;
    
    uint64_t UserWhole, UserPart, SystemWhole, SystemPart, IdleWhole, IdlePart;
    
    cpu_percent(UserTicks, TotalTicks, &UserWhole, &UserPart);
    cpu_percent(SystemTicks, TotalTicks, &SystemWhole, &SystemPart);
    cpu_percent(IdleTicks, TotalTicks, &IdleWhole, &IdlePart);
    
    printf("%" PRIu64 "." "%" PRIu64 "%%\n",UserWhole, UserPart);
    
    
    return 0;
}

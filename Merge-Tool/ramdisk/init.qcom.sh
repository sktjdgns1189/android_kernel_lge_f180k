#!/system/bin/sh
# Copyright (c) 2009-2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

target=`getprop ro.board.platform`
platformid=`cat /sys/devices/system/soc/soc0/id`

start_battery_monitor()
{
	chown -h root.system /sys/module/pm8921_bms/parameters/*
	chmod -h 0660 /sys/module/pm8921_bms/parameters/*
	mkdir -p /data/bms
	chown -h root.system /data/bms
	chmod -h 0770 /data/bms
	start battery_monitor
}

baseband=`getprop ro.baseband`

#
# Suppress default route installation during RA for IPV6; user space will take
# care of this
# exception default ifc
for file in /proc/sys/net/ipv6/conf/*
do
  echo 0 > $file/accept_ra_defrtr
done
echo 1 > /proc/sys/net/ipv6/conf/default/accept_ra_defrtr

case "$baseband" in
        "svlte2a")
        start bridgemgrd
        ;;
esac
case "$target" in
        "msm7630_surf" | "msm8660" | "msm8960" | "msm8974")
        start quipc_igsn
esac
case "$target" in
        "msm7630_surf" | "msm8660" | "msm8960" | "msm8974")
        start quipc_main
esac


case "$target" in
    "msm7630_surf" | "msm7630_1x" | "msm7630_fusion")
        value=`cat /sys/devices/system/soc/soc0/hw_platform`
        case "$value" in
            "Fluid")
             start profiler_daemon;;
        esac
        ;;
    "msm8660" )
        platformvalue=`cat /sys/devices/system/soc/soc0/hw_platform`
        case "$platformvalue" in
            "Fluid")
                start profiler_daemon;;
        esac
        ;;
    "msm8960")
        case "$baseband" in
            "msm")
                start_battery_monitor;;
        esac

        platformvalue=`cat /sys/devices/system/soc/soc0/hw_platform`
        case "$platformvalue" in
             "Fluid")
                 start profiler_daemon;;
             "Liquid")
                 start profiler_daemon;;
        esac
        ;;
esac

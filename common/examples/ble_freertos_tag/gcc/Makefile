#******************************************************************************
#
# Makefile - Rules for building the libraries, examples and docs.
#
# Copyright (c) 2019, Ambiq Micro
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
# contributors may be used to endorse or promote products derived from this
# software without specific prior written permission.
#
# Third party software included in this distribution is subject to the
# additional license terms as defined in the /docs/licenses directory.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# This is part of revision 2.3.2 of the AmbiqSuite Development Package.
#
#******************************************************************************

#******************************************************************************
#
# User Options
#
#******************************************************************************

# You can override these values on the command line e.g. make bootload COM_PORT=/dev/cu***
# COM_PORT is the serial port to use for uploading. For example COM#### on Windows or /dev/cu.usbserial-#### on *nix
COM_PORT		?=
# ASB_UPLOAD_BAUD is the baud rate setting of the Ambiq Secue Bootloader (ASB) as it is configured on the Apollo3. Defautls to 115200 if unset
ASB_UPLOAD_BAUD	?=
# SVL_UPLOAD_BAUD is the baud rate setting of the SparkFun Variable Loader (SVL). Defaults to 921600 if unset
SVL_UPLOAD_BAUD	?=
# PYTHON3 should evaluate to a call to the Python3 executable on your machine
PYTHON3			?=

# *Optionally* specify absolute paths to the SDK and the BSP
# You can do this on the command line - e.g. make bootload SDKPATH=~/$AMBIQ_SDK_ROOT_PATH
# Make sure to use / instead of \ when on Windows
SDKPATH			?=# Set as the path to the SDK root if not located at ../../../../..
COMMONPATH		?=# Set as the path to the BSP common folder if not located at ../../../../common
BOARDPATH		?=# Set as the path to the board if not located at ../../..
PROJECTPATH		?=# Set as the path to the project if not located at ..
BOARD			?=# If using a SparkFun board you can simply provide the name e.g. redboard_artemis_atp

### Project Settings
TARGET := ble_freertos_tag
COMPILERNAME := gcc
PROJECT := $(TARGET)_gcc

#******************************************************************************
#
# Warning Messages
#
#******************************************************************************
ifeq ($(BOARD),)
    $(warning warning: no BOARD specified, will fall back to BOARDPATH for arbitrary bsp locations)
else
    BOARDPATH=../../../../$(BOARD)
    $(warning Using BOARD=$(BOARD) at $(BOARDPATH))
endif

ifeq ($(COM_PORT),)
    COM_PORT=COM4
    $(warning warning: you have not defined COM_PORT. Assuming it is COM4)
endif
ifeq ($(PYTHON3),)
    PYTHON3=python3
    $(warning warning: you have not defined PYTHON3. assuming it is accessible by 'python3')
endif
ifeq ($(ASB_UPLOAD_BAUD),)
    ASB_UPLOAD_BAUD=115200
    $(warning defaulting to 115200 baud for ASB)
endif
ifeq ($(SVL_UPLOAD_BAUD),)
    SVL_UPLOAD_BAUD=921600
    $(warning defaulting to 921600 baud for SVL)
endif

ifeq ($(SDKPATH),)
    SDKPATH			=../../../../..
    $(warning warning: you have not defined SDKPATH so will continue assuming that the SDK root is at $(SDKPATH))
else
# When the SDKPATH is given export it
export SDKPATH
endif

ifeq ($(COMMONPATH),)
    COMMONPATH			=../../../../common
    $(warning warning: you have not defined COMMONPATH so will continue assuming that the COMMON root is at $(COMMONPATH))
else
# When the COMMONPATH is given export it
export COMMONPATH
endif

ifeq ($(BOARDPATH),)
    $(error Error: BOARDPATH must be provided)
else
# Ensure that boardpath does not include a trailing '/'
ifeq ($(notdir $(BOARDPATH)),)
    override BOARDPATH:=$(patsubst %/, %,$(BOARDPATH))
    $(warning BOARDPATH had a trivial 'notdir' so we tried changing it to: $(BOARDPATH))
endif
BOARD=$(notdir $(BOARDPATH))
# When the BOARDPATH is given export it
export BOARDPATH
endif

ifeq ($(PROJECTPATH),)
    PROJECTPATH			=..
    $(warning warning: you have not defined PROJECTPATH so will continue assuming that the PROJECT root is at $(PROJECTPATH))
else
# When the PROJECTPATH is given export it
export PROJECTPATH
endif

CONFIG := $(PROJECTPATH)/gcc/$(BOARD)/bin
$(warning CONFIG=$(CONFIG))

#******************************************************************************
#
# User Defines / Includes / Sources / Libraries
#
#******************************************************************************
# Global Defines
DEFINES=  -DPART_$(PART)
DEFINES+= -DAM_FREERTOS
DEFINES+= -DAM_CUSTOM_BDADDR
DEFINES+= -DAM_PACKAGE_BGA
DEFINES+= -DWSF_TRACE_ENABLED
DEFINES+= -DAM_DEBUG_PRINTF
DEFINES+= -DAM_PART_APOLLO3
DEFINES+= -DSEC_ECC_CFG=SEC_ECC_CFG_UECC
DEFINES+= -DWSF_TRACE_ENABLED
DEFINES+= -Dgcc
DEFINES+=

INCLUDES = -I$(SDKPATH)/utils
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-host/sources/stack/l2c
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/hid
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/fmpl
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-host/sources/stack/att
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/uribeacon
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/apps
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/gap
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-host/include
INCLUDES+= -I$(SDKPATH)/mcu/apollo3
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-host/sources/hci/include
INCLUDES+= -I$(SDKPATH)/devices
INCLUDES+= -I$(SDKPATH)/third_party/exactle/wsf/sources
INCLUDES+= -I$(SDKPATH)/third_party/FreeRTOSv10.1.1/Source/portable/GCC/AMapollo2
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-host/sources/sec/common
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/bas
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/apps/app
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/include
INCLUDES+= -I$(SDKPATH)
INCLUDES+= -I$(SDKPATH)/third_party/exactle/wsf/include
INCLUDES+= -I$(COMMONPATH)/examples/ble_freertos_tag/src
INCLUDES+= -I$(SDKPATH)/CMSIS/ARM/Include
INCLUDES+= -I$(SDKPATH)/third_party/exactle/wsf/sources/port/freertos
INCLUDES+= -I$(SDKPATH)/third_party/FreeRTOSv10.1.1/Source/include
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-host/sources/hci/ambiq/apollo3
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-host/sources/stack/dm
INCLUDES+= -I$(SDKPATH)/third_party/exactle/wsf/sources/util
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/wdxs
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/gatt
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/include/app
INCLUDES+= -I$(SDKPATH)/third_party/uecc
INCLUDES+= -I$(BOARDPATH)/bsp
INCLUDES+= -I$(SDKPATH)/CMSIS/AmbiqMicro/Include
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/services
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/apps/tag
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-host/sources/stack/smp
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-host/sources/stack/hci
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-host/sources/stack/cfg
INCLUDES+= -I$(SDKPATH)/third_party/exactle/ble-host/sources/hci/ambiq

VPATH = $(SDKPATH)/utils
VPATH+=:$(SDKPATH)/third_party/exactle/ble-host/sources/stack/l2c
VPATH+=:$(COMMONPATH)/examples/ble_freertos_tag/src
VPATH+=:$(SDKPATH)/third_party/exactle/wsf/sources/port/freertos
VPATH+=:$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/hid
VPATH+=:$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/fmpl
VPATH+=:$(SDKPATH)/third_party/exactle/ble-host/sources/stack/att
VPATH+=:$(SDKPATH)/third_party/exactle/ble-host/sources/sec/uecc
VPATH+=:$(SDKPATH)/third_party/exactle/ble-profiles/sources/apps/app/common
VPATH+=:$(SDKPATH)/third_party/exactle/ble-host/sources/hci/ambiq/apollo3
VPATH+=:$(SDKPATH)/third_party/exactle/wsf/sources/util
VPATH+=:$(SDKPATH)/third_party/FreeRTOSv10.1.1/Source
VPATH+=:$(SDKPATH)/third_party/exactle/ble-host/sources/stack/dm
VPATH+=:$(SDKPATH)/third_party/FreeRTOSv10.1.1/Source/portable/MemMang
VPATH+=:$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/wdxs
VPATH+=:$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/gatt
VPATH+=:$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/gap
VPATH+=:$(SDKPATH)/third_party/uecc
VPATH+=:$(SDKPATH)/devices
VPATH+=:$(SDKPATH)/third_party/FreeRTOSv10.1.1/Source/portable/GCC/AMapollo2
VPATH+=:$(SDKPATH)/third_party/exactle/ble-profiles/sources/services
VPATH+=:$(SDKPATH)/third_party/exactle/ble-profiles/sources/apps/tag
VPATH+=:$(SDKPATH)/third_party/exactle/ble-host/sources/sec/common
VPATH+=:$(SDKPATH)/third_party/exactle/ble-profiles/sources/profiles/bas
VPATH+=:$(SDKPATH)/third_party/exactle/ble-host/sources/stack/smp
VPATH+=:$(SDKPATH)/third_party/exactle/ble-profiles/sources/apps/app
VPATH+=:$(SDKPATH)/third_party/exactle/ble-host/sources/stack/hci
VPATH+=:$(SDKPATH)/third_party/exactle/ble-host/sources/stack/cfg
VPATH+=:$(SDKPATH)/third_party/exactle/ble-host/sources/hci/ambiq
VPATH+=:$(SDKPATH)/third_party/exactle/ble-profiles/sources/apps/hidapp

LIBS = $(SDKPATH)/mcu/apollo3/hal/gcc/bin/libam_hal.a
LIBS += $(BOARDPATH)/bsp/gcc/bin/libam_bsp.a

SRC = l2c_coc.c
SRC += l2c_main.c
SRC += l2c_master.c
SRC += l2c_slave.c
SRC += ble_freertos_tag.c
SRC += radio_task.c
SRC += rtos.c
SRC += wsf_assert.c
SRC += wsf_buf.c
SRC += wsf_efs.c
SRC += wsf_math.c
SRC += wsf_msg.c
SRC += wsf_os.c
SRC += wsf_queue.c
SRC += wsf_timer.c
SRC += wsf_trace.c
SRC += hid_main.c
SRC += fmpl_main.c
SRC += attc_disc.c
SRC += attc_main.c
SRC += attc_proc.c
SRC += attc_read.c
SRC += attc_sign.c
SRC += attc_write.c
SRC += atts_ccc.c
SRC += atts_csf.c
SRC += atts_dyn.c
SRC += atts_ind.c
SRC += atts_main.c
SRC += atts_proc.c
SRC += atts_read.c
SRC += atts_sign.c
SRC += atts_write.c
SRC += att_main.c
SRC += att_uuid.c
SRC += sec_ecc.c
SRC += app_db.c
SRC += app_hw.c
SRC += app_ui.c
SRC += ui_console.c
SRC += ui_lcd.c
SRC += ui_main.c
SRC += ui_platform.c
SRC += ui_timer.c
SRC += hci_drv_apollo3.c
SRC += bda.c
SRC += bstream.c
SRC += calc128.c
SRC += crc32.c
SRC += print.c
SRC += terminal.c
SRC += wstr.c
SRC += dm_adv.c
SRC += dm_adv_ae.c
SRC += dm_adv_leg.c
SRC += dm_conn.c
SRC += dm_conn_cte.c
SRC += dm_conn_master.c
SRC += dm_conn_master_ae.c
SRC += dm_conn_master_leg.c
SRC += dm_conn_slave.c
SRC += dm_conn_slave_ae.c
SRC += dm_conn_slave_leg.c
SRC += dm_conn_sm.c
SRC += dm_dev.c
SRC += dm_dev_priv.c
SRC += dm_main.c
SRC += dm_past.c
SRC += dm_phy.c
SRC += dm_priv.c
SRC += dm_scan.c
SRC += dm_scan_ae.c
SRC += dm_scan_leg.c
SRC += dm_sec.c
SRC += dm_sec_lesc.c
SRC += dm_sec_master.c
SRC += dm_sec_slave.c
SRC += dm_sync_ae.c
SRC += wdxs_au.c
SRC += wdxs_dc.c
SRC += wdxs_ft.c
SRC += wdxs_main.c
SRC += wdxs_phy.c
SRC += wdxs_stream.c
SRC += gatt_main.c
SRC += gap_main.c
SRC += uECC.c
SRC += uECC_ll.c
SRC += port.c
SRC += sec_aes.c
SRC += sec_aes_rev.c
SRC += sec_ccm_hci.c
SRC += sec_cmac_hci.c
SRC += sec_ecc_debug.c
SRC += sec_ecc_hci.c
SRC += sec_main.c
SRC += bas_main.c
SRC += smpi_act.c
SRC += smpi_sc_act.c
SRC += smpi_sc_sm.c
SRC += smpi_sm.c
SRC += smpr_act.c
SRC += smpr_sc_act.c
SRC += smpr_sc_sm.c
SRC += smpr_sm.c
SRC += smp_act.c
SRC += smp_db.c
SRC += smp_main.c
SRC += smp_non.c
SRC += smp_sc_act.c
SRC += smp_sc_main.c
SRC += hci_main.c
SRC += cfg_stack.c
SRC += hci_cmd.c
SRC += hci_cmd_ae.c
SRC += hci_cmd_cte.c
SRC += hci_cmd_past.c
SRC += hci_cmd_phy.c
SRC += hci_core.c
SRC += hci_core_ps.c
SRC += hci_evt.c
SRC += hci_tr.c
SRC += hci_vs.c
SRC += hci_vs_ae.c
SRC += hidapp_main.c
SRC += am_util_ble.c
SRC += am_util_debug.c
SRC += am_util_delay.c
SRC += am_util_faultisr.c
SRC += am_util_id.c
SRC += am_util_stdio.c
SRC += event_groups.c
SRC += list.c
SRC += queue.c
SRC += tasks.c
SRC += timers.c
SRC += heap_2.c
SRC += am_devices_button.c
SRC += am_devices_led.c
SRC += svc_batt.c
SRC += svc_bps.c
SRC += svc_core.c
SRC += svc_cps.c
SRC += svc_cscs.c
SRC += svc_dis.c
SRC += svc_gls.c
SRC += svc_gyro.c
SRC += svc_hid.c
SRC += svc_hrs.c
SRC += svc_hts.c
SRC += svc_ipss.c
SRC += svc_plxs.c
SRC += svc_px.c
SRC += svc_rscs.c
SRC += svc_scpss.c
SRC += svc_temp.c
SRC += svc_uricfg.c
SRC += svc_wdxs.c
SRC += svc_wp.c
SRC += svc_wss.c
SRC += tag_main.c
SRC += app_disc.c
SRC += app_main.c
SRC += app_master.c
SRC += app_master_leg.c
SRC += app_server.c
SRC += app_slave.c
SRC += app_slave_leg.c
SRC += app_terminal.c
SRC += startup_gcc.c



#******************************************************************************
#
# Warning Messages
#
#******************************************************************************
### Bootloader Tools
ASB_UPLOADER=$(PYTHON3) $(COMMONPATH)/tools_sfe/asb/asb.py
SVL_UPLOADER=$(PYTHON3) $(COMMONPATH)/tools_sfe/svl/svl.py


SHELL:=/bin/bash
#### Setup ####

TOOLCHAIN ?= arm-none-eabi
PART = apollo3
CPU = cortex-m4
FPU = fpv4-sp-d16
# Default to FPU hardware calling convention.  However, some customers and/or
# applications may need the software calling convention.
#FABI = softfp
FABI = hard

STARTUP_FILE := $(COMMONPATH)/examples/ble_freertos_tag/gcc/startup_$(COMPILERNAME).c

#### Required Executables ####
CC = $(TOOLCHAIN)-gcc
GCC = $(TOOLCHAIN)-gcc
CPP = $(TOOLCHAIN)-cpp
CXX = $(TOOLCHAIN)-g++
LD = $(TOOLCHAIN)-ld
CP = $(TOOLCHAIN)-objcopy
OD = $(TOOLCHAIN)-objdump
RD = $(TOOLCHAIN)-readelf
AR = $(TOOLCHAIN)-ar
SIZE = $(TOOLCHAIN)-size
RM = $(shell which rm 2>/dev/null)

EXECUTABLES = CC LD CP OD AR RD SIZE GCC CXX
K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell which $($(exec)) 2>/dev/null),,\
        $(info $(exec) not found on PATH ($($(exec))).)$(exec)))
$(if $(strip $(value K)),$(info Required Program(s) $(strip $(value K)) not found))

ifneq ($(strip $(value K)),)
all clean:
	$(info Tools $(TOOLCHAIN)-$(COMPILERNAME) not installed.)
	$(RM) -rf bin
else


#******************************************************************************
#
# Machinery
#
#******************************************************************************

XSRC = $(filter %.cpp,$(SRC))
ZSRC = $(filter %.cc,$(SRC))
CSRC = $(filter %.c,$(SRC))
ASRC = $(filter %.s,$(SRC))

OBJS = $(XSRC:%.cpp=$(CONFIG)/%.o)
OBJS+= $(ZSRC:%.cc=$(CONFIG)/%.o)
OBJS+= $(CSRC:%.c=$(CONFIG)/%.o)
OBJS+= $(ASRC:%.s=$(CONFIG)/%.o)

DEPS = $(XSRC:%.cpp=$(CONFIG)/%.d)
DEPS+= $(ZSRC:%.cc=$(CONFIG)/%.d)
DEPS+= $(CSRC:%.c=$(CONFIG)/%.d)
DEPS+= $(ASRC:%.s=$(CONFIG)/%.d)

CSTD = -std=c99

CFLAGS = -mthumb -mcpu=$(CPU) -mfpu=$(FPU) -mfloat-abi=$(FABI)
CFLAGS+= -ffunction-sections -fdata-sections -fomit-frame-pointer
CFLAGS+= -MMD -MP $(CSTD) -Wall -g
CFLAGS+= -O0
CFLAGS+= $(DEFINES)
CFLAGS+= $(INCLUDES)
CFLAGS+=

XSTD   = -std=gnu++11

XFLAGS = $(CFLAGS)
XFLAGS+= -fno-exceptions

LFLAGS = -mthumb -mcpu=$(CPU) -mfpu=$(FPU) -mfloat-abi=$(FABI)
LFLAGS+= -nostartfiles -static
LFLAGS+= -Wl,--gc-sections,--entry,Reset_Handler,-Map,$(CONFIG)/$(TARGET).map
LFLAGS+= -Wl,--start-group -lm -lc -lgcc $(LIBS) -Wl,--end-group
LFLAGS+=

# Additional user specified CFLAGS
CFLAGS+=$(EXTRA_CFLAGS)

CPFLAGS = -Obinary

ODFLAGS = -S


#******************************************************************************
#
# Targets / Rules
#
#******************************************************************************
all: asb
asb: directories $(CONFIG)/$(TARGET)_asb.bin
svl: directories $(CONFIG)/$(TARGET)_svl.bin

directories: $(CONFIG)

$(CONFIG):
	@mkdir -p $@

$(CONFIG)/%.o: %.c $(CONFIG)/%.d
	@echo " Compiling $(COMPILERNAME) $<" ;\
	$(CC) -c $(CFLAGS) $< -o $@

$(CONFIG)/%.o: %.s $(CONFIG)/%.d
	@echo " Assembling $(COMPILERNAME) $<" ;\
	$(CC) -c $(CFLAGS) $< -o $@

$(CONFIG)/$(TARGET)_asb.axf: LINKER_FILE := $(COMMONPATH)/examples/ble_freertos_tag/gcc/ble_freertos_tag_asb.ld
$(CONFIG)/$(TARGET)_asb.axf: $(OBJS) $(LIBS)
	@echo " Linking $(COMPILERNAME) $@ with script $(LINKER_FILE)";\
	$(CC) -Wl,-T,$(LINKER_FILE) -o $@ $(OBJS) $(LFLAGS)

$(CONFIG)/$(TARGET)_svl.axf: LINKER_FILE := $(COMMONPATH)/examples/ble_freertos_tag/gcc/ble_freertos_tag_svl.ld
$(CONFIG)/$(TARGET)_svl.axf: $(OBJS) $(LIBS)
	@echo " Linking $(COMPILERNAME) $@ with script $(LINKER_FILE)";\
	$(CC) -Wl,-T,$(LINKER_FILE) -o $@ $(OBJS) $(LFLAGS)

$(CONFIG)/$(TARGET)_%.bin: $(CONFIG)/$(TARGET)_%.axf
	@echo " Copying $(COMPILERNAME) $@..." ;\
	$(CP) $(CPFLAGS) $< $@ ;\
	$(OD) $(ODFLAGS) $< > $(CONFIG)/$(TARGET).lst

bootload_asb: directories $(CONFIG)/$(TARGET)_asb.bin
	@echo "Uploading using the Ambiq Secure Bootloader"
	$(ASB_UPLOADER) --bin $(CONFIG)/$(TARGET)_asb.bin --load-address-blob 0x20000 --magic-num 0xCB -o $(CONFIG)/$(TARGET) --version 0x0 --load-address-wired 0xC000 -i 6 --options 0x1 -b $(ASB_UPLOAD_BAUD) -port $(COM_PORT) -r 2 -v

bootload_svl: directories $(CONFIG)/$(TARGET)_svl.bin
	@echo "Uploading using the SparkFun Variable Loader"
	$(SVL_UPLOADER) $(COM_PORT) -f $(CONFIG)/$(TARGET)_svl.bin -b $(SVL_UPLOAD_BAUD) -v

bootload: bootload_svl

clean:
	@echo "Cleaning..." ;\
	$(RM) -f $(OBJS) $(DEPS) \
	    $(CONFIG)/$(TARGET).bin $(CONFIG)/$(TARGET).axf \
	    $(CONFIG)/$(TARGET).lst $(CONFIG)/$(TARGET).map \
		$(CONFIG)/$(TARGET)_svl.bin $(CONFIG)/$(TARGET)_svl.axf \
	    $(CONFIG)/$(TARGET)_svl.lst $(CONFIG)/$(TARGET)_svl.map \
	    $(CONFIG)/$(TARGET)_asb.bin $(CONFIG)/$(TARGET)_asb.axf \
	    $(CONFIG)/$(TARGET)_asb.lst $(CONFIG)/$(TARGET)_asb.map

$(CONFIG)/%.d: ;

$(SDKPATH)/mcu/apollo3/hal/gcc/bin/libam_hal.a:
	$(MAKE) -C $(SDKPATH)/mcu/apollo3/hal

$(BOARDPATH)/bsp/gcc/bin/libam_bsp.a:
	$(MAKE) -C $(BOARDPATH)/bsp

# Automatically include any generated dependencies
-include $(DEPS)
endif
.PHONY: all clean directories

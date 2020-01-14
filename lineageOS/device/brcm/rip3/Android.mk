#
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),rpi3)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif

include $(CLEAR_VARS)
LOCAL_MODULE := remove_unused_module
LOCAL_MODULE_TAGS := optional

LOCAL_MODULE_CLASS := FAKE
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)

LOCAL_OVERRIDES_PACKAGES += \
   Contacts \
   Email \
   DeskClock \
   Calendar \
   CalendarProvider \
   Contacts \
   Email \
   vr \
   Telecom \
   TeleService \
   PrintSpooler \
   PrintRecommendationService \
   PicoTts \
   MmsService \
   AudioFX \
   ExactCalculator \
   Camera2 \
   Gallery2 \
   Recorder \
   Eleven

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE):
	$(hide) echo "Fake: $@"
	$(hide) mkdir -p $(dir $@)
	$(hide) touch $@

PACKAGES.$(LOCAL_MODULE).OVERRIDES := $(strip $(LOCAL_OVERRIDES_PACKAGES))

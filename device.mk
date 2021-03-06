# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2021 The OmniRom Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file is the build configuration for a full Android
# build for grouper hardware. This cleanly combines a set of
# device-specific aspects (drivers) with a device-agnostic
# product configuration (apps).
#
$(call inherit-product, vendor/xiaomi/alioth/alioth-vendor.mk)

# fusefs / disable sdcardfs usage
#$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Include GSI keys
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    vendor/omni/overlay/CarrierConfig

PRODUCT_PACKAGES += \
    FrameworksResOverlay \
    SettingsProviderOverlay \
    SystemUIOverlay \
    TetheringOverlay \
    WifiOverlay


# VNDK
PRODUCT_TARGET_VNDK_VERSION := 30
PRODUCT_EXTRA_VNDK_VERSIONS := 30

# A/B
ENABLE_VIRTUAL_AB := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    odm \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/omnipreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    omnipreopt_script

# tell update_engine to not change dynamic partition table during updates
# needed since our qti_dynamic_partitions does not include
# vendor and odm and we also dont want to AB update them
TARGET_ENFORCE_AB_OTA_PARTITION_LIST := true

# ANT+
PRODUCT_PACKAGES += \
    AntHalService

# Api
PRODUCT_SHIPPING_API_LEVEL := 30

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot@1.1-impl.recovery \
    bootctrl.kona.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctl

# Charger images
PRODUCT_PACKAGES += \
    omni_charger_res_images \
    animation.txt \
    font_charger.png

# Camera
PRODUCT_PACKAGES += \
    SnapdragonCamera2

# DeviceParts
#PRODUCT_PACKAGES += \
#    DeviceParts
#    OmniDisplayManager


# Display
PRODUCT_PACKAGES += \
    libion \
    libtinyxml2

PRODUCT_PACKAGES += \
    libtinyalsa

$(call inherit-product, vendor/qcom/opensource/commonsys-intf/display/config/display-product-system.mk)
$(call inherit-product, vendor/qcom/opensource/commonsys/display/config/display-product-commonsys.mk)


# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    fastbootd

# Frameworks
PRODUCT_PACKAGES += \
    FrameworksResOverlay

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0 \
    libhidltransport \
    libhwbinder

# Input
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/idc/uinput-fpc.idc:system/usr/idc/uinput-fpc.idc \
    $(LOCAL_PATH)/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/keylayout/uinput-fpc.kl:system/usr/keylayout/uinput-fpc.kl

# Live Wallpapers
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    VisualizationWallpapers \
    librs_jni

# NFC
PRODUCT_PACKAGES += \
    NfcNci \
    Tag \
    SecureElement \
    com.android.nfc_extras

# Prebuilt
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,device/xiaomi/alioth/prebuilt/product,product) \
    $(call find-copy-subdir-files,*,device/xiaomi/alioth/prebuilt/root,recovery/root) \
    $(call find-copy-subdir-files,*,device/xiaomi/alioth/prebuilt/system,system) \
    $(call find-copy-subdir-files,*,device/xiaomi/alioth/prebuilt/system_ext,system_ext)

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.controls.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.controls.xml \
		frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.freeform_window_management.xml

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xhdpi

# Properties
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Netutils
PRODUCT_PACKAGES += \
    netutils-wrapper-1.0 \
    libandroid_net

PRODUCT_PACKAGES += \
    vndk_package

# Ramdisk
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Systemhelper
PRODUCT_PACKAGES += \
    vendor.qti.hardware.systemhelper@1.0 \
		android.hardware.thermal@2.0

# Telephony
PRODUCT_PACKAGES += \
    ims-ext-common \
    ims_ext_common.xml \
    qti-telephony-hidl-wrapper \
    qti_telephony_hidl_wrapper.xml \
    qti-telephony-utils \
    qti_telephony_utils.xml \
    tcmiface

# Telephony extension
PRODUCT_PACKAGES += telephony-ext
PRODUCT_BOOT_JARS += telephony-ext

# Update engine
PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_HOST_PACKAGES += \
    brillo_update_payload

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

PRODUCT_BUILD_SUPER_PARTITION := false
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# WiFi
PRODUCT_PACKAGES += \
    TetheringConfigOverlay \
    WifiOverlay

# Wifi Display
PRODUCT_PACKAGES += \
    libavservices_minijail \
    libnl \

PRODUCT_BOOT_JARS += \
    WfdCommon

# Vintf
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/vintf/manifest/manifest.xml:$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/vintf/manifest/manifest.xml

#		$(LOCAL_PATH)/vintf/manifest/android.hardware.wifi.hostapd.xml:$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/vintf/manifest/android.hardware.wifi.hostapd.xml


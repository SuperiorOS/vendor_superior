EXTRA_PATH := vendor/extra

# Branding
SUPERIOR_BUILD_DATE_UTC ?= $(shell date -u '+%Y%m%d-%H%M')
SUPERIOR_VERSION ?= SuperiorOS-Fifteen-ROGUE-$(SUPERIOR_BUILD_DATE_UTC)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.superior.version=$(SUPERIOR_VERSION)

# Bootanimation
PRODUCT_COPY_FILES += $(EXTRA_PATH)/bootanimation/bootanimation-1080p.zip:$(TARGET_COPY_OUT_SYSTEM)/media/bootanimation.zip

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/media/bootanimation.zip

# Certification
$(call inherit-product, vendor/certification/config.mk)

# Overlays
PRODUCT_PACKAGE_OVERLAYS += \
    $(EXTRA_PATH)/overlay/common

# Google Apps
WITH_GMS := true
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)

# API level spoof
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.pihooks.first_api_level=32

# Google Faceunlock
$(call inherit-product, vendor/google/faceunlock/device.mk)

# Weather Package
PRODUCT_PACKAGES += \
    OmniJaws

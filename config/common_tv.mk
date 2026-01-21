# Inherit common Superior stuff
$(call inherit-product, vendor/superior/config/common.mk)

# Include AOSP audio files
$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioTv.mk)

# Inherit Superior atv device tree
$(call inherit-product, device/superior/atv/superior_atv.mk)

# AOSP packages
PRODUCT_PACKAGES += \
    LeanbackIME

# Superior packages
PRODUCT_PACKAGES += \
    Catapult \
    LineageCustomizer

PRODUCT_PACKAGE_OVERLAYS += vendor/superior/overlay/tv

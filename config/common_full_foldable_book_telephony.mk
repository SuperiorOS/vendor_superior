# Inherit mobile full common Superior stuff
$(call inherit-product, vendor/superior/config/common_mobile_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/large_screen_foldable_common.mk)

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

$(call inherit-product, vendor/superior/config/telephony.mk)

PRODUCT_PACKAGE_OVERLAYS += vendor/superior/overlay/foldable_book

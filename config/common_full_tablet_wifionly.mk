# Inherit mobile full common Superior stuff
$(call inherit-product, vendor/superior/config/common_mobile_full.mk)

# Inherit tablet common Superior stuff
$(call inherit-product, vendor/superior/config/tablet.mk)

$(call inherit-product, vendor/superior/config/wifionly.mk)

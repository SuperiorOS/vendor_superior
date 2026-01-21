# Inherit common Superior stuff
$(call inherit-product, vendor/superior/config/common.mk)

# Inherit Superior car device tree
$(call inherit-product, device/superior/car/superior_car.mk)

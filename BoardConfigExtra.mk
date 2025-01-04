# Google Apps
WITH_GMS ?= true
ifeq ($(WITH_GMS),true)
include vendor/gapps/arm64/BoardConfigVendor.mk
endif

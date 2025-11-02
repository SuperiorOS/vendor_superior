PRODUCT_VERSION_MAJOR = 16
PRODUCT_VERSION_MINOR = 0

# Build date
SUPERIOR_BUILD_DATE := $(shell date -u '+%Y%m%d-%H%M')

# Extract device codename
CURRENT_DEVICE := $(wordlist 2,3,$(subst _, ,$(TARGET_PRODUCT)))
DEVICE_LIST := $(file < vendor/superior/superior.devices)

# Default build type
SUPERIOR_BUILDTYPE ?= COMMUNITY

ifeq ($(SUPERIOR_BUILDTYPE),OFFICIAL)
    SUPERIOR_BUILDTYPE := COMMUNITY
    ifneq ($(filter $(CURRENT_DEVICE),$(DEVICE_LIST)),)
        SUPERIOR_BUILDTYPE := OFFICIAL
    endif
endif

SUPERIOR_VERSION_SUFFIX := $(SUPERIOR_BUILD_DATE)-$(SUPERIOR_BUILDTYPE)-$(CURRENT_DEVICE)

# Internal version
SUPERIOR_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(SUPERIOR_VERSION_SUFFIX)

# Display version
SUPERIOR_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR)-$(SUPERIOR_VERSION_SUFFIX)

# SuperiorOS version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.superior.version=$(SUPERIOR_VERSION) \
    ro.superior.display.version=$(SUPERIOR_DISPLAY_VERSION) \
    ro.superior.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.superior.releasetype=$(SUPERIOR_BUILDTYPE)

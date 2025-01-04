SUPERIOR_TARGET_PACKAGE := $(PRODUCT_OUT)/$(SUPERIOR_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

$(SUPERIOR_TARGET_PACKAGE): $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(SUPERIOR_TARGET_PACKAGE)
	$(hide) $(SHA256) $(SUPERIOR_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(SUPERIOR_TARGET_PACKAGE).sha256sum
	@echo "Package Complete: $(SUPERIOR_TARGET_PACKAGE)" >&2

.PHONY: superior
superior: $(SUPERIOR_TARGET_PACKAGE) $(DEFAULT_GOAL)

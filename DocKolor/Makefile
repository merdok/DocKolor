GO_EASY_ON_ME = 1
SDKVERSION = 9.2
ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = DocKolor
DocKolor_FILES = DocKolor.mm
DocKolor_INSTALL_PATH = /Library/PreferenceBundles
DocKolor_FRAMEWORKS = UIKit
DocKolor_PRIVATE_FRAMEWORKS = Preferences
DocKolor_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DocKolor.plist$(ECHO_END)

GO_EASY_ON_ME = 1
SDKVERSION = 9.2
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = DocKolor
DocKolor_FILES = Tweak.xm
DocKolor_FRAMEWORKS = UIKit


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += DocKolor
include $(THEOS_MAKE_PATH)/aggregate.mk


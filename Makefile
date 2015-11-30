include theos/makefiles/common.mk
export ARCHS = armv7 arm64
export SDKVERSION = 9.1
TWEAK_NAME = CydiaLight
CydiaLight_FILES = Tweak.xm
CydiaLight_FRAMEWORKS = Foundation CoreSpotlight MobileCoreServices CoreImage UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

ARCHS = armv7 arm64
THEOS_BUILD_DIR = Packages
THEOS_DEVICE_IP = 192.168.1.23
include theos/makefiles/common.mk

TWEAK_NAME = ControlPane
ControlPane_FILES = ControlPane.xm CBAutoScrollLabel.m
ControlPane_LIBRARIES = substrate flipswitch activator
ControlPane_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
ControlPane_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard; killall -9 backboardd"
SUBPROJECTS += controlpaneprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

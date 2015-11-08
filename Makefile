ARCHS = armv7 arm64
THEOS_BUILD_DIR = Packages
include theos/makefiles/common.mk

TWEAK_NAME = ControlPane
ControlPane_FILES = ControlPane.xm CBAutoScrollLabel.m
ControlPane_LIBRARIES = substrate flipswitch activator
ControlPane_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
ControlPane_PRIVATE_FRAMEWORKS = MediaRemote
ControlPane_LDFLAGS += -Wl,-segalign,4000
ControlPane_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard; killall -9 backboardd"
SUBPROJECTS += controlpaneprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

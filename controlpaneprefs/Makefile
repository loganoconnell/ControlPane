ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = ControlPanePrefs
ControlPanePrefs_FILES = ControlPanePrefs.mm
ControlPanePrefs_INSTALL_PATH = /Library/PreferenceBundles
ControlPanePrefs_FRAMEWORKS = Foundation UIKit
ControlPanePrefs_PRIVATE_FRAMEWORKS = Preferences Twitter

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ControlPanePrefs.plist$(ECHO_END)

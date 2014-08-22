include theos/makefiles/common.mk

BUNDLE_NAME = ShuffleLock
ShuffleLock_FILES = ShuffleLock.mm
ShuffleLock_INSTALL_PATH = /Library/PreferenceBundles
ShuffleLock_FRAMEWORKS = UIKit
ShuffleLock_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ShuffleLock.plist$(ECHO_END)

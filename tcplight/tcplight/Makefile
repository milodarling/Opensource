include theos/makefiles/common.mk

BUNDLE_NAME = TCPLight
TCPLight_FILES = TCPLight.mm
TCPLight_INSTALL_PATH = /Library/PreferenceBundles
TCPLight_FRAMEWORKS = UIKit
TCPLight_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/TCPLight.plist$(ECHO_END)

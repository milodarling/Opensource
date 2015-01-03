ARCHS = armv7 arm64
TARGET = iphone:clang
include theos/makefiles/common.mk
THEOS_BUILD_DIR = Packages
CFLAGS = -fobjc-arc

TWEAK_NAME = TCPLight
TCPLight_FILES = Tweak.xm
TCPLight_FRAMEWORKS = UIKit
TCPPLight_LIBRARIES = activator substrate
TCPLight_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += tcplight
include $(THEOS_MAKE_PATH)/aggregate.mk

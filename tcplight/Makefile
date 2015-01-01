include theos/makefiles/common.mk
export TARGET=iphone:clang
TCPLight_LDFLAGS = -lactivator

TWEAK_NAME = TCPLight
TCPLight_FILES = Tweak.xm
TCPPLight_LIBRARIES = activator substrate

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

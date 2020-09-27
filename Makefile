TARGET = iphone:latest:10.0
PACKAGE_VERSION = 0.0.6.4~b1
ARCHS = armv7 arm64 arm64e
INSTALL_TARGET_PROCESSES = YouTube

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YouPip
YouPip_FILES = Tweak.xm
YouPip_CFLAGS = -fobjc-arc
YouPip_FRAMEWORKS = AVKit

include $(THEOS_MAKE_PATH)/tweak.mk

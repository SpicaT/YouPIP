TARGET = iphone:latest:10.0
PACKAGE_VERSION = 0.0.5
ARCHS = armv7 arm64 arm64e
INSTALL_TARGET_PROCESSES = YouTube

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YouPip
YouPip_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

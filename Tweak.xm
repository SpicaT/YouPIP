#import <UIKit/UIImage+Private.h>

@interface GPBExtensionRegistry : NSObject
- (void)addExtension:(id)extension;
@end

@interface GoogleGlobalExtensionRegistry : NSObject
- (GPBExtensionRegistry *)extensionRegistry;
@end

@interface YTIPictureInPictureRendererRoot : NSObject
+ (id)pictureInPictureRenderer;
@end

@interface YTIIosMediaHotConfig : NSObject
- (BOOL)enablePictureInPicture;
- (void)setEnablePictureInPicture:(BOOL)enabled;
@end

@interface YTHotConfig : NSObject
- (YTIIosMediaHotConfig *)mediaHotConfig;
@end

@interface GIMMe
- (id)nullableInstanceForType:(id)protocol;
- (id)instanceForType:(id)protocol;
@end

@interface MLPIPController : NSObject
- (id)initWithPlaceholderPlayerItemResourcePath:(NSString *)placeholderPath;
- (BOOL)isPictureInPictureSupported;
- (GIMMe *)gimme;
- (void)setGimme:(GIMMe *)gimme;
- (void)initializePictureInPicture;
- (BOOL)startPictureInPicture;
@end

@interface MLRemoteStream : NSObject
- (NSURL *)URL;
@end

@interface MLStreamingData : NSObject
- (NSArray <MLRemoteStream *> *)adaptiveStreams;
@end

@interface MLVideo : NSObject
- (MLStreamingData *)streamingData;
@end

@interface YTSingleVideo : NSObject
- (MLVideo *)video;
@end

@class YTLocalPlaybackController;

@interface YTSingleVideoController : NSObject
- (YTSingleVideo *)videoData;
- (YTLocalPlaybackController *)delegate;
@end

@interface YTPlaybackControllerUIWrapper : NSObject
- (YTSingleVideoController *)activeVideo;
- (YTSingleVideoController *)contentVideo;
@end

@interface YTPlayerViewController : UIViewController
@end

@interface YTPlayerView : UIView
- (YTPlaybackControllerUIWrapper *)playerViewDelegate;
@end

@interface YTPlayerPIPController : NSObject
- (BOOL)canInvokePictureInPicture;
@end

@interface YTLocalPlaybackController : NSObject {
    YTPlayerPIPController *_playerPIPController;
}
@end

@interface GIMBindingBuilder : NSObject
- (GIMBindingBuilder *)bindType:(Class)type;
- (GIMBindingBuilder *)initializedWith:(id (^)(id))block;
@end

@interface QTMIcon : NSObject
+ (UIImage *)tintImage:(UIImage *)image color:(UIColor *)color;
@end

@interface YTQTMButton : UIButton
@end

@interface YTMainAppVideoPlayerOverlayView : UIView
@end

@interface YTMainAppControlsOverlayView : UIView
+ (CGFloat)topButtonAdditionalPadding;
- (YTQTMButton *)buttonWithImage:(UIImage *)image accessibilityLabel:(NSString *)accessibilityLabel verticalContentPadding:(CGFloat)verticalContentPadding;
@end

@interface YTMainAppVideoPlayerOverlayViewController : UIViewController
- (YTMainAppVideoPlayerOverlayView *)videoPlayerOverlayView;
- (YTPlayerViewController *)delegate;
@end

@interface YTMainAppControlsOverlayView (YP)
@property(retain, nonatomic) YTQTMButton *pipButton;
- (void)didPressPiP:(id)arg;
- (UIImage *)pipImage;
@end

@interface YTUIResources : NSObject
@end

@interface YTPlayerResources : NSObject
@end

@interface YTColor : NSObject
+ (UIColor *)white1;
@end

@interface NSMutableArray (YouTube)
- (void)yt_addNullableObject:(id)object;
@end

%hook YTMainAppVideoPlayerOverlayViewController

- (void)updateTopRightButtonAvailability {
    %orig;
    YTMainAppVideoPlayerOverlayView *v = [self videoPlayerOverlayView];
    YTMainAppControlsOverlayView *c = [v valueForKey:@"_controlsOverlayView"];
    c.pipButton.hidden = NO;
    [c setNeedsLayout];
}

%end

%hook YTMainAppControlsOverlayView

%property(retain, nonatomic) YTQTMButton *pipButton;

- (id)initWithDelegate:(id)delegate {
    self = %orig;
    if (self) {
        CGFloat padding = [[self class] topButtonAdditionalPadding];
        UIImage *image = [self pipImage];
        self.pipButton = [self buttonWithImage:image accessibilityLabel:@"pip" verticalContentPadding:padding];
        self.pipButton.hidden = YES;
        self.pipButton.alpha = 0;
        [self.pipButton addTarget:self action:@selector(didPressPiP:) forControlEvents:64];
        [self addSubview:self.pipButton];
    }
    return self;
}

- (NSMutableArray *)topControls {
    NSMutableArray *controls = %orig;
    [controls insertObject:self.pipButton atIndex:0];
    return controls;
}

- (void)setTopOverlayVisible:(BOOL)visible isAutonavCanceledState:(BOOL)canceledState {
    if (canceledState) {
        if (!self.pipButton.hidden)
            self.pipButton.alpha = 0.0;
    } else {
        if (!self.pipButton.hidden)
            self.pipButton.alpha = visible ? 1.0 : 0.0;
    }
    %orig;
}

%new
- (UIImage *)pipImage {
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIColor *color = [%c(YTColor) white1];
        image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/YouPIP/yt-pip-overlay.png"];
        if ([%c(QTMIcon) respondsToSelector:@selector(tintImage:color:)])
            image = [%c(QTMIcon) tintImage:image color:color];
        else
            image = [image _flatImageWithColor:color];
        if ([image respondsToSelector:@selector(imageFlippedForRightToLeftLayoutDirection)])
            image = [image imageFlippedForRightToLeftLayoutDirection];
    });
    return image;
}

%new
- (void)didPressPiP:(id)arg {
    YTMainAppVideoPlayerOverlayViewController *c = [self valueForKey:@"_eventsDelegate"];
    YTPlayerViewController *p = [c delegate];
    YTPlayerView *v = (YTPlayerView *)p.view;
    YTSingleVideoController *single = [(YTPlaybackControllerUIWrapper *)[v valueForKey:@"_playerViewDelegate"] contentVideo];
    YTLocalPlaybackController *local = [single delegate];
    YTPlayerPIPController *controller = [local valueForKey:@"_playerPIPController"];
    if ([controller canInvokePictureInPicture])
        [(MLPIPController *)[controller valueForKey:@"_pipController"] startPictureInPicture];
}

%end

%hook AVPlayerController

- (void)setPictureInPictureSupported:(BOOL)supported {
    %orig(YES);
}

%end

%hook YTIBackgroundOfflineSettingCategoryEntryRenderer

- (BOOL)isBackgroundEnabled {
	return YES;
}

%end

%hook YTBackgroundabilityPolicy

- (void)updateIsBackgroundableByUserSettings {
	%orig;
	MSHookIvar<BOOL>(self, "_backgroundableByUserSettings") = YES;
}

%end

%hook YTIosMediaHotConfig

- (BOOL)enablePictureInPicture {
	return YES;
}

%end

%hook MLPIPController

- (BOOL)isPictureInPictureSupported {
	%orig;
    [(YTIosMediaHotConfig *)[(YTHotConfig *)[[self gimme] instanceForType:NSClassFromString(@"YTHotConfig")] mediaHotConfig] setEnablePictureInPicture:YES];
    return YES;
}

%end

// This is where magic occurs! (cr. @PoomSmart)
// I however would leave the other hooks here just in case
%hook YTAppModule

- (void)configureWithBinder:(GIMBindingBuilder *)binder {
    %orig;
    [[[[binder bindType:NSClassFromString(@"MLPIPController")] retain] autorelease] initializedWith:^(MLPIPController *controller) {
        MLPIPController *value = [controller initWithPlaceholderPlayerItemResourcePath:@"/Library/Application Support/YouPIP/PlaceholderVideo.mp4"];
        [value initializePictureInPicture];
        return value;
    }];
}

%end

%group LateLateHook

%hook YTIPictureInPictureRenderer

- (BOOL)playableInPip {
	return YES;
}

%end

%hook YTIPictureInPictureSupportedRenderers

// Deprecated
- (BOOL)hasPictureInPictureRenderer {
    return YES;
}

%end

%end

BOOL override = NO;

%hook YTSingleVideo

- (BOOL)isLivePlayback {
    return override ? NO : %orig;
}

%end

%hook YTPlayerPIPController

- (BOOL)canInvokePictureInPicture {
    override = YES;
    BOOL orig = %orig;
    override = NO;
    return orig;
}

- (void)appWillResignActive:(id)arg {
    return;
}

%end

%group LateHook

%hook YTIPlayabilityStatus

- (BOOL)isPlayableInPictureInPicture {
    %init(LateLateHook);
    return %orig;
}

- (void)setHasPictureInPicture:(BOOL)arg {
    %orig(YES);
}

%end

// Deprecated
%hook YTIIosMediaHotConfig

- (BOOL)enablePictureInPicture {
	return YES;
}

%end

%end

%hook YTBaseInnerTubeService

+ (void)initialize {
    %orig;
    %init(LateHook);
}

%end

%hook YTIInnertubeResourcesIosRoot

+ (GPBExtensionRegistry *)extensionRegistry {
    GPBExtensionRegistry *registry = %orig;
    id extension = [NSClassFromString(@"YTIPictureInPictureRendererRoot") pictureInPictureRenderer];
    [registry addExtension:extension];
    return registry;
}

%end

%hook GoogleGlobalExtensionRegistry

+ (GPBExtensionRegistry *)extensionRegistry {
    GPBExtensionRegistry *registry = %orig;
    id extension = [NSClassFromString(@"YTIPictureInPictureRendererRoot") pictureInPictureRenderer];
    [registry addExtension:extension];
    return registry;
}

%end

%ctor {
    %init;
}
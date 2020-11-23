#import <UIKit/UIImage+Private.h>
#import <AVKit/AVKit.h>
#import <version.h>

@class MLVideo, MLInnerTubePlayerConfig;

@protocol MLPlayerViewProtocol
- (void)makeActivePlayer;
- (void)setVideo:(MLVideo *)video playerConfig:(MLInnerTubePlayerConfig *)playerConfig;
@end

@protocol MLHAMPlayerViewProtocol
- (void)makeActivePlayer;
- (void)setVideo:(MLVideo *)video playerConfig:(MLInnerTubePlayerConfig *)playerConfig;
@end

@protocol HAMPixelBufferRenderingView
@end

@interface GPBExtensionRegistry : NSObject
- (void)addExtension:(id)extension;
@end

@interface GoogleGlobalExtensionRegistry : NSObject
- (GPBExtensionRegistry *)extensionRegistry;
@end

@interface YTIPictureInPictureRendererRoot : NSObject
+ (id)pictureInPictureRenderer;
@end

@interface YTIosMediaHotConfig : NSObject
- (BOOL)enablePictureInPicture;
- (void)setEnablePictureInPicture:(BOOL)enabled;
@end

@interface YTHotConfig : NSObject
- (YTIosMediaHotConfig *)mediaHotConfig;
@end

@interface YTPlayerStatus : NSObject
@end

@interface GIMMe
- (instancetype)allocOf:(Class)cls;
- (id)nullableInstanceForType:(id)type;
- (id)instanceForType:(id)type;
@end

@interface MLAVPlayerLayerView : UIView <MLPlayerViewProtocol, HAMPixelBufferRenderingView>
@end

@interface MLAVPIPPlayerLayerView : MLAVPlayerLayerView
- (AVPlayerLayer *)playerLayer;
@end

@interface MLHAMSBDLSampleBufferRenderingView : MLAVPIPPlayerLayerView
@end

@interface MLPIPController : NSObject <AVPictureInPictureControllerDelegate>
@property(retain, nonatomic) MLAVPIPPlayerLayerView *AVPlayerView;
@property(retain, nonatomic) MLHAMSBDLSampleBufferRenderingView *HAMPlayerView;
- (id)initWithPlaceholderPlayerItemResourcePath:(NSString *)placeholderPath;
- (BOOL)isPictureInPictureSupported;
- (BOOL)isPictureInPictureActive;
- (GIMMe *)gimme;
- (MLAVPIPPlayerLayerView *)playerLayerView;
- (void)setGimme:(GIMMe *)gimme;
- (void)initializePictureInPicture;
- (BOOL)startPictureInPicture;
- (void)stopPictureInPicture;
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

@interface MLInnerTubePlayerConfig : NSObject
@end

@interface MLPlayerStickySettings : NSObject
@property(assign) float rate;
@end

@interface MLAVPlayer : AVPlayer
@property(assign) BOOL active;
@property(assign) float rate;
- (instancetype)initWithVideo:(MLVideo *)video playerConfig:(MLInnerTubePlayerConfig *)playerConfig stickySettings:(MLPlayerStickySettings *)stickySettings externalPlaybackActive:(BOOL)externalPlaybackActive;
- (GIMMe *)gimme;
- (MLVideo *)video;
- (MLInnerTubePlayerConfig *)config;
- (UIView <MLPlayerViewProtocol> *)playerView;
- (UIView <MLPlayerViewProtocol> *)renderingView;
- (BOOL)externalPlaybackActive;
- (void)setRenderingView:(UIView <MLPlayerViewProtocol> *)renderingView;
@end

@interface MLHAMPlayer : AVPlayer
- (instancetype)initWithVideo:(MLVideo *)video playerConfig:(MLInnerTubePlayerConfig *)playerConfig stickySettings:(MLPlayerStickySettings *)stickySettings playerViewProvider:(id)playerViewProvider;
@end

@interface MLPlayerPool : NSObject
- (void)createHamResourcesForVideo:(MLVideo *)video playerConfig:(MLInnerTubePlayerConfig *)playerConfig;
- (GIMMe *)gimme;
@end

@interface YTSingleVideo : NSObject
- (MLVideo *)video;
@end

@interface YTIFormatStream : NSObject
- (NSString *)URL;
@end

@interface MLFormat : NSObject
@end

@class YTLocalPlaybackController;

@interface YTSingleVideoController : NSObject
- (YTSingleVideo *)singleVideo;
- (YTSingleVideo *)videoData;
- (YTLocalPlaybackController *)delegate;
- (NSArray <MLFormat *> *)selectableVideoFormats;
@end

@interface YTPlaybackControllerUIWrapper : NSObject
- (YTSingleVideoController *)activeVideo;
- (YTSingleVideoController *)contentVideo;
@end

@interface YTPlayerViewController : UIViewController
@end

@interface YTPlayerView : UIView
@property(retain, nonatomic) MLAVPIPPlayerLayerView *pipRenderingView;
@property(retain, nonatomic) MLAVPlayerLayerView *renderingView;
- (YTPlaybackControllerUIWrapper *)playerViewDelegate;
@end

@interface YTPlayerPIPController : NSObject
@property(retain, nonatomic) YTSingleVideoController *activeSingleVideo;
- (instancetype)initWithPlayerView:(id)playerView delegate:(id)delegate;
- (BOOL)isPictureInPictureActive;
- (BOOL)canInvokePictureInPicture;
- (void)maybeInvokePictureInPicture;
- (void)play;
- (void)pause;
@end

@interface YTLocalPlaybackController : NSObject {
    YTPlayerPIPController *_playerPIPController;
}
- (GIMMe *)gimme;
@end

@interface GIMBindingBuilder : NSObject
- (GIMBindingBuilder *)bindType:(Class)type;
- (GIMBindingBuilder *)initializedWith:(id (^)(id))block;
@end

@interface QTMIcon : NSObject
+ (UIImage *)imageWithName:(NSString *)name color:(UIColor *)color;
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

@interface MLDefaultPlayerViewFactory : NSObject
- (BOOL)canUsePlayerView:(UIView *)playerView forVideo:(MLVideo *)video playerConfig:(MLInnerTubePlayerConfig *)config;
- (MLAVPlayerLayerView *)AVPlayerViewForVideo:(MLVideo *)video playerConfig:(MLInnerTubePlayerConfig *)config;
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
        [[self valueForKey:@"_topControlsAccessibilityContainerView"] addSubview:self.pipButton];
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
    YTLocalPlaybackController *local = [p valueForKey:@"_playbackController"];
    YTPlayerPIPController *controller = [local valueForKey:@"_playerPIPController"];
    [controller maybeInvokePictureInPicture];
}

%end

static BOOL overridePictureInPicture = NO;
static BOOL isInPictureInPicture = NO;

%hook YTLocalPlaybackController

- (id)initWithParentResponder:(id)arg2 overlayFactory:(id)arg3 playerView:(id)playerView playbackControllerDelegate:(id)arg5 viewportSizeProvider:(id)arg6 lightweightPlayback:(bool)arg7 {
    self = %orig;
    if ([self valueForKey:@"_playerPIPController"] == nil) {
        YTPlayerPIPController *pip = [(YTPlayerPIPController *)[[self gimme] allocOf:%c(YTPlayerPIPController)] initWithPlayerView:playerView delegate:self];
        // YTPlayerPIPController *pip = [[[NSClassFromString(@"YTPlayerPIPController") alloc] initWithPlayerView:playerView delegate:self] retain];
        [self setValue:pip forKey:@"_playerPIPController"];
        // HBLogDebug(@"Youpip f %d", %c(YTPlayerPIPController) != NULL);
        HBLogDebug(@"Youpip %d %@", pip != nil, [self valueForKey:@"_playerPIPController"]);
    }
    return self;
}

- (void)videoSequence:(id)sequence didActivateVideoController:(YTSingleVideoController *)videoController {
    %orig;
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        YTPlayerPIPController *pip = [self valueForKey:@"_playerPIPController"];
        [pip setActiveSingleVideo:videoController];
    }
}

- (void)resetWithCurrentVideoSequencer {
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        YTPlayerPIPController *pip = [self valueForKey:@"_playerPIPController"];
        [pip setActiveSingleVideo:nil];
    }
    %orig;
}

- (void)resetToState:(int)state {
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        YTPlayerPIPController *pip = [self valueForKey:@"_playerPIPController"];
        [pip setActiveSingleVideo:nil];
    }
    %orig;
}

- (void)play {
    %orig;
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        YTPlayerPIPController *pip = [self valueForKey:@"_playerPIPController"];
        [pip play];
    }
}

- (void)pause {
    %orig;
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        YTPlayerPIPController *pip = [self valueForKey:@"_playerPIPController"];
        [pip pause];
    }
}

- (YTPlayerStatus *)playerStatusWithPlayerViewLayout:(int)layout {
    overridePictureInPicture = !IS_IOS_OR_NEWER(iOS_14_0);
    if (overridePictureInPicture) {
        YTPlayerPIPController *pip = [self valueForKey:@"_playerPIPController"];
        isInPictureInPicture = [pip isPictureInPictureActive];
    }
    YTPlayerStatus *status = %orig;
    overridePictureInPicture = NO;
    return status;
}

%end

%hook MLHAMQueuePlayer

- (id)initWithStickySettings:(id)stickySettings playerViewProvider:(id)playerViewProvider playerConfiguration:(id)playerConfiguration {
    self = %orig;
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        [self setValue:[[self gimme] nullableInstanceForType:%c(MLPIPController)] forKey:@"_pipController"];
    }
    return self;
}

%end

%hook MLAVPlayer

- (bool)isPictureInPictureActive {
    return [(MLPIPController *)[[self gimme] nullableInstanceForType:%c(MLPIPController)] isPictureInPictureActive];
}

%end

%hook MLPlayerPoolImpl

- (id)init {
    id r = %orig;
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        MLPIPController *pip = (MLPIPController *)[[self gimme] nullableInstanceForType:%c(MLPIPController)];
        [r setValue:pip forKey:@"_pipController"];
    }
    return r;
}

- (void)setActivePlayer:(MLAVPlayer *)player {
    %orig;
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        UIView <MLPlayerViewProtocol> *renderingView = [self valueForKey:@"_renderingView"];
        MLPIPController *pip = [self valueForKey:@"_pipController"];
        if ([renderingView isKindOfClass:%c(MLAVPIPPlayerLayerView)]) {
            [pip setAVPlayerView:(MLAVPIPPlayerLayerView *)renderingView];
        } else if ([renderingView isKindOfClass:%c(MLHAMSBDLSampleBufferRenderingView)]) {
            [pip setHAMPlayerView:(MLHAMSBDLSampleBufferRenderingView *)renderingView];
        }
    }
}

%end

%hook YTPlayerStatus

- (id)initWithExternalPlayback:(BOOL)externalPlayback
    backgroundPlayback:(BOOL)backgroundPlayback
    inlinePlaybackActive:(BOOL)inlinePlaybackActive
    cardboardModeActive:(BOOL)cardboardModeActive
    layout:(int)layout
    userAudioOnlyModeActive:(BOOL)userAudioOnlyModeActive
    blackoutActive:(BOOL)blackoutActive
    clipID:(id)clipID
    accountLinkState:(id)accountLinkState
    muted:(BOOL)muted
    pictureInPicture:(BOOL)pictureInPicture {
        return %orig(externalPlayback,
            backgroundPlayback,
            inlinePlaybackActive,
            cardboardModeActive,
            layout,
            userAudioOnlyModeActive,
            blackoutActive,
            clipID,
            accountLinkState,
            muted,
            overridePictureInPicture ? isInPictureInPicture : pictureInPicture);
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
    [(YTIosMediaHotConfig *)[(YTHotConfig *)[[self gimme] instanceForType:%c(YTHotConfig)] mediaHotConfig] setEnablePictureInPicture:YES];
    return YES;
}

%end

%hook MLModule

- (void)configureWithBinder:(GIMBindingBuilder *)binder {
    %orig;
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        // [[binder bindType:%c(MLPIPController)] initializedWith:^(MLPIPController *controller) {
        //     NSBundle *mainBundle = [NSBundle mainBundle];
        //     NSString *assetPath = [mainBundle pathForResource:@"PiPPlaceholderAsset" ofType:@"mp4"];
        //     MLPIPController *value = [controller initWithPlaceholderPlayerItemResourcePath:assetPath];
        //     return value;
        // }];
        [binder bindType:%c(MLPIPController)];
    }
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

%end

%group LateHook

%hook YTIPlayabilityStatus

- (BOOL)isPlayableInPictureInPicture {
    %init(LateLateHook);
    return %orig;
}

- (BOOL)hasPictureInPicture {
    return YES;
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

%ctor {
    %init;
}
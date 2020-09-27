#import <UIKit/UIImage+Private.h>
#import <AVKit/AVKit.h>
#import <version.h>

@class MLVideo, MLInnerTubePlayerConfig;

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

@interface MLAVPlayerLayerView : UIView <MLHAMPlayerViewProtocol>
@end

@interface MLAVPIPPlayerLayerView : MLAVPlayerLayerView
- (AVPlayerLayer *)layer;
@end

@interface MLPIPController : NSObject <AVPictureInPictureControllerDelegate>
- (id)initWithPlaceholderPlayerItemResourcePath:(NSString *)placeholderPath;
- (BOOL)isPictureInPictureSupported;
- (BOOL)isPictureInPictureActive;
- (GIMMe *)gimme;
- (MLAVPIPPlayerLayerView *)playerLayerView;
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
- (UIView <MLHAMPlayerViewProtocol> *)playerView;
- (UIView <HAMPixelBufferRenderingView> *)renderingView;
- (BOOL)externalPlaybackActive;
- (void)setRenderingView:(UIView <HAMPixelBufferRenderingView> *)renderingView;
@end

@interface MLPlayerPool : NSObject
- (GIMMe *)gimme;
@end

@interface YTSingleVideo : NSObject
- (MLVideo *)video;
@end

@class YTLocalPlaybackController;

@interface YTSingleVideoController : NSObject
- (YTSingleVideo *)singleVideo;
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
@property(retain, nonatomic) YTSingleVideoController *activeSingleVideo;
- (instancetype)initWithPlayerView:(id)playerView delegate:(id)delegate;
- (BOOL)isPictureInPictureActive;
- (BOOL)canInvokePictureInPicture;
- (void)maybeInvokePictureInPicture;
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

@interface AVPlayerLayer (Private)
@property(assign) BOOL PIPModeEnabled;
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
    MLPIPController *pip = (MLPIPController *)[controller valueForKey:@"_pipController"];
    if ([pip valueForKey:@"_pictureInPictureController"] == nil) {
        MLAVPIPPlayerLayerView *pipLayer = [pip valueForKey:@"_pipPlayerLayerView"];
        AVPlayerLayer *avLayer = [pipLayer layer];
        avLayer.PIPModeEnabled = YES;
        AVPictureInPictureController *avpip = [[AVPictureInPictureController alloc] initWithPlayerLayer:avLayer];
        avpip.delegate = pip;
        [pip setValue:avpip forKey:@"_pictureInPictureController"];
    }
    if ([controller canInvokePictureInPicture]) {
        if ([pip respondsToSelector:@selector(startPictureInPicture)])
            [pip startPictureInPicture];
        else {
            AVPictureInPictureController *avpip = [pip valueForKey:@"_pictureInPictureController"];
            [avpip startPictureInPicture];
        }
    }
}

%end

static BOOL overridePictureInPicture = NO;
static BOOL isInPictureInPicture = NO;

%hook YTLocalPlaybackController

- (id)initWithParentResponder:(id)arg2 overlayFactory:(id)arg3 playerView:(id)playerView playbackControllerDelegate:(id)arg5 viewportSizeProvider:(id)arg6 lightweightPlayback:(bool)arg7 {
    id r = %orig;
    if ([self valueForKey:@"_playerPIPController"] == nil) {
        YTPlayerPIPController *pip = [(YTPlayerPIPController *)[[self gimme] allocOf:%c(YTPlayerPIPController)] initWithPlayerView:playerView delegate:self];
        [self setValue:pip forKey:@"_playerPIPController"];
    }
    return r;
}

- (void)videoSequencer:(id)arg2 didActivateVideoController:(YTSingleVideoController *)videoController {
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

- (void)resetToState:(int)arg2 {
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        YTPlayerPIPController *pip = [self valueForKey:@"_playerPIPController"];
        [pip setActiveSingleVideo:nil];
    }
    %orig;
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

%hook MLAVPlayer

- (bool)isPictureInPictureActive {
    return [(MLPIPController *)[[self gimme] nullableInstanceForType:%c(MLPIPController)] isPictureInPictureActive];
}

%end

%hook MLPlayerPool

- (id)init {
    id r = %orig;
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        MLPIPController *pip = (MLPIPController *)[[self gimme] nullableInstanceForType:%c(MLPIPController)];
        [r setValue:pip forKey:@"_pipController"];
    }
    return r;
}

- (MLAVPlayer *)acquirePlayerForVideo:(MLVideo *)video playerConfig:(MLInnerTubePlayerConfig *)playerConfig stickySettings:(MLPlayerStickySettings *)stickySettings {
    MLAVPlayer *player = [(MLAVPlayer *)[[self gimme] allocOf:%c(MLAVPlayer)] initWithVideo:video playerConfig:playerConfig stickySettings:stickySettings externalPlaybackActive:[(MLAVPlayer *)[self valueForKey:@"_activePlayer"] externalPlaybackActive]];
    if (stickySettings)
        player.rate = stickySettings.rate;
    return player;
}

- (void)setActivePlayer:(MLAVPlayer *)player {
    %orig;
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        if ([player isKindOfClass:%c(MLAVPlayer)]) {
            MLDefaultPlayerViewFactory *factory = [self valueForKey:@"_playerViewFactory"];
            MLVideo *video = [player video];
            MLInnerTubePlayerConfig *config = [player config];
            MLPIPController *pip = [self valueForKey:@"_pipController"];
            MLAVPIPPlayerLayerView *layerView = [pip playerLayerView];
            if (layerView) {
                if ([factory canUsePlayerView:layerView forVideo:video playerConfig:config]) {
                    [layerView setVideo:video playerConfig:config];
                    [player setRenderingView:(id)layerView];
                }
            }
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
    [(YTIosMediaHotConfig *)[(YTHotConfig *)[[self gimme] instanceForType:%c(YTHotConfig)] mediaHotConfig] setEnablePictureInPicture:YES];
    return YES;
}

%end

%hook YTAppModule

- (void)configureWithBinder:(GIMBindingBuilder *)binder {
    %orig;
    if (!IS_IOS_OR_NEWER(iOS_14_0)) {
        [[binder bindType:%c(MLPIPController)] initializedWith:^(MLPIPController *controller) {
            NSBundle *mainBundle = [NSBundle mainBundle];
            NSString *assetPath = [mainBundle pathForResource:@"PiPPlaceholderAsset" ofType:@"mp4"];
            MLPIPController *value = [controller initWithPlaceholderPlayerItemResourcePath:assetPath];
            if ([value respondsToSelector:@selector(initializePictureInPicture)])
                [value initializePictureInPicture];
            return value;
        }];
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
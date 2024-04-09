#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <CaptainHook/CaptainHook.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <sys/utsname.h>
#import <substrate.h>
#import <rootless.h>

#import "uYouPlusThemes.h" // Hide "Buy Super Thanks" banner (_ASDisplayView)
#import <YoutubeHeader/YTAppDelegate.h> // Activate FLEX
#import <YoutubeHeader/YTIMenuConditionalServiceItemRenderer.h>
#import <YoutubeHeader/YTIPlayerBarDecorationModel.h>
#import <YoutubeHeader/YTPlayerBarRectangleDecorationView.h>
#import <YoutubeHeader/YTVideoQualitySwitchOriginalController.h>
#import <YoutubeHeader/YTIGuideResponse.h>
#import <YoutubeHeader/YTIGuideResponseSupportedRenderers.h>
#import <YoutubeHeader/YTIPivotBarSupportedRenderers.h>
#import <YoutubeHeader/YTIPivotBarItemRenderer.h>
#import <YoutubeHeader/YTIBrowseRequest.h>
#import <YoutubeHeader/YTIButtonRenderer.h>
#import <YoutubeHeader/YTIElementRenderer.h>
#import <YoutubeHeader/YTISectionListRenderer.h>
#import <YoutubeHeader/YTWatchNextResultsViewController.h>
#import <YoutubeHeader/YTPlayerOverlay.h>
#import <YoutubeHeader/YTPlayerOverlayProvider.h>
#import <YoutubeHeader/YTReelWatchPlaybackOverlayView.h>
#import <YoutubeHeader/YTInlinePlayerBarContainerView.h>
#import <YoutubeHeader/YTInnerTubeCollectionViewController.h>
#import <YoutubeHeader/YTPivotBarItemView.h>
#import <YoutubeHeader/YTCollectionViewCell.h>

// Hide buttons under the video player by @PoomSmart
#import <YouTubeHeader/ASCollectionElement.h>
#import <YouTubeHeader/ASCollectionView.h>
#import <YouTubeHeader/ELMNodeController.h>

// YouTube-X
#import <YouTubeHeader/YTVideoWithContextNode.h>
#import <YouTubeHeader/ELMCellNode.h>

#define LOC(x) [tweakBundle localizedStringForKey:x value:nil table:nil]
#define IS_ENABLED(k) [[NSUserDefaults standardUserDefaults] boolForKey:k]
#define APP_THEME_IDX [[NSUserDefaults standardUserDefaults] integerForKey:@"appTheme"]
#define YT_BUNDLE_ID @"com.google.ios.youtube"
#define YT_NAME @"YouTube"
#define DEFAULT_RATE 1.0f // YTSpeed
#define LOWCONTRASTMODE_CUTOFF_VERSION @"17.38.10" // LowContrastMode (v17.33.2-17.38.10)

// IAmYouTube
@interface SSOConfiguration : NSObject
@end

// Hide Double tap to seek Overlay
@interface YTInlinePlayerDoubleTapIndicatorView : UIView
@property (nonatomic, strong) UIView *scrimOverlay;
@end

// YTTapToSeek - https://github.com/bhackel/YTTapToSeek
@interface YTMainAppVideoPlayerOverlayViewController : UIViewController
- (CGFloat)totalTime;
@end

// Enable Premium logo - @bhackel
@interface YTITopbarLogoRenderer : NSObject
@property(readonly, nonatomic) YTIIcon *iconImage;
@end

// uYouPlus
@interface YTHeaderLogoController : UIView
@property(readonly, nonatomic) long long pageStyle;
@end

@interface YTNavigationBarTitleView : UIView
@end

@interface YTChipCloudCell : UIView
@end

@interface YTPlayabilityResolutionUserActionUIController : NSObject // Skips content warning before playing *some videos - @PoomSmart
- (void)confirmAlertDidPressConfirm;
@end

@interface YTMainAppControlsOverlayView : UIView
@property(readonly, nonatomic) YTQTMButton *watchCollapseButton;
@end

@interface YTTransportControlsButtonView : UIView
@end

@interface YTFullscreenActionsView : UIView
@end

@interface _ASCollectionViewCell : UICollectionViewCell
- (id)node;
@end

@interface YTAsyncCollectionView : UICollectionView
@end

@interface FRPSliderCell : UITableViewCell
@end

@interface boolSettingsVC : UIViewController
@end

@interface YTPlaybackButton : UIControl
@end

@interface YTPlaylistHeaderViewController : UIViewController
@property UIButton *downloadsButton;
@end

// Buttons
@interface YTRightNavigationButtons : UIView
- (id)_viewControllerForAncestor;
@property(readonly, nonatomic) YTQTMButton *searchButton;
@property(readonly, nonatomic) YTQTMButton *notificationButton;
@property(strong, nonatomic) YTQTMButton *sponsorBlockButton;
@property(strong, nonatomic) YTQTMButton *uYouPlusButton;
- (void)setLeadingPadding:(CGFloat)arg1;
- (void)uYouPlusRootOptionsAction;
@end

@interface YTISlimMetadataButtonSupportedRenderers : NSObject
- (id)slimButton_buttonRenderer;
- (id)slimMetadataButtonRenderer;
@end

// YTSpeed
@interface YTVarispeedSwitchControllerOption : NSObject
- (id)initWithTitle:(id)title rate:(float)rate;
@end

@interface MLHAMQueuePlayer : NSObject
@property id playerEventCenter;
@property id delegate;
- (void)setRate:(float)rate;
- (void)internalSetRate;
@end

@interface MLPlayerStickySettings (uYouPlus)
- (void)setRate:(float)rate;
@end

@interface MLPlayerEventCenter : NSObject
- (void)broadcastRateChange:(float)rate;
@end

@interface HAMPlayerInternal : NSObject
- (void)setRate:(float)rate;
@end

// App Theme
@interface YTColor : NSObject
+ (UIColor *)white1;
+ (UIColor *)white2;
+ (UIColor *)white3;
+ (UIColor *)white4;
+ (UIColor *)white5;
+ (UIColor *)black0;
+ (UIColor *)black1;
+ (UIColor *)black2;
+ (UIColor *)black3;
+ (UIColor *)black4;
+ (UIColor *)blackPure;
+ (UIColor *)grey1;
+ (UIColor *)grey2;
@end

@interface YTPageStyleController
+ (NSInteger)pageStyle;
@end

@interface YCHLiveChatView : UIView
@end

@interface ELMView : UIView
@end

@interface ELMContainerNode : NSObject
@end

@interface YTAutonavEndscreenView : UIView
@end

@interface YTPivotBarIndicatorView : UIView
@end

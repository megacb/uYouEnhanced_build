#import "Tweaks/YouTubeHeader/YTPlayerViewController.h"

// IAmYouTube
@interface SSOConfiguration : NSObject
@end

// uYouPlus
@interface YTMainAppControlsOverlayView: UIView
@end

@interface YTPlaylistHeaderViewController : UIViewController
@property (nonatomic, strong, readwrite) UIView *downloadsButton;
@end

// BigYTMiniPlayer
@interface YTMainAppVideoPlayerOverlayView : UIView
- (UIViewController *)_viewControllerForAncestor;
@end

@interface YTWatchMiniBarView : UIView
@end

// YTAutoFullScreen
@interface YTPlayerViewController (YTAFS)
- (void)autoFullscreen;
@end

// OLED Darkmode
@interface ASWAppSwitcherCollectionViewCell: UIView
@end

@interface ASScrollView : UIView
@end

@interface UIKeyboardLayoutStar : UIView
@end

@interface UIKeyboardDockView : UIView
@end

@interface UICandidateViewController : UIViewController
@end

@interface UIPredictionViewController : UIViewController
@end

@interface SponsorBlockSettingsController : UITableViewController 
@end

@interface _ASDisplayView : UIView
@end
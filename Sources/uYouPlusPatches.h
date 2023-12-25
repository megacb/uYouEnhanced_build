#import "../Tweaks/YouTubeHeader/YTCommonColorPalette.h"
#import "uYouPlus.h"

// Prevent uYou player bar from showing when not playing downloaded media
@interface PlayerManager : NSObject
- (float)progress;
@end

// iOS 16 uYou crash fix - @level3tjg: https://github.com/qnblackcat/uYouPlus/pull/224
@interface OBPrivacyLinkButton : UIButton
- (instancetype)initWithCaption:(NSString *)caption
                     buttonText:(NSString *)buttonText
                          image:(UIImage *)image
                      imageSize:(CGSize)imageSize
                   useLargeIcon:(BOOL)useLargeIcon
                displayLanguage:(NSString *)displayLanguage;
@end

// uYouLocal fix
// @interface YTLocalPlaybackController : NSObject
// - (id)activeVideo;
// @end

// uYou theme fix
// @interface YTAppDelegate ()
// @property(nonatomic, strong) id downloadsVC;
// @end

// Fix uYou's appearance not updating if the app is backgrounded
@interface DownloadsPagerVC : UIViewController
- (NSArray<UIViewController *> *)viewControllers;
- (void)updatePageStyles;
@end
@interface DownloadingVC : UIViewController
- (void)updatePageStyles;
- (UITableView *)tableView;
@end
@interface DownloadingCell : UITableViewCell
- (void)updatePageStyles;
@end
@interface DownloadedVC : UIViewController
- (void)updatePageStyles;
- (UITableView *)tableView;
@end
@interface DownloadedCell : UITableViewCell
- (void)updatePageStyles;
@end
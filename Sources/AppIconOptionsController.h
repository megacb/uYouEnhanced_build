#import <UIKit/UIKit.h>

@interface AppIconOptionsController : UIViewController

@property (strong, nonatomic) UIButton *backButton;

@end

@interface UIImage (CustomImages)

+ (UIImage *)customBackButtonImage;

@end

@implementation UIImage (CustomImages)

+ (UIImage *)customBackButtonImage {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"uYouPlus" ofType:@"bundle"]];
    return [UIImage imageNamed:@"Back.png" inBundle:bundle compatibleWithTraitCollection:nil];
}

@end

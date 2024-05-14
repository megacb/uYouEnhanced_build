#import "RootOptionsController.h"
#import "ColourOptionsController.h"
#import "ColourOptionsController2.h"

@interface RootOptionsController ()

- (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)newSize;
@property (strong, nonatomic) UIButton *backButton;
@property (assign, nonatomic) UIUserInterfaceStyle pageStyle;

@end

@implementation RootOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"uYouEnhanced Extras Menu";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"YTSans-Bold" size:22], NSForegroundColorAttributeName: [UIColor whiteColor]}];

    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSBundle *backIcon = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"uYouPlus" ofType:@"bundle"]];
    UIImage *backImage = [UIImage imageNamed:@"Back.png" inBundle:backIcon compatibleWithTraitCollection:nil];
    backImage = [self resizeImage:backImage newSize:CGSizeMake(24, 24)];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton setTintColor:[UIColor whiteColor]];
    [self.backButton setImage:backImage forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setFrame:CGRectMake(0, 0, 24, 24)];
    UIBarButtonItem *customBackButton = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = customBackButton;

    UITableViewStyle style;
    if (@available(iOS 13, *)) {
        style = UITableViewStyleInsetGrouped;
    } else {
        style = UITableViewStyleGrouped;
    }

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.tableView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.tableView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [self.tableView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor]
    ]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RootTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.shadowColor = [UIColor blackColor];
            cell.textLabel.shadowOffset = CGSizeMake(1.0, 1.0);
            cell.detailTextLabel.textColor = [UIColor whiteColor];
        }
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Custom Theme Color";
                cell.imageView.image = [UIImage systemImageNamed:@"slider.horizontal.3"];
                cell.imageView.tintColor = cell.textLabel.textColor;
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Custom Tint Color";
                cell.imageView.image = [UIImage systemImageNamed:@"drop.fill"];
                cell.imageView.tintColor = cell.textLabel.textColor;
            }
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Clear Cache";
                UILabel *cache = [[UILabel alloc] init];
                cache.text = [self getCacheSize];
                cache.textColor = [UIColor secondaryLabelColor];
                cache.font = [UIFont systemFontOfSize:16];
                cache.textAlignment = NSTextAlignmentRight;
                [cache sizeToFit];
                cell.accessoryView = cache;
                cell.imageView.image = [UIImage systemImageNamed:@"trash"];
                cell.imageView.tintColor = cell.textLabel.textColor;
            }
        }
    }
    return cell;
}

- (NSString *)getCacheSize {
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:cachePath error:nil];

    unsigned long long int folderSize = 0;
    for (NSString *fileName in filesArray) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        folderSize += [fileAttributes fileSize];
    }

    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    formatter.countStyle = NSByteCountFormatterCountStyleFile;

    return [formatter stringFromByteCount:folderSize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ColourOptionsController *colourOptionsController = [[ColourOptionsController alloc] init];
            UINavigationController *colourOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:colourOptionsController];
            colourOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:colourOptionsControllerView animated:YES completion:nil];
        }
        if (indexPath.row == 1) {
            ColourOptionsController2 *colourOptionsController2 = [[ColourOptionsController2 alloc] init];
            UINavigationController *colourOptionsController2View = [[UINavigationController alloc] initWithRootViewController:colourOptionsController2];
            colourOptionsController2View.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:colourOptionsController2View animated:YES completion:nil];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
            activityIndicator.color = [UIColor labelColor];
            [activityIndicator startAnimating];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryView = activityIndicator;

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
                [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                });
            });
        }
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self.tableView reloadData];
}

@end

@implementation RootOptionsController (Privates)

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

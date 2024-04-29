#import "AppIconOptionsController.h"

@interface AppIconOptionsController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *appIcons;
@property (assign, nonatomic) NSInteger selectedIconIndex;

@end

@implementation AppIconOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Change App Icon";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"YTSans-Bold" size:22], NSForegroundColorAttributeName: [UIColor whiteColor]}];

    self.selectedIconIndex = -1;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back.png" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;

    self.appIcons = [self loadAppIcons];
    [self setupNavigationBar];
}

- (NSArray<NSString *> *)loadAppIcons {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"uYouPlus" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return [bundle pathsForResourcesOfType:@"png" inDirectory:@"AppIcons"];
}

- (void)setupNavigationBar {
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.clockwise.circle.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(resetIcon)];

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveIcon)];
    [self.navigationItem setRightBarButtonItems:@[saveButton, resetButton]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appIcons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSString *iconPath = self.appIcons[indexPath.row];
    UIImage *iconImage = [UIImage imageWithContentsOfFile:iconPath];

    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.frame = CGRectMake(16, 10, 60, 60);
    iconImageView.layer.cornerRadius = 8;
    iconImageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:iconImageView];

    UILabel *iconNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, self.view.frame.size.width - 90, 60)];
    iconNameLabel.text = [iconPath.lastPathComponent stringByDeletingPathExtension];
    iconNameLabel.textColor = [UIColor blackColor];
    iconNameLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [cell.contentView addSubview:iconNameLabel];

    cell.accessoryType = (indexPath.row == self.selectedIconIndex) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

- (void)resetIcon {
    [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error resetting icon: %@", error.localizedDescription);
            [self showAlertWithTitle:@"Error" message:@"Failed to reset icon"];
        } else {
            NSLog(@"Icon reset successfully");
            [self showAlertWithTitle:@"Success" message:@"Icon reset successfully"];
            [self.tableView reloadData];
        }
    }];
}

- (void)saveIcon {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *selectedIcon = self.selectedIconIndex >= 0 ? self.appIcons[self.selectedIconIndex] : nil;
        if (selectedIcon) {
            NSString *iconName = [selectedIcon.lastPathComponent stringByDeletingPathExtension];
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
            NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            NSMutableDictionary *iconsDict = [infoDict objectForKey:@"CFBundleIcons"];
            
            if (iconsDict) {
                NSMutableDictionary *primaryIconDict = [iconsDict objectForKey:@"CFBundlePrimaryIcon"];
                if (primaryIconDict) {
                    NSMutableArray *iconFiles = [primaryIconDict objectForKey:@"CFBundleIconFiles"];
                    [iconFiles addObject:iconName];
                    primaryIconDict[@"CFBundleIconFiles"] = iconFiles;
                }
                [infoDict setObject:iconsDict forKey:@"CFBundleIcons"];
                [infoDict writeToFile:plistPath atomically:YES];
                
                [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Error setting alternate icon: %@", error.localizedDescription);
                        [self showAlertWithTitle:@"Error" message:@"Failed to set alternate icon"];
                    } else {
                        NSLog(@"Alternate icon set successfully");
                        [self showAlertWithTitle:@"Success" message:@"Alternate icon set successfully"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                }];
            } else {
                NSLog(@"CFBundleIcons key not found in Info.plist");
            }
        } else {
            NSLog(@"Selected icon path is nil");
        }
    });
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

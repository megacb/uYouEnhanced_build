#import "Tweaks/YouTubeHeader/YTSettingsViewController.h"
#import "Tweaks/YouTubeHeader/YTSettingsSectionItem.h"
#import "Tweaks/YouTubeHeader/YTSettingsSectionItemManager.h"
#import "Tweaks/YouTubeHeader/YTUIUtils.h"
#import "Header.h"

@interface YTSettingsSectionItemManager (YouPiP)
- (void)updateuYouPlusSectionWithEntry:(id)entry;
@end

static const NSInteger uYouPlusSection = 500;

extern NSBundle *uYouPlusBundle();
extern BOOL hideHUD();
extern BOOL oled();
extern BOOL oledKB();
extern BOOL autoFullScreen();
extern BOOL hideHoverCard();
extern BOOL reExplore();
extern BOOL bigYTMiniPlayer();
extern BOOL hideCC();
extern BOOL hideAutoplaySwitch();
extern BOOL castConfirm();
extern BOOL ytMiniPlayer();
extern BOOL hidePreviousAndNextButton();
extern BOOL hidePaidPromotionCard();
extern BOOL fixGoogleSignIn();
extern BOOL replacePreviousAndNextButton();
extern BOOL dontEatMyContent();

// Settings
%hook YTAppSettingsPresentationData
+ (NSArray *)settingsCategoryOrder {
    NSArray *order = %orig;
    NSMutableArray *mutableOrder = [order mutableCopy];
    NSUInteger insertIndex = [order indexOfObject:@(1)];
    if (insertIndex != NSNotFound)
        [mutableOrder insertObject:@(uYouPlusSection) atIndex:insertIndex + 1];
    return mutableOrder;
}
%end

%hook YTSettingsSectionItemManager
%new 
- (void)updateuYouPlusSectionWithEntry:(id)entry {
    YTSettingsViewController *delegate = [self valueForKey:@"_dataDelegate"];
    NSBundle *tweakBundle = uYouPlusBundle();

    YTSettingsSectionItem *version = [%c(YTSettingsSectionItem)
    itemWithTitle:[NSString stringWithFormat:LOC(@"VERSION"), @(OS_STRINGIFY(TWEAK_VERSION))]
    titleDescription:LOC(@"VERSION_CHECK")
    accessibilityIdentifier:nil
    detailTextBlock:nil
    selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger arg1) {
        return [%c(YTUIUtils) openURL:[NSURL URLWithString:@"https://github.com/qnblackcat/uYouPlus/releases/latest"]];
    }];

    YTSettingsSectionItem *dontEatMyContent = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"DONT_EAT_MY_CONTENT") titleDescription:LOC(@"DONT_EAT_MY_CONTENT_DESC")];
    dontEatMyContent.hasSwitch = YES;
    dontEatMyContent.switchVisible = YES;
    dontEatMyContent.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"dontEatMyContent_enabled"];
    dontEatMyContent.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"dontEatMyContent_enabled"];
        return YES;
    };

    YTSettingsSectionItem *replacePreviousAndNextButton = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"REPLACE_PREVIOUS_NEXT_BUTTON") titleDescription:LOC(@"REPLACE_PREVIOUS_NEXT_BUTTON_DESC")];
    replacePreviousAndNextButton.hasSwitch = YES;
    replacePreviousAndNextButton.switchVisible = YES;
    replacePreviousAndNextButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"replacePreviousAndNextButton_enabled"];
    replacePreviousAndNextButton.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"replacePreviousAndNextButton_enabled"];
        return YES;
    };

    YTSettingsSectionItem *fixGoogleSignIn = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"FIX_GOOGLE_SIGNIN") titleDescription:LOC(@"FIX_GOOGLE_SIGNIN_DESC")];
    fixGoogleSignIn.hasSwitch = YES;
    fixGoogleSignIn.switchVisible = YES;
    fixGoogleSignIn.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"fixGoogleSignIn_enabled"];
    fixGoogleSignIn.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"fixGoogleSignIn_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hidePaidPromotionCard = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"HIDE_PAID_PROMOTION_CARDS") titleDescription:LOC(@"HIDE_PAID_PROMOTION_CARDS_DESC")];
    hidePaidPromotionCard.hasSwitch = YES;
    hidePaidPromotionCard.switchVisible = YES;
    hidePaidPromotionCard.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hidePaidPromotionCard_enabled"];
    hidePaidPromotionCard.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hidePaidPromotionCard_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hidePreviousAndNextButton = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"HIDE_PREVIOUS_AND_NEXT_BUTTON") titleDescription:LOC(@"HIDE_PREVIOUS_AND_NEXT_BUTTON_DESC")];
    hidePreviousAndNextButton.hasSwitch = YES;
    hidePreviousAndNextButton.switchVisible = YES;
    hidePreviousAndNextButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hidePreviousAndNextButton_enabled"];
    hidePreviousAndNextButton.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hidePreviousAndNextButton_enabled"];
        return YES;
    };

    YTSettingsSectionItem *ytMiniPlayer = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"YT_MINIPLAYER") titleDescription:LOC(@"YT_MINIPLAYER_DESC")];
    ytMiniPlayer.hasSwitch = YES;
    ytMiniPlayer.switchVisible = YES;
    ytMiniPlayer.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"ytMiniPlayer_enabled"];
    ytMiniPlayer.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"ytMiniPlayer_enabled"];
        return YES;
    };

    YTSettingsSectionItem *castConfirm = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"CAST_CONFIRM") titleDescription:LOC(@"CAST_CONFIRM_DESC")];
    castConfirm.hasSwitch = YES;
    castConfirm.switchVisible = YES;
    castConfirm.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"castConfirm_enabled"];
    castConfirm.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"castConfirm_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideHoverCard = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"HIDE_HOVER_CARD") titleDescription:LOC(@"HIDE_HOVER_CARD_DESC")];
    hideHoverCard.hasSwitch = YES;
    hideHoverCard.switchVisible = YES;
    hideHoverCard.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideHoverCards_enabled"];
    hideHoverCard.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideHoverCards_enabled"];
        return YES;
    };

    YTSettingsSectionItem *bigYTMiniPlayer = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"NEW_MINIPLAYER_STYLE") titleDescription:LOC(@"NEW_MINIPLAYER_STYLE_DESC")];
    bigYTMiniPlayer.hasSwitch = YES;
    bigYTMiniPlayer.switchVisible = YES;
    bigYTMiniPlayer.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"bigYTMiniPlayer_enabled"];
    bigYTMiniPlayer.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"bigYTMiniPlayer_enabled"];
        return YES;
    };

    YTSettingsSectionItem *reExplore = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"YT_RE_EXPLORE") titleDescription:LOC(@"YT_RE_EXPLORE_DESC")];
    reExplore.hasSwitch = YES;
    reExplore.switchVisible = YES;
    reExplore.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"reExplore_enabled"];
    reExplore.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"reExplore_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideCC = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"HIDE_SUBTITLES_BUTTON") titleDescription:LOC(@"HIDE_SUBTITLES_BUTTON_DESC")];
    hideCC.hasSwitch = YES;
    hideCC.switchVisible = YES;
    hideCC.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideCC_enabled"];
    hideCC.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideCC_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideAutoplaySwitch = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"HIDE_AUTOPLAY_SWITCH") titleDescription:LOC(@"HIDE_AUTOPLAY_SWITCH_DESC")];
    hideAutoplaySwitch.hasSwitch = YES;
    hideAutoplaySwitch.switchVisible = YES;
    hideAutoplaySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideAutoplaySwitch_enabled"];
    hideAutoplaySwitch.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideAutoplaySwitch_enabled"];
        return YES;
    };

    YTSettingsSectionItem *autoFull = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"AUTO_FULLSCREEN") titleDescription:LOC(@"AUTO_FULLSCREEN_DESC")];
    autoFull.hasSwitch = YES;
    autoFull.switchVisible = YES;
    autoFull.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoFull_enabled"];
    autoFull.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"autoFull_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideHUD = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"HIDE_HUD_MESSAGES") titleDescription:LOC(@"HIDE_HUD_MESSAGES_DESC")];
    hideHUD.hasSwitch = YES;
    hideHUD.switchVisible = YES;
    hideHUD.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideHUD_enabled"];
    hideHUD.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideHUD_enabled"];
        return YES;
    };

    YTSettingsSectionItem *oledDarkMode = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"OLED_DARKMODE") titleDescription:LOC(@"OLED_DARKMODE_DESC")];
    oledDarkMode.hasSwitch = YES;
    oledDarkMode.switchVisible = YES;
    oledDarkMode.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"oled_enabled"];
    oledDarkMode.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"oled_enabled"];
        return YES;
    };

    YTSettingsSectionItem *oledKeyBoard = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"OLED_KEYBOARD") titleDescription:LOC(@"OLED_KEYBOARD_DESC")];
    oledKeyBoard.hasSwitch = YES;
    oledKeyBoard.switchVisible = YES;
    oledKeyBoard.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"oledKeyBoard_enabled"];
    oledKeyBoard.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"oledKeyBoard_enabled"];
        return YES;
    };

    NSMutableArray <YTSettingsSectionItem *> *sectionItems = [NSMutableArray arrayWithArray:@[version, autoFull, castConfirm, ytMiniPlayer, fixGoogleSignIn, hideAutoplaySwitch, hideCC, hideHUD, hidePaidPromotionCard, hidePreviousAndNextButton, hideHoverCard, bigYTMiniPlayer, oledDarkMode, oledKeyBoard, dontEatMyContent, replacePreviousAndNextButton, reExplore]];
    [delegate setSectionItems:sectionItems forCategory:uYouPlusSection title:@"uYouPlus" titleDescription:nil headerHidden:NO];
}

- (void)updateSectionForCategory:(NSUInteger)category withEntry:(id)entry {
    if (category == uYouPlusSection) {
        [self updateuYouPlusSectionWithEntry:entry];
        return;
    }
    %orig;
}
%end

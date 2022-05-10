#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Header.h"
#import "Tweaks/YouTubeHeader/YTVideoQualitySwitchOriginalController.h"
#import "Tweaks/YouTubeHeader/YTSettingsSectionItem.h"
#import "Tweaks/YouTubeHeader/YTPlayerViewController.h"
#import "Tweaks/YouTubeHeader/YTWatchController.h"
#import "Tweaks/YouTubeHeader/YTIGuideResponse.h"
#import "Tweaks/YouTubeHeader/YTIGuideResponseSupportedRenderers.h"
#import "Tweaks/YouTubeHeader/YTIPivotBarSupportedRenderers.h"
#import "Tweaks/YouTubeHeader/YTIPivotBarRenderer.h"
#import "Tweaks/YouTubeHeader/YTIBrowseRequest.h"
#import "Tweaks/YouTubeHeader/YTColorPalette.h"

BOOL hideHUD() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hideHUD_enabled"];
}
BOOL oled() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"oled_enabled"];
}
BOOL oledKB() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"oledKeyBoard_enabled"];
}
BOOL isDarkMode() {
    return ([[NSUserDefaults standardUserDefaults] integerForKey:@"page_style"] == 1);
}
BOOL autoFullScreen() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"autofull_enabled"];
}
BOOL noHoverCard() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hover_cards_enabled"];
}
BOOL ReExplore() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"reExplore_enabled"];
}
BOOL bigYTMiniPlayer() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"bigYTMiniPlayer_enabled"];
}
BOOL hideCC() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hideCC_enabled"];
}
BOOL hideAutoplaySwitch() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hideAutoplaySwitch_enabled"];
}
BOOL castConfirm() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"castConfirm_enabled"];
}

// Hide CC / Autoplay switch
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
    %orig;
    if (hideAutoplaySwitch())
        MSHookIvar<UIView *>(self, "_autonavSwitch").hidden = YES;
    if (hideCC())
        MSHookIvar<UIView *>(self, "_closedCaptionsOrSubtitlesButton").hidden = YES;
}
%end

// Hide HUD Messages
%hook YTHUDMessageView
- (id)initWithMessage:(id)arg1 dismissHandler:(id)arg2 {
    return hideHUD() ? nil : %orig;
}
%end

// YTAutoFullScreen: https://github.com/PoomSmart/YTAutoFullScreen/
%hook YTPlayerViewController
- (void)loadWithPlayerTransition:(id)arg1 playbackConfig:(id)arg2 {
    %orig;
    if (autoFullScreen())
        [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(autoFullscreen) userInfo:nil repeats:NO];
}
%new
- (void)autoFullscreen {
    YTWatchController *watchController = [self valueForKey:@"_UIDelegate"];
    [watchController showFullScreen];
}
%end

// YTNoHoverCards: https://github.com/level3tjg/YTNoHoverCards
%hook YTCreatorEndscreenView
- (void)setHidden:(BOOL)hidden {
    if (noHoverCard())
        hidden = YES;
    %orig;
}
%end
 
//YTCastConfirm: https://github.com/JamieBerghmans/YTCastConfirm
%hook MDXPlaybackRouteButtonController
- (void)didPressButton:(id)arg1 {
    if (castConfirm()) {
        UIAlertController* alertController = [%c(UIAlertController) alertControllerWithTitle:@"Casting"
                                message:@"Are you sure you want to start casting?"
                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [%c(UIAlertAction) actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            %orig;
        }];

        UIAlertAction* noButton = [%c(UIAlertAction)
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleDefault
                                handler: ^(UIAlertAction * action) {
            return;
        }];

        [alertController addAction:defaultAction];
        [alertController addAction:noButton];
        
        id rootViewController = [%c(UIApplication) sharedApplication].delegate.window.rootViewController;
        if ([rootViewController isKindOfClass:[%c(UINavigationController) class]]) {
            rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
        }
        if ([rootViewController isKindOfClass:[%c(UITabBarController) class]]) {
            rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
        }
        if ([rootViewController presentedViewController] != nil) {
            rootViewController = [rootViewController presentedViewController];
        }
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    return %orig;
}
%end

// Workaround for https://github.com/MiRO92/uYou-for-YouTube/issues/12
%hook YTAdsInnerTubeContextDecorator
- (void)decorateContext:(id)arg1 { %orig(nil); }
%end

// YTClassicVideoQuality: https://github.com/PoomSmart/YTClassicVideoQuality
%hook YTVideoQualitySwitchControllerFactory
- (id)videoQualitySwitchControllerWithParentResponder:(id)responder {
    Class originalClass = %c(YTVideoQualitySwitchOriginalController);
    return originalClass ? [[originalClass alloc] initWithParentResponder:responder] : %orig;
}
%end

// YTNoCheckLocalNetwork: https://poomsmart.github.io/repo/depictions/ytnochecklocalnetwork.html
%hook YTHotConfig
- (BOOL)isPromptForLocalNetworkPermissionsEnabled { return NO; }
%end

// YTSystemAppearance: https://poomsmart.github.io/repo/depictions/ytsystemappearance.html
// YouRememberCaption: https://poomsmart.github.io/repo/depictions/youremembercaption.html
%hook YTColdConfig
- (BOOL)shouldUseAppThemeSetting { return YES; }
- (BOOL)respectDeviceCaptionSetting { return NO; }
- (BOOL)isEnhancedSearchBarEnabled { return YES; }
%end

// NOYTPremium - https://github.com/PoomSmart/NoYTPremium/
%hook YTCommerceEventGroupHandler
- (void)addEventHandlers {}
%end

%hook YTInterstitialPromoEventGroupHandler
- (void)addEventHandlers {}
%end

%hook YTPromosheetEventGroupHandler
- (void)addEventHandlers {}
%end

%hook YTPromoThrottleController
- (BOOL)canShowThrottledPromo { return NO; }
- (BOOL)canShowThrottledPromoWithFrequencyCap:(id)arg1 { return NO; }
- (BOOL)canShowThrottledPromoWithFrequencyCaps:(id)arg1 { return NO; }
%end

%hook YTIShowFullscreenInterstitialCommand
- (BOOL)shouldThrottleInterstitial { return YES; }
%end

%hook YTSurveyController
- (void)showSurveyWithRenderer:(id)arg1 surveyParentResponder:(id)arg2 {}
%end

// OLED dark mode by BandarHL
UIColor* oledColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];

%group gOLED
%hook YTColorPalette
- (UIColor *)brandBackgroundSolid {
    if (self.pageStyle == 1) {
        return oledColor;
    }
        return %orig;
}
- (UIColor *)brandBackgroundPrimary {
    if (self.pageStyle == 1) {
        return oledColor;
    }
        return %orig;
}
- (UIColor *)brandBackgroundSecondary {
    if (self.pageStyle == 1) {
        return oledColor;
    }
        return %orig;
}
- (UIColor *)staticBrandBlack {
    if (self.pageStyle == 1) {
        return oledColor;
    }
        return %orig;
}
- (UIColor *)generalBackgroundA {
    if (self.pageStyle == 1) {
        return oledColor;
    }
        return %orig;
}
%end

// Account view controller
%hook YTAccountPanelBodyViewController
- (UIColor *)backgroundColor:(NSInteger)pageStyle {
    if (pageStyle == 1) { 
        return oledColor; 
    }
        return %orig;
}
%end

// Explore
%hook ASScrollView 
- (void)didMoveToWindow {
    if (isDarkMode()) {
        self.backgroundColor = oledColor;
        %orig;
    }
}
%end

// uYou's page
%hook DownloadedVC
- (UIColor *)ytBackgroundColor {
    if (isDarkMode()) {
        return oledColor;
    }
        return %orig;
}
%end

%hook DownloadsPagerVC
- (UIColor *)ytBackgroundColor {
    if (isDarkMode()) {
        return oledColor;
    }
        return %orig;
}
%end

%hook DownloadingVC
- (UIColor *)ytBackgroundColor {
    if (isDarkMode()) {
        return oledColor;
    }
        return %orig;
}
%end

%hook PlayerVC
- (UIColor *)ytBackgroundColor {
    if (isDarkMode()) {
        return oledColor;
    }
        return %orig;
}
%end

// SponsorBlock settings
%hook SponsorBlockSettingsController
- (void)viewDidLoad {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        %orig;
        self.tableView.backgroundColor = oledColor;
    } else { 
        return %orig(); 
    }
}
%end

// uYou & YT player, and downloading view controller
%hook _LNPopupBarContentView
- (void)setBackgroundColor:(UIColor *)color { 
    if (isDarkMode()) {
        return %orig([UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9]);
    }
    return %orig;
}
%end

%hook YTWatchMiniBarView 
- (void)setBackgroundColor:(UIColor *)color { 
    if (isDarkMode()) {
        return %orig([UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9]);
    }
    return %orig;
}
%end

// Search View
%hook YTSearchBarView 
- (void)setBackgroundColor:(UIColor *)color { 
    if (isDarkMode()) {
        return %orig (oledColor);
    }
        return %orig;
}
%end

%hook YTSearchBoxView 
- (void)setBackgroundColor:(UIColor *)color { 
    if (isDarkMode()) {
        return %orig (oledColor);
    }
    return %orig;
}
%end

// Comment view
%hook YTCreateCommentAccessoryView // community reply comment
- (void)setBackgroundColor:(UIColor *)color { 
    if (isDarkMode()) {
        return %orig (oledColor);
    }
    return %orig;
}
%end

%hook YTCreateCommentTextView
- (void)setBackgroundColor:(UIColor *)color { 
    if (isDarkMode()) {
        return %orig (oledColor);
    }
    return %orig;
}
- (void)setTextColor:(UIColor *)color { // fix black text in #Shorts video's comment
    if (isDarkMode()) { 
        return %orig ([UIColor whiteColor]); 
    }
    return %orig;
}
%end

%hook YCHLiveChatActionPanelView  // live chat comment
- (void)setBackgroundColor:(UIColor *)color {
    if (isDarkMode()) {
        return %orig (oledColor);
    }
    return %orig;
}
%end

%hook YTEmojiTextView // live chat comment
- (void)setBackgroundColor:(UIColor *)color {
    if (isDarkMode()) {
        return %orig (oledColor);
    }
    return %orig;
}
%end

// Separation lines
%hook YTCollectionSeparatorView
- (void)didMoveToWindow {
    if (isDarkMode()) {}
    else { 
        return %orig(); 
    }
}
%end

// Open link with...
%hook ASWAppSwitchingSheetHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    if (isDarkMode()) {
        return %orig (oledColor);
    }
}
%end

%hook ASWAppSwitchingSheetFooterView
- (void)setBackgroundColor:(UIColor *)color {
    if (isDarkMode()) {
        return %orig (oledColor);
    }
}
%end

// this sucks :/
%hook UIView
- (void)setBackgroundColor:(UIColor *)color {
    if (isDarkMode()) {
        if ([self.nextResponder isKindOfClass:%c(YTHUDMessageView)]) { color = oledColor; }
        if ([self.nextResponder isKindOfClass:%c(ASWAppSwitcherCollectionViewCell)]) { color = oledColor; } // Open link with...
        %orig;
    }
        return %orig;
}
%end
%end

%group gOLEDKB // OLED keyboard by @ichitaso <3 - http://gist.github.com/ichitaso/935100fd53a26f18a9060f7195a1be0e
%hook UIPredictionViewController
- (void)loadView {
    %orig;
    [self.view setBackgroundColor:oledColor];
}
%end

%hook UICandidateViewController
- (void)loadView {
    %orig;
    [self.view setBackgroundColor:oledColor];
}
%end

%hook UIKeyboardDockView
- (void)didMoveToWindow {
    self.backgroundColor = oledColor;
    %orig;
}
%end

%hook UIKeyboardLayoutStar 
- (void)didMoveToWindow {
    self.backgroundColor = oledColor;
    %orig;
}
%end

%hook UIKBRenderConfig // Prediction text color
- (void)setLightKeyboard:(BOOL)arg1 { %orig(NO); }
%end
%end

// YTReExplore: https://github.com/PoomSmart/YTReExplore/
%group gReExplore
static void replaceTab(YTIGuideResponse *response) {
    NSMutableArray <YTIGuideResponseSupportedRenderers *> *renderers = [response itemsArray];
    for (YTIGuideResponseSupportedRenderers *guideRenderers in renderers) {
        YTIPivotBarRenderer *pivotBarRenderer = [guideRenderers pivotBarRenderer];
        NSMutableArray <YTIPivotBarSupportedRenderers *> *items = [pivotBarRenderer itemsArray];
        NSUInteger shortIndex = [items indexOfObjectPassingTest:^BOOL(YTIPivotBarSupportedRenderers *renderers, NSUInteger idx, BOOL *stop) {
            return [[[renderers pivotBarItemRenderer] pivotIdentifier] isEqualToString:@"FEshorts"];
        }];
        if (shortIndex != NSNotFound) {
            [items removeObjectAtIndex:shortIndex];
            NSUInteger exploreIndex = [items indexOfObjectPassingTest:^BOOL(YTIPivotBarSupportedRenderers *renderers, NSUInteger idx, BOOL *stop) {
                return [[[renderers pivotBarItemRenderer] pivotIdentifier] isEqualToString:[%c(YTIBrowseRequest) browseIDForExploreTab]];
            }];
            if (exploreIndex == NSNotFound) {
                YTIPivotBarSupportedRenderers *exploreTab = [%c(YTIPivotBarRenderer) pivotSupportedRenderersWithBrowseId:[%c(YTIBrowseRequest) browseIDForExploreTab] title:@"Explore" iconType:292];
                [items insertObject:exploreTab atIndex:1];
            }
        }
    }
}
%hook YTGuideServiceCoordinator
- (void)handleResponse:(YTIGuideResponse *)response withCompletion:(id)completion {
    replaceTab(response);
    %orig(response, completion);
}
- (void)handleResponse:(YTIGuideResponse *)response error:(id)error completion:(id)completion {
    replaceTab(response);
    %orig(response, error, completion);
}
%end
%end

// BigYTMiniPlayer: https://github.com/Galactic-Dev/BigYTMiniPlayer
%group Main
%hook YTWatchMiniBarView
- (void)setWatchMiniPlayerLayout:(int)arg1 {
    %orig(1);
}
- (int)watchMiniPlayerLayout {
    return 1;
}
- (void)layoutSubviews {
    %orig;
    self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - self.frame.size.width), self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
%end

%hook YTMainAppVideoPlayerOverlayView
- (BOOL)isUserInteractionEnabled {
    if([[self _viewControllerForAncestor].parentViewController.parentViewController isKindOfClass:%c(YTWatchMiniBarViewController)]) {
        return NO;
    }
    return %orig;
}
%end
%end

%ctor {
    %init;
    if (oled()) {
       %init(gOLED);
    }
    if (oledKB()) {
       %init(gOLEDKB);
    }
    if (ReExplore()) {
       %init(gReExplore);
    }
    if (bigYTMiniPlayer() && (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPad)) {
       %init(Main);
    }
}

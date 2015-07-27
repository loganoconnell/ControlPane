#import <flipswitch/flipswitch.h>
#import <libactivator/libactivator.h>

#import "CBAutoScrollLabel.h"

@interface UIApplication (ControlPane)
- (void)_powerDownNow;
- (void)_relaunchSpringBoardNow;
- (void)_rebootNow;
@end

@interface UIImage (ControlPane)
- (UIImage *)_flatImageWithColor:(UIColor *)color;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (float)volume;
- (void)setVolume:(float)volume;
- (BOOL)togglePlayPause;
- (BOOL)changeTrack:(int)track;
@end

@interface SBBrightnessController : NSObject
+ (id)sharedBrightnessController;
- (void)setBrightnessLevel:(float)level;
@end

@interface SBUIController : NSObject
+ (id)sharedInstance;
- (void)activateApplicationAnimated:(id)animated;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithPid:(int)pid;
@end

@interface SBPowerDownController : NSObject
- (void)activate;
- (void)cancel;
- (void)deactivate;
@end

extern "C" void MRMediaRemoteGetNowPlayingApplicationPID(dispatch_queue_t queue, void (^MRMediaRemoteGetNowPlayingApplicationPIDCompletion)(int PID));
extern "C" void MRMediaRemoteGetNowPlayingInfo(dispatch_queue_t queue, void (^MRMediaRemoteGetNowPlayingInfoCompletion)(CFDictionaryRef information));
extern "C" void MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_queue_t queue, void (^MRMediaRemoteGetNowPlayingApplicationIsPlayingCompletion)(Boolean isPlaying));

UIWindow *controlPane;
UIView *paneDimView;
UIVisualEffectView *effectView;

UIButton *powerOffSwitch;
UIImageView *powerOffSwitchImage;

UIButton *respringSwitch;
UIImageView *respringSwitchImage;

UIButton *airplaneSwitch;
UIButton *autoBrightnessSwitch;
UIButton *autoLockSwitch;
UIButton *bluetoothSwitch;
UIButton *dataSwitch;
UIButton *doNotDisturbSwitch;
UIButton *flashlightSwitch;
UIButton *hotspotSwitch;
UIButton *locationSwitch;
UIButton *lteSwitch;
UIButton *ringerSwitch;
UIButton *rotationLockSwitch;
UIButton *vibrationSwitch;
UIButton *vpnSwitch;
UIButton *wifiSwitch;

UISlider *brightnessSlider;
UIImageView *brightnessSliderImage;

UISlider *volumeSlider;
UIImageView *volumeSliderImage;

UIImageView *albumArtworkImage;
CBAutoScrollLabel *songTitleLabel;
CBAutoScrollLabel *artistNameLabel;

UIProgressView *trackProgressView;

UIButton *rewindButton;
UIButton *playPauseButton;
UIButton *fastForwardButton;

UIAlertView *alertView;

NSBundle *templateBundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/ControlPanePrefs.bundle/IconTemplate.bundle"];

FSSwitchPanel *switchPanel = [FSSwitchPanel sharedPanel];

static CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
static CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
static CGFloat screenHeightScale = screenHeight / 9;
static BOOL isOnFirstPage = YES;

static BOOL enabled;
static NSString *blurType;
static BOOL leftyMode;
static BOOL showSeparators;
static BOOL shouldConfirm;
static BOOL replacePowerDownScreen;
static float animationDuration;
static float dimViewAlpha;
static float cornerRadius;

static void loadPrefs() {
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.tweaksbylogan.controlpane.plist"];

	enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;
	blurType = [prefs objectForKey:@"blurType"] ? [prefs objectForKey:@"blurType"] : @"light";
	leftyMode = [prefs objectForKey:@"leftyMode"] ? [[prefs objectForKey:@"leftyMode"] boolValue] : NO;
	showSeparators = [prefs objectForKey:@"showSeparators"] ? [[prefs objectForKey:@"showSeparators"] boolValue] : YES;
	shouldConfirm = [prefs objectForKey:@"shouldConfirm"] ? [[prefs objectForKey:@"shouldConfirm"] boolValue] : YES;
	replacePowerDownScreen = [prefs objectForKey:@"replacePowerDownScreen"] ? [[prefs objectForKey:@"replacePowerDownScreen"] boolValue] : YES;
	animationDuration = [prefs objectForKey:@"animationDuration"] ? [[prefs objectForKey:@"animationDuration"] floatValue] : 0.25;
	dimViewAlpha = [prefs objectForKey:@"dimViewAlpha"] ? [[prefs objectForKey:@"dimViewAlpha"] floatValue] : 0.2;
	cornerRadius = [prefs objectForKey:@"cornerRadius"] ? [[prefs objectForKey:@"cornerRadius"] floatValue] : 0.0;
}
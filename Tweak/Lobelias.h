#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>
#import "libcolorpicker.h"
#import <Kitten/libKitten.h>
#import <AudioToolbox/AudioServices.h>

HBPreferences* preferences;
NSDictionary *preferencesDictionary;
libKitten* nena;
UIColor* backgroundColor;
UIColor* primaryColor;
UIColor* secondaryColor;
NSTimer* timer;

int notificationCount;

extern BOOL enabled;
extern BOOL enableBackgroundSection;
extern BOOL enableArtworkSection;
extern BOOL enableTimeControlSection;
extern BOOL enableSongTitleSection;
extern BOOL enableArtistNameSection;
extern BOOL enableRewindButtonSection;
extern BOOL enableSkipButtonSection;
extern BOOL enableOthersSection;

UIImage* currentArtwork;
UIImageView* lsArtworkBackgroundImageView;
UIButton* lsArtworkImage;
UIImageView* pauseImage;
UIVisualEffectView* lsBlurView;
UIBlurEffect* lsBlur;
UILabel* songTitleLabel;
UILabel* artistNameLabel;
UIButton* rewindButton;
UIButton* skipButton;
UISlider* timeControlSlider;
UILabel* elapsedTimeLabel;
UILabel* durationLabel;

// Background
NSString* backgroundAlphaValue = @"1.0";
NSString* backgroundBlurValue = @"3";
NSString* backgroundBlurAlphaValue = @"1.0";
BOOL artworkBackgroundTransitionSwitch = NO;

// Artwork
BOOL customArtworkPositionAndSizeSwitch = NO;
NSString* customArtworkXAxisValue = @"0.0";
NSString* customArtworkYAxisValue = @"0.0";
NSString* customArtworkWidthValue = @"230.0";
NSString* customArtworkHeightValue = @"230.0";
NSString* artworkAlphaValue = @"1.0";
NSString* artworkCornerRadiusValue = @"115.0";
NSString* artworkBorderWidthValue = @"4.0";
BOOL artworkBorderCustomColorSwitch = NO;
BOOL pauseImageCustomColorSwitch = NO;
BOOL artworkBorderLibKittenSwitch = YES;
BOOL pauseImageLibKittenSwitch = YES;
BOOL artworkTransitionSwitch = NO;
BOOL artworkHapticFeedbackSwitch = NO;

// Time Control
BOOL customTimeControlPositionAndSizeSwitch = NO;
NSString* customTimeControlXAxisValue = @"0.0";
NSString* customTimeControlYAxisValue = @"0.0";
NSString* customTimeControlWidthValue = @"230.0";
NSString* customTimeControlHeightValue = @"230.0";
BOOL showElapsedTimeLabelSwitch = YES;
BOOL showDurationTimeLabelSwitch = YES;
NSString* timeControlAlphaValue = @"1.0";
NSString* timeControlElapsedLabelAlphaValue = @"1.0";
NSString* timeControlDurationLabelAlphaValue = @"1.0";

// Song Title
BOOL customSongTitlePositionAndSizeSwitch = NO;
NSString* customSongTitleXAxisValue = @"0.0";
NSString* customSongTitleYAxisValue = @"0.0";
NSString* customSongTitleWidthValue = @"200.0";
NSString* customSongTitleHeightValue = @"200.0";
NSString* songTitleAlphaValue = @"1.0";
NSString* songTitleCustomFontValue = @"";
NSString* songTitleFontSizeValue = @"24.0";
BOOL songTitleCustomColorSwitch = NO;
BOOL songTitleLibKittenSwitch = YES;
BOOL songTitleShadowSwitch = NO;
BOOL songTitleShadowLibKittenSwitch = NO;
NSString* songTitleShadowRadiusValue = @"0.0";
NSString* songTitleShadowOpacityValue = @"0.0";
NSString* songTitleShadowXValue = @"0.0";
NSString* songTitleShadowYValue = @"0.0";

// Artist Name
BOOL customArtistNamePositionAndSizeSwitch = NO;
NSString* customArtistNameXAxisValue = @"0.0";
NSString* customArtistNameYAxisValue = @"0.0";
NSString* customArtistNameWidthValue = @"200.0";
NSString* customArtistNameHeightValue = @"200.0";
NSString* artistNameAlphaValue = @"1.0";
NSString* artistNameCustomFontValue = @"";
NSString* artistNameFontSizeValue = @"19.0";
BOOL artistNameShowArtistNameSwitch = YES;
BOOL artistNameShowAlbumNameSwitch = YES;
BOOL artistNameCustomColorSwitch = NO;
BOOL artistNameLibKittenSwitch = YES;
BOOL artistNameShadowSwitch = NO;
BOOL artistNameShadowLibKittenSwitch = NO;
NSString* artistNameShadowRadiusValue = @"0.0";
NSString* artistNameShadowOpacityValue = @"0.0";
NSString* artistNameShadowXValue = @"0.0";
NSString* artistNameShadowYValue = @"0.0";

// Rewind Button
BOOL customRewindButtonPositionAndSizeSwitch = NO;
NSString* customRewindButtonXAxisValue = @"30.0";
NSString* customRewindButtonYAxisValue = @"580.0";
NSString* customRewindButtonWidthValue = @"55.0";
NSString* customRewindButtonHeightValue = @"55.0";
NSString* rewindButtonAlphaValue = @"1.0";
NSString* rewindButtonCornerRadiusValue = @"27.5";
NSString* rewindButtonBorderWidthValue = @"0.0";
BOOL rewindButtonBackgroundCustomColorSwitch = NO;
BOOL rewindButtonCustomColorSwitch = NO;
BOOL rewindButtonBorderCustomColorSwitch = NO;
BOOL rewindButtonBackgroundLibKittenSwitch = YES;
BOOL rewindButtonLibKittenSwitch = YES;
BOOL rewindButtonBorderLibKittenSwitch = NO;
BOOL swipeRewindButtonToToggleShuffleSwitch = YES;
BOOL rewindButtonHapticFeedbackSwitch = NO;

// Skip Button
BOOL customSkipButtonPositionAndSizeSwitch = NO;
NSString* customSkipButtonXAxisValue = @"290.0";
NSString* customSkipButtonYAxisValue = @"580.0";
NSString* customSkipButtonWidthValue = @"55.0";
NSString* customSkipButtonHeightValue = @"55.0";
NSString* skipButtonAlphaValue = @"1.0";
NSString* skipButtonCornerRadiusValue = @"27.5";
NSString* skipButtonBorderWidthValue = @"0.0";
BOOL skipButtonBackgroundCustomColorSwitch = NO;
BOOL skipButtonCustomColorSwitch = NO;
BOOL skipButtonBorderCustomColorSwitch = NO;
BOOL skipButtonBackgroundLibKittenSwitch = YES;
BOOL skipButtonLibKittenSwitch = YES;
BOOL skipButtonBorderLibKittenSwitch = NO;
BOOL swipeSkipButtonToToggleRepeatSwitch = YES;
BOOL skipButtonHapticFeedbackSwitch = NO;

// Others
BOOL fadeWhenNotificationsSwitch = YES;
NSString* fadeWhenNotificationsAlphaValue = @"0.2";
NSString* notificationPositionValue = @"0.0";

@interface CSCoverSheetViewController : UIViewController
- (void)setTime;
- (void)updateTimeControl;
- (void)rewindSong;
- (void)skipSong;
- (void)pausePlaySong;
- (void)toggleShuffle;
- (void)toggleRepeat;
@end

@interface NCNotificationListView : UIScrollView
@end

@interface NCNotificationListHeaderTitleView : UIView
@end

@interface NCToggleControl : UIView
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPaused;
- (BOOL)isPlaying;
- (void)setNowPlayingInfo:(id)arg1;
- (BOOL)changeTrack:(int)arg1 eventSource:(long long)arg2;
- (BOOL)togglePlayPauseForEventSource:(long long)arg1;
- (BOOL)toggleShuffleForEventSource:(long long)arg1;
- (BOOL)toggleRepeatForEventSource:(long long)arg1;
@end
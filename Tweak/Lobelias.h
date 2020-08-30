#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>

HBPreferences* preferences;

extern BOOL enabled;
extern BOOL enableBackgroundSection;
extern BOOL enableArtworkSection;
extern BOOL enableSongTitleSection;
extern BOOL enableArtistNameSection;
extern BOOL enableRewindButtonSection;
extern BOOL enableSkipButtonSection;
extern BOOL enableColorFlowSection;

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

UIView* notificationsSuperview;

// Background
NSString* backgroundAlphaValue = @"1.0";
NSString* backgroundBlurValue = @"3";
NSString* backgroundBlurAlphaValue = @"1.0";

// Artwork
BOOL customArtworkPositionAndSizeSwitch = NO;
NSString* customArtworkXAxisValue = @"0.0";
NSString* customArtworkYAxisValue = @"0.0";
NSString* customArtworkWidthValue = @"230.0";
NSString* customArtworkHeightValue = @"230.0";
NSString* artworkAlphaValue = @"1.0";
NSString* artworkCornerRadiusValue = @"115.0";
NSString* artworkBorderWidthValue = @"4.0";

// Song Title
BOOL customSongTitlePositionAndSizeSwitch = NO;
NSString* customSongTitleXAxisValue = @"0.0";
NSString* customSongTitleYAxisValue = @"0.0";
NSString* customSongTitleWidthValue = @"200.0";
NSString* customSongTitleHeightValue = @"200.0";
NSString* songTitleAlphaValue = @"1.0";
NSString* songTitleFontSizeValue = @"24.0";

// Artist Name
BOOL customArtistNamePositionAndSizeSwitch = NO;
NSString* customArtistNameXAxisValue = @"0.0";
NSString* customArtistNameYAxisValue = @"0.0";
NSString* customArtistNameWidthValue = @"200.0";
NSString* customArtistNameHeightValue = @"200.0";
NSString* artistNameAlphaValue = @"1.0";
NSString* artistNameFontSizeValue = @"19.0";
BOOL artistNameShowArtistNameSwitch = YES;
BOOL artistNameShowAlbumNameSwitch = YES;

// Rewind Button
BOOL customRewindButtonPositionAndSizeSwitch = NO;
NSString* customRewindButtonXAxisValue = @"30.0";
NSString* customRewindButtonYAxisValue = @"580.0";
NSString* customRewindButtonWidthValue = @"55.0";
NSString* customRewindButtonHeightValue = @"55.0";
NSString* rewindButtonAlphaValue = @"1.0";
NSString* rewindButtonCornerRadiusValue = @"27.5";
NSString* rewindButtonBorderWidthValue = @"0.0";

// Skip Button
BOOL customSkipButtonPositionAndSizeSwitch = NO;
NSString* customSkipButtonXAxisValue = @"290.0";
NSString* customSkipButtonYAxisValue = @"580.0";
NSString* customSkipButtonWidthValue = @"55.0";
NSString* customSkipButtonHeightValue = @"55.0";
NSString* skipButtonAlphaValue = @"1.0";
NSString* skipButtonCornerRadiusValue = @"27.5";
NSString* skipButtonBorderWidthValue = @"0.0";

// ColorFlow
BOOL pauseButtonColorFlowSwitch = NO;
NSString* pauseButtonColorFlowColorValue = @"2";
BOOL artworkBorderColorFlowSwitch = NO;
NSString* artworkBorderColorFlowColorValue = @"0";
BOOL songTitleColorFlowSwitch = NO;
NSString* songTitleColorFlowColorValue = @"1";
BOOL artistNameColorFlowSwitch = NO;
NSString* artistNameColorFlowColorValue = @"2";
BOOL rewindButtonBackgroundColorFlowSwitch = NO;
NSString* rewindButtonBackgroundColorFlowColorValue = @"0";
BOOL rewindButtonColorFlowSwitch = NO;
NSString* rewindButtonColorFlowColorValue = @"1";
BOOL skipButtonBackgroundColorFlowSwitch = NO;
NSString* skipButtonBackgroundColorFlowColorValue = @"0";
BOOL skipButtonColorFlowSwitch = NO;
NSString* skipButtonColorFlowColorValue = @"1";

@interface CSCoverSheetViewController : UIViewController
- (void)rewindSong;
- (void)skipSong;
- (void)pausePlaySong;
- (void)receiveColorNotification:(NSNotification *)notification;
@end

@interface NCNotificationListView : UIView
@end

@interface CSAdjunctItemView : UIView
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPaused;
- (void)setNowPlayingInfo:(id)arg1;
- (BOOL)changeTrack:(int)arg1 eventSource:(long long)arg2;
- (BOOL)togglePlayPauseForEventSource:(long long)arg1;
@end
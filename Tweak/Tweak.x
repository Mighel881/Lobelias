#import "Lobelias.h"

BOOL enabled;
BOOL enableBackgroundSection;
BOOL enableArtworkSection;
BOOL enableSongTitleSection;
BOOL enableArtistNameSection;
BOOL enableRewindButtonSection;
BOOL enableSkipButtonSection;
BOOL enableColorFlowSection;

%group Lobelias

%hook CSCoverSheetViewController

- (void)viewDidLoad { // add lobelias

	%orig;

	if (!lsArtworkBackgroundImageView && enableBackgroundSection) {
        lsArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
        [lsArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [lsArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
        [lsArtworkBackgroundImageView setClipsToBounds:YES];
        [lsArtworkBackgroundImageView setAlpha:[backgroundAlphaValue doubleValue]];
		[lsArtworkBackgroundImageView setHidden:YES];
        if (![lsArtworkBackgroundImageView isDescendantOfView:[self view]]) [[self view] insertSubview:lsArtworkBackgroundImageView atIndex:0];
    }
    
    if (!lsBlur && [backgroundBlurValue intValue] != 0 && enableBackgroundSection) {
        if ([backgroundBlurValue intValue] == 1)
            lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        else if ([backgroundBlurValue intValue] == 2)
            lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        else if ([backgroundBlurValue intValue] == 3)
            lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        if (!lsBlurView) lsBlurView = [[UIVisualEffectView alloc] initWithEffect:lsBlur];
        [lsBlurView setFrame:[lsArtworkBackgroundImageView bounds]];
        [lsBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [lsBlurView setClipsToBounds:YES];
        [lsBlurView setAlpha:[backgroundBlurAlphaValue doubleValue]];
        [lsBlurView setHidden:YES];
        if (![lsBlurView isDescendantOfView:lsArtworkBackgroundImageView]) [lsArtworkBackgroundImageView addSubview:lsBlurView];
    }
    
    if (!lsArtworkImage && enableArtworkSection) {
        if (customArtworkPositionAndSizeSwitch) {
            lsArtworkImage = [[UIButton alloc] initWithFrame:CGRectMake([customArtworkXAxisValue doubleValue], [customArtworkYAxisValue doubleValue], [customArtworkWidthValue doubleValue], [customArtworkHeightValue doubleValue])];
        } else {
            lsArtworkImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 230)];
            CGPoint artworkCenter = [[self view] center];
            artworkCenter.y = self.view.frame.size.height / 2;
            [lsArtworkImage setCenter:artworkCenter];
        }
        [lsArtworkImage addTarget:self action:@selector(pausePlaySong) forControlEvents:UIControlEventTouchDown];
        [lsArtworkImage setContentMode:UIViewContentModeScaleAspectFill];
        [lsArtworkImage setClipsToBounds:YES];
        [[lsArtworkImage layer] setCornerRadius:[artworkCornerRadiusValue doubleValue]];
        [[lsArtworkImage layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [[lsArtworkImage layer] setBorderWidth:[artworkBorderWidthValue doubleValue]];
        [lsArtworkImage setAdjustsImageWhenHighlighted:NO];
        [lsArtworkImage setAlpha:[artworkAlphaValue doubleValue]];
        [lsArtworkImage setHidden:YES];
        if (![lsArtworkImage isDescendantOfView:lsArtworkBackgroundImageView]) [[self view] addSubview:lsArtworkImage];
    }
    
    if (!pauseImage) {
        pauseImage = [[UIImageView alloc] initWithFrame:[lsArtworkImage bounds]];
        [pauseImage setContentMode:UIViewContentModeScaleAspectFit];
        [pauseImage setClipsToBounds:YES];
        [pauseImage setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/pauseImage.png"]];
        pauseImage.image = [pauseImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [pauseImage setTintColor:[UIColor whiteColor]];
        [pauseImage setAlpha:0.0];
        [pauseImage setHidden:NO];
        if (![pauseImage isDescendantOfView:lsArtworkImage]) [lsArtworkImage addSubview:pauseImage];
    }
    
    if (!songTitleLabel && enableSongTitleSection) {
        if (customSongTitlePositionAndSizeSwitch) {
            songTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake([customSongTitleXAxisValue doubleValue], [customSongTitleYAxisValue doubleValue], [customSongTitleWidthValue doubleValue], [customSongTitleHeightValue doubleValue])];
        } else {
            songTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
            CGPoint songTitleCenter = [[self view] center];
            songTitleCenter.y = self.view.frame.size.height / 1.365;
            [songTitleLabel setCenter:songTitleCenter];
        }
        [songTitleLabel setTextColor:[UIColor whiteColor]];
        [songTitleLabel setFont:[UIFont systemFontOfSize:[songTitleFontSizeValue doubleValue] weight:UIFontWeightSemibold]];
        [songTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [songTitleLabel setAlpha:[songTitleAlphaValue doubleValue]];
        [songTitleLabel setHidden:YES];
        if (![songTitleLabel isDescendantOfView:[self view]]) [[self view] addSubview:songTitleLabel];
    }
    
    if (!artistNameLabel && enableArtistNameSection) {
        if (customArtistNamePositionAndSizeSwitch) {
            artistNameLabel = [[UILabel alloc] initWithFrame:CGRectMake([customArtistNameXAxisValue doubleValue], [customArtistNameYAxisValue doubleValue], [customArtistNameWidthValue doubleValue], [customArtistNameHeightValue doubleValue])];
        } else {
            artistNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
            CGPoint artistNameCenter = [[self view] center];
            artistNameCenter.y = self.view.frame.size.height / 1.3;
            [artistNameLabel setCenter:artistNameCenter];
        }
        [artistNameLabel setTextColor:[UIColor colorWithRed: 0.65 green: 0.65 blue: 0.65 alpha: 1.00]];
        [artistNameLabel setFont:[UIFont systemFontOfSize:[artistNameFontSizeValue doubleValue]]];
        [artistNameLabel setTextAlignment:NSTextAlignmentCenter];
        [artistNameLabel setAlpha:[artistNameAlphaValue doubleValue]];
        [artistNameLabel setHidden:YES];
        if (![artistNameLabel isDescendantOfView:[self view]]) [[self view] addSubview:artistNameLabel];
    }
    
    if (!rewindButton && enableRewindButtonSection) {
        if (customRewindButtonPositionAndSizeSwitch)
            rewindButton = [[UIButton alloc] initWithFrame:CGRectMake([customRewindButtonXAxisValue doubleValue], [customRewindButtonYAxisValue doubleValue], [customRewindButtonWidthValue doubleValue], [customRewindButtonHeightValue doubleValue])];
        else
            rewindButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 580, 55, 55)];
        [rewindButton addTarget:self action:@selector(rewindSong) forControlEvents:UIControlEventTouchDown];
        UIImage* rewindImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/rewindImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [rewindButton setImage:rewindImage forState:UIControlStateNormal];
        [rewindButton setClipsToBounds:YES];
        [[rewindButton layer] setCornerRadius:[rewindButtonCornerRadiusValue doubleValue]];
        [rewindButton setBackgroundColor:[UIColor colorWithRed: 0.44 green: 0.44 blue: 0.44 alpha: 1.00]];
        [rewindButton setTintColor:[UIColor whiteColor]];
        [[rewindButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [[rewindButton layer] setBorderWidth:[rewindButtonBorderWidthValue doubleValue]];
        [rewindButton setAdjustsImageWhenHighlighted:NO];
        [rewindButton setAlpha:[rewindButtonAlphaValue doubleValue]];
        [rewindButton setHidden:YES];
        if (![rewindButton isDescendantOfView:[self view]]) [[self view] addSubview:rewindButton];
    }
    
    if (!skipButton && enableSkipButtonSection) {
        if (customSkipButtonPositionAndSizeSwitch)
            skipButton = [[UIButton alloc] initWithFrame:CGRectMake([customSkipButtonXAxisValue doubleValue], [customSkipButtonYAxisValue doubleValue], [customSkipButtonWidthValue doubleValue], [customSkipButtonHeightValue doubleValue])];
        else
            skipButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 580, 55, 55)];
        [skipButton addTarget:self action:@selector(skipSong) forControlEvents:UIControlEventTouchDown];
        UIImage* skipImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/skipImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [skipButton setImage:skipImage forState:UIControlStateNormal];
        [skipButton setClipsToBounds:YES];
        [[skipButton layer] setCornerRadius:[skipButtonCornerRadiusValue doubleValue]];
        [skipButton setBackgroundColor:[UIColor colorWithRed: 0.44 green: 0.44 blue: 0.44 alpha: 1.00]];
        [skipButton setTintColor:[UIColor whiteColor]];
        [[skipButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [[skipButton layer] setBorderWidth:[skipButtonBorderWidthValue doubleValue]];
        [skipButton setAdjustsImageWhenHighlighted:NO];
        [skipButton setAlpha:[skipButtonAlphaValue doubleValue]];
        [skipButton setHidden:YES];
        if (![skipButton isDescendantOfView:[self view]]) [[self view] addSubview:skipButton];
    }

    // register colorflow notification observers
    if (enableColorFlowSection) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveColorNotification:) name:@"ColorFlowLockScreenColorReversionNotification" object:nil];
	    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveColorNotification:) name:@"ColorFlowLockScreenColorizationNotification" object:nil];
    }

}

%new
- (void)rewindSong { // rewind song

	[[%c(SBMediaController) sharedInstance] changeTrack:-1 eventSource:0];

    [UIView animateWithDuration:0.16 delay:0 usingSpringWithDamping:400 initialSpringVelocity:40 options:UIViewAnimationOptionCurveEaseIn animations:^{ // bounce animation
        rewindButton.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.16 delay:0 usingSpringWithDamping:1000 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            rewindButton.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }];

}

%new
- (void)skipSong { // skip song

	[[%c(SBMediaController) sharedInstance] changeTrack:1 eventSource:0];

    [UIView animateWithDuration:0.16 delay:0 usingSpringWithDamping:400 initialSpringVelocity:40 options:UIViewAnimationOptionCurveEaseIn animations:^{ // bounce animation
        skipButton.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.16 delay:0 usingSpringWithDamping:1000 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            skipButton.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }];

}

%new
- (void)pausePlaySong { // pause/play song

	[[%c(SBMediaController) sharedInstance] togglePlayPauseForEventSource:0];

    if (![[%c(SBMediaController) sharedInstance] isPaused]) {
        [UIView animateWithDuration:0.15 delay:0.1 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // pause image animation
            [pauseImage setAlpha:1.0];
            pauseImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
        [UIView animateWithDuration:0.4 delay:0.15 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // pause image animation
            [pauseImage setAlpha:0.0];
            pauseImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
            } completion:nil];
        }];
    }

    [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{ // bounce animation
        lsArtworkImage.transform = CGAffineTransformMakeScale(0.98, 0.98);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            lsArtworkImage.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }];

}

%new
- (void)receiveColorNotification:(NSNotification *)notification { // apply colorflow colors

    if ([notification.name isEqual:@"ColorFlowLockScreenColorizationNotification"]) {
        NSDictionary* userInfo = [notification userInfo];
        UIColor* backgroundColor = userInfo[@"BackgroundColor"];
		UIColor* primaryColor = userInfo[@"PrimaryColor"];
		UIColor* secondaryColor = userInfo[@"SecondaryColor"];
        if (pauseButtonColorFlowSwitch) {
            if ([pauseButtonColorFlowColorValue intValue] == 0) [pauseImage setTintColor:backgroundColor];
            else if ([pauseButtonColorFlowColorValue intValue] == 1) [pauseImage setTintColor:primaryColor];
            else if ([pauseButtonColorFlowColorValue intValue] == 2) [pauseImage setTintColor:secondaryColor];
        }
        if (artworkBorderColorFlowSwitch) {
            if ([artworkBorderColorFlowColorValue intValue] == 0) [[lsArtworkImage layer] setBorderColor:[backgroundColor CGColor]];
            else if ([artworkBorderColorFlowColorValue intValue] == 1) [[lsArtworkImage layer] setBorderColor:[primaryColor CGColor]];
            else if ([artworkBorderColorFlowColorValue intValue] == 2) [[lsArtworkImage layer] setBorderColor:[secondaryColor CGColor]];
        }
        if (songTitleColorFlowSwitch) {
            if ([songTitleColorFlowColorValue intValue] == 0) [songTitleLabel setTextColor:backgroundColor];
            else if ([songTitleColorFlowColorValue intValue] == 1) [songTitleLabel setTextColor:primaryColor];
            else if ([songTitleColorFlowColorValue intValue] == 2) [songTitleLabel setTextColor:secondaryColor];
        }
        if (artistNameColorFlowSwitch) {
            if ([artistNameColorFlowColorValue intValue] == 0) [artistNameLabel setTextColor:backgroundColor];
            else if ([artistNameColorFlowColorValue intValue] == 1) [artistNameLabel setTextColor:primaryColor];
            else if ([artistNameColorFlowColorValue intValue] == 2) [artistNameLabel setTextColor:secondaryColor];
        }
        if (rewindButtonBackgroundColorFlowSwitch) {
            if ([rewindButtonBackgroundColorFlowColorValue intValue] == 0) [rewindButton setBackgroundColor:backgroundColor];
            else if ([rewindButtonBackgroundColorFlowColorValue intValue] == 1) [rewindButton setBackgroundColor:primaryColor];
            else if ([rewindButtonBackgroundColorFlowColorValue intValue] == 2) [rewindButton setBackgroundColor:secondaryColor];
        }
        if (rewindButtonColorFlowSwitch) {
            if ([rewindButtonColorFlowColorValue intValue] == 0) [rewindButton setTintColor:backgroundColor];
            else if ([rewindButtonColorFlowColorValue intValue] == 1) [rewindButton setTintColor:primaryColor];
            else if ([rewindButtonColorFlowColorValue intValue] == 2) [rewindButton setTintColor:secondaryColor];
        }
        if (skipButtonBackgroundColorFlowSwitch) {
            if ([skipButtonBackgroundColorFlowColorValue intValue] == 0) [skipButton setBackgroundColor:backgroundColor];
            else if ([skipButtonBackgroundColorFlowColorValue intValue] == 1) [skipButton setBackgroundColor:primaryColor];
            else if ([skipButtonBackgroundColorFlowColorValue intValue] == 2) [skipButton setBackgroundColor:secondaryColor];
        }
        if (skipButtonColorFlowSwitch) {
            if ([skipButtonColorFlowColorValue intValue] == 0) [skipButton setTintColor:backgroundColor];
            else if ([skipButtonColorFlowColorValue intValue] == 1) [skipButton setTintColor:primaryColor];
            else if ([skipButtonColorFlowColorValue intValue] == 2) [skipButton setTintColor:secondaryColor];
        }
    } else if ([notification.name isEqual:@"ColorFlowLockScreenColorReversionNotification"]) {
        [songTitleLabel setTextColor:[UIColor whiteColor]];
        [artistNameLabel setTextColor:[UIColor colorWithRed: 0.65 green: 0.65 blue: 0.65 alpha: 1.00]];
    }

}

%end

// %hook NCNotificationListView

// - (void)setFrame:(CGRect)frame {

//     notificationsSuperview = [self superview];
//     if ([notificationsSuperview isKindOfClass:%c(NCNotificationListView)]) {
//         CGRect newFrame = frame;
//         newFrame.origin.y += 100;
//         %orig(newFrame);
//     } else {
//         %orig;
//     }

// }

// %end

%hook CSAdjunctItemView

- (void)setHidden:(BOOL)hidden { // hide the original player, i could have completely removed it but colorflow support would be broken then

    %orig(YES);

}

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 { // reload data after a respring in case the user uses RoadRunner or Gump

    %orig;

    [[%c(SBMediaController) sharedInstance] setNowPlayingInfo:0];
    
}

%end

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // get and set the artwork

    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information) {
            NSDictionary* dict = (__bridge NSDictionary *)information;
            currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]; // set artwork
            [songTitleLabel setText:[NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle]]]; // set song title
            if (artistNameShowArtistNameSwitch && artistNameShowAlbumNameSwitch)
                [artistNameLabel setText:[NSString stringWithFormat:@"%@ - %@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist], [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoAlbum]]]; // set artist and album name
            else if (artistNameShowArtistNameSwitch && !artistNameShowAlbumNameSwitch)
                [artistNameLabel setText:[NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist]]]; // set artist and album name
            else if (!artistNameShowArtistNameSwitch && artistNameShowAlbumNameSwitch)
                [artistNameLabel setText:[NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoAlbum]]]; // set artist and album name
            [lsArtworkBackgroundImageView setImage:currentArtwork];
            [lsArtworkImage setImage:currentArtwork forState:UIControlStateNormal];
            [lsArtworkBackgroundImageView setHidden:NO];
            [lsArtworkImage setHidden:NO];
            [lsBlurView setHidden:NO];
            [songTitleLabel setHidden:NO];
            [artistNameLabel setHidden:NO];
            [rewindButton setHidden:NO];
            [skipButton setHidden:NO];
        } else {
            [lsArtworkBackgroundImageView setImage:nil];
            [lsArtworkImage setImage:nil forState:UIControlStateNormal];
            currentArtwork = nil;
            [songTitleLabel setText:nil];
            [artistNameLabel setText:nil];
            [lsArtworkBackgroundImageView setHidden:YES];
            [lsArtworkImage setHidden:YES];
            [lsBlurView setHidden:YES];
            [songTitleLabel setHidden:YES];
            [artistNameLabel setHidden:YES];
            [rewindButton setHidden:YES];
            [skipButton setHidden:YES];
        }
  	});
    
}

- (void)_mediaRemoteNowPlayingApplicationIsPlayingDidChange:(id)arg1 {

    %orig;

    if ([self isPaused]) {
        [UIView animateWithDuration:0.15 delay:0.1 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // pause image animation
            [pauseImage setAlpha:1.0];
            pauseImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
        [UIView animateWithDuration:0.4 delay:0.15 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // pause image animation
            [pauseImage setAlpha:0.0];
            pauseImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
            } completion:nil];
        }];
    }

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.lobeliaspreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];
    [preferences registerBool:&enableBackgroundSection default:nil forKey:@"EnableBackgroundSection"];
    [preferences registerBool:&enableArtworkSection default:nil forKey:@"EnableArtworkSection"];
    [preferences registerBool:&enableSongTitleSection default:nil forKey:@"EnableSongTitleSection"];
    [preferences registerBool:&enableArtistNameSection default:nil forKey:@"EnableArtistNameSection"];
    [preferences registerBool:&enableRewindButtonSection default:nil forKey:@"EnableRewindButtonSection"];
    [preferences registerBool:&enableSkipButtonSection default:nil forKey:@"EnableSkipButtonSection"];
    [preferences registerBool:&enableColorFlowSection default:nil forKey:@"EnableColorFlowSection"];

    // Background
    if (enableBackgroundSection) {
        [preferences registerObject:&backgroundAlphaValue default:@"1.0" forKey:@"backgroundAlpha"];
        [preferences registerObject:&backgroundBlurValue default:@"3" forKey:@"backgroundBlur"];
        [preferences registerObject:&backgroundBlurAlphaValue default:@"1.0" forKey:@"backgroundBlurAlpha"];
    }

    // Artwork
    if (enableArtworkSection) {
        [preferences registerBool:&customArtworkPositionAndSizeSwitch default:NO forKey:@"customArtworkPositionAndSize"];
        [preferences registerObject:&customArtworkXAxisValue default:@"0.0" forKey:@"customArtworkXAxis"];
        [preferences registerObject:&customArtworkYAxisValue default:@"0.0" forKey:@"customArtworkYAxis"];
        [preferences registerObject:&customArtworkWidthValue default:@"230.0" forKey:@"customArtworkWidth"];
        [preferences registerObject:&customArtworkHeightValue default:@"230.0" forKey:@"customArtworkHeight"];
        [preferences registerObject:&artworkAlphaValue default:@"1.0" forKey:@"artworkAlpha"];
        [preferences registerObject:&artworkCornerRadiusValue default:@"115.0" forKey:@"artworkCornerRadius"];
        [preferences registerObject:&artworkBorderWidthValue default:@"4.0" forKey:@"artworkBorderWidth"];
    }

    // Song Title
    if (enableSongTitleSection) {
        [preferences registerBool:&customSongTitlePositionAndSizeSwitch default:NO forKey:@"customSongTitlePositionAndSize"];
        [preferences registerObject:&customSongTitleXAxisValue default:@"0.0" forKey:@"customSongTitleXAxis"];
        [preferences registerObject:&customSongTitleYAxisValue default:@"00.0" forKey:@"customSongTitleYAxis"];
        [preferences registerObject:&customSongTitleWidthValue default:@"200.0" forKey:@"customSongTitleWidth"];
        [preferences registerObject:&customSongTitleHeightValue default:@"200.0" forKey:@"customSongTitleHeight"];
        [preferences registerObject:&songTitleAlphaValue default:@"1.0" forKey:@"songTitleAlpha"];
        [preferences registerObject:&songTitleFontSizeValue default:@"24.0" forKey:@"songTitleFontSize"];
    }

    // Artist Name
    if (enableArtistNameSection) {
        [preferences registerBool:&customArtistNamePositionAndSizeSwitch default:NO forKey:@"customArtistNamePositionAndSize"];
        [preferences registerObject:&customArtistNameXAxisValue default:@"0.0" forKey:@"customArtistNameXAxis"];
        [preferences registerObject:&customArtistNameYAxisValue default:@"00.0" forKey:@"customArtistNameYAxis"];
        [preferences registerObject:&customArtistNameWidthValue default:@"200.0" forKey:@"customArtistNameWidth"];
        [preferences registerObject:&customArtistNameHeightValue default:@"200.0" forKey:@"customArtistNameHeight"];
        [preferences registerObject:&artistNameAlphaValue default:@"1.0" forKey:@"artistNameAlpha"];
        [preferences registerObject:&artistNameFontSizeValue default:@"19.0" forKey:@"artistNameFontSize"];
        [preferences registerBool:&artistNameShowArtistNameSwitch default:YES forKey:@"artistNameShowArtistName"];
        [preferences registerBool:&artistNameShowAlbumNameSwitch default:YES forKey:@"artistNameShowAlbumName"];
    }

    // Rewind Button
    if (enableRewindButtonSection) {
        [preferences registerBool:&customRewindButtonPositionAndSizeSwitch default:NO forKey:@"customRewindButtonPositionAndSize"];
        [preferences registerObject:&customRewindButtonXAxisValue default:@"30.0" forKey:@"customRewindButtonXAxis"];
        [preferences registerObject:&customRewindButtonYAxisValue default:@"580.0" forKey:@"customRewindButtonYAxis"];
        [preferences registerObject:&customRewindButtonWidthValue default:@"55.0" forKey:@"customRewindButtonWidth"];
        [preferences registerObject:&customRewindButtonHeightValue default:@"55.0" forKey:@"customRewindButtonHeight"];
        [preferences registerObject:&rewindButtonAlphaValue default:@"1.0" forKey:@"rewindButtonAlpha"];
        [preferences registerObject:&rewindButtonCornerRadiusValue default:@"27.5" forKey:@"rewindButtonCornerRadius"];
        [preferences registerObject:&rewindButtonBorderWidthValue default:@"0.0" forKey:@"rewindButtonBorderWidth"];
    }

    // Skip Button
    if (enableSkipButtonSection) {
        [preferences registerBool:&customSkipButtonPositionAndSizeSwitch default:NO forKey:@"customSkipButtonPositionAndSize"];
        [preferences registerObject:&customSkipButtonXAxisValue default:@"290.0" forKey:@"customSkipButtonXAxis"];
        [preferences registerObject:&customSkipButtonYAxisValue default:@"580.0" forKey:@"customSkipButtonYAxis"];
        [preferences registerObject:&customSkipButtonWidthValue default:@"55.0" forKey:@"customSkipButtonWidth"];
        [preferences registerObject:&customSkipButtonHeightValue default:@"55.0" forKey:@"customSkipButtonHeight"];
        [preferences registerObject:&skipButtonAlphaValue default:@"1.0" forKey:@"skipButtonAlpha"];
        [preferences registerObject:&skipButtonCornerRadiusValue default:@"27.5" forKey:@"skipButtonCornerRadius"];
        [preferences registerObject:&skipButtonBorderWidthValue default:@"0.0" forKey:@"skipButtonBorderWidth"];
    }

    // ColorFlow
    if (enableColorFlowSection) {
        [preferences registerBool:&pauseButtonColorFlowSwitch default:NO forKey:@"pauseButtonColorFlow"];
        [preferences registerObject:&pauseButtonColorFlowColorValue default:@"2" forKey:@"pauseButtonColorFlowColor"];
        [preferences registerBool:&artworkBorderColorFlowSwitch default:NO forKey:@"artworkBorderColorFlow"];
        [preferences registerObject:&artworkBorderColorFlowColorValue default:@"0" forKey:@"artworkBorderColorFlowColor"];
        [preferences registerBool:&songTitleColorFlowSwitch default:NO forKey:@"songTitleColorFlow"];
        [preferences registerObject:&songTitleColorFlowColorValue default:@"1" forKey:@"songTitleColorFlowColor"];
        [preferences registerBool:&artistNameColorFlowSwitch default:NO forKey:@"artistNameColorFlow"];
        [preferences registerObject:&artistNameColorFlowColorValue default:@"2" forKey:@"artistNameColorFlowColor"];
        [preferences registerBool:&rewindButtonBackgroundColorFlowSwitch default:NO forKey:@"rewindButtonBackgroundColorFlow"];
        [preferences registerObject:&rewindButtonBackgroundColorFlowColorValue default:@"0" forKey:@"rewindButtonBackgroundColorFlowColor"];
        [preferences registerBool:&rewindButtonColorFlowSwitch default:NO forKey:@"rewindButtonColorFlow"];
        [preferences registerObject:&rewindButtonColorFlowColorValue default:@"1" forKey:@"rewindButtonColorFlowColor"];
        [preferences registerBool:&skipButtonBackgroundColorFlowSwitch default:NO forKey:@"skipButtonBackgroundColorFlow"];
        [preferences registerObject:&skipButtonBackgroundColorFlowColorValue default:@"0" forKey:@"skipButtonBackgroundColorFlowColor"];
        [preferences registerBool:&skipButtonColorFlowSwitch default:NO forKey:@"skipButtonColorFlow"];
        [preferences registerObject:&skipButtonColorFlowColorValue default:@"1" forKey:@"skipButtonColorFlowColor"];
    }

	if (enabled) {
        %init(Lobelias);
        return;
    }

}
#import "Lobelias.h"

BOOL enabled;
BOOL enableBackgroundSection;
BOOL enableArtworkSection;
BOOL enableSongTitleSection;
BOOL enableArtistNameSection;
BOOL enableRewindButtonSection;
BOOL enableSkipButtonSection;
BOOL enableOthersSection;

%group Lobelias

%hook CSCoverSheetViewController

- (void)viewDidLoad { // add lobelias

	%orig;

    // background
	if (!lsArtworkBackgroundImageView && enableBackgroundSection) {
        lsArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
        [lsArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [lsArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
        [lsArtworkBackgroundImageView setClipsToBounds:YES];
        [lsArtworkBackgroundImageView setAlpha:[backgroundAlphaValue doubleValue]];
		[lsArtworkBackgroundImageView setHidden:YES];
        if (![lsArtworkBackgroundImageView isDescendantOfView:[self view]]) [[self view] insertSubview:lsArtworkBackgroundImageView atIndex:0];
    }
    
    // background blur
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
    
    // artwork
    if (!lsArtworkImage && enableArtworkSection) {
        if (customArtworkPositionAndSizeSwitch) {
            lsArtworkImage = [[UIButton alloc] initWithFrame:CGRectMake([customArtworkXAxisValue doubleValue], [customArtworkYAxisValue doubleValue], [customArtworkWidthValue doubleValue], [customArtworkHeightValue doubleValue])];
        } else {
            lsArtworkImage = [[UIButton alloc] init];
            [lsArtworkImage setTranslatesAutoresizingMaskIntoConstraints:NO];
            [lsArtworkImage.widthAnchor constraintEqualToConstant:230.0].active = YES;
            [lsArtworkImage.heightAnchor constraintEqualToConstant:230.0].active = YES;
        }
        [lsArtworkImage addTarget:self action:@selector(pausePlaySong) forControlEvents:UIControlEventTouchDown];
        [lsArtworkImage setContentMode:UIViewContentModeScaleAspectFill];
        [lsArtworkImage setClipsToBounds:YES];
        [[lsArtworkImage layer] setCornerRadius:[artworkCornerRadiusValue doubleValue]];
        if (artworkBorderCustomColorSwitch) {
            NSString* artworkBorderColorHex = [preferencesDictionary objectForKey:@"artworkBorderColor"];
            [[lsArtworkImage layer] setBorderColor:[LCPParseColorString(artworkBorderColorHex, @"#ffffff:1.000000") CGColor]];
        } else {
            [[lsArtworkImage layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        }
        [[lsArtworkImage layer] setBorderWidth:[artworkBorderWidthValue doubleValue]];
        [lsArtworkImage setAdjustsImageWhenHighlighted:NO];
        [lsArtworkImage setAlpha:[artworkAlphaValue doubleValue]];
        [lsArtworkImage setHidden:YES];
        if (![lsArtworkImage isDescendantOfView:lsArtworkBackgroundImageView]) [[self view] addSubview:lsArtworkImage];

        if (!customArtworkPositionAndSizeSwitch) {
            [lsArtworkImage.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
            [lsArtworkImage.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
        }
    }
    
    // pause image
    if (!pauseImage) {
        if (customArtworkPositionAndSizeSwitch) {
            pauseImage = [[UIImageView alloc] initWithFrame:[lsArtworkImage bounds]];
        } else {
            pauseImage = [[UIImageView alloc] init];
            [pauseImage setTranslatesAutoresizingMaskIntoConstraints:NO];
            [pauseImage.widthAnchor constraintEqualToConstant:230.0].active = YES;
            [pauseImage.heightAnchor constraintEqualToConstant:230.0].active = YES;
        }
        [pauseImage setContentMode:UIViewContentModeScaleAspectFit];
        [pauseImage setClipsToBounds:YES];
        [pauseImage setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/pauseImage.png"]];
        pauseImage.image = [pauseImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (pauseImageCustomColorSwitch) {
            NSString* pauseImageColorHex = [preferencesDictionary objectForKey:@"pauseImageColor"];
            [pauseImage setTintColor:LCPParseColorString(pauseImageColorHex, @"#ffffff:1.000000")];
        } else {
            [pauseImage setTintColor:[UIColor whiteColor]];
        }
        [pauseImage setAlpha:0.0];
        [pauseImage setHidden:NO];
        if (![pauseImage isDescendantOfView:lsArtworkImage]) [lsArtworkImage addSubview:pauseImage];

        if (!customArtworkPositionAndSizeSwitch) {
            [pauseImage.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
            [pauseImage.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
        }
    }
    
    // song title
    if (!songTitleLabel && enableSongTitleSection) {
        if (customSongTitlePositionAndSizeSwitch) {
            songTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake([customSongTitleXAxisValue doubleValue], [customSongTitleYAxisValue doubleValue], [customSongTitleWidthValue doubleValue], [customSongTitleHeightValue doubleValue])];
        } else {
            songTitleLabel = [[UILabel alloc] init];
            [songTitleLabel.widthAnchor constraintEqualToConstant:180.0].active = YES;
            [songTitleLabel.heightAnchor constraintEqualToConstant:29.0].active = YES;
            [songTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        if (songTitleCustomColorSwitch) {
            NSString* songTitleColorHex = [preferencesDictionary objectForKey:@"songTitleColor"];
            [songTitleLabel setTextColor:LCPParseColorString(songTitleColorHex, @"#ffffff:1.000000")];
        } else {
            [songTitleLabel setTextColor:[UIColor whiteColor]];
        }
        if ([songTitleCustomFontValue isEqualToString:@""])
            [songTitleLabel setFont:[UIFont systemFontOfSize:[songTitleFontSizeValue doubleValue] weight:UIFontWeightSemibold]];
        else
            [songTitleLabel setFont:[UIFont fontWithName:songTitleCustomFontValue size:[songTitleFontSizeValue doubleValue]]];
        if (songTitleShadowSwitch) {
            NSString* songTitleShadowColorHex = [preferencesDictionary objectForKey:@"songTitleShadowColor"];
            [[songTitleLabel layer] setShadowColor:[LCPParseColorString(songTitleShadowColorHex, @"#000000:1.000000") CGColor]];
            [[songTitleLabel layer] setShadowRadius:[songTitleShadowRadiusValue doubleValue]];
            [[songTitleLabel layer] setShadowOpacity:[songTitleShadowOpacityValue doubleValue]];
            [[songTitleLabel layer] setShadowOffset:CGSizeMake([songTitleShadowXValue doubleValue], [songTitleShadowYValue doubleValue])];
        }
        [songTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [songTitleLabel setAlpha:[songTitleAlphaValue doubleValue]];
        [songTitleLabel setHidden:YES];
        if (![songTitleLabel isDescendantOfView:[self view]]) [[self view] addSubview:songTitleLabel];

        if (!customSongTitlePositionAndSizeSwitch) {
            [songTitleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
            [songTitleLabel.centerYAnchor constraintEqualToAnchor:lsArtworkImage.bottomAnchor constant:75.0].active = YES;
        }
    }
    
    // artist name & album title
    if (!artistNameLabel && enableArtistNameSection) {
        if (customArtistNamePositionAndSizeSwitch) {
            artistNameLabel = [[UILabel alloc] initWithFrame:CGRectMake([customArtistNameXAxisValue doubleValue], [customArtistNameYAxisValue doubleValue], [customArtistNameWidthValue doubleValue], [customArtistNameHeightValue doubleValue])];
        } else {
            artistNameLabel = [[UILabel alloc] init];
            [artistNameLabel.widthAnchor constraintEqualToConstant:180.0].active = YES;
            [artistNameLabel.heightAnchor constraintEqualToConstant:21.0].active = YES;
            [artistNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        if (artistNameCustomColorSwitch) {
            NSString* artistNameColorHex = [preferencesDictionary objectForKey:@"artistNameColor"];
            [artistNameLabel setTextColor:LCPParseColorString(artistNameColorHex, @"#ffffff:1.000000")];
        } else {
            [artistNameLabel setTextColor:[UIColor colorWithRed: 0.65 green: 0.65 blue: 0.65 alpha: 1.00]];
        }
        if ([artistNameCustomFontValue isEqualToString:@""])
            [artistNameLabel setFont:[UIFont systemFontOfSize:[artistNameFontSizeValue doubleValue]]];
        else
            [artistNameLabel setFont:[UIFont fontWithName:artistNameCustomFontValue size:[artistNameFontSizeValue doubleValue]]];
        if (artistNameShadowSwitch) {
            NSString* artistNameShadowColorHex = [preferencesDictionary objectForKey:@"artistNameShadowColor"];
            [[artistNameLabel layer] setShadowColor:[LCPParseColorString(artistNameShadowColorHex, @"#000000:1.000000") CGColor]];
            [[artistNameLabel layer] setShadowRadius:[artistNameShadowRadiusValue doubleValue]];
            [[artistNameLabel layer] setShadowOpacity:[artistNameShadowOpacityValue doubleValue]];
            [[artistNameLabel layer] setShadowOffset:CGSizeMake([artistNameShadowXValue doubleValue], [artistNameShadowYValue doubleValue])];
        }
        [artistNameLabel setTextAlignment:NSTextAlignmentCenter];
        [artistNameLabel setAlpha:[artistNameAlphaValue doubleValue]];
        [artistNameLabel setHidden:YES];
        if (![artistNameLabel isDescendantOfView:[self view]]) [[self view] addSubview:artistNameLabel];

        if (!customArtworkPositionAndSizeSwitch) {
            [artistNameLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
            [artistNameLabel.centerYAnchor constraintEqualToAnchor:songTitleLabel.bottomAnchor constant:10.0].active = YES;
        }
    }
    
    // rewind button
    if (!rewindButton && enableRewindButtonSection) {
        if (customRewindButtonPositionAndSizeSwitch) {
            rewindButton = [[UIButton alloc] initWithFrame:CGRectMake([customRewindButtonXAxisValue doubleValue], [customRewindButtonYAxisValue doubleValue], [customRewindButtonWidthValue doubleValue], [customRewindButtonHeightValue doubleValue])];
        } else {
            rewindButton = [[UIButton alloc] init];
            [rewindButton.widthAnchor constraintEqualToConstant:55.0].active = YES;
            [rewindButton.heightAnchor constraintEqualToConstant:55.0].active = YES;
            [rewindButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        [rewindButton addTarget:self action:@selector(rewindSong) forControlEvents:UIControlEventTouchUpInside];
        [rewindButton addTarget:self action:@selector(toggleShuffle) forControlEvents:UIControlEventTouchUpOutside];
        UIImage* rewindImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/rewindImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [rewindButton setImage:rewindImage forState:UIControlStateNormal];
        [rewindButton setClipsToBounds:YES];
        [[rewindButton layer] setCornerRadius:[rewindButtonCornerRadiusValue doubleValue]];
        if (rewindButtonBackgroundCustomColorSwitch) {
            NSString* rewindButtonBackgroundColorHex = [preferencesDictionary objectForKey:@"rewindButtonBackgroundColor"];
            [rewindButton setBackgroundColor:LCPParseColorString(rewindButtonBackgroundColorHex, @"#ffffff:1.000000")];
        } else {
            [rewindButton setBackgroundColor:[UIColor colorWithRed: 0.44 green: 0.44 blue: 0.44 alpha: 1.00]];
        }
        if (rewindButtonCustomColorSwitch) {
            NSString* rewindButtonColorHex = [preferencesDictionary objectForKey:@"rewindButtonColor"];
            [rewindButton setTintColor:LCPParseColorString(rewindButtonColorHex, @"#ffffff:1.000000")];
        } else {
            [rewindButton setTintColor:[UIColor whiteColor]];
        }
        if (rewindButtonBorderCustomColorSwitch) {
            NSString* rewindButtonBorderColorHex = [preferencesDictionary objectForKey:@"rewindButtonBorderColor"];
            [[rewindButton layer] setBorderColor:[LCPParseColorString(rewindButtonBorderColorHex, @"#ffffff:1.000000") CGColor]];
        } else {
            [[rewindButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        }
        [[rewindButton layer] setBorderWidth:[rewindButtonBorderWidthValue doubleValue]];
        [rewindButton setAdjustsImageWhenHighlighted:NO];
        [rewindButton setAlpha:[rewindButtonAlphaValue doubleValue]];
        [rewindButton setHidden:YES];
        if (![rewindButton isDescendantOfView:[self view]]) [[self view] addSubview:rewindButton];

        if (!customRewindButtonPositionAndSizeSwitch) {
            [rewindButton.centerXAnchor constraintEqualToAnchor:songTitleLabel.leftAnchor constant:-40.0].active = YES;
            [rewindButton.centerYAnchor constraintEqualToAnchor:lsArtworkImage.bottomAnchor constant:85.0].active = YES;
        }
    }
    
    // skip button
    if (!skipButton && enableSkipButtonSection) {
        if (customSkipButtonPositionAndSizeSwitch) {
            skipButton = [[UIButton alloc] initWithFrame:CGRectMake([customSkipButtonXAxisValue doubleValue], [customSkipButtonYAxisValue doubleValue], [customSkipButtonWidthValue doubleValue], [customSkipButtonHeightValue doubleValue])];
        } else {
            skipButton = [[UIButton alloc] init];
            [skipButton.widthAnchor constraintEqualToConstant:55.0].active = YES;
            [skipButton.heightAnchor constraintEqualToConstant:55.0].active = YES;
            [skipButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        [skipButton addTarget:self action:@selector(skipSong) forControlEvents:UIControlEventTouchUpInside];
        [skipButton addTarget:self action:@selector(toggleRepeat) forControlEvents:UIControlEventTouchUpOutside];
        UIImage* skipImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/skipImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [skipButton setImage:skipImage forState:UIControlStateNormal];
        [skipButton setClipsToBounds:YES];
        [[skipButton layer] setCornerRadius:[skipButtonCornerRadiusValue doubleValue]];
        if (skipButtonBackgroundCustomColorSwitch) {
            NSString* skipButtonBackgroundColorHex = [preferencesDictionary objectForKey:@"skipButtonBackgroundColor"];
            [skipButton setBackgroundColor:LCPParseColorString(skipButtonBackgroundColorHex, @"#ffffff:1.000000")];
        } else {
            [skipButton setBackgroundColor:[UIColor colorWithRed: 0.44 green: 0.44 blue: 0.44 alpha: 1.00]];
        }
        if (skipButtonCustomColorSwitch) {
            NSString* skipButtonColorHex = [preferencesDictionary objectForKey:@"skipButtonColor"];
            [skipButton setTintColor:LCPParseColorString(skipButtonColorHex, @"#ffffff:1.000000")];
        } else {
            [skipButton setTintColor:[UIColor whiteColor]];
        }
        if (skipButtonBorderCustomColorSwitch) {
            NSString* skipButtonBorderColorHex = [preferencesDictionary objectForKey:@"skipButtonBorderColor"];
            [[skipButton layer] setBorderColor:[LCPParseColorString(skipButtonBorderColorHex, @"#ffffff:1.000000") CGColor]];
        } else {
            [[skipButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        }
        [[skipButton layer] setBorderWidth:[skipButtonBorderWidthValue doubleValue]];
        [skipButton setAdjustsImageWhenHighlighted:NO];
        [skipButton setAlpha:[skipButtonAlphaValue doubleValue]];
        [skipButton setHidden:YES];
        if (![skipButton isDescendantOfView:[self view]]) [[self view] addSubview:skipButton];

        if (!customSkipButtonPositionAndSizeSwitch) {
            [skipButton.centerXAnchor constraintEqualToAnchor:songTitleLabel.rightAnchor constant:40.0].active = YES;
            [skipButton.centerYAnchor constraintEqualToAnchor:lsArtworkImage.bottomAnchor constant:85.0].active = YES;
        }
    }

    // time control slider
    if (!timeControlSlider) {
        timeControlSlider = [[UISlider alloc] init];
        [timeControlSlider.widthAnchor constraintEqualToConstant:200.0].active = YES;
        [timeControlSlider.heightAnchor constraintEqualToConstant:10.0].active = YES;
        [timeControlSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [timeControlSlider addTarget:self action:@selector(setTime) forControlEvents:UIControlEventValueChanged];
        [timeControlSlider setContinuous:YES];
        [timeControlSlider setMinimumValue:0.0];
        [timeControlSlider setMaximumValue:1.0];
        [timeControlSlider setHidden:YES];
        if (![timeControlSlider isDescendantOfView:[self view]]) [[self view] addSubview:timeControlSlider];
        
        [timeControlSlider.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [timeControlSlider.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:145.0].active = YES;
    }

    // elapsed time label
    if (!elapsedTimeLabel) {
        elapsedTimeLabel = [[UILabel alloc] init];
        [elapsedTimeLabel.widthAnchor constraintEqualToConstant:50.0].active = YES;
         [elapsedTimeLabel.heightAnchor constraintEqualToConstant:21.0].active = YES;
        [elapsedTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [elapsedTimeLabel setTextColor:[UIColor whiteColor]];
        [elapsedTimeLabel setFont:[UIFont systemFontOfSize:15]];
        [elapsedTimeLabel setTextAlignment:NSTextAlignmentRight];
        [elapsedTimeLabel setHidden:YES];
        if (![elapsedTimeLabel isDescendantOfView:[self view]]) [[self view] addSubview:elapsedTimeLabel];

        [elapsedTimeLabel.centerXAnchor constraintEqualToAnchor:timeControlSlider.leftAnchor constant:-30.0].active = YES;
        [elapsedTimeLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:145.0].active = YES;
    }

    // duration label
    if (!durationLabel) {
        durationLabel = [[UILabel alloc] init];
        [durationLabel.widthAnchor constraintEqualToConstant:50.0].active = YES;
         [durationLabel.heightAnchor constraintEqualToConstant:21.0].active = YES;
        [durationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [durationLabel setTextColor:[UIColor whiteColor]];
        [durationLabel setFont:[UIFont systemFontOfSize:15]];
        [durationLabel setTextAlignment:NSTextAlignmentLeft];
        [durationLabel setHidden:YES];
        if (![durationLabel isDescendantOfView:[self view]]) [[self view] addSubview:durationLabel];

        [durationLabel.centerXAnchor constraintEqualToAnchor:timeControlSlider.rightAnchor constant:30.0].active = YES;
        [durationLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:145.0].active = YES;
    }

}

%new
- (void)setTime { // set user selected time from slider

    MRMediaRemoteSetElapsedTime([timeControlSlider value]);

}

// %new
// - (void)updateTimeControl {

//     AudioServicesPlaySystemSound(1519);
//     MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) { // update slider and elapsed time label
//         if (information) {
//             NSDictionary* dict = (__bridge NSDictionary *)information;
//             [timeControlSlider setValue:[[NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoElapsedTime]] doubleValue]];
//             [elapsedTimeLabel setText:[NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoElapsedTime]]];
//         }
//     });

// }

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
    
    pauseImage.image = [pauseImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pauseImage setTintColor:secondaryColor];
    if (![[%c(SBMediaController) sharedInstance] isPaused]) {
        [UIView animateWithDuration:0.15 delay:0.1 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // pause image fade animation
            [pauseImage setAlpha:1.0];
            pauseImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
        [UIView animateWithDuration:0.4 delay:0.15 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // pause image fade animation
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
- (void)toggleShuffle { // toggle shuffle

    [[%c(SBMediaController) sharedInstance] toggleShuffleForEventSource:0];

    if ([[%c(SBMediaController) sharedInstance] isPaused]) {
        [UIView transitionWithView:pauseImage duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ // if paused fade image
                [pauseImage setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/shuffle.png"]];
        } completion:nil];
    } else {
        [pauseImage setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/shuffle.png"]];
    }

    pauseImage.image = [pauseImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pauseImage setTintColor:secondaryColor];
    [UIView animateWithDuration:0.15 delay:0.1 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // shuffle image fade animation
        [pauseImage setAlpha:1.0];
        pauseImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    [UIView animateWithDuration:0.4 delay:0.15 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    } completion:nil];
    if (![[%c(SBMediaController) sharedInstance] isPaused]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // shuffle image fade animation
                [pauseImage setAlpha:0.0];
                pauseImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
                } completion:^(BOOL finished) {
                    [pauseImage setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/pauseImage.png"]];
                }];
            }];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView transitionWithView:pauseImage duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [pauseImage setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/pauseImage.png"]];
            } completion:nil];
        });
    }

}

%new
- (void)toggleRepeat { // toggle repeat

    [[%c(SBMediaController) sharedInstance] toggleRepeatForEventSource:0];

    if ([[%c(SBMediaController) sharedInstance] isPaused]) {
        [UIView transitionWithView:pauseImage duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ // if paused fade image
                [pauseImage setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/repeat.png"]];
        } completion:nil];
    } else {
        [pauseImage setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/repeat.png"]];
    }

    pauseImage.image = [pauseImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pauseImage setTintColor:secondaryColor];
    [UIView animateWithDuration:0.15 delay:0.1 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // pause image fade animation
        [pauseImage setAlpha:1.0];
        pauseImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    [UIView animateWithDuration:0.4 delay:0.15 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    } completion:nil];
    if (![[%c(SBMediaController) sharedInstance] isPaused]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // shuffle image fade animation
                [pauseImage setAlpha:0.0];
                pauseImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
                } completion:^(BOOL finished) {
                    [pauseImage setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/pauseImage.png"]];
                }];
            }];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView transitionWithView:pauseImage duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [pauseImage setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/pauseImage.png"]];
            } completion:nil];
        });
    }

}

%end

%hook CSAdjunctItemView

- (id)initWithFrame:(CGRect)frame { // remove original player

    return nil;

}

%end

%end

%group LobeliasOthers

%hook NCNotificationListView

- (void)_scrollViewWillBeginDragging { // fade lobelias out when scrolling and notifications are presented

	%orig;

    if (!fadeWhenNotificationsSwitch || notificationCount <= 0) return;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [lsArtworkImage setAlpha:[fadeWhenNotificationsAlphaValue doubleValue]];
        [songTitleLabel setAlpha:[fadeWhenNotificationsAlphaValue doubleValue]];
        [artistNameLabel setAlpha:[fadeWhenNotificationsAlphaValue doubleValue]];
        [rewindButton setAlpha:[fadeWhenNotificationsAlphaValue doubleValue]];
        [skipButton setAlpha:[fadeWhenNotificationsAlphaValue doubleValue]];
    } completion:nil];

}

- (void)_scrollViewDidEndDecelerating { // fade lobelias in when stopped scrolling

	%orig;

    if (!fadeWhenNotificationsSwitch || notificationCount <= 0) return;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [lsArtworkImage setAlpha:[artworkAlphaValue doubleValue]];
        [songTitleLabel setAlpha:[songTitleAlphaValue doubleValue]];
        [artistNameLabel setAlpha:[artistNameAlphaValue doubleValue]];
        [rewindButton setAlpha:[rewindButtonAlphaValue doubleValue]];
        [skipButton setAlpha:[skipButtonAlphaValue doubleValue]];
    } completion:nil];

}

%end

%hook NCNotificationListView

- (void)didMoveToWindow { // lower notifications

    %orig;

    if (fadeWhenNotificationsSwitch) {
        [lsArtworkImage setAlpha:[artworkAlphaValue doubleValue]];
        [songTitleLabel setAlpha:[songTitleAlphaValue doubleValue]];
        [artistNameLabel setAlpha:[artistNameAlphaValue doubleValue]];
        [rewindButton setAlpha:[rewindButtonAlphaValue doubleValue]];
        [skipButton setAlpha:[skipButtonAlphaValue doubleValue]];
    }

    if ([notificationPositionValue doubleValue] == 0.0) return;
    [self setFrame:self.frame];

}

- (void)setFrame:(CGRect)frame { // lower notifications

    %orig;

    if ([notificationPositionValue doubleValue] == 0.0 || (![[%c(SBMediaController) sharedInstance] isPlaying] && ![[%c(SBMediaController) sharedInstance] isPaused])) return;
    CGRect newFrame = frame;
    newFrame.origin.y += [notificationPositionValue doubleValue];
    %orig(newFrame);

}

%end

%hook NCNotificationListHeaderTitleView

- (void)didMoveToWindow { // lower notifications header

    %orig;

    if ([notificationPositionValue doubleValue] == 0.0) return;
    [self setFrame:self.frame];

}

- (void)setFrame:(CGRect)frame { // lower notifications header

    %orig;

    if ([notificationPositionValue doubleValue] == 0.0 || (![[%c(SBMediaController) sharedInstance] isPlaying] && ![[%c(SBMediaController) sharedInstance] isPaused])) return;
    CGRect newFrame = frame;
    newFrame.origin.y += [notificationPositionValue doubleValue];
    %orig(newFrame);

}

%end

%hook NCToggleControl

- (void)didMoveToWindow { // lower notifications control button

    %orig;

    if ([notificationPositionValue doubleValue] == 0.0) return;
    [self setFrame:self.frame];

}

- (void)setFrame:(CGRect)frame { // lower notifications control button

    %orig;

    if ([notificationPositionValue doubleValue] == 0.0 || (![[%c(SBMediaController) sharedInstance] isPlaying] && ![[%c(SBMediaController) sharedInstance] isPaused])) return;
    CGRect newFrame = frame;
    newFrame.origin.y += [notificationPositionValue doubleValue];
    %orig(newFrame);

}

%end

%hook NCNotificationMasterList

- (unsigned long long)notificationCount { // get notifications count

    if ([notificationPositionValue doubleValue] != 0.0 || fadeWhenNotificationsSwitch) notificationCount = %orig;

    return %orig;

}

%end

%end

%group LobeliasData

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // set now playing info

    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information) {
            NSDictionary* dict = (__bridge NSDictionary *)information;

            currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]; // set artwork
            [songTitleLabel setText:[NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle]]]; // set song title
            if (artistNameShowArtistNameSwitch && artistNameShowAlbumNameSwitch)
                [artistNameLabel setText:[NSString stringWithFormat:@"%@ - %@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist], [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoAlbum]]]; // set artist and album name
            else if (artistNameShowArtistNameSwitch && !artistNameShowAlbumNameSwitch)
                [artistNameLabel setText:[NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist]]]; // set artist name
            else if (!artistNameShowArtistNameSwitch && artistNameShowAlbumNameSwitch)
                [artistNameLabel setText:[NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoAlbum]]]; // set album name

            // set time control slider maximum value
            [timeControlSlider setMaximumValue:[[NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoDuration]] doubleValue]];
            [timeControlSlider setValue:[[NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoElapsedTime]] doubleValue]];

            // set elapsed time label and duration label
            int durationMinutes = ([[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoDuration] intValue] / 60) % 60;
            int durationSeconds = [[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoDuration] intValue] % 60;
            int elapsedMinutes = ([[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoElapsedTime] intValue] / 60) % 60;
            int elapsedSeconds = [[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoElapsedTime] intValue] % 60;
                        
            [durationLabel setText:[NSString stringWithFormat:@"%02d:%02d", durationMinutes, durationSeconds]];
            [elapsedTimeLabel setText:[NSString stringWithFormat:@"%02d:%02d", elapsedMinutes, elapsedSeconds]];

            if (dict) {
                if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
                    // set images and unhide elements
                    [lsArtworkBackgroundImageView setImage:currentArtwork];
                    [lsArtworkImage setImage:currentArtwork forState:UIControlStateNormal];
                    [lsArtworkBackgroundImageView setHidden:NO];
                    [lsArtworkImage setHidden:NO];
                    [lsBlurView setHidden:NO];
                    [songTitleLabel setHidden:NO];
                    [artistNameLabel setHidden:NO];
                    [rewindButton setHidden:NO];
                    [skipButton setHidden:NO];
                    [timeControlSlider setHidden:NO];
                    [elapsedTimeLabel setHidden:NO];
                    [durationLabel setHidden:NO];

                    // get libKitten colors
                    backgroundColor = [nena backgroundColor:currentArtwork];
                    primaryColor = [nena primaryColor:currentArtwork];
                    secondaryColor = [nena secondaryColor:currentArtwork];

                    // set libKitten colors
                    if (pauseImageLibKittenSwitch) [pauseImage setTintColor:secondaryColor];
                    if (artworkBorderLibKittenSwitch) [[lsArtworkImage layer] setBorderColor:[backgroundColor CGColor]];
                    if (songTitleLibKittenSwitch) [songTitleLabel setTextColor:primaryColor];
                    if (songTitleShadowLibKittenSwitch) [[songTitleLabel layer] setShadowColor:[primaryColor CGColor]];
                    if (artistNameLibKittenSwitch) [artistNameLabel setTextColor:secondaryColor];
                    if (artistNameShadowLibKittenSwitch) [[artistNameLabel layer] setShadowColor:[secondaryColor CGColor]];
                    if (rewindButtonBackgroundLibKittenSwitch) [rewindButton setBackgroundColor:backgroundColor];
                    if (rewindButtonLibKittenSwitch) [rewindButton setTintColor:primaryColor];
                    if (rewindButtonBorderLibKittenSwitch) [[rewindButton layer] setBorderColor:[secondaryColor CGColor]];
                    if (skipButtonBackgroundLibKittenSwitch) [skipButton setBackgroundColor:backgroundColor];
                    if (skipButtonLibKittenSwitch) [skipButton setTintColor:primaryColor];
                    if (skipButtonBorderLibKittenSwitch) [[skipButton layer] setBorderColor:[secondaryColor CGColor]];
                    [timeControlSlider setMinimumTrackTintColor:primaryColor];
                    [timeControlSlider setMaximumTrackTintColor:secondaryColor];
                    [elapsedTimeLabel setTextColor:secondaryColor];
                    [durationLabel setTextColor:secondaryColor];
                }
            }
        } else { // hide everything if not playing
            [lsArtworkBackgroundImageView setHidden:YES];
            [lsArtworkImage setHidden:YES];
            [lsBlurView setHidden:YES];
            [songTitleLabel setHidden:YES];
            [artistNameLabel setHidden:YES];
            [rewindButton setHidden:YES];
            [skipButton setHidden:YES];
            [timeControlSlider setHidden:YES];
            [elapsedTimeLabel setHidden:YES];
            [durationLabel setHidden:YES];
        }
  	});
    
}

- (void)_mediaRemoteNowPlayingApplicationIsPlayingDidChange:(id)arg1 { // show pause image when event source has paused playback

    %orig;

    pauseImage.image = [pauseImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pauseImage setTintColor:secondaryColor];
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

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 { // reload data after a respring

    %orig;

    [[%c(SBMediaController) sharedInstance] setNowPlayingInfo:0];
    
}

%end

%end

%group TweakCompatibility

%hook CSCoverSheetViewController

- (void)viewWillAppear:(BOOL)animated { // roundlockscreen compatibility

	%orig;

	[[lsArtworkBackgroundImageView layer] setCornerRadius:38];

}

- (void)viewWillDisappear:(BOOL)animated { // roundlockscreen compatibility

	%orig;

	[[lsArtworkBackgroundImageView layer] setCornerRadius:38];

}

- (void)viewDidAppear:(BOOL)animated { // roundlockscreen compatibility

	%orig;

	[[lsArtworkBackgroundImageView layer] setCornerRadius:0];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.lobeliaspreferences"];
    preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/love.litten.lobeliaspreferences.plist"]];
    nena = [[libKitten alloc] init];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];
    [preferences registerBool:&enableBackgroundSection default:nil forKey:@"EnableBackgroundSection"];
    [preferences registerBool:&enableArtworkSection default:nil forKey:@"EnableArtworkSection"];
    [preferences registerBool:&enableSongTitleSection default:nil forKey:@"EnableSongTitleSection"];
    [preferences registerBool:&enableArtistNameSection default:nil forKey:@"EnableArtistNameSection"];
    [preferences registerBool:&enableRewindButtonSection default:nil forKey:@"EnableRewindButtonSection"];
    [preferences registerBool:&enableSkipButtonSection default:nil forKey:@"EnableSkipButtonSection"];
    [preferences registerBool:&enableOthersSection default:nil forKey:@"EnableOthersSection"];

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
        [preferences registerBool:&artworkBorderCustomColorSwitch default:NO forKey:@"artworkBorderCustomColor"];
        [preferences registerBool:&pauseImageCustomColorSwitch default:NO forKey:@"pauseImageCustomColor"];
        [preferences registerBool:&artworkBorderLibKittenSwitch default:NO forKey:@"artworkBorderLibKitten"];
        [preferences registerBool:&pauseImageLibKittenSwitch default:NO forKey:@"pauseImageLibKitten"];
    }

    // Song Title
    if (enableSongTitleSection) {
        [preferences registerBool:&customSongTitlePositionAndSizeSwitch default:NO forKey:@"customSongTitlePositionAndSize"];
        [preferences registerObject:&customSongTitleXAxisValue default:@"0.0" forKey:@"customSongTitleXAxis"];
        [preferences registerObject:&customSongTitleYAxisValue default:@"00.0" forKey:@"customSongTitleYAxis"];
        [preferences registerObject:&customSongTitleWidthValue default:@"200.0" forKey:@"customSongTitleWidth"];
        [preferences registerObject:&customSongTitleHeightValue default:@"200.0" forKey:@"customSongTitleHeight"];
        [preferences registerObject:&songTitleAlphaValue default:@"1.0" forKey:@"songTitleAlpha"];
        [preferences registerObject:&songTitleCustomFontValue default:@"" forKey:@"songTitleCustomFont"];
        [preferences registerObject:&songTitleFontSizeValue default:@"24.0" forKey:@"songTitleFontSize"];
        [preferences registerBool:&songTitleCustomColorSwitch default:NO forKey:@"songTitleCustomColor"];
        [preferences registerBool:&songTitleLibKittenSwitch default:NO forKey:@"songTitleLibKitten"];
        [preferences registerBool:&songTitleShadowSwitch default:NO forKey:@"songTitleShadow"];
        [preferences registerBool:&songTitleShadowLibKittenSwitch default:NO forKey:@"songTitleShadowLibKitten"];
        [preferences registerObject:&songTitleShadowRadiusValue default:@"0.0" forKey:@"songTitleShadowRadius"];
        [preferences registerObject:&songTitleShadowOpacityValue default:@"0.0" forKey:@"songTitleShadowOpacity"];
        [preferences registerObject:&songTitleShadowXValue default:@"0.0" forKey:@"songTitleShadowX"];
        [preferences registerObject:&songTitleShadowYValue default:@"0.0" forKey:@"songTitleShadowY"];
    }

    // Artist Name
    if (enableArtistNameSection) {
        [preferences registerBool:&customArtistNamePositionAndSizeSwitch default:NO forKey:@"customArtistNamePositionAndSize"];
        [preferences registerObject:&customArtistNameXAxisValue default:@"0.0" forKey:@"customArtistNameXAxis"];
        [preferences registerObject:&customArtistNameYAxisValue default:@"00.0" forKey:@"customArtistNameYAxis"];
        [preferences registerObject:&customArtistNameWidthValue default:@"200.0" forKey:@"customArtistNameWidth"];
        [preferences registerObject:&customArtistNameHeightValue default:@"200.0" forKey:@"customArtistNameHeight"];
        [preferences registerObject:&artistNameAlphaValue default:@"1.0" forKey:@"artistNameAlpha"];
        [preferences registerObject:&artistNameCustomFontValue default:@"" forKey:@"artistNameCustomFont"];
        [preferences registerObject:&artistNameFontSizeValue default:@"19.0" forKey:@"artistNameFontSize"];
        [preferences registerBool:&artistNameShowArtistNameSwitch default:YES forKey:@"artistNameShowArtistName"];
        [preferences registerBool:&artistNameShowAlbumNameSwitch default:YES forKey:@"artistNameShowAlbumName"];
        [preferences registerBool:&artistNameCustomColorSwitch default:NO forKey:@"artistNameCustomColor"];
        [preferences registerBool:&artistNameLibKittenSwitch default:NO forKey:@"artistNameLibKitten"];
        [preferences registerBool:&artistNameShadowSwitch default:NO forKey:@"artistNameShadow"];
        [preferences registerBool:&artistNameShadowLibKittenSwitch default:NO forKey:@"artistNameShadowLibKitten"];
        [preferences registerObject:&artistNameShadowRadiusValue default:@"0.0" forKey:@"artistNameShadowRadius"];
        [preferences registerObject:&artistNameShadowOpacityValue default:@"0.0" forKey:@"artistNameShadowOpacity"];
        [preferences registerObject:&artistNameShadowXValue default:@"0.0" forKey:@"artistNameShadowX"];
        [preferences registerObject:&artistNameShadowYValue default:@"0.0" forKey:@"artistNameShadowY"];
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
        [preferences registerBool:&rewindButtonBackgroundCustomColorSwitch default:NO forKey:@"rewindButtonBackgroundCustomColor"];
        [preferences registerBool:&rewindButtonCustomColorSwitch default:NO forKey:@"rewindButtonCustomColor"];
        [preferences registerBool:&rewindButtonBorderCustomColorSwitch default:NO forKey:@"rewindButtonBorderCustomColor"];
        [preferences registerBool:&rewindButtonBackgroundLibKittenSwitch default:NO forKey:@"rewindButtonBackgroundLibKitten"];
        [preferences registerBool:&rewindButtonLibKittenSwitch default:NO forKey:@"rewindButtonLibKitten"];
        [preferences registerBool:&rewindButtonBorderLibKittenSwitch default:NO forKey:@"rewindButtonBorderLibKitten"];
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
        [preferences registerBool:&skipButtonBackgroundCustomColorSwitch default:NO forKey:@"skipButtonBackgroundCustomColor"];
        [preferences registerBool:&skipButtonCustomColorSwitch default:NO forKey:@"skipButtonCustomColor"];
        [preferences registerBool:&skipButtonBorderCustomColorSwitch default:NO forKey:@"skipButtonBorderCustomColor"];
        [preferences registerBool:&skipButtonBackgroundLibKittenSwitch default:NO forKey:@"skipButtonBackgroundLibKitten"];
        [preferences registerBool:&skipButtonLibKittenSwitch default:NO forKey:@"skipButtonLibKitten"];
        [preferences registerBool:&skipButtonBorderLibKittenSwitch default:NO forKey:@"skipButtonBorderLibKitten"];
    }

    if (enableOthersSection) {
        [preferences registerBool:&fadeWhenNotificationsSwitch default:NO forKey:@"fadeWhenNotifications"];
        [preferences registerObject:&fadeWhenNotificationsAlphaValue default:@"0.2" forKey:@"fadeWhenNotificationsAlpha"];
        [preferences registerObject:&notificationPositionValue default:@"0.0" forKey:@"notificationPosition"];
    }

	if (enabled) {
        %init(Lobelias);
        if (enableOthersSection) %init(LobeliasOthers);
        %init(LobeliasData);
        if (enableBackgroundSection && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/RoundLockScreen.dylib"]) %init(TweakCompatibility);
        return;
    }

}
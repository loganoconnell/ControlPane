#import "ControlPane.h"

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1  {
	%orig;

	controlPane = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	controlPane.windowLevel = UIWindowLevelStatusBar + 100.0;
	controlPane.alpha = 1.0;
	controlPane.hidden = YES;
	controlPane.backgroundColor = [UIColor clearColor];

	paneDimView = [[UIView alloc] init];
	paneDimView.frame = [[UIScreen mainScreen] bounds];
	paneDimView.center = controlPane.center;
	paneDimView.backgroundColor = [UIColor blackColor];
	paneDimView.alpha = 0.0;
	[controlPane addSubview:paneDimView];

	UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissControlPane:)];
	[paneDimView addGestureRecognizer:tap1];

	UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissControlPane:)];
	swipe1.direction = UISwipeGestureRecognizerDirectionRight;
	[paneDimView addGestureRecognizer:swipe1];

	UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchButtonPages:)];
	swipe2.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
	[paneDimView addGestureRecognizer:swipe2];

	if ([blurType isEqual:@"extralight"]) {
		effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
	}

	else if ([blurType isEqual:@"dark"]) {
		effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
	}

	else {
		effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
	}
	
	if (leftyMode) {
		effectView.frame = CGRectMake(0 - (screenHeightScale * 3), 0, screenHeightScale * 3, screenHeight);
	}

	else {
		effectView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, screenHeightScale * 3, screenHeight);
	}
	effectView.layer.cornerRadius = cornerRadius;
	effectView.clipsToBounds = true;
	[controlPane addSubview:effectView];

	UISwipeGestureRecognizer *swipe3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissControlPane:)];
	swipe3.direction = UISwipeGestureRecognizerDirectionRight;
	[effectView addGestureRecognizer:swipe3];

	powerOffSwitch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	powerOffSwitch.frame = CGRectMake(0, 0, screenHeightScale * 3, screenHeightScale);
	powerOffSwitch.backgroundColor = [UIColor clearColor];
	[powerOffSwitch setTitle:@"Power Off" forState:UIControlStateNormal];
	[powerOffSwitch setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[powerOffSwitch setTitleEdgeInsets:UIEdgeInsetsMake(0, screenHeightScale, 0, 0)];
	[powerOffSwitch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[powerOffSwitch addTarget:self action:@selector(powerOffSwitchPressed:) forControlEvents:UIControlEventTouchUpInside];
	[powerOffSwitch.titleLabel setFont:[UIFont systemFontOfSize:20]];
	[effectView.contentView addSubview:powerOffSwitch];
	powerOffSwitchImage = [[UIImageView alloc] initWithImage:[switchPanel imageOfSwitchState:FSSwitchStateOn controlState:UIControlStateNormal forSwitchIdentifier:@"com.a3tweaks.switch.rotation" usingTemplate:templateBundle]];
	powerOffSwitchImage.frame = CGRectMake((screenHeightScale / 2) - 15, (screenHeightScale / 2) - 15, 30, 30);
	[powerOffSwitch addSubview:powerOffSwitchImage];

	respringSwitch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	respringSwitch.frame = CGRectMake(0, screenHeightScale, screenHeightScale * 3, screenHeightScale);
	respringSwitch.backgroundColor = [UIColor clearColor];
	[respringSwitch setTitle:@"Respring" forState:UIControlStateNormal];
	[respringSwitch setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[respringSwitch setTitleEdgeInsets:UIEdgeInsetsMake(0, screenHeightScale, 0, 0)];
	[respringSwitch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[respringSwitch addTarget:self action:@selector(respringSwitchPressed:) forControlEvents:UIControlEventTouchUpInside];
	[respringSwitch.titleLabel setFont:[UIFont systemFontOfSize:20]];
	[effectView.contentView addSubview:respringSwitch];
	respringSwitchImage = [[UIImageView alloc] initWithImage:[switchPanel imageOfSwitchState:FSSwitchStateOn controlState:UIControlStateNormal forSwitchIdentifier:@"com.a3tweaks.switch.respring" usingTemplate:templateBundle]];
	respringSwitchImage.frame = CGRectMake((screenHeightScale / 2) - 15, (screenHeightScale / 2) - 15, 30, 30);
	[respringSwitch addSubview:respringSwitchImage];

	airplaneSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.airplane-mode" usingTemplate:templateBundle];
	airplaneSwitch.frame = CGRectMake(0, screenHeightScale * 2, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:airplaneSwitch];

	autoBrightnessSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.auto-brightness" usingTemplate:templateBundle];
	autoBrightnessSwitch.frame = CGRectMake(screenHeightScale, screenHeightScale * 2, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:autoBrightnessSwitch];

	autoLockSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.autolock" usingTemplate:templateBundle];
	autoLockSwitch.frame = CGRectMake(screenHeightScale * 2, screenHeightScale * 2, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:autoLockSwitch];

	bluetoothSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.bluetooth" usingTemplate:templateBundle];
	bluetoothSwitch.frame = CGRectMake(0, screenHeightScale * 3, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:bluetoothSwitch];

	dataSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.cellular-data" usingTemplate:templateBundle];
	dataSwitch.frame = CGRectMake(screenHeightScale, screenHeightScale * 3, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:dataSwitch];

	doNotDisturbSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.do-not-disturb" usingTemplate:templateBundle];
	doNotDisturbSwitch.frame = CGRectMake(screenHeightScale * 2, screenHeightScale * 3, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:doNotDisturbSwitch];

	flashlightSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.flashlight" usingTemplate:templateBundle];
	flashlightSwitch.frame = CGRectMake(0, screenHeightScale * 4, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:flashlightSwitch];

	hotspotSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.hotspot" usingTemplate:templateBundle];
	hotspotSwitch.frame = CGRectMake(screenHeightScale, screenHeightScale * 4, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:hotspotSwitch];

	locationSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.location" usingTemplate:templateBundle];
	locationSwitch.frame = CGRectMake(screenHeightScale * 2, screenHeightScale * 4, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:locationSwitch];

	lteSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.lte" usingTemplate:templateBundle];
	lteSwitch.frame = CGRectMake(0, screenHeightScale * 5, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:lteSwitch];

	ringerSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.ringer" usingTemplate:templateBundle];
	ringerSwitch.frame = CGRectMake(screenHeightScale, screenHeightScale * 5, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:ringerSwitch];

	rotationLockSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.rotation-lock" usingTemplate:templateBundle];
	rotationLockSwitch.frame = CGRectMake(screenHeightScale * 2, screenHeightScale * 5, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:rotationLockSwitch];

	vibrationSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.vibration" usingTemplate:templateBundle];
	vibrationSwitch.frame = CGRectMake(0, screenHeightScale * 6, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:vibrationSwitch];

	vpnSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.vpn" usingTemplate:templateBundle];
	vpnSwitch.frame = CGRectMake(screenHeightScale, screenHeightScale * 6, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:vpnSwitch];

	wifiSwitch = [switchPanel buttonForSwitchIdentifier:@"com.a3tweaks.switch.wifi" usingTemplate:templateBundle];
	wifiSwitch.frame = CGRectMake(screenHeightScale * 2, screenHeightScale * 6, screenHeightScale, screenHeightScale);
	[effectView.contentView addSubview:wifiSwitch];

	volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(screenHeightScale, screenHeightScale * 7, (screenHeightScale * 2) - 20, screenHeightScale)];
	volumeSlider.backgroundColor = [UIColor clearColor];
	volumeSlider.continuous = YES;
	volumeSlider.minimumValue = 0.0;
	volumeSlider.maximumValue = 1.0;
	volumeSlider.value = [[%c(SBMediaController) sharedInstance] volume];
	volumeSlider.maximumTrackTintColor = [UIColor blackColor];
	volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
	[volumeSlider addTarget:self action:@selector(volumeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
	[effectView.contentView addSubview:volumeSlider];
	volumeSliderImage = [[UIImageView alloc] initWithImage:[switchPanel imageOfSwitchState:FSSwitchStateOn controlState:UIControlStateNormal forSwitchIdentifier:@"com.a3tweaks.switch.ringer" usingTemplate:templateBundle]];
	volumeSliderImage.frame = CGRectMake((screenHeightScale / 2) - 15, ((screenHeightScale / 2) - 15) + (screenHeightScale * 7), 30, 30);
	[effectView.contentView addSubview:volumeSliderImage];

	brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(screenHeightScale, screenHeightScale * 8, (screenHeightScale * 2) - 20, screenHeightScale)];
	brightnessSlider.backgroundColor = [UIColor clearColor];
	brightnessSlider.continuous = YES;
	brightnessSlider.minimumValue = 0.0;
	brightnessSlider.maximumValue = 1.0;
	brightnessSlider.value = [UIScreen mainScreen].brightness;
	brightnessSlider.maximumTrackTintColor = [UIColor blackColor];
	brightnessSlider.minimumTrackTintColor = [UIColor whiteColor];
	[brightnessSlider addTarget:self action:@selector(brightnessSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
	[effectView.contentView addSubview:brightnessSlider];
	brightnessSliderImage = [[UIImageView alloc] initWithImage:[switchPanel imageOfSwitchState:FSSwitchStateOn controlState:UIControlStateNormal forSwitchIdentifier:@"com.a3tweaks.switch.auto-brightness" usingTemplate:templateBundle]];
	brightnessSliderImage.frame = CGRectMake((screenHeightScale / 2) - 15, ((screenHeightScale / 2) - 15) + (screenHeightScale * 8), 30, 30);
	[effectView.contentView addSubview:brightnessSliderImage];

	albumArtworkImage = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ControlPanePrefs.bundle/albumart.png"] _flatImageWithColor:[UIColor whiteColor]]];
	albumArtworkImage.frame = CGRectMake((screenHeightScale / 2) - 15, ((screenHeightScale / 2) - 15) + (screenHeightScale * 7), 30, 30);
	albumArtworkImage.userInteractionEnabled = YES;
	albumArtworkImage.layer.cornerRadius = 5;
	albumArtworkImage.clipsToBounds = true;
	albumArtworkImage.alpha = 0.0;
	[effectView.contentView addSubview:albumArtworkImage];

	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openNowPlayingApplication:)];
	[albumArtworkImage addGestureRecognizer:tap2];

	songTitleLabel = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(screenHeightScale, screenHeightScale * 7, (screenHeightScale * 2) - 20, screenHeightScale / 2)];
	songTitleLabel.textColor = [UIColor whiteColor];
	songTitleLabel.textAlignment = NSTextAlignmentLeft;
	songTitleLabel.font = [UIFont systemFontOfSize:20];
	songTitleLabel.backgroundColor = [UIColor clearColor];
	songTitleLabel.text = @"Song Title";
	songTitleLabel.alpha = 0.0;
	songTitleLabel.labelSpacing = 30.0;
	songTitleLabel.pauseInterval = 3.0;
	songTitleLabel.scrollSpeed = 30.0;
	songTitleLabel.fadeLength = 0.0;
	songTitleLabel.scrollDirection = CBAutoScrollDirectionLeft;
	[effectView.contentView addSubview:songTitleLabel];

	artistNameLabel = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(screenHeightScale, (screenHeightScale * 7) + (screenHeightScale / 2), (screenHeightScale * 2) - 20, screenHeightScale / 2)];
	artistNameLabel.textColor = [UIColor whiteColor];
	artistNameLabel.textAlignment = NSTextAlignmentLeft;
	artistNameLabel.font = [UIFont systemFontOfSize:20];
	artistNameLabel.backgroundColor = [UIColor clearColor];
	artistNameLabel.text = @"Artist Name";
	artistNameLabel.alpha = 0.0;
	artistNameLabel.labelSpacing = 30.0;
	artistNameLabel.pauseInterval = 3.0;
	artistNameLabel.scrollSpeed = 30.0;
	artistNameLabel.fadeLength = 0.0;
	artistNameLabel.scrollDirection = CBAutoScrollDirectionLeft;
	[effectView.contentView addSubview:artistNameLabel];

	trackProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	trackProgressView.frame = CGRectMake(20, (screenHeightScale * 8) - 0.5, (screenHeightScale * 3) - 40, 1);
	trackProgressView.progress = 0.0;
	trackProgressView.trackTintColor = [UIColor blackColor];
	trackProgressView.progressTintColor = [UIColor whiteColor];
	trackProgressView.alpha = 0.0;
	[effectView.contentView addSubview:trackProgressView];

	rewindButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	rewindButton.frame = CGRectMake((screenHeightScale / 2) - 18.75, ((screenHeightScale / 2) - 18.75) + (screenHeightScale * 8), 37.5, 37.5);
	rewindButton.backgroundColor = [UIColor clearColor];
	rewindButton.tintColor = [UIColor whiteColor];
	rewindButton.alpha = 0.0;
	[rewindButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ControlPanePrefs.bundle/rewind.png"] _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
	[rewindButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[rewindButton addTarget:self action:@selector(rewindSwitchPressed:) forControlEvents:UIControlEventTouchUpInside];
	[effectView.contentView addSubview:rewindButton];

	playPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	playPauseButton.frame = CGRectMake((screenHeightScale / 2) - 18.75 + screenHeightScale, ((screenHeightScale / 2) - 18.75) + (screenHeightScale * 8), 37.5, 37.5);
	playPauseButton.backgroundColor = [UIColor clearColor];
	playPauseButton.tintColor = [UIColor whiteColor];
	playPauseButton.alpha = 0.0;
	[playPauseButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ControlPanePrefs.bundle/play.png"] _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
	[playPauseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[playPauseButton addTarget:self action:@selector(playPauseSwitchPressed:) forControlEvents:UIControlEventTouchUpInside];
	[effectView.contentView addSubview:playPauseButton];

	fastForwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	fastForwardButton.frame = CGRectMake((screenHeightScale / 2) - 18.75 + (screenHeightScale * 2), ((screenHeightScale / 2) - 18.75) + (screenHeightScale * 8), 37.5, 37.5);
	fastForwardButton.backgroundColor = [UIColor clearColor];
	fastForwardButton.tintColor = [UIColor whiteColor];
	fastForwardButton.alpha = 0.0;
	[fastForwardButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ControlPanePrefs.bundle/fastforward.png"] _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
	[fastForwardButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[fastForwardButton addTarget:self action:@selector(fastForwardSwitchPressed:) forControlEvents:UIControlEventTouchUpInside];
	[effectView.contentView addSubview:fastForwardButton];

	if (showSeparators) {
		UIView *horizontalLineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, (screenHeightScale * 2) - 0.5, (screenHeightScale * 3) - 20, 1)];
		horizontalLineView1.backgroundColor = [UIColor whiteColor];
		[effectView.contentView addSubview:horizontalLineView1];

		UIView *horizontalLineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, (screenHeightScale * 7) - 0.5, (screenHeightScale * 3) - 20, 1)];
		horizontalLineView2.backgroundColor = [UIColor whiteColor];
		[effectView.contentView addSubview:horizontalLineView2];
	}

	alertView = [[UIAlertView alloc] initWithTitle:@"Power Off?" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];

	updateTrackProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTrackProgress:) userInfo:nil repeats:YES];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVolumeLevel:) name:@"SBMediaVolumeChangedNotification" object:[%c(SBMediaController) sharedInstance]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBrightnessLevel:) name:@"UIScreenBrightnessDidChangeNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNowPlayingInfo:) name:@"kMRMediaRemoteNowPlayingInfoDidChangeNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNowPlayingStatus:) name:@"kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification" object:nil];
}

%new
- (void)dismissControlPane:(id)sender {
	[UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
		CGRect newEffectViewFrame = effectView.frame;
		if (leftyMode) {
			newEffectViewFrame.origin.x = 0 - (screenHeightScale * 3);
		}

		else {
			newEffectViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width;
		}
		effectView.frame = newEffectViewFrame;
		paneDimView.alpha = 0.0;
    }
    completion:^(BOOL finished) {
		controlPane.hidden = YES;
	}];
}

%new
- (void)switchButtonPages:(id)sender {
	if (isOnFirstPage) {
		[UIView animateWithDuration:0.125 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
			[powerOffSwitch setTitle:@"Reboot" forState:UIControlStateNormal];
			[respringSwitch setTitle:@"Safe Mode" forState:UIControlStateNormal];
			volumeSlider.alpha = 0.0;
			volumeSliderImage.alpha = 0.0;
			brightnessSlider.alpha = 0.0;
			brightnessSliderImage.alpha = 0.0;
    	}
    	completion:^(BOOL finished) {
			[UIView animateWithDuration:0.125 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
				albumArtworkImage.alpha = 1.0;
				songTitleLabel.alpha = 1.0;
				artistNameLabel.alpha = 1.0;
				trackProgressView.alpha = 1.0;
				rewindButton.alpha = 1.0;
				playPauseButton.alpha = 1.0;
				fastForwardButton.alpha = 1.0;
    		}
    		completion:^(BOOL finished) {
    			isOnFirstPage = NO;
			}];
		}];
	}

	else {
		[UIView animateWithDuration:0.125 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
			[powerOffSwitch setTitle:@"Power Off" forState:UIControlStateNormal];
			[respringSwitch setTitle:@"Respring" forState:UIControlStateNormal];
			albumArtworkImage.alpha = 0.0;
			songTitleLabel.alpha = 0.0;
			artistNameLabel.alpha = 0.0;
			trackProgressView.alpha = 0.0;
			rewindButton.alpha = 0.0;
			playPauseButton.alpha = 0.0;
			fastForwardButton.alpha = 0.0;
    	}
    	completion:^(BOOL finished) {
			[UIView animateWithDuration:0.125 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
				volumeSlider.alpha = 1.0;
				volumeSliderImage.alpha = 1.0;
				brightnessSlider.alpha = 1.0;
				brightnessSliderImage.alpha = 1.0;
    		}
    		completion:^(BOOL finished) {
    			isOnFirstPage = YES;
			}];
		}];
	}
}

%new
- (void)powerOffSwitchPressed:(id)sender {
	[UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
		CGRect newEffectViewFrame = effectView.frame;
		if (leftyMode) {
			newEffectViewFrame.origin.x = 0 - (screenHeightScale * 3);
		}

		else {
			newEffectViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width;
		}
		effectView.frame = newEffectViewFrame;
		paneDimView.alpha = 0.0;
    }
    completion:^(BOOL finished) {
		controlPane.hidden = YES;
		if (shouldConfirm) {
			if (isOnFirstPage) {
				alertView.title = @"Power Off?";
			}

			else {
				alertView.title = @"Reboot?";
			}
			[alertView show];
		}

		else {
			if (isOnFirstPage) {
				[[UIApplication sharedApplication] _powerDownNow];
			}

			else {
				[[UIApplication sharedApplication] _rebootNow];
			}
		}
	}];
}

%new
- (void)respringSwitchPressed:(id)sender {
	[UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
		CGRect newEffectViewFrame = effectView.frame;
		if (leftyMode) {
			newEffectViewFrame.origin.x = 0 - (screenHeightScale * 3);
		}

		else {
			newEffectViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width;
		}
		effectView.frame = newEffectViewFrame;
		paneDimView.alpha = 0.0;
    }
    completion:^(BOOL finished) {
		controlPane.hidden = YES;
		if (shouldConfirm) {
			if (isOnFirstPage) {
				alertView.title = @"Respring?";
			}

			else {
				alertView.title = @"Safe Mode?";
			}
			[alertView show];
		}

		else {
			if (isOnFirstPage) {
				[[UIApplication sharedApplication] _relaunchSpringBoardNow];
			}

			else {
				FILE *tmp = fopen("/var/mobile/Library/Preferences/com.saurik.mobilesubstrate.dat", "w");
        		fclose(tmp);
        		[[UIApplication sharedApplication] _relaunchSpringBoardNow];
			}
		}
	}];
}

%new
- (void)volumeSliderValueChanged:(id)sender {
	[[%c(SBMediaController) sharedInstance] setVolume:volumeSlider.value];
}

%new
- (void)brightnessSliderValueChanged:(id)sender {
	[[%c(SBBrightnessController) sharedBrightnessController] setBrightnessLevel:brightnessSlider.value];
}

%new
- (void)openNowPlayingApplication:(id)sender {
	MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean isPlaying) {
		if ((BOOL)isPlaying) {
			MRMediaRemoteGetNowPlayingApplicationPID(dispatch_get_main_queue(), ^(int PID) {
				[UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
					CGRect newEffectViewFrame = effectView.frame;
					if (leftyMode) {
						newEffectViewFrame.origin.x = 0 - (screenHeightScale * 3);
					}

					else {
						newEffectViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width;
					}
					effectView.frame = newEffectViewFrame;
					paneDimView.alpha = 0.0;
			    }
			    completion:^(BOOL finished) {
					controlPane.hidden = YES;
					[[%c(SBUIController) sharedInstance] activateApplicationAnimated:[[%c(SBApplicationController) sharedInstance] applicationWithPid:PID]];
				}];
    		});
		}
    });
}

%new
- (void)rewindSwitchPressed:(id)sender {
    [[%c(SBMediaController) sharedInstance] changeTrack:-1];
}

%new
- (void)playPauseSwitchPressed:(id)sender {
    [[%c(SBMediaController) sharedInstance] togglePlayPause];
}

%new
- (void)fastForwardSwitchPressed:(id)sender {
    [[%c(SBMediaController) sharedInstance] changeTrack:1];
}

%new
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
			controlPane.hidden = NO;
			CGRect newEffectViewFrame = effectView.frame;
			if (leftyMode) {
				newEffectViewFrame.origin.x = 0;
			}

			else {
				newEffectViewFrame.origin.x = screenWidth - (screenHeightScale * 3);
			}
			effectView.frame = newEffectViewFrame;
			paneDimView.alpha = dimViewAlpha;
    	}
    	completion:^(BOOL finished) {
		}];
    }
    else if ([alertView.title isEqual:@"Power Off?"]) {

		[[UIApplication sharedApplication] _powerDownNow];
    }

    else if ([alertView.title isEqual:@"Respring?"]) {
		[[UIApplication sharedApplication] _relaunchSpringBoardNow];
    }

    else if ([alertView.title isEqual:@"Reboot?"]) {
		[[UIApplication sharedApplication] _rebootNow];
    }

    else {
		FILE *tmp = fopen("/var/mobile/Library/Preferences/com.saurik.mobilesubstrate.dat", "w");
        fclose(tmp);
        [[UIApplication sharedApplication] _relaunchSpringBoardNow];
    }
}

%new
- (void)updateTrackProgress:(id)sender {
	[trackProgressView setProgress:[[%c(MPUNowPlayingController) sharedInstance] currentElapsed] / [[%c(MPUNowPlayingController) sharedInstance] currentDuration] animated:YES];
}

%new
- (void)updateVolumeLevel:(NSNotification *)notification {
	volumeSlider.value = [[%c(SBMediaController) sharedInstance] volume];
}

%new
- (void)updateBrightnessLevel:(NSNotification *)notification {
	brightnessSlider.value = [UIScreen mainScreen].brightness;
}

%new
- (void)updateNowPlayingInfo:(NSNotification *)notification {
	MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean isPlaying) {
		if ((BOOL)isPlaying) {
			MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
				NSDictionary *info = (NSDictionary *)result;
       			albumArtworkImage.image = [UIImage imageWithData:[info objectForKey:@"kMRMediaRemoteNowPlayingInfoArtworkData"]];
				songTitleLabel.text = [info objectForKey:@"kMRMediaRemoteNowPlayingInfoTitle"];
				artistNameLabel.text = [info objectForKey:@"kMRMediaRemoteNowPlayingInfoArtist"];
    		});
		}

		else { 
			albumArtworkImage.image = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ControlPanePrefs.bundle/albumart.png"] _flatImageWithColor:[UIColor whiteColor]];
			songTitleLabel.text = @"Song Title";
			artistNameLabel.text = @"Artist Name";
		}
    });
}

%new
- (void)updateNowPlayingStatus:(NSNotification *)notification {
    MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean isPlaying) {
		if ((BOOL)isPlaying) {
			[playPauseButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ControlPanePrefs.bundle/pause.png"] _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
		}

		else { 
			[playPauseButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ControlPanePrefs.bundle/play.png"] _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
		}
    });
}
%end

%hook MPUNowPlayingController
- (id)init {
	nowPlayingController = self;
	return %orig;
}

%new
+ (id)sharedInstance {
	return nowPlayingController;
}
%end

%hook SBPowerDownController
- (void)activate {
	if (replacePowerDownScreen) {
		if (controlPane.hidden && enabled) {
			[UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
				controlPane.hidden = NO;
				CGRect newEffectViewFrame = effectView.frame;
				if (leftyMode) {
					newEffectViewFrame.origin.x = 0;
				}

				else {
					newEffectViewFrame.origin.x = screenWidth - (screenHeightScale * 3);
				}
				effectView.frame = newEffectViewFrame;
				paneDimView.alpha = dimViewAlpha;
    		}
    		completion:^(BOOL finished) {
			}];
		}

		else {
			[UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
				CGRect newEffectViewFrame = effectView.frame;
				if (leftyMode) {
					newEffectViewFrame.origin.x = 0 - (screenHeightScale * 3);
				}

				else {
					newEffectViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width;
				}
				effectView.frame = newEffectViewFrame;
				paneDimView.alpha = 0.0;
    		}
    		completion:^(BOOL finished) {
				controlPane.hidden = YES;
			}];
		}

		[self cancel];
		[self deactivate];
	}

	else {
		%orig;
	}
}
%end

@interface ControlPaneActivator : NSObject <LAListener>
@end

@implementation ControlPaneActivator
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    if (controlPane.hidden && enabled) {
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            controlPane.hidden = NO;
            CGRect newEffectViewFrame = effectView.frame;
            if (leftyMode) {
                newEffectViewFrame.origin.x = 0;
            }

            else {
                newEffectViewFrame.origin.x = screenWidth - (screenHeightScale * 3);
            }
            effectView.frame = newEffectViewFrame;
            paneDimView.alpha = dimViewAlpha;
        }
        completion:^(BOOL finished) {
        }];
    }

    else {
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect newEffectViewFrame = effectView.frame;
            if (leftyMode) {
                newEffectViewFrame.origin.x = 0 - (screenHeightScale * 3);
            }

            else {
                newEffectViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width;
            }
            effectView.frame = newEffectViewFrame;
            paneDimView.alpha = 0.0;
        }
        completion:^(BOOL finished) {
            controlPane.hidden = YES;
        }];
    }

    [event setHandled:YES];
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
    [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        CGRect newEffectViewFrame = effectView.frame;
        if (leftyMode) {
            newEffectViewFrame.origin.x = 0 - (screenHeightScale * 3);
        }

        else {
            newEffectViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width;
        }
        effectView.frame = newEffectViewFrame;
        paneDimView.alpha = 0.0;
    }
    completion:^(BOOL finished) {
        controlPane.hidden = YES;
    }];
}

+ (void)load {
    if ([LASharedActivator isRunningInsideSpringBoard]) {
            [LASharedActivator registerListener:[self new] forName:@"com.TweaksByLogan.ControlPane"];
    }
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    return @"ControlPane";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    return @"Show the ControlPane";
}

- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}

- (UIImage *)activator:(LAActivator *)activator requiresIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
    return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ControlPanePrefs.bundle/ControlPanePrefs.png"];
}

- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
    return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ControlPanePrefs.bundle/ControlPanePrefs.png"];
}
@end

%ctor {
	loadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.tweaksbylogan.controlpane/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
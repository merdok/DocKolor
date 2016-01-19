#import <UIKit/UIKit.h>


@interface SBWallpaperEffectView : UIView
@end


#define kDockColorSettings @"/var/mobile/Library/Preferences/com.cabralcole.dockolor.plist"

static NSMutableDictionary *settings;
void refreshPrefs()
{
		if(kCFCoreFoundationVersionNumber > 900.00){ // iOS 8.0

			[settings release];
			CFStringRef appID2 = CFSTR("com.cabralcole.dockolor");
			CFArrayRef keyList = CFPreferencesCopyKeyList(appID2, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
			if(keyList)
			{
				settings = (NSMutableDictionary *)CFPreferencesCopyMultiple(keyList, appID2, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
				CFRelease(keyList);
			} else
			{
				settings = nil;
			}
		}
		else
		{
			[settings release];
			settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[kDockColorSettings stringByExpandingTildeInPath]]; //Load settings the old way.
	}
}


static void killPrefs() {
	system("/usr/bin/killall -9 SpringBoard");
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
refreshPrefs();
}

%group main

%hook SBDockView

- (void)layoutSubviews
{
	if(settings != nil && ([settings count] != 0) && [[settings objectForKey:@"enabled"] boolValue])
	{
		%orig;
		SBWallpaperEffectView *bgView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");
		[bgView setBackgroundColor:[self colorFromHex:[settings objectForKey:@"aColor"]]];
		[bgView setStyle:0]; // ClearDock
	}
	%orig;
}

%new
-(UIColor *)colorFromHex:(NSString *)hexString
{
    unsigned rgbValue = 0;
    if ([hexString hasPrefix:@"#"]) hexString = [hexString substringFromIndex:1];
    if (hexString) {
    NSArray *getAlpha = [hexString componentsSeparatedByString:@":"];

    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:0]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];

   return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:[[getAlpha objectAtIndex:1] floatValue]];

    }
	else return [UIColor whiteColor];
}

%end

%end

    %ctor {
	@autoreleasepool {
				settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[kDockColorSettings stringByExpandingTildeInPath]];
				CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.cabralcole.dockolor/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
				refreshPrefs();
		%init(main);
	}
}
#import <Preferences/Preferences.h>

#define exampleTweakPreferencePath @"/User/Library/Preferences/com.openro0t.TCPLight.plist"
static int count;
@interface TCPLightListController: PSEditableListController {
    
}
@end

@interface TCPLightNextPane: PSListController {
    NSInteger percentage;
    NSInteger index;
}
@end

@implementation TCPLightListController

- (id)specifiers {
    extern NSString* PSDeletionActionKey;
	if(_specifiers == nil) {
        NSMutableArray *specifiers = [[NSMutableArray alloc] init];
        PSSpecifier *spec;
        spec = [PSSpecifier groupSpecifierWithHeader:@"TCP Lights IP Address" footer:@"Open the TCP app, go to the configure tab, go to \"System Information\", then put in your Gate way IP Address."];
        [specifiers addObject:spec];
        spec = [PSSpecifier preferenceSpecifierNamed:@""
                                                       target:self
                                                          set:@selector(setPreferenceValue:specifier:)
                                                          get:@selector(readPreferenceValue:)
                                                       detail:Nil
                                                         cell:PSEditTextCell
                                                         edit:Nil];
        [spec setProperty:@"IPAddress" forKey:@"key"];
        [spec setProperty:@"com.openro0t.TCPLight-reloadSettings" forKey:@"PostNotification"];
        [specifiers addObject:spec];
        spec = [PSSpecifier emptyGroupSpecifier];
        [specifiers addObject:spec];
        NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:exampleTweakPreferencePath];
        count = [[prefs objectForKey:@"specCount"] intValue];
        for (int i=1; i<=count; i++) {
            NSString *customNum = [NSString stringWithFormat:@"custom%d", i];
            int percentage = [[prefs objectForKey:customNum] intValue];
            spec = [PSSpecifier preferenceSpecifierNamed:[NSString stringWithFormat:@"%d%%", percentage]
                                              target:self
                                                 set:NULL
                                                 get:NULL
                                              detail:NSClassFromString(@"TCPLightNextPane")
                                                cell:PSLinkCell
                                                edit:Nil];
            [spec setProperty:@(i) forKey:@"index"];
            [spec setProperty:@(percentage) forKey:@"percentage"];
            [spec setProperty:NSStringFromSelector(@selector(removedSpecifier:)) forKey:PSDeletionActionKey];
            [specifiers addObject:spec];
        }
        spec = [PSSpecifier preferenceSpecifierNamed:@"New custom dim..."
                                              target:self
                                                 set:NULL
                                                 get:NULL
                                              detail:Nil
                                                cell:PSButtonCell
                                                edit:Nil];
        spec->action = @selector(newCustom);
        [spec setProperty:NSClassFromString(@"TCPTintedButtonCell") forKey:@"cellClass"];
        [specifiers addObject:spec];
        spec = [PSSpecifier emptyGroupSpecifier];
        [specifiers addObject:spec];
        spec = [PSSpecifier preferenceSpecifierNamed:@"Riley Durant"
                                              target:self
                                                 set:NULL
                                                 get:NULL
                                              detail:Nil
                                                cell:PSButtonCell
                                                edit:Nil];
        spec->action = @selector(openTwitter:);
        [spec setProperty:@"openro0t" forKey:@"screenName"];
        [spec setProperty:NSClassFromString(@"TCPCoolTwitterCell") forKey:@"cellClass"];
        [specifiers addObject:spec];
        spec = [PSSpecifier preferenceSpecifierNamed:@"Milo Darling"
                                              target:self
                                                 set:NULL
                                                 get:NULL
                                              detail:Nil
                                                cell:PSButtonCell
                                                edit:Nil];
        spec->action = @selector(openTwitter:);
        [spec setProperty:@"JamesIscNeutron" forKey:@"screenName"];
        [spec setProperty:NSClassFromString(@"TCPCoolTwitterCell") forKey:@"cellClass"];
        [specifiers addObject:spec];
        spec = [PSSpecifier preferenceSpecifierNamed:@"Source on GitHub"
                                              target:self
                                                 set:NULL
                                                 get:NULL
                                              detail:Nil
                                                cell:PSButtonCell
                                                edit:Nil];
        spec->action = @selector(openGit);
        [spec setProperty:NSClassFromString(@"TCPTintedButtonCell") forKey:@"cellClass"];
        [specifiers addObject:spec];
        _specifiers = [specifiers copy];
		//_specifiers = [[self loadSpecifiersFromPlistName:@"TCPLight" target:self] retain];
	}
	return _specifiers;
}

-(void)newCustom {
    count++;
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:exampleTweakPreferencePath]];
    [defaults setObject:@(count) forKey:@"specCount"];
    [defaults writeToFile:exampleTweakPreferencePath atomically:YES];
    [self showController:[[TCPLightNextPane alloc] init] animate:YES];
    CFNotificationCenterPostNotification ( CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.openro0t.TCPLight-listenersChanged"), NULL, NULL, CFNotificationSuspensionBehaviorDeliverImmediately );
    //[self reloadSpecifiers];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isMovingToParentViewController) {
        [self reloadSpecifiers];
    }
}

-(void)openTwitter:(PSSpecifier *)specifier {
    NSString *screenName = specifier.properties[@"screenName"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/%@", screenName]]];
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitterrific:///profile?screen_name=%@", screenName]]];
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetings:///user?screen_name=%@", screenName]]];
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", screenName]]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://mobile.twitter.com/%@", screenName]]];
}

-(void)openGit {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/openro0t/Opensource/tree/master/tcplight"]];
}

-(void)removedSpecifier:(PSSpecifier *)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:exampleTweakPreferencePath]];
    int index = [specifier.properties[@"index"] intValue];
    for (int i=index+1; i<=count; i++) {
        NSString *originalCustom = [NSString stringWithFormat:@"custom%d", i];
        NSString *newCustom = [NSString stringWithFormat:@"custom%d", i-1];
        [defaults setObject:[defaults objectForKey:originalCustom] forKey:newCustom];
    }
    [defaults removeObjectForKey:[NSString stringWithFormat:@"custom%d", count]];
    count--;
    [defaults setObject:@(count) forKey:@"specCount"];
    [defaults writeToFile:exampleTweakPreferencePath atomically:YES];
    CFNotificationCenterPostNotification ( CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.openro0t.TCPLight-listenersChanged"), NULL, NULL, CFNotificationSuspensionBehaviorDeliverImmediately );
    [self reloadSpecifiers];
}

-(id)readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *exampleTweakSettings = [NSDictionary dictionaryWithContentsOfFile:exampleTweakPreferencePath];
    if (!exampleTweakSettings[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }
    return exampleTweakSettings[specifier.properties[@"key"]];
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:exampleTweakPreferencePath]];
    double tempVal = [value intValue];
    int rounded = (int)(tempVal + 0.5);
    [defaults setObject:@(rounded) forKey:specifier.properties[@"key"]];
    [defaults writeToFile:exampleTweakPreferencePath atomically:YES];
    //NSDictionary *exampleTweakSettings = [NSDictionary dictionaryWithContentsOfFile:exampleTweakPreferencePath];
    CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
    if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

@end

@implementation TCPLightNextPane

-(void)loadView {
    [super loadView];
    self.navigationItem.title = @"Custom Dimming";
}
- (void)setSpecifier:(PSSpecifier *)specifier {
    [super setSpecifier:specifier];
    //NSLog(@"[TCPLight] specifier: %@", specifier);
    NSDictionary *properties = specifier.properties;
    percentage = [properties[@"percentage"] intValue];
    index = [properties[@"index"] intValue];
    //this is where you can get any properties of the specifier tapped that you need, such as the name.
}

-(id)specifiers {
    if (_specifiers == nil) {
        NSMutableArray *specifiers = [[NSMutableArray alloc] init];
        PSSpecifier *spec;
        spec = [PSSpecifier preferenceSpecifierNamed:@"Dim level"
                                              target:self
                                                 set:@selector(setPreferenceValue:specifier:)
                                                 get:@selector(readPreferenceValue:)
                                              detail:Nil
                                                cell:PSSliderCell
                                                edit:Nil];
        index = index ?: count;
        [spec setProperty:[NSString stringWithFormat:@"custom%d", (int)index] forKey:@"key"];
        [spec setProperty:@(percentage) forKey:@"value"];
        [spec setProperty:@0 forKey:@"min"];
        [spec setProperty:@100 forKey:@"max"];
        [spec setProperty:@YES forKey:@"showValue"];
        [specifiers addObject:spec];
        spec = [PSSpecifier preferenceSpecifierNamed:@"Activation Method"
                                              target:self
                                                 set:NULL
                                                 get:NULL
                                              detail:Nil
                                                cell:PSLinkCell
                                                edit:Nil];
        [spec setProperty:@YES forKey:@"isContoller"];
        [spec setProperty:[NSString stringWithFormat:@"com.openro0t.TCPLight.custom%d", (int)index] forKey:@"activatorListener"];
        [spec setProperty:@"/System/Library/PreferenceBundles/LibActivator.bundle" forKey:@"lazy-bundle"];
        spec->action = @selector(lazyLoadBundle:);
        [specifiers addObject:spec];
        _specifiers = [specifiers copy];
    }
    return _specifiers;
}

-(id)readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *exampleTweakSettings = [NSDictionary dictionaryWithContentsOfFile:exampleTweakPreferencePath];
    if (!exampleTweakSettings[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }
    return exampleTweakSettings[specifier.properties[@"key"]];
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:exampleTweakPreferencePath]];
    double tempVal = [value intValue];
    int rounded = (int)(tempVal + 0.5);
    [defaults setObject:@(rounded) forKey:specifier.properties[@"key"]];
    [defaults writeToFile:exampleTweakPreferencePath atomically:YES];
    //NSDictionary *exampleTweakSettings = [NSDictionary dictionaryWithContentsOfFile:exampleTweakPreferencePath];
    CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
    if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

@end

@interface TCPCoolTwitterCell : PSTableCell { }
@end
@implementation TCPCoolTwitterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:specifier.properties[@"big"] && ((NSNumber *)specifier.properties[@"big"]).boolValue ? UITableViewCellStyleSubtitle : UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier specifier:specifier];
    if (self) {
        self.detailTextLabel.text = [NSString stringWithFormat:@"@%@", specifier.properties[@"screenName"]];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.5568627451f alpha:1];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.textColor = [UIColor colorWithRed:48.0f/255.0f green:56.0f/255.0f blue:103.0f/255.0f alpha:1.0];
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end

@interface TCPTintedButtonCell : PSTableCell { }
@end
@implementation TCPTintedButtonCell
-(void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.textColor = [UIColor colorWithRed:48.0f/255.0f green:56.0f/255.0f blue:103.0f/255.0f alpha:1.0];
}
@end

//vim:ft=objc

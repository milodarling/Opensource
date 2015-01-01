#import <Preferences/Preferences.h>

@interface TCPLightListController: PSListController {
}
@end

@implementation TCPLightListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"TCPLight" target:self] retain];
	}
	return _specifiers;
}

-(void)openTwitter {
	if 	([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/openro0t"]];
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
    	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=openro0t"]];
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"safari:"]])
    		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/openro0t"]];
}

-(void)openGit {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/openro0t/Opensource/tree/master/tcplight"]];
}
@end

//vim:ft=objc

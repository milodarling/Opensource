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
@end

// vim:ft=objc

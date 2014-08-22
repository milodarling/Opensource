#import "libactivator.h"
#import <notify.h>

@interface SBLockScreenView : NSObject
-(void)setCustomSlideToUnlockText:(id)arg1;
@end

@interface ShuffleLock : NSObject<LAListener> 


@end

NSDictionary *prefs;
NSArray *phraseArray;

int counter = 0;
id sbLSView;

@implementation ShuffleLock

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	notify_post("com.cortex.shuffle.change");
	counter += 1;
}
@end

+(void)load {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"com.cortex.shuffle"];
	prefs = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/ShuffleLock.plist"]];
	phraseArray = [NSMutableArray array];

if (prefs[@"textBox1"]){
	[phraseArray addObject:prefs[@"textBox1"]];
}
if (prefs[@"textBox2"]){
	[phraseArray addObject:prefs[@"textBox2"]];
}
if (prefs[@"textBox3"]){
	[phraseArray addObject:prefs[@"textBox3"]];
}
if (prefs[@"textBox4"]){
	[phraseArray addObject:prefs[@"textBox4"]];
}
if (prefs[@"textBox5"]){
	[phraseArray addObject:prefs[@"textBox5"]];
}

[p release];
@end

%hook SBLockScreenView
//fucking up here
-(void)setCustomSlideToUnlockText:(id)arg1 {
	sbLSView = self;
	NSString* replacementString = [phraseArray objectAtIndex:counter];
	%orig(replacementString);
}

%end

void shiftSTU() {
	[sbLSView setCustomSlideToUnlockText:@"It shouldnt actually matter what I put here"];
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    (CFNotificationCallback)shiftSTU,
                                    CFSTR("com.cortex.shuffle.change"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    shiftSTU();
}
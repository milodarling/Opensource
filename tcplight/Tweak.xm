#import "Activator.h"
#import <UIKit/UIKit.h>

@interface ALGHActivatorListener : NSObject <LAListener> {
    int count;
    NSDictionary *prefs;
    NSString *IPAddress;
}
-(void)sendRequest:(NSString *)post;
-(void)loadPrefs;
-(void)updateListeners;
@end

ALGHActivatorListener *listener;

@implementation ALGHActivatorListener

- (id)init {
    self = [super init];
    if (self) {
        count = 0;
        [self updateListeners];
    }
    return self;
}

- (void)updateListeners {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (count) {
        for (int i=1; i<=count; i++) {
            [[LAActivator sharedInstance] unregisterListenerWithName:[NSString stringWithFormat:@"com.openro0t.TCPLight.custom%d", i]];
        }
    }
    [self loadPrefs]; //gets new count value
    for (int i=1; i<=count; i++) {
        [[LAActivator sharedInstance] registerListener:self forName:[NSString stringWithFormat:@"com.openro0t.TCPLight.custom%d", i]];
    }
    [pool drain];
}

- (void)loadPrefs {
    prefs = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.openro0t.TCPLight.plist"];
    count = [[prefs objectForKey:@"specCount"] intValue]; //number of listeners enabled by the user
    IPAddress = [prefs objectForKey:@"IPAddress"];
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
    @autoreleasepool {
        if (!IPAddress) {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"TCPLight"
                                                             message:@"Please set an IP Address"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles: nil];
            [alert show];
            return;
        }
        NSString *listenerNumber = [listenerName substringFromIndex:28];
        prefs = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.openro0t.TCPLight.plist"];
        int dimLevel = [[prefs objectForKey:[@"custom" stringByAppendingString:listenerNumber]] intValue];
        
        //turn on
        //this is the actual request, with the info used by the TCP lights. This was what went in the --data part of the curl command
        NSString *post = @"cmd=DeviceSendCommand&data=<gip><version>1</version><token>123456783423</token><did>216495999882663230</did><value>1</value></gip>&fmt=xml";
        //post the request in this method
        [self sendRequest:post];
        
        //apply dim
        post = [NSString stringWithFormat:@"cmd=DeviceSendCommand&data=<gip><version>1</version><token>1234567890</token><did>216495999882663230</did><value>%d</value><type>level</type></gip>&fmt=xml", dimLevel];
        [self sendRequest:post];
	}
}

-(void)sendRequest:(NSString *)post {
    //http://stackoverflow.com/questions/15749486/sending-an-http-post-request-on-ios
    
    //this converts the NSString to NSData for the request
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //gets the length (size) of the data to be sent, in NSString format
    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
    //create a request
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    //set the url for the request (the IP address will not be hardcoded when it's done)
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/gwr/gop.php", IPAddress]]];
    //set it as an HTML POST request, not GET
    [request setHTTPMethod:@"POST"];
    //tell the server/request how much data will be sent
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //tell the server/request what kind of info is being transmitted (in this case form data)
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //set the actual content as the NSData
    [request setHTTPBody:postData];
    //make the actual connection
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:Nil];
    //I believe conn evaluates to true if success, and false if failure. There are also these methods if we want:
    
    // This method is used to receive the data which we get using post method.
    //- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
    
    // This method receives the error report in case of connection is not made to server.
    //- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
    
    // This method is used to process the data after connection has made successfully.
    //- (void)connectionDidFinishLoading:(NSURLConnection *)connection
    
    if (conn) {
        NSLog(@"[TCPLight] Success (I think?)");
    } else {
        NSLog(@"[TCPLight] Failure (I think?)");
    }
}

//create the names in activator
- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName{
    return @"TCPLights";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    int listenerNumber = [[listenerName substringFromIndex:28] intValue];
    NSString *name = [NSString stringWithFormat:@"custom%d", listenerNumber];
    //for some reason, using the existing dictionary causes a crash :/
    NSDictionary *prefsDict = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.openro0t.TCPLight.plist"];
    int percentage = [[prefsDict objectForKey:name] intValue];
    NSString *description = [NSString stringWithFormat:@"%d%% brightness", percentage];
    return description;
}

@end

static void listenersChanged() {
    [listener updateListeners];
}

static void reloadSettings() {
    [listener loadPrefs];
}

%ctor {
    listener = [[ALGHActivatorListener alloc] init];
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)listenersChanged, CFSTR("com.openro0t.TCPLight-listenersChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.openro0t.TCPLight-reloadSettings"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
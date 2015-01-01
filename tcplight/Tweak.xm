#import "Activator.h"

static NSString * const id1 = @"com.openro0t.TCPLight.max";
static NSString * const id2 = @"com.openro0t.TCPLight.half";
static NSString * const id3 = @"com.openro0t.TCPLight.twenty";
static NSString * const id4 = @"com.openro0t.TCPLight.off";

@interface ALGHActivatorListener : NSObject <LAListener>
@end

static inline unsigned char ALGHListenerName(NSString *listenerName) {
    unsigned char en;
    if ([listenerName isEqualToString:id1]) {
        en = 0;
    } else if ([listenerName isEqualToString:id2]) {
        en = 1;
    } else if ([listenerName isEqualToString:id3]) {
        en = 2;
    } else {
        en = 3;
    }
    return en;
}

@implementation ALGHActivatorListener

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
	@autoreleasepool{
        unsigned char en = ALGHListenerName(listenerName);
        switch (en) {
            case 0:
                //turn on the light if its off
                system("curl --data 'cmd=DeviceSendCommand&data=<gip><version>1</version><token>123456783423</token><did>216495999882663230</did><value>1</value></gip>&fmt=xml' http://192.168.0.10/gwr/gop.php");
                //sets it to max brightness
                system("curl --data 'cmd=DeviceSendCommand&data=<gip><version>1</version><token>1234567890</token><did>216495999882663230</did><value>100</value><type>level</type></gip>&fmt=xml' http://192.168.0.10/gwr/gop.php");
                break;
            case 1:
                //tuns on the light if its off
                system("curl --data 'cmd=DeviceSendCommand&data=<gip><version>1</version><token>123456783423</token><did>216495999882663230</did><value>1</value></gip>&fmt=xml' http://192.168.0.10/gwr/gop.php");
                //sets it to 50 percent brightness
                system("curl --data 'cmd=DeviceSendCommand&data=<gip><version>1</version><token>1234567890</token><did>216495999882663230</did><value>50</value><type>level</type></gip>&fmt=xml' http://192.168.0.10/gwr/gop.php");
                break;
            case 2:
                //tuns on the light if its off
                system("curl --data 'cmd=DeviceSendCommand&data=<gip><version>1</version><token>123456783423</token><did>216495999882663230</did><value>1</value></gip>&fmt=xml' http://192.168.0.10/gwr/gop.php");
                //sets it to 25 percent brightness
                system("curl --data 'cmd=DeviceSendCommand&data=<gip><version>1</version><token>1234567890</token><did>216495999882663230</did><value>25</value><type>level</type></gip>&fmt=xml' http://192.168.0.10/gwr/gop.php");
                break;
            case 3:
                system("curl --data 'cmd=DeviceSendCommand&data=<gip><version>1</version><token>123456783423</token><did>216495999882663230</did><value>0</value></gip>&fmt=xml' http://192.168.0.10/gwr/gop.php");
                break;
            default:
                NSLog(@"Something went wrong :(");
                break;
        }
		
	}
}

//create the names in activator
- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName{
    int en = ALGHListenerName(listenerName);
    NSString *title[4] = { @"TPSLight max", @"TPSLight half", @"TPSLight low", @"TPSLight off"};
    return title[en];
}

//memory
+ (void)load{
	@autoreleasepool{
		[[LAActivator sharedInstance] registerListener:[self new] forName:id1];
        [[LAActivator sharedInstance] registerListener:[self new] forName:id2];
        [[LAActivator sharedInstance] registerListener:[self new] forName:id3];
        [[LAActivator sharedInstance] registerListener:[self new] forName:id4];
	}
}

@end
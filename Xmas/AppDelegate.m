//
//  AppDelegate.m
//  Xmas
//

#import "AppDelegate.h"

#import "XmasController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
	// hide the status bar
	[application setStatusBarHidden:YES];
	
	// set up the window
	UIScreen *screen = [UIScreen mainScreen];
    self.window = [[UIWindow alloc] initWithFrame:screen.bounds];
	
	// set up the view controller
	self.window.rootViewController = [[XmasController alloc] initWithNibName:nil bundle:nil];
	
    [self.window makeKeyAndVisible];
    return YES;
}

@end

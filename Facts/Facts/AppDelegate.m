//
//  AppDelegate.m
//  Facts
//
//  Created by LMS on 22/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) ViewController * viewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.viewController = [[ViewController alloc] init];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *ddPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *imgFolderPath = [ddPath stringByAppendingString:@"/img"];
    [fileManager removeItemAtPath:imgFolderPath error:nil];
}

@end

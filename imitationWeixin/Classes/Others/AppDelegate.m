//
//  AppDelegate.m
//  ImitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/6.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInfo.h"
#import "WXXMPPTools.h"
#import "UIStoryboard+showInitVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    //程序启动时，加载沙盒数据
    [[UserInfo sharedUserInfo] loadDataFromSandBox];
    
    //上一次登录成功后，没有退出当前账户登录，isLogin值就一直为yes。下次打开应用时不需要进入登录界面，直接进入主界面，并连接服务器
    if ([UserInfo sharedUserInfo].isLogin) {
        self.window.rootViewController = [UIStoryboard initialVCWithName:@"Main"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //连接服务器
            [[WXXMPPTools sharedWXXMPPTools] userLoginWithResultBlock:nil];
        });
    }
    
    // 注册推送通知
if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
    [application registerUserNotificationSettings:settings];
}
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

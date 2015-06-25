//
//  UserInfo.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/7.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "UserInfo.h"

#define UserNameKey @"USER_NAME"
#define PwdKey @"PASSWORD"
#define LoginKey @"Login"

static NSString *domain = @"mikado";
static NSString *hostIP = @"127.0.0.1";

@implementation UserInfo

singleton_implementation(UserInfo);

- (NSString *)xmppDomain{
    return domain;
}

- (NSString *)xmppHostIP{
    return hostIP;
}

- (NSString *)userId{
    return [NSString stringWithFormat:@"%@@%@",self.loginUserName,domain];
}

- (void)synchronizeToSandBox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.loginUserName forKey:UserNameKey];
    [defaults setObject:self.loginPwd forKey:PwdKey];
    [defaults setBool:self.login forKey:LoginKey];
    [defaults synchronize];
    
}

- (void)loadDataFromSandBox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.loginUserName = [defaults objectForKey:UserNameKey];
    self.loginPwd = [defaults objectForKey:PwdKey];
    self.login = [defaults boolForKey:LoginKey];
    
}

@end

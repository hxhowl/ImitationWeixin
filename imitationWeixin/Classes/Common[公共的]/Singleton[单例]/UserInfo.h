//
//  UserInfo.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/7.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface UserInfo : NSObject
singleton_interface(UserInfo);

@property(nonatomic, copy, readonly) NSString *xmppDomain;//xmpp服务器域名
@property(nonatomic, copy) NSString *xmppHostIP;//XMPP服务器ip
@property(nonatomic, copy) NSString *loginUserName;//登录账号
@property(nonatomic, copy) NSString *loginPwd;//密码
@property(nonatomic,assign,getter=isLogin) BOOL login;//登录是否成功
@property(nonatomic, copy) NSString *userId;

@property(nonatomic, copy) NSString *registerUserName;//注册账号
@property(nonatomic, copy) NSString *registerPwd;//注册密码

/**
 *  数据保存到沙盒，保持运行内存与沙盒的数据同步
 */
- (void)synchronizeToSandBox;

/**
 *  程序一启动时从沙盒获取数据
 */
- (void)loadDataFromSandBox;

@end

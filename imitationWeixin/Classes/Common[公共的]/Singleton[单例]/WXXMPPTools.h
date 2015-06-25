//
//  WXXMPPTools.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/8.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

typedef enum {
    XMPPResultTypeConnecting,//连接中
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetError,//网络连接失败
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;

typedef void (^ResultBlock) (XMPPResultType type);

//自动登录状态通知
static NSString *AutoLoginStatusNotification = @"AutoLoginStatusNotification";

@interface WXXMPPTools : NSObject
singleton_interface(WXXMPPTools)

//是否执行注册操作 YES为注册，NO为登录
@property(nonatomic, assign, getter=isUserRegister)BOOL userRegister;

//用户登录 登录结果以block的方式返回
-(void)userLoginWithResultBlock:(ResultBlock)resultBlock;

//用户注册 注册结果以block的方式返回
- (void)userRegisterWithResultBlock:(ResultBlock)resultBlock;

//用户注销
- (void)userLogout;

//核心通讯类
@property(nonatomic, strong, readonly)XMPPStream *xmppStream;

//模块
//自动连接模块
@property(nonatomic, strong, readonly)XMPPReconnect *reconnect;

// 花名册模块
@property(nonatomic, strong, readonly)XMPPRoster *roster;
// 花名册数据存储
@property(nonatomic, strong, readonly)XMPPRosterCoreDataStorage *rosterStorage;

//电子名片模块
@property(nonatomic, strong, readonly) XMPPvCardTempModule *vCardModule;
//电子名片数据存储
@property(nonatomic, strong, readonly) XMPPvCardCoreDataStorage *vCardStorage;
//电子名片头像模块
@property(nonatomic, strong, readonly) XMPPvCardAvatarModule *vCardAvatarModule;

//消息模块
@property(nonatomic, strong, readonly)XMPPMessageArchiving *msgArchiving;
 //消息归档存储
@property(nonatomic, strong, readonly)XMPPMessageArchivingCoreDataStorage *msgStorage;
@end

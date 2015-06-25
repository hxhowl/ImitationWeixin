//
//  WXXMPPTools.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/8.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "WXXMPPTools.h"
#import "UserInfo.h"
#import "UIStoryboard+showInitVC.h"
#import "HistoryChatDataQRUD.h"

//#import <UIKit/UIKit.h>

//花名册代理，数据流代理
@interface WXXMPPTools ()<XMPPRosterDelegate,XMPPStreamDelegate>
//登录或者注册结果的回调block
@property(nonatomic, copy)ResultBlock resultBlock;
@end

@implementation WXXMPPTools

singleton_implementation(WXXMPPTools)


#pragma mark - 私有方法
#pragma mark 1 初始化XMPPStream核心类
- (void)setupXMPPStream{
    //1.创建XMPPStream对象
    _xmppStream = [[XMPPStream alloc] init];
    
    //设置代理，所有跟服务器交互后，返回的结果通过代理方式通知
    //DISPATCH_QUEUE_PRIORITY_DEFAULT 使用默认的优先级
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    //2.允许socket后台运行
    _xmppStream.enableBackgroundingOnSocket = YES;
    
    //3.添加自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    
    //4.添加花名册模块
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //自动获取花名册
    _roster.autoFetchRoster = YES;
    //取消自动订阅，NO为需要验证才能添加为好友
    _roster.autoAcceptKnownPresenceSubscriptionRequests = NO;
    
    //5.消息模块
   _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorage];
    
    //6.电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCardModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    
    //7.电子名片头像模块
    _vCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCardModule];
    
    
    //激活模块
    HCPLog(@"WXXMPPTOOLS---log---激活自动重连模块");
    [_reconnect         activate:_xmppStream];//自动重连模块
    HCPLog(@"WXXMPPTOOLS---log---激活花名册模块");
    [_roster            activate:_xmppStream];//花名册模块
    HCPLog(@"WXXMPPTOOLS---log---激活消息模块");
    [_msgArchiving      activate:_xmppStream];//消息模块
    HCPLog(@"WXXMPPTOOLS---log---激活电子名片模块");
    [_vCardModule       activate:_xmppStream];//电子名片模块
    HCPLog(@"WXXMPPTOOLS---log---激活电子名片头像模块");
    [_vCardAvatarModule activate:_xmppStream];//电子名片头像模块
    
}

/**
 *  断开连接
 */
- (void)teardownXMPPStream{
    //1.移除代理
    [_xmppStream removeDelegate:self];
    
    //2.停止模块并清空模块
    HCPLog(@"WXXMPPTOOLS---log---停止自动重连模块");
    [_reconnect         deactivate];//自动重连
    HCPLog(@"WXXMPPTOOLS---log---停止花名册模块");
    [_roster            deactivate];//花名册模块
    HCPLog(@"WXXMPPTOOLS---log---停止消息模块");
    [_msgArchiving      deactivate];//消息模块
    HCPLog(@"WXXMPPTOOLS---log---停止电子名片模块");
    [_vCardModule       deactivate];//电子名片模块
    HCPLog(@"WXXMPPTOOLS---log---停止电子名片头像模块");
    [_vCardAvatarModule deactivate];//电子名片头像模块
    
    //3.断开连接
    [_xmppStream disconnect];
}

#pragma mark 2 连接到服务器
- (void)connectToServer{
    //如果XMPPStream没有值，创建对象
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    //获取用户信息单例对象
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    //提交信息到服务器
    //1.设置XMPPStream要交互的主机地址与端口
    self.xmppStream.hostName = userInfo.xmppHostIP;
    //端口默认5222，不用设置
    _xmppStream.hostPort = 5222;
    
    //2.设置登录的账号
    XMPPJID *myJid = nil;
    if (!self.isUserRegister) {
        //设置登录账号
        myJid = [XMPPJID jidWithUser:userInfo.loginUserName domain:userInfo.xmppDomain resource:nil];
        HCPLog(@"WXXMPPTools---log--设置登录账号-%d",self.isUserRegister);
    } else {
        //设置注册账号
        myJid = [XMPPJID jidWithUser:userInfo.registerUserName domain:userInfo.xmppDomain resource:nil];
        HCPLog(@"WXXMPPTools---log--设置注册账号-%d",self.isUserRegister);
    }
    
    _xmppStream.myJID = myJid;
    
    //如果之前的连接还存在，断开连接，否则用新的用户名连接时，会报连接已存在的错误
    if (_xmppStream.isConnected) {
        [_xmppStream disconnect];
    }
    
    //3.执行请求连接服务器
    HCPLog(@"WXXMPPTools---log-- 请求连接到服务器");
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    
    //通知正在连接中
    HCPLog(@"WXXMPPTools---log--正在连接");
    [self postNotificationWithResultType:XMPPResultTypeConnecting];
    
}

#pragma mark 3 发送登录密码到服务器[代理返回连接成功后再执行此步骤]
- (void)sendLoginPwdToServer{
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSError *error = nil;
    HCPLog(@"WXXMPPTools---log--发送登录密码到服务器");
    [_xmppStream authenticateWithPassword:userInfo.loginPwd error:&error];
}

#pragma mark 4 通知用户上线
- (void)notifyUserOnline{
    HCPLog(@"WXXMPPTools---log--通知用户上线");
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
}

#pragma mark 5 通知用户下线
- (void)notifyUserOffline{
    HCPLog(@"WXXMPPTools---log--通知用户下线");
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
}

#pragma mark 发送注册密码到服务器
- (void)sendRegisterPwdToServer{
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSError *error = nil;
    HCPLog(@"WXXMPPTools---log--发送注册密码到服务器");
    [_xmppStream registerWithPassword:userInfo.registerPwd error:&error];
    
}

#pragma mark 发送登录状态的通知
- (void)postNotificationWithResultType:(XMPPResultType)type{
    NSDictionary *userInfo = @{@"type":@(type)};
    [[NSNotificationCenter defaultCenter] postNotificationName:AutoLoginStatusNotification object:nil userInfo:userInfo];
}

#pragma mark - 公共方法
#pragma mark 用户登录
- (void)userLoginWithResultBlock:(ResultBlock)resultBlock{
    HCPLog(@"WXXMPPTools--log--用户登录ResultBlock");
    //赋值给成员属性
    self.resultBlock = resultBlock;
    
    //连接到服务器，成功后，发送密码授权
    [self connectToServer];
}

#pragma mark  用户注册
- (void)userRegisterWithResultBlock:(ResultBlock)resultBlock{
    HCPLog(@"WXXMPPTools--log--用户注册ResultBlock");
    //赋值给成员属性
    self.resultBlock = resultBlock;
    
    //连接到服务器，成功后，发送密码授权
    [self connectToServer];
}

#pragma mark 用户注销
- (void)userLogout{
    //0.通知用户下线
    [self notifyUserOffline];
    
    //1.断开连接
    [_xmppStream disconnect];
    
    //2.回到登录界面
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    //3.取消登录状态
    [UserInfo sharedUserInfo].login = NO;
    [[UserInfo sharedUserInfo] synchronizeToSandBox];
}

#pragma mark XMPPStream代理方法
#pragma mark 客户端连接服务器成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    if (!self.isUserRegister) {
        //连接成功后，发送登录密码到服务器，进行授权验证
        HCPLog(@"WXXMPPTools--loglogin--userRegister=%d",[WXXMPPTools sharedWXXMPPTools].userRegister);
        HCPLog(@"WXXMPPTools--loglogin--userRegister22=%d",self.isUserRegister);
        [self sendLoginPwdToServer];
    } else {
        HCPLog(@"WXXMPPTools--logpwd--userRegister=%d",[WXXMPPTools sharedWXXMPPTools].userRegister);
        HCPLog(@"WXXMPPTools--logpwd--userRegister22=%d",self.isUserRegister);
        //连接成功后，发送注册密码到服务器
        [self sendRegisterPwdToServer];
    }
}

#pragma mark 客户端断开与主机的连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    if (error) {
        HCPLog(@"WXXMPPTools---log--客户端与服务器连接断开");
        [self postNotificationWithResultType:XMPPResultTypeNetError];
    }
}

#pragma mark 授权失败
- (void)xmppStream:(XMPPStream*)sender didNotAuthenticate:(DDXMLElement *)error{
    if (self.resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
        HCPLog(@"WXXMPPTools---log--授权失败");
    }
    HCPLog(@"WXXMPPTools---log--通知登录失败");
    //通知登录失败
    [self postNotificationWithResultType:XMPPResultTypeLoginFailure];
}

#pragma mark 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //通知用户上线
    
    [self notifyUserOnline];
    if (self.resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
        HCPLog(@"WXXMPPTools---log--授权成功");
    }
    HCPLog(@"WXXMPPTools---log--通知登录成功");
    //通知用户登录成功
    [self postNotificationWithResultType:XMPPResultTypeLoginSuccess];
}

#pragma mark 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    if (self.resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
        HCPLog(@"WXXMPPTools---log--注册成功");
    }
    HCPLog(@"WXXMPPTools---log--通知注册成功");
    [self postNotificationWithResultType:XMPPResultTypeRegisterSuccess];
}

#pragma mark 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    if (self.resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
        HCPLog(@"WXXMPPTools---log--注册失败");
    }
    HCPLog(@"WXXMPPTools---log--通知注册失败");
    [self postNotificationWithResultType:XMPPResultTypeRegisterFailure];
}

#pragma mark 发送出去的信息
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    HCPLog(@"WXXMPPTools---log--sendmessageXML信息:%@",message);
    
    
    //有消息变化，添加或更新这个人到HistoryChat，更新历史联系人数据
    NSDate *lastMsgTime = [NSDate date];
    HistoryChatDataQRUD *historyChatDataQRUD = [[HistoryChatDataQRUD alloc] init];
    [historyChatDataQRUD addHistoryChatContact:message.to.user Msg:message.body MsgTime:lastMsgTime];
}

#pragma mark 接收到的信息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    //正常显示信息
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        HCPLog(@"WXXMPPTools---log--getmessageXML信息:%@",message);
        
        if (message.body.length > 0) {
            //更新历史联系人数据
            NSDate *lastMsgTime = [NSDate date];
            HistoryChatDataQRUD *historyChatDataQRUD = [[HistoryChatDataQRUD alloc] init];
            [historyChatDataQRUD addHistoryChatContact:message.from.user Msg:message.body MsgTime:lastMsgTime];
        }
        
    } else {
        //接收到信息体后再发送通知。对方进入编辑状态也会获取到message的，只是body为空。
        if (message.body.length > 0) {
           //本地推送通知
        UILocalNotification *localNot = [[UILocalNotification alloc] init];
        //接受信息时的当前时间
        localNot.fireDate = [NSDate date];
        localNot.alertBody = [NSString stringWithFormat:@"%@\n%@",message.from.bare,message.body];
        localNot.soundName = @"default";
        [[UIApplication sharedApplication] scheduleLocalNotification:localNot]; 
        }
    }
}

#pragma mark 接收好友验证
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    NSString *alertInfo = [NSString stringWithFormat:@"是否同意 %@ 的好友请求",presence.from];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友验证信息" message:alertInfo preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.roster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    }]];
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}

@end

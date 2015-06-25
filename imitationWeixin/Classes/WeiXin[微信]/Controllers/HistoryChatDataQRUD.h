//
//  HistoryChatDataQRUD.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/24.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HistoryChat;

@interface HistoryChatDataQRUD : NSObject
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

#pragma mark 增加/更新联系人聊天最新记录
- (void)addHistoryChatContact:(NSString *)chatContact Msg:(NSString *)lastMsg MsgTime:(NSDate *)lastMsgTime;
#pragma mark 删除与该联系人的聊天记录
- (void)deleteHistoryChatContact:(NSString *)chatContact;

- (NSArray *)queryAllChatContacts;

@end

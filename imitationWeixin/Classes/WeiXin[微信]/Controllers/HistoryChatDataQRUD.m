//
//  HistoryChatDataQRUD.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/24.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "HistoryChatDataQRUD.h"
#import "HistoryChat.h"


@implementation HistoryChatDataQRUD




- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        //告诉coredata数据库的名字和路径
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *sqlitePath = [doc stringByAppendingPathComponent:@"HistoryChatContacts.sqlite"];
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
        
        _managedObjectContext.persistentStoreCoordinator = store;
    }
    return _managedObjectContext;
}

#pragma mark 添加或更新记录
- (void)addHistoryChatContact:(NSString *)chatContact Msg:(NSString *)lastMsg MsgTime:(NSDate *)lastMsgTime{
    NSArray *result = [self queryHistoryData:chatContact];
    HistoryChat *historyChat;
    if (result.count == 0) {//如果不存在，添加这个记录
        historyChat = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([HistoryChat class]) inManagedObjectContext:self.managedObjectContext];
        historyChat.chatContact = chatContact;
        historyChat.lastMsg = lastMsg;
        historyChat.lastMsgTime = lastMsgTime;
    } else {
        //更新这个记录
        historyChat = result[0];
        historyChat.lastMsg = lastMsg;
        historyChat.lastMsgTime = lastMsgTime;
    }
    
    //存储
    [self.managedObjectContext save:nil];
}


#pragma mark 查询有没有与这个人聊过天
- (NSArray *)queryHistoryData:(NSString *)chatContact{
    //创建查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([HistoryChat class ])];
    //添加查询请求
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chatContact=%@",chatContact];
    request.predicate = predicate;
    //查询表格
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }

    return result;
}

#pragma mark 删除与这个人的聊天记录行
- (void)deleteHistoryChatContact:(NSString *)chatContact{
    NSArray *result = [self queryHistoryData:chatContact];
    if (result.count != 0) {
        HistoryChat *historyChat = result[0];
        [self.managedObjectContext deleteObject:historyChat];
        
        [self.managedObjectContext save:nil];
    }
}

- (NSArray *)queryAllChatContacts{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([HistoryChat class])];
    //添加排序  按消息时间降序升序排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"lastMsgTime" ascending:NO];
    request.sortDescriptors = @[sort];

    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:nil];
    return result;
}


@end

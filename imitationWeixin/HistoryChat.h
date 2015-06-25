//
//  HistoryChat.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/24.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HistoryChat : NSManagedObject

@property (nonatomic, retain) NSDate * lastMsgTime;
@property (nonatomic, retain) NSString * chatContact;
@property (nonatomic, retain) NSString * lastMsg;

@end

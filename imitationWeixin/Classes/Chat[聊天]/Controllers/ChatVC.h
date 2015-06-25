//
//  ChatVC.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/22.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatVC : UIViewController<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextViewDelegate>

#pragma mark 聊天对象
@property(nonatomic, strong) XMPPJID *chatJid;

@end

//
//  CommonCell.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/15.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPUserCoreDataStorageObject.h"

@class CommonCell,CommonCellModel;


@interface CommonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconItem;
@property (weak, nonatomic) IBOutlet UILabel *labelItem;
@property(nonatomic, strong) CommonCellModel *commonCellModel;
@property(nonatomic, strong) XMPPUserCoreDataStorageObject *userContacts;


#pragma mark 初始化cell
+(instancetype)commonCellWithTableView:(UITableView *)tableView;


@end

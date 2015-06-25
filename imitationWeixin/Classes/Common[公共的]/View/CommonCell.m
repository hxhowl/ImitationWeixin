//
//  CommonStyleCell.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/15.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "CommonCell.h"
#import "CommonCellModel.h"
#include "WXXMPPTools.h"

@interface CommonCell ()


@end

@implementation CommonCell

#pragma mark commonCellModel的set方法
- (void)setCommonCellModel:(CommonCellModel *)commonCellModel{
    _commonCellModel = commonCellModel;
    self.labelItem.text = commonCellModel.labelItem;
    self.iconItem.image = [UIImage imageNamed:commonCellModel.iconItem];
}

#pragma mark 初始化cell
+ (instancetype)commonCellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"commonCell";
    CommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        //从xib初始化cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

#pragma mark 用户联系人数据set方法
- (void)setUserContacts:(XMPPUserCoreDataStorageObject *)userContacts{
    _userContacts = userContacts;
    
    XMPPUserCoreDataStorageObject *contact = userContacts;
    //显示昵称
    NSString *displayName = contact.nickname;
    if (!contact.nickname) {//没有设置昵称，显示用户名
        //好像默认的的displayName用户名
        displayName = contact.displayName;
    }
    NSString *onlineStatus = @"[离线]";
    switch ([contact.sectionNum intValue]) {
        case 0:
            onlineStatus = @"[在线]";
            break;
        case 1:
            onlineStatus = @"[离开]";
            break;
        case 2:
            onlineStatus = @"[离线]";//对方离线和隐身反应到我们这都是离线
            break;
        default:
            onlineStatus = @"[异常]";
            break;
    }
    
    // subscription
    // 如果是none表示对方还没有确认
    // to   我关注对方
    // from 对方关注我
    // both 互粉
    
    self.labelItem.text = [NSString stringWithFormat:@"%@    %@    |-%@",onlineStatus, displayName, contact.subscription];
    //HCPLog(@"commonCell ---- log ===%@ | %@ | %@", onlineStatus, displayName, contact.subscription);
    
    //后面做了头像模块再细化处理，暂时先用一张图片代理
    if (contact.photo) {//有头像显示头像
        self.iconItem.image = contact.photo;
    } else {
        NSData *data = [[WXXMPPTools sharedWXXMPPTools].vCardAvatarModule photoDataForJID:contact.jid];
        if (data) {
            self.iconItem.image = [UIImage imageWithData:data];
        } else {
            self.iconItem.image = [UIImage imageNamed:@"fts_default_headimage"];
        }
    }
}







- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  SendTVCell.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/23.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendTVCell : UITableViewCell
#pragma mark 头像按钮
@property (weak, nonatomic) IBOutlet UIButton *headImageBtn;
#pragma mark 信息+头像的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgViewWidth;
#pragma mark cell高度
@property(nonatomic,assign)CGFloat cellRowHeight;
#pragma mark 信息label
@property (weak, nonatomic) IBOutlet UILabel *sendMsgShowLabel;
#pragma mark 承载label的view与，整个信息view的底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendMsgShowLabelViewBottom;
#pragma mark 承载label的view
@property (weak, nonatomic) IBOutlet UIView *sendMsgShowLabelView;
#pragma mark 承载label的view上的imageview，用来显示背景图片
@property (weak, nonatomic) IBOutlet UIImageView *sendMsgImageView;

@end

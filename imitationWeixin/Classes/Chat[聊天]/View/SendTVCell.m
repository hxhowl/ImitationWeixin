//
//  SendTVCell.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/23.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "SendTVCell.h"
#import "UIImage+Externsion.h"
#import "UIView+Externsion.h"

@implementation SendTVCell

//当从storyboard中加载控件后，会执行下面的方法
- (void)awakeFromNib {
    
    [self.sendMsgImageView setImage:[UIImage stretchedImageWithName:@"SenderTextNodeBkg"]];
    
}

#pragma mark 获取cell的高度
//通过计算文字所占控件，调整控件之间的约束值，并计算出cell需要的高度
- (CGFloat)cellRowHeight{
    //设置msg视图宽高自适应
    
    NSString *msg = self.sendMsgShowLabel.text;
    CGRect rect = [UIView viewCGRectWithText:msg :[UIFont systemFontOfSize:14] :180 :MAXFLOAT];
    self.msgViewWidth.constant = 5 + 36  + 4  + 8 + 14 + 8 + rect.size.width ;//外间距+头像宽+外间距+文字宽度 + 与label的内间距 最后1个8是14号字体的一个字符宽度，不加上这个8，会有显示问题
   
    
    if (rect.size.height <  44 - 4 - 8 - 14 -8  ) {//减去view外间距和与label的内间距
        self.sendMsgShowLabelViewBottom.constant = 44 - 4 - 8 - 14 -8 - rect.size.height;
        _cellRowHeight = 44;
        //HCPLog(@"文字内容%@----字体高度：%f,字体宽度%f,labelw:%f,H:%f",msg,rect.size.height,rect.size.width,self.sendMsgShowLabel.frame.size.width,self.sendMsgShowLabel.frame.size.height);
    } else {
        self.sendMsgShowLabelViewBottom.constant = 0;
        _cellRowHeight = rect.size.height + 4  + 8 + 14 + 8 ;
         // HCPLog(@"文字内容%@----字体高度：%f,字体宽度%f,labelw:%f,H:%f",msg,rect.size.height,rect.size.width,self.sendMsgShowLabel.frame.size.width,self.sendMsgShowLabel.frame.size.height);
    }
    return _cellRowHeight;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

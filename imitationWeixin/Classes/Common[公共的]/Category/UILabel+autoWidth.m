//
//  UILabel+autoWidth.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/13.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "UILabel+autoWidth.h"

@implementation UILabel (autoWidth)

/**
 *  返回一个根据文字字体自动的大小的label
 *
 *  @param text  传入的文字
 *  @param font  字体
 *  @param color 文字颜色
 *
 *  @return 根据文字设定大小的label
 */
+ (UILabel *)autoWidthLabelWithText:(NSString *)text :(UIFont *)font :(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    [label setFont:font];
    [label setTextColor:color];
    NSDictionary *dict = @{NSFontAttributeName:label.font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    label.frame = rect;
    return label;
}

@end

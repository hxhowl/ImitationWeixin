//
//  UILabel+autoWidth.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/13.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (autoWidth)


/**
*   根据传入的字符串返回相应大小的label
*
*  @param text  传入的字符串
*  @param font  字体
*  @param color 字色
*
*  @return 返回一个label
*/
+ (UILabel *)autoWidthLabelWithText:(NSString *)text :(UIFont *)font :(UIColor *)color;
@end

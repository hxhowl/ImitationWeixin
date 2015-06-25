//
//  UIView+Externsion.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/23.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Externsion)
/**
 *  根据文字，字体，宽高限制，得到文字占用空间
 *
 *  @param text      文字
 *  @param font      字体
 *  @param maxWidth  宽
 *  @param maxHeight 高
 *
 *  @return 文字占用空间CGrect值
 */
+ (CGRect)viewCGRectWithText:(NSString *)text :(UIFont *)font :(CGFloat)maxWidth :(CGFloat)maxHeight;
@end

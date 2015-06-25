//
//  UIImage+Externsion.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/14.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Externsion)
/**
 *  将图片从中心进行拉伸
 *
 *  @param name 图片名
 *
 *  @return 返回拉伸后的图片
 */
+ (UIImage *)stretchedImageWithName:(NSString *)name;

/**
 *  重新绘制图片
 *
 *  @param name 传入的图片名
 *
 *  @return 返回一个重绘后的图片
 */
+ (UIImage *)reDrawImageWithName:(NSString *)name;
@end

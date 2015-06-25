//
//  UIImage+Externsion.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/14.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "UIImage+Externsion.h"

@implementation UIImage (Externsion)


#pragma mark 将图片从中心进行拉伸
+ (UIImage *)stretchedImageWithName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    int leftCap = image.size.width * 0.5;
    int topCap = image.size.height * 0.5;
    return [image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

#pragma mark  重新绘制图片
+ (UIImage *)reDrawImageWithName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    //UIImageRenderingModeAlwaysOriginal 显示原图，不添加渲染
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


@end

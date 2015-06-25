//
//  UIStoryboard+showInitVC.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/7.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "UIStoryboard+showInitVC.h"

@implementation UIStoryboard (showInitVC)

+ (void)showInitialVCWithName:(NSString *)name
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [storyboard instantiateInitialViewController];
}

+ (id)initialVCWithName:(NSString *)name
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    return [storyboard instantiateInitialViewController];
}

@end

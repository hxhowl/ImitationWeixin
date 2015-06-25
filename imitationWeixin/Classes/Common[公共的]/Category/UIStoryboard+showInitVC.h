//
//  UIStoryboard+showInitVC.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/7.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (showInitVC)
/**
 *  显示Storyboard的第一个控制器
 *
 *  @param name storyboar名
 */
+ (void)showInitialVCWithName:(NSString *)name;
/**
 *  初始化Storyboard
 *
 *  @param name storyboard名
 *
 *  @return 一个初始化的storyboard
 */
+ (id)initialVCWithName:(NSString *)name;
@end

//
//  RegisterVC.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/7.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXRegisterViewControllerDelegate <NSObject>

//注册完成
- (void)registerViewControllerDidfinishedRegister;

@end

@interface RegisterVC : UIViewController

@property (nonatomic, weak) id<WXRegisterViewControllerDelegate> delegate;
@end

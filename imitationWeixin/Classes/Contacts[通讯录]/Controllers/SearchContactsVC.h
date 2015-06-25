//
//  SearchContactsVC.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/17.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchContactsVCDelegate <NSObject>

@required
- (void)touchBeganSearchContactsVC;

@end

@interface SearchContactsVC : UIViewController
@property(nonatomic, strong) id<SearchContactsVCDelegate> delegate;
@end

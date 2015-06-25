//
//  SearchView.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/17.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchViewEventDelegate <NSObject>

@optional
//点击返回btn
- (void)backBtnClick;
//监听输入框值变化
- (void)fieldIsEditing;


@end

@interface SearchView : UIView

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property(nonatomic, weak) id<searchViewEventDelegate> delegate;

#pragma mark 从xib初始化view
+ (SearchView *)searchView;
@end

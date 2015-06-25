//
//  SearchView.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/17.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "SearchView.h"
#import "UIImage+Externsion.h"
#import "SearchViewModel.h"
#import "SearchContactsVC.h"

@interface SearchView ()

@end

@implementation SearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//当addSubview时或者view的frame发生改变时触发layoutSubviews
- (void)layoutSubviews{
    //设置输入框左边视图
    UIImageView *inputRightItem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    inputRightItem.image = [UIImage imageNamed:@"add_friend_searchicon"];
    inputRightItem.contentMode = UIViewContentModeCenter;
    self.searchField.leftView = inputRightItem;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
}



#pragma mark 从xib初始化view
+ (SearchView *)searchView{
    NSArray *arrayXibObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchView" owner:nil options:nil];
    return arrayXibObjects[0];
}

#pragma mark 返回按钮点击事件
- (IBAction)back {
    if ([self.delegate respondsToSelector:@selector(backBtnClick)]) {
        [self.delegate backBtnClick];
    }
}

#pragma mark 输入框值变化事件
- (IBAction)searchEditChange:(UITextField *)sender {
    [SearchViewModel sharedSearchViewModel].searchFieldText = sender.text;
    if ([self.delegate respondsToSelector:@selector(fieldIsEditing)]) {
        [self.delegate fieldIsEditing];
    }
}



@end

//
//  MainTabBarVC.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/6.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "MainTabBarVC.h"
#import "UILabel+autoWidth.h"

@interface MainTabBarVC ()

@end

@implementation MainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //登陆时显示蒙版
    [self loginLoadingView];
    
}

#pragma mark 登陆进来后先显示蒙版，等数据加载完
//第一次进入页面，即完成登陆后，添加蒙版视图，以等待和服务器交互完，否则此时马上点击联系人时，会由于列表数据还未完整获取导致程序崩溃。
- (void)loginLoadingView{
    CGRect rect = [[UIScreen mainScreen] bounds];
        
    UIView *actBackView = [[UIView alloc] initWithFrame:CGRectMake((rect.size.width - 160 ) / 2, (rect.size.height - 100) / 2, 160, 100)];
    actBackView.backgroundColor = [UIColor colorWithWhite:0/255.0 alpha:0.4];
        
    UILabel *loadLabel = [UILabel autoWidthLabelWithText:@"加载中" :[UIFont systemFontOfSize:15] :[UIColor whiteColor]];
    loadLabel.frame = CGRectMake((actBackView.frame.size.width - loadLabel.frame.size.width) / 2, 55, loadLabel.frame.size.width, 20);
    loadLabel.backgroundColor = [UIColor clearColor];
        
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((actBackView.frame.size.width - 20 ) / 2, 25, 20, 20)];
    actView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [actView startAnimating];
        
    [actBackView addSubview:actView];
    [actBackView addSubview:loadLabel];
        
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithWhite:100/255.0 alpha:0.1];
    [view addSubview:actBackView];
    [self.view addSubview:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view removeFromSuperview];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

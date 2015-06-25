//
//  WeiXinNC.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/6.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "WeiXinNC.h"

@interface WeiXinNC ()

@end

@implementation WeiXinNC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



+ (void)initialize{
    [self setupTheme];
}

+ (void)setupTheme{
    //设置导航条背景
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIImage *image = [UIImage imageNamed:@"topbarbg_ios7"];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //设置全局状态栏样式为白色字样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    //设置导航条标题字体样式
    NSMutableDictionary *titleAtt = [NSMutableDictionary dictionary];
    
    titleAtt[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    titleAtt[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:titleAtt];
    
    //导航条上item样式为白色,字体15
    NSMutableDictionary *itemAtt = [NSMutableDictionary dictionary];
    
    itemAtt[NSForegroundColorAttributeName] = [UIColor whiteColor];
    itemAtt[NSFontAttributeName] = [UIFont boldSystemFontOfSize:15];
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setTitleTextAttributes:itemAtt forState:UIControlStateNormal];
    
    //设置TextField所有光标颜色
    [[UITextField appearance] setTintColor:[UIColor lightGrayColor]];
    
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

//
//  RegisterVC.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/7.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "RegisterVC.h"
#import "UIImage+Externsion.h"
#import "UILabel+autoWidth.h"
#import "UserInfo.h"
#import "WXXMPPTools.h"

@interface RegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIView *nameSeparator;
@property (weak, nonatomic) IBOutlet UIView *pwdSeparator;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航元素
    [self setNavigationItem];
    //设置控件样式
    [self setVCStyle];
    
}

#pragma mark 设置导航元素
- (void)setNavigationItem{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 25)];
    view.backgroundColor = [UIColor blackColor];
    UILabel *label = [UILabel autoWidthLabelWithText:@"填写账号" :[UIFont systemFontOfSize:15] :[UIColor whiteColor]];
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    UIBarButtonItem *viewItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage reDrawImageWithName:@"barbuttonicon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    NSArray *array = @[backBtnItem, viewItem, labelItem];
    self.navigationItem.leftBarButtonItems = array;
    
}

#pragma mark 返回
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 设置控制器控件的样式
- (void)setVCStyle{
    //账号输入框样式
    UILabel *nameLabel = [UILabel autoWidthLabelWithText:@" 账  号      " :[UIFont systemFontOfSize:13] :[UIColor blackColor]];
    self.nameField.leftView = nameLabel;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    
    //密码输入框样式
    UILabel *pwdLabel = [UILabel autoWidthLabelWithText:@" 密  码      " :[UIFont systemFontOfSize:13] :[UIColor blackColor]];
    self.pwdField.leftView = pwdLabel;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImage *pwdHideImage = [UIImage reDrawImageWithName:@"CellHidePassword_icon"];
    UIImage *pwdShowImage = [UIImage reDrawImageWithName:@"CellHidePassword_icon_HL"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 14)];
    [btn setImage:pwdHideImage forState:UIControlStateNormal];
    [btn setImage:pwdShowImage forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(rightViewPwd) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 101;
    self.pwdField.rightView = btn;
    self.pwdField.rightViewMode = UITextFieldViewModeAlways;
    
    //登录按钮
    //按钮图片
    UIImage *loginBtnImage = [UIImage stretchedImageWithName:@"fts_green_btn"];
    [self.registerBtn setBackgroundImage:loginBtnImage forState:UIControlStateNormal];
    //按钮被选中时的图片
    UIImage *loginBtnImageSelected = [UIImage stretchedImageWithName:@"fts_green_btnHL"];
    [self.registerBtn setBackgroundImage:loginBtnImageSelected forState:UIControlStateSelected];
    //初始状态输入框无数据，登录按钮禁用
    self.registerBtn.enabled = NO;
}

#pragma mark 显示密码
- (void)rightViewPwd{
    if (self.pwdField.secureTextEntry == YES) {
        self.pwdField.secureTextEntry = NO;
        UIButton *btn = (id)[self.view viewWithTag:101];
        btn.selected = YES;
    } else {
        self.pwdField.secureTextEntry = YES;
        UIButton *btn = (id)[self.view viewWithTag:101];
        btn.selected = NO;
    }
}

#pragma mark 账号Field开始输入事件
- (IBAction)nameFieldFocus {
    self.nameSeparator.backgroundColor = [UIColor colorWithRed:68/255.0 green:179/255.0 blue:63/255.0 alpha:1.0];
}

#pragma mark 账号Field结束输入事件
- (IBAction)nameFieldFinish {
    self.nameSeparator.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark 密码Field开始输入事件
- (IBAction)pwdFieldfocus {
    self.pwdSeparator.backgroundColor = [UIColor colorWithRed:68/255.0 green:179/255.0 blue:63/255.0 alpha:1.0];

}

#pragma mark 密码Field结束输入事件
- (IBAction)pwdFieldFinish {
    self.pwdSeparator.backgroundColor = [UIColor lightGrayColor];
}


#pragma mark TextField值变化事件
- (IBAction)textChange:(id)sender {
    BOOL enable = (self.nameField.text.length != 0 && self.pwdField.text.length != 0);
    //TextField都有值时，注册按钮启用
    self.registerBtn.enabled = enable;
}

#pragma mark 触摸输入框外部屏幕时，键盘退出
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark 注册按钮点击事件
- (IBAction)userRegister {
    [self.view endEditing:YES];
    NSString *username = self.nameField.text;
    NSString *pwd = self.pwdField.text;
    
    UserInfo *userinfo = [UserInfo sharedUserInfo];
    userinfo.registerUserName = username;
    userinfo.registerPwd = pwd;
    
    [WXXMPPTools sharedWXXMPPTools].userRegister = YES;
    HCPLog(@"RegisterVC--log--userRegister=%d",[WXXMPPTools sharedWXXMPPTools].userRegister);
    __weak typeof(self) selfVC = self;
    [[WXXMPPTools sharedWXXMPPTools] userRegisterWithResultBlock:^(XMPPResultType type) {
        [selfVC handleResultType:type];
    }];
   
}

#pragma mark 处理注册请求返回的结果
-(void)handleResultType:(XMPPResultType)type{
    
     dispatch_async(dispatch_get_main_queue(), ^{
         int myType = type;
         switch (myType) {
             case XMPPResultTypeRegisterSuccess:
                 if([self.delegate respondsToSelector:@selector(registerViewControllerDidfinishedRegister)])
                     [self.delegate registerViewControllerDidfinishedRegister];
                 break;
                 
             case XMPPResultTypeRegisterFailure:
                 HCPLog(@"RegisterVC---用户名已存在");
                 break;
         }
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

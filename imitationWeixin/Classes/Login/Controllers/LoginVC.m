//
//  LoginVC.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/7.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "LoginVC.h"
#import "UIImage+Externsion.h"
#import "RegisterVC.h"
#import "UserInfo.h"
#import "UIStoryboard+showInitVC.h"
#import "UILabel+autoWidth.h"
#import "WXXMPPTools.h"


@interface LoginVC ()<WXRegisterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *loginContainer;
@property (weak, nonatomic) IBOutlet UIView *loginMoreView;

@end


@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置页面样式
    [self setVCStyle];
    
    
    NSString *lastLoginUsername = [UserInfo sharedUserInfo].loginUserName;
    if (lastLoginUsername) {
        self.nameLabel.text = lastLoginUsername;
    }
}
#pragma mark 当前视图控制器消失后，该视图控制器中的蒙版view隐藏
- (void)viewDidDisappear:(BOOL)animated{
    self.loginMoreView.hidden = YES;
}



/**
 *  设置UI样式
 */
#pragma mark 设置UI样式
- (void)setVCStyle{
    //设置导航栏样式
    UILabel *label = [UILabel autoWidthLabelWithText:@"微信" :[UIFont systemFontOfSize:15] :[UIColor whiteColor]];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
    
    //密码输入框左侧imageview
    UIImageView *lockIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Card_Lock"]];
    CGRect imageBound = self.pwdField.bounds;
    imageBound.size.width = imageBound.size.height;
    //设置imageview大小
    lockIV.bounds = imageBound;
    //图片居中
    lockIV.contentMode = UIViewContentModeCenter;
    
    //添加TextField左视图
    self.pwdField.leftView = lockIV;
    //设置TextField左边总是显示
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    
    //登录按钮
    //按钮图片
    UIImage *loginBtnImage = [UIImage stretchedImageWithName:@"fts_green_btn"];
    [self.loginBtn setBackgroundImage:loginBtnImage forState:UIControlStateNormal];
    //按钮被选中时的图片
    UIImage *loginBtnImageSelected = [UIImage stretchedImageWithName:@"fts_green_btnHL"];
    [self.loginBtn setBackgroundImage:loginBtnImageSelected forState:UIControlStateSelected];
    //初始状态输入框无数据，登录按钮禁用
    self.loginBtn.enabled = NO;
    
    //点击更多按钮显示的蒙版
    self.loginMoreView.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.4];
    
}


#pragma mark 无密码输入时登录按钮禁用
- (IBAction)textChange:(UITextField *)sender {
    //登录按钮禁用
    self.loginBtn.enabled = (self.pwdField.text.length > 0);
    HCPLog(@"LoginVC.m--log:%@",self.pwdField.text);
}

//拖拽屏幕视图时，登录容器跟随拖拽响应拖拽动画
#pragma mark 拖拽手势
- (IBAction)panView:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.25 animations:^{
            //线性代数里面讲的矩阵变换，这个是恒等变换。当你改变过一个view.transform属性或者view.layer.transform的时候需要恢复默认状态的话，记得先把他们重置可以使用
            self.loginContainer.transform = CGAffineTransformIdentity;
        }];
    } else {
        CGFloat transY = [sender translationInView:sender.view].y * 0.5;
        self.loginContainer.transform = CGAffineTransformTranslate(self.loginContainer.transform, 0, transY);
    }
    //清除
    [sender setTranslation:CGPointZero inView:sender.view];
    
}

#pragma mark 显示蒙版和菜单view
- (IBAction)moreBtn {
    self.loginMoreView.hidden = NO;
}

#pragma mark 触摸输入框外部屏幕时，键盘退出
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //隐藏蒙版和菜单View
    self.loginMoreView.hidden = YES;
}

//在当前视图控制器（loginVC）配置目标视图控制器（RegisterVC）属性
#pragma mark 设置注册控制器代理
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)destVc;
        id rootVc = nav.viewControllers[0];
        
        //注册控制器
        if ([rootVc isKindOfClass:[RegisterVC class]]) {
            RegisterVC *regiVc = (RegisterVC *)rootVc;
            regiVc.delegate = self;
        }
    }
}


#pragma mark 登录按钮点击事件
- (IBAction)loginBtnClick:(id)sender {
    [self.view endEditing:YES];
    NSString *username = self.nameLabel.text;
    NSString *pwd = self.pwdField.text;
    
    UserInfo *userinfo = [UserInfo sharedUserInfo];
    userinfo.loginUserName = username;
    userinfo.loginPwd = pwd;
    [WXXMPPTools sharedWXXMPPTools].userRegister = NO;
    
    __weak typeof(self) selfVC = self;
    [[WXXMPPTools sharedWXXMPPTools] userLoginWithResultBlock:^(XMPPResultType type) {
        [selfVC handResultType:type];
    }];
    
    
}

#pragma mark 处理登录请求
- (void)handResultType:(XMPPResultType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        int myType = type;
        switch (myType) {
            case XMPPResultTypeLoginSuccess:
                //服务器返回登录成功，跳转主界面
                [UIStoryboard showInitialVCWithName:@"Main"];
                //登录成功
                [UserInfo sharedUserInfo].login = YES;
                //保存登录信息到沙盒
                [[UserInfo sharedUserInfo] synchronizeToSandBox];
                break;
                
            case XMPPResultTypeLoginFailure:
                HCPLog(@"登录失败，用户名或密码不正确");
                break;
        }
    });
}




#pragma mark - 注册控制器代理方法
//注册完成
- (void) registerViewControllerDidfinishedRegister
{
    HCPLog(@"LoginVC---注册完成");
    self.nameLabel.text = [UserInfo sharedUserInfo].registerUserName;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
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

//
//  SearchContactsVC.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/17.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "SearchContactsVC.h"
#import "UIImage+Externsion.h"
#import "SearchView.h"
#import "SearchViewModel.h"
#import "UserInfo.h"
#import "WXXMPPTools.h"

@interface SearchContactsVC ()<searchViewEventDelegate>
@property (weak, nonatomic) IBOutlet UIView *addContentView;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property(nonatomic, weak) UITextField *searchTextField;//用弱引用指向searchView上的searchView,从而实现退出输入
@property(nonatomic,assign)BOOL isBeginTouch;
@property(nonatomic,assign)CGPoint firstTouchPoint;
@end

@implementation SearchContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationItem];
    [self.searchTextField becomeFirstResponder];
}

#pragma mark 当进入这个页面时，底部工具条不显示
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark 设置导航元素
- (void)setNavigationItem{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    SearchView *titleView = [SearchView searchView];
    self.searchTextField = titleView.searchField;
    titleView.delegate = self;
    CGRect titleViewRect = CGRectMake(0, 0, rect.size.width - 15, titleView.frame.size.height);
    titleView.frame = titleViewRect;
    UIBarButtonItem *fieldItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    
    self.navigationItem.leftBarButtonItem = fieldItem;
}

#pragma mark searchView代理方法 实现返回
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark searchView代理方法 实现监听输入框输入 并返回一个bool值，监听是否退出输入
- (void)fieldIsEditing{
    if ([SearchViewModel sharedSearchViewModel].searchFieldText.length == 0) {
       
        self.addContentView.hidden = YES;
        self.addLabel.text = [NSString stringWithFormat:@""];
        
    } else {
        self.addContentView.hidden = NO;
        self.addLabel.text = [NSString stringWithFormat:@"%@",[SearchViewModel sharedSearchViewModel].searchFieldText];
    }

}

#pragma mark 开始触摸事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //退出键盘
    if ([SearchViewModel sharedSearchViewModel].searchFieldText.length == 0) {
        //没有任何输入时，键盘不退出。即触摸响应事件为空即可。
        //下面这句让输入框endEditing:NO的做法是不对的,并不能达到预期效果
        //[self.searchTextField endEditing:NO];
    } else{
        [self.searchTextField endEditing:YES];
    }
    
    
    //显示coverview
    
    UITouch *touch = [touches anyObject];
    //获取当前触摸点的坐标
    CGPoint touchPoint = [touch locationInView:self.view];
    //判断触摸点在不在addContainView上
    BOOL isContains = CGRectContainsPoint(self.addContentView.frame, touchPoint);
    if (isContains) {
        self.coverView.hidden = NO;
    }
    
    
    //开始触摸，让触摸移动时记录下第一次的触摸点
    self.isBeginTouch = YES;
    //触摸移动开始时，把点传给下面方法
    [self onceMethod:touchPoint];
}

#pragma mark //每次触摸移动时只会在刚触摸时赋值给fistTouchPoint
- (void)onceMethod:(CGPoint)point{
    if(self.isBeginTouch){
        self.isBeginTouch = NO;
        self.firstTouchPoint = point;
    } else {
        return;
    }
}

#pragma mark 触摸被打断（取消）事件
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //隐藏coverview
    
    UITouch *touch = [touches anyObject];
    //获取当前触摸点的坐标
    CGPoint touchPoint = [touch locationInView:self.view];
    //判断触摸点在不在addContainView上
    BOOL isContains = CGRectContainsPoint(self.addContentView.frame, touchPoint);
    if (isContains) {
        self.coverView.hidden = YES;
    }

}

#pragma mark 结束触摸事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //隐藏coverview
    
    UITouch *touch = [touches anyObject];
    //获取当前触摸点的坐标
    CGPoint touchPoint = [touch locationInView:self.view];
    //判断触摸点在不在addContainView上
    BOOL isContains = CGRectContainsPoint(self.addContentView.frame, touchPoint);
    if (isContains) {
        self.coverView.hidden = YES;
    }

}

#pragma mark 触摸移动事件
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //触摸点在addContentView上时显示coverview，否则隐藏coverView
    
    UITouch *touch = [touches anyObject];
    //获取当前触摸点的坐标
    CGPoint touchPoint = [touch locationInView:self.view];
    //判断开始触摸屏幕的位置是不是在addContentView上
    BOOL firstPointIsContains = CGRectContainsPoint(self.addContentView.frame, self.firstTouchPoint);
    if (firstPointIsContains) {
        //判断触摸点在不在addContainView上
        BOOL isContains = CGRectContainsPoint(self.addContentView.frame, touchPoint);
        if (isContains) {
            //当触摸点移出addContainView后，再移动进来就不做任何改变了，即保持蒙版隐藏
            static dispatch_once_t onceTask;
            dispatch_once(&onceTask, ^{
                self.coverView.hidden = NO;
            });
            
        } else {
            self.coverView.hidden = YES;
        }
    } else {
        self.coverView.hidden = YES;
    }
   
    
    
}

#pragma mark addContentView的单击手势
- (IBAction)TapGesShowCover:(UITapGestureRecognizer *)sender {
    //单击显示蒙版，延时0.1秒后隐藏蒙版
    self.coverView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.coverView.hidden = YES;
    });
    //执行好友添加操作
    [self addContacts];
}

#pragma mark 添加好友
- (void)addContacts{
    HCPLog(@"SearchContactsVC.m----log--进入添加好友模块");
    NSString *contactName = [SearchViewModel sharedSearchViewModel].searchFieldText;
    HCPLog(@"SearchContactsVC.m----log--待添加的好友：%@",[SearchViewModel sharedSearchViewModel].searchFieldText);
    //不能添加自己
    if ([contactName isEqualToString:[UserInfo sharedUserInfo].loginUserName]) {
        HCPLog(@"SearchContactsVC.m----log--不能添加自己");
        [self showAlert:@"不能添加自己"];
        return;
    }

    //用户名如果输入的是用户名+域名，直接使用，如果没有加域名，自动添加
    NSString *contactLastName =[NSString stringWithFormat:@"@%@", [UserInfo sharedUserInfo].xmppDomain];
    NSRange range = [contactName rangeOfString:contactLastName];
    if (range.location == NSNotFound) {
        contactName = [contactName stringByAppendingString:contactLastName];
    }
    
    NSString *jid = contactName;
    XMPPJID *friendJid = [XMPPJID jidWithString:jid];
    
    if ([[WXXMPPTools sharedWXXMPPTools].rosterStorage userExistsWithJID:friendJid xmppStream:[WXXMPPTools sharedWXXMPPTools].xmppStream]) {
        HCPLog(@"SearchContactsVC.m----log--已经发送过添加请求了");
        [self showAlert:@"已经发送过添加请求了,请勿重复操作"];
        return;
    }
    
    //添加好友
    [[WXXMPPTools sharedWXXMPPTools].roster subscribePresenceToUser:friendJid];
}


#pragma mark 提示框
- (void)showAlert:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
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

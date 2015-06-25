//
//  SettingTableVC.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/16.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "SettingTableVC.h"
#import "UILabel+autoWidth.h"
#import "UIImage+Externsion.h"
#import "UIStoryboard+showInitVC.h"
#import "WXXMPPTools.h"

@interface SettingTableVC ()
@property(nonatomic, strong) NSArray *settingCellArray;
@property(nonatomic, strong) UIView  *loginoutMenuView;
@end

@implementation SettingTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //设置导航元素
    [self setNavigationItem];
}

#pragma mark 当进入这个页面时，底部工具条不显示
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark 离开此视图时，从父控件删除蒙版
- (void)viewDidDisappear:(BOOL)animated{
    [self.loginoutMenuView removeFromSuperview];
}

#pragma mark 设置导航元素
- (void)setNavigationItem{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 25)];
    view.backgroundColor = [UIColor blackColor];
    UILabel *label = [UILabel autoWidthLabelWithText:@"设置" :[UIFont systemFontOfSize:15] :[UIColor whiteColor]];
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    UIBarButtonItem *viewItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage reDrawImageWithName:@"barbuttonicon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    NSArray *array = @[backBtnItem, viewItem, labelItem];
    self.navigationItem.leftBarButtonItems = array;

}

#pragma mark 返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark settingCellArray的get方法
- (NSArray *)settingCellArray{
    if (_settingCellArray == nil) {
        NSArray *array = @[@"新消息提醒", @"勿扰模式", @"聊天", @"隐私", @"通用", @"账号与安全", @"关于微信", @"退出"];
        _settingCellArray = array;
    }
    return _settingCellArray;
}


#pragma mark 退出登录
- (void)loginoutWX{
    //退出登录，告诉服务器用户下线，并跳转登录界面
    [[WXXMPPTools sharedWXXMPPTools] userLogout];
    
}

- (UIView *)loginoutMenuView{
    if (_loginoutMenuView == nil) {
        CGRect rect = [[UIScreen mainScreen] bounds];
        UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake((rect.size.width - 280) / 2, 200, 280, 89)];
        menuView.backgroundColor = [UIColor whiteColor];
        
        //退出当前账号button
        UIButton *loginoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, menuView.bounds.size.width, 44)];
        [loginoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        loginoutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [loginoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [loginoutBtn addTarget:self action:@selector(loginoutWX) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:loginoutBtn];
        
        //分割线
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, menuView.bounds.size.width, 1)];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        separatorView.alpha = 0.3;
        [menuView addSubview:separatorView];
        
        //关闭微信button
        UIButton *closeWXBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 45, menuView.bounds.size.width, 44)];
        [closeWXBtn setTitle:@"关闭微信" forState:UIControlStateNormal];
        closeWXBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [closeWXBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closeWXBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        
        [menuView addSubview:closeWXBtn];
        
        //蒙版view
        UIView *coverView = [[UIView alloc] initWithFrame:rect];
        coverView.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.4];
        [coverView addSubview:menuView];
        
        //为蒙版view添加点击手势，点击隐藏
        UITapGestureRecognizer *onceTapGes = [[UITapGestureRecognizer alloc] init];
        onceTapGes.numberOfTouchesRequired = 1;//需要操作的手指数
        onceTapGes.numberOfTapsRequired = 1;//需要点击的次数
        [onceTapGes addTarget:self action:@selector(removeMenuView)];
        [coverView addGestureRecognizer:onceTapGes];
        
        
        _loginoutMenuView = coverView;
    }
    return _loginoutMenuView;
   
}

#pragma mark 点击屏幕从父控件删除蒙版
- (void)removeMenuView{
    [self.loginoutMenuView removeFromSuperview];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Table view 代理方法

//设置cell完整分割线（去掉分割线左边留白部分）
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 10, 0, 10);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:insets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
    
}
- (void)viewDidLayoutSubviews{
      UIEdgeInsets insets = UIEdgeInsetsMake(0, 10, 0, 10);
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:insets];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:insets];
    }
}

#pragma mark 设置section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

#pragma mark 每个section中row个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 6;
    } else {
        return 2;
    }
}


#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark 设置头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 25;
    } else {
        return 15;
    }
}

#pragma mark 返回cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Setting";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    //让cell和数据一一对应
    NSInteger n = indexPath.row;
    if (indexPath.section > 0) {
        for (NSInteger j = 0; j< indexPath.section; j++) {
            n += [tableView numberOfRowsInSection:j];
        }
    }
    cell.textLabel.text = self.settingCellArray[n];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark cell选择事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self.view addSubview:self.loginoutMenuView];
            }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

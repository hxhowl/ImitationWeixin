//
//  WeiXinTableVC.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/6.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "WeiXinTableVC.h"
#import "UILabel+autoWidth.h"
#import "HistoryChat.h"
#import "HistoryChatDataQRUD.h"
#import "HistoryChatTVCell.h"
#import "ChatVC.h"
#import "ContactsTableVC.h"

@interface WeiXinTableVC ()<NSFetchedResultsControllerDelegate>

#pragma mark 结果调度器
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultController;
#pragma mark 所有联系人
@property(nonatomic, strong) NSArray *allContacts;

@end

@implementation WeiXinTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //重绘图标，不然显示出来的“选中”图片是默认的蓝色
    UIImage *image = [UIImage imageNamed:@"tabbar_mainframeHL"];
    UIImage *oriImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //self.tabBarItem.selectedImage = oriImage;
    self.navigationController.tabBarItem.selectedImage = oriImage;
    
    //设置navigationItem样式
    [self setNavigationItem];
    
    //执行查询好友数据表格 
    [self.fetchedResultController performFetch:nil];
}

- (void)viewDidAppear:(BOOL)animated{
   //执行查询好友数据表格
    [self.fetchedResultController performFetch:nil];
    [self.tableView reloadData];
}


#pragma mark 设置导航元素
- (void)setNavigationItem{
    //设置导航栏左边文字
    UILabel *label = [UILabel autoWidthLabelWithText:@"微信" :[UIFont systemFontOfSize:15] :[UIColor whiteColor]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //设置导航栏右边“添加”按钮
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    [addBtn setImage:[UIImage imageNamed:@"barbuttonicon_add"] forState:UIControlStateNormal];
    //后面添加事件：点击弹出一个view
    [addBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}



#pragma mark 结果调度器get方法
#if 1
//用自己创建的数据库，每次要重新登录，cell上的数据才会刷新，但是cell的位置是实时变化的。NSFetchedResultsController代理方法里面也没执行，说明并没有监测到数据变化，估计我的上下文处理的有问题。
- (NSFetchedResultsController *)fetchedResultController{
    if (_fetchedResultController == nil) {
        
        //获取查询请求
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([HistoryChat class])];
        
        //获取上下文
        HistoryChatDataQRUD *historyChatDataQRUD = [[HistoryChatDataQRUD alloc] init];
        NSManagedObjectContext *context = historyChatDataQRUD.managedObjectContext;
        
        //添加排序  按消息时间降序升序排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"lastMsgTime" ascending:NO];
        request.sortDescriptors = @[sort];
        
        
        _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultController.delegate = self;
        //HCPLog(@"log------初始化调度结果数组");
    }
    //HCPLog(@"log-------返回初始化调度结果数组");
    return _fetchedResultController;
}
#endif


#if 0
//用框架的数据库,还有些东西没搞清楚，等搞清楚了再弄过
- (NSFetchedResultsController *)fetchedResultController{
    if (_fetchedResultController == nil) {
        
        //获取查询请求
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([XMPPMessageArchiving_Contact_CoreDataObject class])];
        
        //获取上下文
        NSManagedObjectContext *context = [WXXMPPTools sharedWXXMPPTools].msgStorage.mainThreadManagedObjectContext;
        
        //添加排序  按消息时间降序升序排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"lastMsgTime" ascending:NO];
        request.sortDescriptors = @[sort];
        
        //添加过滤
        request.predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",[UserInfo sharedUserInfo].userId];
        
        _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultController.delegate = self;
        //HCPLog(@"log------初始化调度结果数组");
    }
    //HCPLog(@"log-------返回初始化调度结果数组");
    return _fetchedResultController;
}
#endif

#pragma mark 获取所有联系人
- (NSArray *)allContacts{
    //获取查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([XMPPUserCoreDataStorageObject class])];
        
    //获取上下文
    NSManagedObjectContext *context = [WXXMPPTools sharedWXXMPPTools].rosterStorage.mainThreadManagedObjectContext;
        
    //添加排序  按用户名升序排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
        
    //添加过滤
    request.predicate = [NSPredicate predicateWithFormat:@"!(subscription CONTAINS 'none')"];
    
    _allContacts = [context executeFetchRequest:request error:nil];
    
    return _allContacts;
}

#pragma mark - 结果调度器代理方法
#pragma mark 结果调度器中内容发生改变   这里未获取到值，但是查询到的数据确实重新按时间排序了
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    NSArray *feachObject = self.fetchedResultController.fetchedObjects;
    
    HCPLog(@"啊啊啊啊啊啊啊首页---微信----llllog---%s---结果选择器：%zi",__FUNCTION__,feachObject.count);
    
    [self.tableView reloadData];
}



#pragma mark - Table view 代理方法
#pragma mark 列数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

#pragma mark 每列行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.fetchedResultController.fetchedObjects.count;
}

#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark 设置头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //无法设置为0，设置为0时，显示效果并不是0
    return 1;
}

#pragma mark 返回cell
//用自己创建的数据库
#if 1
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"historyCell";
    HistoryChatTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    HistoryChat *historyChat = self.fetchedResultController.fetchedObjects[indexPath.row];
    cell.ContactName.text = historyChat.chatContact;
    cell.LastMsg.text = historyChat.lastMsg;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *lastMsgTime = [dateFormatter stringFromDate:historyChat.lastMsgTime];
    cell.LastMsgTime.text = lastMsgTime;
    NSLog(@"------23234----celllastmsg---%@ , %@,",cell.LastMsg.text,historyChat.lastMsg);
    return cell;
}
#endif

//用框架数据库
#if 0
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"historyCell";
    HistoryChatTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    XMPPMessageArchiving_Contact_CoreDataObject *historyChat = self.fetchedResultController.fetchedObjects[indexPath.row];
    cell.ContactName.text = historyChat.bareJid.user;
    cell.LastMsg.text = historyChat.mostRecentMessageBody;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *lastMsgTime = [dateFormatter stringFromDate:historyChat.mostRecentMessageTimestamp];
    cell.LastMsgTime.text = lastMsgTime;
    NSLog(@"------23234----celllastmsg---%@ , %@,",cell.LastMsg.text,historyChat.mostRecentMessageBody);
    return cell;
}
#endif

#pragma mark 设置编辑模式为删除模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

#if 1
//用自己创建的数据库
#pragma mark 删除好友
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        HistoryChat *historyChat = self.fetchedResultController.fetchedObjects[indexPath.row];
        HistoryChatDataQRUD *historyChatDataQRUD = [[HistoryChatDataQRUD alloc] init];
        [historyChatDataQRUD deleteHistoryChatContact:historyChat.chatContact];
        [tableView reloadData];
    }
}

#endif



#if 1
//用自己创建的数据库
#pragma mark cell选择事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    HistoryChat *historyChat = self.fetchedResultController.fetchedObjects[indexPath.row];

    //HCPLog(@"-----%@---%zi-",historyChat.chatContact,self.allContacts.count);
    for (XMPPUserCoreDataStorageObject *obj in self.allContacts) {
        //获取点击那个历史聊天好友的的jid，传给聊天页面
        if ([obj.jid.user isEqualToString:historyChat.chatContact]) {
            UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ChatVC *chatVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
            chatVC.chatJid = obj.jid;
            HCPLog(@"单击和--%@--聊天",obj.jid.user);
            chatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:NO];
        }
    }
    //取消cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#endif

#if 0
//用框架数据库
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    XMPPMessageArchiving_Contact_CoreDataObject *historyChat = self.fetchedResultController.fetchedObjects[indexPath.row];
    
    
            UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ChatVC *chatVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
            chatVC.chatJid = historyChat.bareJid;
            HCPLog(@"单击和--%@--聊天",historyChat.bareJid);
            chatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:NO];
    
    //取消cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#endif

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

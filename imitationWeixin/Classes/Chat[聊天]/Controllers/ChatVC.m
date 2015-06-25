//
//  ChatVC.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/22.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "ChatVC.h"
#import "SendTVCell.h"
#import "RecvTVCell.h"
#import "HistoryChatDataQRUD.h"

@interface ChatVC ()
#pragma mark - 界面
#pragma mark 切换键盘输入
@property (weak, nonatomic) IBOutlet UIButton *showKeyboardBtn;
#pragma mark 切换语音输入
@property (weak, nonatomic) IBOutlet UIButton *showVoiceBtn;
#pragma mark 信息输入框
@property (weak, nonatomic) IBOutlet UITextView *msgTextView;
#pragma mark 显示表情输入
@property (weak, nonatomic) IBOutlet UIButton *showEmmotion;
#pragma mark 显示其他扩展
@property (weak, nonatomic) IBOutlet UIButton *showOthersBtn;
#pragma mark 发送信息
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;
#pragma mark 信息输入框、表情，所在的view
@property (weak, nonatomic) IBOutlet UIView *inputView;
#pragma mark 按下并说话
@property (weak, nonatomic) IBOutlet UIButton *pressAndSpeak;
#pragma mark 底部视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
#pragma mark 底部视图的底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewbottomConstraint;
#pragma mark 聊天信息列表
@property (weak, nonatomic) IBOutlet UITableView *msgTableView;

#pragma mark - 数据
#pragma mark 要发送的消息
@property(nonatomic, copy) NSString *msgSend;
#pragma mark  聊天信息的cell高度
@property(nonatomic,assign)CGFloat rowHeight;
#pragma mark  结果调度器
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultController;


@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置当行元素样式
    [self setNavigationItem];
    //创建通知，获取键盘推出和退出，实时改变底部view
    [self createKeyboardNotification];
    [self.sendMsgBtn setBackgroundImage:[UIImage stretchedImageWithName:@"fts_green_btn"] forState:UIControlStateNormal];
    [self.sendMsgBtn setBackgroundImage:[UIImage stretchedImageWithName:@"fts_green_btn_HL"] forState:UIControlStateSelected];
    [self.sendMsgBtn setBackgroundImage:[UIImage stretchedImageWithName:@"fts_green_btn_HL"] forState:UIControlStateHighlighted];
    
    //textView代理
    self.msgTextView.delegate = self;
    
    //执行结果查询
    [self.fetchedResultController performFetch:nil];
}

//进入页面后，最低端显示最新一条消息
- (void)viewDidAppear:(BOOL)animated{
    //进入页面，底部显示最新的一条消息
    [self srollToLastMsg];
}

#pragma mark 设置导航元素
- (void)setNavigationItem{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 25)];
    view.backgroundColor = [UIColor blackColor];
    UILabel *label = [UILabel autoWidthLabelWithText:[NSString stringWithFormat:@"%@",self.chatJid.user] :[UIFont systemFontOfSize:15] :[UIColor whiteColor]];
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    UIBarButtonItem *viewItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage reDrawImageWithName:@"barbuttonicon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    NSArray *array = @[backBtnItem, viewItem, labelItem];
    self.navigationItem.leftBarButtonItems = array;
    
    //设置导航栏右边联系人图标的按钮
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    [addBtn setImage:[UIImage imageNamed:@"barbuttonicon_InfoSingle"] forState:UIControlStateNormal];
    //后面添加事件：点击跳转到用户详情页面
    [addBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

#pragma mark 返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 结果调度器get方法
- (NSFetchedResultsController *)fetchedResultController{
    if (_fetchedResultController == nil) {
        
        //获取查询请求
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([XMPPMessageArchiving_Message_CoreDataObject class])];
        
        //获取上下文
        NSManagedObjectContext *context = [WXXMPPTools sharedWXXMPPTools].msgStorage.mainThreadManagedObjectContext;
        
        //添加排序  按信息时间排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        request.sortDescriptors = @[sort];
        
        //添加过滤
        request.predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr = %@",self.chatJid.bare,[UserInfo sharedUserInfo].userId];
        
        _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultController.delegate = self;
        //HCPLog(@"log------初始化调度结果");
    }
    //HCPLog(@"log-------返回初始化调度结果");
    return _fetchedResultController;
}


#pragma mark - 结果调度器代理方法
#pragma mark 结果调度器中内容发生改变
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    NSArray *feachObject = self.fetchedResultController.fetchedObjects;
    
    //HCPLog(@"啊啊啊啊啊啊啊--ChatVC--log---%s---结果选择器：%zi",__FUNCTION__,feachObject.count);
    
    //刷新表格数据
    [self.msgTableView reloadData];
    [self srollToLastMsg];
}


#pragma mark - 输入框界面交互
#pragma mark 单击切换键盘输入
- (IBAction)clickShowKeyboard {
    //键盘btn隐藏
    self.showKeyboardBtn.hidden = YES;
    //语音btn显示
    self.showVoiceBtn.hidden = NO;
    //显示inputView
    self.inputView.hidden = NO;
    //隐藏触摸说话Btn
    self.pressAndSpeak.hidden = YES;
    //信息输入框变为第一响应者
    [self.msgTextView becomeFirstResponder];
}

#pragma mark 单击切换语音输入
- (IBAction)clickShowVoice {
    self.showKeyboardBtn.hidden = NO;
    self.showVoiceBtn.hidden = YES;
    self.inputView.hidden = YES;
    self.pressAndSpeak.hidden = NO;
    [self.msgTextView endEditing:YES];
}

#pragma mark textView代理方法 textView有值变化时调用
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length) {
        self.showOthersBtn.hidden = YES;
        self.sendMsgBtn.hidden = NO;
    } else {
        self.showOthersBtn.hidden = NO;
        self.sendMsgBtn.hidden = YES;
    }
}


#pragma mark 点击发送消息
- (IBAction)clickSendMsg:(UIButton *)sender {
    self.msgSend = self.msgTextView.text;
    
    //创建消息体
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.chatJid];
    [msg addBody:self.msgSend];
    //发送消息
    [[WXXMPPTools sharedWXXMPPTools].xmppStream sendElement:msg];
        
    //发送完，清空当前textView输入值
    self.msgTextView.text = nil;
}



#pragma mark 获取键盘改变通知
- (void)createKeyboardNotification{
    //获取键盘位置变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //获取键盘位置完成变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange) name:UIKeyboardDidChangeFrameNotification object:nil];
}

#pragma mark 底部视图随键盘推入退出底部视图改变约束值
- (void)keyboardWillChange:(NSNotification *)not{
    NSDictionary *keyboardInfo = [not userInfo];
    CGRect keyboardRect = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyY = keyboardRect.origin.y;
    CGFloat duration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //HCPLog(@"键盘发生位置改变");
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenH = screenRect.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.bottomViewbottomConstraint.constant = screenH - keyY;
    }];
}

#pragma mark 键盘完成变化，底部消息滚动到最新的一条
- (void)keyboardDidChange{
    [self srollToLastMsg];
}

#pragma mark 滚动表格，保持最低端显示最新的消息
- (void)srollToLastMsg{
    //表格显示最底层，即显示最新的消息
    if (self.fetchedResultController.fetchedObjects.count > 1) {
        NSIndexPath *lastMsgIndex = [NSIndexPath indexPathForRow:self.fetchedResultController.fetchedObjects.count - 1 inSection:0];
        [self.msgTableView scrollToRowAtIndexPath:lastMsgIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

#pragma mark - TableView代理方法
#pragma mark section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fetchedResultController.fetchedObjects.count;
}

#pragma mark cell高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;
}

#pragma mark cell初始化
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //从结果调度器中取出当前信息对象
    XMPPMessageArchiving_Message_CoreDataObject *message = [self.fetchedResultController objectAtIndexPath:indexPath];
    //如果是outgoing就是发送出去的消息，用sendCell显示，否则用recvCell显示
    if ([message.outgoing intValue] == 1) {
        static NSString *cellID = @"sendCell";
        SendTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.sendMsgShowLabel.text = message.body;
        self.rowHeight = [cell cellRowHeight];
        return cell;
    } else {
        static NSString *cellID = @"recvCell";
        RecvTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.recvMsgShowLabel.text = message.body;
        self.rowHeight = cell.cellRowHeight;
        return cell;
    }
    
}

#pragma mark cell被选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    //取消表格被选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

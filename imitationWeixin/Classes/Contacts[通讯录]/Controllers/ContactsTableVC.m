//
//  ContactsTableVC.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/6.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "ContactsTableVC.h"
#import "UILabel+autoWidth.h"
#import "CommonCell.h"
#import "CommonCellModel.h"
#import "SearchContactsVC.h"
#import "WXXMPPTools.h"
#import "UserInfo.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "pinyin.h"
#import "ChatVC.h"


@interface ContactsTableVC ()<NSFetchedResultsControllerDelegate>
#pragma mark 联系人模块里面普通的cell
@property(nonatomic, strong) NSArray *contactsCellInfoArray;
#pragma mark 结果调度器
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultController;

#pragma mark 将调度器返回的数据重新处理后的数据保存在这个数组
@property(nonatomic, strong) NSMutableArray *contactsCellDataArray;

#pragma mark 行首字符数组
@property(nonatomic, strong) NSMutableArray *sectionTitleArray;

@end

@implementation ContactsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //重绘图标，不然显示出来的“选中”图片是默认的蓝色
    UIImage *image = [UIImage imageNamed:@"tabbar_contactsHL"];
    UIImage *oriImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     self.navigationController.tabBarItem.selectedImage = oriImage;
    
    //设置navigationItem样式
    [self setNavigationItem];
    
    //结果调度器执行查询操作
    [self.fetchedResultController performFetch:nil];
    
    //设置tableview索引文字颜色
    self.tableView.sectionIndexColor = [UIColor grayColor];
    //索引背景色为透明
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //设置索引被选中时，背景颜色
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithWhite:60/255.0 alpha:0.3];
    
    
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

#pragma mark - 数据处理
#pragma mark contactsCellInfoArray的get方法
- (NSArray *)contactsCellInfoArray{
    if (_contactsCellInfoArray == nil) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ContactsCellModel" ofType:@"plist"]];
        //HCPLog(@"log1---%@",dictArray);
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            CommonCellModel *contactsCellInfo = [CommonCellModel CommonCellWithDict:dict];
            [arr addObject:contactsCellInfo];
        }
        _contactsCellInfoArray = arr;
        //HCPLog(@"log---%@",arr);
    }
    return _contactsCellInfoArray;
}


#pragma mark 获取sectionTitle数组
- (NSMutableArray *)sectionTitleArray{
    NSMutableArray *sectionArray = [NSMutableArray arrayWithObjects:@"↑", @"☆", nil];
    //NSLog(@"--------------标题log---%zi",self.contactsCellDataArray.count);
    for (int i = 0; i < self.contactsCellDataArray.count; i++) {
        XMPPUserCoreDataStorageObject *contact = [[self.contactsCellDataArray objectAtIndex: i] objectAtIndex:0];
        for (int j =0; j < sectionArray.count; j++) {
            NSString *sectionStr = (NSString*)sectionArray[j];
            if (![contact.sectionName isEqualToString:sectionStr] && j == [sectionArray count] - 1) {
                [sectionArray addObject:contact.sectionName];
            }
        }
    }
    [sectionArray addObject:@"#"];
    _sectionTitleArray = sectionArray;
    
    return _sectionTitleArray;
}

#pragma mark 获取数据
- (NSMutableArray *)contactsCellDataArray{
    //HCPLog(@"11111111111");
    //先将中文字符转换为拼音再重设sectionName
    NSArray *feachObject = [self transformContactsData];
    //HCPLog(@"转换后的联系人数量：%zi",feachObject.count);
    NSMutableArray *contactSection = [NSMutableArray array];
    NSMutableArray *contactRow = [NSMutableArray array];
    int tmpi = 0;
    //遍历feachObject
    for (XMPPUserCoreDataStorageObject *co in feachObject) {
        
        //分组个数为0时，直接将元素添加进数组，然后作为第一个分组的第一个元素
        if (contactSection.count == 0) {
            NSMutableArray *tmparry = [NSMutableArray arrayWithObject:co];
           // HCPLog(@"首元素1---%@",co.sectionName);
            [contactSection addObject:tmparry];
            //HCPLog(@"22222222---%@",co.jidStr);
        }
        //遍历每个分组中的元素
        for (int i = 0; i < [contactSection count]; i++) {
            contactRow = contactSection[i];
            //HCPLog(@"333333--%@,%@,%zi",co.sectionName,[(XMPPUserCoreDataStorageObject *)contactRow[0] sectionName],[[(XMPPUserCoreDataStorageObject *)contactRow[0] sectionName] isEqualToString:co.sectionName]);
            
            //如果sectionname相同，添加进当前分组
            if([[(XMPPUserCoreDataStorageObject *)contactRow[0] sectionName] isEqualToString:co.sectionName]){
                for (int j = 0; j <[contactRow count]; j++) {
                    // HCPLog(@"555555");
                    //sectionName相同且不是已保存的元素，添加进当前分组
                    if (![co.jidStr isEqualToString:[(XMPPUserCoreDataStorageObject *)contactRow[j] jidStr]]) {
                        [contactRow addObject:co];
                        //HCPLog(@"666666---%@",co.jidStr);
                        //把数组内重新按在线、离开、隐身、离线的优先级排序
                        NSMutableArray *arr = [self sortContactsWithSectionNum:contactRow];
                        for (int h =0; h < arr.count; h++) {
                            contactRow[h] = arr[h];
                        }
                        //添加进分组后，退出与当前分组内元素的比较循环
                        break;
                    }
                    
                }//与分组内元素比较循环结束后，退出当前比较，换下一个元素
                break;

            } else {
                if (i == [contactSection count] - 1) {
                    NSMutableArray *tmparry = [NSMutableArray arrayWithObject:co];
                       //HCPLog(@"首元素2---%@,%@,%@,%@,%zi",co.sectionName,co.displayName,[contactRow[0] sectionName],[contactRow[0] displayName],i);
                    [contactSection addObject:tmparry];
                    tmpi++;
                }
            }
        }
    }
    
    //HCPLog(@"测试数据----log--%zi,%zi",feachObject.count,contactSection.count);
    for (int h = 0; h < [contactSection count]; h++) {
        //HCPLog(@"测试数据2----log--,%zi",[contactSection[h] count]);
    }
    _contactsCellDataArray = contactSection;
    return _contactsCellDataArray;
    
}


#pragma mark 将数据中中文字符转换为拼音，取首字母用来分组
- (NSArray *)transformContactsData{
    NSArray *feachObject = self.fetchedResultController.fetchedObjects;
    
    for (int i = 0; i < feachObject.count; i++) {
        NSString *tmpStr = [(XMPPUserCoreDataStorageObject*)feachObject[i] sectionName];
        
        unsigned short sectionStr = [tmpStr characterAtIndex:0];
        //HCPLog(@"字符转int-------log-----%d",sectionStr);
        //判断如果是中文，获取拼音首字母,并设置为该数据元素的sectionName属性值
        if (isFirstLetterHANZI(sectionStr)) {
            char firstLetter = pinyinFirstLetter(sectionStr);
            HCPLog(@"中文的首字母---log----%c",firstLetter);
            [(XMPPUserCoreDataStorageObject*)feachObject[i] setSectionName:[[NSString stringWithFormat:@"%c",firstLetter] uppercaseString]];
        }
    }
    return feachObject;
}

#pragma mark 将传入的数组按状态排序
- (NSMutableArray *)sortContactsWithSectionNum:(NSMutableArray *)array {
    NSMutableArray *array0 = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableArray *array2 = [NSMutableArray array];
    NSMutableArray *array3 = [NSMutableArray array];
    NSMutableArray *sortArray = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        switch ([(XMPPUserCoreDataStorageObject *)array[i] sectionNum].intValue) {
            case 0:
                //在线的用户往前插
                [array0 addObject:array[i]];
                break;
            case 1:
                [array1 addObject:array[i]];
                break;
            case 2:
                [array2 addObject:array[i]];
                break;
            default:
                [array3 addObject:array[i]];
                break;
        }
    }
    
    [sortArray addObjectsFromArray:array0];
    [sortArray addObjectsFromArray:array1];
    [sortArray addObjectsFromArray:array2];
    [sortArray addObjectsFromArray:array3];
    //HCPLog(@"分组情况----log---%zi,%zi,%zi,%zi,%zi",array0.count, array1.count, array2.count, array3.count,sortArray.count);
    
    return sortArray;
}





#pragma mark 结果调度器get方法
- (NSFetchedResultsController *)fetchedResultController{
    if (_fetchedResultController == nil) {
        
        //获取查询请求
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([XMPPUserCoreDataStorageObject class])];
        
        //获取上下文
        NSManagedObjectContext *context = [WXXMPPTools sharedWXXMPPTools].rosterStorage.mainThreadManagedObjectContext;
        
        //添加排序  按用户名升序排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
        request.sortDescriptors = @[sort];
        
        //添加过滤
        request.predicate = [NSPredicate predicateWithFormat:@"!(subscription CONTAINS 'none')"];
        
        _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultController.delegate = self;
        //HCPLog(@"log------初始化调度结果数组");
    }
    //HCPLog(@"log-------返回初始化调度结果数组");
    return _fetchedResultController;
}

#pragma mark - 结果调度器代理方法
#pragma mark 结果调度器中内容发生改变
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    NSArray *feachObject = self.fetchedResultController.fetchedObjects;
    
    HCPLog(@"啊啊啊啊啊啊啊llllog---%s---结果选择器：%zi",__FUNCTION__,feachObject.count);
    
    [self.tableView reloadData];
}

//#pragma mark 结果调度器中内容即将改变
//-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
//    [self.tableView reloadData];
//    HCPLog(@"啊啊啊啊啊啊啊llllog2---%s",__FUNCTION__);
//}




#pragma mark - Table view 代理方法

#pragma mark 设置section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //因为结果调度器获取到的结果，默认只有一个section，这里想把数据按字母分section，所以不用下面这两行
//    NSArray *sections = self.fetchedResultController.sections;
//    return sections.count + 1;
//    return 2;

    NSArray *feachObject = self.fetchedResultController.fetchedObjects;
    //HCPLog(@"contactsTableVC----log--获取好友列表列数--%zi,结果查询器中内容个数--%zi",self.contactsCellDataArray.count,feachObject.count);
    return self.contactsCellDataArray.count + 1;

}

#pragma mark 每个section中row个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 4;
    } else {
        //return self.fetchedResultController.fetchedObjects.count;

                NSArray *sections = self.contactsCellDataArray;
        if (sections.count > 0 ) {
        NSArray *rows = [sections objectAtIndex:section - 1];
        //HCPLog(@"contactsTableVC----log--获取好友列表行数--%zi",rows.count);
            return [rows count];
        } else {
            return 0;
        }
        
    }
    
}

#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark 设置头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        //无法设置为0，设置为0时，显示效果并不是0
        return 1;
    } else {
        return 22;
    }
}


#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CommonCell *cell = [CommonCell commonCellWithTableView:tableView];
        cell.commonCellModel = self.contactsCellInfoArray[indexPath.row];
        return cell;
    } else {
        CommonCell *cell = [CommonCell commonCellWithTableView:tableView];
        //XMPPUserCoreDataStorageObject *contacts = self.fetchedResultController.fetchedObjects[indexPath.row];
        XMPPUserCoreDataStorageObject *contacts = [[self.contactsCellDataArray objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
       // HCPLog(@"ContactsTableVC---tableview数据--%zi %@ %@ %@ %@", contacts.section, contacts.sectionName, contacts.sectionNum, contacts.jidStr, contacts.displayName);
        cell.userContacts = contacts;
        return cell;
    }
}



#pragma mark 设置行头数据
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"";
    } else {
        NSArray *sections = self.contactsCellDataArray;
        if (sections.count > 0 ) {
            //XMPPUserCoreDataStorageObject *contacts = self.fetchedResultController.fetchedObjects[section];
            XMPPUserCoreDataStorageObject *contacts = [[self.contactsCellDataArray objectAtIndex:section - 1] objectAtIndex:0];
            //HCPLog(@"ContactsTableVC---tableviewHeader数据--%zi %@ %@ %@", contacts.section, contacts.sectionName, contacts.sectionNum, contacts.jidStr);
            return contacts.sectionName;
        } else {
            return @"";
        }

    }
}

#pragma mark 设置索引Index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.sectionTitleArray;
}

#pragma mark 设置索引数组与section对应关系
//第一个字符对应首列，最后一个字符对应尾列，第二个字符代表第一列，依次下去
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    HCPLog(@"---点击了索引-%@,%zi",title,index);
    if (index == 0 ) {
        
        return index;
    } else if (index == self.sectionTitleArray.count - 1){
        return index - 2;
    }
    else{
        return index - 1;
    }
}

#pragma mark 设置编辑模式为删除模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark 删除好友
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //XMPPUserCoreDataStorageObject *contact = self.fetchedResultController.fetchedObjects[indexPath.row];
        XMPPUserCoreDataStorageObject *contact = [[self.contactsCellDataArray objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
        XMPPJID *jId = contact.jid;
        
        //删除提示框
        //UIAlertActionStyleCancel 取消样式
        //UIAlertActionStyleDestructive 警告样式
        //UIAlertActionStyleDefault 默认样式
        UIAlertController *altert = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除这个好友吗" preferredStyle:UIAlertControllerStyleActionSheet];
        [altert addAction:[UIAlertAction actionWithTitle:@"我再考虑下" style:UIAlertActionStyleCancel handler:nil]];
        [altert addAction:[UIAlertAction actionWithTitle:@"我确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [[WXXMPPTools sharedWXXMPPTools].roster removeUser:jId];
        }]];
        [self presentViewController:altert animated:YES completion:nil];
    }
}


#pragma mark cell选择事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        //跳转到好友搜索页面
        SearchContactsVC *searchVC = [[SearchContactsVC alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
        
    }
    if (indexPath.section >0) {
        UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ChatVC *chatVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
        XMPPUserCoreDataStorageObject *contact = [[self.contactsCellDataArray objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
        chatVC.chatJid = contact.jid;
        HCPLog(@"单击和--%@--聊天---%@--",contact.jid.user,contact.jid);
        
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:NO];
    }
    
    //取消cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

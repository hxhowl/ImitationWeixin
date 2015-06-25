//
//  FindTableVC.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/6.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "FindTableVC.h"
#import "UILabel+autoWidth.h"
#import "CommonCell.h"
#import "CommonCellModel.h"

@interface FindTableVC ()
@property(nonatomic, strong) NSArray *findCellInfoArray;
@end

@implementation FindTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //重绘图标，不然显示出来的“选中”图片是默认的蓝色
    UIImage *image = [UIImage imageNamed:@"tabbar_discoverHL"];
    UIImage *oriImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     self.navigationController.tabBarItem.selectedImage = oriImage;
    
    //设置navigationItem样式
    [self setNavigationItem];
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

#pragma mark findCellInfoArray的get方法
- (NSArray *)findCellInfoArray{
    if (_findCellInfoArray == nil) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FindCellModel" ofType:@"plist"]];
        //HCPLog(@"log1---%@",dictArray);
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            CommonCellModel *findCellInfo = [CommonCellModel CommonCellWithDict:dict];
            [arr addObject:findCellInfo];
        }
        _findCellInfoArray = arr;
        //HCPLog(@"log---%@",arr);
    }
    return _findCellInfoArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view 代理方法

#pragma mark 设置section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

#pragma mark 每个section中row个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
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
    CommonCell *cell = [CommonCell commonCellWithTableView:tableView];

    NSInteger n = indexPath.row;
    if (indexPath.section > 0) {
        for (NSInteger j = 0; j< indexPath.section; j++) {
            n += [tableView numberOfRowsInSection:j];
        }
    }
    cell.commonCellModel = self.findCellInfoArray[n];
        return cell;
}

#pragma mark cell选择事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       //取消cell选中效果
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

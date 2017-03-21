//
//  YMMsgListController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMsgListController.h"
#import "YMMsgCell.h"
#import "YMMsgDetailController.h"
#import "UIBarButtonItem+HKExtension.h"
#import "YMBottomView.h"
#import "UIControl+Custom.h"


@interface YMMsgListController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray* dataArr;

//选择的数组
@property(nonatomic,strong)NSMutableArray* selectArr;

@property(nonatomic,strong)YMBottomView* btmView;


@end

@implementation YMMsgListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置按钮
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"del" target:self action:@selector(deleteMsgClick:)];
    
    _dataArr = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    
    YMWeakSelf;
    self.btmView = [[YMBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEGIHT - NavBarTotalHeight, SCREEN_WIDTH, 40) titlesArr:@[@"全选",@"删除"] bgColorsHexStrArr:@[@"ffffff",@"ffffff"] textColor:BlackColor selectColor:NavBarTintColor taskBlock:^(UIButton *btn) {
        DDLog(@"点击啦按钮。tag == %ld btn select == %d",(long)btn.tag,btn.selected);
        btn.custom_acceptEventInterval = 1;
    
        if (btn.tag == 0) {
            btn.selected = !btn.selected;
            [weakSelf.selectArr removeAllObjects];
            for (int i = 0 ; i < weakSelf.dataArr.count; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                if (btn.selected == YES) {
                    
                    [weakSelf.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
                }else{
                    [weakSelf.tableView deselectRowAtIndexPath:indexPath  animated:NO];
                }
            }
            if (btn.selected == YES) {
                weakSelf.selectArr = [weakSelf.dataArr mutableCopy];
            }
            DDLog(@"select == %@",weakSelf.selectArr);
        }else{
            btn.selected = YES;
            //删除
            [weakSelf.dataArr removeObjectsInArray:weakSelf.selectArr];
            weakSelf.tableView.editing = NO;
            
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.btmView.y = SCREEN_HEGIHT - NavBarTotalHeight ;
            }];
            
            [weakSelf.tableView reloadData];
        }
    }];
    
//    YMBottomView* btmView = [[YMBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEGIHT - NavBarTotalHeight, SCREEN_WIDTH, 40) titlesArr:@[@"全选",@"删除"] backGgColorsArr:@[@"111111",@"123456"] taskBlock:^(UIButton *btn) {
//        DDLog(@"点击啦按钮。tag == %d btn select == %d",btn.tag,btn.selected);
//        if (btn.tag == 0) {
//            btn.selected = !btn.selected;
//            [weakSelf.selectArr removeAllObjects];
//            for (int i = 0 ; i < weakSelf.dataArr.count; i ++) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                if (btn.selected == YES) {
//    
//                    [weakSelf.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
//                }else{
//                    [weakSelf.tableView deselectRowAtIndexPath:indexPath  animated:NO];
//                }
//            }
//            if (btn.selected == YES) {
//                  weakSelf.selectArr = [weakSelf.dataArr mutableCopy];
//            }
//            DDLog(@"select == %@",weakSelf.selectArr);
//    
//        }else{
//            
//            //删除
//            [weakSelf.dataArr removeObjectsInArray:weakSelf.selectArr];
//            weakSelf.tableView.editing = NO;
//            
//            [UIView animateWithDuration:0.5 animations:^{
//                 weakSelf.btmView.y = SCREEN_HEGIHT - NavBarTotalHeight ;
//            }];
//
//            [weakSelf.tableView reloadData];
//    
//        }
//
//    }];
//    self.btmView = btmView;
    [self.view addSubview:self.btmView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)deleteMsgClick:(UIButton* )btn{
    DDLog(@"删除了按钮  btn == %d",btn.selected);
    if (_dataArr.count == 0) {
        [MBProgressHUD showFail:@"已没有消息可删除啦！" view:self.view];
        return;
    }
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    btn.selected = self.tableView.editing;
    YMWeakSelf;
    if (btn.selected) {
        //  [self.tableView setEditing:YES animated:YES];
        
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.btmView.y = SCREEN_HEGIHT - NavBarTotalHeight - 40;
        }];
    }else{
        // [self.tableView setEditing:NO animated:YES];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.btmView.y = SCREEN_HEGIHT - NavBarTotalHeight;
        }];

    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMMsgCell* cell = [YMMsgCell cellDequeueReusableCellWithTableView:tableView];
    cell.titlLabel.text = _dataArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing == YES) {
      //  YMMsgCell* cell = [tableView cellForRowAtIndexPath:indexPath];

        if (![self.selectArr containsObject:_dataArr[indexPath.row]]) {
            [self.selectArr addObject:_dataArr[indexPath.row]];
        }
               DDLog(@"selectArr === %@",self.selectArr);
        
    }else{
        YMMsgDetailController* mvc = [[YMMsgDetailController alloc]init];
        mvc.title = @"消息详情";
        [self.navigationController pushViewController:mvc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectArr containsObject:_dataArr[indexPath.row]]) {
        [self.selectArr removeObject:_dataArr[indexPath.row]];
    }
     DDLog(@"selectArr === %@",self.selectArr);
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewEdit
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.selectArr containsObject:_dataArr[indexPath.row]]) {
        [self.selectArr addObject:_dataArr[indexPath.row]];
    }
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [[NSMutableArray alloc]init];
    }
    return _selectArr;
}
@end

//
//  MCSettingViewController.m
//  MaiCai
//
//  Created by Peng Jack on 14-2-18.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCSettingViewController.h"
#import "MCSettingCell.h"
#import "MCNetwork.h"

@interface MCSettingViewController ()
{
    @private
        NSMutableArray* data;
}
@end

@implementation MCSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //初始化数据结构
    data = [[NSMutableArray alloc]init];
    
    NSDictionary* obj1 = @{@"name":@"缓存",@"data": @[@"文字缓存",@"图片缓存"]};
    NSDictionary* obj2 = @{@"name":@"版本",@"data": @[@"检查更新"]};
    
    [data addObject:obj1];
    [data addObject:obj2];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -tableview
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
     NSString* title = data[indexPath.section][@"data"][indexPath.row];
    if (indexPath.section == 0) {
        [self showProgressHUD];
        if ([title isEqualToString:@"文字缓存"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[MCNetwork getInstance]clearDocumentCache];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    [self showMsgHint:@"清空缓存成功..."];
                    [self.tableView reloadData];
                });
            });
        }else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[MCNetwork getInstance]clearImageCache];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    [self showMsgHint:@"清空缓存成功..."];
                    [self.tableView reloadData];
                });
            });
        }
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* title = data[indexPath.section][@"data"][indexPath.row];
    
    MCSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (indexPath.section == 0) {
        if ([title isEqualToString:@"文字缓存"]) {
            cell.label.text =  cell.label.text = [[NSString alloc]initWithFormat:@"%@(%@MB)",title,[[MCNetwork getInstance] sizeDocumentCache]];
        }else {
            cell.label.text =  cell.label.text = [[NSString alloc]initWithFormat:@"%@(%@MB)",title,[[MCNetwork getInstance] sizeImageCache]];
        }
    }else {
        cell.label.text =  cell.label.text = [[NSString alloc]initWithFormat:@"%@",title];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* array = data[section][@"data"];
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return data.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return data[section][@"name"];
}


@end

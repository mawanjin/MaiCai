//
//  MCMineAddressViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-11.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCMineAddressViewController.h"
#import "MCNewMineAddressViewController.h"
#import "MCAddress.h"
#import "MCMineAdressCell.h"
#import "MCUserManager.h"
#import "MCContextManager.h"
#import "MCUser.h"
#import "MCOrderConfirmViewController.h"
#import "MCButton.h"

@implementation MCMineAddressViewController
{
    @private
        int addressId;
        NSIndexPath* index;
}
#pragma mark- base
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
    self.navigationItem.rightBarButtonItem=
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //获取地址数据
    MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
    [self showProgressHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.data = [[MCUserManager getInstance]getUserAddressByUserId:user.userId];
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:MC_ERROR_MSG_0001];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
                [self.tableView reloadData];
            });
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCMineAdressCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    MCAddress* address = self.data[indexPath.row];
    cell.usernameLabel.text = [[NSString alloc]initWithFormat:@"收货人：%@",address.shipper];
    if([self.previousView isKindOfClass:[MCOrderConfirmViewController class]]){
         MCOrderConfirmViewController* controller = ( MCOrderConfirmViewController*)self.previousView;
        if(indexPath.row == controller.index) {
            [cell.chooseIcon setHidden:NO];
        }else{
             [cell.chooseIcon setHidden:YES];
        }
    }else {
        [cell.chooseIcon setHidden:YES];
    }
    
    cell.mobileLabel.text = [[NSString alloc]initWithFormat:@"联系电话：%@",address.mobile];
    cell.addressLabel.text = [[NSString alloc]initWithFormat:@"收货地址：%@",address.address];
    
    [cell.editBtn setParam:indexPath];
    [cell.deleteBtn setParam:@{@"addressId":[NSNumber numberWithInt:address.id],@"indexPath":indexPath}];
    [cell.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.previousView isKindOfClass:[MCOrderConfirmViewController class]]){
        if(self.currentChoose != Nil) {
            MCMineAdressCell* cell =(MCMineAdressCell* ) [self.tableView cellForRowAtIndexPath:self.currentChoose];
            [cell.chooseIcon setHidden:YES];
        }
        MCMineAdressCell* cell = (MCMineAdressCell* )[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.chooseIcon setHidden:NO];
        self.currentChoose = indexPath;
        MCAddress* address = self.data[indexPath.row];
        MCOrderConfirmViewController* controller = ( MCOrderConfirmViewController*)self.previousView;
        controller.address = address;
        controller.index = indexPath.row;
        [self backBtnAction];
    }
}

#pragma mark- others
-(void)addBtnAction
{
    MCNewMineAddressViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCNewMineAddressViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)editBtnAction:(id)sender {
    NSIndexPath* indexPath = [(MCButton*)sender param];
    
   
    MCNewMineAddressViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCNewMineAddressViewController"];
    vc.navigationItem.title = @"修改收货地址";
    MCAddress* obj = self.data[indexPath.row];
    vc.obj = obj;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteBtnAction:(id)sender {
    UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:@"确定需要删除改收货地址吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    NSDictionary* dic = [(MCButton*)sender param];
    index = dic[@"indexPath"];
    addressId = [dic[@"addressId"]integerValue];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
                [[MCUserManager getInstance]deleteUserAddressById:[[NSString alloc]initWithFormat:@"%d",addressId]UserId:user.userId];
                [self.data removeObject:self.data[index.row]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            @catch (NSException *exception) {
                [self.view makeToast:@"操作失败" duration:2 position:@"center"];
            }
        });
    }else{
        return;
    }
}



@end

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
#import "Toast+UIView.h"
#import "MBProgressHUD.h"
#import "MCOrderConfirmViewController.h"

@implementation MCMineAddressViewController

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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.data = [[MCUserManager getInstance]getUserAddressByUserId:user.userId];
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"无法获取网络资源" duration:2 position:@"center"];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    cell.addressId = address.id;
    cell.parentView = self;
    cell.index = indexPath;
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


-(void)addBtnAction
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    MCNewMineAddressViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCNewMineAddressViewController"];
   
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc]animated:YES completion:Nil];
}



@end

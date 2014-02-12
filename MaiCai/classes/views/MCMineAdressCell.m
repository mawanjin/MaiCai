//
//  MCMineAdressCell.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-11.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCMineAdressCell.h"
#import "MCUserManager.h"
#import "MCMineAddressViewController.h"
#import "MCNewMineAddressViewController.h"
#import "MCAddress.h"
#import "Toast+UIView.h"
#import "MCContextManager.h"
#import "MCUser.h"

@implementation MCMineAdressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editBtnAction:(id)sender {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    MCNewMineAddressViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCNewMineAddressViewController"];
    vc.navigationItem.title = @"修改收货地址";
    MCAddress* obj = self.parentView.data[self.index.row];
    vc.obj = obj;
    [self.parentView.navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteBtnAction:(id)sender {
   UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:@"确定需要删除改收货地址吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
                [[MCUserManager getInstance]deleteUserAddressById:[[NSString alloc]initWithFormat:@"%d",self.addressId]UserId:user.userId];
                [self.parentView.data removeObject:self.parentView.data[self.index.row]];
                 dispatch_async(dispatch_get_main_queue(), ^{
                      [self.parentView.tableView reloadData];
                 });
            }
            @catch (NSException *exception) {
                [self.parentView.view makeToast:@"操作失败" duration:2 position:@"center"];
            }
        });
    }else{
        return;
    }
}
@end

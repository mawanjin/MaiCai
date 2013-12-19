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
    [self.parentView presentViewController:[[UINavigationController alloc]initWithRootViewController:vc]animated:NO completion:Nil];
}

- (IBAction)deleteBtnAction:(id)sender {
   UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:@"确定需要删除改收货地址吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        @try {
            [[MCUserManager getInstance]deleteUserAddressById:[[NSString alloc]initWithFormat:@"%d",self.addressId]];
            [self.parentView.data removeObject:self.parentView.data[self.index.row]];
            [self.parentView.tableView reloadData];
        }
        @catch (NSException *exception) {
            [self.parentView.view makeToast:@"操作失败" duration:2 position:@"center"];
        }

    }else{
        return;
    }
}
@end

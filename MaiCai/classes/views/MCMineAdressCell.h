//
//  MCMineAdressCell.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-11.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCButton.h"

@class MCMineAddressViewController;

@interface MCMineAdressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseIcon;
//@property unsigned int addressId;
//@property MCMineAddressViewController* parentView;
//@property NSIndexPath* index;
//- (IBAction)editBtnAction:(id)sender;
//- (IBAction)deleteBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet MCButton *editBtn;
@property (weak, nonatomic) IBOutlet MCButton *deleteBtn;

@end

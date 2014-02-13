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

@end

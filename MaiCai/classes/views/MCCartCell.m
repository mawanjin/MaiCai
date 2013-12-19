//
//  MCCartCell.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-15.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCCartCell.h"
#import "MCVegetable.h"
#import "MCShop.h"
#import "MCMineCartViewController.h"

@implementation MCCartCell

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

- (IBAction)chooseBtnClick:(id)sender {
    MCShop* shop = self.shops[self.indexPath.section];
    MCVegetable* vegetable = shop.vegetables[self.indexPath.row];
    vegetable.isSelected = !vegetable.isSelected;
    unsigned int count = 0;
    unsigned int i=0;
    for(i=0;i<shop.vegetables.count;i++) {
        MCVegetable* temp = shop.vegetables[i];
        if(temp.isSelected) {
            count++;
        }
    }
    if(count == shop.vegetables.count) {
        shop.isSelected = true;
    }else {
        shop.isSelected = false;
    }
    
    count = 0;
    
    for(i=0;i<self.shops.count;i++) {
        MCShop* temp = self.shops[i];
        if(temp.isSelected == true) {
            count++;
        }
    }
    if(count == self.shops.count) {
        self.parentView.isTotalChoosed = YES;
    }else{
        self.parentView.isTotalChoosed = NO;
    }
    
    [self.tableView reloadData];
    [self.parentView calculateTotalPrice];
    [self.parentView dispLayTotalChoosedBtn];
}
@end

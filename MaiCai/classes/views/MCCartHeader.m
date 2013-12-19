//
//  MCCartHeader.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-17.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCCartHeader.h"
#import "MCShop.h"
#import "MCVegetable.h"
#import "MCMineCartViewController.h"

@implementation MCCartHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(id)initMCCartHeader
{
    NSArray* objs = [[NSBundle mainBundle] loadNibNamed:@"MCCartHeader" owner:self options:nil];
    MCCartHeader* obj = objs[0];
    return obj;
}
- (IBAction)chooseBtnClickAction:(UIButton *)sender {
    MCShop* shop = self.shops[self.section];
    shop.isSelected = !shop.isSelected;
    unsigned int i = 0;
    if(shop.isSelected == true) {
        for(i=0;i<shop.vegetables.count;i++) {
            MCVegetable* temp = shop.vegetables[i];
            temp.isSelected = true;
        }
    }else {
        for(i=0;i<shop.vegetables.count;i++) {
            MCVegetable* temp = shop.vegetables[i];
            temp.isSelected = false;
        }
    }
    
    int count = 0;
    for(i=0;i<self.shops.count;i++) {
        MCShop* temp = self.shops[i];
        if(temp.isSelected == true) {
            count++;
        }
    }
    if(count == self.shops.count) {
        self.parentView.isTotalChoosed = YES;
    }else {
        self.parentView.isTotalChoosed = NO;
    }

    [self.tableView reloadData];
    [self.parentView calculateTotalPrice];
    [self.parentView dispLayTotalChoosedBtn];

}
@end

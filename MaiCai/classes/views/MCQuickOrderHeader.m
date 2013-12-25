//
//  MCQuickOrderHeader.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCQuickOrderHeader.h"
#import "MCQuickOrderViewController.h"
#import "MCRecipe.h"
#import "MCVegetable.h"

@implementation MCQuickOrderHeader

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

+(id)initInstance
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MCQuickOrderHeader" owner:self options:Nil]lastObject];
}

- (IBAction)chooseBtnClickAction:(UIButton *)sender {
    if(self.section == 0) {
        //主料
        self.parentView.recipe.isMainIngredientsAllSelected = !self.parentView.recipe.isMainIngredientsAllSelected;
        unsigned int i = 0;
        if(self.parentView.recipe.isMainIngredientsAllSelected  == true) {
            for(i=0;i<self.parentView.recipe.mainIngredients.count;i++) {
                MCVegetable* temp = self.parentView.recipe.mainIngredients[i];
                temp.isSelected = true;
            }
        }else {
            for(i=0;i<self.parentView.recipe.mainIngredients.count;i++) {
                MCVegetable* temp = self.parentView.recipe.mainIngredients[i];
                temp.isSelected = false;
            }
        }
        
        if(self.parentView.recipe.isMainIngredientsAllSelected && self.parentView.recipe.isAccessoryIngredientsAllSelected) {
            self.parentView.isTotalChoosed = YES;
        }else{
            self.parentView.isTotalChoosed = NO;
        }


    }else {
        //配料
        self.parentView.recipe.isAccessoryIngredientsAllSelected = !self.parentView.recipe.isAccessoryIngredientsAllSelected;
        unsigned int i = 0;
        if(self.parentView.recipe.isAccessoryIngredientsAllSelected  == true) {
            for(i=0;i<self.parentView.recipe.accessoryIngredients.count;i++) {
                MCVegetable* temp = self.parentView.recipe.accessoryIngredients[i];
                temp.isSelected = true;
            }
        }else {
            for(i=0;i<self.parentView.recipe.accessoryIngredients.count;i++) {
                MCVegetable* temp = self.parentView.recipe.accessoryIngredients[i];
                temp.isSelected = false;
            }
        }
        
        if(self.parentView.recipe.isMainIngredientsAllSelected && self.parentView.recipe.isAccessoryIngredientsAllSelected) {
            self.parentView.isTotalChoosed = YES;
        }else{
            self.parentView.isTotalChoosed = NO;
        }

    
    }
    
    [self.parentView.tableView reloadData];
    [self.parentView calculateTotalPrice];
    [self.parentView dispLayTotalChoosedBtn];
    
}


@end

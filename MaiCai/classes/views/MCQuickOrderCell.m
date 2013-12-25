//
//  MCQuickOrderCell.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCQuickOrderCell.h"
#import "MCQuickOrderViewController.h"
#import "MCRecipe.h"
#import "MCVegetable.h"

@implementation MCQuickOrderCell

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

- (IBAction)chooseBtnAction:(id)sender {
    if(self.indexPath.section == 0) {
        //主料
        MCVegetable* vegetable = self.parentView.recipe.mainIngredients[self.indexPath.row];
         vegetable.isSelected = !vegetable.isSelected;
        
        unsigned int count = 0;
        unsigned int i=0;
        for(i=0;i<self.parentView.recipe.mainIngredients.count;i++) {
            MCVegetable* temp = self.parentView.recipe.mainIngredients[i];
            if(temp.isSelected) {
                count++;
            }
        }
        if(count == self.parentView.recipe.mainIngredients.count) {
            self.parentView.recipe.isMainIngredientsAllSelected = true;
        }else {
            self.parentView.recipe.isMainIngredientsAllSelected = false;
        }
        
        if(self.parentView.recipe.isMainIngredientsAllSelected && self.parentView.recipe.isAccessoryIngredientsAllSelected) {
            self.parentView.isTotalChoosed = YES;
        }else{
            self.parentView.isTotalChoosed = NO;
        }

        
    }else{
        //配料
        MCVegetable* vegetable = self.parentView.recipe.accessoryIngredients[self.indexPath.row];
        vegetable.isSelected = !vegetable.isSelected;
        
        unsigned int count = 0;
        unsigned int i=0;
        for(i=0;i<self.parentView.recipe.accessoryIngredients.count;i++) {
            MCVegetable* temp = self.parentView.recipe.accessoryIngredients[i];
            if(temp.isSelected) {
                count++;
            }
        }
        if(count == self.parentView.recipe.accessoryIngredients.count) {
            self.parentView.recipe.isAccessoryIngredientsAllSelected = true;
        }else {
            self.parentView.recipe.isAccessoryIngredientsAllSelected = false;
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

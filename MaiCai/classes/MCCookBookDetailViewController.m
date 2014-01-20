//
//  MCCookBookDetailViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-16.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCCookBookDetailViewController.h"
#import "MCCookBookDetailHeader.h"
#import "MCCookStepCell.h"
#import "MCNetwork.h"
#import "MCVegetableManager.h"
#import "MCRecipeDishDescriptionCell.h"
#import "MCRecipeIngredientCell.h"
#import "MCRecipe.h"
#import "MCVegetable.h"
#import "MCStep.h"
#import "UIImageView+MCAsynLoadImage.h"

@implementation MCCookBookDetailViewController

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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.recipe = [[MCVegetableManager getInstance]getRecipeDetailById:self.recipe.id];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navItem setTitle:self.recipe.name];
                MCCookBookDetailHeader* header = [MCCookBookDetailHeader initInstance];
                header.label.text = self.recipe.name;
                [self.tableView setTableHeaderView:header];
                 [header.image loadImageByUrl:self.recipe.bigImage];
            });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:MC_ERROR_MSG_0001];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    if(section ==0) {
        return 1;
    }else if(section == 1){
        //主料
        return self.recipe.mainIngredients.count;
    }else if(section == 2) {
        //辅料
        return self.recipe.accessoryIngredients.count;
    }else if(section == 3) {
        //步骤
        return self.recipe.steps.count;
    }else {
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"介绍";
    }else if(section == 1){
        return @"主料";
    }else if(section == 2) {
        return @"辅料";
    }else if(section == 3) {
        return @"烹饪步骤";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return 98;
    }else if(indexPath.section == 1) {
        return 37;
    }else if(indexPath.section == 2) {
        return 37;
    }
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if(indexPath.section == 0) {
        MCRecipeDishDescriptionCell* temp = [tableView dequeueReusableCellWithIdentifier:@"dishDescriptionCell"];
        temp.descriptionLabel.text = self.recipe.introduction;
        cell = temp;
    }else if(indexPath.section == 1) {
        MCRecipeIngredientCell* temp = [tableView dequeueReusableCellWithIdentifier:@"ingredientCell"];
        MCVegetable* vegetable = self.recipe.mainIngredients[indexPath.row];
        temp.nameLabel.text = vegetable.name;
        temp.dosageLabel.text = vegetable.dosage;
        cell = temp;
    }else if(indexPath.section == 2) {
        MCRecipeIngredientCell* temp = [tableView dequeueReusableCellWithIdentifier:@"ingredientCell"];
        MCVegetable* vegetable = self.recipe.accessoryIngredients[indexPath.row];
        temp.nameLabel.text = vegetable.name;
        temp.dosageLabel.text = vegetable.dosage;
        cell = temp;
    }else if(indexPath.section == 3) {
        MCCookStepCell* temp = [tableView dequeueReusableCellWithIdentifier:@"cookStepCell"];
        MCStep* step = self.recipe.steps[indexPath.row];
        temp.label.text = step.content;
        [temp.image loadImageByUrl:step.image];
        cell = temp;
    }
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

@end

//
//  MCQuickOrderViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCQuickOrderViewController.h"
#import "MBProgressHUD.h"
#import "MCVegetableManager.h"
#import "MCRecipe.h"
#import "Toast+UIView.h"
#import "MCQuickOrderCell.h"
#import "MCVegetable.h"
#import "MCQuickOrderHeader.h"
#import "MCCartChangeNumView.h"

@interface MCQuickOrderViewController ()

@end

@implementation MCQuickOrderViewController

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
            self.recipe = [[MCVegetableManager getInstance]getRecipeById:self.recipe.id];
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
    if(section == 0){
        //主料
        return self.recipe.mainIngredients.count;
    }else{
        //辅料
        return self.recipe.accessoryIngredients.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCQuickOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"quickOrderCell"];
    
    if(indexPath.section == 0) {
        //主料
        MCVegetable* vegetable = self.recipe.mainIngredients[indexPath.row];
        cell.quantityLabel.text = [[NSString alloc]initWithFormat:@"用量：%@",vegetable.dosage];
       cell.nameLabel.text = [[NSString alloc]initWithFormat:@"%@x%d",vegetable.name,vegetable.quantity];
        cell.priceLabel.text = [[NSString alloc]initWithFormat:@"单价为%.2f元/%@",vegetable.price,vegetable.unit];
        NSMutableDictionary* relation = [[MCVegetableManager getInstance]getRelationshipBetweenProductAndImage];
        NSString* imageName = relation[[[NSString alloc]initWithFormat:@"%d",vegetable.product_id]];
        [cell.imageIcon setImage:[UIImage imageNamed:imageName]];
        cell.subTotalPriceLabel.text = [[NSString alloc]initWithFormat:@"小计%.2f元",vegetable.price*vegetable.quantity];
        if(indexPath.row == (self.recipe.mainIngredients.count-1)) {
            cell.line.hidden = YES;
        }
    }else {
        //辅料
         MCVegetable* vegetable = self.recipe.accessoryIngredients[indexPath.row];
        cell.quantityLabel.text = [[NSString alloc]initWithFormat:@"用量：%@",vegetable.dosage];
        cell.nameLabel.text = [[NSString alloc]initWithFormat:@"%@x%d",vegetable.name,vegetable.quantity];
        cell.priceLabel.text = [[NSString alloc]initWithFormat:@"单价为%.2f元/%@",vegetable.price,vegetable.unit];
        NSMutableDictionary* relation = [[MCVegetableManager getInstance]getRelationshipBetweenProductAndImage];
        NSString* imageName = relation[[[NSString alloc]initWithFormat:@"%d",vegetable.product_id]];
        [cell.imageIcon setImage:[UIImage imageNamed:imageName]];
        cell.subTotalPriceLabel.text = [[NSString alloc]initWithFormat:@"小计%.2f元",vegetable.price*vegetable.quantity];
        
        if(indexPath.row == (self.recipe.accessoryIngredients.count-1)) {
            cell.line.hidden = YES;
        }

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MCQuickOrderHeader* header = [MCQuickOrderHeader initInstance];
    header.parentViewController = self;
    if(section == 0) {
        //主料
        header.nameLabel.text = @"主料";
    }else{
        //辅料
        header.nameLabel.text = @"辅料";
    }
    
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCCartChangeNumView *popup = [[MCCartChangeNumView alloc] initWithNibName:@"MCCartChangeNumView" bundle:nil];
    popup.previousView = self;
    popup.indexPath = indexPath;
    [self presentPopupViewController:popup animated:YES completion:nil];
}

@end

//
//  MCVegetableDetailViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-5.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCVegetableDetailViewController.h"
#import "HMSegmentedControl.h"
#import "MCVegetable.h"
#import "MCVegetableManager.h"
#import "MCCartConfirmPopupView.h"
#import "MCContextManager.h"
#import "MCShop.h"
#import "MCVegetableDetailDescriptionCell.h"
#import "MCVegetableDetailRecipeCell.h"
#import "MCVegetableDetailShopInfoCell.h"
#import "UIImageView+MCAsynLoadImage.h"
#import "MCRecipe.h"
#import "MCCookBookDetailViewController.h"
#import "UILabel+MCAutoResize.h"

@interface MCVegetableDetailViewController ()
@property NSDictionary* data;
@end

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation MCVegetableDetailViewController

#pragma mark- base
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
    //self.discoutPriceLabel.hidden = YES;
    
    NSString* lng = ((NSDictionary*)[[MCContextManager getInstance]getDataByKey:MC_CONTEXT_POSITION])[@"lng"];
    NSString* lat = ((NSDictionary*)[[MCContextManager getInstance]getDataByKey:MC_CONTEXT_POSITION])[@"lat"];
    
    self.navItem.title = self.vegetable.name;
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"联系客服" style:UIBarButtonItemStylePlain target:self action:@selector(phoneCallAction:)];
    item.tintColor = [UIColor whiteColor];
    self.navItem.rightBarButtonItem = item;
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.data = [[MCVegetableManager getInstance]getVegetableDetailByProductId:self.vegetable.id Longitude: lng Latitude:lat];
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:MC_ERROR_MSG_0001];
            });
        }@finally {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSMutableArray* tenants = self.data[@"tenants"];
                MCShop* shop = tenants[0];
                self.vegetable = shop.vegetables[0];
                [self.imageIcon loadImageByUrl:self.vegetable.image];
                self.priceLabel.text = [[NSString alloc]initWithFormat:@"菜篮价：%.02f元/%@",self.vegetable.price,self.vegetable.unit];
                 self.discoutPriceLabel.text = [[NSString alloc]initWithFormat:@"市场价：%.02f元/%@",self.vegetable.originalPrice,self.vegetable.unit];
                self.shopLabel.text = self.vegetable.shop.name;
                
                [self.tableView reloadData];
                [self hideProgressHUD];
            });
        }
    });

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"介绍";
    }else if(section == 1) {
        return @"店铺信息";
    }else {
        return @"相关菜谱";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section !=0 && indexPath.section!=1) {
        MCCookBookDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCCookBookDetailViewController"];
        NSMutableArray* recipes = self.data[@"recipes"];
        MCRecipe* recipe = recipes[indexPath.row];
        vc.recipe = recipe;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
       MCVegetableDetailDescriptionCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"vegetableDetailDescriptionCell"];
        [cell.descriptionLabel autoResizeByText:self.data[@"summary"] PositionX:0 PositionY:0];
        return cell;
    }else if(indexPath.section == 1) {
        MCVegetableDetailShopInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"vegetableDetailShopInfoCell"];
        MCShop* shop = self.data[@"tenants"][0];
        cell.shopNameLabel.text = shop.name;
        [cell.shopImage loadImageByUrl:shop.image];
        [cell.licenseImage loadImageByUrl:shop.license];
        return cell;
    }else{
        MCVegetableDetailRecipeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"vegetableDetailRecipeCell"];
        NSMutableArray* recipes = self.data[@"recipes"];
        MCRecipe* recipe = recipes[indexPath.row];
        [cell.icon loadImageByUrl:recipe.image];
        cell.name.text = recipe.name;
        cell.description.text = recipe.introduction;
        if(indexPath.row == (recipes.count-1)) {
            cell.divideLine.hidden = YES;
        }
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        //商品介绍
        return [UILabel calculateHeightByText:self.data[@"summary"]];
    }else if(indexPath.section == 1) {
        //店铺信息
        return 110;
    }else {
        //菜谱
        return 68;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        //商品介绍
        return 1;
    }else if(section == 1) {
        //店铺信息
        return 1;
    }else {
        //菜谱
        return ((NSMutableArray*)self.data[@"recipes"]).count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


#pragma mark- others
- (IBAction)phoneCallAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://021-54331510"]];//打电话
}

- (IBAction)addProductToCartAction:(id)sender {
    MCCartConfirmPopupView *popup = [[MCCartConfirmPopupView alloc] initWithNibName:@"MCCartConfirmPopupView" bundle:nil];
    popup.previousView = self;
    popup.vegetable = self.vegetable;
    [self presentPopupViewController:popup animated:YES completion:nil];
}
@end

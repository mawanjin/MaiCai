//
//  MCQuickOrderViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCQuickOrderViewController.h"
#import "MCVegetableManager.h"
#import "MCRecipe.h"
#import "MCQuickOrderCell.h"
#import "MCVegetable.h"
#import "MCQuickOrderHeader.h"
#import "MCCartChangeNumView.h"
#import "MCQuickOrderTableHeader.h"
#import "MCNetwork.h"
#import "MCTradeManager.h"
#import "MCUser.h"
#import "MCContextManager.h"
#import "UIImageView+MCAsynLoadImage.h"

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
                [self showMsgHint:MC_ERROR_MSG_0001];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                MCQuickOrderTableHeader* header = [MCQuickOrderTableHeader initInstance];
                header.nameLabel.text = self.recipe.name;
                header.descriptionLabel.text = self.recipe.introduction;
                header.parentView = self;
                
                NSString* source = [[NSString alloc]initWithFormat:@"%@",self.recipe.bigImage];
                [header.image loadImageByUrl:source];
                self.tableView.tableHeaderView = header;
                [self.tableView reloadData];
            });
        }
    });
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
    cell.parentView = self;
    cell.indexPath = indexPath;
    if(indexPath.section == 0) {
        //主料
        if(self.recipe.mainIngredients.count>0) {
            MCVegetable* vegetable = self.recipe.mainIngredients[indexPath.row];
            
            cell.quantityLabel.text = [[NSString alloc]initWithFormat:@"用量：%@",vegetable.dosage];
            cell.nameLabel.text = [[NSString alloc]initWithFormat:@"%@x%d",vegetable.name,vegetable.quantity];
            cell.priceLabel.text = [[NSString alloc]initWithFormat:@"单价为%.2f元/%@",vegetable.price,vegetable.unit];
            NSMutableDictionary* relation = [[MCVegetableManager getInstance]getRelationshipBetweenProductAndImage];
            NSString* imageName = relation[[[NSString alloc]initWithFormat:@"%d",vegetable.product_id]];
            [cell.imageIcon setImage:[UIImage imageNamed:imageName]];
            cell.subTotalPriceLabel.text = [[NSString alloc]initWithFormat:@"小计%.2f元",vegetable.price*vegetable.quantity];
            if(vegetable.isSelected) {
                [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateNormal];
            }else {
                [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
            }
            
            if(indexPath.row == (self.recipe.mainIngredients.count-1)) {
                cell.line.hidden = YES;
            }
        }
    }else {
        //辅料
        if(self.recipe.accessoryIngredients.count>0){
             MCVegetable* vegetable = self.recipe.accessoryIngredients[indexPath.row];
            cell.quantityLabel.text = [[NSString alloc]initWithFormat:@"用量：%@",vegetable.dosage];
            cell.nameLabel.text = [[NSString alloc]initWithFormat:@"%@x%d",vegetable.name,vegetable.quantity];
            cell.priceLabel.text = [[NSString alloc]initWithFormat:@"单价为%.2f元/%@",vegetable.price,vegetable.unit];
            NSMutableDictionary* relation = [[MCVegetableManager getInstance]getRelationshipBetweenProductAndImage];
            NSString* imageName = relation[[[NSString alloc]initWithFormat:@"%d",vegetable.product_id]];
            [cell.imageIcon setImage:[UIImage imageNamed:imageName]];
            cell.subTotalPriceLabel.text = [[NSString alloc]initWithFormat:@"小计%.2f元",vegetable.price*vegetable.quantity];
            
            if(vegetable.isSelected) {
                [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateNormal];
            }else {
                [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
            }
            
            if(indexPath.row == (self.recipe.accessoryIngredients.count-1)) {
                cell.line.hidden = YES;
            }
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
    header.section = section;
    header.parentView = self;
    if(section == 0) {
        //主料
        header.nameLabel.text = @"主料";
        if(self.recipe.isMainIngredientsAllSelected) {
            [ header.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateNormal];
        }else{
            [ header.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
        }
    }else{
        //辅料
        header.nameLabel.text = @"辅料";
        if(self.recipe.isAccessoryIngredientsAllSelected) {
            [ header.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateNormal];
        }else{
            [ header.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
        }
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

-(void)calculateTotalPrice
{
    float totalPrice = 0.0f;
    unsigned int i = 0;
    
    for(i=0;i<self.recipe.mainIngredients.count;i++) {
        
        MCVegetable* vegetable = self.recipe.mainIngredients[i];
        if(vegetable.isSelected) {
            totalPrice += vegetable.quantity*vegetable.price;
        }
        
    }
    
    for(i=0;i<self.recipe.accessoryIngredients.count;i++) {
        MCVegetable* vegetable = self.recipe.accessoryIngredients[i];
        if(vegetable.isSelected) {
            totalPrice += vegetable.quantity*vegetable.price;
        }
        
    }
    self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",totalPrice];
}

-(void)dispLayTotalChoosedBtn
{
    if(self.isTotalChoosed) {
        [self.totalChooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateNormal];
    }else {
        [self.totalChooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
    }
}

- (IBAction)totalChooseAction:(id)sender {
    self.isTotalChoosed = !self.isTotalChoosed;
    self.recipe.isMainIngredientsAllSelected = self.isTotalChoosed;
    self.recipe.isAccessoryIngredientsAllSelected = self.isTotalChoosed;
    unsigned int i=0;
    
    float totalPrice = 0.0f;
    for(i=0;i<self.recipe.mainIngredients.count;i++) {
        MCVegetable* vegetable = self.recipe.mainIngredients[i];
        vegetable.isSelected = self.isTotalChoosed;
        totalPrice += vegetable.price*vegetable.quantity;
    }
    
    for(i=0;i<self.recipe.accessoryIngredients.count;i++) {
        MCVegetable* vegetable = self.recipe.accessoryIngredients[i];
        vegetable.isSelected = self.isTotalChoosed;
        totalPrice += vegetable.price*vegetable.quantity;
    }
    
    if(self.isTotalChoosed)
        self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",totalPrice];
    else
        self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：0.00元"];
    [self.tableView reloadData];
    [self dispLayTotalChoosedBtn];
}

-(void)resetTotalChooseBtn
{
    self.isTotalChoosed = false;
    self.recipe.isMainIngredientsAllSelected = self.isTotalChoosed;
    self.recipe.isAccessoryIngredientsAllSelected = self.isTotalChoosed;
    
   unsigned int i=0;
    for(i=0;i<self.recipe.mainIngredients.count;i++) {
        MCVegetable* vegetable = self.recipe.mainIngredients[i];
        vegetable.isSelected = self.isTotalChoosed;
    }
    
    for(i=0;i<self.recipe.accessoryIngredients.count;i++) {
        MCVegetable* vegetable = self.recipe.accessoryIngredients[i];
        vegetable.isSelected = self.isTotalChoosed;
        
    }
    
    self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：0.00元"];
    [self.tableView reloadData];
    [self dispLayTotalChoosedBtn];
}

- (IBAction)addCartAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            if ([[MCContextManager getInstance]isLogged]) {
                MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
                NSMutableArray* products = [[NSMutableArray alloc]init];
                for(int i=0;i<self.recipe.mainIngredients.count;i++) {
                    MCVegetable* vegetable = self.recipe.mainIngredients[i];
                    if(vegetable.isSelected == true) {
                        NSDictionary* product = @{
                                                  @"id":[[NSNumber alloc]initWithInt:vegetable.id],
                                                  @"quantity":[[NSNumber alloc]initWithInt:vegetable.quantity],
                                                  @"dosage":vegetable.dosage
                                                  };
                        [products addObject:product];
                    
                    }
                }
                
                for(int i=0;i<self.recipe.accessoryIngredients.count;i++) {
                    MCVegetable* vegetable = self.recipe.accessoryIngredients[i];
                    if(vegetable.isSelected == true) {
                        NSDictionary* product = @{
                                                  @"id":[[NSNumber alloc]initWithInt:vegetable.id],
                                                  @"quantity":[[NSNumber alloc]initWithInt:vegetable.quantity],
                                                  @"dosage":vegetable.dosage
                                                  };
                        [products addObject:product];
                    }
                }
                
                NSDictionary* recipe = @{
                                          @"id":[[NSNumber alloc]initWithInt:self.recipe.id],
                                          @"name":self.recipe.name,
                                          @"image":self.recipe.bigImage
                                         };
                [[MCTradeManager getInstance]addProductToCartOnlineByUserId:user.userId Products:products Recipe:recipe];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //结束后需要做些什么
                });
            }else {
                NSString* macId = (NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID];
                NSMutableArray* products = [[NSMutableArray alloc]init];
                for(int i=0;i<self.recipe.mainIngredients.count;i++) {
                    MCVegetable* vegetable = self.recipe.mainIngredients[i];
                    if(vegetable.isSelected == true) {
                        NSDictionary* product = @{
                                                  @"id":[[NSNumber alloc]initWithInt:vegetable.id],
                                                  @"quantity":[[NSNumber alloc]initWithInt:vegetable.quantity],
                                                  @"dosage":vegetable.dosage
                                                  };
                        [products addObject:product];
                        
                    }
                }
                
                for(int i=0;i<self.recipe.accessoryIngredients.count;i++) {
                    MCVegetable* vegetable = self.recipe.accessoryIngredients[i];
                    if(vegetable.isSelected == true) {
                        NSDictionary* product = @{
                                                  @"id":[[NSNumber alloc]initWithInt:vegetable.id],
                                                  @"quantity":[[NSNumber alloc]initWithInt:vegetable.quantity],
                                                  @"dosage":vegetable.dosage
                                                  };
                        [products addObject:product];
                    }
                }
                
                NSDictionary* recipe = @{
                                         @"id":[[NSNumber alloc]initWithInt:self.recipe.id],
                                         @"name":self.recipe.name,
                                         @"image":self.recipe.bigImage
                                         };
                
                [[MCTradeManager getInstance]addProductToCartByUserId:macId Products:products Recipe:recipe];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //结束后需要做些什么
                });
            }
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",exception);
                [self showMsgHint:MC_ERROR_MSG_0001];
            });
        }@finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        }
    });
}


@end

//
//  MCMineCartViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-10-30.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCMineCartViewController.h"
#import "MCVegetable.h"
#import "MCShop.h"
#import "MCTradeManager.h"
#import "MCVegetableManager.h"
#import "MCCartCell.h"
#import "MCCartChangeNumView.h"
#import "UIViewController+CWPopup.h"
#import "MCCartHeader.h"
#import "MCContextManager.h"
#import "MCLoginViewController.h"
#import "MCUser.h"
#import "MCOrderConfirmViewController.h"


@implementation MCMineCartViewController

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
    UIButton* button = [[UIButton alloc]init];
    button.titleLabel.text = @"删除";
    [self.navigationController.navigationItem.rightBarButtonItem setCustomView:button];
}

-(void)deleteAction
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self resetCart];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            if ([[MCContextManager getInstance]isLogged]) {
                MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
                self.data = [[MCTradeManager getInstance]getCartProductsOnlineByUserId:user.userId];
            }else {
                NSString* macId = (NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID];
                self.data = [[MCTradeManager getInstance]getCartProductsByUserId:macId];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dispLayTotalChoosedBtn];
                [self.tableView reloadData];
            });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:MC_ERROR_MSG_0001];
            });
            
        }@finally {
           dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
           });
        }

    });
}


-(void)resetCart
{
    self.isTotalChoosed = NO;
    [self dispLayTotalChoosedBtn];
    self.totalPriceLabel.text =[[NSString alloc]initWithFormat:@"总价：0.00元"];
    self.totalPrice = 0.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MCShop* shop  = self.data[section];
    return shop.vegetables.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCCartChangeNumView *popup = [[MCCartChangeNumView alloc] initWithNibName:@"MCCartChangeNumView" bundle:nil];
    popup.previousView = self;
    popup.indexPath = indexPath;
    [self presentPopupViewController:popup animated:YES completion:nil];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MCShop* shop  = self.data[section];
    MCCartHeader* header = [MCCartHeader initMCCartHeader];
    header.tableView = self.tableView;
    header.section = section;
    header.titleLabel.text = shop.name;
    header.shops = self.data;
    header.parentView = self;
    if(shop.isSelected) {
        [ header.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateNormal];
    }else{
        [ header.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
    }

    return  header;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 10)];
    
    [footer setBackgroundColor:[UIColor clearColor]];
    return  footer;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCCartCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"cartCell"];
    MCShop* shop = self.data[indexPath.section];
    NSMutableArray* vegetables = shop.vegetables;
    MCVegetable* vegetable = vegetables[indexPath.row];
    NSMutableDictionary* relation = [[MCVegetableManager getInstance]getRelationshipBetweenProductAndImage];
    NSString* imageName = relation[[[NSString alloc]initWithFormat:@"%d",vegetable.product_id]];
    [cell.imageIcon setImage:[UIImage imageNamed:imageName]];
    cell.nameLabel.text = vegetable.name;
    cell.quantityLabel.text = [[NSString alloc]initWithFormat:@"数量：%d",vegetable.quantity];
    cell.priceLabel.text = [[NSString alloc]initWithFormat:@"单价：%0.02f元/%@",vegetable.price,vegetable.unit];
    cell.subTotalPriceLabel.text = [[NSString alloc]initWithFormat:@"小计：%0.02f元",vegetable.price*vegetable.quantity];
    if(vegetable.isSelected) {
        [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateNormal];
    }else {
        [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
    }
    cell.indexPath = indexPath;
    cell.shops = self.data;
    cell.tableView = self.tableView;
    cell.parentView = self;
    
    if(indexPath.row == ([tableView numberOfRowsInSection:indexPath.section]-1)) {
        cell.divideline.hidden = YES;
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MCShop* shop = self.data[indexPath.section];
        NSMutableArray* vegetables = shop.vegetables;
        MCVegetable* vegetable = vegetables[indexPath.row];
        NSMutableArray* array = [[NSMutableArray alloc]init];
        [array addObject:[[NSNumber alloc]initWithInt:vegetable.id]];
        if ([[MCContextManager getInstance]isLogged]) {
            MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @try {
                    [[MCTradeManager getInstance]deleteProductsInCartOnlineByUserId:user.userId ProductIds:array];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [vegetables removeObjectAtIndex:indexPath.row];
                        if(vegetables.count == 0) {
                            [self.data removeObjectAtIndex:indexPath.section];
                        }
                        [self.tableView reloadData];
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
                    });
                }
            });
        }else {
            NSString* macId = (NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 @try {
                     [[MCTradeManager getInstance]deleteProductsInCartByUserId:macId ProductIds:array];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [vegetables removeObjectAtIndex:indexPath.row];
                         if(vegetables.count == 0) {
                             [self.data removeObjectAtIndex:indexPath.section];
                         }
                         [self.tableView reloadData];
                     });
                }@catch (NSException *exception) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showMsgHint:MC_ERROR_MSG_0001];
                    });
                }
                @finally {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    });
                }
            });
        }
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


-(void)calculateTotalPrice
{
    float totalPrice = 0.0f;
    unsigned int i = 0;
    unsigned int j = 0;
    for(i=0;i<self.data.count;i++) {
        MCShop* shop = self.data[i];
        for(j=0;j<shop.vegetables.count;j++) {
            MCVegetable* vegetable = shop.vegetables[j];
            if(vegetable.isSelected) {
                totalPrice += vegetable.quantity*vegetable.price;
            }
        }
    }
    self.totalPrice = totalPrice;
    self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",totalPrice];
}

- (IBAction)totalChooseBtnClickAction:(UIButton *)sender {
    self.isTotalChoosed = !self.isTotalChoosed;
    unsigned int i=0;
    unsigned int j=0;
    float totalPrice = 0.0f;
    for(i=0;i<self.data.count;i++) {
        MCShop* shop = self.data[i];
        for(j=0;j<shop.vegetables.count;j++) {
            MCVegetable* vegetable = shop.vegetables[j];
            vegetable.isSelected = self.isTotalChoosed;
            totalPrice += vegetable.price*vegetable.quantity;
        }
        shop.isSelected = self.isTotalChoosed;
    }
    self.totalPrice = totalPrice;
    if(self.isTotalChoosed)
        self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",totalPrice];
    else
        self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：0.00元"];
    [self.tableView reloadData];
    [self dispLayTotalChoosedBtn];
    
}

-(void)dispLayTotalChoosedBtn
{
    if(self.isTotalChoosed) {
        [self.totalChooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateNormal];
    }else {
        [self.totalChooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
    }
}

-(IBAction)submitBtnAction:(UIButton *)sender {
    if([[MCContextManager getInstance]isLogged]){
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:nil];
        MCOrderConfirmViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCOrderConfirmViewController"];
        vc.previousView = self;
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:Nil];
    
    }else{
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                    bundle:nil];
        MCLoginViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCLoginViewController"];
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:Nil];
    }
}

@end

//
//  SamplePopupViewController.m
//  CWPopupDemo
//
//  Created by Cezary Wojcik on 8/21/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import "MCCartChangeNumView.h"
#import "MCMineCartViewController.h"
#import "MCVegetable.h"
#import "MCTradeManager.h"
#import "MCShop.h"
#import "MCUser.h"
#import "MCContextManager.h"
#import "Toast+UIView.h"
#import "MBProgressHUD.h"
#import "MCQuickOrderViewController.h"
#import "MCRecipe.h"



@implementation MCCartChangeNumView

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
    // Do any additional setup after loading the view from its nib.
    // use toolbar as background because its pretty in iOS7
    MCVegetable* vegetable = nil;
    if([self.previousView isKindOfClass:[MCMineCartViewController class]]) {
        //如果是MCMineCartViewController
        MCShop* shop = ((MCMineCartViewController*)self.previousView).data[self.indexPath.section];
        vegetable = shop.vegetables[self.indexPath.row];
        self.vegetable = [[MCVegetable alloc]init];
        self.vegetable.id = vegetable.id;
        self.vegetable.product_id = vegetable.product_id;
        self.vegetable.quantity = vegetable.quantity;
        self.vegetable.price = vegetable.price;
        self.vegetable.unit = vegetable.unit;
    }else if([self.previousView isKindOfClass:[MCQuickOrderViewController class]]) {
        //如果是MCQuickOrderViewController
        if(self.indexPath.section == 0) {
            vegetable = ((MCQuickOrderViewController*)self.previousView).recipe.mainIngredients[self.indexPath.row];
        }else{
            vegetable = ((MCQuickOrderViewController*)self.previousView).recipe.accessoryIngredients[self.indexPath.row];
        }
        self.vegetable = vegetable;
    }
    self.unitLabel.text = [[NSString alloc]initWithFormat:@"单位：%@",self.vegetable.unit];
    self.quantityTextField.text = [[NSString alloc]initWithFormat:@"%d",self.vegetable.quantity];
    self.priceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",self.vegetable.quantity*self.vegetable.price];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
    if (self.previousView.popupViewController != nil) {
        [self.previousView dismissPopupViewControllerAnimated:YES completion:^{
            
            if([self.previousView isKindOfClass:[MCMineCartViewController class]]) {
               [ ((MCMineCartViewController*)self.previousView).tableView reloadData];
            }else if([self.previousView isKindOfClass:[MCQuickOrderViewController class]]){
                [ ((MCQuickOrderViewController*)self.previousView).tableView reloadData];
            }
        }];
    }
}
- (IBAction)plusBtnAction:(UIButton *)sender {
    NSInteger quantity = self.quantityTextField.text.integerValue;
    quantity++;
    self.quantityTextField.text = [[NSString alloc]initWithFormat:@"%ld",(long)quantity];
    float totalPrice = self.vegetable.price*quantity;
    self.priceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",totalPrice];
    self.vegetable.quantity = quantity;
}

- (IBAction)viewTouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if(self.quantityTextField.text == Nil) {
        self.quantityTextField.text= [[NSString alloc]initWithFormat:@"%d",0];
    }
     NSInteger quantity = self.quantityTextField.text.integerValue;
   
    float totalPrice = self.vegetable.price*quantity;
    self.priceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",totalPrice];
    self.vegetable.quantity = quantity;
}

- (IBAction)minusBtnAction:(UIButton *)sender {
     NSInteger quantity = self.quantityTextField.text.integerValue;
    if(quantity<=0) {
        return;
    }
    quantity--;
    self.quantityTextField.text = [[NSString alloc]initWithFormat:@"%ld",(long)quantity];
    float totalPrice = self.vegetable.price*quantity;
    self.priceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",totalPrice];
    self.vegetable.quantity = quantity;
}

- (IBAction)okBtnAction:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            if ([[MCContextManager getInstance]isLogged]) {
                if([self.previousView isKindOfClass:[MCMineCartViewController class]]) {
                    //如果是MCMineCartViewController
                    MCUser* user = [[MCContextManager getInstance]getDataByKey:MC_USER];
                    [[MCTradeManager getInstance]changeProductNumInCartOnlineByUserId:user.userId ProductId:self.vegetable.id Quantity:self.vegetable.quantity];
                    ((MCMineCartViewController*)self.previousView).data = [[MCTradeManager getInstance]getCartProductsOnlineByUserId:user.userId];
                }else if([self.previousView isKindOfClass:[MCQuickOrderViewController class]]) {
                    //如果是MCQuickOrderViewController
                    [(MCQuickOrderViewController*)self.previousView resetTotalChooseBtn];
                }
            }else {
                if([self.previousView isKindOfClass:[MCMineCartViewController class]]) {
                    //如果是MCMineCartViewController
                    NSString* macId = (NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID];
                    [[MCTradeManager getInstance]changeProductNumInCartByUserId:macId ProductId:self.vegetable.id Quantity:self.vegetable.quantity];
                    ((MCMineCartViewController*)self.previousView).data = [[MCTradeManager getInstance]getCartProductsByUserId:macId];

                }else if([self.previousView isKindOfClass:[MCQuickOrderViewController class]]) {
                    //如果是MCQuickOrderViewController
                     [(MCQuickOrderViewController*)self.previousView resetTotalChooseBtn];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.previousView.popupViewController != nil) {
                    [self.previousView dismissPopupViewControllerAnimated:NO completion:^{
                        if([self.previousView isKindOfClass:[MCMineCartViewController class]]) {
                            //如果是MCMineCartViewController
                            [ ((MCMineCartViewController*)self.previousView).tableView reloadData];
                        }else if([self.previousView isKindOfClass:[MCQuickOrderViewController class]]) {
                            //如果是MCQuickOrderViewController
                             [(MCQuickOrderViewController*)self.previousView resetTotalChooseBtn];
                            [ ((MCQuickOrderViewController*)self.previousView).tableView reloadData];

                        }
                    }];
                }
            });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"无法获取网络资源" duration:2 position:@"center"];
            });
        }@finally {
            dispatch_async(dispatch_get_main_queue(), ^{
               [MBProgressHUD hideHUDForView:self.view animated:NO];
            });
        }
    });
}

@end

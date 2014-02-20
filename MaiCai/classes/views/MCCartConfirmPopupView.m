//
//  SamplePopupViewController.m
//  CWPopupDemo
//
//  Created by Cezary Wojcik on 8/21/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import "MCCartConfirmPopupView.h"
#import "MCVegetable.h"
#import "MCTradeManager.h"
#import "MCContextManager.h"
#import "MCUser.h"
#import "Toast+UIView.h"




@implementation MCCartConfirmPopupView

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
    
    self.unitLabel.text = [[NSString alloc]initWithFormat:@"%.02f元/%@",self.vegetable.price,self.vegetable.unit];
    self.quantityTextField.text = [[NSString alloc]initWithFormat:@"%d",1];
    self.vegetable.quantity = 1;
    float totalPrice = self.vegetable.price*self.vegetable.quantity;
    self.priceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",totalPrice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
    if (self.previousView.popupViewController != nil) {
        [self.previousView dismissPopupViewControllerAnimated:YES completion:^{
            MCLog(@"popup view dismissed");
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
    if(quantity<=1) {
        return;
    }
    quantity--;
    self.quantityTextField.text = [[NSString alloc]initWithFormat:@"%ld",(long)quantity];
    float totalPrice = self.vegetable.price*quantity;
    self.priceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",totalPrice];
    self.vegetable.quantity = quantity;
}

- (IBAction)okBtnAction:(UIButton *)sender {
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[MCContextManager getInstance]isLogged]) {
            //登入状态
            MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
            
            NSArray* products =@[@{
                                      @"id":[[NSNumber alloc]initWithInt:self.vegetable.shop_product_id],
                                      @"quantity":[[NSNumber alloc]initWithInt:self.vegetable.quantity]
                                }];
            if ([[MCTradeManager getInstance]addProductToCartOnlineByUserId:user.userId Products:products Recipe:nil]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (self.previousView.popupViewController != nil) {
                        [self.previousView dismissPopupViewControllerAnimated:NO completion:^{
                        }];
                    }
                });
            }
        }else {
            //非登入状态
            NSString* macId = (NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID];
            
            NSArray* products =@[@{
                                     @"id":[[NSNumber alloc]initWithInt:self.vegetable.shop_product_id],
                                     @"quantity":[[NSNumber alloc]initWithInt:self.vegetable.quantity]
                                }];
            if ([[MCTradeManager getInstance]addProductToCartByUserId:macId Products:products Recipe:nil]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (self.previousView.popupViewController != nil) {
                        [self.previousView dismissPopupViewControllerAnimated:NO completion:^{
                        }];
                    }
                });
            }
        }
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self hideProgressHUD];
        });
    });
}
@end

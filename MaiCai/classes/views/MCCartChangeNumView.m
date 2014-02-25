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
    if (self.actionCancel) {
        self.actionCancel();
        self.actionCancel = nil;
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
    if (self.actionComplete) {
        self.actionComplete(self.vegetable);
        self.actionComplete = nil;
    }
}

@end

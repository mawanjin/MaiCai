//
//  SamplePopupViewController.h
//  CWPopupDemo
//
//  Created by Cezary Wojcik on 8/21/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CWPopup.h"
#import "MCBaseViewController.h"
@class MCVegetable;

@interface MCCartConfirmPopupView :MCBaseViewController

@property MCVegetable* vegetable;

@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (copy,nonatomic) void(^cancelAction)();
@property (copy,nonatomic) void(^okAction)(MCVegetable* vegetable);


- (IBAction)plusBtnAction:(UIButton *)sender;
- (IBAction)viewTouchDown:(id)sender;
- (IBAction)cancelBtnAction:(UIButton *)sender;
- (IBAction)minusBtnAction:(UIButton *)sender;
- (IBAction)okBtnAction:(UIButton *)sender;
@end

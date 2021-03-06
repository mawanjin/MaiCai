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


@interface MCCartChangeNumView :MCBaseViewController
- (IBAction)cancelBtnAction:(UIButton *)sender;
//@property  UIViewController* previousView;
//@property  NSIndexPath* indexPath;
@property  MCVegetable* vegetable;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (nonatomic,copy) void(^actionComplete)(MCVegetable* vegetable);
@property (nonatomic,copy) void(^actionCancel)();

- (IBAction)plusBtnAction:(UIButton *)sender;
- (IBAction)viewTouchDown:(id)sender;
- (IBAction)minusBtnAction:(UIButton *)sender;
- (IBAction)okBtnAction:(UIButton *)sender;
@end

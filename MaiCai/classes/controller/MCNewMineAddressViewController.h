//
//  MCNewMineAdressViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-11.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
#import "MCAddress.h"
@interface MCNewMineAddressViewController :MCBaseNavViewController

@property (weak, nonatomic) IBOutlet UITextField *receiver;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *address;

@property MCAddress* obj;

- (IBAction)okBtnAction:(id)sender;
- (IBAction)addressHelperAction:(id)sender;
- (IBAction)tappedAction:(id)sender;
@end

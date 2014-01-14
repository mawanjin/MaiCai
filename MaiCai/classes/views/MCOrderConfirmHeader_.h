//
//  MCOrderConfirmHeader_.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCOrderConfirmHeader_ : UIView
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressLabel;

@property UIViewController* parentView;
- (IBAction)helperAction:(UIButton *)sender;
+(id)initInstance;
@end

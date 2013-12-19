//
//  MCChangePasswordView.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-21.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CWPopup.h"
@class MCPersonalInfoViewController;

@interface MCChangePasswordView : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property  MCPersonalInfoViewController* previousView;
- (IBAction)cancelBtn:(id)sender;
- (IBAction)okBtn:(id)sender;

@end

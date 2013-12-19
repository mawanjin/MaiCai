//
//  MCChangeNicknameViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-21.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CWPopup.h"
@class  MCPersonalInfoViewController;

@interface MCChangeNicknameView : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property  MCPersonalInfoViewController* previousView;

- (IBAction)okBtnAction:(id)sender;

- (IBAction)cancelBtnAction:(id)sender;
@end

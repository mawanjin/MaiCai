//
//  MCAddressHelperView.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-22.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CWPopup.h"

@interface MCAddressHelperView : UIViewController
@property  UIViewController* previousView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
- (IBAction)cancelBtn:(id)sender;
- (IBAction)setAddressAction:(UIButton *)sender;

@end

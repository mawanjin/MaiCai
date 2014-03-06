//
//  MCFeedbackViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-18.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
@class GCPlaceholderTextView;
@interface MCFeedbackViewController :MCBaseNavViewController
@property (weak, nonatomic) IBOutlet  GCPlaceholderTextView* content;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (copy,nonatomic) void(^submitComplete)();
- (IBAction)submitBtnAction:(UIButton *)sender;
- (IBAction)viewClickAction:(id)sender;

@end

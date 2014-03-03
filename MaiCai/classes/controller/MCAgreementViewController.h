//
//  MCAgreementViewController.h
//  MaiCai
//
//  Created by Peng Jack on 14-2-27.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
#import "DTAttributedTextView.h"

@interface MCAgreementViewController : MCBaseNavViewController

@property (weak, nonatomic) IBOutlet DTAttributedTextView *textView;
@property (copy,nonatomic) void(^agreeComplete)();
@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)agreeAction:(id)sender;

@end

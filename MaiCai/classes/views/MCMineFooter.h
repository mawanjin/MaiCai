//
//  MCMineFooter.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-18.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCMineFooter : UIView<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property UIViewController* parentView;
+(id)initInstance;
- (IBAction)clickAction:(UIButton *)sender;
@end

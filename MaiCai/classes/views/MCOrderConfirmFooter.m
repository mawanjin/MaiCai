//
//  MCOrderConfirmFooter.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-26.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCOrderConfirmFooter.h"
#import "MCOrderConfirmViewController.h"

@implementation MCOrderConfirmFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(id)initInstance {
    MCOrderConfirmFooter* view = [[[NSBundle mainBundle]loadNibNamed:@"MCOrderConfirmFooter" owner:self options:nil]lastObject];
    [view.alipayBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
     [view.alipayBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateSelected];
    
    [view.cashpayBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
    [view.cashpayBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateSelected];
    
    [view.alipayBtn setSelected:YES];
    [view.cashpayBtn setSelected:NO];
    return view;
}

- (IBAction)chooseAction:(id)sender {
    UIButton* btn = sender;
    if(!btn.isSelected) {
        [btn setSelected:YES];
        self.parentView.paymentMethod = [btn.titleLabel.text integerValue];
        if(btn == self.alipayBtn) {
            [self.cashpayBtn setSelected:NO];
        }else{
            [self.alipayBtn setSelected:NO];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

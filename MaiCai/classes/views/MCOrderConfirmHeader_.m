//
//  MCOrderConfirmHeader_.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCOrderConfirmHeader_.h"
#import "MCAddressHelperView.h"

@implementation MCOrderConfirmHeader_

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)helperAction:(UIButton *)sender {
    MCAddressHelperView *popup = [[MCAddressHelperView alloc] initWithNibName:@"MCAddressHelperView" bundle:nil];
    popup.previousView = self.parentView;
    [self.parentView presentPopupViewController:popup animated:YES completion:nil];
}

+(id)initInstance
{
    MCOrderConfirmHeader_* view =  [[[NSBundle mainBundle]loadNibNamed:@"MCOrderConfirmHeader_" owner:self options:nil]lastObject];
    return view;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end

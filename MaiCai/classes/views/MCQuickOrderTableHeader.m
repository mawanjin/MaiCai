//
//  MCQuickOrderTableHeader.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCQuickOrderTableHeader.h"
#import "MCCookBookDetailViewController.h"
#import "MCQuickOrderViewController.h"

@implementation MCQuickOrderTableHeader

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

- (IBAction)clickAction:(UIButton *)sender {
    if([self.parentView isKindOfClass:[MCQuickOrderViewController class]]) {
        MCQuickOrderViewController* controller = (MCQuickOrderViewController*)self.parentView;
        MCCookBookDetailViewController *vc = [controller.storyboard instantiateViewControllerWithIdentifier:@"MCCookBookDetailViewController"];
        vc.recipe = controller.recipe;
        [self.parentView presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
        }];

    }
}

+(id)initInstance
{
    MCQuickOrderTableHeader* view = [[[NSBundle mainBundle]loadNibNamed:@"MCQuickOrderTableHeader" owner:self options:Nil]lastObject];
    return view;
}

@end

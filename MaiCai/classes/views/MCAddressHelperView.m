//
//  MCAddressHelperView.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-22.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCAddressHelperView.h"
#import "MCNewMineAddressViewController.h"
#import "MCOrderConfirmViewController.h"
#import "MCOrderConfirmHeader_.h"


@interface MCAddressHelperView ()

@end

@implementation MCAddressHelperView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navbar setBackgroundImage:[UIImage imageNamed:@"bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtn:(id)sender {
    if (self.previousView.popupViewController != nil) {
        [self.previousView dismissPopupViewControllerAnimated:YES completion:^{
            MCLog(@"popup view dismissed");
        }];
    }
}

- (IBAction)setAddressAction:(UIButton *)sender {
    if([self.previousView isKindOfClass:[MCNewMineAddressViewController class]]) {
        MCNewMineAddressViewController* controller = (MCNewMineAddressViewController*)self.previousView;
        if([sender.titleLabel.text isEqualToString:@"紫欣公寓[上海市闵行区碧秀路98弄]"]) {
            controller.address.text = @"上海市闵行区碧秀路98弄";
        }else if([sender.titleLabel.text isEqualToString:@"众众家园[上海市闵行区新建东路388号]"]) {
            controller.address.text = @"上海市闵行区新建东路388号";
        }else if ([sender.titleLabel.text isEqualToString:@"地铁明珠苑[上海市闵行区新建东路198弄]"]) {
            controller.address.text = @"上海市闵行区新建东路198弄";
        }
    }else if([self.previousView isKindOfClass:[MCOrderConfirmViewController class]]) {
        MCOrderConfirmViewController* controller = (MCOrderConfirmViewController*)self.previousView;
        MCOrderConfirmHeader_* header = (MCOrderConfirmHeader_*)controller.tableView.tableHeaderView;
        if([sender.titleLabel.text isEqualToString:@"紫欣公寓[上海市闵行区碧秀路98弄]"]) {
            header.addressLabel.text = @"上海市闵行区碧秀路98弄";
        }else if([sender.titleLabel.text isEqualToString:@"众众家园[上海市闵行区新建东路388号]"]) {
            header.addressLabel.text = @"上海市闵行区新建东路388号";
        }else if ([sender.titleLabel.text isEqualToString:@"地铁明珠苑[上海市闵行区新建东路198弄]"]) {
            header.addressLabel.text = @"上海市闵行区新建东路198弄";
        }
    }
   
    [self cancelBtn:nil];
}
@end

//
//  MCMineOrderViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-27.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
#import "HMSegmentedControl.h"

@interface MCMineOrderViewController : MCBaseNavViewController<UITableViewDataSource,UITableViewDelegate>
@property   HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* data;
- (void) segmentChanged:(UISegmentedControl *)paramSender;
@end

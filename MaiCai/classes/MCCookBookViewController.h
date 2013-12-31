//
//  MCCookBookViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseViewController.h"
@class HMSegmentedControl;

@interface MCCookBookViewController : MCBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* recipes;
@property NSMutableArray* healthList;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@end

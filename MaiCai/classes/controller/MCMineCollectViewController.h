//
//  MCMineCollectViewController.h
//  MaiCai
//
//  Created by Peng Jack on 14-1-13.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
#import "MJRefresh.h"
@class HMSegmentedControl;

@interface MCMineCollectViewController : MCBaseNavViewController<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* recipes;
@property NSMutableArray* healthList;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic,weak) MJRefreshHeaderView *header;
@property (nonatomic,weak) MJRefreshFooterView *footer;
@end

//
//  MCCookBookViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseTabViewController.h"
#import "MJRefresh.h"
@class HMSegmentedControl;

@interface MCCookBookViewController : MCBaseTabViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* recipes;
@property NSMutableArray* healthList;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property MJRefreshHeaderView *header;
@property MJRefreshFooterView *footer;
@end

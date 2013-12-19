//
//  MCCookBookDetailViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-16.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"

@interface MCCookBookDetailViewController : MCBaseNavViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

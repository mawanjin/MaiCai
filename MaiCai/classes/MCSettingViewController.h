//
//  MCSettingViewController.h
//  MaiCai
//
//  Created by Peng Jack on 14-2-18.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"

@interface MCSettingViewController : MCBaseNavViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

//
//  MCAddressHelperViewController.h
//  MaiCai
//
//  Created by Peng Jack on 14-2-21.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"

@interface MCAddressHelperViewController : MCBaseNavViewController<UITableViewDataSource,UITableViewDelegate>
@property NSMutableArray* data;
@property (nonatomic,strong)void(^selectionComplete)(NSString* address);
@property (nonatomic,strong)void(^showMsg)();
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

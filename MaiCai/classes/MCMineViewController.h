//
//  MCKitchenViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseTabViewController.h"
@class MCMineFooter;
@interface MCMineViewController : MCBaseTabViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *quitAndLoginLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property NSMutableArray* data;
@end

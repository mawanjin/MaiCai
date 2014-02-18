//
//  MCMineAddressViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-11.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
#import "MCAddress.h"
@interface MCMineAddressViewController :MCBaseNavViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSIndexPath* currentChoose ;
@property NSMutableArray* data;
@property int choosedRow;
@property (strong,nonatomic) void(^chooseAddressComplete)(MCAddress* address,int row);
-(void)addBtnAction;
@end

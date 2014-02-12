//
//  MCCartHeader.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-17.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCMineCartViewController;

@interface MCCartHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel __weak *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property int section;
@property UITableView* __weak tableView;
@property NSMutableArray* __weak shops;
@property MCMineCartViewController* __weak parentView;
+(id)initMCCartHeader;
- (IBAction)chooseBtnClickAction:(UIButton *)sender;

@end

//
//  MCCartCell.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-15.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCVegetable;
@class MCMineCartViewController;

@interface MCCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property NSIndexPath* indexPath;
@property UITableView* tableView;
@property NSMutableArray* shops;
@property MCMineCartViewController* parentView;
@property (weak, nonatomic) IBOutlet UIImageView *divideline;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
- (IBAction)chooseBtnClick:(id)sender;

@end

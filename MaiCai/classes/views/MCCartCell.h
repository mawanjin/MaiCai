//
//  MCCartCell.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-15.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCButton.h"
@interface MCCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UIImageView *divideline;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet MCButton *chooseBtn;

@end

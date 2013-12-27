//
//  MCCookBookCell.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-27.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCCookBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@end

//
//  MCVegetableDetailRecipeCell.h
//  MaiCai
//
//  Created by Peng Jack on 14-1-7.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCVegetableDetailRecipeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UIImageView *divideLine;

@end

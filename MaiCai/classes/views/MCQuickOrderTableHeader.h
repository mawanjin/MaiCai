//
//  MCQuickOrderTableHeader.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCQuickOrderTableHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
+(id)initInstance;
@end

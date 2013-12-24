//
//  MCQuickOrderViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
@class MCRecipe;

@interface MCQuickOrderViewController : MCBaseNavViewController<UITableViewDataSource,UITableViewDelegate>
@property MCRecipe* recipe;
@end

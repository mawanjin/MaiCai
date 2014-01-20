//
//  MCBaseNavViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-7.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCBaseViewController.h"

@interface MCBaseNavViewController : MCBaseViewController
@property MCBaseViewController* previousView;
-(void)backBtnAction;
@end

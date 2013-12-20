//
//  MCSearchViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-19.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MCSearchViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>

@property NSMutableArray* hotWords;
@property NSMutableArray* suggestData;
@property NSMutableArray* filterData;

@end

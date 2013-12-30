//
//  MCCookBookViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCCookBookViewController.h"
#import "MCCookBookDetailViewController.h"
#import "MCVegetableManager.h"
#import "MCCookBookCell.h"
#import "MCNetwork.h"
#import "MCRecipe.h"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"
#import "HMSegmentedControl.h"

@interface MCCookBookViewController ()

@end

@implementation MCCookBookViewController
int page = 1;
int pageSize = 10;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"养身";
    
    CGFloat yDelta;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        yDelta = 20.0f;
    } else {
        yDelta = 0.0f;
    }

    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"菜谱", @"百科"]];
    [self.segmentedControl setSelectedSegmentIndex:0];
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.font = [UIFont systemFontOfSize:15];
    self.segmentedControl.selectionIndicatorHeight = 2;
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.41f green:0.75f blue:0.27f alpha:1.00f];
    self.segmentedControl.selectedTextColor = [UIColor colorWithRed:0.41f green:0.75f blue:0.27f alpha:1.00f];
    self.segmentedControl.textColor = [UIColor grayColor];
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.scrollEnabled = YES;
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [self.segmentedControl setFrame:CGRectMake(0, 40 + yDelta, 320, 40)];
    //[self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    
    UIView* view = [[UIView alloc]initWithFrame:self.segmentedControl.frame];
    [view setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = view;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    page = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.recipes = [[MCVegetableManager getInstance]getRecipesByPage:page Pagesize:pageSize];
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"无法获取网络资源" duration:2 position:@"center"];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView reloadData];
            });
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.recipes.count) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                page++;
                NSMutableArray* newData = [[MCVegetableManager getInstance]getRecipesByPage:page Pagesize:pageSize];
                
                [self.recipes addObjectsFromArray:newData];
            }
            @catch (NSException *exception) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:@"无法获取网络资源" duration:2 position:@"center"];
                });
            }
            @finally {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.tableView reloadData];
                });
            }
        });

    }else {
        MCCookBookDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCCookBookDetailViewController"];
        vc.recipe = self.recipes[indexPath.row];
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.recipes.count){
        //加载更多
        MCCookBookCell* cell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
        return cell;
    }else {
        MCCookBookCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cookBookCell"];
        MCRecipe* recipe = self.recipes[indexPath.row];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage* image = [[MCNetwork getInstance]loadImageFromSource:recipe.image];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image.image = image;
            });
        });
        cell.nameLabel.text = recipe.name;
        cell.introductionLabel.text = recipe.introduction;
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.recipes.count) {
        return 43;
    }else {
        return 73;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recipes.count+1;
}

@end

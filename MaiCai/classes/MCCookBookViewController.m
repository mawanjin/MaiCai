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

@interface MCCookBookViewController ()

@end

@implementation MCCookBookViewController

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
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.recipes = [[MCVegetableManager getInstance]getRecipes];
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
    MCCookBookDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCCookBookDetailViewController"];
    vc.recipe = self.recipes[indexPath.row];
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recipes.count;
}

@end

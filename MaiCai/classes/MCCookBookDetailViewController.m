//
//  MCCookBookDetailViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-16.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCCookBookDetailViewController.h"
#import "MCCookBookDetailHeader.h"
#import "MCCookStepCell.h"
#import "MCNetwork.h"

@implementation MCCookBookDetailViewController

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
    [self.tableView setTableHeaderView:[MCCookBookDetailHeader initInstance]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0) {
        return 1;
    }else {
        return 3;
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"介绍";
    }else if(section == 1){
        return @"主料";
    }else if(section == 2) {
        return @"辅料";
    }else if(section == 3) {
        return @"调料";
    }else if(section == 4) {
        return @"烹饪步骤";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return 98;
    }else if(indexPath.section == 1) {
        return 37;
    }else if(indexPath.section == 2) {
        return 37;
    }else if(indexPath.section == 3) {
        return 37;
    }
    
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if(indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"dishDescriptionCell"];
    }else if(indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientCell"];
    }else if(indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientCell"];
    }else if(indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientCell"];
    }else if(indexPath.section == 4) {
        MCCookStepCell* temp = [tableView dequeueReusableCellWithIdentifier:@"cookStepCell"];
        NSString* source = [[NSString alloc]initWithFormat:@"http://61.172.243.70:1980/test/step%d.png",(indexPath.row+1)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage* image = [[MCNetwork getInstance]loadImageFromSource:source];
            dispatch_async(dispatch_get_main_queue(), ^{
                temp.image.image = image;
            });
        });
        cell = temp;
    }
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

@end

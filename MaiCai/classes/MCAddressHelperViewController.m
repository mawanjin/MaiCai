//
//  MCAddressHelperViewController.m
//  MaiCai
//
//  Created by Peng Jack on 14-2-21.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCAddressHelperViewController.h"
#import "MCAddressHelperCell.h"
#import "MCUserManager.h"

@interface MCAddressHelperViewController ()

@end

@implementation MCAddressHelperViewController

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
    [self showProgressHUD];
    
    if (self.showMsg) {
        self.showMsg();
        self.showMsg = nil;
    }
    
    //联系客服
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"联系客服" style:UIBarButtonItemStylePlain target:self action:@selector(phoneCallAction:)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.data = [[MCUserManager getInstance]getAddressHelperList];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self hideProgressHUD];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)phoneCallAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://021-54331510"]];//打电话
}

#pragma mark -tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* obj = self.data[indexPath.row];
    MCAddressHelperCell* cell = [tableView dequeueReusableCellWithIdentifier:@"addressHelperCell"];
    cell.nameLabel.text = [[NSString alloc]initWithFormat:@"[%@]%@",obj[@"name"],obj[@"address"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectionComplete) {
         NSDictionary* obj = self.data[indexPath.row];
        self.selectionComplete(obj[@"address"]);
        self.selectionComplete = nil;
        [self backBtnAction];
    }
}

@end

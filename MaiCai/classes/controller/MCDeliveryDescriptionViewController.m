//
//  MCDeliveryDescriptionViewController.m
//  MaiCai
//
//  Created by Peng Jack on 14-2-27.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCDeliveryDescriptionViewController.h"
#import "DTCoreText.h"
#import "MCTradeManager.h"

@interface MCDeliveryDescriptionViewController ()

@end

@implementation MCDeliveryDescriptionViewController

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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.data = [[MCTradeManager getInstance]getDeliveryDescription];
        if (self.data) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSMutableString* html = [[NSMutableString alloc]init];
                 for (int i=0; i<self.data.count; i++) {
                     NSDictionary* obj = self.data[i];
                     [html appendFormat:@"<br><p>"];
                     [html appendFormat:@"<b>%@</b><br>",obj[@"title"]];
                     [html appendFormat:@"%@",obj[@"content"]];
                     [html appendFormat:@"</p>"];
                 }
                 
                 NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
                 NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:NULL];
                 self.textView.attributedString = attrString;
                 self.textView.backgroundColor = [UIColor clearColor];
             });
        }else {
        
        }
    });
    
   
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

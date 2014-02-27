//
//  MCOrderDetailViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-27.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCOrderDetailViewController.h"
#import "MCAddress.h"
#import "MCOrderDetailHeader.h"
#import "MCOrderConfirmSectionHeader.h"
#import "MCTradeManager.h"
#import "MCContextManager.h"
#import "MCOrder.h"
#import "MCOrderDetailCell.h"
#import "MCVegetable.h"
#import "MCVegetableManager.h"
#import "MCOrderDetailFooter.h"
#import "MCUser.h"
#import "MCAppDelegate.h"
#import "UIImageView+MCAsynLoadImage.h"



#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"


@implementation MCOrderDetailViewController

#pragma mark- base
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
    
    //联系客服
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"联系客服" style:UIBarButtonItemStylePlain target:self action:@selector(phoneCallAction:)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.order = [[MCTradeManager getInstance]getOrderDetailByOrderId:[[NSString alloc]initWithFormat:@"%d",self.order.id]];
        
        if (self.order) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
                //初始化头
                MCOrderDetailHeader* header = [MCOrderDetailHeader initInstance];
                header.nameLabel.text = [[NSString alloc]initWithFormat:@"收货人：%@", self.order.shipper];
                header.mobileLabel.text = [[NSString alloc]initWithFormat:@"联系电话：%@",self.order.tel];
                header.addressLabel.text = [[NSString alloc]initWithFormat:@"地址：%@",self.order.address];
                self.tableView.tableHeaderView = header;
                
                //初始化尾
                MCOrderDetailFooter* footer = [MCOrderDetailFooter initInstance];
                footer.paymentMethodLabel.text = [[NSString alloc]initWithFormat:@"支付方式：%@",self.order.paymentMethod];
                footer.shipMethodLabel.text = [[NSString alloc]initWithFormat:@"配送方式：%@",self.order.shipMethod];
                footer.orderStatusLabel.text = [[NSString alloc]initWithFormat:@"订单状态：%@",self.order.status];
                footer.messageLabel.text = [[NSString alloc]initWithFormat:@"留言：%@",self.order.message];
                
                self.tableView.tableFooterView = footer;
                
                self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",self.order.total];
                
                if([self.order.status isEqualToString: @"待付款"]) {
                    [self.payBtn setHidden:NO];
                }else{
                    [self.payBtn setHidden:YES];
                }
                [self.tableView reloadData];
            });
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
                //[self showMsgHint:MC_ERROR_MSG_0001];
            });
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCOrderDetailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"orderDetailCell"];
    MCVegetable* vegetable = self.order.products[indexPath.row];
    cell.nameLabel.text = [[NSString alloc]initWithFormat:@"%@",vegetable.name];
    cell.quantityLabel.text =[[NSString alloc]initWithFormat:@"数量：%d",vegetable.quantity];

    cell.priceLabel.text = [[NSString alloc]initWithFormat:@"单价：%.02f元",vegetable.price];
    cell.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"小计：%.02f元",vegetable.price*vegetable.quantity];
    [cell.imageIcon loadImageByUrl:vegetable.image];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.order.products.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MCOrderConfirmSectionHeader* header =  [MCOrderConfirmSectionHeader initInstance];
    header.shopNameLabel.text = self.order.shopName;
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}


#pragma mark- others
- (IBAction)phoneCallAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://021-54331510"]];//打电话
}

- (IBAction)payBtnAction:(id)sender {
    NSString* orderIds = [[NSString alloc]initWithFormat:@"%d",self.order.id];
    NSString* userId = ((MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER]).userId;
    self.pay_no = [[MCTradeManager getInstance]getPaymentNoByUserId:userId OrderIds:orderIds Amount:self.order.total];
    MCAppDelegate* delegate = (MCAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setPay_no:self.pay_no];
    
    [delegate setAlipayEndAction:^{
        self.showMsg(@"交易失败");
        [self backBtnAction];
    }];
    
    [delegate setAlipayErrorAction:^{
        self.showMsg(MC_ERROR_MSG_0001);
        [self backBtnAction];
    }];
    
    NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
    //NSString* privateKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"];
    
    NSString *appScheme = @"MaiCaiAlipay";
    
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    
    order.tradeNO = self.pay_no; //订单ID（由商家自行制定）
    order.productName = [[NSString alloc]initWithFormat:@"总共需要花费%.2f元",self.order.total]; //商品标题
    order.productDescription = @"商品描述"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",self.order.total]; //商品价格
    order.notifyURL =  [@"http://star-faith.com:8083/maicai/api/ios/v1/public/alipay/notify.do" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //回调URL
    NSString* signedStr = [self doRsa:[order description]];
    
    MCLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             [order description], signedStr, @"RSA"];
    
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
    
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}


//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"];//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                if(self.showMsg){
                    self.showMsg(@"交易成功");
                    self.showMsg = nil;
                }
                [self backBtnAction];
               
			}
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if ([[MCTradeManager getInstance]cancelPaymentByPaymentNo:self.pay_no]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if(self.showMsg){
                            self.showMsg(@"交易失败");
                            self.showMsg = nil;
                        }
                        [self backBtnAction];
                        
                    });
                }else{
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if(self.showMsg){
                            self.showMsg(MC_ERROR_MSG_0001);
                            self.showMsg = nil;
                        }
                    });
                }
            });
        }
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([[MCTradeManager getInstance]cancelPaymentByPaymentNo:self.pay_no]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if(self.showMsg){
                        self.showMsg(@"交易失败");
                        self.showMsg = nil;
                    }
                    [self backBtnAction];
                });
            }else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if(self.showMsg){
                        self.showMsg(MC_ERROR_MSG_0001);
                        self.showMsg = nil;
                    }
                });
            }
        });
    }
}


@end


//
//  MCAgreementViewController.m
//  MaiCai
//
//  Created by Peng Jack on 14-2-27.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCAgreementViewController.h"
#import "DTCoreText.h"
@interface MCAgreementViewController ()

@end

@implementation MCAgreementViewController

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
    
    NSString *html = @"<p><center><h3 style='color: red'>使用前必读</h3></center><p><b>本系统提醒您：</b><br>在使用本系统的所有功能之前，请您务必仔细阅读并透彻理解本声明。您可以选择不使用本系统，但如果您使用本系统，您的使用行为将被视为对本声明全部内容的认可。</p><p><b>免责声明:</b><br>鉴于本系统使用非人工检索/解析方式，无法确定您输入的条件进行是否合法，所以本系统对检索/解析出的结果不承担责任。如果因以本系统的检索/解析结果作为任何商业行为或者学术研究的依据而产生不良后果，本系统不承担任何法律责任。</p><p><b>关于隐私权：</b><br>访问者在本系统注册时提供的一些个人资料、地理位置定位功能使用，本系统除您本人同意外不会将用户的任何资料以任何方式泄露给第三方。当政府部门、司法机关等依照法定程序要求本系统披露个人资料时，本系统将根据执法单位之要求或为公共安全之目的提供个人资料，在此情况下的披露，本系统不承担任何责任。</p><p><b>关于版权：</b><br>一、凡本系统注明“国家知识产权局”、“专利检索与服务系统”的所有作品，其版权属于国家知识产权局所有。其他媒体、网站或个人转载使用时不得进行商业性的原版原式的转载，也不得歪曲和篡改本系统所发布的内容。<br>二、凡本系统转载其它媒体作品的目的在于传递更多信息，并不代表本系统赞同其观点和对其真实性负责；其他媒体、网站或个人转载使用时必须保留本站注明的文章来源，并自负法律责任。<br>三、被本系统授权使用的单位，不应超越授权范围。<br>四、本系统提供的资料如与相关纸质文本不符，以纸质文本为准。<br>五、如因作品内容、版权和其它问题需要同本系统联系的，请在本系统发布该作品后的30日内进行。<p><b>关于解释权：</b><br>本系统之声明以及其修改权、更新权及最终解释权均属上海卓领通讯技术有限公司以及国家知识产权局所有。</p></p>";
    
    
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:NULL];
    
    self.textView.attributedString = attrString;
    self.textView.backgroundColor = [UIColor whiteColor];
    //self.textView.editable = false;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)agreeAction:(id)sender {
    [self backBtnAction];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (self.agreeComplete) {
            self.agreeComplete();
            self.agreeComplete = nil;
        }
    });
}
@end

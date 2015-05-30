//
//  ViewController.m
//  BRQRCode
//
//  Created by gitBurning on 15/5/29.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "ViewController.h"
#import "UserCode.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)QR:(UIButton *)sender {
    
    [[UserCode shareCode] popCodeViewBlcok:^(id info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.qrEnd.text=[NSString stringWithFormat:@"获取到的数据:%@",info];
        });
        NSLog(@"获取到的数据:%@",info);
    } andInVC:self];
}
@end

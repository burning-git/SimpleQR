//
//  ViewController.h
//  BRQRCode
//
//  Created by gitBurning on 15/5/29.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)QR:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *qrEnd;
@end


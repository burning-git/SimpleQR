//
//  sysytemCodeVC.h
//  myCode
//
//  Created by gitBurning on 14-8-8.
//  Copyright (c) 2014年 gitBurning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol getCodeInfoDelegate <NSObject>

-(void)getCodeInfoWith:(id)infoMation;

@end


@interface SysytemCodeVC : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}


@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@property(assign,nonatomic) id<getCodeInfoDelegate>infoDelegate;



@end

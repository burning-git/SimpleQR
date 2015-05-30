//
//  userCode.m
//  myCode
//
//  Created by gitBurning on 14-8-8.
//  Copyright (c) 2014年 gitBurning. All rights reserved.
//

#import "UserCode.h"
#define QRWINDOW_WIDTH [[UIScreen mainScreen] bounds].size.width
#define QRWINDOW_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7

@interface UserCode ()

@property(copy,nonatomic) getCodeInfo myGetCodeInfo;

@end

@implementation UserCode
+(UserCode *)shareCode{
    static UserCode *mamanger=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mamanger=[[UserCode alloc] init];
        
    });
    return mamanger;
}

-(void)popCodeViewBlcok:(getCodeInfo)blcok andInVC:(id)vc
{
    
    currentViewController=vc;
    
    if (blcok) {
        
        self.myGetCodeInfo=blcok;
    }
    if (IOS7) {
        SysytemCodeVC *next=[[SysytemCodeVC alloc] init];
        next.infoDelegate=self;
        
       [currentViewController presentViewController:next animated:YES completion:nil];
        //[[currentViewController navigationController] pushViewController:next animated:YES];
        
    }
    else{
        [self setupCameraWithIos6WithQRSize:CGSizeMake(280, 280)];
    }
    
    
    
    
}
-(void)getCodeInfoWith:(id)infoMation{
    self.myGetCodeInfo(infoMation);

}




//read code
#pragma mark---ios 6

-(void)setupCameraWithIos6WithQRSize:(CGSize)size{
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.tracksSymbols=NO;
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    
    
    float height=QRWINDOW_HEIGHT-64;
    
    float top_y=85.0;
    
    
    float QR_x=25.0;
    
    float QR_x_Offset=5;
    
    float leftViewHeight=height-top_y;
    
    
    /**
     *  计算感应区
     */
    reader.scanCrop = CGRectMake(QR_x/QRWINDOW_WIDTH, top_y/QRWINDOW_HEIGHT, 1-2*(QR_x/QRWINDOW_WIDTH), size.height/height);//扫描的感应框   需要 设置 增加 识别率

    
    NSLog(@"感应区--%@",    NSStringFromCGRect(reader.scanCrop));
    
    UIColor * overColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
//
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QRWINDOW_HEIGHT, height)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    
    /**
     topView
     
     :returns: <#return value description#>
     */
    UIView * topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), top_y)];
    [view addSubview:topView];
    topView.backgroundColor=overColor;
    
    
    /**
     leftView
     
     :returns: <#return value description#>
     */
    UIView * leftView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(topView.frame), QR_x, leftViewHeight)];
    [view addSubview:leftView];
    leftView.backgroundColor=overColor;
    
    
    /**
     rightView
     
     :returns: <#return value description#>
     */
    
    UIView * rightView=[[UIView alloc] initWithFrame:CGRectMake(QRWINDOW_WIDTH-QR_x, CGRectGetHeight(topView.frame), QR_x, leftViewHeight)];
    [view addSubview:rightView];
    rightView.backgroundColor=overColor;
    
    /**
     downView
     
     :returns: <#return value description#>
     */
    
    UIView * downView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(leftView.frame), CGRectGetHeight(topView.frame)+size.height, size.width-2*QR_x_Offset, height-size.height-CGRectGetHeight(topView.frame))];
    [view addSubview:downView];
    downView.backgroundColor=overColor;

    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, size.height, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor blackColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(QR_x-QR_x_Offset, top_y-QR_x_Offset, size.width, size.height);
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, size.height-60, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    
    
    /**
     *  增加其他的透明灰色块
     *
     *  @param animation1 <#animation1 description#>
     *
     *  @return <#return value description#>
     */
    
    
   
    
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    //[self pres];
    
 //   UIViewController *next=myDelegate;
    [currentViewController presentViewController:reader animated:YES completion:nil];
    
   
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    
    id<NSFastEnumeration> results =
    
    [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    
    for(symbol in results) {
        
        // EXAMPLE: just grab the first barcode
        
        break;
        
    }
    
    //symbol.data;
    
    //处理部分中文乱码问题
    
    NSString * endString=symbol.data;
    if ([endString canBeConvertedToEncoding:NSShiftJISStringEncoding])
        
    {
        
        endString = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        
    }
    
    self.myGetCodeInfo(endString);

    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//write code

-(UIImage *)getImageWith:(id)info withSize:(CGSize)imageSize{
    UIImage *image=nil;
    if ([info isKindOfClass:[NSString class]]) {
        image= [QRCodeGenerator qrImageForString:info imageSize:imageSize.width];

    }
    
//    UIImageView *imageLogo=[[UIImageView alloc] initWithFrame:CGRectMake(imageview.frame.size.width/2.0 -10, imageview.frame.size.height/2.0 -10, 20, 20)];
//    imageLogo.image=[UIImage imageNamed:@"icon-58"];
//    [imageview addSubview:imageLogo];
    return image;
}
-(void)getImageWith:(id)info withSize:(CGSize)imageSize withLogoImage:(UIImage *)logImage andLogSize:(CGSize)logoSize andImageView:(UIImageView *)imageView{
    UIImage *image=nil;

    if ([info isKindOfClass:[NSString class]]) {
        image= [QRCodeGenerator qrImageForString:info imageSize:imageSize.width];
        imageView.image=image;
    }
  //  imageView.image=image;
    
  //  if (image) {
    UIImageView *imageLogo=[[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.size.width/2.0 -10, imageView.frame.size.height/2.0 -10, 20, 20)];
    imageLogo.image=logImage?logImage:[UIImage imageNamed:@"icon-58"];
    
    
    [imageView addSubview:imageLogo];
 //   }
   
   
    
    
}
@end

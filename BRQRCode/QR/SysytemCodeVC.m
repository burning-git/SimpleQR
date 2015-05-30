//
//  sysytemCodeVC.m
//  myCode
//
//  Created by gitBurning on 14-8-8.
//  Copyright (c) 2014年 gitBurning. All rights reserved.
//

#import "SysytemCodeVC.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"
@interface SysytemCodeVC ()<ZBarReaderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    float navHeight;
}
@end

@implementation SysytemCodeVC

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

    
    navHeight=64;
    
    self.view.backgroundColor = [UIColor grayColor];
	UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(100, 420+navHeight, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addSubview:scanButton];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40 + navHeight, 290, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100+navHeight, 300, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110+navHeight, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    
    UIBarButtonItem *photo=[[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStyleBordered target:self action:@selector(userLibrayPhoto)];
    self.navigationItem.rightBarButtonItem=photo;
    
}
-(void)userLibrayPhoto{
    
    [self stopCodeAndTime];

    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.sourceType = sourceType;
    // picker.cameraOverlayView.layer.cornerRadius=10;
    //   picker.showsCameraControls=NO;
    [self presentViewController:picker animated:YES completion:^{
        
    }];//进入照相界面

}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 110+2*num +navHeight, 220, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 110+2*num + navHeight, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self setupCamera];

}

-(void)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(20,110 +navHeight,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    
    // Start
    [self performSelector:@selector(delayStart) withObject:nil afterDelay:0.1];
    
}
-(void)delayStart{
    [_session startRunning];

}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [self stopCodeAndTime];
//    [self dismissViewControllerAnimated:YES completion:^
//     {
         NSLog(@"%@",stringValue);
         [self.infoDelegate getCodeInfoWith:stringValue];
   //  }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    [timer invalidate];
    //    _line.frame = CGRectMake(30, 10, 220, 2);
    //    num = 0;
    //    upOrdown = NO;
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    [picker dismissViewControllerAnimated:YES completion:^{
//        [picker removeFromParentViewController];
    
        //  image=[UIImage imageNamed:@"111.png"];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        ZBarImageScanner * scanner = read.scanner;
        [scanner setSymbology:ZBAR_I25
                       config:ZBAR_CFG_ENABLE
                           to:0];
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        
        // self.myGetCodeInfo(result);
        NSLog(@"%@",result);
        [self.infoDelegate getCodeInfoWith:result];

       // [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        
  //  }];
}

-(void)stopCodeAndTime{
    [_session stopRunning];
    [timer invalidate];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

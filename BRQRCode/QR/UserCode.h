//
//  userCode.h
//  myCode
//
//  Created by gitBurning on 14-8-8.
//  Copyright (c) 2014年 gitBurning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ZBarSDK.h"
#import "QRCodeGenerator.h"
#import "SysytemCodeVC.h"

@class ZBarReaderController;
typedef void(^getCodeInfo)(id info);
@interface UserCode : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate,getCodeInfoDelegate>
{
    id currentViewController;
    int num;
    BOOL upOrdown;
    NSTimer * timer;

    
}
@property (nonatomic, strong) UIImageView * line;

+(UserCode*)shareCode;


#pragma mark--扫码
/*
   //显示扫码UI
*/

-(void)popCodeViewBlcok:(getCodeInfo)blcok andInVC:(id)vc;

// write code
//get codeImage

/*
   //制作二维码的图片
   *@prama info  二维码的值
   *@prame imageSize 图片大小
*/


#pragma mark---制作二维码
-(UIImage*)getImageWith:(id)info withSize:(CGSize)imageSize;

//getCodeAndLogo
/*
 //制作二维码的图片 加中间小logo
   *@prama info  二维码的值
   *@prame imageSize 图片大小
   *@prama logImage  logo 图片
   *@prame logoSize   logo大小
   *@prame imageView   所显示的 UIImageView  //logo 实际上是add 的。二维码 有自动纠错 功能。因此logo图片不能设置太大
 */


-(void)getImageWith:(id)info withSize:(CGSize)imageSize withLogoImage:(UIImage*)logImage andLogSize:(CGSize)logoSize andImageView:(UIImageView*)imageView;

@end

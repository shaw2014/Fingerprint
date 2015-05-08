//
//  FingerPrintVerify.m
//  demo
//
//  Created by shaw on 15/5/8.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import "FingerPrintVerify.h"
#import "TouchInstance.h"
#import "InputPasswordView.h"

#define kFingerprintLockKey @"IsOpenFingerprintLock"

@implementation FingerPrintVerify

//指纹验证
-(void)verifyFingerprint
{
    TouchInstance *instance = [TouchInstance instance];
    if([instance canEvaluatePolicy])
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        BOOL isOpen = [[user objectForKey:kFingerprintLockKey] boolValue];
        
        //开启或关闭指纹解锁
        [instance evaluatePolicyWithStatus:isOpen localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __block BOOL result = isOpen;
                
                if(isOpen)
                {//关闭
                    if(success)
                    {
                        result = NO;
                    }
                    else
                    {
                        if(error.code == LAErrorUserFallback)
                        {//用户点击输入密码
                            //跳转到输入钱一百登陆密码
                            
                            InputPasswordView *input = [[InputPasswordView alloc]init];
                            [input showWithCompletion:^(NSString *inputPwd) {
                                
                                //密码检验
                                if(inputPwd && [inputPwd isEqualToString:@""])
                                {//点击确认并且密码正确
                                    result = NO;
                                }
                                else
                                {//再次弹出指纹验证
                                    [[TouchInstance instance] evaluatePolicyWithStatus:NO localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError *error) {
                                        if(success)
                                        {
                                            result = NO;
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
//                                                [self changeStatus:result];
                                                //TODO
                                            });
                                        }
                                    }];
                                }
                            }];
                        }
                    }
                }
                else
                {//开启
                    if(success)
                    {
                        result = YES;
                    }
                }
                
//                [self changeStatus:result];
                //TODO
            });
        }];
    }
}

@end

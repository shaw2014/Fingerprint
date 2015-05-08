//
//  TouchInstance.h
//  Qian100
//
//  Created by zhaoxiao on 15/1/27.
//  Copyright (c) 2015年 ZOSENDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LAError.h>

@interface TouchInstance : NSObject

+(TouchInstance *)instance;

-(BOOL)canEvaluatePolicy;

/**
 *  验证指纹密码
 *
 *  @param status 是否有输入密码按钮
 *  @param reason 文本描述
 *  @param reply  验证后的回调方法
 */
-(void)evaluatePolicyWithStatus:(BOOL)status localizedReason:(NSString *)reason reply:(void(^)(BOOL success, NSError *error))reply;

@end

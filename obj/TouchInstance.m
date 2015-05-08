//
//  TouchInstance.m
//  Qian100
//
//  Created by zhaoxiao on 15/1/27.
//  Copyright (c) 2015年 ZOSENDA. All rights reserved.
//

#import "TouchInstance.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface TouchInstance ()

@property (nonatomic,strong) LAContext *context;

@end

@implementation TouchInstance

+(TouchInstance *)instance
{
    return [[TouchInstance alloc]init];
}

-(LAContext *)context
{
    if(!_context)
    {
        _context = [[LAContext alloc]init];
    }
    
    return _context;
}

-(BOOL)canEvaluatePolicy
{
    NSError *error = nil;
    return [self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
}

-(void)evaluatePolicyWithStatus:(BOOL)status localizedReason:(NSString *)reason reply:(void (^)(BOOL, NSError *))reply
{
    if([self canEvaluatePolicy])
    {
        if(status)
        {
            _context.localizedFallbackTitle = nil;
        }
        else
        {
            _context.localizedFallbackTitle = @"";
        }
        [_context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reason reply:reply];
    }
}

@end

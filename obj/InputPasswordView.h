//
//  InputPasswordView.h
//  Qian100
//
//  Created by shaw on 15/4/14.
//  Copyright (c) 2015年 ZOSENDA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputPasswordView : UIView

-(void)showWithCompletion:(void (^)(NSString *inputPwd))completeBlock;

@end

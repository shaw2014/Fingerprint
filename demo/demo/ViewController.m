//
//  ViewController.m
//  demo
//
//  Created by shaw on 15/5/8.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import "ViewController.h"

#import "FingerPrintVerify.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FingerPrintVerify *verify = [[FingerPrintVerify alloc] init];
    [verify verifyFingerprint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

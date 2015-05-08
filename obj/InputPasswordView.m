//
//  InputPasswordView.m
//  Qian100
//
//  Created by shaw on 15/4/14.
//  Copyright (c) 2015年 ZOSENDA. All rights reserved.
//-------------------指纹验证输入密码弹框-----------------------

#import "InputPasswordView.h"
#import "UIImage+ImageWithColor.h"

#define kDefaultKayboardHeight 216.0f

@interface InputPasswordView ()
{
    CGFloat keyboardHeight;
}

@property (nonatomic,strong) UIView *dialogView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *passwordField;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *okBtn;

@property (nonatomic,strong) NSLayoutConstraint *dialogHeightConstraint;

@property (nonatomic,copy) void(^clickHandle)(NSString *input);

@end

@implementation InputPasswordView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        
        [self setup];
        
        keyboardHeight = kDefaultKayboardHeight;
        [self addNotification];
    }
    
    return self;
}

-(void)dealloc
{
    [self removeNotification];
}

-(void)setup
{
    if(!_dialogView)
    {
        _dialogView = [[UIView alloc]init];
        _dialogView.translatesAutoresizingMaskIntoConstraints = NO;
        _dialogView.layer.masksToBounds = YES;
        _dialogView.layer.cornerRadius = 5.0f;
        _dialogView.backgroundColor = UIColorFromRGB(0xEFEFF4);
        [self addSubview:_dialogView];
    }
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"请输入登录密码";
    [_dialogView addSubview:_titleLabel];
    
    UIView *line = [[UIView alloc]init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = UIColorFromRGB(0x9f9f9f);
    [_dialogView addSubview:line];
    
    UIView *inputView = [[UIView alloc]init];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.layer.masksToBounds = YES;
    inputView.layer.cornerRadius = 4.0f;
    inputView.layer.borderWidth = 0.5f;
    inputView.layer.borderColor = UIColorFromRGB(0xb7b7b7).CGColor;
    [_dialogView addSubview:inputView];
    
    UILabel *label = [[UILabel alloc]init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"登录密码";
    [inputView addSubview:label];
    
    _passwordField = [[UITextField alloc]init];
    _passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    _passwordField.secureTextEntry = YES;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [inputView addSubview:_passwordField];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.cornerRadius = 4.0f;
    _cancelBtn.layer.borderWidth = 0.5f;
    _cancelBtn.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:UIColorFromRGB(0x6c6c6c) forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:UIColorFromRGB(0xfbfbfb)];
    [_cancelBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dialogView addSubview:_cancelBtn];
    
    self.okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _okBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _okBtn.layer.masksToBounds = YES;
    _okBtn.layer.cornerRadius = 4.0f;
    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okBtn setTitleColor:UIColorFromRGB(0xdadadc) forState:UIControlStateDisabled];
    [_okBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x3ea3fe)] forState:UIControlStateNormal];
    [_okBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xecebf1)] forState:UIControlStateDisabled];
    [_okBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dialogView addSubview:_okBtn];
    [_okBtn setEnabled:NO];
    
    //-----------添加约束--------------
    //横向约束
    NSDictionary *bindDic =  @{@"dialog":_dialogView, @"title":_titleLabel, @"line":line, @"input":inputView, @"label":label, @"field":_passwordField, @"cancel":_cancelBtn, @"ok":_okBtn};
    CGFloat dialogWidth = 260.0f;
    NSDictionary *paramDic = @{@"dialogWidth":@(dialogWidth), @"titleHeight":@(45.0f), @"lineHeight":@(1.0f), @"inputHeight":@(45.0f), @"line_input_margin_V":@(13.0f), @"input_btn_margin_V":@(10.0f), @"btn_view_margin_V":@(12.0f), @"marginLeftRight":@(12.0f), @"btnMargin":@(10.0f), @"btnWidth":@(110.0f), @"btnHeight":@(43.0f), @"labelWidth":@(80.0f), @"input_margin_H":@(5.0f)};
    
    NSLayoutConstraint *dialog_W = [NSLayoutConstraint constraintWithItem:_dialogView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:dialogWidth];
    NSLayoutConstraint *dialog_CX = [NSLayoutConstraint constraintWithItem:_dialogView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *dialog_CY = [NSLayoutConstraint constraintWithItem:_dialogView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *dialog_H = [NSLayoutConstraint constraintWithItem:_dialogView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:dialogWidth];
    self.dialogHeightConstraint = dialog_H;
    [self addConstraint:dialog_W];
    [self addConstraint:_dialogHeightConstraint];
    [self addConstraint:dialog_CX];
    [self addConstraint:dialog_CY];
    
    NSArray *title_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[title]|" options:0 metrics:paramDic views:bindDic];
    [_dialogView addConstraints:title_H];
    
    NSArray *line_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[line]|" options:0 metrics:paramDic views:bindDic];
    [_dialogView addConstraints:line_H];
    
    NSArray *input_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginLeftRight-[input]-marginLeftRight-|" options:0 metrics:paramDic views:bindDic];
    [_dialogView addConstraints:input_H];
    
    NSArray *inputContent_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-input_margin_H-[label(labelWidth)]-input_margin_H-[field]-input_margin_H-|" options:0 metrics:paramDic views:bindDic];
    [inputView addConstraints:inputContent_H];
    
    NSArray *btns_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[cancel]-btnMargin-[ok]-btnMargin-|" options:NSLayoutFormatAlignAllTop metrics:paramDic views:bindDic];
    NSLayoutConstraint *btns_EW = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_okBtn attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    NSLayoutConstraint *btns_EH = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_okBtn attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [_dialogView addConstraints:btns_H];
    [_dialogView addConstraint:btns_EW];
    [_dialogView addConstraint:btns_EH];
    
    //纵向约束
    NSArray *subview_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title(titleHeight)]-[line(lineHeight)]-line_input_margin_V-[input(inputHeight)]-input_btn_margin_V-[cancel(btnHeight)]-input_btn_margin_V-|" options:0 metrics:paramDic views:bindDic];
    [_dialogView addConstraints:subview_V];
    
    NSArray *label_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:paramDic views:bindDic];
    NSArray *field_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[field]|" options:0 metrics:paramDic views:bindDic];
    [inputView addConstraints:label_V];
    [inputView addConstraints:field_V];
    
    CGSize size = [_dialogView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    _dialogHeightConstraint.constant = size.height;
}

-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notificaiton
{
    CGRect keyboardFrame = [[notificaiton.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyboardHeight = keyboardFrame.size.height;

    [self resetAlertFrame];
}

-(void)keyboardWillHide:(NSNotification *)notificaiton
{
    keyboardHeight = 0;
    [self resetAlertFrame];
}

//改变alert的位置，防止阻挡键盘
-(void)resetAlertFrame
{
    CGFloat bottom = [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(_dialogView.frame);
    if(bottom < keyboardHeight)
    {
        CGFloat moveY = keyboardHeight - bottom;
        
        CGRect alertFrame = _dialogView.frame;
        alertFrame.origin.y -= moveY;
        
        [UIView animateWithDuration:0.3f animations:^{
            _dialogView.frame = alertFrame;
        }];
    }
    else
    {
        CGRect alertFrame = _dialogView.frame;
        alertFrame.origin.y = ([UIScreen mainScreen].bounds.size.height - alertFrame.size.height) / 2.0f;
        
        [UIView animateWithDuration:0.3f animations:^{
            _dialogView.frame = alertFrame;
        }];
    }
}

-(void)textDidChanged:(NSNotification *)notification
{
    if(_passwordField.text.length > 0)
    {
        [_okBtn setEnabled:YES];
    }
    else
    {
        [_okBtn setEnabled:NO];
    }
}

-(void)buttonAction:(UIButton *)sender
{
    if(_clickHandle)
    {
        NSString *inputStr = nil;
        if(sender == _okBtn)
        {
            inputStr = _passwordField.text;
        }
        
        _clickHandle(inputStr);
    }
    
    [self dismiss];
}

-(void)showWithCompletion:(void (^)(NSString *))completeBlock
{
    self.clickHandle = completeBlock;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *self_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(self)];
    NSArray *self_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(self)];
    [keyWindow addConstraints:self_H];
    [keyWindow addConstraints:self_V];
    
    _dialogView.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        _dialogView.alpha = 1.0;
    }completion:^(BOOL finished) {
        [_passwordField becomeFirstResponder];
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        _dialogView.alpha = 0;
    }completion:^(BOOL finished) {
        if(finished)
        {
            [self removeFromSuperview];
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

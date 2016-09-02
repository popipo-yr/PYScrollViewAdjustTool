//
//  ViewController.m
//  PYScrollViewAdjustTool
//
//  Created by PY on 16/4/19.
//  Copyright © 2016年 PY. All rights reserved.
//

#import "ViewController.h"
#import "PYScrollViewAdjustTool.h"
#import "ScrollViewViewController.h"

@interface ViewController ()<UITextFieldDelegate>{
    IBOutlet UIScrollView *_scrollView;
}

@property (nonatomic, assign)  BOOL hasInputView;
@property (nonatomic, assign)  BOOL hasAccessoryView;


@end

@implementation ViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray        *params  = (NSArray *)sender;
    ViewController *receive = segue.destinationViewController;

    receive.hasInputView     = [params.firstObject boolValue];
    receive.hasAccessoryView = [params.lastObject boolValue];
}


- (IBAction)clikcOne:(id)sender
{
    [self performSegueWithIdentifier:@"ABCD" sender:@[@(0), @(0)]];
}


- (IBAction)clikcTwo:(id)sender
{
    [self performSegueWithIdentifier:@"ABCD2" sender:@[@(1), @(0)]];
}


- (IBAction)clikcThree:(id)sender
{
    [self performSegueWithIdentifier:@"ABCD3" sender:@[@(1), @(1)]];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect frame = self.view.frame;
    
    if (_hasInputView) {
        frame.size.height = 260;
        
        UILabel *inputView = [[UILabel alloc] initWithFrame:frame];
        inputView.backgroundColor = [UIColor redColor];
        inputView.text            = @"this's inputView";
        inputView.textAlignment   = NSTextAlignmentCenter;
        textField.inputView = inputView;
    }

    if (_hasAccessoryView) {
        frame.size.height = 40;
        
        UILabel *accessoryView = [[UILabel alloc] initWithFrame:frame];
        accessoryView.backgroundColor = [UIColor yellowColor];
        accessoryView.text            = @"this's accessoryView";
        accessoryView.textAlignment   = NSTextAlignmentCenter;
        textField.inputAccessoryView = accessoryView;
    }

    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [PYScrollViewAdjustTool adjustViewToKeyboardTop:textField atScrollView:_scrollView];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [PYScrollViewAdjustTool restoreView:textField];
    return YES;
}


@end
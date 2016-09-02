//
//  ScrollViewViewController.m
//  PYScrollViewAdjustTool
//
//  Created by PY on 16/4/22.
//  Copyright © 2016年 PY. All rights reserved.
//

#import "ScrollViewViewController.h"

@interface ScrollViewViewController ()
{
    
    UIScrollView* _scrollView;

}

@end

@implementation ScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = YES;
}


-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    
    UIEdgeInsets edge          = _scrollView.contentInset;
    CGFloat      contentHeight = _scrollView.contentSize.height;
    CGFloat      needHeight    = contentHeight + edge.top + edge.bottom;
    CGFloat      extendHeight  = needHeight - CGRectGetHeight(_scrollView.bounds);
    
    CGFloat maxiumOffsetHeight222 = -edge.top + extendHeight;
    
        CGFloat      maxiumOffsetHeight = _scrollView.contentSize.height - _scrollView.frame.size.height + _scrollView.contentInset.top + _scrollView.contentInset.bottom;
    
    
    NSLog(@"off ... %@", @(_scrollView.contentOffset.y));
   
    NSLog(@"maxOffset2222 ... %@", @(maxiumOffsetHeight222));
    NSLog(@"maxOffset ... %@", @(maxiumOffsetHeight));
    NSLog(@"top... %@", @(_scrollView.contentInset.top));
    
    

}


- (void)setupViews{

    UIScrollView* view = [UIScrollView new];
    
    [self.view addSubview:view];
    
    view.frame = self.view.bounds;
    
    
    
    UIView* bView = [UIView new];
    bView.backgroundColor = [UIColor redColor];
    
    [view addSubview:bView];
    
//    bView.frame = view.bounds;
    
    CGRect SSS = view.bounds;
    SSS.size.height -= (264 + 30);
    bView.frame = SSS;
    
    
    
    view.contentSize = bView.bounds.size;
    view.contentInset = UIEdgeInsetsMake(100, 0, 100, 0);
    
   
    _scrollView = view;
    
}


@end

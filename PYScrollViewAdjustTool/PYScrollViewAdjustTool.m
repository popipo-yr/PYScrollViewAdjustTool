//
//  PYScrollViewAdjustTool.m
//  yr
//
//  Created by yr on 15/9/14.
//  Copyright (c) 2015年 yr. All rights reserved.
//

#import "PYScrollViewAdjustTool.h"

//视图底部到键盘顶部或滚动视图顶部的最小间距
#define _C_PointToKeyBoardTopLessInterval 5.0f

@implementation PYScrollViewAdjustTool {
    /////
    UIView       *_changeAboutView; //当前调整的视图
    UIScrollView *_changeScrollView;//当前调整的视图所在的滑动视图

    CGFloat _keyboardHeight;  //键盘的高度
}

//全局只有这个单例
+ (PYScrollViewAdjustTool *)instance
{
    static PYScrollViewAdjustTool *adjustScrollView;

    static dispatch_once_t onlyOne;
    dispatch_once(&onlyOne, ^{
        adjustScrollView = [PYScrollViewAdjustTool new];
    });

    return adjustScrollView;
}


- (instancetype)init
{
    if (self = [super init]) {
        //增加监听-键盘退出
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        //增加监听-键盘改变
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardFrameChange:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }

    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//当键盘出现或改变时调用
- (void)keyboardFrameChange:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo    = [aNotification userInfo];
    NSValue      *aValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect       keyboardRect = [aValue CGRectValue];
    CGFloat      height       = keyboardRect.size.height;
    CGFloat      oldHeight    = _keyboardHeight;

    _keyboardHeight = height;
    
    if (0 == _keyboardHeight || oldHeight == _keyboardHeight) return;
    if (nil == _changeAboutView || nil == _changeScrollView) return;
    //有inputAccessoryView的时候,键盘隐藏的时候键盘的高度为inputAccessoryView的高度
    if (0 == _keyboardHeight - CGRectGetHeight(_changeScrollView.inputAccessoryView.bounds)) return;
    
    [self realChangeMe:_changeAboutView];
}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    _keyboardHeight = 0;
}


- (void)realChangeMe:(UIView *)view
{
    CGSize  textFieldSize   = view.bounds.size;
    CGPoint textFieldTop    = CGPointZero;
    CGPoint textFieldBottom = CGPointMake(textFieldSize.width,
                                          textFieldSize.height);
    
    CGPoint pointInWindow = [view convertPoint:textFieldBottom toView:_changeScrollView.window];
    pointInWindow.y += _C_PointToKeyBoardTopLessInterval;
    
    CGPoint pointInScrollView = [view convertPoint:textFieldTop toView:_changeScrollView];
    
    
    CGFloat keyboardHeight = _keyboardHeight;
    CGFloat windowHeight   = CGRectGetHeight(_changeScrollView.window.bounds);


    CGPoint currentOffset  = _changeScrollView.contentOffset;
    CGFloat initialOffsetY = -_changeScrollView.contentInset.top;
    CGPoint needOffset     = currentOffset;

    BOOL isNeedMove = false;

    CGFloat topPointYOfScrollView =  currentOffset.y - initialOffsetY;
    CGFloat intervalOfPointToScrollViewTop = pointInScrollView.y - topPointYOfScrollView;
    ///保证条件:保证输入位置显示在滑动视图显示区域或者显示区域下方
    if (intervalOfPointToScrollViewTop  < 0) {
        needOffset.y -= (-intervalOfPointToScrollViewTop);
        ///改变offset 改变前面计算在window的位置也要相应的改变
        pointInWindow.y += (-intervalOfPointToScrollViewTop);
        isNeedMove = true;
    }

    //点距离键盘顶部的距离
    CGFloat intervalOfPointToKeyboardTop = pointInWindow.y - (windowHeight - keyboardHeight);
    //键盘比较,如果视图在键盘下侧移动到键盘上侧
    if (intervalOfPointToKeyboardTop > 0) {
        needOffset.y += intervalOfPointToKeyboardTop;
        isNeedMove  = true;
    }

    if (isNeedMove) {
        [_changeScrollView setContentOffset:needOffset animated:true];
    }
}


- (void)adjustScrollViewToBottomIfNeed
{
    UIEdgeInsets svEdge        = _changeScrollView.contentInset;
    CGFloat      contentHeight = _changeScrollView.contentSize.height;
    //需要的展示高度
    CGFloat      needHeight    = contentHeight + svEdge.top + svEdge.bottom;
    //需要的滑动的高度
    CGFloat      extendHeight  = needHeight - CGRectGetHeight(_changeScrollView.bounds);

    CGFloat      maxiumOffset  = -svEdge.top + extendHeight;
    
    if (extendHeight < 0) {
        //不能进行滑动,修改最大offset为初始状态的offset
        maxiumOffset = -svEdge.top;
    }

    if (_changeScrollView.contentOffset.y > maxiumOffset) {
        [_changeScrollView setContentOffset:CGPointMake(0, maxiumOffset) animated:true];
    }
}


- (void)adjustViewToKeyboardTop:(UIView*)view atScrollView:(UIScrollView*)sv
{
    if (_changeScrollView != sv && nil != view) { // 换了滑动视图需要恢复前一个滑动视图的状态
        [self adjustScrollViewToBottomIfNeed];
    }

    _changeScrollView = sv;
    _changeAboutView  = view;
}


- (void)restoreView:(UIView*)view
{
    //键盘关闭时,如果视图与编辑开始时记录的视图不一致,不需要调整.
    //因为执行新的视图调整时已经进行了滑动视图调整
    if (_changeAboutView != view) return;

    [self adjustScrollViewToBottomIfNeed];

    _changeAboutView  = nil;
    _changeScrollView = nil;
}


/*键盘弹起时,移动指定视图到键盘上方*/
+ (void)adjustViewToKeyboardTop:(UIView*)view atScrollView:(UIScrollView*)sv
{
    [[PYScrollViewAdjustTool instance] adjustViewToKeyboardTop:view atScrollView:sv];
}


/*重置指定视图的位置,一般在键盘关闭的时候调用*/
+ (void)restoreView:(UIView*)view
{
    [[PYScrollViewAdjustTool instance] restoreView:view];
}


@end

//
//  ContainerVC.m
//  navi-custom
//
//  Created by jhtxch on 16/10/9.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import "ContainerVC.h"
#import "PagePushTransition.h"

@interface ContainerVC ()<UINavigationControllerDelegate>
{
    NSInteger _lastNum;
    NSInteger _selectNum;
    UIPercentDrivenInteractiveTransition *_percentDriven;
    BOOL _isEnablePan;
}

@end

@implementation ContainerVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationBar.hidden = YES;
        
        //重写navi动画
        self.delegate = self;
        _isEnablePan = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addEdgePanGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIViewController *vc = [self.dataSource viewControllerInRow:0];
    [self setViewControllers:[NSArray arrayWithObject:vc] animated:NO];
    
    if ([self.dataDelegate respondsToSelector:@selector(rectOfPageView)]) {
        self.view.frame = [self.dataDelegate rectOfPageView];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)reladData
{
    [self reladDataWithAnimation:NO];
}
- (void)reladDataWithAnimation:(BOOL)animated
{
    _lastNum = _selectNum;
    _selectNum = 0;
    UIViewController *vc = [self.dataSource viewControllerInRow:0];
    [self setViewControllers:[NSArray arrayWithObject:vc] animated:animated];
}

#pragma mark - gesture

- (void)addEdgePanGesture
{
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }

    //手势百分比驱动
//    UIPanGestureRecognizer *upGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(upGesAction:)];
//    [self.view addGestureRecognizer:upGesture];
    
    
    
    UISwipeGestureRecognizer *upSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upAction:)];
    upSwip.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:upSwip];
    
    UISwipeGestureRecognizer *downSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downAction:)];
    downSwip.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downSwip];
}

- (void)upAction:(UIGestureRecognizer *)sender
{
    [self pushNextWithAnimation:YES];
}

- (void)downAction:(UIGestureRecognizer *)sender
{
    [self popNextWithAnimation:YES];
    
    
}



/**
 *  手势百分比驱动 失败 (原因 transitionWithView方法 在手势结束之后不会产生后续的动画 
                    如果使用animateWithDuration方法 在手势结束之后依旧会有后续的动画)
 *
 *  @param sender 手势
 */
- (void)upGesAction:(UIPanGestureRecognizer *)sender
{
    CGFloat progress = 0;
    if (_isEnablePan) {
        progress = fabs([sender translationInView:self.view].y) / self.view.bounds.size.height;
        NSLog(@"%lf",progress);
        if (sender.state == UIGestureRecognizerStateBegan) {
            NSLog(@"===%lf===",[sender locationInView:self.view].y);
            
            //push
            if (self.view.bounds.size.height - [sender locationInView:self.view].y < 40) {
                _percentDriven = [[UIPercentDrivenInteractiveTransition alloc] init];
                _percentDriven.completionSpeed = 10;
                _percentDriven.completionCurve = UIViewAnimationCurveEaseIn;
                [self pushNextWithAnimation:YES];
            }else if ([sender locationInView:self.view].y < 40) {
                //pop
                _percentDriven = [[UIPercentDrivenInteractiveTransition alloc] init];
                _percentDriven.completionCurve = UIViewAnimationCurveEaseIn;
                [self popNextWithAnimation:YES];
            }else{
                _isEnablePan = NO;
            }
            
        }else if (sender.state == UIGestureRecognizerStateChanged){
            [_percentDriven updateInteractiveTransition:progress];
            
        }
        
    }
    if (sender.state == UIGestureRecognizerStateCancelled || sender.state ==UIGestureRecognizerStateEnded){
        if (progress > .5) {
            [_percentDriven finishInteractiveTransition];
        }else{
            [_percentDriven cancelInteractiveTransition];
        }
        _isEnablePan = YES;
        _percentDriven = nil;
    }
}


- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return _percentDriven;
}

#pragma mark - navi delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (_selectNum == 0) {
        return [PagePopTransition pageTransitionWithCmp:^(BOOL finished) {
            if ([self.dataDelegate respondsToSelector:@selector(pageViewController:turntoPageFrom:To:)]) {
                [self.dataDelegate pageViewController:self turntoPageFrom:_lastNum To:_selectNum];
            }
        }];
    }else{
        if (operation == UINavigationControllerOperationPush) {
            return [PagePushTransition pageTransitionWithCmp:^(BOOL finished) {
                if ([self.dataDelegate respondsToSelector:@selector(pageViewController:turntoPageFrom:To:)]) {
                    [self.dataDelegate pageViewController:self turntoPageFrom:_selectNum - 1 To:_selectNum];
                }
            }];
        }else if (operation == UINavigationControllerOperationPop){
            return [PagePopTransition pageTransitionWithCmp:^(BOOL finished) {
                if ([self.dataDelegate respondsToSelector:@selector(pageViewController:turntoPageFrom:To:)]) {
                    [self.dataDelegate pageViewController:self turntoPageFrom:_selectNum + 1 To:_selectNum];
                }
            }];
        }
    }
    
    return nil;
}



- (void)pushNextWithAnimation:(BOOL)animated
{
    if (_selectNum ==  [self.dataSource numberOfRows] - 1) {
        return;
    }else{
        _selectNum++;
        _lastNum = _selectNum;
        UIViewController *vc = [self.dataSource viewControllerInRow:_selectNum];
        
        [self pushViewController:vc animated:animated];
    }
}

- (void)popNextWithAnimation:(BOOL)animated
{
    if (_selectNum == 0) {
        return;
    }else{
        _selectNum--;
        [self popViewControllerAnimated:animated];
    }
}

- (void)moveToVC:(NSInteger)index
{
    if (index > [self.dataSource numberOfRows]) {
        return;
    }
    NSInteger count = index - self.viewControllers.count;
    
    if (count > 0) {
        for (int i = 0; i < count; i ++) {
            [self pushNextWithAnimation:NO];
        }
    }else{
        for (int i = 0; i < -(count); i++) {
            [self popNextWithAnimation:NO];
            
        }
    }
}


@end

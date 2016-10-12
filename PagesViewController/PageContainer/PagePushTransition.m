//
//  PagePushTransition.m
//  navi-custom
//
//  Created by jhtxch on 16/10/10.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#define istest 0

#import "PagePushTransition.h"
NSString *FinishBlockKey;

@implementation PagePushTransition

+ (instancetype)pageTransitionWithCmp:(finishBlock)cmp
{
    PagePushTransition *tra = [PagePushTransition new];
    objc_setAssociatedObject(tra, &FinishBlockKey, cmp, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return tra;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return TransitionTime;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *tvc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerview = [transitionContext containerView];
    [containerview addSubview:tvc.view];
    CGRect originFrame = [transitionContext initialFrameForViewController:fvc];
    tvc.view.frame = originFrame;
    
    [UIView transitionWithView:containerview
                      duration:[self transitionDuration:transitionContext]
                       options:UIViewAnimationOptionTransitionCurlUp |UIViewAnimationOptionCurveEaseOut
                    animations:^{}
                    completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                        finishBlock cmp = objc_getAssociatedObject(self, &FinishBlockKey
                                                                   );
                        if (cmp) {
                            cmp(finished);
                        }
    }];
    
}

@end

@implementation PagePopTransition

+ (instancetype)pageTransitionWithCmp:(finishBlock)cmp
{
    PagePopTransition *tra = [PagePopTransition new];
    objc_setAssociatedObject(tra, &FinishBlockKey, cmp, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return tra;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return TransitionTime;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *tvc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerview = [transitionContext containerView];
    [containerview addSubview:tvc.view];
    CGRect originFrame = [transitionContext initialFrameForViewController:fvc];
    tvc.view.frame = originFrame;
    

    [UIView transitionWithView:containerview
                      duration:[self transitionDuration:transitionContext]
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{}
                    completion:^(BOOL finished) {
                        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                        finishBlock cmp = objc_getAssociatedObject(self, &FinishBlockKey
                                                                   );
                        if (cmp) {
                            cmp(finished);
                        }
                    }];
}
@end
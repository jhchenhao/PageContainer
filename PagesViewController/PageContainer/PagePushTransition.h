//
//  PagePushTransition.h
//  navi-custom
//
//  Created by jhtxch on 16/10/10.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define TransitionTime 1
typedef void(^finishBlock)(BOOL finished);

@interface PagePushTransition : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)pageTransitionWithCmp:(finishBlock)cmp;

@end

@interface PagePopTransition : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)pageTransitionWithCmp:(finishBlock)cmp;

@end
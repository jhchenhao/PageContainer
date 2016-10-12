//
//  ContainerVC.h
//  navi-custom
//
//  Created by jhtxch on 16/10/9.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContainerVC;
@protocol PageDataSource <NSObject>

@required

- (NSInteger)numberOfRows;

- (UIViewController *)viewControllerInRow:(NSInteger)row;




@end

@protocol PageDataDelegate <NSObject>

@optional

- (CGRect)rectOfPageView;

- (void)pageViewController:(ContainerVC *)container turntoPageFrom:(NSInteger)fromPage To:(NSInteger)toPage;

@end

@interface ContainerVC : UINavigationController

@property (nonatomic, weak) id<PageDataSource> dataSource;
@property (nonatomic, weak) id<PageDataDelegate> dataDelegate;

- (void)reladData;
- (void)reladDataWithAnimation:(BOOL)animated;

- (void)pushNextWithAnimation:(BOOL)animated;

- (void)popNextWithAnimation:(BOOL)animated;

- (void)moveToVC:(NSInteger)index;
@end

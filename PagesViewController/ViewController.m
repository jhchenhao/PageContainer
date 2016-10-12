//
//  ViewController.m
//  PagesViewController
//
//  Created by jhtxch on 16/10/12.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import "ViewController.h"
#import "ContainerVC.h"

@interface ViewController ()<PageDataDelegate, PageDataSource>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create container
    ContainerVC *container = [ContainerVC new];
    [self addChildViewController:container];
    [self.view addSubview:container.view];
    container.dataDelegate = self;
    container.dataSource = self;
    [container didMoveToParentViewController:self];
}


#pragma mark - delegate

//设置页数
- (NSInteger)numberOfRows
{
    return 5;
}
//设置每页内容
- (UIViewController *)viewControllerInRow:(NSInteger)row
{
    UIViewController *vc = [UIViewController new];
    UIImageView *img = [[UIImageView alloc] initWithFrame:vc.view.bounds];
    img.image = [UIImage imageNamed:[NSString stringWithFormat:@"egg-%li.jpg",row + 1]];
    img.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [vc.view addSubview:img];
    
    return vc;
}

//设置container 尺寸
- (CGRect)rectOfPageView
{
    return CGRectInset(self.view.bounds, 0, 100);
}

//动画结束回调
- (void)pageViewController:(ContainerVC *)container turntoPageFrom:(NSInteger)fromPage To:(NSInteger)toPage
{
    NSLog(@"from: %li to: %li",fromPage,toPage);
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

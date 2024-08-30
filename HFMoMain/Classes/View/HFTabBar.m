//
//  HFTabBar.m
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import "HFTabBar.h"

@interface HFTabBar ()

@property(nonatomic, strong) UIView *separatorView;

@end

@implementation HFTabBar

/**
 *  设置全局的菜单栏背景颜色
 *
 *  @param globalColor 全局菜单栏背景颜色
 */
+ (void)setGlobalBackGroundColor:(UIColor *)globalColor {
    UITabBar *tabBar = [UITabBar appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:NSClassFromString(@"HFTabBarController")]];
    tabBar.backgroundColor = globalColor;
    
    if (@available (iOS 15.0, *)) {
        // iOS 15.0 及以上
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = globalColor;
        
        tabBar.standardAppearance = appearance;
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance;
    } else {
        tabBar.barTintColor = globalColor;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.separatorView = [UIView new];
        self.separatorView.alpha = 0.2;
        self.separatorView.backgroundColor = UIColor.lightGrayColor;
        [self addSubview:_separatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self bringSubviewToFront:self.separatorView];
    [self.separatorView setFrame:CGRectMake(0, -0.5, self.frame.size.width, 0.5)];
}

@end

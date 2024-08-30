//
//  HFNavBar.m
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import "HFNavBar.h"

@interface HFNavBar ()

@property(nonatomic, strong) UIView *separatorView;

@end

@implementation HFNavBar

/**
 *  设置全局的导航栏背景颜色
 *
 *  @param globalColor 全局导航栏背景颜色
 */
+ (void)setGlobalBackGroundColor:(UIColor *)globalColor {
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:NSClassFromString(@"HFNavigationViewController")]];
    
    // 设置背景颜色
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = navBar.standardAppearance;
        appearance.backgroundColor = globalColor;
        
        navBar.standardAppearance = appearance;
        navBar.scrollEdgeAppearance = appearance;
    } else {
        [navBar setBarTintColor:globalColor];
    }
}

/**
 *  设置全局导航栏标题颜色
 *
 *  @param globalTextColor 全局导航栏标题颜色
 */
+ (void)setGlobalTextColor:(UIColor *)globalTextColor andFontSize:(CGFloat)fontSize {
    if (globalTextColor == nil) {
        return;
    }
    if (fontSize < 6 || fontSize > 40) {
        fontSize = 17;
    }
    
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:NSClassFromString(@"HFNavigationViewController")]];
    
    // 设置导航栏颜色
    NSDictionary *titleDic = @{NSForegroundColorAttributeName: globalTextColor, NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    [navBar setTitleTextAttributes:titleDic];
    navBar.tintColor = globalTextColor;
    
    if(@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = navBar.standardAppearance;
        appearance.titleTextAttributes = titleDic;
        navBar.standardAppearance = appearance;
        navBar.scrollEdgeAppearance = appearance;
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
    [self.separatorView setFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
}

@end

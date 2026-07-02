//
//  HFMainConfigs.m
//  HFMoMain
//
//  Created by hongfei_liu on 2026/7/1.
//

#import "HFMainConfigs.h"

static HFMainConfigs *_HFMainConfigs;

@implementation HFMainConfigs

#pragma mark - 单例的初始化
+ (HFMainConfigs *)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _HFMainConfigs = [[HFMainConfigs alloc] init];
    });
    return _HFMainConfigs;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _navBarBGColor = nil;
        _navBarTitleColor = UIColor.blackColor;
        _navBarFontSize = 17.f;
        _isNavBarSeparator = NO;
        
        _tabbarBGColor = nil;
        _tabbarNormalTitleColor = UIColor.grayColor;
        _tabbarSelectedTitleColor = UIColor.systemBlueColor;
        _tabbarNormalFontSize = 11.f;
        _tabbarSelectedFontSize = 11.f;
        _tabbarTitleImageSpacing = 2.f;
        _isTabbarSeparator = NO;
        _tabbarLiquidGlassEnabled = NO;
    }
    return self;
}

@end

//
//  HFMainConfigs.h
//  HFMoMain
//
//  Created by hongfei_liu on 2026/7/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFMainConfigs : NSObject

/// navBar背景颜色
@property (nonatomic, strong, nullable) UIColor *navBarBGColor;
/// navBar标题颜色
@property (nonatomic, strong, nonnull) UIColor *navBarTitleColor;
/// navBar标题字体大小
@property (nonatomic, assign) CGFloat navBarFontSize;
/// 是否有navBar分割线
@property (nonatomic, assign) BOOL isNavBarSeparator;

/// tabbar背景颜色
/// 仅在 `tabbarLiquidGlassEnabled = NO` 时生效
@property (nonatomic, strong, nullable) UIColor *tabbarBGColor;
/// tabbar item normal 标题颜色
@property (nonatomic, strong) UIColor *tabbarNormalTitleColor;
/// tabbar item selected 标题颜色
@property (nonatomic, strong) UIColor *tabbarSelectedTitleColor;
/// tabbar item normal 标题字体大小
@property (nonatomic, assign) CGFloat tabbarNormalFontSize;
/// tabbar item selected 标题字体大小
@property (nonatomic, assign) CGFloat tabbarSelectedFontSize;
/// tabbar item 图片和标题之间的间距
/// 仅在自定义 `HFTabBar` 模式下生效
@property (nonatomic, assign) CGFloat tabbarTitleImageSpacing;
/// 是否有tabbar分割线
/// 仅在 `tabbarLiquidGlassEnabled = NO` 时生效
@property (nonatomic, assign) BOOL isTabbarSeparator;

/// 是否启用tabbar动态玻璃效果
/// YES: 使用系统默认玻璃风格外观，`tabbarBGColor` 和 `isTabbarSeparator` 设置不生效
/// NO: 使用非玻璃的普通底栏效果；未配置 `tabbarBGColor` 时默认使用白色背景
@property (nonatomic, assign) BOOL tabbarLiquidGlassEnabled;

/// 模式管理单例
+ (HFMainConfigs *)defaultManager;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

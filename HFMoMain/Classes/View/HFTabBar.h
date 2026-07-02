//
//  HFTabBar.h
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HFTabBar;
@class HFTabBarItem;

@protocol HFTabBarDelegate <NSObject>

- (void)tabBar:(HFTabBar *)tabBar didSelectIndex:(NSInteger)index;

@end

@interface HFTabBar : UIView

@property (nonatomic, weak, nullable) id<HFTabBarDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray<HFTabBarItem *> *items;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL blurEnabled;
@property (nonatomic, assign) UIBlurEffectStyle blurStyle;
@property (nonatomic, strong, nullable) UIColor *barBackgroundColor;
@property (nonatomic, assign) BOOL showsTopSeparator;
@property (nonatomic, strong, nullable) UIColor *separatorColor;

- (void)reloadWithItems:(NSArray<HFTabBarItem *> *)items selectedIndex:(NSInteger)selectedIndex;
- (void)updateItem:(HFTabBarItem *)item atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END

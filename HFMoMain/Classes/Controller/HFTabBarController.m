//
//  HFTabBarController.m
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import "HFTabBarController.h"
#import "HFNavigationViewController.h"
#import "HFTabBar.h"
#import "HFTabBarItem.h"
#import "HFMainConfigs.h"
#import "HFMainConfigs+HFStyle.h"
#import "UIViewController+HFTabBar.h"

@interface HFTabBarController () <HFTabBarDelegate, UITabBarDelegate>

@property (nonatomic, strong) NSMutableArray<UIViewController *> *hf_mutableViewControllers;
@property (nonatomic, strong, readwrite) NSArray<HFTabBarItem *> *items;
@property (nonatomic, strong) UIView *hf_contentView;
@property (nonatomic, strong) HFTabBar *hf_toolbarView;
@property (nonatomic, strong) UITabBar *hf_systemTabBar;
@property (nonatomic, strong) NSLayoutConstraint *hf_toolbarHeightConstraint;
@property (nonatomic, assign, readwrite, getter=isToolbarHidden) BOOL toolbarHidden;
@property (nonatomic, assign) BOOL hf_hasAppliedInitialSelection;

@end

@implementation HFTabBarController

+ (instancetype)shareInstance {
    static HFTabBarController *tabbarC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabbarC = [[HFTabBarController alloc] init];
    });
    return tabbarC;
}

+ (instancetype)tabBarControllerWithAddChildVCsBlock:(void(^)(HFTabBarController *tabBarC))addVCBlock {
    HFTabBarController *tabbarVC = [[HFTabBarController alloc] init];
    if (addVCBlock) {
        addVCBlock(tabbarVC);
    }
    return tabbarVC;
}

- (instancetype)init {
    return [self initWithViewControllers:@[] items:@[] defaultSelectedIndex:0];
}

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                                  items:(NSArray<HFTabBarItem *> *)items {
    return [self initWithViewControllers:viewControllers items:items defaultSelectedIndex:0];
}

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                                  items:(NSArray<HFTabBarItem *> *)items
                   defaultSelectedIndex:(NSInteger)defaultSelectedIndex {
    self = [super init];
    if (self) {
        [self hf_commonInitWithViewControllers:viewControllers items:items defaultSelectedIndex:defaultSelectedIndex];
    }
    return self;
}

- (void)hf_commonInitWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                                   items:(NSArray<HFTabBarItem *> *)items
                    defaultSelectedIndex:(NSInteger)defaultSelectedIndex {
    NSInteger count = MIN(viewControllers.count, items.count);
    _hf_mutableViewControllers = [NSMutableArray array];
    for (NSInteger idx = 0; idx < count; idx++) {
        UIViewController *viewController = viewControllers[idx];
        [_hf_mutableViewControllers addObject:viewController];
    }
    _items = (count > 0) ? [items subarrayWithRange:NSMakeRange(0, count)] : @[];
    
    HFMainConfigs *configs = [HFMainConfigs defaultManager];
    _liquidGlassEnabled = configs.tabbarLiquidGlassEnabled;
    _backgroundColor = [configs hf_effectiveTabbarBackgroundColor];
    _showTopSeparator = [configs hf_effectiveTabbarSeparatorEnabled];
    _separatorColor = UIColor.separatorColor;
    _blurEnabled = YES;
    _blurStyle = UIBlurEffectStyleSystemMaterial;
    _extendContentUnderTabbar = NO;
    _toolbarHidden = NO;
    _selectedIndex = (defaultSelectedIndex >= 0 && defaultSelectedIndex < count) ? defaultSelectedIndex : 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hf_setupContentView];
    [self hf_setupNavigationBar];
    [self hf_addManagedChildViewControllersIfNeeded];
    [self hf_reloadTabBarItems];
    if (self.hf_mutableViewControllers.count > 0) {
        [self hf_handleSelectIndex:self.selectedIndex animated:NO notify:NO force:YES];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self hf_updateTabBarLayoutIfNeeded];
    [self hf_updateChildViewControllerInsets];
}

- (NSArray<UIViewController *> *)viewControllers {
    return [self.hf_mutableViewControllers copy] ?: @[];
}

- (UIViewController *)selectedViewController {
    if (self.selectedIndex < 0 || self.selectedIndex >= self.hf_mutableViewControllers.count) {
        return nil;
    }
    return self.hf_mutableViewControllers[self.selectedIndex];
}

- (void)hf_setupContentView {
    if (self.hf_contentView) {
        return;
    }
    
    self.hf_contentView = [[UIView alloc] init];
    self.hf_contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.hf_contentView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.hf_contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.hf_contentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.hf_contentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.hf_contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)hf_setupNavigationBar {
    if (self.liquidGlassEnabled) {
        [self hf_setupSystemTabBarIfNeeded];
    } else {
        [self hf_setupToolbarIfNeeded];
    }
}

- (void)hf_setupToolbarIfNeeded {
    if (self.hf_toolbarView) {
        return;
    }
    
    self.hf_toolbarView = [[HFTabBar alloc] init];
    self.hf_toolbarView.delegate = self;
    self.hf_toolbarView.blurEnabled = self.blurEnabled;
    self.hf_toolbarView.blurStyle = self.blurStyle;
    self.hf_toolbarView.separatorColor = self.separatorColor;
    [[HFMainConfigs defaultManager] hf_applyToCustomTabBar:self.hf_toolbarView];
    [self.view addSubview:self.hf_toolbarView];
    
    self.hf_toolbarHeightConstraint = [self.hf_toolbarView.heightAnchor constraintEqualToConstant:[self hf_tabBarHeight]];
    [NSLayoutConstraint activateConstraints:@[
        [self.hf_toolbarView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.hf_toolbarView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.hf_toolbarView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        self.hf_toolbarHeightConstraint
    ]];
}

- (void)hf_setupSystemTabBarIfNeeded {
    if (self.hf_systemTabBar) {
        return;
    }
    
    self.hf_systemTabBar = [[UITabBar alloc] init];
    self.hf_systemTabBar.delegate = self;
    self.hf_systemTabBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.hf_systemTabBar];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.hf_systemTabBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.hf_systemTabBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.hf_systemTabBar.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [[HFMainConfigs defaultManager] hf_applyToSystemTabBar:self.hf_systemTabBar];
}

- (void)hf_addManagedChildViewControllersIfNeeded {
    for (NSInteger idx = 0; idx < self.hf_mutableViewControllers.count; idx++) {
        UIViewController *viewController = self.hf_mutableViewControllers[idx];
        [self hf_installManagedViewController:viewController atIndex:idx];
    }
}

- (void)hf_installManagedViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    if (viewController.parentViewController == self) {
        return;
    }
    
    [self addChildViewController:viewController];
    viewController.view.frame = self.hf_contentView.bounds;
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.hf_contentView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    viewController.view.hidden = YES;
    
    if (index >= 0 && index < self.items.count) {
        [viewController hf_bindTabBarItem:self.items[index]];
    }
}

- (void)hf_reloadTabBarItems {
    HFMainConfigs *configs = [HFMainConfigs defaultManager];
    for (HFTabBarItem *item in self.items) {
        [configs hf_applyToTabBarItem:item];
    }
    
    if (self.liquidGlassEnabled) {
        [self hf_reloadSystemTabBarItems];
    } else {
        self.hf_toolbarView.blurEnabled = self.blurEnabled;
        self.hf_toolbarView.blurStyle = self.blurStyle;
        self.hf_toolbarView.separatorColor = self.separatorColor;
        [[HFMainConfigs defaultManager] hf_applyToCustomTabBar:self.hf_toolbarView];
        [self.hf_toolbarView reloadWithItems:self.items selectedIndex:self.selectedIndex];
    }
}

- (void)hf_reloadSystemTabBarItems {
    if (!self.hf_systemTabBar) {
        return;
    }
    
    NSMutableArray<UITabBarItem *> *tabBarItems = [NSMutableArray array];
    for (HFTabBarItem *item in self.items) {
        UIImage *normalImage = item.normalImage;
        UIImage *selectedImage = item.selectedImage ?: item.normalImage;
        if (!item.useOriginalRendering) {
            normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else {
            normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:item.title image:normalImage selectedImage:selectedImage];
        [tabBarItems addObject:tabBarItem];
    }
    
    self.hf_systemTabBar.items = tabBarItems;
    if (self.selectedIndex >= 0 && self.selectedIndex < tabBarItems.count) {
        self.hf_systemTabBar.selectedItem = tabBarItems[self.selectedIndex];
    }
}

- (CGFloat)hf_tabBarHeight {
    return 49.0 + self.view.safeAreaInsets.bottom;
}

- (void)hf_updateTabBarLayoutIfNeeded {
    if (self.hf_toolbarHeightConstraint) {
        self.hf_toolbarHeightConstraint.constant = [self hf_tabBarHeight];
    }
}

- (void)hf_updateChildViewControllerInsets {
    CGFloat bottomInset = 0.0;
    if (!self.extendContentUnderTabbar && !self.toolbarHidden) {
        bottomInset = [self hf_tabBarHeight];
    }
    
    for (UIViewController *viewController in self.hf_mutableViewControllers) {
        UIEdgeInsets insets = viewController.additionalSafeAreaInsets;
        if (insets.bottom != bottomInset) {
            insets.bottom = bottomInset;
            viewController.additionalSafeAreaInsets = insets;
        }
    }
}

- (void)hf_handleSelectIndex:(NSInteger)index animated:(BOOL)animated notify:(BOOL)notify force:(BOOL)force {
    if (index < 0 || index >= self.hf_mutableViewControllers.count) {
        return;
    }
    if (!force && index == self.selectedIndex && self.hf_hasAppliedInitialSelection) {
        return;
    }
    if (notify && [self.delegate respondsToSelector:@selector(hfTabBarController:shouldSelectIndex:)] &&
        ![self.delegate hfTabBarController:self shouldSelectIndex:index]) {
        return;
    }
    
    NSInteger oldIndex = self.selectedIndex;
    UIViewController *oldViewController = self.selectedViewController;
    UIViewController *newViewController = self.hf_mutableViewControllers[index];
    BOOL isVisible = self.isViewLoaded && self.view.window != nil;
    
    if (isVisible && oldViewController && oldViewController != newViewController) {
        [oldViewController beginAppearanceTransition:NO animated:animated];
    }
    if (isVisible && newViewController && oldViewController != newViewController) {
        [newViewController beginAppearanceTransition:YES animated:animated];
    }
    
    oldViewController.view.hidden = YES;
    newViewController.view.hidden = NO;
    _selectedIndex = index;
    self.hf_hasAppliedInitialSelection = YES;
    
    if (isVisible && oldViewController && oldViewController != newViewController) {
        [oldViewController endAppearanceTransition];
    }
    if (isVisible && newViewController && oldViewController != newViewController) {
        [newViewController endAppearanceTransition];
    }
    
    if (self.liquidGlassEnabled) {
        if (index < self.hf_systemTabBar.items.count) {
            self.hf_systemTabBar.selectedItem = self.hf_systemTabBar.items[index];
        }
    } else {
        self.hf_toolbarView.selectedIndex = index;
    }
    
    [self hf_syncToolbarVisibilityForViewController:newViewController animated:animated];
    
    if (notify && [self.delegate respondsToSelector:@selector(hfTabBarController:didSelectIndex:viewController:)]) {
        [self.delegate hfTabBarController:self didSelectIndex:index viewController:newViewController];
    }
    
    if (oldIndex != index) {
        [self hf_updateChildViewControllerInsets];
    }
}

- (void)hf_syncToolbarVisibilityForViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL shouldHide = NO;
    if ([viewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        UIViewController *topViewController = navigationController.topViewController;
        BOOL isRootViewController = (topViewController == navigationController.viewControllers.firstObject);
        if (topViewController && !isRootViewController) {
            shouldHide = topViewController.hf_hidesBottomBarWhenPushed;
        }
    } else {
        shouldHide = viewController.hf_hidesBottomBarWhenPushed;
    }
    [self setToolbarHidden:shouldHide animated:animated];
}

- (UIView *)hf_activeTabBarView {
    return self.liquidGlassEnabled ? self.hf_systemTabBar : self.hf_toolbarView;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self hf_handleSelectIndex:selectedIndex animated:NO notify:NO force:NO];
}

- (void)switchToIndex:(NSInteger)index {
    [self hf_handleSelectIndex:index animated:NO notify:YES force:NO];
}

- (void)addChildVC:(UIViewController *)vc titleStr:(NSString *)titleStr normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName isRequiredNavController:(BOOL)isRequired {
    HFTabBarItem *item = [[HFTabBarItem alloc] initWithTitle:titleStr
                                                 normalImage:[self originImageWithName:normalImageName]
                                               selectedImage:[self originImageWithName:selectedImageName]];
    [[HFMainConfigs defaultManager] hf_applyToTabBarItem:item];
    UIViewController *managedViewController = vc;
    if (isRequired) {
        managedViewController = [[HFNavigationViewController alloc] initWithRootViewController:vc];
    }
    [self hf_appendViewController:managedViewController item:item];
}

- (void)hf_appendViewController:(UIViewController *)viewController item:(HFTabBarItem *)item {
    [self.hf_mutableViewControllers addObject:viewController];
    NSMutableArray<HFTabBarItem *> *mutableItems = [self.items mutableCopy] ?: [NSMutableArray array];
    [mutableItems addObject:item];
    self.items = [mutableItems copy];
    
    if (self.isViewLoaded) {
        NSInteger index = self.hf_mutableViewControllers.count - 1;
        [self hf_installManagedViewController:viewController atIndex:index];
        [self hf_reloadTabBarItems];
        if (self.hf_mutableViewControllers.count == 1) {
            [self hf_handleSelectIndex:0 animated:NO notify:NO force:YES];
        }
    }
}

- (void)replaceViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self replaceViewController:viewController atIndex:index andSwitchTo:NO];
}

- (void)replaceViewController:(UIViewController *)viewController atIndex:(NSInteger)index andSwitchTo:(BOOL)switchTo {
    if (!viewController || index < 0 || index >= self.hf_mutableViewControllers.count) {
        return;
    }
    
    UIViewController *oldViewController = self.hf_mutableViewControllers[index];
    [oldViewController willMoveToParentViewController:nil];
    [oldViewController.view removeFromSuperview];
    [oldViewController removeFromParentViewController];
    
    self.hf_mutableViewControllers[index] = viewController;
    if (index < self.items.count) {
        [viewController hf_bindTabBarItem:self.items[index]];
    }
    
    if (self.isViewLoaded) {
        [self hf_installManagedViewController:viewController atIndex:index];
        [self hf_reloadTabBarItems];
    }
    
    if (switchTo || index == self.selectedIndex) {
        [self hf_handleSelectIndex:index animated:NO notify:NO force:YES];
    } else if (self.isViewLoaded) {
        viewController.view.hidden = YES;
    }
}

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated {
    _toolbarHidden = hidden;
    UIView *tabBarView = [self hf_activeTabBarView];
    if (!tabBarView) {
        return;
    }
    
    CGFloat offset = [self hf_tabBarHeight];
    CGAffineTransform transform = hidden ? CGAffineTransformMakeTranslation(0, offset) : CGAffineTransformIdentity;
    CGFloat alpha = hidden ? 0.0 : 1.0;
    
    if (animated) {
        if (!hidden) {
            tabBarView.hidden = NO;
        }
        [UIView animateWithDuration:0.25 animations:^{
            tabBarView.transform = transform;
            tabBarView.alpha = alpha;
        } completion:^(BOOL finished) {
            tabBarView.hidden = hidden;
        }];
    } else {
        tabBarView.hidden = hidden;
        tabBarView.transform = transform;
        tabBarView.alpha = alpha;
    }
    
    [self hf_updateChildViewControllerInsets];
}

- (void)updateItem:(HFTabBarItem *)item atIndex:(NSInteger)index {
    if (!item || index < 0 || index >= self.items.count) {
        return;
    }
    [[HFMainConfigs defaultManager] hf_applyToTabBarItem:item];
    
    NSMutableArray<HFTabBarItem *> *mutableItems = [self.items mutableCopy];
    mutableItems[index] = item;
    self.items = [mutableItems copy];
    
    UIViewController *viewController = self.hf_mutableViewControllers[index];
    [viewController hf_bindTabBarItem:item];
    
    if (self.liquidGlassEnabled) {
        [self hf_reloadSystemTabBarItems];
    } else {
        [self.hf_toolbarView updateItem:item atIndex:index];
    }
}

- (void)hf_selectedNavigationStateDidChangeAnimated:(BOOL)animated {
    UIViewController *viewController = self.selectedViewController;
    if (!viewController) {
        return;
    }
    [self hf_syncToolbarVisibilityForViewController:viewController animated:animated];
}

- (UIImage *)originImageWithName:(NSString *)name {
    return [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - HFTabBarDelegate

- (void)tabBar:(HFTabBar *)tabBar didSelectIndex:(NSInteger)index {
    [self switchToIndex:index];
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [tabBar.items indexOfObject:item];
    if (index == NSNotFound) {
        return;
    }
    [self switchToIndex:index];
}

@end

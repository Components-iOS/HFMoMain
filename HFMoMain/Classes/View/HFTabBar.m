//
//  HFTabBar.m
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import "HFTabBar.h"
#import "HFTabBarItem.h"

@interface HFTabBarButtonView : UIControl

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HFTabBarItem *item;

- (instancetype)initWithItem:(HFTabBarItem *)item;
- (void)updateSelectedState:(BOOL)selected;

@end

@implementation HFTabBarButtonView

- (instancetype)initWithItem:(HFTabBarItem *)item {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _item = item;
        [self hf_setupViews];
        [self updateSelectedState:NO];
    }
    return self;
}

- (void)hf_setupViews {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _iconView = [[UIImageView alloc] init];
    _iconView.translatesAutoresizingMaskIntoConstraints = NO;
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_iconView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [_iconView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_iconView.topAnchor constraintEqualToAnchor:self.topAnchor constant:6.0],
        [_iconView.widthAnchor constraintEqualToConstant:24.0],
        [_iconView.heightAnchor constraintEqualToConstant:24.0],
        
        [_titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_titleLabel.topAnchor constraintEqualToAnchor:_iconView.bottomAnchor constant:2.0],
        [_titleLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:4.0],
        [_titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-4.0],
        [_titleLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor constant:-4.0]
    ]];
}

- (void)updateSelectedState:(BOOL)selected {
    UIColor *normalColor = self.item.normalColor ?: UIColor.grayColor;
    UIColor *selectedColor = self.item.selectedColor ?: UIColor.systemBlueColor;
    UIColor *color = selected ? selectedColor : normalColor;
    UIImage *image = selected ? (self.item.selectedImage ?: self.item.normalImage) : self.item.normalImage;
    CGFloat normalFontSize = self.item.normalFontSize > 0 ? self.item.normalFontSize : (self.item.fontSize > 0 ? self.item.fontSize : 10.0);
    CGFloat selectedFontSize = self.item.selectedFontSize > 0 ? self.item.selectedFontSize : normalFontSize;
    
    self.titleLabel.text = self.item.title;
    self.titleLabel.font = [UIFont systemFontOfSize:(selected ? selectedFontSize : normalFontSize)];
    self.titleLabel.textColor = color;
    if (self.item.useOriginalRendering) {
        self.iconView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.iconView.tintColor = nil;
    } else {
        self.iconView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.iconView.tintColor = color;
    }
}

@end

@interface HFTabBar ()

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIView *solidBackgroundView;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) NSArray<HFTabBarItem *> *items;
@property (nonatomic, strong) NSArray<HFTabBarButtonView *> *itemViews;

@end

@implementation HFTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _blurEnabled = YES;
        _blurStyle = UIBlurEffectStyleSystemMaterial;
        _showsTopSeparator = YES;
        _separatorColor = UIColor.separatorColor;
        [self hf_setupViews];
        [self hf_updateBackgroundAppearance];
    }
    return self;
}

- (void)hf_setupViews {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = NO;
    
    _blurView = [[UIVisualEffectView alloc] init];
    _blurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_blurView];
    
    _solidBackgroundView = [[UIView alloc] init];
    _solidBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_solidBackgroundView];
    
    _overlayView = [[UIView alloc] init];
    _overlayView.translatesAutoresizingMaskIntoConstraints = NO;
    _overlayView.backgroundColor = UIColor.clearColor;
    [self addSubview:_overlayView];
    
    _separatorView = [[UIView alloc] init];
    _separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_separatorView];
    
    _stackView = [[UIStackView alloc] init];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    _stackView.axis = UILayoutConstraintAxisHorizontal;
    _stackView.alignment = UIStackViewAlignmentFill;
    _stackView.distribution = UIStackViewDistributionFillEqually;
    [self addSubview:_stackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [_blurView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_blurView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_blurView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        
        [_solidBackgroundView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_solidBackgroundView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_solidBackgroundView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_solidBackgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        
        [_overlayView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_overlayView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_overlayView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_overlayView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        
        [_separatorView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_separatorView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_separatorView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_separatorView.heightAnchor constraintEqualToConstant:1.0 / UIScreen.mainScreen.scale],
        
        [_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_stackView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor],
        [_stackView.heightAnchor constraintEqualToConstant:49.0]
    ]];
}

- (void)setBlurEnabled:(BOOL)blurEnabled {
    _blurEnabled = blurEnabled;
    [self hf_updateBackgroundAppearance];
}

- (void)setBlurStyle:(UIBlurEffectStyle)blurStyle {
    _blurStyle = blurStyle;
    [self hf_updateBackgroundAppearance];
}

- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor {
    _barBackgroundColor = barBackgroundColor;
    [self hf_updateBackgroundAppearance];
}

- (void)setShowsTopSeparator:(BOOL)showsTopSeparator {
    _showsTopSeparator = showsTopSeparator;
    self.separatorView.hidden = !_showsTopSeparator;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor ?: UIColor.separatorColor;
    self.separatorView.backgroundColor = _separatorColor;
}

- (void)hf_updateBackgroundAppearance {
    self.blurView.hidden = !self.blurEnabled;
    self.solidBackgroundView.hidden = self.blurEnabled;
    self.separatorView.hidden = !self.showsTopSeparator;
    self.separatorView.backgroundColor = self.separatorColor ?: UIColor.separatorColor;
    
    if (self.blurEnabled) {
        self.blurView.effect = [UIBlurEffect effectWithStyle:self.blurStyle];
        self.overlayView.backgroundColor = self.barBackgroundColor ?: UIColor.clearColor;
        self.solidBackgroundView.backgroundColor = UIColor.clearColor;
    } else {
        self.overlayView.backgroundColor = UIColor.clearColor;
        self.solidBackgroundView.backgroundColor = self.barBackgroundColor ?: UIColor.whiteColor;
    }
}

- (void)reloadWithItems:(NSArray<HFTabBarItem *> *)items selectedIndex:(NSInteger)selectedIndex {
    self.items = items ?: @[];
    
    for (UIView *arrangedSubview in self.stackView.arrangedSubviews) {
        [self.stackView removeArrangedSubview:arrangedSubview];
        [arrangedSubview removeFromSuperview];
    }
    
    NSMutableArray<HFTabBarButtonView *> *itemViews = [NSMutableArray array];
    [self.items enumerateObjectsUsingBlock:^(HFTabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        HFTabBarButtonView *itemView = [[HFTabBarButtonView alloc] initWithItem:item];
        itemView.tag = idx;
        [itemView addTarget:self action:@selector(hf_handleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.stackView addArrangedSubview:itemView];
        [itemViews addObject:itemView];
    }];
    self.itemViews = itemViews;
    self.selectedIndex = selectedIndex;
}

- (void)updateItem:(HFTabBarItem *)item atIndex:(NSInteger)index {
    if (!item || index < 0 || index >= self.items.count) {
        return;
    }
    
    NSMutableArray<HFTabBarItem *> *mutableItems = [self.items mutableCopy];
    mutableItems[index] = item;
    self.items = [mutableItems copy];
    
    HFTabBarButtonView *itemView = self.itemViews[index];
    itemView.item = item;
    [itemView updateSelectedState:(index == self.selectedIndex)];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self.itemViews enumerateObjectsUsingBlock:^(HFTabBarButtonView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj updateSelectedState:(idx == selectedIndex)];
    }];
}

- (void)hf_handleTap:(HFTabBarButtonView *)sender {
    self.selectedIndex = sender.tag;
    [self.delegate tabBar:self didSelectIndex:sender.tag];
}

@end

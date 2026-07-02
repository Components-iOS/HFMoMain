#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFTabBarItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, nullable) UIImage *normalImage;
@property (nonatomic, strong, nullable) UIImage *selectedImage;
@property (nonatomic, strong, nullable) UIColor *normalColor;
@property (nonatomic, strong, nullable) UIColor *selectedColor;
@property (nonatomic, assign) CGFloat normalFontSize;
@property (nonatomic, assign) CGFloat selectedFontSize;
@property (nonatomic, assign) CGFloat titleImageSpacing;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) BOOL useOriginalRendering;

- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(nullable UIImage *)normalImage
                selectedImage:(nullable UIImage *)selectedImage;

@end

NS_ASSUME_NONNULL_END

#import "HFTabBarItem.h"

@implementation HFTabBarItem

- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage {
    self = [super init];
    if (self) {
        _title = [title copy] ?: @"";
        _normalImage = normalImage;
        _selectedImage = selectedImage;
        _normalColor = nil;
        _selectedColor = nil;
        _normalFontSize = 0.0;
        _selectedFontSize = 0.0;
        _fontSize = 0.0;
        _useOriginalRendering = YES;
    }
    return self;
}

@end

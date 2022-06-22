//
//  KMLScrollTextLabel.h
//  YooLive
//
//  Created by ChenHuaMou on 2022/6/22.
//  Copyright © 2022 encore. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 滚动label
@interface KMLScrollTextLabel : UIView

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, assign) CGFloat maxContainerWidth;

- (CGFloat)realTextWidth;

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor textFont:(UIFont *)textFont textAlignment:(NSTextAlignment)textAlignment;

@end

NS_ASSUME_NONNULL_END

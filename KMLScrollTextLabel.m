//
//  KMLScrollTextLabel.m
//  YooLive
//
//  Created by ChenHuaMou on 2022/6/22.
//  Copyright © 2022 encore. All rights reserved.
//

#import "KMLScrollTextLabel.h"

@interface KMLScrollTextLabel ()
/// 文字字过长的时候 滑动 的容器
@property (nonatomic, strong) UIView *clipView;
@property (nonatomic, strong) ECLabel *titleLabel;
@property (nonatomic, strong) ECLabel *titleLabel_copy;

@end

@implementation KMLScrollTextLabel

- (CGFloat)realTextWidth {
    return [_titleLabel intrinsicContentSize].width;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor textFont:(UIFont *)textFont textAlignment:(NSTextAlignment)textAlignment {
    if (self = [super initWithFrame:frame]) {
        self.textColor = textColor;
        self.textFont = textFont;
        self.textAlignment = textAlignment;
        [self setupAppearance];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupAppearance];
    }
    return self;
}

- (void)setupAppearance {
    
    self.textColor = self.textColor ?: UIColor.whiteColor;
    self.textFont = self.textFont ?: [UIFont systemFontOfSize:14];
    
    _clipView = [[UIView alloc] initWithFrame:self.bounds];
    _clipView.clipsToBounds = YES;
    [self addSubview:_clipView];
    
    _titleLabel = [[ECLabel alloc] initWithFrame:self.bounds];
    _titleLabel.kmTextColor(_textColor).kmFont(_textFont).kmTextAlignment(_textAlignment);
    [_clipView addSubview:_titleLabel];
    
    _titleLabel_copy = [[ECLabel alloc] initWithFrame:self.bounds];
    _titleLabel_copy.kmTextColor(_textColor).kmFont(_textFont).kmTextAlignment(NSTextAlignmentLeft);
    [_clipView addSubview:_titleLabel_copy];
    _titleLabel_copy.hidden = YES;
}

- (void)layoutSubviews {
    _clipView.frame = self.bounds;
}

#pragma mark - 滚动
- (void)startScroolAction {
    _titleLabel_copy.hidden = NO;
    // 增加一定的偏移距离
    CGFloat offset = _clipView.widthKM / 2.0;
    _titleLabel_copy.frame = _titleLabel.frame;
    _titleLabel_copy.xKM = _titleLabel.rightKM + offset;
    
    [self performSelector:@selector(setAnimation) withObject:nil afterDelay:1];
}
- (void)stopScrollAction {
    [UIView cancelPreviousPerformRequestsWithTarget:self selector:@selector(setAnimation) object:nil];
    [_titleLabel.layer removeAllAnimations];
    
    [_titleLabel_copy.layer removeAllAnimations];
    _titleLabel_copy.hidden = YES;
}
- (void)setAnimation {
    CGFloat offset = _clipView.widthKM / 2;
    
    CAKeyframeAnimation *anim = [self makeScrollAnimation];
    anim.values = @[@(0), @(-(_titleLabel.widthKM + offset))];
    [_titleLabel.layer addAnimation:anim forKey:nil];
    
    anim = [self makeScrollAnimation];
    anim.values = @[@(0), @(-(_titleLabel_copy.xKM))];
    [_titleLabel_copy.layer addAnimation:anim forKey:nil];
    
}
- (CAKeyframeAnimation *)makeScrollAnimation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.keyTimes = @[@(0.0), @(1.0)];
    
    CGFloat speed = 80.0;
    CFTimeInterval moveTime = _titleLabel.widthKM / speed + 1;
    CFTimeInterval totalTime = moveTime + 1;
    anim.duration = totalTime;
    
    anim.repeatCount = MAXFLOAT;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeBackwards;
    return anim;
}

/// 判断是否需要滚动
- (void)checkShouldAnimation {
    // 真正的宽度
    CGFloat realWidth = [ECPublicConfiguration calculateTextWidthWithFont:_textFont Text:_text];
    
    if (_isSelected && realWidth > self.widthKM) {
        // 需要滚动展示
        _titleLabel.widthKM = _titleLabel_copy.widthKM = realWidth;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [self startScroolAction];
    } else {
        _titleLabel.widthKM = _titleLabel_copy.widthKM = self.widthKM;
        _titleLabel.textAlignment = _textAlignment;
        [self stopScrollAction];
    }
}

#pragma mark - Setter
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _titleLabel.textColor = _titleLabel_copy.textColor = _textColor;
}
- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    _titleLabel.font = _titleLabel_copy.font = _textFont;
}
- (void)setText:(NSString *)text {
    _text = text;
    _titleLabel.text = _titleLabel_copy.text = text;
    
    [self checkShouldAnimation];
}
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    [self checkShouldAnimation];
}
- (void)setMaxContainerWidth:(CGFloat)maxContainerWidth {
    _maxContainerWidth = maxContainerWidth;
    self.widthKM = maxContainerWidth;
    [self checkShouldAnimation];
}

@end

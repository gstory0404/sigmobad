//
//  SigmobNativeAdCustomView.m
//  Pods-Runner
//
//  Created by gstory on 2022/8/25.
//

#import "SigmobNativeAdCustomView.h"

@implementation SigmobNativeAdCustomView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.CTAButton];
    [self addSubview:self.mainImageView];
}


#pragma mark - proerty getter

- (UIImageView *)mainImageView {
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _mainImageView.userInteractionEnabled = YES;
    }
    return _mainImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.accessibilityIdentifier = @"titleLabel_id";
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.accessibilityIdentifier = @"descLabel_id";
    }
    return _descLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.accessibilityIdentifier = @"iconImageView_id";
    }
    return _iconImageView;
}

- (UIButton *)CTAButton {
    if (!_CTAButton) {
        _CTAButton = [[UIButton alloc] init];
        _CTAButton.accessibilityIdentifier = @"CTAButton_id";
        _CTAButton.backgroundColor = UIColor.whiteColor;
        [_CTAButton setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
        _CTAButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _CTAButton.layer.masksToBounds = YES;
        _CTAButton.layer.cornerRadius = 5;
        _CTAButton.layer.borderColor = UIColor.systemBlueColor.CGColor;
        _CTAButton.layer.borderWidth = 1;
    }
    return _CTAButton;
}

- (void)dealloc {
   
}

@end

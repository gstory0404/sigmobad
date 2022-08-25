//
//  NativeAdViewStyle.m
//  sigmobad
//
//  Created by gstory on 2022/8/25.
//

#import "NativeAdViewStyle.h"
#import "SigmobNativeAdCustomView.h"
#import "SDWebImage.h"
#import <WindSDK/WindSDK.h>
#import "Masonry.h"

static CGFloat const margin = 15;
//static CGSize const logoSize = {15, 15};
static UIEdgeInsets const padding = {10, 15, 10, 15};

@implementation NativeAdViewStyle

+ (void)layoutWithModel:(WindNativeAd *)nativeAd adView:(SigmobNativeAdCustomView *)adView {
    if (nativeAd.feedADMode == WindFeedADModeLargeImage) {
        [self renderAdWithLargeImg:nativeAd adView:adView];
    }else if (nativeAd.feedADMode == WindFeedADModeVideo || nativeAd.feedADMode == WindFeedADModeVideoPortrait || nativeAd.feedADMode == WindFeedADModeVideoLandSpace) {
        [self renderAdWithVideo:nativeAd adView:adView];
    }
}

+ (CGFloat)cellHeightWithModel:(WindNativeAd *)nativeAd width:(CGFloat)width {
    if (nativeAd.feedADMode == WindFeedADModeLargeImage) {
        return [self cellLargeImageHeightWithModel:nativeAd width:width];
    }else if (nativeAd.feedADMode == WindFeedADModeVideo || nativeAd.feedADMode == WindFeedADModeVideoPortrait || nativeAd.feedADMode == WindFeedADModeVideoLandSpace) {
        return [self cellVideoHeightWithModel:nativeAd width:width];
    }
    return 0;
}

+ (CGFloat)cellLargeImageHeightWithModel:(WindNativeAd *)nativeAd width:(CGFloat)width {
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat imageHeight = 170;
    CGSize iconSize = CGSizeMake(60, 60);
    NSAttributedString *attributedDescText = [self titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    
    return imageHeight + descSize.height + iconSize.height + 80;
}

+ (CGFloat)cellVideoHeightWithModel:(WindNativeAd *)nativeAd width:(CGFloat)width {
    CGFloat videoRate = 9.0 / 16.0;//高宽比
    if (nativeAd.feedADMode == WindFeedADModeVideoPortrait) {
        videoRate = 16.0 / 9.0;
    }
    if (videoRate > 1.0) {
        videoRate = 1.0;
    }
    CGFloat contentWidth = (width - 2 * margin);
    NSAttributedString *attributedDescText = [self titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    return contentWidth + descSize.height + 140;
}

+ (NSAttributedString *)titleAttributeText:(NSString *)text {
    if (text == nil) {
        return nil;
    }
    NSMutableDictionary *attribute = @{}.mutableCopy;
    NSMutableParagraphStyle * titleStrStyle = [[NSMutableParagraphStyle alloc] init];
    titleStrStyle.lineSpacing = 5;
    titleStrStyle.alignment = NSTextAlignmentJustified;
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:17.f];
    attribute[NSParagraphStyleAttributeName] = titleStrStyle;
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

+ (void)renderAdWithLargeImg:(WindNativeAd *)nativeAd adView:(SigmobNativeAdCustomView *)adView{
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat imageHeight = 170;
    [adView bindImageViews:@[adView.mainImageView] placeholder:nil];
    [adView.mainImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.mainImageView.superview).offset(padding.top);
        make.left.equalTo(adView.mainImageView.superview).offset(padding.left);
        make.right.equalTo(adView.mainImageView.superview).offset(-padding.right);
        make.height.mas_equalTo(imageHeight);
    }];
    
    CGSize iconSize = CGSizeMake(60, 60);
    NSURL *iconUrl = [NSURL URLWithString:nativeAd.iconUrl];
    adView.iconImageView.layer.masksToBounds = YES;
    adView.iconImageView.layer.cornerRadius = 10;
    [adView.iconImageView sd_setImageWithURL:iconUrl];
    
    [adView.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(iconSize);
        make.top.equalTo(adView.mainImageView.mas_bottom).offset(10);
        make.left.equalTo(adView.iconImageView.superview).offset(padding.left);
    }];

    NSAttributedString *attributedText = [self titleAttributeText:nativeAd.title];
    adView.titleLabel.attributedText = attributedText;
    adView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [adView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.left.equalTo(adView.iconImageView.mas_right).offset(padding.left);
        make.right.equalTo(adView.CTAButton.mas_left).offset(-padding.right);
        make.height.equalTo(@30);
    }];
    
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    [adView.CTAButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.right.equalTo(adView.CTAButton.superview).offset(-padding.right);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    NSAttributedString *attributedDescText = [self titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    adView.descLabel.attributedText = attributedDescText;
    adView.descLabel.numberOfLines = 0;
    adView.descLabel.textColor = UIColor.blackColor;
    [adView.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_bottom).offset(10);
        make.left.equalTo(adView.descLabel.superview).offset(padding.left);
        make.right.equalTo(adView.descLabel.superview).offset(-padding.right);
        make.height.equalTo(@(descSize.height));
    }];
    
    [adView.dislikeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(adView).offset(-10);
        make.right.equalTo(adView).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    UIView *logoView = (UIView *)adView.logoView;
    [logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(logoView.superview).offset(-10);
        make.left.equalTo(logoView.superview).offset(10);
        make.width.equalTo(@(70));
        make.height.equalTo(@(20));
    }];
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(adView.superview).offset(0);
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width);
        make.height.mas_equalTo(imageHeight + descSize.height + iconSize.height + 80);
    }];
    
    [adView setClickableViews:@[adView.CTAButton, adView.mainImageView, adView.iconImageView]];
}

+ (void)renderAdWithVideo:(WindNativeAd *)nativeAd adView:(SigmobNativeAdCustomView *)adView{

    CGFloat videoRate = 9.0 / 16.0;//高宽比
    if (nativeAd.feedADMode == WindFeedADModeVideoPortrait) {
        videoRate = 16.0 / 9.0;
    }
    if (videoRate > 1.0) {
        videoRate = 1.0;
    }
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat y = padding.top;
    
    CGSize iconSize = CGSizeMake(60, 60);
    NSURL *iconUrl = [NSURL URLWithString:nativeAd.iconUrl];
    adView.iconImageView.layer.masksToBounds = YES;
    adView.iconImageView.layer.cornerRadius = 10;
    [adView.iconImageView sd_setImageWithURL:iconUrl];
    adView.iconImageView.frame = CGRectMake(padding.left, y, iconSize.width, iconSize.height);
    
    NSAttributedString *attributedText = [self titleAttributeText:nativeAd.title];
    adView.titleLabel.attributedText = attributedText;
    adView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [adView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.left.equalTo(adView.iconImageView.mas_right).offset(padding.left);
        make.right.equalTo(adView.CTAButton.mas_left).offset(-padding.right);
        make.height.equalTo(@30);
    }];
    
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    [adView.CTAButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.right.equalTo(adView.CTAButton.superview).offset(-padding.right);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    
    NSAttributedString *attributedDescText = [self titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    adView.descLabel.attributedText = attributedDescText;
    adView.descLabel.numberOfLines = 0;
    adView.descLabel.textColor = UIColor.blackColor;
    [adView.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_bottom).offset(10);
        make.left.equalTo(adView.descLabel.superview).offset(padding.left);
        make.right.equalTo(adView.descLabel.superview).offset(-padding.right);
        make.height.equalTo(@(descSize.height));
    }];
    
    [adView.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.descLabel.mas_bottom).offset(10);
        make.left.equalTo(adView.mediaView.superview).offset(padding.left);
        make.right.equalTo(adView.mediaView.superview).offset(-padding.right);
        make.height.equalTo(adView.mediaView.mas_width).multipliedBy(videoRate);
    }];
    
    UIView *logogView = (UIView *)adView.logoView;
    [logogView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(logogView.superview).offset(-10);
        make.left.equalTo(logogView.superview).offset(10);
        make.width.equalTo(@(70));
        make.height.equalTo(@(20));
    }];
    
    [adView.dislikeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(adView).offset(-10);
        make.right.equalTo(adView).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    [adView setClickableViews:@[adView.CTAButton, adView.mediaView]];
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(adView.superview).offset(0);
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width);
        make.height.mas_equalTo(adView.mediaView.mas_height).offset(descSize.height + 140);
    }];
}

@end

//
//  PromptModalView.h
//  bookhelper
//
//  Created by Luke on 7/6/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PromptModalView : UIView<UIScrollViewDelegate> {
    CGFloat     indicatorWidth;
    CGFloat     indicatorHeight;
    
    UIScrollView                *scrollView;
    UIView                      *maskView;
    UIView                      *backView;
    UIActivityIndicatorView     *activityView;
    UILabel                     *textLabel;
    
    UIImageView                 *imageView;
}

- (void)animateToHide;
- (void)animateShowInView:(UIView *)view autoHideAfter:(float)interval;

- (void)sizeToIndicator;

- (void)setIndicatorImage:(UIImage *)image;

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) CGFloat indicatorWidth, indicatorHeight;
@property (nonatomic, retain) UILabel *textLabel;

@end

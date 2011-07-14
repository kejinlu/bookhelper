//
//  PromptModalView.m
//  bookhelper
//
//  Created by Luke on 7/6/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "PromptModalView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PromptModalView
@synthesize indicatorWidth, indicatorHeight;
@synthesize textLabel;
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.userInteractionEnabled = YES;
        
        indicatorWidth = 120.0;
        indicatorHeight = 120.0;
        
        CGSize size = frame.size;
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(floor((size.width-indicatorWidth)/2.0),
                                                                    floor((size.height-indicatorHeight)/2.0),
                                                                    indicatorWidth,
                                                                    indicatorHeight)];
        scrollView.scrollEnabled = NO;
        scrollView.contentMode = UIViewContentModeCenter;
        scrollView.minimumZoomScale = 0.1;
        scrollView.maximumZoomScale = 2;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(indicatorWidth, indicatorHeight);
        scrollView.zoomScale = 1.0;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:scrollView];
        
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, indicatorWidth, indicatorHeight)];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.layer.cornerRadius = 8.0;
        maskView.autoresizingMask = 0x111111b;
        maskView.alpha = 0.7;
        [scrollView addSubview:maskView];
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, indicatorWidth, indicatorHeight)];
        [scrollView addSubview:backView];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [activityView sizeToFit];

		activityView.center = CGPointMake(floor(indicatorWidth/2.0), floor(indicatorHeight/2.0-activityView.bounds.size.height/4.0));

        [activityView startAnimating];
        [backView addSubview:activityView];
        

		textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, floor(indicatorHeight/2.0+6), indicatorWidth, 25.0)];
		textLabel.textAlignment = UITextAlignmentCenter;
		textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		textLabel.contentMode = UIViewContentModeRedraw;
		textLabel.text = @"正在加载";
		textLabel.adjustsFontSizeToFitWidth = NO;
		textLabel.font = [UIFont boldSystemFontOfSize:12.0];
		textLabel.textColor = [UIColor whiteColor];
		textLabel.backgroundColor = [UIColor clearColor];
		[backView addSubview:textLabel];
        
    }
	
    return self;
}

#pragma mark -

- (void)setImageView:(UIImageView *)imgView {
    [imgView retain];
    [imageView release];
    imageView = imgView;
    
    [activityView removeFromSuperview];
    
	imageView.center = CGPointMake(floor(indicatorWidth/2.0), floor(indicatorHeight/2.0-imageView.bounds.size.height/4.0));
    
    [backView addSubview:imageView];
}

- (void)setIndicatorImage:(UIImage *)image {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.bounds = CGRectMake(0, 0, 20, 20);
    self.imageView = imgView;
    [imgView release];
}

#pragma mark -
#pragma mark Layout

- (void)sizeToIndicator {
    CGRect rect = self.frame;
    self.frame = CGRectInset(rect,
                             floor((rect.size.width-indicatorWidth)/2.0),
                             floor((rect.size.height-indicatorHeight)/2.0));
}

- (void)resetView {
    [self removeFromSuperview];
    
    scrollView.bounds = CGRectMake(0, 0, indicatorWidth, indicatorHeight);
    scrollView.zoomScale = 1;
    maskView.alpha = 0.7;
}

#pragma mark -
#pragma mark Actions

- (void)animateShowInView:(UIView *)view autoHideAfter:(float)interval {
    [self removeFromSuperview];
    
    scrollView.bounds = CGRectMake(0, 0, floor(indicatorWidth*1.5), floor(indicatorHeight*1.5));
    scrollView.zoomScale = 1.5;
    maskView.alpha = 0;
    
    [view addSubview:self];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    scrollView.bounds = CGRectMake(0, 0, indicatorWidth, indicatorHeight);
    scrollView.zoomScale = 1;
    maskView.alpha = 0.7;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(animateToHide) withObject:nil afterDelay:0.2 + interval];
}

- (void)animateToHide {
    if (!self.superview) {
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    scrollView.bounds = CGRectZero;
    scrollView.zoomScale = 0.1;
    maskView.alpha = 0;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(resetView) withObject:nil afterDelay:0.2];
}

#pragma mark -
#pragma mark UISCrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return backView;
}

#pragma mark -

- (void)dealloc {
    [activityView release];
    [textLabel release];
    [backView release];
    [scrollView release];
    [imageView release];
    [maskView release];
    [super dealloc];
}

@end

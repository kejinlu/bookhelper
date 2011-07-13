/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#define ACTIVITY_INDICATOR_TAG 100

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
	
    self.image = placeholder;
    if (url)
    {
		//如果url存在，则添加等待标示
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
		activityIndicator.tag = ACTIVITY_INDICATOR_TAG;
		[activityIndicator startAnimating];
		[self addSubview:activityIndicator];
		[activityIndicator release];
		
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
	
	UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self viewWithTag:ACTIVITY_INDICATOR_TAG];
	if (activityIndicator) {
		[activityIndicator removeFromSuperview];
	}
	
    self.image = image;
}

@end

//
//  ASImageView.m
//  bookhelper
//
//  Created by Luke on 7/1/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "ASImageView.h"
#import "NSString+URLEncoding.h"
#import "ASIDownloadCache.h"
@implementation ASImageView
@synthesize urlString;
@synthesize placeHolderImage;

- (void)setUrlString:(NSString *)_urlString{
	
	if (_urlString && [_urlString isEqualToString:urlString]) {
		return;
	}
	
	if (urlString) {
		[urlString release];
		urlString = nil;
	}
	
	urlString = [_urlString copy];
	
	if (myRequest) {
		[myRequest cancel];
		[myRequest release];
		myRequest = nil;
	}
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
	myRequest = [request retain];
	request.delegate = self;
	request.cachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
	request.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
	ASIDownloadCache *downloadCache = [ASIDownloadCache sharedCache];
	request.downloadCache = downloadCache;
	self.image = self.placeHolderImage;
	[request startAsynchronous];	
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	UIImage *responseImage = [UIImage imageWithData:[request responseData]];
	self.image = responseImage;
}

@end

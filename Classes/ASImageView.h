//
//  ASImageView.h
//  bookhelper
//
//  Created by Luke on 7/1/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//
#import "ASIHTTPRequest.h"

@interface ASImageView : UIImageView {
	NSString *urlString;
	UIImage *placeHolderImage;
	ASIHTTPRequest *myRequest;
}

@property(nonatomic,copy) NSString *urlString;
@property(nonatomic,retain) UIImage *placeHolderImage;

@end

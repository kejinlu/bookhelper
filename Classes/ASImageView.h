//
//  ASImageView.h
//  bookhelper
//
//  Created by Luke on 7/1/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

@interface ASImageView : UIImageView {
	NSString *urlString;
	UIImage *placeHolderImage;
}

@property(nonatomic,copy) NSString *urlString;
@property(nonatomic,retain) UIImage *placeHolderImage;

@end

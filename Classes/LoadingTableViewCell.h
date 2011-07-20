//
//  LoadingTableViewCell.h
//  bookhelper
//
//  Created by Luke on 7/5/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingTableViewCell : UITableViewCell {
	UIActivityIndicatorView *indicator;
	UILabel *loadingLabel;
}
@property(nonatomic,retain) UIActivityIndicatorView *indicator;
@property(nonatomic,retain) UILabel *loadingLabel;
@end 

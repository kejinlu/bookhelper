//
//  BookDetailItemCell.h
//  bookhelper
//
//  Created by Luke on 7/11/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookDetailItemCell : UITableViewCell {
	UIImageView *iconImageView;
	UILabel *nameLabel;
}

- (void)setName:(NSString *)name;
- (void)setIconImage:(UIImage *)icon;
@end

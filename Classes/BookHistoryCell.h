//
//  BookHistoryCell.h
//  bookhelper
//
//  Created by Luke on 7/11/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "TableUIButton.h"
#import "BookGetHistory.h"

@interface BookHistoryCell : UITableViewCell {
	TableUIButton *starButton;
	UIImageView *starImageView;
	UILabel *bookTitleLabel;
	UILabel *bookInfoLabel;
	
	BookGetHistory *bookHistory;
}
@property(nonatomic,retain) TableUIButton *starButton;
@property(nonatomic,retain) BookGetHistory *bookHistory;

- (void)addStarTarget:(id)target action:(SEL)action;
@end

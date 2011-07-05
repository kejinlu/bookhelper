//
//  ContinuousTableView.m
//  bookhelper
//
//  Created by Luke on 7/6/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "ContinuousTableView.h"


@implementation ContinuousTableView
@synthesize isLoading;
@synthesize isLoadFailed;
@synthesize end;

- (void)setIsLoadFailed:(BOOL)isFailed{
	isLoadFailed = isFailed;
	[self reloadData];
}

- (LoadingTableViewCell *)dequeueReusableLoadingCell{
	static NSString *CellIdentifier = @"LoadingCell";
	
    LoadingTableViewCell *cell = (LoadingTableViewCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[LoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[cell.indicator startAnimating];
    if (isLoadFailed) {
        cell.loadingLabel.text = @"加载失败";    
        
    } else {
        cell.loadingLabel.text = @"正在加载...";        
    }
	
	if (end) {
		[cell.indicator stopAnimating];
		cell.loadingLabel.text = @"~";
	}
	
    return cell;
}

@end

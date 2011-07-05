//
//  ContinuousTableView.h
//  bookhelper
//
//  Created by Luke on 7/6/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadingTableViewCell.h"

@interface ContinuousTableView : UITableView {
	BOOL isLoading;//是否正在加载
	BOOL isLoadFailed;//是否加载失败
	BOOL end;

}
@property(nonatomic,assign) BOOL isLoading;
@property(nonatomic,assign) BOOL isLoadFailed;
@property(nonatomic,assign) BOOL end;

- (LoadingTableViewCell *)dequeueReusableLoadingCell;
@end

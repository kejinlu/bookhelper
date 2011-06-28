//
//  DoubanURLConnection.h
//  bookhelper
//
//  Created by Luke on 6/23/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

typedef enum  {
	DOUBAN_BOOK = 0,
	DOUBAN_BOOKS
} DoubanConnectionType;

@interface DoubanURLConnection : NSURLConnection {
	DoubanConnectionType type;
}

@property(assign)DoubanConnectionType type;
@end

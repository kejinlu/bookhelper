//
//  BookPriceComparisonViewController.h
//  bookhelper
//
//  Created by Luke on 6/24/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookPriceComparisonViewController : UIViewController {
	NSArray *bookStoreLogoNames;
	NSArray *prices;
	NSString *subjectId;
	
	IBOutlet UITableView *priceTableView;
}

@property(nonatomic,copy) NSString *subjectId;
- (void)didGetPrices:(NSArray *)priceArray;
@end

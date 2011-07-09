//
//  BookPriceComparisonViewController.h
//  bookhelper
//
//  Created by Luke on 6/24/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookPriceComparisonViewController : UIViewController {

	NSString *subjectId;	
	IBOutlet UIWebView *priceWebView;
}

@property(nonatomic,copy) NSString *subjectId;

- (void)didGetPriceHTML:(NSString *)htmlString;

@end

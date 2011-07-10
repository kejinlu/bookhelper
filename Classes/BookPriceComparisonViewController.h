//
//  BookPriceComparisonViewController.h
//  bookhelper
//
//  Created by Luke on 6/24/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromptModalView.h"

@interface BookPriceComparisonViewController : UIViewController<UIWebViewDelegate> {

	NSString *subjectId;	
	IBOutlet UIWebView *priceWebView;
	
	PromptModalView *modalView;
}

@property(nonatomic,copy) NSString *subjectId;

- (void)didGetPriceHTML:(NSString *)htmlString;

@end

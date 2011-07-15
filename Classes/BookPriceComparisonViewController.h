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

	UIWebView *priceWebView;

	NSString *subjectId;		
	PromptModalView *modalView;
	NSString *connectionUUID;
}
@property(nonatomic,retain)IBOutlet UIWebView *priceWebView;
@property(nonatomic,copy) NSString *subjectId;

- (void)didGetPriceHTML:(NSDictionary *)userInfo;

@end

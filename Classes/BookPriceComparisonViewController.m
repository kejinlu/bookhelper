//
//  BookPriceComparisonViewController.m
//  bookhelper
//
//  Created by Luke on 6/24/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookPriceComparisonViewController.h"
#import "DoubanConnector.h"


@implementation BookPriceComparisonViewController
@synthesize subjectId;

- (id)init{
	if (self = [super initWithNibName:@"BookPriceComparisonView" bundle:nil]) {
		//do 
	}
	return self;
}

- (void)dealloc{
	if (modalView) {
		[modalView release];
	}
	[super dealloc];
}

- (void)viewDidLoad{
	priceWebView.delegate = self;

	if (modalView == nil) {    
		modalView = [[PromptModalView alloc] initWithFrame:self.view.bounds];
	}
	
	[self.view addSubview:modalView];
	
	[[DoubanConnector sharedDoubanConnector] requestBookPriceHTMLWithBookId:subjectId
															 responseTarget:self
															 responseAction:@selector(didGetPriceHTML:)];
}

- (void)didGetPriceHTML:(NSString *)htmlString{
	NSString *html = [NSString stringWithFormat:@"<head><link href=\"prices.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body>%@</body>",htmlString];
	[priceWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}


#pragma mark web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {    
	[modalView animateToHide];
	[modalView release];
	modalView = nil;
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
	
    return YES;
}
@end

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
@synthesize priceWebView;
@synthesize subjectId;

- (id)init{
	if (self = [super initWithNibName:@"BookPriceComparisonView" bundle:nil]) {
		//do 
	}
	return self;
}

- (void)dealloc{
	BH_RELEASE(priceWebView);
	BH_RELEASE(modalView);
	BH_RELEASE(connectionUUID);
	[super dealloc];
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
		// back button was pressed.  We know this is true because self is no longer
		// in the navigation stack. 
		[[DoubanConnector sharedDoubanConnector] removeConnectionWithUUID:connectionUUID];
    }
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad{
	priceWebView.delegate = self;

	if (modalView == nil) {    
		modalView = [[PromptModalView alloc] initWithFrame:self.view.bounds];
	}
	
	[self.view addSubview:modalView];
	BH_RELEASE(connectionUUID);
	connectionUUID = [[[DoubanConnector sharedDoubanConnector] requestBookPriceHTMLWithBookId:subjectId
															 responseTarget:self
															 responseAction:@selector(didGetPriceHTML:)] retain];
}

- (void)viewDidUnload{
	self.priceWebView = nil;
	[super viewDidUnload];
}

- (void)didGetPriceHTML:(NSDictionary *)userInfo{
	NSError *error = [userInfo objectForKey:@"error"];
	if (error) {
		[modalView removeFromSuperview];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" 
														message:[error localizedDescription]
													   delegate:self 
											  cancelButtonTitle:@"知道了" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	NSString *htmlString = [userInfo objectForKey:@"html"];
	htmlString = htmlString ? htmlString : @"对不起,本书没有比价数据...";
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

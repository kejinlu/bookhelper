//
//  BarCodeScannerViewController.m
//  bookhelper
//
//  Created by Luke on 6/25/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BarCodeScannerViewController.h"
#import "ScannerOverlayView.h"
#import "BookGetHistoryDatabase.h"
@implementation BarCodeScannerViewController


- (id)initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]) {
		barReaderViewController = [ZBarReaderViewController new];
		[barReaderViewController setShowsZBarControls:NO];
		barReaderViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
		barReaderViewController.showsCameraControls = NO;
		barReaderViewController.readerDelegate = self;
		
		ZBarImageScanner *scanner = barReaderViewController.scanner;

		[scanner setSymbology: ZBAR_ISBN10
					   config: ZBAR_CFG_ENABLE
						   to: 1];
		[scanner setSymbology: ZBAR_ISBN13
					   config: ZBAR_CFG_ENABLE
						   to: 1];
		
		// disable rarely used i2/5 to improve performance
		[scanner setSymbology: ZBAR_I25
					   config: ZBAR_CFG_ENABLE
						   to: 0];
		
		
		loadingViewController = [[LoadingViewController alloc] init];

		
		
	}
	return self;
}

-(void)viewDidLoad{
	UIView *barReaderView = [barReaderViewController view];
	barReaderView.frame = CGRectMake(0.0, 0.0, 320.0, 367.0);
	ScannerOverlayView *overlay = [[ScannerOverlayView alloc]initWithFrame:[barReaderView bounds]];
	[barReaderViewController setCameraOverlayView:overlay];
}

- (void) initAudio
{
    if(beep)
        return;
    NSError *error = nil;
    beep = [[AVAudioPlayer alloc]
			initWithContentsOfURL:
			[[NSBundle mainBundle]
			 URLForResource: @"scan"
			 withExtension: @"wav"]
			error: &error];
    if(!beep)
        NSLog(@"ERROR loading sound: %@: %@",
              [error localizedDescription],
              [error localizedFailureReason]);
    else {
        beep.volume = .5f;
        [beep prepareToPlay];
    }
}

- (void) playBeep
{
    if(!beep)
        [self initAudio];
    [beep play];
}


- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[[self view] addSubview:[barReaderViewController view]];
	[barReaderViewController viewWillAppear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
}

- (void)viewDidDisappear{
	[[barReaderViewController view] removeFromSuperview];
}


- (void)  imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info
{
	if (searching) {
		return;
	}
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
	
    id <NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *sym = nil;
    for(sym in results)
        break;
    assert(sym);
    assert(image);
	NSLog(@"%@",sym.data);
    if(!sym || !image)
        return;
	
	if (sym.type != ZBAR_ISBN13 && sym.type != ZBAR_ISBN10) {
		return;
	}
	[self performSelector: @selector(playBeep)
			   withObject: nil
			   afterDelay: 0.0];

	[[DoubanConnector sharedDoubanConnector] requestBookDataWithISBN:sym.data
													  responseTarget:self
													  responseAction:@selector(didGetDoubanBook:)];
	searching = YES;
	[[self view] addSubview:[loadingViewController view]];
	
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry{
	
}


- (void)didGetDoubanBook:(DoubanBook *)book{
	if (!bookDetailViewController) {
		bookDetailViewController = [[BookDetailViewController alloc] init];
		bookDetailViewController.title = @"图书详情";
		//bookDetailViewController.navigationController = [self navigationController];
	}
	//加入历史记录
	[[BookGetHistoryDatabase sharedInstance] addBookHistory:book]; 

	bookDetailViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Books" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissView:)];
	bookDetailViewController.book = book;
	
	[[self navigationController ] pushViewController:bookDetailViewController animated:YES];
	[[loadingViewController view] removeFromSuperview];
	searching = NO;
}

- (IBAction)dismissView:(id)sender{
	[[self navigationController ] popViewControllerAnimated:YES];
}
@end

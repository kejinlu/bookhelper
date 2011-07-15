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

- (void)viewDidLoad{
	[super viewDidLoad];
	
	[self initBarReaderViewController];
	[self initAudio];

	//set frame
	UIView *barReaderView = [barReaderViewController view];
	barReaderView.frame = CGRectMake(0.0, 0.0, 320.0, 367.0);
	
	//add overlay for barReaderView
	ScannerOverlayView *overlay = [[ScannerOverlayView alloc] initWithFrame:[barReaderView bounds]];
	[barReaderViewController setCameraOverlayView:overlay];
	[overlay release];
	
	[[self view] addSubview:barReaderView];
	[barReaderViewController.readerView start];//start scanning
}

- (void)viewDidUnload{
	[super viewDidUnload];
	if (barReaderViewController) {
		BH_RELEASE(barReaderViewController);
	}
	if (beep) {
		BH_RELEASE(beep);
	}
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	isScannerAvailable = YES;
}


- (void)initBarReaderViewController{
	barReaderViewController = [ZBarReaderViewController new];
	[barReaderViewController setShowsZBarControls:NO];
	barReaderViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
	barReaderViewController.showsCameraControls = NO;
	barReaderViewController.readerDelegate = self;
	barReaderViewController.readerView.torchMode = 0;
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
}

- (void)initAudio
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


- (void)  imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info
{
	if (!isScannerAvailable) {
		return;
	}
	isScannerAvailable = NO;
	
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
		isScannerAvailable = YES;
		return;
	}
	
	[self performSelector: @selector(playBeep)
			   withObject: nil
			   afterDelay: 0.0];
	BookDetailViewController *bookDetailViewController = [[BookDetailViewController alloc] init];
	bookDetailViewController.isbn = sym.data;
	bookDetailViewController.isRecord = YES;
	bookDetailViewController.navigationItem.title = @"图书详情";
	[[self navigationController ] pushViewController:bookDetailViewController animated:YES];
	[bookDetailViewController release];
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry{
	
}




@end

//
//  BookGetHistoryViewController.m
//  bookhelper
//
//  Created by Luke on 6/29/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookGetHistoryViewController.h"
#import "BookGetHistory.h"
#import "BookGetHistoryDatabase.h"
#import "TableUIButton.h"
#import "GradientView.h"
#import "UIImage+Scale.h"
#import "DoubanConnector.h"
#import "DoubanBook.h"
#define TRASH_ACTION_SHEET 100
@implementation BookGetHistoryViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]) {
		totalPages = 0;
		pageNumber = 1;
		filterByStarred = NO;
		histories = [[NSMutableArray alloc] init];
		totalPages = [[BookGetHistoryDatabase sharedInstance] totalPagesFilterByStarred:filterByStarred];
		loadingViewController = [[LoadingViewController alloc] init];
	}
	return self;
}

- (void)dealloc{
	[histories release];
	[super dealloc];
}


- (void)checkNavigationItemButtons{
	if (totalPages > 0) {
		[self cancel:self];
		
		UIBarButtonItem *trashButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
																					  target:self
																					  action:@selector(launchTrashMenu)] autorelease];
		self.navigationItem.rightBarButtonItem = trashButton;		
		
		UISegmentedControl *segmentedControl = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"所有",@"标注",nil]] autorelease];
	    [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
		[segmentedControl setWidth:80 forSegmentAtIndex:0];
		[segmentedControl setWidth:80 forSegmentAtIndex:1];
		[segmentedControl addTarget:self action:@selector(segmentSwitch:) forControlEvents:UIControlEventValueChanged];
		[self navigationItem].titleView = segmentedControl;		 
	}
}

- (void)viewDidLoad{
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(reloadFromDB:) 
												 name:@"ReloadHistoryNotification"  
											   object:nil];
	[self checkNavigationItemButtons];
	UISegmentedControl *segmentControl = (UISegmentedControl *)[self navigationItem].titleView;
	segmentControl.selectedSegmentIndex = 0;
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[historyTable deselectRowAtIndexPath:[historyTable indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark tableView datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger historyCount = [histories count];
    return historyCount ? historyCount + 1: historyCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	if (indexPath.row < [histories count]) {
		static NSString *CellIdentifier = @"BookCell";
		cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.backgroundView = [[[GradientView alloc] initWithGradientType:WHITE_GRADIENT] autorelease];
			cell.selectedBackgroundView = [[[GradientView alloc] initWithGradientType:GREEN_GRADIENT] autorelease];
			
			TableUIButton *starButton = [TableUIButton buttonWithType:UIButtonTypeCustom];
			starButton.frame = CGRectMake(0, 0, 52, 52);
			starButton.tag = STAR_BUTTON;
			[starButton addTarget:self action:@selector(starHistory:) forControlEvents:UIControlEventTouchUpInside];
			[cell.contentView addSubview:starButton];
			
			UILabel	*myTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 6, 240, 20)];
			myTextLabel.tag = BOOK_TITLE;
			myTextLabel.backgroundColor = [UIColor clearColor];
			myTextLabel.highlightedTextColor = [UIColor whiteColor];
			myTextLabel.textColor = [UIColor blackColor];
			myTextLabel.textAlignment = UITextAlignmentLeft;
			myTextLabel.font = [UIFont systemFontOfSize:16];
			[cell.contentView addSubview:myTextLabel];
			
			UILabel	*myDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 28, 240, 20)];
			myDetailLabel.tag = BOOK_INFO;
			myDetailLabel.backgroundColor = [UIColor clearColor];
			myDetailLabel.textColor = [UIColor grayColor];
			myDetailLabel.highlightedTextColor = [UIColor whiteColor];
			myDetailLabel.textAlignment = UITextAlignmentLeft;
			myDetailLabel.font = [UIFont systemFontOfSize:12];
			[cell.contentView addSubview:myDetailLabel];
			[myTextLabel release];
			[myDetailLabel release];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.textLabel.backgroundColor = [UIColor clearColor];
		}
		TableUIButton *starButton = (TableUIButton *)[cell viewWithTag:STAR_BUTTON];
		UILabel *textLabel = (UILabel *)[cell viewWithTag:BOOK_TITLE];
		UILabel	*detailLabel = (UILabel *)[cell viewWithTag:BOOK_INFO];
		BookGetHistory *history = (BookGetHistory *)[histories objectAtIndex:indexPath.row];
		[starButton setImage:[[UIImage imageNamed:history.starred ? @"star.png" : @"unstar.png"] imageScaledToSize:CGSizeMake(16, 16)] 
					forState:UIControlStateNormal];
		starButton.row = indexPath.row;
		textLabel.text = history.bookTitle;
		
		if (history.author) {
			detailLabel.text = history.author;
		}
		if (history.publisher) {
			detailLabel.text = [detailLabel.text stringByAppendingFormat:@" / %@",history.publisher];
		}
		if (history.pubDate) {
			detailLabel.text = [detailLabel.text stringByAppendingFormat:@" %@",history.pubDate];
		}
	}else {
		if (pageNumber + 1 > totalPages) {
			historyTable.end = YES;
		}else {
			historyTable.end = NO;
		}

		cell = [historyTable  dequeueReusableLoadingCell];
		if (!historyTable.isLoading) {
			pageNumber += 1;
			if (pageNumber <= totalPages) {
				[self performSelector:@selector(loadMore) withObject:nil afterDelay:0.1]; 
			}
        }
	}


    return cell;
}


//编辑之后的delegate方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		BookGetHistory *history = [histories objectAtIndex:indexPath.row];
		if ([[BookGetHistoryDatabase sharedInstance] deleteBookHistoryWithUID:history.uid]) {
			[histories removeObject:history];
			[historyTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:YES];
		}
	}
}


#pragma mark -
#pragma mark tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 52.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	BookGetHistory *history = [histories objectAtIndex:indexPath.row];
	[[DoubanConnector sharedDoubanConnector] requestBookDataWithISBN:history.isbn
													  responseTarget:self 
													  responseAction:@selector(didGetDoubanBook:)];
	[[self view] addSubview:[loadingViewController view]];
}


- (void)loadMore {
	if (pageNumber <= totalPages) {
		historyTable.isLoading = YES;
		NSArray *results = [[BookGetHistoryDatabase sharedInstance] bookHistoriesOnPage:pageNumber
																		filterByStarred:filterByStarred];
		[histories addObjectsFromArray:results];
		[historyTable reloadData];
		historyTable.isLoading = NO;
	}

}

#pragma mark -
#pragma mark Did GeetBook
- (void)didGetDoubanBook:(DoubanBook *)book{
	if (!bookDetailViewController) {
		bookDetailViewController = [[BookDetailViewController alloc] init];
		bookDetailViewController.title = @"图书详情";
	}
	bookDetailViewController.book = book;
	[[loadingViewController view] removeFromSuperview];
	[[self navigationController ] pushViewController:bookDetailViewController animated:YES];
}

#pragma mark Button Action

- (void)edit:(id)sender {
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"完成"
																	  style:UIBarButtonItemStyleDone
																	 target:self
																	 action:@selector(cancel:)] autorelease];
	[self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
	[historyTable setEditing:YES animated:YES];
}

- (void)cancel:(id)sender {
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithTitle:@"编辑"
																	style:UIBarButtonItemStylePlain
																   target:self
																   action:@selector(edit:)] autorelease];
    [self.navigationItem setLeftBarButtonItem:editButton animated:YES];
    [historyTable setEditing:NO animated:YES];
}


- (void)launchTrashMenu{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil
													otherButtonTitles: @"删除未加星的",@"删除所有",nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
	[actionSheet setTag:TRASH_ACTION_SHEET];
	[actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
	[actionSheet release];
}

#pragma mark actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (actionSheet.tag == TRASH_ACTION_SHEET) {
		if (buttonIndex == 0) {
			//删除未加星的
		}else if (buttonIndex == 1) {
			//删除所有
		}
	}
	return;
}



- (void)starHistory:(id)sender{
	NSInteger row = ((TableUIButton *)sender).row;
	BookGetHistory *history = [histories objectAtIndex:row];
	BOOL starred = history.starred;
	if ([[BookGetHistoryDatabase sharedInstance] updateBookHistory:history WithStarred:!starred]) {
		history.starred = !starred;
		[historyTable reloadData];
	}
}


#pragma mark segment
- (void)segmentSwitch:(id)sender{
	UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
	NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
	switch (selectedSegment) {
		case 0:
			filterByStarred = NO;
			break;
		case 1:
			filterByStarred = YES;
			break;
		default:
			break;
	}
	[histories removeAllObjects];
	pageNumber = 1;
	totalPages = [[BookGetHistoryDatabase sharedInstance] totalPagesFilterByStarred:filterByStarred];
	NSArray *results = [[BookGetHistoryDatabase sharedInstance] bookHistoriesOnPage:pageNumber 
																	filterByStarred:filterByStarred];
	[histories addObjectsFromArray:results];
	[historyTable reloadData];
}



- (void)reloadFromDB:(NSNotification*)notification{
	[histories removeAllObjects];
	pageNumber = 1;
	totalPages = [[BookGetHistoryDatabase sharedInstance] totalPagesFilterByStarred:filterByStarred];
	NSArray *results = [[BookGetHistoryDatabase sharedInstance] bookHistoriesOnPage:pageNumber 
																	filterByStarred:filterByStarred];
	[histories addObjectsFromArray:results];
	[historyTable reloadData];
}
@end

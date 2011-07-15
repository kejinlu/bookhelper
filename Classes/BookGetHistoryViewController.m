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
#import "DoubanConnector.h"
#import "DoubanBook.h"
#import "BookHistoryCell.h"

#define TRASH_ACTION_SHEET 100
@implementation BookGetHistoryViewController
@synthesize historyTable;

- (id)initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]) {
		totalPages = 0;
		pageNumber = 1;
		filterByStarred = NO;
		histories = [[NSMutableArray alloc] init];
		totalPages = [[BookGetHistoryDatabase sharedInstance] totalPagesFilterByStarred:filterByStarred];
	}
	return self;
}

- (void)dealloc{
	[histories release];
	BH_RELEASE(historyTable);
	[super dealloc];
}


- (void)checkNavigationItemButtons{
	if (totalPages > 0) {
		[self cancel:self];
		
		UIBarButtonItem *trashButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
																					  target:self
																					  action:@selector(launchTrashMenu)] autorelease];
		self.navigationItem.rightBarButtonItem = trashButton;		
		
		UISegmentedControl *segmentedControl = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"所有",@"收藏夹",nil]] autorelease];
	    [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
		[segmentedControl setWidth:80 forSegmentAtIndex:0];
		[segmentedControl setWidth:80 forSegmentAtIndex:1];
		[segmentedControl addTarget:self action:@selector(segmentSwitch:) forControlEvents:UIControlEventValueChanged];
		[self navigationItem].titleView = segmentedControl;		 
	}
}

- (void)viewDidLoad{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(reloadFromDB:) 
												 name:@"ReloadHistoryNotification"  
											   object:nil];
	[self checkNavigationItemButtons];
	UISegmentedControl *segmentControl = (UISegmentedControl *)[self navigationItem].titleView;
	segmentControl.selectedSegmentIndex = 0;
}

- (void)viewDidUnload{
	self.historyTable = nil;
	[super viewDidUnload];
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
		static NSString *CellIdentifier = @"BookHistoryCell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell) {
			cell = [[[BookHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.backgroundView = [[[GradientView alloc] initWithGradientType:WHITE_GRADIENT] autorelease];
			cell.selectedBackgroundView = [[[GradientView alloc] initWithGradientType:GREEN_GRADIENT] autorelease];
			[(BookHistoryCell *)cell addStarTarget:self action:@selector(starHistory:)];
		}
		((BookHistoryCell *)cell).starButton.row = indexPath.row;
		((BookHistoryCell *)cell).bookHistory = [histories objectAtIndex:indexPath.row];
		
	}else {
		if (pageNumber + 1 > totalPages) {
			historyTable.end = YES;
		}else {
			historyTable.end = NO;
		}

		cell = [historyTable  dequeueReusableEndCell];
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

//禁止末尾的自定义行的删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row < [histories count]) {
		return UITableViewCellEditingStyleDelete;
	}else {
		return UITableViewCellEditingStyleNone;
	}

}
#pragma mark -
#pragma mark tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 52.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [histories count]) {
		BookGetHistory *history = [histories objectAtIndex:indexPath.row];
		NSString *isbnString = history.isbn;
		
		BookDetailViewController *bookDetailViewController = [[BookDetailViewController alloc] init];
		bookDetailViewController.title = @"图书详情";
		bookDetailViewController.isbn = isbnString;
		[[self navigationController ] pushViewController:bookDetailViewController animated:YES];
		[bookDetailViewController release];
	}

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



#pragma mark Button Action

- (void)edit:(id)sender {
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"完成"
																	  style:UIBarButtonItemStyleDone
																	 target:self
																	 action:@selector(cancel:)] autorelease];
	[self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
	[historyTable setEditing:YES animated:YES];
}

- (void)cancel:(id)sender {
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithTitle:@"编辑"
																	style:UIBarButtonItemStylePlain
																   target:self
																   action:@selector(edit:)] autorelease];
    [self.navigationItem setLeftBarButtonItem:editButton animated:NO];
    [historyTable setEditing:NO animated:YES];
}


- (void)launchTrashMenu{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil
													otherButtonTitles: @"删除未收藏的",@"删除所有",nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
	[actionSheet setTag:TRASH_ACTION_SHEET];
	[actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
	[actionSheet release];
}

#pragma mark actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (actionSheet.tag == TRASH_ACTION_SHEET) {
		if (buttonIndex == 0) {
			//删除未收藏的
			[[BookGetHistoryDatabase sharedInstance] deleteUnStarredBookHitories];
		}else if (buttonIndex == 1) {
			//删除所有
			[[BookGetHistoryDatabase sharedInstance] deleteAllBookHistories];
		}
	}
	
	[self reloadFromDB:nil];
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
	[self checkNavigationItemButtons];
	UISegmentedControl *segmentControl = (UISegmentedControl *)[self navigationItem].titleView;
	segmentControl.selectedSegmentIndex = 0;
}
@end

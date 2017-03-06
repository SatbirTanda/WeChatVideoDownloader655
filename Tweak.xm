#import "WeChatVideoDownloader.h"

static MMTableViewCell *mmCell;
static MMTableView *mmTV;
static WCTimeLineViewController *wcVC;


%hook WCTLContentItemTemplateVideo 

%new
- (WCMediaItem *)mediaItemFromSight 
{
	id responder = self;
	while (![responder isKindOfClass:NSClassFromString(@"WCTimeLineViewController")]) 
	{
		if ([responder isKindOfClass:NSClassFromString(@"MMTableViewCell")]) mmCell = responder;
		else if ([responder isKindOfClass:NSClassFromString(@"MMTableView")]) mmTV = responder;
		responder = [responder nextResponder]; 
	}
	
	wcVC = responder;
	
	if (!mmCell || !mmTV || !wcVC) 
	{
		NSLog(@"iOSRE: Failed to get video object.");
		return nil; 
	}
	
	NSIndexPath *indexPath = [mmTV indexPathForCell:mmCell];
	int itemIndex = [wcVC calcDataItemIndex:[indexPath section]]; 
	WCFacade *facade = [(MMServiceCenter *)[%c(MMServiceCenter) defaultCenter] getService:[%c(WCFacade) class]];
	WCDataItem *dataItem = [facade getTimelineDataItemOfIndex:itemIndex]; 
	WCContentItem *contentItem = dataItem.contentObj;
	WCMediaItem *mediaItem = [contentItem.mediaList count] != 0 ? (contentItem.mediaList)[0] : nil; 
	return mediaItem;
}

%new
- (void)onSaveToDisk 
{
	NSString *localPath = [[self mediaItemFromSight] pathForSightData];
	UISaveVideoAtPathToSavedPhotosAlbum(localPath, nil, nil, nil); 
}

%new
- (void)onCopyURL 
{
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard]; 
	pasteboard.string = [self mediaItemFromSight].dataUrl.url;
}

static int counter;

- (void)onLongTouch 
{
	counter++;
	if (counter % 2 == 0) return;
	[self becomeFirstResponder];
	UIMenuItem *saveToDiskMenuItem = [[UIMenuItem alloc] initWithTitle:@"Save to Disk" action:@selector(onSaveToDisk)];
	UIMenuItem *copyURLMenuItem = [[UIMenuItem alloc] initWithTitle:@"Copy URL" action:@selector(onCopyURL)];
	UIMenuController *menuController = [UIMenuController sharedMenuController]; 
	[menuController setMenuItems:@[saveToDiskMenuItem, copyURLMenuItem]]; [menuController setTargetRect:CGRectZero inView:self];
	[menuController setMenuVisible:YES animated:YES];
	[saveToDiskMenuItem release];
	[copyURLMenuItem release]; 
}

%end
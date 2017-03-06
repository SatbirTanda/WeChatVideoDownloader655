@interface WCContentItem : NSObject
@property (retain, nonatomic) NSMutableArray *mediaList; 
@end

@interface WCUrl : NSObject
@property(retain, nonatomic) NSString *url; // @synthesize url;
@end

@interface WCDataItem : NSObject
@property (retain, nonatomic) WCContentItem *contentObj; 
@end

@interface WCMediaItem : NSObject
@property (retain, nonatomic) WCUrl *dataUrl;
- (id)pathForSightData;
@end

@interface WCTLContentItemTemplateVideo : UIView 
- (WCMediaItem *)mediaItemFromSight;
- (void)onSaveToDisk;
- (void)onCopyURL;
@end

@interface MMServiceCenter : NSObject 
+ (id)defaultCenter;
- (id)getService:(Class)arg1;
@end

@interface WCFacade : NSObject
- (WCDataItem *)getTimelineDataItemOfIndex:(int)arg1; 
@end

@interface WCTimeLineViewController : NSObject 
- (int)calcDataItemIndex:(int)arg1;
@end

@interface MMTableViewCell : UITableViewCell 
@end

@interface MMTableView : UITableView 
@end
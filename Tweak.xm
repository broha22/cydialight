#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface Database : NSObject
	- (id)packages;
	+ (id)sharedInstance;
	- (void)update;
	- (id)packageWithName:(id)name;
@end
@interface Package : NSObject
	- (id)id;
	- (id)source;
	- (id)name;
	- (id)icon;
	- (id)shortDescription;
@end
@interface Source : NSObject
	- (id)rooturi;
@end
@interface PackageListController : NSObject
	- (void)didSelectPackage:(id)package;
@end
@interface Cydia : UIApplication
	- (BOOL)openCydiaURL:(id)url forExternal:(BOOL)b;
	- (void)applicationOpenURL:(id)hello;
@end
static dispatch_queue_t backgroundQueue1;
static dispatch_queue_t backgroundQueue2;
static dispatch_queue_t backgroundQueue3;
static dispatch_queue_t backgroundQueue4;
%hook Database
- (void)update {
	%orig;
	dispatch_async(backgroundQueue1, ^(void) {
		NSArray *packages = [[self packages] subarrayWithRange:NSMakeRange(0,(int)(([[self packages] count]-1)/4))];
		for (Package *it in packages) {
			NSString *identifier = [it name];
			NSString *repo = [[it source] rooturi];
			CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
			attributeSet.title = [it name];
			attributeSet.contentDescription = [it shortDescription];
			attributeSet.contentURL = [NSURL URLWithString:repo];
			CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:@"com.saurik.Cydia" attributeSet:attributeSet];
			[[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[[item copy]] completionHandler:^(NSError * _Nullable error) {
	    	}];
		}
		
    });
	dispatch_async(backgroundQueue2, ^(void) {
		NSArray *packages = [[self packages] subarrayWithRange:NSMakeRange((int)((([[self packages] count]-1)/4)+1),(int)(([[self packages] count]-1)/4))];
		for (Package *it in packages) {
			NSString *identifier = [it name];
			NSString *repo = [[it source] rooturi];
			CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
			attributeSet.title = [it name];
			attributeSet.contentDescription = [it shortDescription];
			attributeSet.contentURL = [NSURL URLWithString:repo];
			CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:@"com.saurik.Cydia" attributeSet:attributeSet];
			[[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[[item copy]] completionHandler:^(NSError * _Nullable error) {
	    	}];
		}
		
    }); 
	dispatch_async(backgroundQueue3, ^(void) {
		NSArray *packages = [[self packages] subarrayWithRange:NSMakeRange((int)((([[self packages] count]-1)/2)+2),(int)(([[self packages] count]-1)/4))];
		for (Package *it in packages) {
			NSString *identifier = [it name];
			NSString *repo = [[it source] rooturi];
			CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
			attributeSet.title = [it name];
			attributeSet.contentDescription = [it shortDescription];
			attributeSet.contentURL = [NSURL URLWithString:repo];
			CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:@"com.saurik.Cydia" attributeSet:attributeSet];
			[[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[[item copy]] completionHandler:^(NSError * _Nullable error) {
	    	}];
		}
		
    }); 
	dispatch_async(backgroundQueue4, ^(void) {
		NSArray *packages = [[self packages] subarrayWithRange:NSMakeRange((int)((3*([[self packages] count]-1)/4)+3),(int)(([[self packages] count]-1)/4)-3)];
		for (Package *it in packages) {
			NSString *identifier = [it name];
			NSString *repo = [[it source] rooturi];
			CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
			attributeSet.title = [it name];
			attributeSet.contentDescription = [it shortDescription];
			attributeSet.contentURL = [NSURL URLWithString:repo];
			CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:@"com.saurik.Cydia" attributeSet:attributeSet];
			[[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[[item copy]] completionHandler:^(NSError * _Nullable error) {
	    	}];
		}
		
    }); 
	
}
%end
%hook Cydia
- (void)reloadData {
	%orig;
	[[%c(Database) sharedInstance] update];
}
%new
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString:CSSearchableItemActionType]) {
       NSString *uniqueIdentifier = userActivity.userInfo[CSSearchableItemActivityIdentifier];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"cydia://package/%@",uniqueIdentifier]];
       
		[self applicationOpenURL:url];
    }

    return %orig;
}
%end
%ctor {
	backgroundQueue1 = dispatch_queue_create("com.broganminer.cydialight.bg1", NULL);
	backgroundQueue2 = dispatch_queue_create("com.broganminer.cydialight.bg2", NULL);
	backgroundQueue3 = dispatch_queue_create("com.broganminer.cydialight.bg3", NULL);
	backgroundQueue4 = dispatch_queue_create("com.broganminer.cydialight.bg4", NULL);
}

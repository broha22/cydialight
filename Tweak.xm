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
%hook PackageListController
- (void)didSelectPackage:(id)package {
	CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *) kUTTypeImage];
	
    attributeSet.title = [package name];
	attributeSet.contentDescription = [package shortDescription];
	attributeSet.contentURL = [NSURL URLWithString:[[package source] rooturi]];

	NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.saurik.Cydia.search.package"];
	userActivity.title = [package name];
	userActivity.userInfo = @{@"UID" : [package id]};
	
	userActivity.contentAttributeSet = attributeSet;
	userActivity.eligibleForSearch = YES;
	userActivity.eligibleForPublicIndexing = YES;
	
         
	[userActivity becomeCurrent];
	%orig;
}
%end
%hook Cydia
%new
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
	if (userActivity.userInfo[@"UID"]) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"cydia://package/%@",userActivity.userInfo[@"UID"]]];
		[self applicationOpenURL:url];
	}
    return YES;
}
%end

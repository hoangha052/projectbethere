//
//  AppDelegate.m
//  BeThere
//
//  Created by hoangha052 on 11/5/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import "NSPredicate+TSCUtils.h"
#import "PopupNewMessageViewController.h"
#import "ContactListViewController.h"
@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // register remote notification

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    [Parse setApplicationId:@"wHAiPhtEABNNcQOo8CU7npAjhR8qwa0wh0F5Zg58" clientKey:@"MAevm4cTxwB6OajaiNBQJgdbI8t2HjZAAZdixPhG"];

    //You may adjust the time interval depends on the need of your app.
    self.locationTracker = [[LocationTracker alloc]init];
    [self.locationTracker startLocationTracking];

    // Start background jobs.
    [NSTimer scheduledTimerWithTimeInterval:15 target:self
                                                           selector:@selector(_check_new_messages)
                                                           userInfo:nil
                                                            repeats:YES];

    [NSTimer scheduledTimerWithTimeInterval:15 target:self
                                                           selector:@selector(_check_new_friend_requests)
                                                           userInfo:nil
                                                            repeats:YES];

    return YES;
}

// Check all messages with appropriate locations that user can receive.
- (void) _check_new_messages
{
    // Only process when user has logged in.
    LoginInfo *login_info = [LoginInfo sharedObject];
    if(login_info.userName == nil) return;

    // Get the current location of the user.
    // The current location is checked and saved in LocationTracker,
    // the location of simulator is faked to be easily debugged.
    // To remove the fake location, please modify LocationTracker.m
    LocationShareModel *model = [LocationShareModel sharedModel];
    NSArray* locations = model.myLocationArray;
    if(locations.count == 0) return;
    NSDictionary* location_dic = [locations firstObject];
    CLLocation *current_location = [[CLLocation alloc] initWithLatitude:[[location_dic objectForKey:@"latitude"] floatValue] longitude:[[location_dic objectForKey:@"longitude"] floatValue]];

    // Check if there is any pending messages sent to the user.
    PFQuery *query = [PFQuery queryWithClassName:@"message"];
    [query whereKey:@"receiver" equalTo:login_info.userName];
    [query whereKey:@"status" equalTo:@"pending"];
    NSArray *messages = [query findObjects];
    if(messages.count == 0) return;
    int message_received_count = 0;
    for(PFObject *message in messages)
    {
        PFGeoPoint *point = [message objectForKey:@"location"];
        CLLocation *message_location = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
        double message_radius = [[message objectForKey:@"radius"] doubleValue];
        CLLocationDistance distance = [current_location distanceFromLocation:message_location];

        // Is this message in the appropriate distance specified by the sender ?
        if(distance < message_radius)
        {
            message_received_count++;
            message[@"status"] = @"received";
            [message save];
        }
    }

    // Notify user of new messages if any.
    if(message_received_count > 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"You have %d new messages",message_received_count] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alertView.tag = 0;
        [alertView show];

        // @todo should notify MessageViewController when there are new messages added.
    }
}

// There are some friend requests that need to be displayed ?
// If any, system will ask if the current user accepts the friend request or not.
// An alert view is used to collect user's response to the friend request.
- (void) _check_new_friend_requests
{
    // Only process when user has logged in.
    LoginInfo *login_info = [LoginInfo sharedObject];
    if(login_info.userName == nil) return;

    // Find all pending friend requests of this user.
    PFQuery* query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"receiver" equalTo:login_info.userName];
    [query whereKey:@"status" equalTo:@"pending"];
    NSArray *friend_requests = [query findObjects];

    // Are there any friend requests sent to this user ?
    // The user will confirm if he accepts or refuses the friend request.
    if([friend_requests count] > 0)
    {
        self.friend_request = [friend_requests objectAtIndex:0];
        NSString* message = [NSString stringWithFormat:@"%@ would like to add you as a friend.",[self.friend_request objectForKey:@"sender"]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alertView.tag = 1;
        [alertView show];
        return;
    }
}

// User touches on friend request alert view,
// system checks what buttons are touched.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // User accepts friend request,
    // the friend relationship is about to be stored in cloud.
    if (buttonIndex == 1)
    {
        self.friend_request[@"status"] = @"accepted";
        [self.friend_request save];

        // @todo should notify ContactListViewController when there are new friends added.
    }

    // User rejects the friend request,
    // this action will be stored in cloud but the sender can send more request to this user.
    else {
        [self.friend_request delete];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *message = notification.userInfo;
    PFObject *object = [PFQuery getObjectOfClass:@"message" objectId:[message valueForKey:@"objectId"]];
    if (object!=nil) {
        object[@"readmessage"] = @(YES);
        [object save];
        // Send a notification to all devices subscribed to the "Giants" channel.
        PFPush *push = [[PFPush alloc] init];
        [push setChannels:@[[message objectForKey:@"sender"]]];
        [push setMessage:[NSString stringWithFormat:@"[%@] has received your message", [message objectForKey:@"receiver"]]];
        [push sendPushInBackground];
        
        [self handleReceiverMessager:message];
    }
}

- (void)handleReceiverMessager:(NSDictionary *)dicData;
{
    UINavigationController *nc = (UINavigationController *)self.window.rootViewController;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    PopupNewMessageViewController *ivc = [mainStoryboard instantiateViewControllerWithIdentifier: @"PopupNewMessageViewController"];
    ivc.dicMessage = dicData;
    [nc pushViewController:ivc animated:YES];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"notificationData = %@",userInfo);
    [PFPush handlePush:userInfo];
    if ([[userInfo objectForKey:@"type"] isEqualToString:@"request"]) {
        UINavigationController *nc = (UINavigationController *)self.window.rootViewController;
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ContactListViewController *ivc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ContactListViewController"];
        ivc.isRequest = YES;
        ivc.namePushNotification = [userInfo objectForKey:@"sender"];
        [nc pushViewController:ivc animated:YES];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

// coredata
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContextSave = self.managedObjectContext;
    if (managedObjectContextSave != nil) {
        if ([managedObjectContextSave hasChanges] && ![managedObjectContextSave save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//Explicitly write Core Data accessors
- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"bethereModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end

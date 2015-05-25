//
//  AppDelegate.h
//  BeThere
//
//  Created by hoangha052 on 11/5/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationTracker.h"
#import "LoginInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navicontrer;
@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic)  PFObject *friend_request;
- (NSURL *)applicationDocumentsDirectory;


@end

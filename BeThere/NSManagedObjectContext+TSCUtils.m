//
//  NSManagedObjectContext+TSCUtils.m
//  TableViewTutorial
//
//  Created by hoangha052 on 10/28/14.
//  Copyright (c) 2014 Codigator. All rights reserved.
//

#import "NSManagedObjectContext+TSCUtils.h"
#import "AppDelegate.h"

@implementation NSManagedObjectContext (TSCUtils)
+(NSManagedObjectContext *)sharedContext
{
    AppDelegate *delegate = (id) [UIApplication sharedApplication].delegate;
    return delegate.managedObjectContext;
}

@end

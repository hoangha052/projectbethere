//
//  NSManagedObjectContext+TSCUtils.h
//  TableViewTutorial
//
//  Created by hoangha052 on 10/28/14.
//  Copyright (c) 2014 Codigator. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (TSCUtils)
+(NSManagedObjectContext *)sharedContext;
@end

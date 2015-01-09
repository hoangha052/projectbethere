//
//  Friends.h
//  bethere
//
//  Created by hoangha052 on 12/12/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friends : NSManagedObject

@property (nonatomic, retain) NSString * myName;
@property (nonatomic, retain) NSString * friendName;

@end

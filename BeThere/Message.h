//
//  Message.h
//  bethere
//
//  Created by hoangha052 on 11/24/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * messageid;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSString * receiver;
@property (nonatomic, retain) NSNumber * readmessage;

@end

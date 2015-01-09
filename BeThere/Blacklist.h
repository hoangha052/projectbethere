//
//  Blacklist.h
//  bethere
//
//  Created by hoangha052 on 11/30/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Blacklist : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * blackName;
@property (nonatomic, retain) NSNumber * isReceiver;
@end

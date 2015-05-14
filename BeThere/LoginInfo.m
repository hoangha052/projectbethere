//
//  CachLoginInfo.m
//  BeThere
//
//  Created by hoangha052 on 11/10/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "LoginInfo.h"

@implementation LoginInfo

+(id)sharedObject
{
    static LoginInfo *sharedObject = nil;
    if (!sharedObject) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedObject = [LoginInfo new];
            // complete download
            sharedObject.arrayImage = @[@"pk1",@"pk2",@"pk3",@"pk4",@"symbol-5",@"symbol-6"];
        });
    }
    return sharedObject;
}

- (void) resetData
{
    self.userName = nil;
    self.userEmail = nil;
    self.password =nil;
    self.receiverReply = nil;
    self.arrayReceiver = nil;
    self.messageDic = nil;
    self.reply = NO;
}

- (id)serializedObject
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (id)objectWithData:(id)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userEmail forKey:@"userEmail"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.password forKey:@"password"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userEmail = [aDecoder decodeObjectForKey:@"userEmail"];
        self.userName  = [aDecoder decodeObjectForKey:@"userName"];
        self.password  = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}


@end

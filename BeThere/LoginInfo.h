//
//  LoginInfo.h
//  BeThere
//
//  Created by hoangha052 on 11/10/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfo : NSObject

@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (assign, nonatomic) BOOL reply;
@property (strong, nonatomic) NSString *receiverReply;
@property (strong, nonatomic) NSArray *arrayReceiver;
@property (strong, nonatomic) NSDictionary *messageDic;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer * delay10Seconds;
@property (nonatomic) NSTimer *timerGetMessage;
@property (strong, nonatomic) NSArray *arrayImage;

+(id)objectWithData:(id)data;
+(id)sharedObject;
- (void)resetData;
- (id)serializedObject;
@end

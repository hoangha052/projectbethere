//
//  CreatMessageViewController.h
//  BeThere
//
//  Created by hoangha052 on 11/6/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatMessageViewController : UIViewController
@property (strong, nonatomic) PFGeoPoint *locationRecieve;
@property (nonatomic) NSInteger radiusReceiver;
@property (strong, nonatomic) NSArray *arrayReceiver;
@property (strong, nonatomic) NSString *imageName;

@end

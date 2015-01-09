//
//  CircleView.h
//  bethere
//
//  Created by hoangha052 on 12/7/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CircleView : MKCircleView
@property (strong, nonatomic) UIImageView *imageView;
- (void)start;
@end


//
//  Rectangle.h
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
/*
 this class is the rectangle class which store all neccessary information, but never stores a imgview.
 */
@protocol myDelegate<NSObject>

-(void) update;

@end

@interface Rectangle : NSObject

@property Vector2D* postion;
@property double mass;
@property double angularV;
@property Vector2D* velocity;
@property double rotation;
@property double ineria;
@property double e;
@property double mu;
@property double force;
@property double height;
@property double width;
@property id<myDelegate> delegate;
@property (nonatomic) Vector2D* h;
@property (nonatomic) Matrix2D* R;
@property Vector2D* gravity;
@property RectType type;

-(Rectangle*)initWithPosition:(Vector2D*)pos Width:(double)width Height:(double)height Mass:(double)mass Type:(RectType)type;

@end

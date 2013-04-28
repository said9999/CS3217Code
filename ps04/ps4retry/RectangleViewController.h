//
//  RectangleViewController.h
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rectangle.h"
#import "Constant.h"
/*
 this class is the view controller for each single rectangle, in order to update its view position
 */

@interface RectangleViewController : UIViewController<myDelegate>

@property UIView* imgView;
@property Rectangle* model;

-(void)update;

-(RectangleViewController*)initWithX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)w Height:(CGFloat)h Mass:(double)m Type:(RectType)type Color:(COLORTYPE) color;
@end

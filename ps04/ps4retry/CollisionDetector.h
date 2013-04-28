//
//  CollisionDetector.h
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rectangle.h"
#import "Constant.h"
#import "ContactPoint.h"
/*
 This class detect any collision happenning in this world, and add the creating contact points into its contact point list.
 */

@interface CollisionDetector : NSObject

- (void)solveWithA:(Rectangle*)rectA B:(Rectangle*)rectB;
//this method happens when two rectangles collide with each other, it will create two contact points into its
//list

@property  NSMutableArray* contactPointsList;

@end

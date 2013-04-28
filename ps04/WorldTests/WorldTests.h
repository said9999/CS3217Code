//
//  WorldTests.h
//  WorldTests
//
//  Created by sai on 2/17/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

//PLS CANCEL ALL STATEMENTS RELATED TO UIACCELEROMETER IN World.m before testing!!!!

#import <SenTestingKit/SenTestingKit.h>
#import "World.h"
#import "CollisionDetector.h"
@interface WorldTests : SenTestCase

@property Rectangle* A;
@property Rectangle* B;
@property World* myWorld;


@end

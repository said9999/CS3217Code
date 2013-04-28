//
//  RectangleTest.m
//  RectangleTest
//
//  Created by sai on 2/17/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


//PLS CANCEL ALL STATEMENTS RELATED TO UIACCELEROMETER IN World.m before testing!!!!

#import "RectangleTest.h"

@implementation RectangleTest

- (void)setUp
{
    [super setUp];
    _A = [[Rectangle alloc] initWithPosition:[Vector2D vectorWith:0 y:0] Width:30 Height:40 Mass:99 Type:actor];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in RectangleTest");
}

- (void)testRectInit{
    STAssertTrue((_A.velocity.x == ZERO_VECTOR.x && _A.velocity.y == ZERO_VECTOR.y),nil);
    STAssertEquals(_A.width, 30.0, nil);
    STAssertEquals(_A.height, 40.0, nil);
    STAssertEquals(_A.mass, 99.0, nil);
    STAssertEquals(_A.rotation,0.0, nil);
    STAssertEquals(_A.ineria,20625.0, nil);
    STAssertEquals(_A.type, actor, nil);
    STAssertEquals(_A.angularV, 0.0, nil);
}

@end

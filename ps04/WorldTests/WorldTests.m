//
//  WorldTests.m
//  WorldTests
//
//  Created by sai on 2/17/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


//PLS CANCEL ALL STATEMENTS RELATED TO UIACCELEROMETER IN World.m before testing!!!!

#import "WorldTests.h"

@implementation WorldTests

- (void)setUp
{
    [super setUp];
    _myWorld = [[World alloc] init];
    _A = [[Rectangle alloc] initWithPosition:[Vector2D vectorWith:0 y:0] Width:30 Height:40 Mass:99 Type:actor];
    _B = [[Rectangle alloc] initWithPosition:[Vector2D vectorWith:300 y:300] Width:500 Height:100 Mass:INFINITY Type:bound];
    
    [_myWorld.objectsList addObject:_A];
    [_myWorld.objectsList addObject:_B];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in WorldTests");
}

- (void)testWorld{
    Rectangle* A = [_myWorld.objectsList objectAtIndex:0];
    Rectangle* B = [_myWorld.objectsList objectAtIndex:1];
    
    STAssertTrue([A isEqual:_A], nil);
    STAssertTrue([B isEqual:_B], nil);
}

- (void)testUpdatePosition{
    _A.velocity = [Vector2D vectorWith:0 y:10];
    _B.velocity = [Vector2D vectorWith:1 y:-10];
    
    [_myWorld updatePosition];
    
    STAssertEquals(_A.postion.x, 0.0, nil);
    STAssertEqualsWithAccuracy(_A.postion.y, 0.1666, 0.001, nil);
    STAssertEquals(_B.postion.x,300.0, nil);
    STAssertEquals(_B.postion.y, 300.0, nil);
}

@end

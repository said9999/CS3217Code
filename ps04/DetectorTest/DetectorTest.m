//
//  DetectorTest.m
//  DetectorTest
//
//  Created by sai on 2/17/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


//PLS CANCEL ALL STATEMENTS RELATED TO UIACCELEROMETER IN World.m before testing!!!!

#import "DetectorTest.h"

@implementation DetectorTest

- (void)setUp
{
    [super setUp];
    
    _detector = [[CollisionDetector alloc] init];
    _A = [[Rectangle alloc] initWithPosition:[Vector2D vectorWith:10 y:0] Width:30 Height:40 Mass:99 Type:actor];
    _B = [[Rectangle alloc] initWithPosition:[Vector2D vectorWith:0 y:-35] Width:100 Height:40 Mass:99 Type:actor];
    [_detector solveWithA:_A B:_B];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in DetectorTest");
}

- (void)testDetector{
    ContactPoint* p1 = [_detector.contactPointsList objectAtIndex:0];
    
    ContactPoint* p = [[ContactPoint alloc] initWithRectA:_A RectB:_B Normal:[Vector2D vectorWith:0.0 y:-1.0] Separation:-5.0 Point:[Vector2D vectorWith:-5 y:-20]];
    
    STAssertEquals(p1.n.x, p.n.x, nil);
    STAssertEquals(p1.n.y, p.n.y, nil);
    STAssertEquals(p1.separation, p.separation, nil);
    STAssertEqualsWithAccuracy(p1.c.x
                               , p.c.x, 0.01, nil);
    STAssertEqualsWithAccuracy(p1.c.y, p.c.y, 0.01, nil);
    
}

- (void)testContactPoint{
    ContactPoint* p = [_detector.contactPointsList objectAtIndex:0];
    [p applyImpulse];
    STAssertEqualsWithAccuracy(_A.velocity.x, 0.0, 0.01, nil);
    STAssertEqualsWithAccuracy(_A.velocity.y, 4.82, 0.01, nil);
    STAssertEqualsWithAccuracy(_B.velocity.x, 0.0, 0.01, nil);
    STAssertEqualsWithAccuracy(_B.velocity.y, -4.82, 0.01, nil);
    
    STAssertEqualsWithAccuracy(_A.angularV, -0.347, 0.01, nil);
    STAssertEqualsWithAccuracy(_B.angularV, 0.024, 0.01, nil);
}

@end

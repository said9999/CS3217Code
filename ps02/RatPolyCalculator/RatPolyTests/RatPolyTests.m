//
//  RatPolyTests.m
//  RatPolyTests
//
//  Created by sai on 1/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

/* skeleton unit test implementation */

#import "RatPolyTests.h"


@implementation RatPolyTests

RatNum* num(int i) {
	return [[RatNum alloc] initWithInteger:i];
}

RatNum* num2(int i, int j) {
	return [[RatNum alloc] initWithNumer:i Denom:j];
}

RatTerm* term(int coeff, int expt) {
	return [[RatTerm alloc] initWithCoeff:num(coeff) Exp:expt];
}

RatTerm* term3(int numer, int denom, int expt) {
	return [[RatTerm alloc] initWithCoeff:num2(numer, denom) Exp:expt];
}

RatPoly* poly0() {
    return [[RatPoly alloc] init];
}

RatPoly* polyt(RatTerm* rt) {
    return [[RatPoly alloc] initWithTerm:rt];
}

RatPoly* polya(NSArray* ts) {
    return [[RatPoly alloc] initWithTerms:ts];
}

-(void)setUp{
    nanNum = [num(1) div:num(0)];
    nanTerm = [[RatTerm alloc] initWithCoeff:nanNum Exp:3];
    nanPoly = [[RatPoly alloc] initWithTerm:nanTerm];
    poly1 = [[NSArray alloc] initWithObjects:term3(3, 1, 2), nil]; // 3*x^2
    polyz = [NSArray array];
    poly2 = [[NSArray alloc] initWithObjects:term3(1,1,1), term3(1, 1, 0), nil]; // x+1
    poly3 = [[NSArray alloc] initWithObjects:term3(1, 1, 3), term3(1, 1, 1), term3(-1, 1, 0), nil]; // x^3+x-1
    
}

-(void)tearDown{
}

-(void)testPass{
	STAssertTrue(1==1, @"", @"");
}

-(void)testCtor{
    poly0();
    poly0();
}

-(void)testCtorTerm{
    polyt(term(1, 0));
    polyt(term(2, 3));
    polyt(term3(4, 3, 6));
    polyt(term3(-2, 7, 3));
}

-(void)testCtorTerms{
    NSArray *temp = [[NSArray alloc] initWithObjects:term3(-1, 1, 6), term3(3, 4, 3), term3(3,5,0), nil];
    polya(temp);
    polya(polyz);
    polya(poly1);
    polya(poly2);
    polya(poly3);
}

-(void)testCtorNaN{
    polyt([RatTerm initNaN]);
}

-(void)testGetDegree{
    STAssertTrue([polya(polyz) degree]==0, @"0 poly degree f", nil);
    STAssertTrue([polya(poly1) degree]==2, @"one terms degree f", nil);
    STAssertTrue([polya(poly2) degree]==1, @"two terms degree f", nil);
    STAssertTrue([polya(poly3) degree]==3, @"3 terms degree f", nil);
}

-(void)testGetTerm{
    STAssertEqualObjects([polya(poly1) getTerm:2], term(3, 2), @"", @"");
    STAssertEqualObjects([polya(poly3) getTerm:3], term(1, 3), @"", @"");
    STAssertEqualObjects([polya(poly3) getTerm:2], term(0, 0), @"", @"");
    STAssertEqualObjects([polya(poly3) getTerm:1], term(1, 1), @"", @"");
    STAssertEqualObjects([polya(poly3) getTerm:0], term(-1, 0), @"", @"");
}

-(void)testIsNaN{
    STAssertTrue([polya([NSArray arrayWithObjects:term3(1, 0, 2), nil]) isNaN], @"", @"");
	STAssertTrue([polya([NSArray arrayWithObjects:term3(1, 0, 1), term(2, 0), nil]) isNaN], @"", @"");
    STAssertFalse([polya([NSArray arrayWithObjects:term(10, 3), term3(-2, 3, 2), nil]) isNaN], @"", @"");
    STAssertTrue([nanPoly isNaN], @"", @"");
}

-(void)testIsEqual {
    RatPoly *rpn = polya([NSArray arrayWithObjects:term3(1, 0, 4), term(2, 3), nil]);
    RatPoly *rp1 = polyt(term(3,2));
    RatPoly *rpz = polyt(term(0,0));
    RatPoly *rp2 = polya(poly2);
    RatPoly *rp3 = polya(poly3);
    STAssertTrue([rpn isEqual: nanPoly], @"", @"");
    STAssertTrue([rp1 isEqual: polyt(term(3,2))], @"", @"");
    STAssertTrue([rpz isEqual: polyt(term(0,0))], @"", @"");
    STAssertFalse([rp2 isEqual: rp3], @"", @"");
    STAssertTrue([rp3 isEqual: polya(poly3)], @"", @"");
}

-(void)testNegate{
    RatPoly *rp1 = polya([NSArray arrayWithObjects:term(-3,2), nil]);
    RatPoly *rp3 = polya([[NSArray alloc] initWithObjects:term3(-1, 1, 3), term3(-1, 1, 1), term3(1, 1, 0), nil]);
    STAssertEqualObjects(rp1, [polya(poly1) negate], @"", nil);
    STAssertEqualObjects(nanPoly, [nanPoly negate], @"", nil);
    STAssertEqualObjects(rp3, [polya(poly3) negate], @"", nil);
    
}

-(void)testEval {
    [nanPoly eval:5.2];
    STAssertEqualsWithAccuracy(0.0, [poly0() eval:3.0], 0.000001, @"", @"");
    STAssertEqualsWithAccuracy(3.0, [polya(poly1) eval:1.0], 0.000001, @"", @"");
    STAssertEqualsWithAccuracy(-11.0, [polya(poly3) eval:-2.0], 0.000001, @"", @"");
}

-(void)testAdd {
    RatPoly *rp1 = polya([NSArray arrayWithObjects: term(3, 2), term(1, 1), term(1, 0), nil]);
    RatPoly *rp2 = polya([NSArray arrayWithObjects: term(2, 1), term(2, 0), nil]);
    RatPoly *rp3 = polya([NSArray arrayWithObjects: term(1, 3), term(2, 1), nil]);
    STAssertEqualObjects([polya(poly1) add:polya(poly2)], rp1, nil, nil);
    STAssertEqualObjects([polya(poly2) add:polya(poly2)], rp2, nil, nil);
    STAssertEqualObjects([polya(poly3) add:polya(poly2)], rp3, nil, nil);
    STAssertEqualObjects([poly0() add: polyt(term(1, 1))], polyt(term(1, 1)), @"", @"");
    STAssertEqualObjects([nanPoly add: polyt(term(1, 1))], nanPoly, @"", @"");
}

-(void)testSub {
    RatPoly *rp1 = polya([NSArray arrayWithObjects: term(3, 2), term(-1, 1), term(-1, 0), nil]);
    RatPoly *rp3 = polya([NSArray arrayWithObjects: term(1, 3), term(-2, 0), nil]);
    STAssertEqualObjects([polya(poly1) sub:polya(poly2)], rp1, nil, nil);
    STAssertEqualObjects([polya(poly2) sub:polya(poly2)], poly0(), nil, nil);
    STAssertEqualObjects([polya(poly3) sub:polya(poly2)], rp3, nil, nil);
    STAssertEqualObjects([poly0() sub: polyt(term(1, 1))], polyt(term(-1, 1)), @"", @"");
    STAssertEqualObjects([nanPoly sub: polyt(term(1, 1))], nanPoly, @"", @"");
}

-(void)testMul {
    RatPoly *x = polyt(term(1, 1));
    RatPoly *p = polya(poly2);
    RatPoly *q = polya(poly3);
    STAssertEqualObjects([x mul:poly0()], poly0(), @"", @"");
    STAssertEqualObjects([x mul:nanPoly], nanPoly, @"", @"");
    STAssertEqualObjects([x mul:p], polya([NSArray arrayWithObjects: term(1, 2), term(1, 1), nil]), @"", @"");
    STAssertEqualObjects([q mul:p], polya([NSArray arrayWithObjects: term(1,4), term(1,3), term(1, 2), term(-1, 0), nil]), @"", @"");
    STAssertEqualObjects([p mul:q], polya([NSArray arrayWithObjects: term(1,4), term(1,3), term(1, 2), term(-1, 0), nil]), @"", @"");
}

-(void)testDiv {
    RatPoly *x = polyt(term(1, 1));
    RatPoly *pq = polya([NSArray arrayWithObjects:term(6, 2), term(1, 1), term(-2, 0), nil]);
    RatPoly *p = polya([NSArray arrayWithObjects: term(3, 1), term(2, 0), nil]);
    RatPoly *q = polya([NSArray arrayWithObjects: term(2, 1), term(-1, 0), nil]);
    STAssertEqualObjects([nanPoly div:x], nanPoly, @"", @"");
    STAssertEqualObjects([x div:nanPoly], nanPoly, @"", @"");
    STAssertEqualObjects([poly0() div:x], poly0(), @"", @"");
    STAssertEqualObjects([x div:poly0()], nanPoly, @"", @"");
    STAssertEqualObjects([x div:polya([NSArray arrayWithObjects: term(1, 3), term(2, 0), nil])], poly0(), @"", @"");
    STAssertEqualObjects([pq div:p], q, @"", @"");
    STAssertEqualObjects([pq div:q], p, @"", @"");
    STAssertEqualObjects([polya([NSArray arrayWithObjects: term(1, 3), term(1, 2), nil]) div:x],
                         polya([NSArray arrayWithObjects: term(1, 2), term(1, 1), nil]), @"", @"");
    STAssertEqualObjects([x div:pq], poly0(), @"", @"");
    STAssertEqualObjects([pq div:x], polya([NSArray arrayWithObjects: term(6, 1), term(1, 0), nil]), @"", @"");
    STAssertEqualObjects([polya([NSArray arrayWithObjects: term(1, 3), term(-2, 1), term(3, 0), nil]) div:
                          polyt(term(3, 2))], polyt(term3(1, 3, 1)), @"", @"");
    STAssertEqualObjects([polya([NSArray arrayWithObjects: term(1, 2), term(2, 1), term(15, 0), nil]) div:
                          polyt(term(2, 3))], poly0(), @"", @"");
    STAssertEqualObjects([polya([NSArray arrayWithObjects: term(1, 3), term(1, 1), term(-1, 0), nil]) div:
                          polya([NSArray arrayWithObjects: term(1, 1), term(1, 0), nil])],
                         polya([NSArray arrayWithObjects: term(1, 2), term(-1, 1), term(2, 0), nil]), @"", @"");
    
}

-(void)testValueOf:(NSString*)actual :(RatPoly*)target{
	STAssertEqualObjects(target, [RatPoly valueOf:actual], @"", @"");
}

-(void)testValueOfc {
    [self testValueOf:@"NaN" :nanPoly];
    [self testValueOf:@"0" :poly0()];
    [self testValueOf:@"-x^5" :polyt(term(-1, 5))];
    [self testValueOf:@"x-1" :polya([NSArray arrayWithObjects:term(1, 1), term(-1, 0), nil])];
    [self testValueOf:@"x^3-2*x^2+5/3*x+3" :polya([NSArray arrayWithObjects:term(1, 3), term(-2, 2), term3(5, 3, 1), term(3, 0), nil])];
    [self testValueOf:@"-x^3-2/5*x^2-1" :polya([NSArray arrayWithObjects:term(-1, 3), term3(-2, 5, 2), term(-1, 0), nil])];
}


-(void)testStringValue:(RatPoly *)actual :(NSString *)target{
    STAssertEqualObjects(target, [actual stringValue], @"", @"");
}

-(void)testStringValueC {
    [self testStringValue:nanPoly :@"NaN"];
    [self testStringValue:poly0() :@"0"];
    [self testStringValue:polyt(term(-1, 2)) :@"-x^2"];
    [self testStringValue:polya([NSArray arrayWithObjects:term(1, 1), term(-10, 0), nil]) :@"x-10"];
    [self testStringValue:polya([NSArray arrayWithObjects:term(1, 3), term(-2, 2), term3(5, 3, 1), term(3, 0), nil]) :@"x^3-2*x^2+5/3*x+3"];
    [self testStringValue:polya([NSArray arrayWithObjects:term(1, 17), term3(-3, 2, 2), term(1, 0), nil]) :@"x^17-3/2*x^2+1"];
    [self testStringValue:polyt(term3(-1, 2, 0)) :@"-1/2"];
}

- (void) testInput{
    [[[[RatPoly valueOf:@"3x"] add:[RatPoly valueOf:@"3"]] stringValue] isEqualToString:@"3"];
}







@end
//
//  Overlaps.m
//  
//  CS3217 || Assignment 1
//  Name: <Jiang Yaoxuan>
//

#import <Foundation/Foundation.h>
// Import PERectangle here
#import "PERectangle.h"
// define structure Rectangle
// <definition for struct Rectangle here>
struct Rectangle{int x;int y;int w;int h;};
int test();

int overlaps(struct Rectangle rect1, struct Rectangle rect2) {
  // EFFECTS: returns 1 if rectangles overlap and 0 otherwise
    struct Rectangle leftRect;
    struct Rectangle rightRect;
    
    if(rect1.x <= rect2.x) {
        leftRect = rect1;
        rightRect = rect2;
    }else{
        rightRect = rect1;
        leftRect = rect2;
    }
    
    int topPointDistance = rightRect.x - leftRect.x;
    
    if (topPointDistance <= leftRect.w) {
        if ((rightRect.y >= leftRect.y && rightRect.y - leftRect.y <= rightRect.h)
            || (rightRect.y < leftRect.y && leftRect.y - rightRect.y <= leftRect.h)) {
            return 1;
        }
    }
    return 0;
}


int main (int argc, const char * argv[]) {
	/* Problem 1 code (C only!) */
    // declare rectangle 1 and rectangle 2
    test();
    struct Rectangle r1 ;
    struct Rectangle r2 ;
    int ox,oy,Mwidth,Mheight;
    // input origin for rectangle 1
    printf("Input <x y> coordinates for the origin of the first rectangle: ");
    scanf("%d%d",&ox,&oy);
    // input size (width and height) for rectangle 1
    printf("Input width and height of the first rectangle: ");
    scanf("%d%d",&Mwidth,&Mheight);
    
    r1.x = ox;
    r1.y = oy;
    r1.w = Mwidth;
    r1.h = Mheight;
    // input origin for rectangle 2
    printf("Input <x y> coordinates for the origin of the second rectangle: ");
    scanf("%d%d",&ox,&oy);
    // input size (width and height) for rectangle 2
    printf("Input width and height of the second rectangle: ");
    scanf("%d%d",&Mwidth,&Mheight);
    
    r2.x = ox;
    r2.y = oy;
    r2.w = Mwidth;
    r2.h = Mheight;
    // check if overlapping and write message
    int isOverlap = overlaps(r1, r2);
    if (isOverlap) {
        printf("The two rectangles are overlapping!\n");
    }else{
        printf("The two rectangles are not overlapping!\n");
    }
    
    /* Problem 2 code (Objective-C) */
    // declare rectangle 1 and rectangle 2 object
    PERectangle* rec1 = [[PERectangle alloc] initWithOrigin:CGPointMake(r1.x, r1.y) width:r1.w height:r1.h
                        rotation:0];
    PERectangle* rec2 = [[PERectangle alloc] initWithOrigin:CGPointMake(r2.x, r2.y) width:r2.w height:r2.h
                        rotation:0];
    
    // input rotation for rectangle 1
    float angle;
    float angle2;
    printf("Input rotation angle for the first rectangle:");
    scanf("%f",&angle);
    // input rotation for rectangle 2
    printf("Input rotation angle for the second rectangle:");
    scanf("%f",&angle2);
    // rotate rectangle objects
    [rec1 rotate:angle];
    [rec2 rotate:angle2];
    // check if rectangle objects overlap and write message
    if ([rec1 overlapsWithRect:rec2]) {
        printf("The two rectangles objects are overlapping!\n");
    }else{
        printf("The two rectangles objects are not overlapping!\n");
    }
	// clean up
    free(rec1);
    free(rec2);
	// exit program
	return 0;
}


// This is where you should put your test cases to test that your implementation is correct. 
int test() {
    struct Rectangle test1 ;
    struct Rectangle test2 ;
    
    // test2 contains test 1
    test1.x = 1;
    test1.y = 1;
    test2.x = 0;
    test2.y = 0;
    test1.w = test1.h = 1;
    test2.w = test2.h = 5;
    //overlap
    assert(overlaps(test1, test2)==1);
    //printf("case 1 passed\n");
    
    //test2 & test1 intersects at one vertex
    test1.x = 5;
    test1.y = -5;
    test2.x = 0;
    test2.y = 0;
    test1.w = test1.h = 1;
    test2.w = test2.h = 5;
    //overlap
    assert(overlaps(test1, test2)==1);
    //printf("case 2 passed\n");
    
    //test2 & test 1 intersects
    test1.x = -5;
    test1.y = 0;
    test2.x = 0;
    test2.y = 0;
    test1.w = test1.h = 6;
    test2.w = test2.h = 5;
    //overlap
    assert(overlaps(test1, test2)==1);
    //printf("case 3 passed\n");
    
    //intersect on one side
    test1.x = -5;
    test1.y = 0;
    test2.x = 0;
    test2.y = 0;
    test1.w = test1.h = 5;
    test2.w = test2.h = 5;
    //overlap
    assert(overlaps(test1, test2)==1);
    //printf("case 4 passed\n");
    
    //not intersect
    test1.x = -5;
    test1.y = 0;
    test2.x = 0;
    test2.y = 0;
    test1.w = test1.h = 4;
    test2.w = test2.h = 5;
    //not overlap
    assert(overlaps(test1, test2)==0);
    //printf("case 5 passed\n");
    
    //test 4 contains test 3
    PERectangle* test3 = [[PERectangle alloc] initWithOrigin:CGPointMake(1,-1) width:2 height:2 rotation:0];
    PERectangle* test4 = [[PERectangle alloc] initWithOrigin:CGPointMake(0,0) width:5 height:5 rotation:0];
    assert(test3.width==2&&test3.height==2&&test3.rotation==0&&test3.origin.x==1&&test3.origin.y==-1);
    assert([test3 overlapsWithShape:test4]==YES);
    //printf("case 6 passed\n");

    //test 5 not overlap with test6 
    PERectangle* test5 = [[PERectangle alloc] initWithOrigin:CGPointMake(0,6) width:5 height:5 rotation:0];
    PERectangle* test6 = [[PERectangle alloc] initWithOrigin:CGPointMake(0,0) width:5 height:5 rotation:0];
    assert([test5 overlapsWithShape:test6]==NO);
    //printf("case 7 passed\n");
    
    //test 5  overlap with test6 after rotation
    [test5 rotate:45];
    assert([test5 overlapsWithShape:test6]==YES);
    //printf("case 8 passed\n");
    
    //test7  overlap with test8
    PERectangle* test7 = [[PERectangle alloc] initWithOrigin:CGPointMake(0,6) width:5 height:5 rotation:45];
    PERectangle* test8 = [[PERectangle alloc] initWithOrigin:CGPointMake(0,0) width:5 height:5 rotation:0];
    assert([test7 overlapsWithShape:test8]==YES);
    assert(test7.rotation==45);
    //printf("case 9 passed\n");
    
    //overlap with one vertex 
    PERectangle* test9 = [[PERectangle alloc] initWithOrigin:CGPointMake(-5,5) width:5 height:5 rotation:0];
    PERectangle* test10 = [[PERectangle alloc] initWithOrigin:CGPointMake(0,0) width:5 height:5 rotation:0];
    assert([test9 overlapsWithShape:test10]==YES);
    assert(test9.corners[0].x == -5&&test9.corners[0].y == 5&&test9.corners[1].x==0&&test9.corners[1].y==5&&
           test9.corners[2].x == 0&&test9.corners[2].y == 0&&test9.corners[3].x==-5&&test9.corners[3].y==0);
    //printf("case 10 passed\n");
    
    //overlap with one side
    PERectangle* test11 = [[PERectangle alloc] initWithOrigin:CGPointMake(0,5) width:5 height:5 rotation:0];
    PERectangle* test12 = [[PERectangle alloc] initWithOrigin:CGPointMake(0,0) width:5 height:5 rotation:0];
    assert([test11 overlapsWithShape:test12]==YES);
    assert(test11.corners[0].x == 0&&test11.corners[0].y == 5&&test11.corners[1].x==5&&test11.corners[1].y==5&&
           test11.corners[2].x == 5&&test11.corners[2].y == 0&&test11.corners[3].x==0&&test11.corners[3].y==0);
    //printf("case 11 passed\n");
    
    
    [test11 translateX:5 Y:5];
    assert(test11.origin.x==5&&test11.origin.y==10);
    //printf("case 12 passed\n");
    
    PERectangle* test13 = [[PERectangle alloc] initWithRect:CGRectMake(0, 5, 5, 5)];
    assert(test13.width==5&&test13.height==5&&test13.origin.x==0&&test13.origin.y==5);
    assert([test13 overlapsWithShape:test12]==YES);
    assert([test13 center].x == 2.5 && [test13 center].y == 2.5);
    //printf("case 13 passed\n");
    
    //SAME RECTANGLE
    assert([test8 overlapsWithShape:test10]==YES);

    return 0;
}

/* 

Question 2(h)
========

<Your answer here>
1) we can define a rectangle by its four vertices. 
   The pro is we can compute more efficiently but
   The con is we need extra space to store the data.

2) If we use the origin, width and height
   The pro is we can represent a rectangle in a simple way, and use less space to store the data.
   But the con is we need to compute all necessary data that we need which may cause a waste of time.


Question 2(i): Reflection (Bonus Question)
==========================
(a) How many hours did you spend on each problem of this problem set?

  around 10 hours. 

(b) In retrospect, what could you have done better to reduce the time you spent solving this problem set?

  learn objective-c before instead of learning it when doing the assignment.
  communicate more frequently with my friends.
  

(c) What could the CS3217 teaching staff have done better to improve your learning experience in this problem set?
 
  maybe provide some testcases. Spend too much time on writing test cases.
  

*/




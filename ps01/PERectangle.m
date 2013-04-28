//
//  PERectangle.m
//  
//  CS3217 || Assignment 1
//  Name: <Jiang Yaoxuan>
//

#import "PERectangle.h"

@interface PERectangle()

@property (nonatomic, readwrite) CGFloat width;
@property (nonatomic, readwrite) CGFloat height;
@property (nonatomic, readwrite) CGPoint* corners;
@property (nonatomic, readwrite) CGPoint center;

@end

@implementation PERectangle
// OVERVIEW: This class implements a rectangle and the associated
//             operations.

@synthesize width = _width,height = _height,corners = _corners, origin = _origin,rotation = _rotation,center = _center;




- (CGPoint)center {
  // EFFECTS: returns the coordinates of the centre of mass for this
  // rectangle.
    return self.center = CGPointMake(self.origin.x + self.width/2,self.origin.y - self.height/2);
}

- (CGPoint)cornerFrom:(CornerType)corner {
  // REQUIRES: corner is a enum constant defined in PEShape.h as follows:
  //           kTopLeftCorner, kTopRightCorner, kBottomLeftCorner,
  //		   kBottomRightCorner 
  // EFFECTS: returns the coordinates of the specified rotated rectangle corner after rotating
    CGPoint Point;
    CGFloat dx = [self center].x;
    CGFloat dy = [self center].y;
    [self translateX:-dx Y:-dy];
    switch (corner) {
        case 1:
            Point = CGPointMake(self.origin.x, self.origin.y);
            break;
        case 2:
            Point = CGPointMake(self.origin.x + self.width, self.origin.y);
            break;
        case 3:
            Point = CGPointMake(self.origin.x, self.origin.y - self.height);
            break;
        case 4:
            Point = CGPointMake(self.origin.x + self.width, self.origin.y - self.height);
            break;
        default:
            break;
    }
    double degree = M_PI/180.00*self.rotation;
    
    CGPoint afterRotation = CGPointMake(-Point.y*sin(degree) + Point.x*cos(degree) + dx,
                                      Point.y*cos(degree) + Point.x*sin(degree)+dy);
    [self translateX:dx Y:dy];
    return afterRotation;
}

- (CGPoint*)corners {
  // EFFECTS:  return an array with all the rectangle corners

  CGPoint *cornersPoint = (CGPoint*) malloc(4*sizeof(CGPoint));
  cornersPoint[0] = [self cornerFrom: kTopLeftCorner];
  cornersPoint[1] = [self cornerFrom: kTopRightCorner];
  cornersPoint[2] = [self cornerFrom: kBottomRightCorner];
  cornersPoint[3] = [self cornerFrom: kBottomLeftCorner];
  return cornersPoint;
}

- (id)initWithOrigin:(CGPoint)o width:(CGFloat)w height:(CGFloat)h rotation:(CGFloat)r{
  // MODIFIES: self
  // EFFECTS: initializes the state of this rectangle with origin, width,
  //          height, and rotation angle in degrees
    self.origin = o;
    self.rotation = 0;
    self.width = w;
    self.height = h;
    [self rotate:r];
    return self;
}

- (id)initWithRect:(CGRect)rect {
  // MODIFIES: self
  // EFFECTS: initializes the state of this rectangle using a CGRect
    return [self initWithOrigin:rect.origin width:rect.size.width height:rect.size.height rotation:0];
}

- (void)rotate:(CGFloat)angle {
  // MODIFIES: self
  // EFFECTS: rotates this shape anti-clockwise by the specified angle
  // around the center of mass
    self.rotation += angle;
    self.corners = [self corners];//reset the value
}

- (void)translateX:(CGFloat)dx Y:(CGFloat)dy {
  // MODIFIES: self
  // EFFECTS: translates this shape by the specified dx (along the
  //            X-axis) and dy coordinates (along the Y-axis)
    self.origin = CGPointMake(self.origin.x + dx, self.origin.y + dy);
}

- (BOOL)overlapsWithShape:(id<PEShape>)shape {
  // EFFECTS: returns YES if this shape overlaps with specified shape.
  
  if ([shape class] == [PERectangle class]) {
    return [self overlapsWithRect:(PERectangle *)shape];
  }

  return NO;
}

- (BOOL)overlapsWithRect:(PERectangle*)rect {
  // EFFECTS: returns YES if this shape overlaps with specified shape.
  // <add missing code here>
    if([self isNotOverLappingPartialTest:rect.corners :self]||[self isNotOverLappingPartialTest:self.corners :rect])
        return NO;
    return YES;
}

- (BOOL) isNotOverLappingPartialTest:(CGPoint *)Mcorners :(PERectangle*)rect{
   
    CGPoint* edges = (CGPoint*) malloc(4*sizeof(CGPoint));
    edges[0] = CGPointMake(rect.corners[0].x - rect.corners[1].x, rect.corners[1].y - rect.corners[0].y);
    edges[1] = CGPointMake(rect.corners[1].x - rect.corners[2].x, rect.corners[2].y - rect.corners[1].y);
    edges[2] = CGPointMake(rect.corners[2].x - rect.corners[3].x, rect.corners[3].y - rect.corners[2].y);
    edges[3] = CGPointMake(rect.corners[3].x - rect.corners[0].x, rect.corners[0].y - rect.corners[3].y);
    
    CGFloat A;
    CGFloat B;
    CGFloat C;
    // justify if there is an edge can seperate two rectangles
    // edges are the four sides of $rect
    // edge = (x1-x2,y1-y2)
    // let A=y2-y1; B=x1-x2; C=x2*y1-x1*y2;
    // and D=A*xp+B*yp+C  if D>0 point (xp,yp) on the left side, D<0 point(xp,yp) on the right side. D=0 point on the edge
    for (int i=0; i<4; i++) {
        A = edges[i].y;
        B = edges[i].x;
        C = rect.corners[(i+1)%4].x*rect.corners[i%4].y - rect.corners[i%4].x*rect.corners[(i+1)%4].y;
        if (([self sign:A:B:C:Mcorners[0]]==[self sign:A:B:C:Mcorners[1]])&&
            ([self sign:A:B:C:Mcorners[1]]==[self sign:A:B:C:Mcorners[2]])&&
            ([self sign:A:B:C:Mcorners[2]]==[self sign:A:B:C:Mcorners[3]])&&
            ([self sign:A:B:C:rect.corners[(i+2)%4]]!= [self sign:A:B:C:Mcorners[0]])&&
            ([self sign:A:B:C:rect.corners[(i+3)%4]]!= [self sign:A:B:C:Mcorners[0]])
           )
        {
            return YES;
        }
    }
    return NO;
}

- (int) sign:(CGFloat)A:(CGFloat)B:(CGFloat)C:(CGPoint)point{
    CGFloat D = A*point.x + B*point.y + C;
    if (D>0) {
        return 1;
    }else if(D<0){
        return -1;
    }
    return 0;
}

- (CGRect)boundingBox {
  // EFFECTS: returns the bounding box of this shape.
    
  // optional implementation (not graded)
  return CGRectMake(INFINITY, INFINITY, INFINITY, INFINITY);
}

@end


//
//  GameObject.h
// 
// You can add your own prototypes in this file
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "Rectangle.h"

#define ZERO 0
#define SCALE_ZOOMIN 1.01
#define SCALE_ZOOMOUT 0.99
#define TOPBARHEIGHT 145
#define MAX_SCALE 2
#define MIN_SCALE 1
#define ORIGIN_SCALE 1
#define NUM_DOUBLETAP 2
#define NUM_SINGLETAP 1


// Constants for the three game objects to be implemented
typedef enum {kGameObjectWolf=1, kGameObjectPig=2, kGameObjectWind = 3, kGameObjectBlock=4} GameObjectType;

typedef enum {GameBlockWood = 5, GameBlockIron = 6, GameBlockStone = 7} BlockType;

@protocol myDelegate <NSObject>

- (UIView*) getTopBar;
- (UIScrollView*) getGameArea;
- (void) setGestures:(id) obj;
- (void) reset;
- (void) gameOver;

@end

@interface GameObject : UIViewController<UIGestureRecognizerDelegate,NSCoding,reDelegate> {
  // You might need to add state here.
    CGPoint center;
    CGAffineTransform transform;
    id<myDelegate> delegate;
}

@property (nonatomic) id<myDelegate> delegate;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGAffineTransform transform;
@property (nonatomic) GameObjectType objectType;
@property (nonatomic) int originX;//X cordinate in platte
@property (nonatomic) int originY;//Y coordinate in platte
@property (nonatomic,strong) UIImageView* selfImgView; //self image view
@property (nonatomic) UIScrollView* gamearea;//game information
@property (nonatomic) UIView* topBar;//game information
@property (nonatomic) int realWidth;//width and height showed in gamearea
@property (nonatomic) int realHeight;
@property (nonatomic) int originWidth;//width and height showed in topbar
@property (nonatomic) int originHeight;
@property (strong) GameObject* son; //son of a block(this property only used by GameBlock)
@property Rectangle* model;
@property UIImageView* animation;
@property int HP; //health point
@property UIImageView* pigDieAnimation;
@property UIImageView* pigDieSmoke;
@property Boolean isDie;
@property int flag;

- (void)translate:(UIGestureRecognizer *)gesture;
  // MODIFIES: object model (coordinates)
  // REQUIRES: game in designer mode
  // EFFECTS: the user drags around the object with one finger
  //          if the object is in the palette, it will be moved in the game area

- (void)rotate:(UIGestureRecognizer *)gesture;
  // MODIFIES: object model (rotation)
  // REQUIRES: game in designer mode, object in game area
  // EFFECTS: the object is rotated with a two-finger rotation gesture

- (void)zoom:(UIGestureRecognizer *)gesture;
  // MODIFIES: object model (size)
  // REQUIRES: game in designer mode, object in game area
  // EFFECTS: the object is scaled up/down with a pinch gesture

// You will need to define more methods to complete the specification.
- (id)initWithBackground:(UIScrollView*) downArea:(UIView*)upArea;
    //REQUIRES: game begins
    //EFFECTS: create a new object knowing the information of the game

- (void)assignModel;
    //make self become a delegate of the model

- (NSMutableArray*)getImgsWithName:(NSString*)name Row:(int)rowN Col:(int)colN;



@end

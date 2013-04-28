//
//  NSObject+GameViewControllerExtension.h
//  Game
//
//  Created by sai on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "GameObject.h"
#import "RectangleViewController.h"
#import "Rectangle.h"
#import "World.h"

#define DICTIONARY_NAME @"Storage House "
#define EMPTYSTRING @""
#define _SAVE @"Save Now"
#define NEW_SAVE @"New Save"
#define _LOAD @"~Load Your Game"
#define WARNING @"Warning: Delete"

@interface ViewController (Extension)

- (void)save;
// REQUIRES: game in designer mode
// EFFECTS: game objects are saved

- (void)load;
// MODIFIES: self (game objects)
// REQUIRES: game in designer mode
// EFFECTS: game objects are loaded

- (void)reset;

- (void)wolfHeartsBroke;

// MODIFIES: self (game objects)
// REQUIRES: game in designer mode
// EFFECTS: current game objects are deleted and palette contains all objects

- (void)delete;

- (void)loadFileWithIndex:(NSInteger)index levelInfo:(NSString*)level;

- (void)play;

@end

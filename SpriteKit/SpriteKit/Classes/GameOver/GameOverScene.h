//
//  GameOverScene.h
//  SpriteKit
//
//  Created by Thomas Dupont on 16/11/2013.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScene : SKScene

-(id)initWithSize:(CGSize)size won:(BOOL)won zombieKilled:(NSInteger)zombieKilled cranberriesShooted:(NSInteger)cranberriesShooted;

@end

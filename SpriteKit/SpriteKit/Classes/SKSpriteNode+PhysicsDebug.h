//
//  SKSpriteNode+PhysicsDebug.h
//  SpriteKit
//
//  Created by Thomas Dupont on 16/11/2013.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKSpriteNode (PhysicsDebug)

- (void)debugPhysicsWithPath:(UIBezierPath *)path;

- (void)debugPhysicsWithRadiusOfSize:(CGFloat)radius;

@end

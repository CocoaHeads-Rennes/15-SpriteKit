//
//  SKSpriteNode+PhysicsDebug.m
//  SpriteKit
//
//  Created by Thomas Dupont on 16/11/2013.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "SKSpriteNode+PhysicsDebug.h"

@implementation SKSpriteNode (PhysicsDebug)

- (void)debugPhysicsWithRadiusOfSize:(CGFloat)radius
{
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(- radius, - radius, radius * 2, radius * 2)];
    [self debugPhysicsWithPath:path];
}

- (void)debugPhysicsWithPath:(UIBezierPath *)path
{
    if (!self.physicsBody)
    {
        return;
    }
    
    SKShapeNode *debugNode = [SKShapeNode node];
    debugNode.path = path.CGPath;
    debugNode.lineWidth = 0.05;
    
    debugNode.fillColor = [SKColor colorWithRed:0 green:1 blue:0 alpha:0.5];

    [self addChild:debugNode];
}

@end

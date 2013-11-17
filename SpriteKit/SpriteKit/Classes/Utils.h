//
//  Utils.h
//  SpriteKit
//
//  Created by Thomas Dupont on 17/11/2013.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

static inline CGPoint skpNormalize(CGPoint pt)
{
    if (pt.x == 0 && pt.y == 0)
        return CGPointZero;
    float m = sqrtf(pt.x * pt.x + pt.y * pt.y);
    return CGPointMake(pt.x/m, pt.y/m);
}

static inline CGPoint skpAdd(CGPoint pt1, CGPoint pt2)
{
    return CGPointMake(pt1.x + pt2.x, pt1.y + pt2.y);
}

static inline CGPoint skpSubtract(CGPoint pt1, CGPoint pt2)
{
    return CGPointMake(pt1.x - pt2.x, pt1.y - pt2.y);
}

static inline CGPoint skpMultiply(CGPoint pt, float scalar)
{
    return CGPointMake(pt.x * scalar, pt.y * scalar);
}


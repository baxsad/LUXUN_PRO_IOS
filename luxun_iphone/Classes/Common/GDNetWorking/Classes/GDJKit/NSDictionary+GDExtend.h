//
//  NSDictionary+GDExtend.h
//  2HUO
//
//  Created by iURCoder on 4/13/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GDExtend)

- (NSString *)joinToPath;

- (id)objectAtPath:(NSString*)path;

@end

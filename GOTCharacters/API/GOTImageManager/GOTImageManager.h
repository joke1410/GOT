//
//  GOTImageManager.h
//  GOTCharacters
//
//  Created by Piotr Bruź on 15/09/15.
//  Copyright (c) 2015 Piotr Bruź. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GOTImageManager : NSObject

+ (GOTImageManager*)sharedInstance;

- (void)saveImage:(UIImage*)image filename:(NSString*)filename;
- (UIImage*)getImage:(NSString*)filename;

@end

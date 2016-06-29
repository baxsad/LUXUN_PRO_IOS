//
//  GDImagePickerController.h
//  2HUO
//
//  Created by iURCoder on 4/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDImagePickerController : UIViewController

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount;

@property (nonatomic, assign) NSInteger maxImagesCount;
@property (nonatomic, strong) NSArray* customSmartCollections;
@property (nonatomic, strong) NSArray* mediaTypes;
@property (nonatomic, assign) BOOL showCameraButton;
@property (nonatomic, assign) NSInteger colsInVertical;
@property (nonatomic, assign) NSInteger colsInLandscape;
@property (nonatomic, assign) double minimumInteritemSpacing;
@property (nonatomic, strong) UIColor *navBackgroundColor;
@property (nonatomic, assign) BOOL observerPhotoChange;

@end

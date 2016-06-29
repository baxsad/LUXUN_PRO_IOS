//
//  GDAssetManager.m
//  2HUO
//
//  Created by iURCoder on 4/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDAssetManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation GDAlbumModel

- (instancetype)initWithResult:(PHFetchResult *)result title:(NSString *)title
{
    if (self = [super init]) {
        self.results = result;
        self.title = title;
        self.count = result.count;
    }
    return self;
}

- (void)setResults:(PHFetchResult *)results
{
    _results = results;
    self.count = results.count;
}

@end

@implementation GDAssetModel

+ (instancetype)modelWithAsset:(id)asset
{
    GDAssetModel * obj = [[GDAssetModel alloc] init];
    if (obj && asset) {
        
        PHAsset *phasset = (PHAsset *)asset;
        obj.asset = phasset;
        obj.isSelected = NO;
        switch (phasset.mediaType) {
            case PHAssetMediaTypeUnknown:
                if (phasset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                    obj.type = GDAssetModelMediaTypeLivePhoto;
                }
                if (phasset.mediaSubtypes == PHAssetMediaSubtypePhotoHDR) {
                    obj.type = GDAssetModelMediaTypePhotoHDR;
                }
                break;
            case PHAssetMediaTypeImage:
                obj.type = GDAssetModelMediaTypePhoto;
                break;
            case PHAssetMediaTypeAudio:
                obj.type = GDAssetModelMediaTypeAudio;
                break;
            case PHAssetMediaTypeVideo:
                obj.type = GDAssetModelMediaTypeVideo;
                break;
                
            default:
                break;
        }
        
        NSString *timeLength = obj.type == GDAssetModelMediaTypeVideo ? [NSString stringWithFormat:@"%0.0f",phasset.duration] : @"";
        obj.timeLength = [obj getNewTimeFromDurationSecond:timeLength.integerValue];
        
    }else{
        return nil;
    }
    return obj;
}

- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"0:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"0:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}


@end

@interface GDAssetManager ()

@property (nonatomic,copy) NSArray *mediaTypes;
@property (nonatomic, strong) NSArray* customSmartCollections;
@property (nonatomic,strong) NSArray *collectionsFetchResults;
@property (nonatomic,strong) NSArray *collectionsLocalizedTitles;
@property (nonatomic,strong) NSArray *collectionsFetchResultsAssets;
@property (nonatomic,strong) NSArray *collectionsFetchResultsTitles;

@end

@implementation GDAssetManager

- (BOOL)authorizationStatusAuthorized {
    if (iOS8Later) {
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) return YES;
    } else {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) return YES;
    }
    return NO;
}

+ (instancetype)manager {
    static GDAssetManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.cachingImageManager = [[PHCachingImageManager alloc] init];
        manager.customSmartCollections = @[@(PHAssetCollectionSubtypeSmartAlbumFavorites),
                                           @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
                                           @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                           @(PHAssetCollectionSubtypeSmartAlbumSlomoVideos),
                                           @(PHAssetCollectionSubtypeSmartAlbumTimelapses),
                                           @(PHAssetCollectionSubtypeSmartAlbumBursts),
                                           @(PHAssetCollectionSubtypeSmartAlbumPanoramas)];
        manager.shouldFixOrientation = NO;
    });
    return manager;
}

- (void)getAllAlbums:(NSArray *)mediaTypes completion:(void (^)(NSArray<GDAlbumModel *> *models))completion
{
    self.mediaTypes = mediaTypes;
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    self.collectionsFetchResults = @[topLevelUserCollections, smartAlbums];
    self.collectionsLocalizedTitles = @[ @"Albums",@"Smart Albums"];
    [self updateFetchResultsCompletion:completion];
}

-(void)updateFetchResultsCompletion:(void (^)(NSArray<GDAssetModel *> *models))completion
{
    //What I do here is fetch both the albums list and the assets of each album.
    //This way I have acces to the number of items in each album, I can load the 3
    //thumbnails directly and I can pass the fetched result to the gridViewController.
    
    self.collectionsFetchResultsAssets=nil;
    self.collectionsFetchResultsTitles=nil;
    
    //Fetch PHAssetCollections:
    PHFetchResult *topLevelUserCollections = [self.collectionsFetchResults objectAtIndex:0];
    PHFetchResult *smartAlbums = [self.collectionsFetchResults objectAtIndex:1];
    
    //All album: Sorted by descending creation date.
    NSMutableArray *allFetchResultArray = [[NSMutableArray alloc] init];
    NSMutableArray *allFetchResultLabel = [[NSMutableArray alloc] init];
    {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", self.mediaTypes];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsWithOptions:options];
        [allFetchResultArray addObject:assetsFetchResult];
        [allFetchResultLabel addObject:@"All photos"];
    }
    
    //User albums:
    NSMutableArray *userFetchResultArray = [[NSMutableArray alloc] init];
    NSMutableArray *userFetchResultLabel = [[NSMutableArray alloc] init];
    for(PHCollection *collection in topLevelUserCollections)
    {
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", self.mediaTypes];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            //Albums collections are allways PHAssetCollectionType=1 & PHAssetCollectionSubtype=2
            
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            [userFetchResultArray addObject:assetsFetchResult];
            [userFetchResultLabel addObject:collection.localizedTitle];
        }
    }
    
    
    //Smart albums: Sorted by descending creation date.
    NSMutableArray *smartFetchResultArray = [[NSMutableArray alloc] init];
    NSMutableArray *smartFetchResultLabel = [[NSMutableArray alloc] init];
    for(PHCollection *collection in smartAlbums)
    {
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            //Smart collections are PHAssetCollectionType=2;
            if(self.customSmartCollections && [self.customSmartCollections containsObject:@(assetCollection.assetCollectionSubtype)])
            {
                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", self.mediaTypes];
                options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                
                PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
                if(assetsFetchResult.count>0)
                {
                    [smartFetchResultArray addObject:assetsFetchResult];
                    [smartFetchResultLabel addObject:collection.localizedTitle];
                }
            }
        }
    }
    
    self.collectionsFetchResultsAssets= @[allFetchResultArray,userFetchResultArray,smartFetchResultArray];
    self.collectionsFetchResultsTitles= @[allFetchResultLabel,userFetchResultLabel,smartFetchResultLabel];
    
    if (completion) {
        
        NSMutableArray * models = [NSMutableArray array];
        
        for (int i = 0; i < self.collectionsFetchResultsAssets.count; i++) {
            
            NSArray * assets = self.collectionsFetchResultsAssets[i];
            NSArray * titles = self.collectionsFetchResultsTitles[i];
            for (int k = 0; k < assets.count; k++) {
                
                GDAlbumModel * model = [[GDAlbumModel alloc] initWithResult:assets[k] title:titles[k]];
                [models addObject: model];
                
            }
            
        }
        
        completion(models);
        
    }
}


- (void)getPhotoWithAsset:(id)asset requestPhtotType:(GDPhotoRequestType)type targetSize:(CGSize)size options:(PHImageRequestOptions *)options completion:(void (^)(UIImage *photo,NSDictionary *info))completion
{
    
    [[GDAssetManager manager].cachingImageManager requestImageForAsset:asset
                                        targetSize:size
                                       contentMode:PHImageContentModeAspectFill
                                           options:options
                                     resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                         
                                         // 排除取消，错误，低清图三种情况，即已经获取到了高清图
                                         BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                                         
                                         if (result && downloadFinined) {
                                             result = [self fixOrientation:result];
                                             if (completion) completion(result,info);
                                         }
                                         
                                         // 从iCloud下载图片
                                         if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                                             PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
                                             option.networkAccessAllowed = YES;
                                             [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                 UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                                                 resultImage = [self scaleImage:resultImage toSize:size];
                                                 if (resultImage) {
                                                     resultImage = [self fixOrientation:resultImage];
                                                     if (completion) completion(resultImage,info);
                                                 }
                                             }];
                                         }
                                         
                                         
                                     }];
}

- (void)getThumbnailPhotoWithAssetModel:(GDAssetModel*)model size:(CGSize)size completion:(void (^)(UIImage *photo,NSDictionary *info))completion
{
    if (model.type == GDAssetModelMediaTypeCamera) {
        completion((UIImage *)model.asset,@{@"name":@"Camera"});
        return;
    }
    [self getThumbnailPhotoWithAsset:model.asset size:size completion:completion];
}

- (void)getThumbnailPhotoWithAsset:(id)asset size:(CGSize)size completion:(void (^)(UIImage *photo,NSDictionary *info))completion
{
    PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
    option.synchronous = NO;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [self getPhotoWithAsset:asset
           requestPhtotType:GDPhotoRequestTypeThumbnail
                 targetSize:size
                    options:option
                 completion:completion];
}

- (void)getOriginlPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion
{
    PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    
    [self getPhotoWithAsset:asset
           requestPhtotType:GDPhotoRequestTypeOriginl
                 targetSize:PHImageManagerMaximumSize
                    options:option
                 completion:completion];
}

- (void)getPreviewlPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion
{
    PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    CGSize previewSize = [UIScreen mainScreen].bounds.size;
    
    [self getPhotoWithAsset:asset
           requestPhtotType:GDPhotoRequestTypeThumbnail
                 targetSize:previewSize
                    options:option
                 completion:completion];
}


- (UIImage *)fixOrientation:(UIImage *)aImage {
    if (!self.shouldFixOrientation) return aImage;
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

@end

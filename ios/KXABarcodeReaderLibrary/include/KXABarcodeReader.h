/*
 KXABarcodeReader Library
 Copyright 2017 TAKAHASHI, Ryoji
 mailto:poohtaro@ukixa.com
 http://ukixa.com/
 */

#import <CoreVideo/CoreVideo.h>

#include "kxa_barcode_reader.h"

@interface KXABarcodeReader : NSObject
+ (KXABarcodeReader *)sharedInstance;
- (void)reset;
- (NSString *)decode:(CVImageBufferRef)imageBuffer;
@property (readonly) NSString *version;
@property (readonly) NSUInteger versionNumber;
@property (readonly) NSString *license;
@property (nonatomic,setter=setTypes:) NSInteger types;
@property NSInteger rotation;
@property (readonly) NSInteger type;
@property (readonly) NSString *text;
@end

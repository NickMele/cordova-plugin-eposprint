//
//  ePosConstantsConverter.h
//
//
//  Created by Siat Choon Ng on 3/1/18.
//

#import <Foundation/Foundation.h>

@interface ePosConstantsConverter : NSObject

+ (int)toBoolean:(NSString *)input;
+ (NSString *)toErrorText:(int)code;
+ (int)toPrinterSeries:(NSString *)model;
+ (int)toLanguageModel:(NSString *)lang;
+ (int)toLanguageCode:(NSString *)lang;
+ (int)toTextAlign:(NSString *)align;
+ (int)toTextFont:(NSString *)font;
+ (int)toTextColor:(NSString *)color;
+ (int)toColorMode:(NSString *)mode;
+ (int)toHalftoneMode:(NSString *)mode;
+ (int)toCompressMode:(NSString *)mode;
+ (int)toBarcodeType:(NSString *)type;
+ (int)toHriPosition:(NSString *)position;
+ (int)to2DSymbolType:(NSString *)type;
+ (int)to2DSymbolErrorCorrectionLevel:(NSString *)level;
+ (int)toLineStyle:(NSString *)style;
+ (int)toPageDirection:(NSString *)direction;
+ (int)toCutType:(NSString *)type;
+ (int)toSoundPattern:(NSString *)pattern;
+ (int)toFeedPosition:(NSString *)position;
+ (int)toLayout:(NSString *)layout;
+ (int)toDrawerPin:(NSString *)pin;
+ (int)toDrawerSignalTime:(NSString *)time;
+ (NSString *)toPaperStatusText:(int)code;
+ (NSString *)toDrawerStatusText:(int)code;
+ (NSString *)toErrorStatusText:(int)code;
+ (NSString *)toAutoRecoverErrorStatusText:(int)code;
+ (NSString *)toBatteryStatusText:(int)code;
+ (NSString *)toEventTypeText:(int)code;

@end

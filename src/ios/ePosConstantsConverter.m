//
//  ePosConstantsConverter.m
//
//
//  Created by Siat Choon Ng on 3/1/18.
//

#import "ePosConstantsConverter.h"
#import "ePOS2.h"

@interface ePosConstantsConverter ()

@end

@implementation ePosConstantsConverter

// convert to boolean
+ (int)toBoolean:(NSString *)input {
    int result = EPOS2_PARAM_DEFAULT;
    if ([input caseInsensitiveCompare:@"true"] == NSOrderedSame) {
        result = EPOS2_TRUE;
    }
    else if ([input caseInsensitiveCompare:@"false"] == NSOrderedSame) {
        result = EPOS2_FALSE;
    }
    return result;
}

// convert the error code to error string
+ (NSString *)toErrorText:(int)code {
    NSString *errText = @"";
    switch (code) {
        case EPOS2_SUCCESS:
            errText = @"Success";
            break;
        case EPOS2_ERR_PARAM:
            errText = @"An invalid parameter was specified";
            break;
        case EPOS2_ERR_CONNECT:
            errText = @"Failed to open the device";
            break;
        case EPOS2_ERR_TIMEOUT:
            errText = @"Failed to communicate with the devices within the specified time";
            break;
        case EPOS2_ERR_MEMORY:
            errText = @"Memory could not be allocated";
            break;
        case EPOS2_ERR_ILLEGAL:
            errText = @"An illegal operation has been called";
            break;
        case EPOS2_ERR_PROCESSING:
            errText = @"Could not run the process";
            break;
        case EPOS2_ERR_NOT_FOUND:
            errText = @"The entity could not be found";
            break;
        case EPOS2_ERR_IN_USE:
            errText = @"The device was in use";
            break;
        case EPOS2_ERR_TYPE_INVALID:
            errText = @"The device type is different";
            break;
        case EPOS2_ERR_DISCONNECT:
            errText = @"Failed to disconnect the device";
            break;
        case EPOS2_ERR_ALREADY_OPENED:
            errText = @"Target already in opened status";
            break;
        case EPOS2_ERR_ALREADY_USED:
            errText = @"Target already in been used status";
            break;
        case EPOS2_ERR_BOX_COUNT_OVER:
            errText = @"Box count over";
            break;
        case EPOS2_ERR_BOX_CLIENT_OVER:
            errText = @"Box client over";
            break;
        case EPOS2_ERR_UNSUPPORTED:
            errText = @"The entity parameters not supported was specified";
            break;
        case EPOS2_ERR_FAILURE:
            errText = @"An unknown error occurred";
            break;
        default:
            errText = [NSString stringWithFormat:@"Code %d", code];
            break;
    }
    return errText;
}

//convert the printer model to printer series
+ (int)toPrinterSeries:(NSString *)model   {
    int series = 0;
    if ([model caseInsensitiveCompare:@"TM-m10"] == NSOrderedSame) {
        series = EPOS2_TM_M10;
    }
    else if ([model caseInsensitiveCompare:@"TM-m30"] == NSOrderedSame) {
        series = EPOS2_TM_M30;
    }
    else if ([model caseInsensitiveCompare:@"TM-P20"] == NSOrderedSame) {
        series = EPOS2_TM_P20;
    }
    else if ([model caseInsensitiveCompare:@"TM-P60"] == NSOrderedSame) {
        series = EPOS2_TM_P60;
    }
    else if ([model caseInsensitiveCompare:@"TM-P60II"] == NSOrderedSame) {
        series = EPOS2_TM_P60II;
    }
    else if ([model caseInsensitiveCompare:@"TM-P80"] == NSOrderedSame) {
        series = EPOS2_TM_P80;
    }
    else if ([model caseInsensitiveCompare:@"TM-T20"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-T20II"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-T20II-i"] == NSOrderedSame) {
        series = EPOS2_TM_T20;
    }
    else if ([model caseInsensitiveCompare:@"TM-T60"] == NSOrderedSame) {
        series = EPOS2_TM_T60;
    }
    else if ([model caseInsensitiveCompare:@"TM-T70"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-T70-i"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-T70II"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-T70II-DT"] == NSOrderedSame) {
        series = EPOS2_TM_T70;
    }
    else if ([model caseInsensitiveCompare:@"TM-T81II"] == NSOrderedSame) {
        series = EPOS2_TM_T81;
    }
    else if ([model caseInsensitiveCompare:@"TM-T82"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-T82II"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-T82II-i"] == NSOrderedSame) {
        series = EPOS2_TM_T82;
    }
    else if ([model caseInsensitiveCompare:@"TM-T83II-i"] == NSOrderedSame) {
        series = EPOS2_TM_T83;
    }
    else if ([model caseInsensitiveCompare:@"TM-T88IV"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-T88V"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-T88VI"] == NSOrderedSame ||
             [model caseInsensitiveCompare:@"TM-T88V-i"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-T88VI-iHUB"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-T88V-DT"] == NSOrderedSame) {
        series = EPOS2_TM_T88;
    }
    else if ([model caseInsensitiveCompare:@"TM-T90"] == NSOrderedSame) {
        series = EPOS2_TM_T90;
    }
    else if ([model caseInsensitiveCompare:@"TM-U220"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-U220-i"] == NSOrderedSame) {
        series = EPOS2_TM_U220;
    }
    else if ([model caseInsensitiveCompare:@"TM-U330"] == NSOrderedSame) {
        series = EPOS2_TM_U330;
    }
    else if ([model caseInsensitiveCompare:@"TM-L90"] == NSOrderedSame) {
        series = EPOS2_TM_L90;
    }
    else if ([model caseInsensitiveCompare:@"TM-H6000IV"] == NSOrderedSame || [model caseInsensitiveCompare:@"TM-H6000IV-DT"] == NSOrderedSame) {
        series = EPOS2_TM_H6000;
    }
    return series;
}

// covert to language model
+ (int)toLanguageModel:(NSString *)lang {
    int code = EPOS2_MODEL_ANK;
    if ([lang caseInsensitiveCompare:@"ANK"] == NSOrderedSame) {
        code = EPOS2_MODEL_ANK;
    }
    else if ([lang caseInsensitiveCompare:@"SimplifiedChinese"] == NSOrderedSame) {
        code = EPOS2_MODEL_CHINESE;
    }
    else if ([lang caseInsensitiveCompare:@"Taiwan"] == NSOrderedSame) {
        code = EPOS2_MODEL_TAIWAN;
    }
    else if ([lang caseInsensitiveCompare:@"Korean"] == NSOrderedSame) {
        code = EPOS2_MODEL_KOREAN;
    }
    else if ([lang caseInsensitiveCompare:@"Thai"] == NSOrderedSame) {
        code = EPOS2_MODEL_THAI;
    }
    else if ([lang caseInsensitiveCompare:@"SouthAsian"] == NSOrderedSame) {
        code = EPOS2_MODEL_SOUTHASIA;
    }
    return code;
}

// covert to language
+ (int)toLanguageCode:(NSString *)lang {
    int code = EPOS2_PARAM_DEFAULT;
    if ([lang caseInsensitiveCompare:@"English"] == NSOrderedSame) {
        code = EPOS2_LANG_EN;
    }
    else if ([lang caseInsensitiveCompare:@"Japanese"] == NSOrderedSame) {
        code = EPOS2_LANG_JA;
    }
    else if ([lang caseInsensitiveCompare:@"SimplifiedChinese"] == NSOrderedSame) {
        code = EPOS2_LANG_ZH_CN;
    }
    else if ([lang caseInsensitiveCompare:@"TraditionalChinese"] == NSOrderedSame) {
        code = EPOS2_LANG_ZH_TW;
    }
    else if ([lang caseInsensitiveCompare:@"Korean"] == NSOrderedSame) {
        code = EPOS2_LANG_KO;
    }
    else if ([lang caseInsensitiveCompare:@"Thai"] == NSOrderedSame) {
        code = EPOS2_LANG_TH;
    }
    else if ([lang caseInsensitiveCompare:@"Vietnamese"] == NSOrderedSame) {
        code = EPOS2_LANG_VI;
    }
    return code;
}

// convert to text alignment
+ (int)toTextAlign:(NSString *)align {
    int code = EPOS2_PARAM_DEFAULT;
    if ([align caseInsensitiveCompare:@"Left"] == NSOrderedSame) {
        code = EPOS2_ALIGN_LEFT;
    }
    else if ([align caseInsensitiveCompare:@"Center"] == NSOrderedSame) {
        code = EPOS2_ALIGN_CENTER;
    }
    else if ([align caseInsensitiveCompare:@"Right"] == NSOrderedSame) {
        code = EPOS2_ALIGN_RIGHT;
    }
    return code;
}

// convert to text font
+ (int)toTextFont:(NSString *)font {
    int code = EPOS2_PARAM_DEFAULT;
    if ([font caseInsensitiveCompare:@"FontA"] == NSOrderedSame) {
        code = EPOS2_FONT_A;
    }
    else if ([font caseInsensitiveCompare:@"FontB"] == NSOrderedSame) {
        code = EPOS2_FONT_B;
    }
    else if ([font caseInsensitiveCompare:@"FontC"] == NSOrderedSame) {
        code = EPOS2_FONT_C;
    }
    else if ([font caseInsensitiveCompare:@"FontD"] == NSOrderedSame) {
        code = EPOS2_FONT_D;
    }
    else if ([font caseInsensitiveCompare:@"FontE"] == NSOrderedSame) {
        code = EPOS2_FONT_E;
    }
    return code;
}

// convert to text color
+ (int)toTextColor:(NSString *)color {
    int code = EPOS2_PARAM_DEFAULT;
    if ([color caseInsensitiveCompare:@"None"] == NSOrderedSame) {
        code = EPOS2_COLOR_NONE;
    }
    else if ([color caseInsensitiveCompare:@"Color1"] == NSOrderedSame) {
        code = EPOS2_COLOR_1;
    }
    else if ([color caseInsensitiveCompare:@"Color2"] == NSOrderedSame) {
        code = EPOS2_COLOR_2;
    }
    else if ([color caseInsensitiveCompare:@"Color3"] == NSOrderedSame) {
        code = EPOS2_COLOR_3;
    }
    else if ([color caseInsensitiveCompare:@"Color4"] == NSOrderedSame) {
        code = EPOS2_COLOR_4;
    }
    return code;
}

// convert to color mode
+ (int)toColorMode:(NSString *)mode {
    int code = EPOS2_PARAM_DEFAULT;
    if ([mode caseInsensitiveCompare:@"Monochrome"] == NSOrderedSame) {
        code = EPOS2_MODE_MONO;
    }
    else if ([mode caseInsensitiveCompare:@"Multigradation"] == NSOrderedSame) {
        code = EPOS2_MODE_GRAY16;
    }
    else if ([mode caseInsensitiveCompare:@"MonochromeDoubleDensity"] == NSOrderedSame) {
        code = EPOS2_MODE_MONO_HIGH_DENSITY;
    }
    return code;
}

// convert to halftone mode
+ (int)toHalftoneMode:(NSString *)mode {
    int code = EPOS2_PARAM_DEFAULT;
    if ([mode caseInsensitiveCompare:@"Dithering"] == NSOrderedSame) {
        code = EPOS2_HALFTONE_DITHER;
    }
    else if ([mode caseInsensitiveCompare:@"ErrorDiffusion"] == NSOrderedSame) {
        code = EPOS2_HALFTONE_ERROR_DIFFUSION;
    }
    else if ([mode caseInsensitiveCompare:@"Threshold"] == NSOrderedSame) {
        code = EPOS2_HALFTONE_THRESHOLD;
    }
    return code;
}

// convert to compress mode
+ (int)toCompressMode:(NSString *)mode {
    int code = EPOS2_PARAM_DEFAULT;
    if ([mode caseInsensitiveCompare:@"Compresses"] == NSOrderedSame) {
        code = EPOS2_COMPRESS_DEFLATE;
    }
    else if ([mode caseInsensitiveCompare:@"NoCompresses"] == NSOrderedSame) {
        code = EPOS2_COMPRESS_NONE;
    }
    else if ([mode caseInsensitiveCompare:@"Auto"] == NSOrderedSame) {
        code = EPOS2_COMPRESS_AUTO;
    }
    return code;
}

// convert to barcode type
+ (int)toBarcodeType:(NSString *)type {
    int code = EPOS2_BARCODE_CODE39;
    if ([type caseInsensitiveCompare:@"UPC-A"] == NSOrderedSame) {
        code = EPOS2_BARCODE_UPC_A;
    }
    else if ([type caseInsensitiveCompare:@"UPC-E"] == NSOrderedSame) {
        code = EPOS2_BARCODE_UPC_E;
    }
    else if ([type caseInsensitiveCompare:@"EAN13"] == NSOrderedSame) {
        code = EPOS2_BARCODE_EAN13;
    }
    else if ([type caseInsensitiveCompare:@"JAN13"] == NSOrderedSame) {
        code = EPOS2_BARCODE_JAN13;
    }
    else if ([type caseInsensitiveCompare:@"EAN8"] == NSOrderedSame) {
        code = EPOS2_BARCODE_EAN8;
    }
    else if ([type caseInsensitiveCompare:@"JAN8"] == NSOrderedSame) {
        code = EPOS2_BARCODE_JAN8;
    }
    else if ([type caseInsensitiveCompare:@"CODE39"] == NSOrderedSame) {
        code = EPOS2_BARCODE_CODE39;
    }
    else if ([type caseInsensitiveCompare:@"ITF"] == NSOrderedSame) {
        code = EPOS2_BARCODE_ITF;
    }
    else if ([type caseInsensitiveCompare:@"CODABAR"] == NSOrderedSame) {
        code = EPOS2_BARCODE_CODABAR;
    }
    else if ([type caseInsensitiveCompare:@"CODE93"] == NSOrderedSame) {
        code = EPOS2_BARCODE_CODE93;
    }
    else if ([type caseInsensitiveCompare:@"CODE128"] == NSOrderedSame) {
        code = EPOS2_BARCODE_CODE128;
    }
    else if ([type caseInsensitiveCompare:@"GS1-128"] == NSOrderedSame) {
        code = EPOS2_BARCODE_GS1_128;
    }
    else if ([type caseInsensitiveCompare:@"GS1 DataBar Omnidirectional"] == NSOrderedSame) {
        code = EPOS2_BARCODE_GS1_DATABAR_OMNIDIRECTIONAL;
    }
    else if ([type caseInsensitiveCompare:@"GS1 DataBar Truncated"] == NSOrderedSame) {
        code = EPOS2_BARCODE_GS1_DATABAR_TRUNCATED;
    }
    else if ([type caseInsensitiveCompare:@"GS1 DataBar Limited"] == NSOrderedSame) {
        code = EPOS2_BARCODE_GS1_DATABAR_LIMITED;
    }
    else if ([type caseInsensitiveCompare:@"GS1 DataBar Expanded"] == NSOrderedSame) {
        code = EPOS2_BARCODE_GS1_DATABAR_EXPANDED;
    }
    return code;
}

// convert to HRI position
+ (int)toHriPosition:(NSString *)position {
    int code = EPOS2_PARAM_DEFAULT;
    if ([position caseInsensitiveCompare:@"None"] == NSOrderedSame) {
        code = EPOS2_HRI_NONE;
    }
    else if ([position caseInsensitiveCompare:@"Above"] == NSOrderedSame) {
        code = EPOS2_HRI_ABOVE;
    }
    else if ([position caseInsensitiveCompare:@"Below"] == NSOrderedSame) {
        code = EPOS2_HRI_BELOW;
    }
    else if ([position caseInsensitiveCompare:@"Both"] == NSOrderedSame) {
        code = EPOS2_HRI_BOTH;
    }
    return code;
}

// convert to SD symbol type
+ (int)to2DSymbolType:(NSString *)type {
    int code = EPOS2_SYMBOL_PDF417_STANDARD;
    if ([type caseInsensitiveCompare:@"Standard PDF417"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_PDF417_STANDARD;
    }
    else if ([type caseInsensitiveCompare:@"Truncated PDF417"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_PDF417_TRUNCATED;
    }
    else if ([type caseInsensitiveCompare:@"QR Code Model 1"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_QRCODE_MODEL_1;
    }
    else if ([type caseInsensitiveCompare:@"QR Code Model 2"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_QRCODE_MODEL_2;
    }
    else if ([type caseInsensitiveCompare:@"QR Code Micro"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_QRCODE_MICRO;
    }
    else if ([type caseInsensitiveCompare:@"MaxiCode Mode 2"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_MAXICODE_MODE_2;
    }
    else if ([type caseInsensitiveCompare:@"MaxiCode Mode 3"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_MAXICODE_MODE_3;
    }
    else if ([type caseInsensitiveCompare:@"MaxiCode Mode 4"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_MAXICODE_MODE_4;
    }
    else if ([type caseInsensitiveCompare:@"MaxiCode Mode 5"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_MAXICODE_MODE_5;
    }
    else if ([type caseInsensitiveCompare:@"MaxiCode Mode 6"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_MAXICODE_MODE_6;
    }
    else if ([type caseInsensitiveCompare:@"GS1 DataBar Stacked"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_GS1_DATABAR_STACKED;
    }
    else if ([type caseInsensitiveCompare:@"GS1 DataBar Stacked Omnidirectional"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_GS1_DATABAR_STACKED_OMNIDIRECTIONAL;
    }
    else if ([type caseInsensitiveCompare:@"GS1 DataBar Expanded Stacked"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_GS1_DATABAR_EXPANDED_STACKED;
    }
    else if ([type caseInsensitiveCompare:@"Aztec Code Full-Range mode"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_AZTECCODE_FULLRANGE;
    }
    else if ([type caseInsensitiveCompare:@"Aztec Code Compact mode"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_AZTECCODE_COMPACT;
    }
    else if ([type caseInsensitiveCompare:@"DataMatrix Square"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_DATAMATRIX_SQUARE;
    }
    else if ([type caseInsensitiveCompare:@"DataMatrix Rectangle 8 lines"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_DATAMATRIX_RECTANGLE_8;
    }
    else if ([type caseInsensitiveCompare:@"DataMatrix Rectangle 12 lines"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_DATAMATRIX_RECTANGLE_12;
    }
    else if ([type caseInsensitiveCompare:@"DataMatrix Rectangle 16 lines"] == NSOrderedSame) {
        code = EPOS2_SYMBOL_DATAMATRIX_RECTANGLE_16;
    }
    return code;
}

// convert to 2D symbol error correction level
+ (int)to2DSymbolErrorCorrectionLevel:(NSString *)level {
    int code = EPOS2_PARAM_DEFAULT;
    if ([level caseInsensitiveCompare:@"Level0"] == NSOrderedSame) {
        code = EPOS2_LEVEL_0;
    }
    else if ([level caseInsensitiveCompare:@"Level1"] == NSOrderedSame) {
        code = EPOS2_LEVEL_1;
    }
    else if ([level caseInsensitiveCompare:@"Level2"] == NSOrderedSame) {
        code = EPOS2_LEVEL_2;
    }
    else if ([level caseInsensitiveCompare:@"Level3"] == NSOrderedSame) {
        code = EPOS2_LEVEL_3;
    }
    else if ([level caseInsensitiveCompare:@"Level4"] == NSOrderedSame) {
        code = EPOS2_LEVEL_4;
    }
    else if ([level caseInsensitiveCompare:@"Level5"] == NSOrderedSame) {
        code = EPOS2_LEVEL_5;
    }
    else if ([level caseInsensitiveCompare:@"Level6"] == NSOrderedSame) {
        code = EPOS2_LEVEL_6;
    }
    else if ([level caseInsensitiveCompare:@"Level7"] == NSOrderedSame) {
        code = EPOS2_LEVEL_7;
    }
    else if ([level caseInsensitiveCompare:@"Level8"] == NSOrderedSame) {
        code = EPOS2_LEVEL_8;
    }
    else if ([level caseInsensitiveCompare:@"LevelL"] == NSOrderedSame) {
        code = EPOS2_LEVEL_L;
    }
    else if ([level caseInsensitiveCompare:@"LevelM"] == NSOrderedSame) {
        code = EPOS2_LEVEL_M;
    }
    else if ([level caseInsensitiveCompare:@"LevelQ"] == NSOrderedSame) {
        code = EPOS2_LEVEL_Q;
    }
    else if ([level caseInsensitiveCompare:@"LevelH"] == NSOrderedSame) {
        code = EPOS2_LEVEL_H;
    }
    else if (level.length >= 2) {
        NSUInteger length = level.length;
        NSRange range = [level rangeOfString:@"%"];
        if (range.location == length - 1 && range.location != NSNotFound) {
            NSString *percentage = [level substringToIndex:length - 1];
            code = [percentage intValue];
        }
    }
    return code;
}

// convert to line style
+ (int)toLineStyle:(NSString *)style {
    int code = EPOS2_PARAM_DEFAULT;
    if ([style caseInsensitiveCompare:@"SolidThin"] == NSOrderedSame) {
        code = EPOS2_LINE_THIN;
    }
    else if ([style caseInsensitiveCompare:@"SolidMedium"] == NSOrderedSame) {
        code = EPOS2_LINE_MEDIUM;
    }
    else if ([style caseInsensitiveCompare:@"SolidThick"] == NSOrderedSame) {
        code = EPOS2_LINE_THICK;
    }
    else if ([style caseInsensitiveCompare:@"DoubleThin"] == NSOrderedSame) {
        code = EPOS2_LINE_THIN_DOUBLE;
    }
    else if ([style caseInsensitiveCompare:@"DoubleMedium"] == NSOrderedSame) {
        code = EPOS2_LINE_MEDIUM_DOUBLE;
    }
    else if ([style caseInsensitiveCompare:@"DoubleThick"] == NSOrderedSame) {
        code = EPOS2_LINE_THICK_DOUBLE;
    }
    return code;
}

// convert to page direction
+ (int)toPageDirection:(NSString *)direction {
    int code = EPOS2_PARAM_DEFAULT;
    if ([direction caseInsensitiveCompare:@"LeftToRight"] == NSOrderedSame) {
        code = EPOS2_DIRECTION_LEFT_TO_RIGHT;
    }
    else if ([direction caseInsensitiveCompare:@"BottomToTop"] == NSOrderedSame) {
        code = EPOS2_DIRECTION_BOTTOM_TO_TOP;
    }
    else if ([direction caseInsensitiveCompare:@"RightToLeft"] == NSOrderedSame) {
        code = EPOS2_DIRECTION_RIGHT_TO_LEFT;
    }
    else if ([direction caseInsensitiveCompare:@"TopToBottom"] == NSOrderedSame) {
        code = EPOS2_DIRECTION_TOP_TO_BOTTOM;
    }
    return code;
}

// convert to cut type
+ (int)toCutType:(NSString *)type {
    int code = EPOS2_PARAM_DEFAULT;
    if ([type caseInsensitiveCompare:@"CutFeed"] == NSOrderedSame) {
        code = EPOS2_CUT_FEED;
    }
    else if ([type caseInsensitiveCompare:@"CutNoFeed"] == NSOrderedSame) {
        code = EPOS2_CUT_NO_FEED;
    }
    else if ([type caseInsensitiveCompare:@"CutReserve"] == NSOrderedSame) {
        code = EPOS2_CUT_RESERVE;
    }
    return code;
}

// convert to sound pattern
+ (int)toSoundPattern:(NSString *)pattern {
    int code = EPOS2_PARAM_DEFAULT;
    if ([pattern caseInsensitiveCompare:@"None"] == NSOrderedSame) {
        code = EPOS2_PATTERN_NONE;
    }
    else if ([pattern caseInsensitiveCompare:@"PatternA"] == NSOrderedSame) {
        code = EPOS2_PATTERN_A;
    }
    else if ([pattern caseInsensitiveCompare:@"PatternB"] == NSOrderedSame) {
        code = EPOS2_PATTERN_B;
    }
    else if ([pattern caseInsensitiveCompare:@"PatternC"] == NSOrderedSame) {
        code = EPOS2_PATTERN_C;
    }
    else if ([pattern caseInsensitiveCompare:@"PatternD"] == NSOrderedSame) {
        code = EPOS2_PATTERN_D;
    }
    else if ([pattern caseInsensitiveCompare:@"PatternE"] == NSOrderedSame) {
        code = EPOS2_PATTERN_E;
    }
    else if ([pattern caseInsensitiveCompare:@"PatternError"] == NSOrderedSame) {
        code = EPOS2_PATTERN_ERROR;
    }
    else if ([pattern caseInsensitiveCompare:@"PatternPaperEmpty"] == NSOrderedSame) {
        code = EPOS2_PATTERN_PAPER_EMPTY;
    }
    else if ([pattern caseInsensitiveCompare:@"Pattern1"] == NSOrderedSame) {
        code = EPOS2_PATTERN_1;
    }
    else if ([pattern caseInsensitiveCompare:@"Pattern2"] == NSOrderedSame) {
        code = EPOS2_PATTERN_2;
    }
    else if ([pattern caseInsensitiveCompare:@"Pattern3"] == NSOrderedSame) {
        code = EPOS2_PATTERN_3;
    }
    else if ([pattern caseInsensitiveCompare:@"Pattern4"] == NSOrderedSame) {
        code = EPOS2_PATTERN_4;
    }
    else if ([pattern caseInsensitiveCompare:@"Pattern5"] == NSOrderedSame) {
        code = EPOS2_PATTERN_5;
    }
    else if ([pattern caseInsensitiveCompare:@"Pattern6"] == NSOrderedSame) {
        code = EPOS2_PATTERN_6;
    }
    else if ([pattern caseInsensitiveCompare:@"Pattern7"] == NSOrderedSame) {
        code = EPOS2_PATTERN_7;
    }
    else if ([pattern caseInsensitiveCompare:@"Pattern8"] == NSOrderedSame) {
        code = EPOS2_PATTERN_8;
    }
    else if ([pattern caseInsensitiveCompare:@"Pattern9"] == NSOrderedSame) {
        code = EPOS2_PATTERN_9;
    }
    else if ([pattern caseInsensitiveCompare:@"Pattern10"] == NSOrderedSame) {
        code = EPOS2_PATTERN_10;
    }
    return code;
}

// convert to feed position
+ (int)toFeedPosition:(NSString *)position {
    int code = EPOS2_FEED_CUTTING;
    if ([position caseInsensitiveCompare:@"Peeling"] == NSOrderedSame) {
        code = EPOS2_FEED_PEELING;
    }
    else if ([position caseInsensitiveCompare:@"Cutting"] == NSOrderedSame) {
        code = EPOS2_FEED_CUTTING;
    }
    else if ([position caseInsensitiveCompare:@"CurrentTOF"] == NSOrderedSame) {
        code = EPOS2_FEED_CURRENT_TOF;
    }
    else if ([position caseInsensitiveCompare:@"NextTOF"] == NSOrderedSame) {
        code = EPOS2_FEED_NEXT_TOF;
    }
    return code;
}

// convert to layout
+ (int)toLayout:(NSString *)layout {
    int code = EPOS2_FEED_CUTTING;
    if ([layout caseInsensitiveCompare:@"Receipt"] == NSOrderedSame) {
        code = EPOS2_LAYOUT_RECEIPT;
    }
    else if ([layout caseInsensitiveCompare:@"ReceiptWithBlackMark"] == NSOrderedSame) {
        code = EPOS2_LAYOUT_RECEIPT_BM;
    }
    else if ([layout caseInsensitiveCompare:@"LabelSheet"] == NSOrderedSame) {
        code = EPOS2_LAYOUT_LABEL;
    }
    else if ([layout caseInsensitiveCompare:@"LabelSheetWithBlackMark"] == NSOrderedSame) {
        code = EPOS2_LAYOUT_LABEL_BM;
    }
    return code;
}

// convert to drawer pin
+ (int)toDrawerPin:(NSString *)pin {
    int code = EPOS2_PARAM_DEFAULT;
    if ([pin caseInsensitiveCompare:@"Pin2"] == NSOrderedSame) {
        code = EPOS2_DRAWER_2PIN;
    }
    else if ([pin caseInsensitiveCompare:@"Pin5"] == NSOrderedSame) {
        code = EPOS2_DRAWER_5PIN;
    }
    return code;
}

// convert to drawer kick signal time
+ (int)toDrawerSignalTime:(NSString *)time {
    int code = EPOS2_PARAM_DEFAULT;
    if ([time caseInsensitiveCompare:@"100"] == NSOrderedSame) {
        code = EPOS2_PULSE_100;
    }
    else if ([time caseInsensitiveCompare:@"200"] == NSOrderedSame) {
        code = EPOS2_PULSE_200;
    }
    else if ([time caseInsensitiveCompare:@"300"] == NSOrderedSame) {
        code = EPOS2_PULSE_300;
    }
    else if ([time caseInsensitiveCompare:@"400"] == NSOrderedSame) {
        code = EPOS2_PULSE_400;
    }
    else if ([time caseInsensitiveCompare:@"500"] == NSOrderedSame) {
        code = EPOS2_PULSE_500;
    }
    return code;
}

// convert to paper status text
+ (NSString *)toPaperStatusText:(int)code {
    NSString *statusText = @"";
    switch (code) {
        case EPOS2_PAPER_OK:
            statusText = @"paperOk";
            break;
        case EPOS2_PAPER_NEAR_END:
            statusText = @"paperNearEnd";
            break;
        case EPOS2_PAPER_EMPTY:
            statusText = @"paperEmpty";
            break;
        default:
            statusText = @"unknown";
            break;
    }
    return statusText;
}

// convert to drawer status text
+ (NSString *)toDrawerStatusText:(int)code {
    NSString *statusText = @"";
    switch (code) {
        case EPOS2_DRAWER_HIGH:
            statusText = @"drawerHigh";
            break;
        case EPOS2_DRAWER_LOW:
            statusText = @"drawerLow";
            break;
        default:
            statusText = @"unknown";
            break;
    }
    return statusText;
}

// convert to error status text
+ (NSString *)toErrorStatusText:(int)code {
    NSString *statusText = @"";
    switch (code) {
        case EPOS2_NO_ERR:
            statusText = @"normal";
            break;
        case EPOS2_MECHANICAL_ERR:
            statusText = @"mechanical";
            break;
        case EPOS2_AUTOCUTTER_ERR:
            statusText = @"autoCutter";
            break;
        case EPOS2_UNRECOVER_ERR:
            statusText = @"unrecover";
            break;
        case EPOS2_AUTORECOVER_ERR:
            statusText = @"autoRecover";
            break;
        default:
            statusText = @"unknown";
            break;
    }
    return statusText;
}

// convert to auto recover error status text
+ (NSString *)toAutoRecoverErrorStatusText:(int)code {
    NSString *statusText = @"";
    switch (code) {
        case EPOS2_HEAD_OVERHEAT:
            statusText = @"headOverheat";
            break;
        case EPOS2_MOTOR_OVERHEAT:
            statusText = @"motorDriverOverheat";
            break;
        case EPOS2_BATTERY_OVERHEAT:
            statusText = @"batteryOverheat";
            break;
        case EPOS2_WRONG_PAPER:
            statusText = @"paper";
            break;
        case EPOS2_COVER_OPEN:
            statusText = @"coverOpen";
            break;
        default:
            statusText = @"unknown";
            break;
    }
    return statusText;
}

// convert to battery status text
+ (NSString *)toBatteryStatusText:(int)code {
    NSString *statusText = @"";
    switch (code) {
        case EPOS2_BATTERY_LEVEL_6:
            statusText = @"6";
            break;
        case EPOS2_BATTERY_LEVEL_5:
            statusText = @"5";
            break;
        case EPOS2_BATTERY_LEVEL_4:
            statusText = @"4";
            break;
        case EPOS2_BATTERY_LEVEL_3:
            statusText = @"3";
            break;
        case EPOS2_BATTERY_LEVEL_2:
            statusText = @"2";
            break;
        case EPOS2_BATTERY_LEVEL_1:
            statusText = @"1";
            break;
        case EPOS2_BATTERY_LEVEL_0:
            statusText = @"0";
            break;
        default:
            statusText = @"unknown";
            break;
    }
    return statusText;
}

// convert to event type text
+ (NSString *)toEventTypeText:(int)code {
    NSString *statusText = @"";
    switch (code) {
        case EPOS2_EVENT_ONLINE:
            statusText = @"Printer online";
            break;
        case EPOS2_EVENT_OFFLINE:
            statusText = @"Printer offline";
            break;
        case EPOS2_EVENT_POWER_OFF:
            statusText = @"Printer powered off";
            break;
        case EPOS2_EVENT_COVER_CLOSE:
            statusText = @"Printer cover closed";
            break;
        case EPOS2_EVENT_COVER_OPEN:
            statusText = @"Printer Cover open";
            break;
        case EPOS2_EVENT_PAPER_OK:
            statusText = @"Printer paper roll okay.";
            break;
        case EPOS2_EVENT_PAPER_NEAR_END:
            statusText = @"Printer paper has almost run out.";
            break;
        case EPOS2_EVENT_PAPER_EMPTY:
            statusText = @"Printer paper has run out.";
            break;
        case EPOS2_EVENT_DRAWER_HIGH:
            statusText = @"Drawer kick connector pin No.3 status = 'H'";
            break;
        case EPOS2_EVENT_DRAWER_LOW:
            statusText = @"Drawer kick connector pin No.3 status = 'L'";
            break;
        case EPOS2_EVENT_BATTERY_ENOUGH:
            statusText = @"Printer battery is enough.";
            break;
        case EPOS2_EVENT_BATTERY_EMPTY:
            statusText = @"Printer battery has run out.";
            break;
        default:
            statusText = @"unknown";
            break;
    }
    return statusText;
}

@end

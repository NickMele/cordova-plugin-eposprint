//
//  ePosPrinter.h
//
//
//  Created by Siat Choon Ng on 1/1/18.
//

#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>
#import "ePOS2.h"

@interface ePosPrinter : CDVPlugin

- (void)handleReceiveEvent:(CDVInvokedUrlCommand *)command;
- (void)handleStatusEvent:(CDVInvokedUrlCommand *)command;
- (void)startDiscover:(CDVInvokedUrlCommand *)command;
- (void)getDiscoveredPrinters:(CDVInvokedUrlCommand *)command;
- (void)stopDiscover:(CDVInvokedUrlCommand *)command;
- (void)initializePrinter:(CDVInvokedUrlCommand *)command;
- (void)connect:(CDVInvokedUrlCommand *)command;
- (void)disconnect:(CDVInvokedUrlCommand *)command;
- (void)getStatus:(CDVInvokedUrlCommand *)command;
- (void)sendData:(CDVInvokedUrlCommand *)command;
- (void)beginTransaction:(CDVInvokedUrlCommand *)command;
- (void)endTransaction:(CDVInvokedUrlCommand *)command;
- (void)requestPrintJobStatus:(CDVInvokedUrlCommand *)command;
- (void)clearCommandBuffer:(CDVInvokedUrlCommand *)command;
- (void)addTextAlign:(CDVInvokedUrlCommand *)command;
- (void)addLineSpace:(CDVInvokedUrlCommand *)command;
- (void)addTextRotate:(CDVInvokedUrlCommand *)command;
- (void)addText:(CDVInvokedUrlCommand *)command;
- (void)addTextLang:(CDVInvokedUrlCommand *)command;
- (void)addTextFont:(CDVInvokedUrlCommand *)command;
- (void)addTextSmooth:(CDVInvokedUrlCommand *)command;
- (void)addTextSize:(CDVInvokedUrlCommand *)command;
- (void)addTextStyle:(CDVInvokedUrlCommand *)command;
- (void)addHPosition:(CDVInvokedUrlCommand *)command;
- (void)addFeedUnit:(CDVInvokedUrlCommand *)command;
- (void)addFeedLine:(CDVInvokedUrlCommand *)command;
- (void)addImage:(CDVInvokedUrlCommand *)command;
- (void)addLogo:(CDVInvokedUrlCommand *)command;
- (void)addBarcode:(CDVInvokedUrlCommand *)command;
- (void)addSymbol:(CDVInvokedUrlCommand *)command;
- (void)addHLine:(CDVInvokedUrlCommand *)command;
- (void)addVLineBegin:(CDVInvokedUrlCommand *)command;
- (void)addVLineEnd:(CDVInvokedUrlCommand *)command;
- (void)addPageBegin:(CDVInvokedUrlCommand *)command;
- (void)addPageEnd:(CDVInvokedUrlCommand *)command;
- (void)addPageArea:(CDVInvokedUrlCommand *)command;
- (void)addPageDirection:(CDVInvokedUrlCommand *)command;
- (void)addPagePosition:(CDVInvokedUrlCommand *)command;
- (void)addPageLine:(CDVInvokedUrlCommand *)command;
- (void)addPageRectangle:(CDVInvokedUrlCommand *)command;
- (void)addCut:(CDVInvokedUrlCommand *)command;
- (void)addPulse:(CDVInvokedUrlCommand *)command;
- (void)addSound:(CDVInvokedUrlCommand *)command;
- (void)addFeedPosition:(CDVInvokedUrlCommand *)command;
- (void)addLayout:(CDVInvokedUrlCommand *)command;
- (void)addCommand:(CDVInvokedUrlCommand *)command;
- (void)forceRecover:(CDVInvokedUrlCommand *)command;
- (void)forcePulse:(CDVInvokedUrlCommand *)command;
- (void)forceStopSound:(CDVInvokedUrlCommand *)command;
- (void)forceCommand:(CDVInvokedUrlCommand *)command;
- (void)forceReset:(CDVInvokedUrlCommand *)command;

@end

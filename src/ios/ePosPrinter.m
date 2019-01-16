/********* ePosPrinter.m Cordova Plugin Implementation *******/

#import <UIKit/UIKit.h>
#import "ePosPrinter.h"
#import "ePosConstantsConverter.h"

@interface ePosPrinter ()<Epos2DiscoveryDelegate, Epos2PtrReceiveDelegate, Epos2PtrStatusChangeDelegate>

@property(strong, nonatomic, readwrite) Epos2FilterOption *filterOption;
@property(strong, nonatomic, readwrite) NSMutableArray *printerList;
@property(strong, retain, readwrite) Epos2Printer *printer;
@property NSString *receiveEventCallbackId;
@property NSString *statusEventCallbackId;

@end

@implementation ePosPrinter

// initialize the plugin here
- (void)pluginInitialize {
    // initialize the filter option for discovery
    self.filterOption  = [[Epos2FilterOption alloc] init];
    [self.filterOption setDeviceType:EPOS2_TYPE_PRINTER];

    // initialize the printer list for discovery
    self.printerList = [[NSMutableArray alloc]init];
}

// start the discovery of the printer
- (void)handleReceiveEvent:(CDVInvokedUrlCommand *)command {
    self.receiveEventCallbackId = command.callbackId;
}

// start the discovery of the printer
- (void)handleStatusEvent:(CDVInvokedUrlCommand *)command {
    self.statusEventCallbackId = command.callbackId;
}

// start the discovery of the printer
- (void)startDiscover:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        // remove any stored printer
        [self.printerList removeAllObjects];

        // start the discovery of printers
        int result = [Epos2Discovery start:self.filterOption delegate:self];
        if (result != EPOS2_SUCCESS) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:result]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }

    }];
}

// return the discovered printer list
- (void)getDiscoveredPrinters:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        NSMutableDictionary *printers = [NSMutableDictionary dictionaryWithCapacity:1];
        [printers setObject:self.printerList forKey:@"printers"];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:printers];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
}

// delegate called by the discover process
- (void)onDiscovery:(Epos2DeviceInfo *)deviceInfo  {
    NSMutableDictionary *printerInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    [printerInfo setObject:deviceInfo.target forKey:@"target"];
    [printerInfo setObject:deviceInfo.deviceName forKey:@"name"];
    [self.printerList addObject:printerInfo];
}

- (void) onPtrReceive:(Epos2Printer *)printerObj code:(int)code status:(Epos2PrinterStatusInfo *)status printJobId:(NSString *)printJobId {
    if (self.receiveEventCallbackId != nil) {
      NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:15];
      [data setObject:[ePosConstantsConverter toErrorText:code] forKey:@"code"];
      [data setObject:(code == EPOS2_SUCCESS) ? @YES : @NO forKey:@"success"];
      [data setObject:(printJobId == nil ? @"" : printJobId) forKey:@"jobId"];
      [data setObject:(status.connection == EPOS2_TRUE) ? @YES : @NO forKey:@"connection"];
      [data setObject:(status.online == EPOS2_TRUE) ? @YES : @NO forKey:@"online"];
      [data setObject:(status.coverOpen == EPOS2_TRUE) ? @YES : @NO forKey:@"coverOpen"];
      [data setObject:[ePosConstantsConverter toPaperStatusText:status.paper] forKey:@"paper"];
      [data setObject:(status.paperFeed == EPOS2_TRUE) ? @YES : @NO forKey:@"paperFeed"];
      [data setObject:(status.panelSwitch == EPOS2_SWITCH_ON) ? @YES : @NO forKey:@"panelSwitch"];
      [data setObject:[ePosConstantsConverter toDrawerStatusText:status.drawer] forKey:@"drawer"];
      [data setObject:[ePosConstantsConverter toErrorStatusText:status.errorStatus] forKey:@"error"];
      [data setObject:[ePosConstantsConverter toAutoRecoverErrorStatusText:status.autoRecoverError] forKey:@"autoRecoverError"];
      [data setObject:(status.buzzer == EPOS2_TRUE) ? @YES : @NO forKey:@"buzzer"];
      [data setObject:(status.adapter == EPOS2_TRUE) ? @YES : @NO forKey:@"adapter"];
      [data setObject:[ePosConstantsConverter toBatteryStatusText:status.batteryLevel] forKey:@"battery"];

      CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:data];
      [result setKeepCallbackAsBool:YES];
      [self.commandDelegate sendPluginResult:result callbackId:self.receiveEventCallbackId];
    }

    if (self.printer != nil) {
      [self.printer endTransaction];
      [self.printer disconnect];
      [self.printer clearCommandBuffer];
      [self.printer stopMonitor];
    }
}

- (void) onPtrStatusChange:(Epos2Printer *)printerObj eventType:(int)eventType {
    if (self.statusEventCallbackId != nil) {
      NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:2];
      [data setObject:[NSNumber numberWithInt:eventType] forKey:@"eventType"];
      [data setObject:[ePosConstantsConverter toEventTypeText:eventType] forKey:@"message"];

      CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:data];
      [result setKeepCallbackAsBool:YES];
      [self.commandDelegate sendPluginResult:result callbackId:self.statusEventCallbackId];
    }
}

// start the discovery of the printer
- (void)stopDiscover:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        // stop the discovery of printers
        int result = [Epos2Discovery stop];
        if (result != EPOS2_ERR_PROCESSING) {
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }
        else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }

    }];
}

// initialize the printer with the specified series and language model
- (void)initializePrinter:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        // get the parameters
        NSString *series = [command.arguments objectAtIndex:0];
        NSString *lang = [command.arguments objectAtIndex:1];

        // try to initialize the printer object
        self.printer = [[Epos2Printer alloc] initWithPrinterSeries:[ePosConstantsConverter toPrinterSeries:series] lang:[ePosConstantsConverter toLanguageModel:lang]];
        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:EPOS2_ERR_PARAM]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            [self.printer setReceiveEventDelegate:self];
            [self.printer setStatusChangeEventDelegate:self];
            [self.printer startMonitor];
            [self.printer setInterval:3000];
        }

    }];
}

// connect to the printer specified by the target
- (void)connect:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        // try to connect to the printer
        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *target = [command.arguments objectAtIndex:0];
            NSString *timeoutStr = [command.arguments objectAtIndex:1];
            long timeout = (timeoutStr == nil ? EPOS2_PARAM_DEFAULT : (long)(timeoutStr.intValue));

            if (timeout < 1000 || timeout > 300000) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer connect:target timeout:timeout];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// disconnect from the printer specified by the target
- (void)disconnect:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        // try to disconnect from the printer
        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            int result = [self.printer disconnect];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// get the printer current status
- (void)getStatus:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            Epos2PrinterStatusInfo *result = [self.printer getStatus];
            if (result != nil) {
                // dictionary to store the status
                NSMutableDictionary *status = [NSMutableDictionary dictionaryWithCapacity:12];
                [status setObject:(result.connection == EPOS2_TRUE ? @YES : @NO) forKey:@"connection"];
                [status setObject:(result.online == EPOS2_TRUE ? @YES : @NO) forKey:@"online"];
                [status setObject:(result.coverOpen == EPOS2_TRUE ? @YES : @NO) forKey:@"coverOpen"];
                [status setObject:[ePosConstantsConverter toPaperStatusText:result.paper] forKey:@"paper"];
                [status setObject:(result.paperFeed == EPOS2_TRUE ? @YES : @NO) forKey:@"paperFeed"];
                [status setObject:(result.panelSwitch == EPOS2_SWITCH_ON ? @YES : @NO) forKey:@"panelSwitch"];
                [status setObject:[ePosConstantsConverter toDrawerStatusText:result.drawer] forKey:@"drawer"];
                [status setObject:[ePosConstantsConverter toErrorStatusText:result.errorStatus] forKey:@"error"];
                [status setObject:[ePosConstantsConverter toAutoRecoverErrorStatusText:result.autoRecoverError] forKey:@"autoRecoverError"];
                [status setObject:(result.buzzer == EPOS2_TRUE ? @YES : @NO) forKey:@"buzzer"];
                [status setObject:(result.adapter == EPOS2_TRUE ? @YES : @NO) forKey:@"adapter"];
                [status setObject:[ePosConstantsConverter toBatteryStatusText:result.batteryLevel] forKey:@"battery"];

                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:status];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:EPOS2_ERR_FAILURE]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// send the printer command
- (void)sendData:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *timeoutStr = [command.arguments objectAtIndex:0];
            long timeout = (timeoutStr == nil ? EPOS2_PARAM_DEFAULT : (long)(timeoutStr.intValue));

            if (timeout < 5000 || timeout > 600000) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer sendData:timeout];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// start a transaction (a single printing task)
- (void)beginTransaction:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            int result = [self.printer beginTransaction];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// end a transaction (a single printing task)
- (void)endTransaction:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            int result = [self.printer endTransaction];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// request the printing job status by job ID
- (void)requestPrintJobStatus:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *jobId = [command.arguments objectAtIndex:0];

            int result = [self.printer requestPrintJobStatus:jobId];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// clears the command buffer
- (void)clearCommandBuffer:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            int result = [self.printer clearCommandBuffer];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }

        }

    }];
}

// add text alignment
- (void)addTextAlign:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *align = [command.arguments objectAtIndex:0];

            int result = [self.printer addTextAlign:[ePosConstantsConverter toTextAlign:align]];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }

        }

    }];
}

// add line space
- (void)addLineSpace:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *spaceStr = [command.arguments objectAtIndex:0];
            long space = (spaceStr == nil ? EPOS2_PARAM_DEFAULT : (long)(spaceStr.intValue));

            if (space < 0 || space > 255) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addLineSpace:space];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }

        }

    }];
}

// set the text rotation
- (void)addTextRotate:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *rotation = [command.arguments objectAtIndex:0];

            int result = [self.printer addTextRotate:[ePosConstantsConverter toBoolean:rotation]];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }

        }

    }];
}

// adds a character print command to the command buffer
- (void)addText:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *data = [command.arguments objectAtIndex:0];

            int result = [self.printer addText:data];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }

        }

    }];
}

// adds language setting to the command buffer
- (void)addTextLang:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *lang = [command.arguments objectAtIndex:0];

            int result = [self.printer addTextLang:[ePosConstantsConverter toLanguageCode:lang]];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }

        }

    }];
}

// adds character font setting to the command buffer
- (void)addTextFont:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *font = [command.arguments objectAtIndex:0];

            int result = [self.printer addTextFont:[ePosConstantsConverter toTextFont:font]];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }

        }

    }];
}

// adds smoothing setting to the command buffer
- (void)addTextSmooth:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *smooth = [command.arguments objectAtIndex:0];

            int result = [self.printer addTextSmooth:[ePosConstantsConverter toBoolean:smooth]];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }

        }

    }];
}

// adds character scaling factor setting to the command buffer
- (void)addTextSize:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *widthStr = [command.arguments objectAtIndex:0];
            long width = (widthStr == nil ? 0 : (long)(widthStr.intValue));
            NSString *heightStr = [command.arguments objectAtIndex:1];
            long height = (heightStr == nil ? 0 : (long)(heightStr.intValue));

            if ((width < 1 || width > 8) || (height < 1 || height > 8)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addTextSize:width height:height];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }

        }

    }];
}

// adds character style setting to the command buffer
- (void)addTextStyle:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *reverse = [command.arguments objectAtIndex:0];
            NSString *underscore = [command.arguments objectAtIndex:1];
            NSString *bold = [command.arguments objectAtIndex:2];
            NSString *color = [command.arguments objectAtIndex:3];

            int result = [self.printer addTextStyle:[ePosConstantsConverter toBoolean:reverse] ul:[ePosConstantsConverter toBoolean:underscore] em:[ePosConstantsConverter toBoolean:bold] color:[ePosConstantsConverter toTextColor:color]];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }

        }

    }];
}

// adds horizontal character print start position to the command buffer
- (void)addHPosition:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *positionStr = [command.arguments objectAtIndex:0];
            long position = (positionStr == nil ? EPOS2_PARAM_DEFAULT : (long)(positionStr.intValue));

            if (position < 0 || position > 65535) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addHPosition:position];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }

        }

    }];
}

// adds a paper-feed-by-dot command to the command buffer
- (void)addFeedUnit:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *feedStr = [command.arguments objectAtIndex:0];
            long feed = (feedStr == nil ? EPOS2_PARAM_DEFAULT : (long)(feedStr.intValue));

            if (feed < 0 || feed > 255) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addFeedUnit:feed];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }

        }

    }];
}

// adds a paper-feed-by-line command to the command buffer
- (void)addFeedLine:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *feedStr = [command.arguments objectAtIndex:0];
            long feed = (feedStr == nil ? EPOS2_PARAM_DEFAULT : (long)(feedStr.intValue));

            if (feed < 0 || feed > 255) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addFeedLine:feed];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }

        }

    }];
}

// adds a raster image print command to the command buffer.
- (void)addImage:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *imageName = [command.arguments objectAtIndex:0];
            UIImage *imageData = [UIImage imageNamed:imageName];
            NSString *xStr = [command.arguments objectAtIndex:1];
            long xPos = (xStr == nil ? 0 : (long)(xStr.intValue));
            NSString *yStr = [command.arguments objectAtIndex:2];
            long yPos = (yStr == nil ? 0 : (long)(yStr.intValue));
            NSString *widthStr = [command.arguments objectAtIndex:3];
            long width = (widthStr == nil ? 0 : (long)(widthStr.intValue));
            NSString *heightStr = [command.arguments objectAtIndex:4];
            long height = (heightStr == nil ? 0 : (long)(heightStr.intValue));
            NSString *color = [command.arguments objectAtIndex:5];
            NSString *mode = [command.arguments objectAtIndex:6];
            NSString *halftone = [command.arguments objectAtIndex:7];
            NSString *brightnessStr = [command.arguments objectAtIndex:8];
            double brightness = (brightnessStr == nil ? EPOS2_PARAM_DEFAULT : brightnessStr.doubleValue);
            NSString *compress = [command.arguments objectAtIndex:9];

            if ((xPos < 0 || xPos > 65534) || (yPos < 0 || yPos > 65534) || (width < 1 || width > 65535) || (height < 1 || height > 65535) || (brightness < 0.1 || brightness > 10.0)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addImage:imageData x:xPos y:yPos width:width height:height color:[ePosConstantsConverter toTextColor:color] mode:[ePosConstantsConverter toColorMode:mode] halftone:[ePosConstantsConverter toHalftoneMode:halftone] brightness:brightness compress:[ePosConstantsConverter toCompressMode:compress]];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// adds a NV logo print command to the command buffer
- (void)addLogo:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *key1Str = [command.arguments objectAtIndex:0];
            long key1 = (key1Str == nil ? 0 : (long)(key1Str.intValue));
            NSString *key2Str = [command.arguments objectAtIndex:1];
            long key2 = (key2Str == nil ? 0 : (long)(key2Str.intValue));

            if ((key1 < 1 || key1 > 255) || (key2 < 1 || key2 > 255)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addLogo:key1 key2:key2];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }

        }

    }];
}

// adds a barcode print command to the command buffer
- (void)addBarcode:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *data = [command.arguments objectAtIndex:0];
            NSString *type = [command.arguments objectAtIndex:1];
            NSString *hri = [command.arguments objectAtIndex:2];
            NSString *font = [command.arguments objectAtIndex:3];
            NSString *widthStr = [command.arguments objectAtIndex:4];
            long width = (widthStr == nil ? 0 : (long)(widthStr.intValue));
            NSString *heightStr = [command.arguments objectAtIndex:5];
            long height = (heightStr == nil ? 0 : (long)(heightStr.intValue));

            if ((width < 2 || width > 6) || (height < 1 || height > 255)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addBarcode:data type:[ePosConstantsConverter toBarcodeType:type] hri:[ePosConstantsConverter toHriPosition:hri] font:[ePosConstantsConverter toTextFont:font] width:width height:height];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// adds a 2D symbol print command to the command buffer
- (void)addSymbol:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *data = [command.arguments objectAtIndex:0];
            NSString *type = [command.arguments objectAtIndex:1];
            NSString *level = [command.arguments objectAtIndex:2];
            NSString *widthStr = [command.arguments objectAtIndex:3];
            long width = (widthStr == nil ? 0 : (long)(widthStr.intValue));
            NSString *heightStr = [command.arguments objectAtIndex:4];
            long height = (heightStr == nil ? 0 : (long)(heightStr.intValue));
            NSString *sizeStr = [command.arguments objectAtIndex:5];
            long size = (sizeStr == nil ? 0 : (long)(sizeStr.intValue));

            if ((width < 1 || width > 255) || (height < 1 || height > 255) || (size < 0 || size > 65535)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addSymbol:data type:[ePosConstantsConverter to2DSymbolType:type] level:[ePosConstantsConverter to2DSymbolErrorCorrectionLevel:level] width:width height:height size:size];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// adds a horizontal ruled line print command to the command buffer
- (void)addHLine:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *x1Str = [command.arguments objectAtIndex:0];
            long x1 = (x1Str == nil ? 0 : (long)(x1Str.intValue));
            NSString *x2Str = [command.arguments objectAtIndex:1];
            long x2 = (x2Str == nil ? 0 : (long)(x2Str.intValue));
            NSString *lineStyle = [command.arguments objectAtIndex:2];

            if ((x1 < 0 || x1 > 65535) || (x2 < 0 || x2 > 65535)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addHLine:x1 x2:x2 style:[ePosConstantsConverter toLineStyle:lineStyle]];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// adds a command to start drawing a vertical ruled line to the command buffer
- (void)addVLineBegin:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *x1Str = [command.arguments objectAtIndex:0];
            long x1 = (x1Str == nil ? 0 : (long)(x1Str.intValue));
            NSString *lineStyle = [command.arguments objectAtIndex:1];

            if ((x1 < 0 || x1 > 65535)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int *lineId;
                int result = [self.printer addVLineBegin:x1 style:[ePosConstantsConverter toLineStyle:lineStyle] lineId:lineId];
                if (result == EPOS2_SUCCESS) {
                    NSMutableDictionary *jobId = [NSMutableDictionary dictionaryWithCapacity:1];
                    [jobId setObject:[NSNumber numberWithInt:lineId] forKey:@"lineId"];

                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jobId];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// adds a command to stop drawing a vertical ruled line to the command buffer
- (void)addVLineEnd:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *idStr = [command.arguments objectAtIndex:0];
            int lineId = (idStr == nil ? 0 : idStr.intValue);

            int result = [self.printer addVLineEnd:lineId];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:EPOS2_SUCCESS];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// adds a page mode start command to the command buffer
- (void)addPageBegin:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            int result = [self.printer addPageBegin];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }

        }

    }];
}

// adds a page mode end command to the command buffer
- (void)addPageEnd:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            int result = [self.printer addPageEnd];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }

        }

    }];
}

// adds page mode print area setting to the command buffer
- (void)addPageArea:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *xStr = [command.arguments objectAtIndex:0];
            long xPos = (xStr == nil ? 0 : (long)(xStr.intValue));
            NSString *yStr = [command.arguments objectAtIndex:1];
            long yPos = (yStr == nil ? 0 : (long)(yStr.intValue));
            NSString *widthStr = [command.arguments objectAtIndex:2];
            long width = (widthStr == nil ? 0 : (long)(widthStr.intValue));
            NSString *heightStr = [command.arguments objectAtIndex:3];
            long height = (heightStr == nil ? 0 : (long)(heightStr.intValue));

            if ((xPos < 0 || xPos > 65535) || (yPos < 0 || yPos > 65535) || (width < 1 || width > 65535) || (height < 1 || height > 65535)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addPageArea:xPos y:yPos width:width height:height];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// adds page mode print direction setting to the command buffer
- (void)addPageDirection:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *direction = [command.arguments objectAtIndex:0];

            int result = [self.printer addPageDirection:[ePosConstantsConverter toPageDirection:direction]];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:EPOS2_SUCCESS];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// adds print position setting within the print area in the page mode to the command buffer
- (void)addPagePosition:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *xStr = [command.arguments objectAtIndex:0];
            long xPos = (xStr == nil ? 0 : (long)(xStr.intValue));
            NSString *yStr = [command.arguments objectAtIndex:1];
            long yPos = (yStr == nil ? 0 : (long)(yStr.intValue));

            if ((xPos < 0 || xPos > 65535) || (yPos < 0 || yPos > 65535)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addPagePosition:xPos y:yPos];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// adds a page mode line draw command to the command buffer
- (void)addPageLine:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *x1Str = [command.arguments objectAtIndex:0];
            long x1 = (x1Str == nil ? 0 : (long)(x1Str.intValue));
            NSString *y1Str = [command.arguments objectAtIndex:1];
            long y1 = (y1Str == nil ? 0 : (long)(y1Str.intValue));
            NSString *x2Str = [command.arguments objectAtIndex:2];
            long x2 = (x2Str == nil ? 0 : (long)(x2Str.intValue));
            NSString *y2Str = [command.arguments objectAtIndex:3];
            long y2 = (y2Str == nil ? 0 : (long)(y2Str.intValue));
            NSString *lineStyle = [command.arguments objectAtIndex:4];

            if ((x1 < 0 || x1 > 65535) || (y1 < 0 || y1 > 65535) || (x2 < 0 || x2 > 65535) || (y2 < 0 || y2 > 65535)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addPageLine:x1 y1:y1 x2:x2 y2:y2 style:[ePosConstantsConverter toLineStyle:lineStyle]];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// adds a page mode rectangle draw command to the command buffer
- (void)addPageRectangle:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *x1Str = [command.arguments objectAtIndex:0];
            long x1 = (x1Str == nil ? 0 : (long)(x1Str.intValue));
            NSString *y1Str = [command.arguments objectAtIndex:1];
            long y1 = (y1Str == nil ? 0 : (long)(y1Str.intValue));
            NSString *x2Str = [command.arguments objectAtIndex:2];
            long x2 = (x2Str == nil ? 0 : (long)(x2Str.intValue));
            NSString *y2Str = [command.arguments objectAtIndex:3];
            long y2 = (y2Str == nil ? 0 : (long)(y2Str.intValue));
            NSString *lineStyle = [command.arguments objectAtIndex:4];

            if ((x1 < 0 || x1 > 65535) || (y1 < 0 || y1 > 65535) || (x2 < 0 || x2 > 65535) || (y2 < 0 || y2 > 65535)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addPageRectangle:x1 y1:y1 x2:x2 y2:y2 style:[ePosConstantsConverter toLineStyle:lineStyle]];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// adds a sheet cut command to the command buffer
- (void)addCut:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *cut = [command.arguments objectAtIndex:0];

            int result = [self.printer addCut:[ePosConstantsConverter toCutType:cut]];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:EPOS2_SUCCESS];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// adds a drawer kick command to the command buffer
- (void)addPulse:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *drawer = [command.arguments objectAtIndex:0];
            NSString *signal = [command.arguments objectAtIndex:1];

            int result = [self.printer addPulse:[ePosConstantsConverter toDrawerPin:drawer] time:[ePosConstantsConverter toDrawerSignalTime:signal]];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:EPOS2_SUCCESS];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// adds buzzer sound setting to the command buffer
- (void)addSound:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *pattern = [command.arguments objectAtIndex:0];
            NSString *repeatStr = [command.arguments objectAtIndex:1];
            long repeat = (repeatStr == nil ? EPOS2_PARAM_DEFAULT : (long)(repeatStr.intValue));
            NSString *cycleStr = [command.arguments objectAtIndex:2];
            long cycle = (cycleStr == nil ? EPOS2_PARAM_DEFAULT : (long)(cycleStr.intValue));

            if ((repeat < 0 || repeat > 255) || (cycle < 1000 || cycle > 25500)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addSound:[ePosConstantsConverter toSoundPattern:pattern] repeat:repeat cycle:cycle];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:EPOS2_SUCCESS];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// adds a label sheet/black mark sheet feed command to the command buffer
- (void)addFeedPosition:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *position = [command.arguments objectAtIndex:0];

            int result = [self.printer addFeedPosition:[ePosConstantsConverter toFeedPosition:position]];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:EPOS2_SUCCESS];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// adds layout setting of the label sheet/black mark sheet to the command buffer
- (void)addLayout:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *layout = [command.arguments objectAtIndex:0];
            NSString *widthStr = [command.arguments objectAtIndex:1];
            long width = (widthStr == nil ? 0 : (long)(widthStr.intValue));
            NSString *heightStr = [command.arguments objectAtIndex:2];
            long height = (heightStr == nil ? 0 : (long)(heightStr.intValue));
            NSString *marginTopStr = [command.arguments objectAtIndex:3];
            long marginTop = (marginTopStr == nil ? 0 : (long)(marginTopStr.intValue));
            NSString *marginBottomStr = [command.arguments objectAtIndex:4];
            long marginBottom = (marginBottomStr == nil ? 0 : (long)(marginBottomStr.intValue));
            NSString *offsetCutStr = [command.arguments objectAtIndex:5];
            long offsetCut = (offsetCutStr == nil ? 0 : (long)(offsetCutStr.intValue));
            NSString *offsetLabelStr = [command.arguments objectAtIndex:6];
            long offsetLabel = (offsetLabelStr == nil ? 0 : (long)(offsetLabelStr.intValue));

            if ((width < 290 || width > 800) || (height < 0 || height > 1550) || (marginTop < -150 || marginTop > 1500) || (marginBottom < -15 || marginBottom > 15) || (offsetCut < -290 || offsetCut > 50) || (offsetLabel < 0 || offsetLabel > 15)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value out of range"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                int result = [self.printer addLayout:[ePosConstantsConverter toLayout:layout] width:width height:height marginTop:marginTop marginBottom:marginBottom offsetCut:offsetCut offsetLabel:offsetLabel];
                if (result == EPOS2_SUCCESS) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:EPOS2_SUCCESS];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }

    }];
}

// adds a command to the command buffer
- (void)addCommand:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *commandStr = [command.arguments objectAtIndex:0];
            NSData *commandData = [commandStr dataUsingEncoding:NSUTF8StringEncoding];

            int result = [self.printer addCommand:commandData];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// forcibly sends the error recovery command
- (void)forceRecover:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *timeoutStr = [command.arguments objectAtIndex:0];
            long timeout = (timeoutStr == (id)[NSNull null] ? EPOS2_PARAM_DEFAULT : (long)(timeoutStr.intValue));

            int result = [self.printer forceRecover:timeout];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// forcibly sends the drawer kick command
- (void)forcePulse:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *drawer = [command.arguments objectAtIndex:0];
            NSString *signal = [command.arguments objectAtIndex:1];
            NSString *timeoutStr = [command.arguments objectAtIndex:2];
            long timeout = (timeoutStr == (id)[NSNull null] ? EPOS2_PARAM_DEFAULT : (long)(timeoutStr.intValue));

            int result = [self.printer forcePulse:[ePosConstantsConverter toDrawerPin:drawer] pulseTime:[ePosConstantsConverter toDrawerSignalTime:signal] timeout:timeout];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// forcibly sends the buzzer sound command
- (void)forceStopSound:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *timeoutStr = [command.arguments objectAtIndex:0];
            long timeout = (timeoutStr == (id)[NSNull null] ? EPOS2_PARAM_DEFAULT : (long)(timeoutStr.intValue));

            int result = [self.printer forceStopSound:timeout];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// forcibly sends the ESC/POS command
- (void)forceCommand:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *commandStr = [command.arguments objectAtIndex:0];
            NSData *commandData = [commandStr dataUsingEncoding:NSUTF8StringEncoding];
            NSString *timeoutStr = [command.arguments objectAtIndex:1];
            long timeout = (timeoutStr == (id)[NSNull null] ? EPOS2_PARAM_DEFAULT : (long)(timeoutStr.intValue));

            int result = [self.printer forceCommand:commandData timeout:timeout];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

// forcibly sends the printer reset command
- (void)forceReset:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{

        if (self.printer == nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Printer object is not been initialized yet"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            // get the parameters
            NSString *timeoutStr = [command.arguments objectAtIndex:0];
            long timeout = (timeoutStr == (id)[NSNull null] ? EPOS2_PARAM_DEFAULT : (long)(timeoutStr.intValue));

            int result = [self.printer forceReset:timeout];
            if (result == EPOS2_SUCCESS) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[ePosConstantsConverter toErrorText:EPOS2_SUCCESS]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ePosConstantsConverter toErrorText:result]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

@end

var exec = require('cordova/exec');

exports.handleReceiveEvent = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'handleReceiveEvent', []);
};

exports.handleStatusEvent = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'handleStatusEvent', []);
};

exports.startDiscover = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'startDiscover', []);
};

exports.getDiscoveredPrinters = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'getDiscoveredPrinters', []);
};

exports.stopDiscover = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'stopDiscover', []);
};

exports.initializePrinter = function (series, lang, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'initializePrinter', [series, lang]);
};

exports.connect = function (target, timeout, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'connect', [target, timeout]);
};

exports.disconnect = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'disconnect', []);
};

exports.getStatus = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'getStatus', []);
};

exports.sendData = function (timeout, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'sendData', [timeout]);
};

exports.beginTransaction = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'beginTransaction', []);
};

exports.endTransaction = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'endTransaction', []);
};

exports.requestPrintJobStatus = function (jobId, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'requestPrintJobStatus', [jobId]);
};

exports.clearCommandBuffer = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'clearCommandBuffer', []);
};

exports.addTextAlign = function (align, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addTextAlign', [align]);
};

exports.addLineSpace = function (space, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addLineSpace', [space]);
};

exports.addTextRotate = function (rotation, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addTextRotate', [rotation]);
};

exports.addText = function (data, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addText', [data]);
};

exports.addTextLang = function (lang, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addTextLang', [lang]);
};

exports.addTextFont = function (font, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addTextFont', [font]);
};

exports.addTextSmooth = function (smooth, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addTextSmooth', [smooth]);
};

exports.addTextSize = function (width, height, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addTextSize', [width, height]);
};

exports.addTextStyle = function (reverse, underscore, bold, color, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addTextStyle', [reverse, underscore, bold, color]);
};

exports.addHPosition = function (position, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addHPosition', [position]);
};

exports.addFeedUnit = function (feed, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addFeedUnit', [feed]);
};

exports.addFeedLine = function (feed, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addFeedLine', [feed]);
};

exports.addImage = function (data, x, y, width, height, color, mode, halftone, brightness, compress, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addImage', [data, x, y, width, height, color, mode, halftone, brightness, compress]);
};

exports.addLogo = function (key1, key2, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addLogo', [key1, key2]);
};

exports.addBarcode = function (data, type, hri, font, width, height, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addBarcode', [data, type, hri, font, width, height]);
};

exports.addSymbol = function (data, type, level, width, height, size, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addSymbol', [data, type, level, width, height, size]);
};

exports.addHLine = function (x1, x2, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addHLine', [x1, x2]);
};

exports.addVLineBegin = function (x1, lineStyle, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addVLineBegin', [x1, lineStyle]);
};

exports.addVLineEnd = function (lineId, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addVLineEnd', [lineId]);
};

exports.addPageBegin = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addPageBegin', []);
};

exports.addPageEnd = function (success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addPageEnd', []);
};

exports.addPageArea = function (x, y, width, height, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addPageArea', [x, y, width, height]);
};

exports.addPageDirection = function (direction, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addPageDirection', [direction]);
};

exports.addPagePosition = function (x, y, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addPagePosition', [x, y]);
};

exports.addPageLine = function (x1, y1, x2, y2, lineStyle, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addPageLine', [x1, y1, x2, y2, lineStyle]);
};

exports.addPageRectangle = function (x1, y1, x2, y2, lineStyle, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addPageRectangle', [x1, y1, x2, y2, lineStyle]);
};

exports.addCut = function (cut, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addCut', [cut]);
};

exports.addPulse = function (drawer, signal, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addPulse', [drawer, signal]);
};

exports.addSound = function (pattern, repeat, cycle, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addSound', [pattern, repeat, cycle]);
};

exports.addFeedPosition = function (position, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addFeedPosition', [position]);
};

exports.addLayout = function (layout, width, height, marginTop, marginBottom, offsetCut, offsetLabel, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addLayout', [layout, width, height, marginTop, marginBottom, offsetCut, offsetLabel]);
};

exports.addCommand = function (commandData, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'addCommand', [commandData]);
};

exports.forceRecover = function (timeout, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'forceRecover', [timeout]);
};

exports.forcePulse = function (drawer, signal, timeout, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'forcePulse', [drawer, signal, timeout]);
};

exports.forceStopSound = function (timeout, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'forceStopSound', [timeout]);
};

exports.forceCommand = function (commandData, timeout, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'forceCommand', [commandData, timeout]);
};

exports.forceReset = function (timeout, success, error) {
    cordova.exec(success, error, 'ePosPrinter', 'forceReset', [timeout]);
};

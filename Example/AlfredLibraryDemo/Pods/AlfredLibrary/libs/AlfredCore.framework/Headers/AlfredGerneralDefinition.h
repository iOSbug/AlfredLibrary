//
//  AlfredGerneralDefinition.h
//  AlfredLibrary
//
//  Created by Tianbao Wang on 2020/11/12.
//

#ifndef AlfredGerneralDefinition_h
#define AlfredGerneralDefinition_h
#import <AlfredCore/AlfredBinderDevice.h>
#import <AlfredCore/AlfredEnumsHeader.h>
#import <AlfredCore/BluetoothUtils.h>
#import <AlfredCore/NSDataToStringUtils.h>
#import <AlfredCore/NSStringToDataUtils.h>
#import <AlfredCore/NSStringToBlowfishUtils.h>

#define BlowFishKey @"lhcwysghbc"

typedef void(^ AlfredErrorCallback)(AlfredError error, NSString *message);

typedef void(^ AlfredBLECallback)(id T, AlfredError E);

#endif /* AlfredGerneralDefinition_h */

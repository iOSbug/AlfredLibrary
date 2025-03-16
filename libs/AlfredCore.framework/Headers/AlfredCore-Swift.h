#if 0
#elif defined(__arm64__) && __arm64__
// Generated by Apple Swift version 6.0.3 effective-5.10 (swiftlang-6.0.3.1.10 clang-1600.0.30.1)
#ifndef ALFREDCORE_SWIFT_H
#define ALFREDCORE_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#if defined(__OBJC__)
#include <Foundation/Foundation.h>
#endif
#if defined(__cplusplus)
#include <cstdint>
#include <cstddef>
#include <cstdbool>
#include <cstring>
#include <stdlib.h>
#include <new>
#include <type_traits>
#else
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <string.h>
#endif
#if defined(__cplusplus)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnon-modular-include-in-framework-module"
#if defined(__arm64e__) && __has_include(<ptrauth.h>)
# include <ptrauth.h>
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreserved-macro-identifier"
# ifndef __ptrauth_swift_value_witness_function_pointer
#  define __ptrauth_swift_value_witness_function_pointer(x)
# endif
# ifndef __ptrauth_swift_class_method_pointer
#  define __ptrauth_swift_class_method_pointer(x)
# endif
#pragma clang diagnostic pop
#endif
#pragma clang diagnostic pop
#endif

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...) 
# endif
#endif
#if !defined(SWIFT_RUNTIME_NAME)
# if __has_attribute(objc_runtime_name)
#  define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
# else
#  define SWIFT_RUNTIME_NAME(X) 
# endif
#endif
#if !defined(SWIFT_COMPILE_NAME)
# if __has_attribute(swift_name)
#  define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
# else
#  define SWIFT_COMPILE_NAME(X) 
# endif
#endif
#if !defined(SWIFT_METHOD_FAMILY)
# if __has_attribute(objc_method_family)
#  define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
# else
#  define SWIFT_METHOD_FAMILY(X) 
# endif
#endif
#if !defined(SWIFT_NOESCAPE)
# if __has_attribute(noescape)
#  define SWIFT_NOESCAPE __attribute__((noescape))
# else
#  define SWIFT_NOESCAPE 
# endif
#endif
#if !defined(SWIFT_RELEASES_ARGUMENT)
# if __has_attribute(ns_consumed)
#  define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
# else
#  define SWIFT_RELEASES_ARGUMENT 
# endif
#endif
#if !defined(SWIFT_WARN_UNUSED_RESULT)
# if __has_attribute(warn_unused_result)
#  define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
# else
#  define SWIFT_WARN_UNUSED_RESULT 
# endif
#endif
#if !defined(SWIFT_NORETURN)
# if __has_attribute(noreturn)
#  define SWIFT_NORETURN __attribute__((noreturn))
# else
#  define SWIFT_NORETURN 
# endif
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA 
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA 
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA 
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif
#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif
#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER 
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility) 
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED_OBJC)
# if __has_feature(attribute_diagnose_if_objc)
#  define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
# else
#  define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
# endif
#endif
#if defined(__OBJC__)
#if !defined(IBSegueAction)
# define IBSegueAction 
#endif
#endif
#if !defined(SWIFT_EXTERN)
# if defined(__cplusplus)
#  define SWIFT_EXTERN extern "C"
# else
#  define SWIFT_EXTERN extern
# endif
#endif
#if !defined(SWIFT_CALL)
# define SWIFT_CALL __attribute__((swiftcall))
#endif
#if !defined(SWIFT_INDIRECT_RESULT)
# define SWIFT_INDIRECT_RESULT __attribute__((swift_indirect_result))
#endif
#if !defined(SWIFT_CONTEXT)
# define SWIFT_CONTEXT __attribute__((swift_context))
#endif
#if !defined(SWIFT_ERROR_RESULT)
# define SWIFT_ERROR_RESULT __attribute__((swift_error_result))
#endif
#if defined(__cplusplus)
# define SWIFT_NOEXCEPT noexcept
#else
# define SWIFT_NOEXCEPT 
#endif
#if !defined(SWIFT_C_INLINE_THUNK)
# if __has_attribute(always_inline)
# if __has_attribute(nodebug)
#  define SWIFT_C_INLINE_THUNK inline __attribute__((always_inline)) __attribute__((nodebug))
# else
#  define SWIFT_C_INLINE_THUNK inline __attribute__((always_inline))
# endif
# else
#  define SWIFT_C_INLINE_THUNK inline
# endif
#endif
#if defined(_WIN32)
#if !defined(SWIFT_IMPORT_STDLIB_SYMBOL)
# define SWIFT_IMPORT_STDLIB_SYMBOL __declspec(dllimport)
#endif
#else
#if !defined(SWIFT_IMPORT_STDLIB_SYMBOL)
# define SWIFT_IMPORT_STDLIB_SYMBOL 
#endif
#endif
#if defined(__OBJC__)
#if __has_feature(objc_modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import Foundation;
@import ObjectiveC;
#endif

#import <AlfredCore/AlfredCore.h>

#endif
#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"
#pragma clang diagnostic ignored "-Wdollar-in-identifier-extension"
#pragma clang diagnostic ignored "-Wunsafe-buffer-usage"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="AlfredCore",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

#if defined(__OBJC__)

SWIFT_CLASS("_TtC10AlfredCore11ResultModel")
@interface ResultModel : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSString;

SWIFT_CLASS("_TtC10AlfredCore12AbilityModel")
@interface AbilityModel : ResultModel
@property (nonatomic, copy) NSString * _Nullable enable;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end

@class AlfredBridgeInfo;

SWIFT_CLASS("_TtC10AlfredCore12AlfredBridge")
@interface AlfredBridge : ResultModel
@property (nonatomic, copy) NSString * _Nullable did;
@property (nonatomic, copy) NSString * _Nullable dtype;
@property (nonatomic, strong) AlfredBridgeInfo * _Nullable info;
@property (nonatomic, copy) NSArray<NSString *> * _Nullable slaves;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore22AlfredBridgeBindStatus")
@interface AlfredBridgeBindStatus : ResultModel
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable retCode;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore27AlfredBridgeCapabilityModel")
@interface AlfredBridgeCapabilityModel : ResultModel
@property (nonatomic, copy) NSString * _Nullable diagnose;
@property (nonatomic, copy) NSString * _Nullable localStorageTypes;
@property (nonatomic, copy) NSString * _Nullable networkConfig;
@property (nonatomic, copy) NSString * _Nullable privLiveStream;
@property (nonatomic, copy) NSString * _Nullable timeZoneVersion;
@property (nonatomic, copy) NSString * _Nullable newtz;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore19AlfredBridgeHotspot")
@interface AlfredBridgeHotspot : ResultModel
@property (nonatomic, copy) NSString * _Nullable ssid;
@property (nonatomic) BOOL open;
@property (nonatomic) NSInteger signal;
@property (nonatomic, copy) NSString * _Nullable i;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class AlfredBridgeInfoBase;
@class AlfredBridgeInfoNetworkConfig;
@class AlfredTimeConfig;
@class AlfredFwVersionUpgrade;

SWIFT_CLASS("_TtC10AlfredCore16AlfredBridgeInfo")
@interface AlfredBridgeInfo : ResultModel
@property (nonatomic, strong) AlfredBridgeInfoBase * _Nullable base;
@property (nonatomic, strong) AlfredBridgeInfoNetworkConfig * _Nullable networkConfig;
@property (nonatomic, strong) AlfredTimeConfig * _Nullable timeConfig;
@property (nonatomic, strong) AlfredFwVersionUpgrade * _Nullable newFwversion;
@property (nonatomic, strong) AlfredBridgeCapabilityModel * _Nullable capability;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore20AlfredBridgeInfoBase")
@interface AlfredBridgeInfoBase : ResultModel
@property (nonatomic, copy) NSString * _Nullable aliasName;
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable deviceType;
@property (nonatomic, copy) NSString * _Nullable deviceMode;
@property (nonatomic, copy) NSString * _Nullable fwVersion;
@property (nonatomic, copy) NSString * _Nullable newFwVersion;
@property (nonatomic, copy) NSString * _Nullable onlineStatus;
@property (nonatomic, copy) NSString * _Nullable remoteAddr;
@property (nonatomic, copy) NSString * _Nullable vendorCode;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore29AlfredBridgeInfoNetworkConfig")
@interface AlfredBridgeInfoNetworkConfig : ResultModel
@property (nonatomic, copy) NSString * _Nullable channel;
@property (nonatomic, copy) NSString * _Nullable ethMac;
@property (nonatomic, copy) NSString * _Nullable localDirectProbeUrl;
@property (nonatomic, copy) NSString * _Nullable localIp;
@property (nonatomic, copy) NSString * _Nullable localIpMask;
@property (nonatomic, copy) NSString * _Nullable netLinkType;
@property (nonatomic, copy) NSString * _Nullable ssid;
@property (nonatomic, copy) NSString * _Nullable wanIp;
@property (nonatomic, copy) NSString * _Nullable wlanMac;
@property (nonatomic, copy) NSString * _Nullable wifiSignal;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class AlfredBridgeStatusModel;

SWIFT_CLASS("_TtC10AlfredCore31AlfredBridgeLockStatusListModel")
@interface AlfredBridgeLockStatusListModel : ResultModel
@property (nonatomic, copy) NSArray<AlfredBridgeStatusModel *> * _Nullable value;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore27AlfredBridgeLockStatusModel")
@interface AlfredBridgeLockStatusModel : ResultModel
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable onlineStatus;
@property (nonatomic, copy) NSString * _Nullable lockStatus;
@property (nonatomic, copy) NSString * _Nullable malfunction;
@property (nonatomic, copy) NSString * _Nullable blesignal;
@property (nonatomic, copy) NSString * _Nullable blesignalTs;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore19AlfredBridgeOperate")
@interface AlfredBridgeOperate : ResultModel
@property (nonatomic, copy) NSString * _Nullable status;
@property (nonatomic, copy) NSString * _Nullable lockStatus;
@property (nonatomic, copy) NSString * _Nullable err;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore16AlfredBridgePair")
@interface AlfredBridgePair : ResultModel
@property (nonatomic, copy) NSString * _Nullable deviceid;
@property (nonatomic, copy) NSString * _Nullable subDeviceId;
@property (nonatomic, copy) NSString * _Nullable status;
@property (nonatomic) BOOL value;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore23AlfredBridgeStatusModel")
@interface AlfredBridgeStatusModel : ResultModel
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable onlineStatus;
@property (nonatomic, copy) NSArray<AlfredBridgeLockStatusModel *> * _Nullable subDevices;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore13AlfredBridges")
@interface AlfredBridges : ResultModel
@property (nonatomic, copy) NSArray<AlfredBridge *> * _Nullable infos;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore22AlfredDeviceBindStatus")
@interface AlfredDeviceBindStatus : ResultModel
@property (nonatomic, copy) NSString * _Nullable sn;
@property (nonatomic, copy) NSString * _Nullable mac;
@property (nonatomic, copy) NSString * _Nullable bleUUID;
@property (nonatomic) NSInteger rssi;
@property (nonatomic, copy) NSString * _Nullable localName;
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable password1;
@property (nonatomic, copy) NSString * _Nullable isPreemptBind;
@property (nonatomic, copy) NSString * _Nullable deviceType;
@property (nonatomic, copy) NSString * _Nullable mode;
@property (nonatomic, copy) NSString * _Nullable status;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore16AlfredDeviceList")
@interface AlfredDeviceList : ResultModel
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class AlfredLock;

SWIFT_CLASS("_TtC10AlfredCore13AlfredDevices")
@interface AlfredDevices : ResultModel
@property (nonatomic, copy) NSArray<AlfredBridge *> * _Nullable bridges;
@property (nonatomic, copy) NSArray<AlfredLock *> * _Nullable locks;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/// 固件升级
SWIFT_CLASS("_TtC10AlfredCore22AlfredFwVersionUpgrade")
@interface AlfredFwVersionUpgrade : ResultModel
@property (nonatomic) BOOL success;
@property (nonatomic, copy) NSString * _Nullable downloadUrl;
@property (nonatomic, copy) NSString * _Nullable priority;
@property (nonatomic, copy) NSString * _Nullable releaseNoteUrl;
@property (nonatomic, copy) NSString * _Nullable version;
@property (nonatomic, copy) NSString * _Nullable deviceId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore22AlfredInfoBluuidsModel")
@interface AlfredInfoBluuidsModel : ResultModel
@property (nonatomic, copy) NSString * _Nullable bluuid;
@property (nonatomic, copy) NSString * _Nullable puuid;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class AlfredLockExtendModel;
@class AlfredLockInfo;
@class AlfredLockAbilityModel;

SWIFT_CLASS("_TtC10AlfredCore10AlfredLock")
@interface AlfredLock : ResultModel
@property (nonatomic, copy) NSString * _Null_unspecified _id;
@property (nonatomic) BOOL unavailable;
@property (nonatomic, copy) NSString * _Nullable deviceid;
@property (nonatomic, copy) NSString * _Nullable mode;
@property (nonatomic, copy) NSString * _Nullable imode;
@property (nonatomic, copy) NSString * _Nullable umode;
@property (nonatomic, copy) NSString * _Nullable mac;
@property (nonatomic, copy) NSString * _Nullable xsn;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable doorsensor;
@property (nonatomic, strong) AlfredLockExtendModel * _Nullable extend;
@property (nonatomic) BOOL connectBridge;
@property (nonatomic) AlfredLockConnectState connectState;
@property (nonatomic) AlfredLockStatus lockState;
@property (nonatomic, strong) AlfredLockInfo * _Nullable lockInfo;
@property (nonatomic, strong) AlfredLockAbilityModel * _Nullable ability;
@property (nonatomic, copy) NSString * _Nullable gatewayLockBleSignal;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore22AlfredLockAbilityModel")
@interface AlfredLockAbilityModel : ResultModel
@property (nonatomic, strong) AbilityModel * _Nullable RFID;
@property (nonatomic, strong) AbilityModel * _Nullable autolock;
@property (nonatomic, strong) AbilityModel * _Nullable bluetooth;
@property (nonatomic, strong) AbilityModel * _Nullable fingerprint;
@property (nonatomic, strong) AbilityModel * _Nullable insidelock;
@property (nonatomic, strong) AbilityModel * _Nullable language;
@property (nonatomic, strong) AbilityModel * _Nullable leavemode;
@property (nonatomic, strong) AbilityModel * _Nullable safemode;
@property (nonatomic, strong) AbilityModel * _Nullable voice;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC10AlfredCore14AlfredLockCode")
@interface AlfredLockCode : ResultModel
@property (nonatomic, copy) NSString * _Nullable index;
@property (nonatomic, copy) NSString * _Nullable value;
@property (nonatomic, copy) NSString * _Nullable codeAttr;
@property (nonatomic, copy) NSString * _Nullable scheduleid;
@property (nonatomic, copy) NSString * _Nullable start;
@property (nonatomic, copy) NSString * _Nullable end;
@property (nonatomic, copy) NSArray<NSNumber *> * _Nullable week;
/// /周日-周六，如果有配置，则为1，否则为0
@property (nonatomic, copy) NSString * _Nullable did;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable personid;
@property (nonatomic) AlfredLockCodeType _type;
@property (nonatomic) AlfredLockCodeSchedule _scheduletype;
+ (AlfredLockCode * _Nonnull)getWeekScheduleModelWithResult:(NSString * _Nonnull)result SWIFT_WARN_UNUSED_RESULT;
+ (AlfredLockCode * _Nonnull)getYMDScheduleModelWithResult:(NSString * _Nonnull)result SWIFT_WARN_UNUSED_RESULT;
+ (AlfredLockCode * _Nonnull)getKeyModelWithResult:(NSString * _Nonnull)result SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore21AlfredLockExtendModel")
@interface AlfredLockExtendModel : ResultModel
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable password1;
@property (nonatomic, copy) NSString * _Nullable password2;
@property (nonatomic, copy) NSArray<AlfredInfoBluuidsModel *> * _Nullable bluuids;
@property (nonatomic, copy) NSArray<AlfredLockCode *> * _Nullable keys;
@property (nonatomic, copy) NSString * _Nullable systemId;
@property (nonatomic, copy) NSString * _Nullable modelnum;
@property (nonatomic, copy) NSString * _Nullable fwversion;
@property (nonatomic, copy) NSString * _Nullable hardversion;
@property (nonatomic, copy) NSString * _Nullable softversion;
@property (nonatomic, copy) NSString * _Nullable bluetoothname;
@property (nonatomic, copy) NSString * _Nullable wfwversion;
@property (nonatomic, copy) NSString * _Nullable whardversion;
@property (nonatomic, copy) NSString * _Nullable wmode;
@property (nonatomic, copy) NSString * _Nullable wsn;
@property (nonatomic, copy) NSString * _Nullable mfwversion;
@property (nonatomic, copy) NSString * _Nullable mhardversion;
@property (nonatomic, copy) NSString * _Nullable mmode;
@property (nonatomic, copy) NSString * _Nullable msn;
@property (nonatomic, copy) NSString * _Nullable mtype;
@property (nonatomic, copy) NSString * _Nullable latitude;
@property (nonatomic, copy) NSString * _Nullable longitude;
@property (nonatomic, copy) NSString * _Nullable autounlockradius;
@property (nonatomic, copy) NSString * _Nullable autounlockenable;
@property (nonatomic, copy) NSString * _Nullable autounlocktimeout;
@property (nonatomic, copy) NSString * _Nullable powersave;
@property (nonatomic, copy) NSString * _Nullable insidelock;
@property (nonatomic, copy) NSString * _Nullable leavemode;
@property (nonatomic, copy) NSString * _Nullable autolock;
@property (nonatomic, copy) NSString * _Nullable language;
@property (nonatomic, copy) NSString * _Nullable voice;
@property (nonatomic, copy) NSString * _Nullable admincodes;
@property (nonatomic, copy) NSString * _Nullable safemode;
@property (nonatomic, copy) NSString * _Nullable infrared;
@property (nonatomic, copy) NSString * _Nullable vibratewarning;
@property (nonatomic, copy) NSString * _Nullable battery;
@property (nonatomic, copy) NSString * _Nullable batterytime;
@property (nonatomic, copy) NSString * _Nullable timezone;
@property (nonatomic, copy) NSString * _Nullable philipscompatible;
@property (nonatomic, copy) NSString * _Nullable platform;
@property (nonatomic, copy) NSString * _Nullable pushenable;
@property (nonatomic, copy) NSString * _Nullable hijack;
@property (nonatomic, copy) NSString * _Nullable maxpinkey;
@property (nonatomic, copy) NSString * _Nullable maxfingerprint;
@property (nonatomic, copy) NSString * _Nullable maxaccesscard;
@property (nonatomic, copy) NSString * _Nullable maxschedule;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore14AlfredLockInfo")
@interface AlfredLockInfo : ResultModel
@property (nonatomic, copy) NSString * _Nullable mainLockTongueState;
@property (nonatomic, copy) NSString * _Nullable antilockState;
@property (nonatomic, copy) NSString * _Nullable doorState;
@property (nonatomic, copy) NSString * _Nullable doorMagnetState;
@property (nonatomic, copy) NSString * _Nullable safeModeState;
@property (nonatomic, copy) NSString * _Nullable adminPwdState;
@property (nonatomic, copy) NSString * _Nullable autoState;
@property (nonatomic, copy) NSString * _Nullable armingState;
@property (nonatomic, copy) NSString * _Nullable powersave;
@property (nonatomic) AlfredLockVoice soundVolume;
@property (nonatomic, copy) NSString * _Nullable language;
@property (nonatomic, copy) NSString * _Nullable battery;
@property (nonatomic, copy) NSString * _Nullable batterytime;
@property (nonatomic) uint64_t timeSeconds;
+ (AlfredLockInfo * _Nullable)getLockInfo:(NSString * _Nonnull)info SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)getML2AutoTimeWithInfo:(NSString * _Nonnull)info SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC10AlfredCore16AlfredLockRecord")
@interface AlfredLockRecord : ResultModel
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable time;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable index;
@property (nonatomic, copy) NSString * _Nullable lockevent;
@property (nonatomic) AlfredLockRecordID recordID;
+ (AlfredLockRecord * _Nullable)getCurrentRecordWithRecord:(NSString * _Nonnull)record SWIFT_WARN_UNUSED_RESULT;
+ (AlfredLockRecord * _Nullable)getNewLockLog:(NSString * _Nonnull)logstr SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore17AlfredLockRecords")
@interface AlfredLockRecords : ResultModel
@property (nonatomic, copy) NSArray<AlfredLockRecord *> * _Nullable logs;
@property (nonatomic, copy) NSString * _Nullable lasttime;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/// 网关时区
SWIFT_CLASS("_TtC10AlfredCore16AlfredTimeConfig")
@interface AlfredTimeConfig : ResultModel
@property (nonatomic, copy) NSString * _Nullable tzName;
@property (nonatomic, copy) NSString * _Nullable tzValue;
@property (nonatomic, copy) NSString * _Nullable dst;
@property (nonatomic, copy) NSString * _Nullable tzGmt;
@property (nonatomic, copy) NSString * _Nullable tzUtc;
@property (nonatomic, copy) NSString * _Nullable tzString;
@property (nonatomic, copy) NSString * _Nullable en;
@property (nonatomic, copy) NSString * _Nullable tzDistrict;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class TzDistrictModel;

SWIFT_CLASS("_TtC10AlfredCore14AlfredTimeZone")
@interface AlfredTimeZone : ResultModel
@property (nonatomic, copy) NSString * _Nullable version;
@property (nonatomic, copy) NSArray<AlfredTimeConfig *> * _Nullable timeZones;
@property (nonatomic, copy) NSArray<TzDistrictModel *> * _Nullable tzDistricts;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore9ConDevice")
@interface ConDevice : ResultModel
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable deviceType;
@property (nonatomic, copy) NSString * _Nullable aliasName;
@property (nonatomic, copy) NSString * _Nullable conType;
@property (nonatomic, copy) NSString * _Nullable conStatus;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore8DebugLog")
@interface DebugLog : NSObject
+ (void)showDebugLogWithIsShow:(BOOL)isShow;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore10DevGeneral")
@interface DevGeneral : ResultModel
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSArray<NSString *> * _Nullable slaves;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore11DeviceToken")
@interface DeviceToken : ResultModel
@property (nonatomic, copy) NSString * _Nullable token;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@protocol OS_dispatch_source_timer;

SWIFT_CLASS("_TtC10AlfredCore13GCDTimerUtils")
@interface GCDTimerUtils : NSObject
/// GCD定时器倒计时⏳
/// \param timeInterval 循环间隔时间
///
/// \param repeatCount 重复次数
///
/// \param handler 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数
///
+ (id <OS_dispatch_source_timer> _Nullable)dispatchTimerWithTimeInterval:(double)timeInterval repeatCount:(NSInteger)repeatCount handler:(void (^ _Nonnull)(id <OS_dispatch_source_timer> _Nullable, NSInteger))handler SWIFT_WARN_UNUSED_RESULT;
/// GCD定时器循环操作
/// \param timeInterval 循环间隔时间
///
/// \param handler 循环事件
///
+ (id <OS_dispatch_source_timer> _Nullable)dispatchTimerWithTimeInterval:(double)timeInterval handler:(void (^ _Nonnull)(id <OS_dispatch_source_timer> _Nullable))handler SWIFT_WARN_UNUSED_RESULT;
/// GCD延时操作
/// \param after 延迟的时间
///
/// \param handler 事件
///
+ (void)dispatchAfterAfter:(double)after handler:(void (^ _Nonnull)(void))handler;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore16NServerUrlsModel")
@interface NServerUrlsModel : ResultModel
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore13NetErrorModel")
@interface NetErrorModel : NSObject
@property (nonatomic) NSInteger eCode;
@property (nonatomic, copy) NSString * _Nullable eMessage;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS_NAMED("OauthModel")
@interface OauthModel : ResultModel
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end



SWIFT_CLASS("_TtC10AlfredCore12SDKInitModel")
@interface SDKInitModel : ResultModel
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore21SDKTimestampDataModel")
@interface SDKTimestampDataModel : ResultModel
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore17SDKTimestampModel")
@interface SDKTimestampModel : ResultModel
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore15ServerUrlsModel")
@interface ServerUrlsModel : ResultModel
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10AlfredCore15TzDistrictModel")
@interface TzDistrictModel : ResultModel
@property (nonatomic, copy) NSString * _Nullable tzName;
@property (nonatomic, copy) NSString * _Nullable tzUtc;
@property (nonatomic, copy) NSString * _Nullable en;
@property (nonatomic, copy) NSString * _Nullable zh;
@property (nonatomic, copy) NSString * _Nullable fr;
@property (nonatomic, copy) NSString * _Nullable de;
@property (nonatomic, copy) NSString * _Nullable es;
@property (nonatomic, copy) NSString * _Nullable pt;
@property (nonatomic, copy) NSString * _Nullable ja;
@property (nonatomic, copy) NSString * _Nullable po;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#endif
#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#if defined(__cplusplus)
#endif
#pragma clang diagnostic pop
#endif

#else
#error unsupported Swift architecture
#endif

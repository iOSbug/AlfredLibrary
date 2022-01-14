#if 0
#elif defined(__arm64__) && __arm64__
// Generated by Apple Swift version 5.5.2 (swiftlang-1300.0.47.5 clang-1300.0.29.30)
#ifndef ALFREDNETMANAGER_SWIFT_H
#define ALFREDNETMANAGER_SWIFT_H
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
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

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

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
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
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
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
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import AlfredCore;
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="AlfredNetManager",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif


SWIFT_CLASS("_TtC16AlfredNetManager11AFNetClient")
@interface AFNetClient : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSString;

/// sdk 初始化
SWIFT_CLASS("_TtC16AlfredNetManager16AlfredLibManager")
@interface AlfredLibManager : NSObject
+ (void)sdkInit:(NSString * _Nonnull)appKey appSecret:(NSString * _Nonnull)appSecret success:(void (^ _Nonnull)(void))success failure:(AlfredErrorCallback _Nonnull)failure;
/// 登录
+ (void)signIn:(NSString * _Nonnull)allyName allyToken:(NSString * _Nonnull)allyToken success:(void (^ _Nonnull)(void))success failure:(AlfredErrorCallback _Nonnull)failure;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class AlfredLock;
@class AlfredBridge;
@class AlfredTimeZone;

SWIFT_CLASS("_TtC16AlfredNetManager12CacheManager")
@interface CacheManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) CacheManager * _Nonnull shared;)
+ (CacheManager * _Nonnull)shared SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, copy) NSArray<AlfredLock *> * _Nonnull lockList;
@property (nonatomic, copy) NSArray<AlfredBridge *> * _Nonnull bridgeList;
- (void)clear;
- (void)unbindDeviceWithDeviceId:(NSString * _Nonnull)deviceId;
- (AlfredLock * _Nullable)getLockDevice:(NSString * _Nullable)deviceId SWIFT_WARN_UNUSED_RESULT;
- (AlfredBridge * _Nullable)getLockBindGateway:(AlfredLock * _Nullable)device SWIFT_WARN_UNUSED_RESULT;
- (AlfredBridge * _Nullable)getMygatewayByGatewayDid:(NSString * _Nullable)did SWIFT_WARN_UNUSED_RESULT;
- (AlfredBridge * _Nullable)getMygatewayByLockId:(NSString * _Nullable)deviceId SWIFT_WARN_UNUSED_RESULT;
- (NSArray<AlfredLock *> * _Nonnull)getMyLocksByGatewayDid:(NSString * _Nullable)did SWIFT_WARN_UNUSED_RESULT;
- (void)saveGatewayTimezone:(NSString * _Nonnull)gatewayId :(AlfredTimeZone * _Nonnull)timezones;
- (AlfredTimeZone * _Nullable)getGatewayTimezone:(NSString * _Nonnull)gatewayId SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC16AlfredNetManager10ErrorModel")
@interface ErrorModel : NSObject
@property (nonatomic, copy) NSString * _Nullable eMessage;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end

@class AlfredDevices;
@class NetErrorModel;
@class AlfredLockRecords;

SWIFT_CLASS("_TtC16AlfredNetManager15NetSwiftManager")
@interface NetSwiftManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) NetSwiftManager * _Nonnull shared;)
+ (NetSwiftManager * _Nonnull)shared SWIFT_WARN_UNUSED_RESULT;
- (void)queryDevices:(void (^ _Nonnull)(AlfredDevices * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)fetchDevice:(NSString * _Nonnull)deviceID deviceType:(AlfredDeviceType)deviceType success:(void (^ _Nonnull)(AlfredLock * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)fetchLockRecords:(NSString * _Nonnull)deviceID limit:(NSString * _Nonnull)limit page:(NSString * _Nonnull)page success:(void (^ _Nonnull)(AlfredLockRecords * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)updateLockRecords:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)renameDevice:(NSString * _Nonnull)deviceID deviceDid:(NSString * _Nonnull)deviceDid deviceType:(AlfredDeviceType)deviceType alias:(NSString * _Nonnull)alias success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)unbindDevice:(NSString * _Nonnull)deviceID deviceType:(AlfredDeviceType)deviceType success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)timestamp:(void (^ _Nonnull)(NSString * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class AlfredDeviceBindStatus;

@interface NetSwiftManager (SWIFT_EXTENSION(AlfredNetManager))
- (void)checkDeviceBindStatus:(NSString * _Nonnull)deviceID deviceType:(AlfredDeviceType)deviceType success:(void (^ _Nonnull)(AlfredDeviceBindStatus * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)getDevInfo:(NSString * _Nonnull)deviceID success:(void (^ _Nonnull)(AlfredLock * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)lockBind:(NSString * _Nonnull)deviceID type:(NSString * _Nonnull)type success:(void (^ _Nonnull)(AlfredLock * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)lockBindUac:(NSString * _Nonnull)deviceID mac:(NSString * _Nonnull)mac deviceType:(NSString * _Nonnull)deviceType success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)lockPostinfo:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)updateBluetoothUuid:(NSString * _Nonnull)did bluuid:(NSString * _Nonnull)bluuid success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)lockPostkeys:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)lockkeyschedule:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
@end

@class AlfredBridges;
@class DeviceToken;
@class AlfredBridgeBindStatus;
@class AlfredBridgeLockStatusListModel;
@class AlfredBridgeOperate;
@class AlfredBridgePair;

@interface NetSwiftManager (SWIFT_EXTENSION(AlfredNetManager))
- (void)fetchBridgeDevices:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridges * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)getDevicePairToken:(void (^ _Nonnull)(DeviceToken * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (NSString * _Nonnull)getAlfredBridgePairUrl SWIFT_WARN_UNUSED_RESULT;
- (void)gatewayCheckBind:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgeBindStatus * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayStatus:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgeLockStatusListModel * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayTransparent:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgeOperate * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayTransparentResult:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgeOperate * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayQueryBindReq:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgePair * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayQueryBindRes:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgePair * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayBindUacLock:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayBindLock:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgePair * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayUnbindUacLock:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayUnbindLock:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayTimezones:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredTimeZone * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)setgGatewayTimezone:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
@end


#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif

#elif defined(__ARM_ARCH_7A__) && __ARM_ARCH_7A__
// Generated by Apple Swift version 5.5.2 (swiftlang-1300.0.47.5 clang-1300.0.29.30)
#ifndef ALFREDNETMANAGER_SWIFT_H
#define ALFREDNETMANAGER_SWIFT_H
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
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

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

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
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
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
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
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import AlfredCore;
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="AlfredNetManager",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif


SWIFT_CLASS("_TtC16AlfredNetManager11AFNetClient")
@interface AFNetClient : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSString;

/// sdk 初始化
SWIFT_CLASS("_TtC16AlfredNetManager16AlfredLibManager")
@interface AlfredLibManager : NSObject
+ (void)sdkInit:(NSString * _Nonnull)appKey appSecret:(NSString * _Nonnull)appSecret success:(void (^ _Nonnull)(void))success failure:(AlfredErrorCallback _Nonnull)failure;
/// 登录
+ (void)signIn:(NSString * _Nonnull)allyName allyToken:(NSString * _Nonnull)allyToken success:(void (^ _Nonnull)(void))success failure:(AlfredErrorCallback _Nonnull)failure;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class AlfredLock;
@class AlfredBridge;
@class AlfredTimeZone;

SWIFT_CLASS("_TtC16AlfredNetManager12CacheManager")
@interface CacheManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) CacheManager * _Nonnull shared;)
+ (CacheManager * _Nonnull)shared SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, copy) NSArray<AlfredLock *> * _Nonnull lockList;
@property (nonatomic, copy) NSArray<AlfredBridge *> * _Nonnull bridgeList;
- (void)clear;
- (void)unbindDeviceWithDeviceId:(NSString * _Nonnull)deviceId;
- (AlfredLock * _Nullable)getLockDevice:(NSString * _Nullable)deviceId SWIFT_WARN_UNUSED_RESULT;
- (AlfredBridge * _Nullable)getLockBindGateway:(AlfredLock * _Nullable)device SWIFT_WARN_UNUSED_RESULT;
- (AlfredBridge * _Nullable)getMygatewayByGatewayDid:(NSString * _Nullable)did SWIFT_WARN_UNUSED_RESULT;
- (AlfredBridge * _Nullable)getMygatewayByLockId:(NSString * _Nullable)deviceId SWIFT_WARN_UNUSED_RESULT;
- (NSArray<AlfredLock *> * _Nonnull)getMyLocksByGatewayDid:(NSString * _Nullable)did SWIFT_WARN_UNUSED_RESULT;
- (void)saveGatewayTimezone:(NSString * _Nonnull)gatewayId :(AlfredTimeZone * _Nonnull)timezones;
- (AlfredTimeZone * _Nullable)getGatewayTimezone:(NSString * _Nonnull)gatewayId SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC16AlfredNetManager10ErrorModel")
@interface ErrorModel : NSObject
@property (nonatomic, copy) NSString * _Nullable eMessage;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end

@class AlfredDevices;
@class NetErrorModel;
@class AlfredLockRecords;

SWIFT_CLASS("_TtC16AlfredNetManager15NetSwiftManager")
@interface NetSwiftManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) NetSwiftManager * _Nonnull shared;)
+ (NetSwiftManager * _Nonnull)shared SWIFT_WARN_UNUSED_RESULT;
- (void)queryDevices:(void (^ _Nonnull)(AlfredDevices * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)fetchDevice:(NSString * _Nonnull)deviceID deviceType:(AlfredDeviceType)deviceType success:(void (^ _Nonnull)(AlfredLock * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)fetchLockRecords:(NSString * _Nonnull)deviceID limit:(NSString * _Nonnull)limit page:(NSString * _Nonnull)page success:(void (^ _Nonnull)(AlfredLockRecords * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)updateLockRecords:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)renameDevice:(NSString * _Nonnull)deviceID deviceDid:(NSString * _Nonnull)deviceDid deviceType:(AlfredDeviceType)deviceType alias:(NSString * _Nonnull)alias success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)unbindDevice:(NSString * _Nonnull)deviceID deviceType:(AlfredDeviceType)deviceType success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)timestamp:(void (^ _Nonnull)(NSString * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class AlfredDeviceBindStatus;

@interface NetSwiftManager (SWIFT_EXTENSION(AlfredNetManager))
- (void)checkDeviceBindStatus:(NSString * _Nonnull)deviceID deviceType:(AlfredDeviceType)deviceType success:(void (^ _Nonnull)(AlfredDeviceBindStatus * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)getDevInfo:(NSString * _Nonnull)deviceID success:(void (^ _Nonnull)(AlfredLock * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)lockBind:(NSString * _Nonnull)deviceID type:(NSString * _Nonnull)type success:(void (^ _Nonnull)(AlfredLock * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)lockBindUac:(NSString * _Nonnull)deviceID mac:(NSString * _Nonnull)mac deviceType:(NSString * _Nonnull)deviceType success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)lockPostinfo:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)updateBluetoothUuid:(NSString * _Nonnull)did bluuid:(NSString * _Nonnull)bluuid success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)lockPostkeys:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)lockkeyschedule:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
@end

@class AlfredBridges;
@class DeviceToken;
@class AlfredBridgeBindStatus;
@class AlfredBridgeLockStatusListModel;
@class AlfredBridgeOperate;
@class AlfredBridgePair;

@interface NetSwiftManager (SWIFT_EXTENSION(AlfredNetManager))
- (void)fetchBridgeDevices:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridges * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)getDevicePairToken:(void (^ _Nonnull)(DeviceToken * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (NSString * _Nonnull)getAlfredBridgePairUrl SWIFT_WARN_UNUSED_RESULT;
- (void)gatewayCheckBind:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgeBindStatus * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayStatus:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgeLockStatusListModel * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayTransparent:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgeOperate * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayTransparentResult:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgeOperate * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayQueryBindReq:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgePair * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayQueryBindRes:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgePair * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayBindUacLock:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayBindLock:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredBridgePair * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayUnbindUacLock:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayUnbindLock:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)gatewayTimezones:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(AlfredTimeZone * _Nonnull))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
- (void)setgGatewayTimezone:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(void))success failure:(void (^ _Nonnull)(NetErrorModel * _Nonnull))failure;
@end


#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif

#endif

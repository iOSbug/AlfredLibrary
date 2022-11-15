//
//  TCPManager.h
//  Wansview
//
//  Created by HX on 2018/10/15.
//  Copyright © 2018 AJCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

static NSString *base64TcpPort = @"8601";     //使用base64加密
static NSString *blowfishTcpPort = @"28601";  //blowfish 加密

typedef void(^ SocketSuccess)(void);
typedef void(^ SocketFailed)(NSError *error);
typedef void(^ ReceviceResponse)(id model);

@interface TCPManager : NSObject

@property(strong, nonatomic) GCDAsyncSocket *asyncsocket;
@property(copy, nonatomic) SocketSuccess connectSuccess;
@property(copy, nonatomic) SocketFailed connectFailed;
@property(copy, nonatomic) SocketFailed disconnectNor;
@property(copy, nonatomic) ReceviceResponse response;
@property(nonatomic) BOOL needBase64;

+(instancetype)Share;

- (BOOL)isConnected;

-(void)connectToHost:(NSString *)host onPort:(uint16_t)port success:(SocketSuccess)success failed:(SocketFailed)failed;

- (void)sendData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag response:(ReceviceResponse)response;
- (void)sendNoBase64Data:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag response:(ReceviceResponse)response;

-(BOOL)destroy;

@end

//
//  DHMacJsonFormatStringTool.h
//  MacOSJsonFormatConversionTool
//
//  Created by Hui Dahe on 2018/6/2.
//  Copyright © 2018年 闹皮科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHMacJsonFormatStringTool : NSObject

#pragma mark - 写入本地txt并返回地址
+(NSString*)writeFile:(NSString *)file withFileName:(NSString*)fileName andBool:(BOOL)isDelete;
#pragma mark - NSArray 转 NSString
+(NSString*)stringWithJsonArray:(NSArray*)jsonArray;
#pragma mark - NSDictionary 转 NSString
+(NSString*)stringWithJsonDic:(NSDictionary*)jsonDic;


@end

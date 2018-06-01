//
//  ViewController.m
//  MacOSJsonFormatConversionTool
//
//  Created by Hui Dahe on 2018/6/1.
//  Copyright © 2018年 闹皮科技. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}


- (IBAction)buttonAction:(id)sender {
    NSLog(@"-_firstText.stringValue--%@",_firstText.stringValue);
    NSString* filePath = [self writeFile:_firstText.stringValue withFileName:@"MyLog.txt" andBool:1];
    NSLog(@"-filePath--%@",filePath);
    //OC-JSonDic
    NSDictionary* jsonDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSLog(@"-jsonDic--%@",jsonDic);
    _sectionText.stringValue = [self stringWithJsonDic:jsonDic];
}

#pragma mark - NSDictionary 转 NSString
-(NSString*)stringWithJsonDic:(NSDictionary*)jsonDic{
    NSString* jsonString = @"{";
    //OC-字典中所有键
    NSArray* keyArray = jsonDic.allKeys;
    for (NSString* key in keyArray) {
        NSString* valueString;
        id value = [jsonDic valueForKey:key];
        if ([value isKindOfClass:[NSString class]]) {//字符串
            NSLog(@"-value-NSString-%@",value);
            BOOL result = [key caseInsensitiveCompare:@"UserID"] == NSOrderedSame || [key caseInsensitiveCompare:@"OrganizationId"] == NSOrderedSame || [key caseInsensitiveCompare:@"Role"] == NSOrderedSame;
            if (result) {//NSNumber类型--userID/OrganizationId/Role
                valueString = [NSString stringWithFormat:@"\"%@\":%@,",key,value];
            }else{//字符串类型
                valueString = [NSString stringWithFormat:@"\"%@\":\"%@\",",key,value];
            }
            jsonString = [jsonString stringByAppendingString:valueString];
            
        }else if ([value isKindOfClass:[NSArray class]]) {//数组
            NSLog(@"-value-NSArray-%@",value);
            valueString = [NSString stringWithFormat:@"\"%@\":%@,",key,[self stringWithJsonArray:value]];
            jsonString = [jsonString stringByAppendingString:valueString];

        }else if ([value isKindOfClass:[NSDictionary class]]) {//字典
            NSLog(@"-value-NSDictionary-%@",value);
            valueString = [NSString stringWithFormat:@"\"%@\":%@,",key,[self stringWithJsonDic:value]];
            jsonString = [jsonString stringByAppendingString:@","];
            
        }else{
//            jsonString = [jsonString stringByAppendingString:valueString];
        }

    }
    //// 去掉最后一个","
    jsonString = [jsonString substringToIndex:([jsonString length]-1)];
    jsonString = [jsonString stringByAppendingString:@"}"];
    return jsonString;
}
#pragma mark - NSArray 转 NSString
-(NSString*)stringWithJsonArray:(NSArray*)jsonArray{
    
    if (jsonArray != nil && ![jsonArray isKindOfClass:[NSNull class]] && jsonArray.count != 0){
        NSString* jsonString = @"[";
        for (id objArray in jsonArray) {
            NSString* valueString;
            if ([objArray isKindOfClass:[NSDictionary class]]) {
                valueString = [NSString stringWithFormat:@"%@,",[self stringWithJsonDic:objArray]];
                jsonString = [jsonString stringByAppendingString:valueString];
                
            }else if ([objArray isKindOfClass:[NSNumber class]]){//数字类型
                valueString = [jsonArray componentsJoinedByString:@","];//,为分隔符
                jsonString = [jsonString stringByAppendingString:valueString];
                NSLog(@"jsonString = %@",jsonString);
                return jsonString;
            }else if ([objArray isKindOfClass:[NSString class]]){//字符串类型
                valueString = [NSString stringWithFormat:@"\"%@\",",objArray];
                jsonString = [jsonString stringByAppendingString:valueString];
            }else{
                jsonString = [jsonString stringByAppendingString:@"]"];
                return jsonString;
                
            }
        }
        //// 去掉最后一个","
        jsonString = [jsonString substringToIndex:([jsonString length]-1)];
        jsonString = [jsonString stringByAppendingString:@"]"];
        return jsonString;
        
    }else{
        NSString* jsonString = @"[]";
        return jsonString;
    }
}

#pragma mark - 写入本地txt并返回地址
-(NSString*)writeFile:(NSString *)file withFileName:(NSString*)fileName andBool:(BOOL)isDelete{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    //获取文件路径
    // [fileManager removeItemAtPath:@"MyLog" error:nil];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    //创建数据缓冲
    NSData *reader = [NSData dataWithContentsOfFile:path];
    NSString* str = [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];
    NSString* string = [NSString stringWithFormat:@"%@\r\n",str ];
    NSMutableData *writer = [[NSMutableData alloc] init];
    
    if (!isDelete) {
        //将字符串添加到缓冲中
        [writer appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //将其他数据添加到缓冲中
    [writer appendData:[file dataUsingEncoding:NSUTF8StringEncoding]];
    //将缓冲的数据写入到文件中
    [writer writeToFile:path atomically:YES];
    
    return path;
}


@end

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
    NSString* filePath = [DHMacJsonFormatStringTool writeFile:_firstText.stringValue withFileName:@"MyLog.txt" andBool:1];
    NSLog(@"-filePath--%@",filePath);
    //OC-JSonDic
    NSDictionary* jsonDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSLog(@"-jsonDic--%@",jsonDic);
    
    if (jsonDic) {
        _sectionText.stringValue = [DHMacJsonFormatStringTool stringWithJsonDic:jsonDic];
    }else{
        _sectionText.stringValue = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    }
}


@end

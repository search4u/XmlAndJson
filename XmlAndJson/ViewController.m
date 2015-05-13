//
//  ViewController.m
//  XmlAndJson
//
//  Created by bottle on 15-5-13.
//  Copyright (c) 2015年 bottle. All rights reserved.
//

#import "ViewController.h"
#import "Video.h"
@interface ViewController () <NSXMLParserDelegate>

@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) NSMutableString *elemString;
@property (nonatomic,strong) Video *v;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self parseXml];
}

- (void)parseXml {
    NSURL *url = [NSURL URLWithString:@"http://localhost/videos.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@--%@",[NSThread currentThread],str);
        
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
        parser.delegate = self;
        [parser parse];
    }];
}

#pragma mark - NSXMLParser代理方法
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    if (!self.dataList) {
        self.dataList = [NSMutableArray array];
    }else {
        [self.dataList removeAllObjects];
    }
    if (!self.elemString) {
        self.elemString = [NSMutableString string];
    } else {
        [self.elemString setString:@""];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"video"]) {
        self.v = [[Video alloc] init];
        self.v.ID = attributeDict[@"id"];
    }
    [self.elemString setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.elemString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"video"]) {
        [self.dataList addObject:self.v];
        
    } else if(![elementName isEqualToString:@"videos"]) {
        [self.v setValue:self.elemString forKey:elementName];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"%@",self.dataList);
}

@end

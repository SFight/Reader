//
//  VTEpubManager.m
//  VTReader
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTEpubManager.h"

#import "ZipArchive.h"
#import "VTXmlParser.h"

@interface VTEpubManager()<NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *htmls;
@property (nonatomic, strong) NSMutableArray *css;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *spin;
@property (nonatomic, strong) NSMutableArray *guide;

@end

static VTEpubManager *_manager = nil;

@implementation VTEpubManager

#pragma mark - 单利
+ (VTEpubManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[VTEpubManager alloc] init];
        }
    });
    
    return _manager;
}

#pragma mark - 根据路径解析epub文件到数据模型中
- (VTDataReader *_Nullable)praserEpub:(NSString * _Nonnull)epubPath
{
    if ([@"" isEqualToString:epubPath] || epubPath == nil) {
        VTLog(@"epub文件路径不能为空");
        @throw [NSException exceptionWithName:@"文件路径异常" reason:@"epub文件路径不能为空" userInfo:nil];
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:epubPath]) {
        VTLog(@"epub文件不存在:%@", epubPath);
        @throw [NSException exceptionWithName:@"文件异常" reason:@"epub文件不存在" userInfo:nil];
        return nil;
    }
    
    //1、解压epub文件到指定目录，返回解压后的文件路径
    NSError *error;
    epubPath = [self unZip:epubPath error:&error];
    if ([@"" isEqualToString:epubPath] || epubPath == nil) {
        VTLog(@"文件解压失败");
        @throw [NSException exceptionWithName:@"文件解压异常" reason:[error localizedDescription] userInfo:[error userInfo]];
        return nil;
    }
    //2、解析OPF路径
    NSString *opfPath = [self OPFPath:epubPath];
    if (opfPath == nil || [@"" isEqualToString:opfPath]) {
        VTLog(@"opfPath路径异常");
        @throw [NSException exceptionWithName:@"opfPath路径异常" reason:@"opfPath路径不能为空" userInfo:nil];
        return nil;
    }
    
    //3、获取ncx路径
    NSString *ncxPath = [self NCXPath:opfPath];
    //4、解析opf文件
    NSArray<VTDataReaderChapter *> *chapters = [self parseOPF:opfPath];
    
    //5、生成数据
    VTDataReader *dataReader = [[VTDataReader alloc] init];
    dataReader.chapters = chapters;
    return dataReader;
}

#pragma mark - 解压epub文件
- (NSString *)unZip:(NSString *)epubPath error:(NSError **)error
{
    NSString *fileName = [[epubPath lastPathComponent] stringByDeletingPathExtension];
    VTLog(@"文件名称:%@", fileName);
    NSString *dst = [[NSString documentsPath] stringByAppendingPathComponent:fileName];
    BOOL success = [SSZipArchive unzipFileAtPath:epubPath toDestination:dst overwrite:YES password:nil error:error];
    if (success && *error == nil) {
        return dst;
    }
    
    return nil;
}

#pragma mark - OPF文件路径
-(NSString *)OPFPath:(NSString *)epubPath
{
    // 拼接epub文件的container.xml文件路径
    NSString *containerPath = [NSString stringWithFormat:@"%@/META-INF/container.xml",epubPath];
    //container.xml文件路径 通过container.xml获取到opf文件的路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:containerPath]) {
        VTLog(@"epub文件的container.xml文件不存在:%@", containerPath);
        @throw [NSException exceptionWithName:@"epub文件异常" reason:@"container.xml文件不存在" userInfo:nil];
        return nil;
    }
    
    NSString *fullpath = [[VTXmlParser sharedInstance] valueForAttribute:@"full-path" inXMLFile:containerPath];
    NSString *opfPath = [epubPath stringByAppendingPathComponent:fullpath];
    
    VTLog(@"查找到opfPath:%@", opfPath);
    
    return opfPath;
    
}

#pragma mark - 获取NCX文件路径
- (NSString *)NCXPath:(NSString *)opfPath
{
    NSString *ncxPath = [[VTXmlParser sharedInstance] valueForAttribute:@"href" withAttribute:@"media-type" attributeValue:@"application/x-dtbncx+xml" inXMLFile:opfPath];
    ncxPath = [[opfPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:ncxPath];
    return ncxPath;
}

#pragma mark - 解析OPF文件
- (NSMutableArray *)parseOPF:(NSString *)opfPath
{
    _htmls = [[NSMutableArray alloc] init];
    _css = [[NSMutableArray alloc] init];
    _images = [[NSMutableArray alloc] init];
    _spin = [[NSMutableArray alloc] init];
    _guide = [[NSMutableArray alloc] init];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath]];
    parser.delegate = self;
    [parser parse];
    VTLog(@"%@", self.htmls);
    
    for (NSDictionary *dic in self.css) {
        NSString *path = dic[@"href"];
        path = [[opfPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:path];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            VTLog(@"文件%@不存在", path);
            continue;
        }
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil documentAttributes:nil error:nil];
    }
    
    // 解析spin，生成章节数据 章节数据路径在manifest中
    NSString *absolutePath = [opfPath stringByDeletingLastPathComponent];
    NSMutableArray<VTDataReaderChapter *> *chapters = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.spin) {
        
        VTDataReaderChapter *readerChapter = [[VTDataReaderChapter alloc] init];
        
        NSString *key = dic[@"idref"];
        for (int i = 0; i < self.htmls.count; i++) {
            NSDictionary *htmlDic = self.htmls[i];
            if ([[htmlDic objectForKey:@"id"] isEqualToString:key]) {
                NSString *path = [htmlDic objectForKey:@"href"];
                readerChapter.chapterPath = [absolutePath stringByAppendingPathComponent:path];
                [chapters addObject:readerChapter];
                break;
            }
        }
        
    }
    
    
    // 解析css文件
    return chapters;
}

#pragma mark - 解析OPF文件
//-(NSMutableArray *)parseOPF:(NSString *)opfPath
//{
//    CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
//    // manifest
//    NSArray* itemsArray = [document nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//    //opf文件的命名空间 xmlns="http://www.idpf.org/2007/opf" 需要取到某个节点设置命名空间的键为opf 用opf:节点来获取节点
//    NSString *ncxFile;
//    // manifest 除ncx的所有item的href链接
//    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
//    for (CXMLElement* element in itemsArray){
//        [itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
//        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
//            ncxFile = [[element attributeForName:@"href"] stringValue]; //获取ncx文件名称 根据ncx获取书的目录
//
//        }
//    }
//
//    NSString *absolutePath = [opfPath stringByDeletingLastPathComponent];
//    CXMLDocument *ncxDoc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", absolutePath,ncxFile]] options:0 error:nil];
//    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
//    for (CXMLElement* element in itemsArray) {
//        NSString* href = [[element attributeForName:@"href"] stringValue];
//
//        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];
//        //根据opf文件的href获取到ncx文件中的中对应的目录名称
//        NSArray* navPoints = [ncxDoc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
//        if ([navPoints count] == 0) {
//            NSString *contentpath = @"//ncx:content";
//            NSArray *contents = [ncxDoc nodesForXPath:contentpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
//            for (CXMLElement *element in contents) {
//                NSString *src = [[element attributeForName:@"src"] stringValue];
//                if ([src hasPrefix:href]) {
//                    xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", src];
//                    navPoints = [ncxDoc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
//                    break;
//                }
//            }
//        }
//
//        if([navPoints count]!=0){
//            CXMLElement* titleElement = navPoints.firstObject;
//            [titleDictionary setValue:[titleElement stringValue] forKey:href];
//        }
//    }
//    // spin
//    NSArray* itemRefsArray = [document nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//    NSMutableArray *chapters = [NSMutableArray array];
//    for (CXMLElement* element in itemRefsArray){
//        NSString* chapHref = [itemDictionary objectForKey:[[element attributeForName:@"idref"] stringValue]];
//        //        LSYChapterModel *model = [LSYChapterModel chapterWithEpub:[NSString stringWithFormat:@"%@/%@",absolutePath,chapHref] title:[titleDictionary valueForKey:chapHref] imagePath:[opfPath stringByDeletingLastPathComponent]];
//        LSYChapterModel *model = [LSYChapterModel chapterWithEpub:[NSString stringWithFormat:@"%@/%@",absolutePath,chapHref] title:[titleDictionary objectForKey:chapHref] imagePath:[[[opfPath stringByDeletingLastPathComponent]stringByAppendingPathComponent:chapHref] stringByDeletingLastPathComponent]];
//        [chapters addObject:model];
//
//    }
//    return chapters;
//}

#pragma mark - NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    VTLog(@"开始解析xml");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    VTLog(@"开始解析element");
    VTLog(@"elementName：%@, namespaceURI:%@, qualifiedName:%@, attributes:%@", elementName, namespaceURI, qName, attributeDict);
    
    if ([@"item" isEqualToString:elementName] && [@"application/xhtml+xml" isEqualToString:[attributeDict objectForKey:@"media-type"]]) {
        [self.htmls addObject:attributeDict];
    }
    
    if ([@"item" isEqualToString:elementName] && [@"text/css" isEqualToString:[attributeDict objectForKey:@"media-type"]]) {
        [self.css addObject:attributeDict];
    }
    
    if ([@"item" isEqualToString:elementName] && [@"image/jpeg" isEqualToString:[attributeDict objectForKey:@"media-type"]]) {
        [self.images addObject:attributeDict];
    }
    
    if ([@"itemref" isEqualToString:elementName]) {
        [self.spin addObject:attributeDict];
    }
    
    if ([@"reference" isEqualToString:elementName]) {
        [self.guide addObject:attributeDict];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    VTLog(@"解析element结束");
    VTLog(@"elementName：%@, namespaceURI:%@, qualifiedName:%@", elementName, namespaceURI, qName);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    VTLog(@"解析xml结束");
}



@end

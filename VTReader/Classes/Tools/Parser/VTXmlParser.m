//
//  VTXmlParser.m
//  VTReader
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTXmlParser.h"

//#import <libxml/HTMLparser.h>
//#import <libxml/tree.h>
//#import <libxml/parser.h>

#import <libxml/parser.h>
#import <libxml/tree.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>
#import <libxml/xmlmemory.h>
#import <libxml/xpointer.h>

typedef void (^ElementBlock)(NSString *elementName, NSDictionary *attributes);

@interface VTXmlParser()<NSXMLParserDelegate>

@property (nonatomic, assign) ElementBlock elementBlock;

@end

static VTXmlParser *_parser = nil;

@implementation VTXmlParser

#pragma mark - 单利
+ (VTXmlParser *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_parser) {
            _parser = [[VTXmlParser alloc] init];
        }
    });
    
    return _parser;
}

#pragma mark - 获取指定属性的值
- (NSString *)valueForAttribute:(NSString *)attribute inXMLFile:(NSString *)xmlURL
{
    xmlKeepBlanksDefault(0);//必须加上，防止程序把元素前后的空白文本符号当作一个node
    
    xmlDocPtr doc = xmlReadFile([xmlURL UTF8String], [@"UTF-8" UTF8String], XML_PARSE_SAX1);
    
    if (doc == NULL ) {
        VTLog(@"Document not parsed successfully.");
        return nil;
    }
    // get root
    xmlNodePtr root = xmlDocGetRootElement(doc);
    if (root == NULL) {
        VTLog(@"empty document");
        xmlFreeDoc(doc);
        return nil;
    }
    
    /*****************查找书店中所有书籍的名称********************/
    xmlChar *content = NULL;
    nextNode(root, BAD_CAST([attribute cStringUsingEncoding:NSUTF8StringEncoding]), &content);
    
    NSString *result = [NSString stringWithUTF8String:content];
    VTLog(@"查询的属性值为:%@", result);
    
    
    /****************释放资源*******************/
    xmlFreeDoc(doc);
    xmlCleanupParser();
    xmlMemoryDump();
    
    VTLog(@"已经执行结束了");
    return result;
}

#pragma mark - 遍历所有的节点，查询相应属性的值
void nextNode(xmlNodePtr nodePtr, xmlChar *attribute, xmlChar **content) {
    if (nodePtr == NULL || *content != NULL) {
        return;
    }
    
    if (nodePtr == NULL && *content == NULL) {
        return;
    }
    
    *content = xmlGetProp(nodePtr, attribute);
    
    if (nodePtr->children != NULL) {
        nextNode(nodePtr->children, attribute, content);
    }
    
    if (nodePtr->next != NULL) {
        nextNode(nodePtr->next, attribute, content);
    }
}

#pragma mark - 遍历所有的节点，根据对应属性的值，查询相应属性的值
void nextNode_1(xmlNodePtr nodePtr, xmlChar *attribute, xmlChar **content, xmlChar *attribute1, xmlChar *attributeValue) {
    if (nodePtr == NULL || *content != NULL) {
        return;
    }
    
    if (nodePtr == NULL && *content == NULL) {
        return;
    }
    
    
    if(xmlStrcmp(xmlGetProp(nodePtr, attribute1), attributeValue)) {
        *content = xmlGetProp(nodePtr, attribute);
    }
    
    if (nodePtr->children != NULL) {
        nextNode(nodePtr->children, attribute, content);
    }
    
    if (nodePtr->next != NULL) {
        nextNode(nodePtr->next, attribute, content);
    }
}

- (NSString *)valueForAttribute:(NSString *)attribute withAttribute:(NSString *)attribute1 attributeValue:(NSString *)attributeValue inXMLFile:(NSString *)xmlURL
{
    xmlKeepBlanksDefault(0);//必须加上，防止程序把元素前后的空白文本符号当作一个node
    
    xmlDocPtr doc = xmlReadFile([xmlURL UTF8String], [@"UTF-8" UTF8String], XML_PARSE_SAX1);
    
    if (doc == NULL ) {
        VTLog(@"Document not parsed successfully.");
        return nil;
    }
    // get root
    xmlNodePtr root = xmlDocGetRootElement(doc);
    if (root == NULL) {
        VTLog(@"empty document");
        xmlFreeDoc(doc);
        return nil;
    }
    
    /*****************查找书店中所有书籍的名称********************/
    xmlChar *content = NULL;
    nextNode_1(root, BAD_CAST([attribute cStringUsingEncoding:NSUTF8StringEncoding]), &content, BAD_CAST([attribute1 cStringUsingEncoding:NSUTF8StringEncoding]), BAD_CAST([attributeValue cStringUsingEncoding:NSUTF8StringEncoding]));
    
    NSString *result = [NSString stringWithUTF8String:content];
    VTLog(@"查询的属性值为:%@", result);
    
    
    /****************释放资源*******************/
    xmlFreeDoc(doc);
    xmlCleanupParser();
    xmlMemoryDump();
    
    VTLog(@"已经执行结束了");
    return result;
}

#pragma mark - 获取集合数组
- (NSArray *)arrayForAttribute:(NSString *)attribute inXMLFile:(NSString *)xmlURL
{
    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    
    xmlDocPtr pdoc = NULL;
    xmlNodePtr proot = NULL;
    
    /*****************打开xml文档********************/
    xmlKeepBlanksDefault(0);//必须加上，防止程序把元素前后的空白文本符号当作一个node
    pdoc = xmlReadFile ([xmlURL UTF8String], "UTF-8", XML_PARSE_RECOVER);//libxml只能解析UTF-8格式数据
    
    if (pdoc == NULL) {
        VTLog(@"error:can't open file!");
        return nil;
    }
    
    /*****************获取xml文档对象的根节对象********************/
    proot = xmlDocGetRootElement (pdoc);
    
    if (proot == NULL) {
        VTLog("error: file is empty!");
        return nil;
    }
    
    /*****************查找XML文件中所有attribute属性的值********************/
    attribute = [@"//@" stringByAppendingString:attribute];
    xmlChar *xpath = BAD_CAST([attribute cStringUsingEncoding:NSUTF8StringEncoding]); //xpath语句
    xmlXPathObjectPtr result = getNodeset(pdoc, xpath); //查询XPath表达式，得到一个查询结果
    if (result == NULL) {
        VTLog("result is NULL");
        return nil;
    }
    
    if(result) {
        xmlNodeSetPtr nodeset = result->nodesetval; //获取查询到的节点指针集合
        xmlNodePtr cur;
        
        //nodeset->nodeNr是集合元素总数
        for (int i=0; i < nodeset->nodeNr; i++) {
            cur = nodeset->nodeTab[i];
            cur = cur->xmlChildrenNode;
            
            while (cur != NULL)
            {
                //如同标准C中的char类型一样，xmlChar也有动态内存分配，字符串操作等 相关函数。例如xmlMalloc是动态分配内存的函数；xmlFree是配套的释放内存函数；xmlStrcmp是字符串比较函数等。
                //对于char* ch="book", xmlChar* xch=BAD_CAST(ch)或者xmlChar* xch=(const xmlChar *)(ch)
                //对于xmlChar* xch=BAD_CAST("book")，char* ch=(char *)(xch)
                xmlChar *content = XML_GET_CONTENT(cur);
                [muArray addObject:[NSString stringWithUTF8String:content]];
                
                cur = cur->next;
            }
        }
        
        xmlXPathFreeObject(result);//释放结果指针
    }
    
    /*****************释放资源********************/
    xmlFreeDoc (pdoc);
    xmlCleanupParser ();
    xmlMemoryDump ();
    
    if ([muArray count] > 0) {
        return [NSArray arrayWithArray:muArray];
    }
    
    return nil;
}

#pragma mark - NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    VTLog(@"开始解析xml");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    VTLog(@"开始解析element");
    VTLog(@"elementName：%@, namespaceURI:%@, qualifiedName:%@, attributes:%@", elementName, namespaceURI, qName, attributeDict);
    
    if ([[attributeDict allKeys] containsObject:@"full-path"]) {
        NSString *fullpath = [attributeDict objectForKey:@"full-path"];
        VTLog(@"OPFPath:%@", fullpath);
        if (self.elementBlock) {
            self.elementBlock(elementName, attributeDict);
        }
        [parser abortParsing];
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

#pragma mark - XPath
xmlXPathObjectPtr getNodeset(xmlDocPtr pdoc,const xmlChar *xpath)
{
    xmlXPathContextPtr context=NULL;//XPath上下文指针
    xmlXPathObjectPtr result=NULL; //XPath结果指针
    context = xmlXPathNewContext(pdoc);
    
    if(pdoc==NULL){
        printf("pdoc is NULL\n");
        return NULL;
    }
    
    if(xpath){
        if (context == NULL) {
            printf("context is NULL\n");
            return NULL;
        }
        
        result = xmlXPathEvalExpression(xpath, context);
        xmlXPathFreeContext(context); //释放上下文指针
        if (result == NULL) {
            printf("xmlXPathEvalExpression return NULL\n");
            return NULL;
        }
        
        if (xmlXPathNodeSetIsEmpty(result->nodesetval)) {
            xmlXPathFreeObject(result);
            printf("nodeset is empty\n");
            return NULL;
        }
    }
    
    return result;
}
    

@end

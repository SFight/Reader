//
//  VTDataReaderChapter.m
//  VTReader
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTDataReaderChapter.h"

#import <DTCoreText/DTCoreText.h>

#import "VTReaderConfig.h"

@interface VTDataReaderChapter()

@property (nonatomic, strong) NSArray *analysePages;

@end

@implementation VTDataReaderChapter

#pragma mark - 页数
- (NSArray *)pages
{
    if (!_analysePages) {
        CGRect rect = [[UIScreen mainScreen] bounds];
        
        NSData *htmlData = [[NSData alloc] initWithContentsOfFile:self.chapterPath];
        
        NSAttributedString *attrString = [self attributedStringFromData:htmlData withFrame:rect baseURL:[NSURL fileURLWithPath:[self.chapterPath stringByDeletingLastPathComponent]]];
        
        // 根据富文本获得layouter
        DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:attrString];
        // 根据layouter获取layoutframe
        DTCoreTextLayoutFrame *theLayoutFrame = [[DTCoreTextLayoutFrame alloc] initWithFrame:rect layouter:layouter];
        // 获得可见的NSRange
        NSRange visiblerange = [theLayoutFrame visibleStringRange];
        
        // 所有的layoutframe加入的数组
        NSMutableArray *array = [[NSMutableArray alloc] init];
        // 所有的富文本截断后放到数组里
        NSMutableArray *stringArray = [NSMutableArray array];
        
        NSUInteger location = visiblerange.location;
        NSUInteger length = visiblerange.length;
        
        do {
            DTCoreTextLayoutFrame *aFrame = [[DTCoreTextLayoutFrame alloc] initWithFrame:rect layouter:layouter range:visiblerange];
            if (aFrame) {
                [array addObject:aFrame];
                [stringArray addObject:[attrString attributedSubstringFromRange:visiblerange]];
            } else {
                VTLog(@"location:%zi,length:%zi, attrlength:%zi", location, length, attrString.length);
            }
            
            location = location + length;
            
            if (location >= attrString.length) {
                break;
            }
            
            attrString = [attrString attributedSubstringFromRange:NSMakeRange(location, attrString.length - location)];
            layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:attrString];
            
            theLayoutFrame = [[DTCoreTextLayoutFrame alloc] initWithFrame:rect layouter:layouter];
            
            visiblerange = [theLayoutFrame visibleStringRange];
            
            location = visiblerange.location;
            
            length = visiblerange.length;
            
        } while (location < attrString.length);
        
        _analysePages = stringArray;
        
    }
    
    
    return _analysePages;
}

#pragma mark - 获取富文本
- (NSAttributedString *)attributedStringFromData:(NSData *)data withFrame:(CGRect)frame baseURL:(NSURL *)baseURL
{
    // Load HTML data
    //    NSString *readmePath = [[NSBundle mainBundle] pathForResource:_fileName ofType:nil];
    //    NSString *html = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:NULL];
    //    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create attributed string from HTML
    CGSize maxImageSize = CGSizeMake(frame.size.width - 20.0, frame.size.height - 20.0);
    
    // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
        
        // the block is being called for an entire paragraph, so we check the individual elements
        
        for (DTHTMLElement *oneChildElement in element.childNodes)
        {
            // if an element is larger than twice the font size put it in it's own block
            if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize)
            {
                oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
                oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
                oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
            }
        }
    };
    
//    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
//                                    @"Times New Roman", DTDefaultFontFamily, [NSNumber numberWithInteger:25], DTDefaultFontSize, @"purple", DTDefaultLinkColor, @"red", DTDefaultLinkHighlightColor, callBackBlock, DTWillFlushBlockCallBack, nil];
//
//    [options setObject:baseURL forKey:NSBaseURLDocumentOption];
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    
    [options setObject:[NSValue valueWithCGSize:maxImageSize] forKey:DTMaxImageSize];
    [options setObject:[[VTReaderConfig sharedInstance] fontName] forKey:DTDefaultFontFamily];
    [options setObject:[NSNumber numberWithInteger:[[VTReaderConfig sharedInstance] fontSize]] forKey:DTDefaultFontSize];
    [options setObject:@"purple" forKey:DTDefaultLinkColor];
    [options setObject:@"red" forKey:DTDefaultLinkHighlightColor];
    [options setObject:callBackBlock forKey:DTWillFlushBlockCallBack];
    [options setObject:baseURL forKey:NSBaseURLDocumentOption];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    return string;
}

@end

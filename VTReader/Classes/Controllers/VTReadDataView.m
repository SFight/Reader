//
//  VTReadDataView.m
//  VTReader
//
//  Created by JinJie Song on 2018/4/12.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTReadDataView.h"

#import "VTDataReaderChapter.h"
#import <DTCoreText/DTCoreText.h>

#import "VTReaderConfig.h"

@interface VTReadDataView()<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>

@property (nonatomic, strong) DTAttributedTextContentView *contentView;

@property (nonatomic, strong) VTDataReaderChapter *chapter;
@property (nonatomic, strong) id page;

@end

@implementation VTReadDataView

- (instancetype)initWithFrame:(CGRect)frame chapter:(VTDataReaderChapter *)chapter page:(id)page
{
    self = [super initWithFrame:frame];
    if (self) {
        _chapter = chapter;
        _page = page;
        self.backgroundColor = [UIColor whiteColor];
        
        _contentView = [[DTAttributedTextContentView alloc] initWithFrame:frame];
        self.contentView.delegate = self;
//
//        NSData *htmlData = [[NSData alloc] initWithContentsOfFile:self.chapter.chapterPath];
//
//        NSAttributedString *attrString = [self attributedStringFromData:htmlData withFrame:frame baseURL:[NSURL fileURLWithPath:[self.chapter.chapterPath stringByDeletingLastPathComponent]]];
//
//        self.contentView.attributedString = attrString;
        if ([self.page isKindOfClass:[DTCoreTextLayoutFrame class]]) {
            self.contentView.attributedString = [((DTCoreTextLayoutFrame *)self.page) attributedStringFragment];
        } else if ([self.page isKindOfClass:[NSAttributedString class]]) {
            self.contentView.attributedString = self.page;
        }
        [self addSubview:self.contentView];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    // 将数据画在画布上
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    if ([self.page isKindOfClass:[DTCoreTextLayoutFrame class]]) {
//        [((DTCoreTextLayoutFrame *)self.page) drawInContext:ctx options:DTCoreTextLayoutFrameDrawingDefault];
//    }
////    CGContextRef ctx = UIGraphicsGetCurrentContext();
////    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
////    CGContextTranslateCTM(ctx, 0, rect.size.height);
////    CGContextScaleCTM(ctx, 1.0, -1.0);
////
////    // 获得当前第一页的数据
////    CTFrameDraw((__bridge CTFrameRef)self.page, ctx);
//
////    NSArray *lines = (__bridge NSArray *)CTFrameGetLines((__bridge CTFrameRef)self.page);
////    for (int i = 0; i < lines.count; i++) {
////
////    }
//
//}

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

#pragma mark - DTAttributedTextContentViewDelegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    
    // get image with normal link text
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    // use normal push action for opening URL
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    // demonstrate combination with long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];
    
    return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTVideoTextAttachment class]])
    {
        NSURL *url = (id)attachment.contentURL;
        
        // we could customize the view that shows before playback starts
        UIView *grayView = [[UIView alloc] initWithFrame:frame];
        grayView.backgroundColor = [DTColor blackColor];
        
        // find a player for this URL if we already got one
        
        return grayView;
    }
    else if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        // if the attachment has a hyperlinkURL then this is currently ignored
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        
        // url for deferred loading
        imageView.url = attachment.contentURL;
        
        // if there is a hyperlink then add a link button on top of this image
        if (attachment.hyperLinkURL)
        {
            // NOTE: this is a hack, you probably want to use your own image view and touch handling
            // also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
            imageView.userInteractionEnabled = YES;
            
            DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
            button.URL = attachment.hyperLinkURL;
            button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
            button.GUID = attachment.hyperLinkGUID;
            
            // use normal push action for opening URL
            [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
            
            // demonstrate combination with long press
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
            [button addGestureRecognizer:longPress];
            
            [imageView addSubview:button];
        }
        
        return imageView;
    }
    else if ([attachment isKindOfClass:[DTIframeTextAttachment class]])
    {
//        DTWebVideoView *videoView = [[DTWebVideoView alloc] initWithFrame:frame];
//        videoView.attachment = attachment;
//
//        return videoView;
        return nil;
    }
    else if ([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        // somecolorparameter has a HTML color
        NSString *colorName = [attachment.attributes objectForKey:@"somecolorparameter"];
        UIColor *someColor = DTColorCreateWithHTMLName(colorName);
        
        UIView *someView = [[UIView alloc] initWithFrame:frame];
        someView.backgroundColor = someColor;
        someView.layer.borderWidth = 1;
        someView.layer.borderColor = [UIColor blackColor].CGColor;
        
        someView.accessibilityLabel = colorName;
        someView.isAccessibilityElement = YES;
        
        return someView;
    }
    
    return nil;
}

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame,1,1) cornerRadius:10];
    
    CGColorRef color = [textBlock.backgroundColor CGColor];
    if (color)
    {
        CGContextSetFillColorWithColor(context, color);
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextFillPath(context);
        
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        CGContextStrokePath(context);
        return NO;
    }
    
    return YES; // draw standard background
}

#pragma mark - DTLazyImageViewDelegate
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
    
    // update all attachments that match this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [self.contentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = imageSize;
            
            didUpdate = YES;
        }
    }
    
    if (didUpdate)
    {
        // layout might have changed due to image sizes
        // do it on next run loop because a layout pass might be going on
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentView relayoutText];
        });
    }
}

@end

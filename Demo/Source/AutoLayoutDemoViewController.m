//
// AutoLayoutDemoViewController.m
// DTCoreText
//
// Created by David Whetstone on 5/8/15.
// Copyright (c) 2015 Drobnik.com. All rights reserved.
//

#import "AutoLayoutDemoViewController.h"

@interface AutoLayoutDemoViewController ()
@property (weak, nonatomic) IBOutlet DTAttributedTextView *label;

@property (nonatomic, weak) IBOutlet DTAttributedTextContentView *textView;
@end

@implementation AutoLayoutDemoViewController

- (void)viewDidLoad {

    [super viewDidLoad];
	// Create attributed string from HTML
	CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 20.0);
	
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
	
	NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
									@"Times New Roman", DTDefaultFontFamily,  @"purple", DTDefaultLinkColor, @"red", DTDefaultLinkHighlightColor, callBackBlock, DTWillFlushBlockCallBack, nil];
	
    NSString *html = @"<p>小丽想不摸到蓝色珠子，请问她应该摸第________个盒子？</p><p><img width=100 height=150 src=\"http://7xu137.com1.z0.glb.clouddn.com/ueditor_20161213_584f624e3905b.png\"/></p>";
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    self.textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];;
	self.label.attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];;
}

@end

//
//  PDFViewController.h
//  PMRG
//
//  Created by SSASOFT on 8/31/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIWebView  *pdfWebView;
    IBOutlet UIActivityIndicatorView    *indicator;
}

@property (nonatomic, strong) NSString  *heading;
@property (nonatomic, strong) NSURL     *pdf_url;

@end

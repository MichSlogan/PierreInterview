//
//  ImageDetailViewController.h
//  PierreCode
//
//  Created by Pierre Larose on 6/10/15.
//  Copyright (c) 2015 Pierre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property UIImage *detailimage;

@end

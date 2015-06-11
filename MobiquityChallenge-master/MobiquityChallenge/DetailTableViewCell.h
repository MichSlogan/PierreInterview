//
//  DetailTableViewCell.h
//  PierreCode
//
//  Created by Pierre Larose on 6/10/15.
//  Copyright (c) 2015 Pierre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *DBImage;
@property (weak, nonatomic) IBOutlet UILabel *imageInfo;

@end

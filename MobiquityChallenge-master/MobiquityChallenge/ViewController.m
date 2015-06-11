//
//  ViewController.m
//  PierreCode
//
//  Created by Pierre Larose on 6/10/15.
//  Copyright (c) 2015 Pierre. All rights reserved.
//

#import "ViewController.h"
#import <Dropbox/Dropbox.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MapKit/MapKit.h>



@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property BOOL statusGranted;
@property (strong, nonatomic) DBAccount *userAccount;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *LogInButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *photoLibraryButton;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic)UIImage *image;
@property (nonatomic)UIImageView *photoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:072.0f/255.0f green:050.0f/220.0f blue:055.0f/255.0f alpha:1.0f];
    
    self.takePhotoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.takePhotoButton.frame = CGRectMake(57.5f, self.view.frame.size.width/2 - 55, 110, 110);
    self.takePhotoButton.layer.cornerRadius = self.takePhotoButton.frame.size.width / 4.0f;
    [self.takePhotoButton setImage:[UIImage imageNamed:@"take-photo-btn"] forState:UIControlStateNormal];
    [self.view addSubview:self.takePhotoButton];
    
    self.photoLibraryButton                      = [UIButton buttonWithType:UIButtonTypeSystem];
    self.photoLibraryButton.frame                = CGRectMake(self.view.frame.size.width/2 + 27.5f, self.view.frame.size.width/2 - 55, 110, 110);
    self.photoLibraryButton.layer.cornerRadius   = self.photoLibraryButton.frame.size.width / 2.0f;
    [self.photoLibraryButton setImage:[UIImage imageNamed:@"pick-photo-btn"] forState:UIControlStateNormal];
    [self.view addSubview:self.photoLibraryButton];
    
    
    
    self.photoView                              = [[UIImageView alloc] init];
    self.photoView.backgroundColor              = [UIColor colorWithRed:255.0f/255.0f green:000.0f/255.0f blue:000.0f/255.0f alpha:0.25f];
    self.photoView.frame                        = CGRectMake(0, 0, 320, 320);
    self.photoView.layer.cornerRadius           = self.photoView.frame.size.width / 2;
    self.photoView.layer.masksToBounds          = YES;
    self.photoView.userInteractionEnabled       = YES;
    
    
    self.userAccount = [[DBAccountManager sharedManager] linkedAccount];
    if (self.userAccount) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:self.userAccount];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
}



#pragma mark - Helper Methods
- (IBAction)didPressLogin:(id)sender {
    if (![[DBAccountManager sharedManager] linkedAccount]) {
        self.LogInButton.title = @"Login";
        self.statusGranted = NO;
        [[DBAccountManager sharedManager] linkFromController:self];
    }
    else if ([[DBAccountManager sharedManager] linkedAccount]) {
        self.statusGranted = YES;
        self.LogInButton.title = @"Logout";
        NSLog(@"App linked successfully!");
    }
}

- (void)uploadImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.6);
    DBPath *path = [[DBPath root] childPath:[NSString stringWithFormat:@"image_%i.png", arc4random()]];
    DBFile *file = [[DBFilesystem sharedFilesystem] createFile:path error:nil];
    [file writeData:data error:nil];
    NSLog(@"Photo uploaded!");
}


#pragma mark - UIImagePickerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self uploadImage:self.image];

        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions
- (IBAction)onTakePhotoButtonTapped:(id)sender {
    if (self.image == nil) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}




@end

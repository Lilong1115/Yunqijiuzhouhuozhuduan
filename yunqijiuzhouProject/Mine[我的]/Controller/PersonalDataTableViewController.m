//
//  PersonalDataTableViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/19.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "PersonalDataTableViewController.h"
#import "UserInfo.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ChangePasswordController.h"

@interface PersonalDataTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
//名称
@property (weak, nonatomic) IBOutlet UILabel *username;
//手机号
@property (weak, nonatomic) IBOutlet UILabel *phone;

//获取图片
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

//头像
@property (nonatomic, strong) UIImage *icon;

@end

@implementation PersonalDataTableViewController

- (void)viewWillAppear:(BOOL)animated {

    if ([UserInfo account]) {
        
        NSString *photo = GetIcon;
        
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoBase_URL, photo]]];
        
        self.username.text = [UserInfo account].userName;
        self.phone.text = [UserInfo account].phone;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人资料";
    self.tableView.bounces = NO;
    
    
    self.saveButton.layer.cornerRadius = 5;
    self.saveButton.layer.masksToBounds = YES;
    
    self.saveButton.hidden = YES;
    
    
    self.iconView.layer.cornerRadius = 22;
    self.iconView.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            
            [self callActionSheetFunc];
            break;
        case 4:
            [self changePassword];
            break;
        default:
            break;
    }
}


- (void)changePassword {
    
    ChangePasswordController *vc = [[ChangePasswordController alloc]init];
    vc.phone = [UserInfo account].phone;
    [self.navigationController pushViewController:vc animated:YES];
}



/**
 @ 调用ActionSheet
 */
- (void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil, nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil, nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}


// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 2) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /*
    NSLog(@"%@", image);
    
    NSData *imageData = UIImageJPEGRepresentation(image,1);
    
    CGFloat length = [imageData length]/1000;
    
    NSLog(@"old  %f", length);
     */
    
    UIImage *newImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(image.size.width * 0.1, image.size.height * 0.1)];
    
    /*
    NSData *newData = UIImageJPEGRepresentation(newImage,1);
    
    CGFloat newLength = [newData length]/1000;
    
    NSLog(@"new  %f", newLength);
    */
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        self.iconView.image = newImage;
        self.icon = newImage;
        self.saveButton.hidden = NO;
        
    }];
    
}
- (IBAction)saveInfo:(UIButton *)sender {
    
 
    //NSLog(@"%@", self.icon);
    
    NSData *data = UIImageJPEGRepresentation(self.icon, 1);
    
    NSString *imageBase64Str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    //NSLog(@"%@", imageBase64Str);
    
    NSDictionary *parameters = @{
                                 @"uuid": GetUuid
                                 };
    
    NSString *json = [NSString ObjectTojsonString:parameters];
    
    //NSLog(@"%@", json);
    
    NSString *jsonBase64 = [NSString jsonBase64WithJson:json];
    
    
    NSDictionary *dict = @{
                           @"basic": jsonBase64,
                           @"imgStr": imageBase64Str
                           };
    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:POST andUrlString:SaveIcon_URL andParameters:dict andSuccessBlock:^(id result) {
        
        
        //NSLog(@"%@", result);
        
        if ([result[@"msg"] isEqualToString:@"信息修改成功"]) {
            [LLGHUD showSuccessWithStatus:@"保存成功"];
            
            NSString *data = result[@"data"];
            
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userPhoto"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];

        } else {
            [LLGHUD showErrorWithStatus:@"保存失败"];
        }
        
        
    } andFailBlock:^(NSError *error) {
        
        [LLGHUD showErrorWithStatus:@"保存失败"];
    }];
    
    
    
}

@end

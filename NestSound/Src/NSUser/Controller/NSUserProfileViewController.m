//
//  NSUserProfileViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserProfileViewController.h"
#import "NSDatePicker.h"
#import "NSChangeNameViewController.h"
#import "NSGetQiNiuModel.h"
#import "NSUserMessageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface NSUserProfileViewController ()

<
UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
{
    
    UITableView * settingTableView;
    UIActionSheet * photoActionSheet;
    UIImagePickerController * imagePicker;
    UIActionSheet * choseMale;
    NSDatePicker * datePicker;
    NSString * birthday;
    NSString * male;
    NSIndexPath * cellIndex;
    NSChangeNameViewController * changeName;
    NSString * nickName;
    NSString * signature;
    NSString * url ;
    NSString * userIconUrl;
    NSMutableDictionary * userInfo;
    int males ;
    int count;
    
    
}
@property (nonatomic,copy) NSString * titleImageUrl;
@end

static NSString * const settingCellIditify = @"settingCell";

@implementation NSUserProfileViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureAppearance];
//    males = 0;
//    count = 0;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -configureAppearance
-(void)configureAppearance
{

     self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    userInfo = [[NSMutableDictionary  alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];

    self.title = @"完善个人信息";

//    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(getBack)];
//    self.navigationItem.leftBarButtonItem = back;
    
    settingTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    settingTableView.dataSource = self;
    settingTableView.delegate = self;
    settingTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    settingTableView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    [self.view addSubview:settingTableView];
    
    
    datePicker = [[NSDatePicker alloc] init];
    datePicker.hidden = YES;
    [datePicker.choseBtn addTarget:self action:@selector(ensureBirthday) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:datePicker];
    [datePicker.cancelBtn addTarget:self action:@selector(cancelChose) forControlEvents:UIControlEventTouchUpInside];
    
    photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    photoActionSheet.tag = 103;
    
    choseMale = [[UIActionSheet alloc] initWithTitle:@"请选择您的性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    choseMale.tag =104;
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    //constraints
    [settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
}

-(void)getBack
{
    
//    count ++;
//    if (count == 1) {
//        url = [self getQiniuDetailWithType:1 andFixx:@"headport"];
//    }
    

}

-(void)ensureBirthday
{
    NSDate * bir = datePicker.choseBirthday.date;
   // NSTimeInterval timeStmp = [bir timeIntervalSince1970];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"YYYY-MM-dd"];
    NSString * dateString = [fomatter stringFromDate:bir];
    [userInfo setObject:dateString forKey:@"birthday"];
    birthday = dateString;
    datePicker.hidden = YES;
    [settingTableView reloadData];
    [self changeProfile];
}

-(void)cancelChose
{
    datePicker.hidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? 1 : 5;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    }else{
    return 45;

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = indexPath.row;
    UITableViewCell * settingCell = [tableView dequeueReusableCellWithIdentifier:settingCellIditify];
    settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!settingCell) {
        settingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellIditify];
       
        UILabel * valueLabel = [[UILabel alloc] init];
        valueLabel.font = [UIFont systemFontOfSize:12];
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.textColor = [UIColor hexColorFloat:@"666666"];
        valueLabel.tag = 100;
        [settingCell.contentView addSubview:valueLabel];
       UIImageView * userIcon = [[UIImageView alloc] init];
        userIcon.layer.cornerRadius = 21;
        userIcon.layer.masksToBounds = YES;
        userIcon.tag = 101;
        [settingCell.contentView addSubview:userIcon];
        valueLabel.hidden = NO;
        userIcon.hidden = YES;
        settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //constraints
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(settingCell.contentView.mas_centerY);
            make.right.equalTo(settingCell.contentView.mas_right
                               ).with.offset(-15);
            make.left.equalTo(settingCell.contentView.mas_left).offset(100);
        }];
        
        [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(settingCell.contentView.mas_centerY);
            make.right.equalTo(settingCell.contentView.mas_right).with.offset(-10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
        }];
        
        
    }
    
    UILabel * valueLabel = (UILabel *)[settingCell.contentView viewWithTag:100];
    UIImageView * userIcon = (UIImageView *)[settingCell.contentView viewWithTag:101];
    
        if (row == 0 && indexPath.section == 0) {
            settingCell.textLabel.text = @"用户头像";
            //        LocalizedStr(@"prompt_userIcon");
//            self.titleImageUrl = userInfo[@"userIcon"];
            [userIcon setDDImageWithURLString:userInfo[@"userIcon"] placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
            userIcon.hidden = NO;
            valueLabel.hidden = YES;
            
        }else if (row == 1){
            settingCell.textLabel.text = @"昵称";
            valueLabel.hidden = NO;
//            nickName = userInfo[@"userName"];
            
            valueLabel.text = userInfo[@"userName"];
            
        }else if (row == 2){
            settingCell.textLabel.text = @"性别";
            if ([userInfo[@"male"] intValue]== 1) {
                valueLabel.text = @"女";
            }else{
                valueLabel.text = @"男";
            }
//            valueLabel.text = male;
        }else if (row == 3){
            settingCell.textLabel.text = @"生日";
//            if (userInfo[@"birthday"]) {
//                birthday = userInfo[@"birthday"];
//            }else{
//                birthday = @"";
//            }
            valueLabel.text = userInfo[@"birthday"];
        }else if (row == 4){
            settingCell.textLabel.text = @"个性签名";
            if (userInfo[@"desc"]) {
                valueLabel.text = userInfo[@"desc"];
            }else{
                valueLabel.text = @"您还没有描述";
            }
//            valueLabel.text = signature;
        } else if (row == 0 && indexPath.section == 1) {
            settingCell.textLabel.text = @"个人保全信息";
        }
        return settingCell;
    
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger row = indexPath.row;
    if (row == 0 && indexPath.section == 0) {
        [photoActionSheet showInView:self.view];
        cellIndex = indexPath;
    }else if (row == 1){
        changeName = [[NSChangeNameViewController alloc] initWithType:@"name" ];
       
        [self.navigationController pushViewController:changeName animated:YES];
        [changeName returnName:^(NSString *name) {
            userInfo[@"userName"] = name;
            nickName = name;
            [tableView reloadData];
            [self changeProfile];
        }];
    }else if (row == 2){
    
        [choseMale showInView:self.view];
    }else if (row == 3){
        datePicker.hidden = NO;
    }else if (row == 4){
        changeName = [[NSChangeNameViewController alloc] initWithType:nil];
        [self.navigationController pushViewController:changeName animated:YES];
        [changeName returnName:^(NSString *name) {
            userInfo[@"desc"] = name;
            signature = name;
            [tableView reloadData];
            [self changeProfile];
        }];
    } else if (row == 0 && indexPath.section == 1) {
        NSUserMessageViewController *userMessageVC = [[NSUserMessageViewController alloc] init];
        [self.navigationController pushViewController:userMessageVC animated:YES];
    }
    
    
}

#pragma mark -actionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 103) {
    
        switch (buttonIndex) {
            case 0:
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
                break;
            case 1:
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
                
                break;
                
            default:
                break;
        }
        
        
    }else{
        
        switch (buttonIndex) {
            case 0:
            {
                males = 2;
                [userInfo setObject:[NSNumber numberWithInt:2] forKey:@"male"];
                [settingTableView reloadData];
                [self changeProfile];
                break;
            }
            case 1:
            {

                males = 1;
                [userInfo setObject:[NSNumber numberWithInt:1] forKey:@"male"];
                [settingTableView reloadData];
                [self changeProfile];
                break;
            }
            default:
                break;
        }
    
    }

}


#pragma mark -ImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * userIconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [NSTool saveImage:userIconImage withName:@"userIcon.png"];
    UITableViewCell * settingCell = [settingTableView cellForRowAtIndexPath:cellIndex];
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIImageView * userIcon = (UIImageView *)[settingCell viewWithTag:101];
        //    userIcon.layer.cornerRadius = 21;
        userIcon.image = userIconImage;
        url = [self getQiniuDetailWithType:1 andFixx:@"headport"];
    }];
    
}

#pragma mark -uploadPhoto
-(NSString *)uploadPhotoWith:(NSString *)photoPath type:(BOOL)type_ token:(NSString *)token url:(NSString *)url
{
    
    WS(wSelf);
    __block NSString * file = self.titleImageUrl;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    photoPath = [LocalPath stringByAppendingPathComponent:@"userIcon.png"];
    if ([fileManager fileExistsAtPath:photoPath]) {
        QNUploadManager * upManager = [[QNUploadManager alloc] init];
        NSData * imageData = [NSData dataWithContentsOfFile:photoPath];
        [upManager putData:imageData key:[[NSString stringWithFormat:@"%.f.jpg",[date getTimeStamp]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            wSelf.titleImageUrl = resp[@"key"];
            userInfo[@"userIcon"] = [NSString stringWithFormat:@"http://pic.yinchao.cn/%@",wSelf.titleImageUrl];
            [self changeProfile];
        } option:nil];
    }else{
        [self changeProfile];
    }
    
    return file;
}


-(void)setQiniuDetail:(qiNiu *)qiniuDetail
{
    _qiniuDetail = qiniuDetail;
    
//    NSString * fullPath = [LocalPath stringByAppendingPathComponent:@"userIcon.png"];
    [self uploadPhotoWith:nil type:NO token:_qiniuDetail.token url:_qiniuDetail.qiNIuDomain];

}



-(void)changeProfile
{
    self.requestType = NO;
    
    if ([male isEqualToString:@"男"]) {
        males = 2;
    }else if([male isEqualToString:@"女"]){
        males = 1;
    }
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    if (nickName) {
        [dic setObject:nickName forKey:@"nickname"];
    }
    if (males) {
        [dic setObject:[NSNumber numberWithInt:males] forKey:@"sex"];
    }
    if (signature) {
        [dic setObject:signature forKey:@"signature"];
    }
    if (birthday) {
        [dic setObject:birthday forKey:@"birthday"];
    }
    if (self.titleImageUrl != nil) {
        [dic setObject:self.titleImageUrl forKey:@"headurl"];
    }
    [dic setObject:JUserID forKey:@"uid"];
    [dic setObject:LoginToken forKey:@"token"];
    self.requestParams = dic;
//    self.requestParams = @{@"token":LoginToken,@"uid":JUserID,@"headurl":self.titleImageUrl,@"nickname":nickName,@"sex":[NSNumber numberWithInt:males],@"signature":signature,@"birthday":birthday};
    self.requestURL = changeProfileURL;

}
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:url]) {
                NSGetQiNiuModel *  qiniu = (NSGetQiNiuModel *)parserObject;
                self.qiniuDetail = qiniu.qiNIuModel;
            }else if([operation.urlTag isEqualToString:changeProfileURL]){
                //                [self.navigationController popViewControllerAnimated:YES];
                //                [[NSToastManager manager] showtoast:@"修改成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserPageNotific" object:nil];
//                                NSMutableDictionary * changeDic = [[NSMutableDictionary alloc] init];
//                                [changeDic setValue:JUserID forKey:@"userID"];
//                                [changeDic setValue:LoginToken forKey:@"userLoginToken"];
//                                [changeDic setValue:userInfo[@"userName"] forKey:@"userName"];
//                                [changeDic setValue:userInfo[@"userIcon"] forKey:@"userIcon"];
//                
//                                [changeDic setValue:[NSNumber numberWithInt:[userInfo[@"male"] intValue]] forKey:@"male"];
//                                [changeDic setValue:userInfo[@"birthday"]  forKey:@"birthday"];
//                                [changeDic setValue:userInfo[@"desc"] forKey:@"desc"];

                NSDictionary *changeDic = @{@"userID":JUserID,
                                            @"userLoginToken":LoginToken,
                                            @"userName":userInfo[@"userName"],
                                            @"userIcon":userInfo[@"userIcon"],
                                            @"male":[NSNumber numberWithInt:[userInfo[@"male"] intValue]],
                                            @"birthday":userInfo[@"birthday"],
                                            @"desc":userInfo[@"desc"]};
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
                [[NSUserDefaults standardUserDefaults] setObject:changeDic forKey:@"user"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSMutableDictionary *dic = [[NSMutableDictionary  alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
                CHLog(@"%@",dic);
            }
            
        }
    }
}
//- (void)viewDidDisappear:(BOOL)animated {
//
//    [super viewDidDisappear:animated];
//    [self getBack];
////    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(getBack)];
////    if ([self  respondsToSelector:@selector(popViewControllerAnimated:)]) {
////
////    }
//    
//    
//}

@end

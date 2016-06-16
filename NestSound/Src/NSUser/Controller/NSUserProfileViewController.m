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
#import "NSQiniuModel.h"
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
    
    
}
@end

static NSString * const settingCellIditify = @"settingCell";

@implementation NSUserProfileViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:url]) {
            NSQiniuModel *  qiniu = (NSQiniuModel *)parserObject;
            self.qiniuDetail = qiniu.qiniuDetail;
        }
    }else{
        if ([operation.urlTag isEqualToString:changeProfileURL]) {
            [[NSToastManager manager] showtoast:@"修改成功"];
        }
    }
    
}
#pragma mark -configureAppearance
-(void)configureAppearance
{

    self.title = @"完善个人信息";
//    LocalizedStr(@"prompt_completeMessage");
//    self.showBackBtn = YES;
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(getBack)];
    self.navigationItem.leftBarButtonItem = back;
    
    settingTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    settingTableView.dataSource = self;
    settingTableView.delegate = self;
    settingTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
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
    [self changeProfile];
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)ensureBirthday
{
    NSDate * bir = datePicker.choseBirthday.date;
    birthday = [date datetoStringWithDate:bir];
    datePicker.hidden = YES;
    [settingTableView reloadData];
}

-(void)cancelChose
{
    datePicker.hidden = YES;
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;

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
    return 0.1;
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
            
        }];
        
        [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(settingCell.contentView.mas_centerY);
            make.right.equalTo(settingCell.contentView.mas_right).with.offset(-15);
            make.height.mas_equalTo(42);
            make.width.mas_equalTo(42);
        }];
        
        
    }
    
    UILabel * valueLabel = (UILabel *)[settingCell.contentView viewWithTag:100];
    UIImageView * userIcon = (UIImageView *)[settingCell.contentView viewWithTag:101];
   
    if (row == 0) {
        settingCell.textLabel.text = @"用户头像";
//        LocalizedStr(@"prompt_userIcon");
        userIcon.image = [UIImage imageNamed:@"2.0_addPicture"];
        userIcon.hidden = NO;
        valueLabel.hidden = YES;
        
    }else if (row == 1){
        settingCell.textLabel.text = @"昵称";
//        LocalizedStr(@"prompt_nickName");
        valueLabel.hidden = NO;
        valueLabel.text = nickName;
        
    }else if (row == 2){
        settingCell.textLabel.text = @"性别";
//        LocalizedStr(@"prompt_sex");
        //male = @"男";
        valueLabel.text = male;
        
    }else if (row == 3){
        settingCell.textLabel.text = @"生日";
//        LocalizedStr(@"prompt_birthday");
        valueLabel.text = birthday;
    }else if (row == 4){
        settingCell.textLabel.text = @"个人描述";
//        LocalizedStr(@"prompt_desc");
        valueLabel.text = signature;
    }


    
    return settingCell;
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    NSUInteger row = indexPath.row;
    if (row == 0) {
        [photoActionSheet showInView:self.view];
        cellIndex = indexPath;
    }else if (row == 1){
        changeName = [[NSChangeNameViewController alloc] initWithType:@"name" ];
       
        [self.navigationController pushViewController:changeName animated:YES];
        [changeName returnName:^(NSString *name) {
            nickName = name;
            [tableView reloadData];
        }];
    }else if (row == 2){
    
        [choseMale showInView:self.view];
    }else if (row == 3){
        datePicker.hidden = NO;
    }else if (row == 4){
        changeName = [[NSChangeNameViewController alloc] initWithType:nil];
        [self.navigationController pushViewController:changeName animated:YES];
        [changeName returnName:^(NSString *name) {
            signature = name;
            [tableView reloadData];
        }];
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
                male = @"男";
                [settingTableView reloadData];
                
                break;
            }
            case 1:
            {
                male = @"女";
                [settingTableView reloadData];
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
    UIImage * userIconImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [NSTool saveImage:userIconImage withName:@"userIcon.png"];
    UITableViewCell * settingCell = [settingTableView cellForRowAtIndexPath:cellIndex];
   
    UIImageView * userIcon = (UIImageView *)[settingCell viewWithTag:101];
//    userIcon.layer.cornerRadius = 21;
    userIcon.image = userIconImage;
    
   url = [self getQiniuDetailWithType:2 andFixx:@"headport"];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

-(void)setQiniuDetail:(QiniuDetail *)qiniuDetail
{
    _qiniuDetail = qiniuDetail;
    
    
    NSString * fullPath = [LocalPath stringByAppendingPathComponent:@"userIcon.png"];
    userIconUrl = [NSTool uploadPhotoWith:fullPath type:NO token:_qiniuDetail.token url:_qiniuDetail.QiniuDomain];

}



-(void)changeProfile
{
    self.requestType = NO;
    self.requestParams = @{@"uid":JUserID,@"nickname":nickName,@"sex":male,@"signature":signature,@"birthday":birthday,@"token":LoginToken};
    self.requestURL = changeProfileURL;

}

@end

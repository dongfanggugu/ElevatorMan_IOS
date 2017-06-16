//
//  ChatController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2016/12/27.
//
//

#import <Foundation/Foundation.h>
#import "ChatController.h"
#import "PullTableView.h"
#import "HttpClient.h"
#import "User.h"
#import <AVFoundation/AVFoundation.h>
#include "lame.h"
#import "FileUtils.h"
#import "Utils.h"
#import "ChatRightController.h"


#define kSandboxPathStr [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define kMp3FileName @"myRecord.mp3"

#define kCafFileName @"myRecord.caf"

#define netFileName @"myRecordNet.mp4"

@interface ChatController () <UIScrollViewDelegate, UIGestureRecognizerDelegate, AVAudioPlayerDelegate,
        AVAudioRecorderDelegate, PullTableViewDelegate, ChatRightControllerDelegate, UITableViewDelegate,
        UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PullTableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnSwitch;

@property (weak, nonatomic) IBOutlet UITextField *tfContent;

@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;

@property (strong, nonatomic) NSString *cafPathStr;

@property (strong, nonatomic) NSString *mp3PathStr;

@property (strong, nonatomic) NSString *netMp3PathStr;

@property (nonatomic, strong) NSTimer *timer1;  //控制录音时长显示更新

@property NSInteger countNum;

@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (strong, nonatomic) AVAudioPlayer *player;

@property (strong, nonatomic) ChatRightController *controller;

@property (strong, nonatomic) NSMutableArray *arrayChannel;

@end

@implementation ChatController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavTitle:@"救援交流"];

    [self initData];

    [self initView];


    if (Enter_Worker == _enterType)
    {
        [self getChatList];
    }
    else
    {

        [self initNavRightWithImage:[UIImage imageNamed:@"icon_menu"]];

        [self getChannels];
    }


}


- (void)initRightController
{
    _controller = [[ChatRightController alloc] init];

    _controller.delegate = self;

    _controller.arrayAlarm = _arrayChannel;

    CGRect frame = frame = CGRectMake(self.screenWidth / 2, 64, self.screenWidth / 2,
            self.screenHeight - 49 - 64);


    _controller.view.frame = frame;

    [self addChildViewController:_controller];
    [self.view addSubview:_controller.view];

    _controller.view.hidden = YES;

    _controller.view.layer.shadowColor = [UIColor grayColor].CGColor;

    _controller.view.layer.shadowOffset = CGSizeMake(-3, 3);

    _controller.view.layer.shadowOpacity = 1;

    _controller.view.layer.shadowRadius = 3;
}

- (void)onClickNavRight
{
    if (_controller.view.hidden)
    {
        _controller.view.hidden = NO;
    }
    else
    {
        _controller.view.hidden = YES;
    }

}

- (void)initData
{

    _resultArray = [NSMutableArray array];
    _cafPathStr = [kSandboxPathStr stringByAppendingPathComponent:kCafFileName];
    _mp3PathStr = [kSandboxPathStr stringByAppendingPathComponent:kMp3FileName];
    _netMp3PathStr = [kSandboxPathStr stringByAppendingPathComponent:netFileName];
    [self audioRecorder];

    if (Enter_Property == _enterType)
    {
        _arrayChannel = [NSMutableArray array];
    }
}


- (void)initView
{
    //_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.pullDelegate = self;
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _btnSwitch.tag = 1001;
    _btnRecord.hidden = YES;
    [_btnSwitch addTarget:self action:@selector(showRecord) forControlEvents:UIControlEventTouchUpInside];

    [_btnSend addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];

}

- (void)showRecord
{
    if (1001 == _btnSwitch.tag)
    {
        _tfContent.hidden = YES;
        _btnSend.hidden = YES;
        _btnRecord.hidden = NO;

        [_btnRecord addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(handleTableviewCellLongPressed:)];
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.5;
        [_btnRecord addGestureRecognizer:longPress];

        _btnSwitch.tag = 1002;
        [_btnSwitch setImage:[UIImage imageNamed:@"chat_keyboard_normal"] forState:UIControlStateNormal];
    }
    else
    {
        _tfContent.hidden = NO;
        _btnSend.hidden = NO;
        _btnRecord.hidden = YES;

        _btnSwitch.tag = 1001;
        [_btnSwitch setImage:[UIImage imageNamed:@"chat_voice_normal"] forState:UIControlStateNormal];
    }
}

- (void)record
{
    NSLog(@"record");
}

#pragma mark -  Getter

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
- (AVAudioRecorder *)audioRecorder
{
    if (!_audioRecorder)
    {
        //创建录音文件保存路径
        NSURL *url = [NSURL URLWithString:self.cafPathStr];
        //创建录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        //创建录音机
        NSError *error = nil;

        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//如果要监控声波则必须设置为YES
        if (error)
        {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@", error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}


/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
- (NSDictionary *)getAudioSetting
{
    //LinearPCM 是iOS的一种无损编码格式,但是体积较为庞大
    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //采样率
    [recordSettings setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];//44100.0
    //通道数
    [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];

    return recordSettings;
}

#pragma mark - 录音方法

- (void)startRecordNotice
{

    if ([self.audioRecorder isRecording])
    {
        [self.audioRecorder stop];
    }
    NSLog(@"----------开始录音----------");
    [self deleteOldRecordFile];  //如果不删掉，会在原文件基础上录制；虽然不会播放原来的声音，但是音频长度会是录制的最大长度。

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    //[_recordBtn setImage:[UIImage imageNamed:@"record_high"]];

    if (![self.audioRecorder isRecording])
    {//0--停止、暂停，1-录制中

        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.countNum = 0;
        NSTimeInterval timeInterval = 1; //0.1s
        self.timer1 = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self
                                                     selector:@selector(changeRecordTime) userInfo:nil repeats:YES];

        [self.timer1 fire];
    }
}

- (void)changeRecordTime
{

    self.countNum += 1;
    NSInteger min = self.countNum / 60;
    NSInteger sec = self.countNum - min * 60;

    NSLog(@"count:%ld", _countNum);
    //self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
}


//长按事件的实现方法

- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {

        NSLog(@"UIGestureRecognizerStateBegan");
        [_btnRecord setTitle:@"松开手指 完成录音" forState:UIControlStateNormal];
        [self startRecordNotice];

    }

    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {

    }

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {

        NSLog(@"UIGestureRecognizerStateEnded");
        [_btnRecord setTitle:@"按住 说话" forState:UIControlStateNormal];
        [self stopRecordNotice];

    }

}


- (void)stopRecordNotice
{
    NSLog(@"----------结束录音----------");


    [self.audioRecorder stop];
    [self.timer1 invalidate];

    [self audio_PCMtoMP3];

    [self sendAudio];
}

- (void)deleteOldRecordFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:_cafPathStr];
    if (!blHave)
    {
        NSLog(@"不存在");
        return;
    }
    else
    {
        NSLog(@"存在");
        BOOL blDele = [fileManager removeItemAtPath:self.cafPathStr error:nil];
        if (blDele)
        {
            NSLog(@"删除成功");
        }
        else
        {
            NSLog(@"删除失败");
        }
    }
}


#pragma mark - caf转mp3

- (void)audio_PCMtoMP3
{

    @try
    {
        int read, write;

        FILE *pcm = fopen([self.cafPathStr cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4 * 1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([self.mp3PathStr cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置

        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];

        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);

        do
        {
            read = fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
            {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            }
            else
            {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }

            fwrite(mp3_buffer, write, 1, mp3);

        }
        while (read != 0);

        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", [exception description]);
    }
    @finally
    {
        NSLog(@"MP3生成成功: %@", self.mp3PathStr);
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position
{

    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];

    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];

    //背影图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf ? @"SenderAppNodeBkg_HL" : @"ReceiverTextNodeBkg" ofType:@"png"]];

    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width / 2) topCapHeight:floorf(bubble.size.height / 2)]];
    NSLog(@"%f,%f", size.width, size.height);


    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf ? 15.0f : 22.0f, 20.0f, size.width + 10, size.height + 10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;

    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width + 30.0f, bubbleText.frame.size.height + 20.0f);

    if (fromSelf)
    {
        returnView.frame = CGRectMake(self.view.frame.size.width - position - (bubbleText.frame.size.width + 30.0f), 30, bubbleText.frame.size.width + 30.0f, bubbleText.frame.size.height + 30.0f);
    }
    else
    {
        returnView.frame = CGRectMake(position, 30, bubbleText.frame.size.width + 30.0f, bubbleText.frame.size.height + 30.0f);
    }

    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];

    return returnView;
}

//泡泡语音
- (UIView *)yuyinView:(NSInteger)logntime from:(BOOL)fromSelf withIndexRow:(NSInteger)indexRow withPosition:(int)position
{

    //根据语音长度
    int yuyinwidth = 66 + fromSelf;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = indexRow;
    if (fromSelf)
    {
        button.frame = CGRectMake(self.view.frame.size.width - position - yuyinwidth, 30, yuyinwidth, 54);
    }
    else
    {
        button.frame = CGRectMake(position, 30, yuyinwidth, 54);
    }

    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf ? button.frame.size.width / 3 : -button.frame.size.width / 3;
    button.imageEdgeInsets = imageInsert;

    [button setImage:[UIImage imageNamed:fromSelf ? @"SenderVoiceNodePlaying" : @"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf ? @"SenderVoiceNodeDownloading" : @"ReceiverVoiceNodeDownloading"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf ? -30 : button.frame.size.width, 0, 30, button.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%ld''", logntime];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];

    return button;
}

#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_resultArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [[dict objectForKey:@"content"] sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f)
                                                 lineBreakMode:NSLineBreakByWordWrapping];

    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    else
    {
        for (UIView *cellView in cell.subviews)
        {
            [cellView removeFromSuperview];
        }
    }

    NSDictionary *dict = [_resultArray objectAtIndex:_resultArray.count - 1 - indexPath.row];

    UILabel *lbTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 170, 25)];
    lbTime.center = CGPointMake(self.view.frame.size.width / 2, 13);
    lbTime.backgroundColor = [Utils getColorByRGB:@"#c1c1c1"];
    lbTime.textColor = [UIColor whiteColor];
    lbTime.textAlignment = NSTextAlignmentCenter;
    lbTime.layer.masksToBounds = YES;
    lbTime.layer.cornerRadius = 5;
    lbTime.text = [dict objectForKey:@"sendTime"];
    lbTime.font = [UIFont systemFontOfSize:12];
    [cell addSubview:lbTime];


    if ([[dict objectForKey:@"senderName"] isEqualToString:[User sharedUser].name])
    {
        UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 45, 70, 25)];
        lbName.text = [User sharedUser].name;
        lbName.font = [UIFont systemFontOfSize:14];
        lbName.textAlignment = NSTextAlignmentRight;
        [cell addSubview:lbName];


        NSString *type = [dict objectForKey:@"type"];

        if ([type isEqualToString:@"1"])
        {
            NSString *content = [dict objectForKey:@"content"];
            content = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [cell addSubview:[self bubbleView:content from:YES withPosition:85]];
        }
        else
        {
            NSNumber *length = [dict objectForKey:@"timeLength"];

            UIView *view = [self yuyinView:length.integerValue from:YES withIndexRow:indexPath.row withPosition:85];

            view.userInteractionEnabled = YES;
            view.tag = indexPath.row;
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadMp3:)]];

            [cell addSubview:view];
        }
    }
    else
    {
        UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 70, 25)];
        lbName.text = [dict objectForKey:@"senderName"];
        lbName.font = [UIFont systemFontOfSize:14];
        lbName.textAlignment = NSTextAlignmentLeft;

        [cell addSubview:lbName];

        NSString *type = [dict objectForKey:@"type"];

        if ([type isEqualToString:@"1"])
        {
            NSString *content = [dict objectForKey:@"content"];
            content = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [cell addSubview:[self bubbleView:content from:NO withPosition:85]];
        }
        else
        {
            NSNumber *length = [dict objectForKey:@"timeLength"];

            UIView *view = [self yuyinView:length.integerValue from:NO withIndexRow:indexPath.row withPosition:85];
            view.userInteractionEnabled = YES;
            view.tag = indexPath.row;
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadMp3:)]];

            [cell addSubview:view];
        }

    }

//    if ([[dict objectForKey:@"name"]isEqualToString:@"rhl"]) {
//        photo = [[UIImageView alloc]initWithFrame:CGRectMake(320-60, 10, 50, 50)];
//        [cell addSubview:photo];
//        photo.image = [UIImage imageNamed:@"photo1"];
//        
//        if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
//            [cell addSubview:[self yuyinView:1 from:YES withIndexRow:indexPath.row withPosition:65]];
//            
//            
//        }else{
//            [cell addSubview:[self bubbleView:[dict objectForKey:@"content"] from:YES withPosition:65]];
//        }
//        
//    }else{
//        photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
//        [cell addSubview:photo];
//        photo.image = [UIImage imageNamed:@"photo"];
//        
//        if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
//            [cell addSubview:[self yuyinView:1 from:NO withIndexRow:indexPath.row withPosition:65]];
//        }else{
//            [cell addSubview:[self bubbleView:[dict objectForKey:@"content"] from:NO withPosition:65]];
//        }
//    }

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dict = [_resultArray objectAtIndex:_resultArray.count - 1 - indexPath.row];
//    NSString *type = [dict objectForKey:@"type"];
//    
//    if ([type isEqualToString:@"2"])
//    {
//        //NSURL *url = [NSURL URLWithString:@"http://192.168.0.80:3000/videos/myRecord.mp3"];
//        [self downloadMp3:@"http://192.168.0.80:3000/videos/myRecord.mp3"];
//    }
}


#pragma mark - 播放

/**
 *播放音乐文件
 */
- (BOOL)playMusicWithUrl:(NSURL *)fileUrl
{
    //其他播放器停止播放

    if (!fileUrl)
    {
        return NO;
    }

    if ([_player isPlaying])
    {
        [_player stop];
        _player = nil;
    }

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [session setActive:YES error:nil];

    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];


    _player.delegate = self;

    [_player play];

    return YES;//正在播放，那么就返回YES
}

#pragma mark - network request

- (void)getChannels
{
    [[HttpClient sharedClient] view:self.view post:@"getChatChannels" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                [_arrayChannel removeAllObjects];

                                [_arrayChannel addObjectsFromArray:[responseObject objectForKey:@"body"]];

                                if (_arrayChannel.count > 0)
                                {
                                    _alarmId = [_arrayChannel[0] objectForKey:@"id"];

                                    [self setNavTitle:[_arrayChannel[0] objectForKey:@"text"]];

                                    [self getChatList];


                                    [self initRightController];
                                }
                                else
                                {
                                    [HUDClass showHUDWithLabel:@"暂无进行中救援"];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }

                            }];
}

- (void)getChatList
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInt:10] forKey:@"rows"];
    param[@"alarmId"] = _alarmId;

    [[HttpClient sharedClient] view:self.view post:@"getChatList" parameter:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [_resultArray removeAllObjects];
        [_resultArray addObjectsFromArray:[responseObject objectForKey:@"body"]];

        [_tableView reloadData];

        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);

        if (offset.y > 0)
        {
            [self.tableView setContentOffset:offset animated:NO];
        }
    }];
}

- (void)getMoreChatList
{
    if (0 == _resultArray.count)
    {
        return;
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInt:10] forKey:@"rows"];
    param[@"alarmId"] = _alarmId;
    [param setObject:[[_resultArray lastObject] objectForKey:@"code"] forKey:@"maxCode"];

    [[HttpClient sharedClient] view:self.view post:@"getChatList" parameter:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (_tableView.pullTableIsRefreshing)
        {
            _tableView.pullTableIsRefreshing = NO;
        }

        [_resultArray addObjectsFromArray:[responseObject objectForKey:@"body"]];

        [_tableView reloadData];
    }];
}

- (void)sendText
{
    NSString *content = _tfContent.text;

    content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"1" forKey:@"type"];
    [param setObject:content forKey:@"content"];
    param[@"alarmId"] = _alarmId;
    [param setObject:[User sharedUser].name forKey:@"userName"];

    [[HttpClient sharedClient] view:self.view post:@"addChat" parameter:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _tfContent.text = @"";
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self getChatList];

    }];
}


- (void)sendAudio
{
    NSData *data = [NSData dataWithContentsOfFile:self.mp3PathStr];
    NSString *base64Str = [self Base64StrWithMp3Data:data];

    NSMutableDictionary *param1 = [NSMutableDictionary dictionary];
    [param1 setObject:base64Str forKey:@"audio"];

    [[HttpClient sharedClient] view:self.view post:@"uploadAudio" parameter:param1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *url = [[responseObject objectForKey:@"body"] objectForKey:@"url"];

        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:@"2" forKey:@"type"];
        [param setObject:url forKey:@"content"];
        [param setObject:[User sharedUser].name forKey:@"userName"];
        [param setObject:[NSNumber numberWithInteger:_countNum] forKey:@"timeLength"];
        param[@"alarmId"] = _alarmId;

        [[HttpClient sharedClient] view:self.view post:@"addChat" parameter:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            [self getChatList];

        }];
    }];

}

#pragma mark - UIScrollViewDelegate

//禁止上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //内容大于屏幕，并且向上滑动
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height
            && scrollView.contentSize.height >= scrollView.bounds.size.height)
    {
        CGPoint offset = scrollView.contentOffset;
        offset.y = scrollView.contentSize.height - scrollView.bounds.size.height;

        scrollView.contentOffset = offset;
    }
    else if (scrollView.contentOffset.y >= 0
            && scrollView.contentSize.height <= scrollView.bounds.size.height) //内容小于屏幕，并且向上滑动
    {
        CGPoint offset = scrollView.contentOffset;
        offset.x = 0;
        offset.y = 0;
        scrollView.contentOffset = offset;
    }

}


#pragma mark - 文件转换

// 二进制文件转为base64的字符串
- (NSString *)Base64StrWithMp3Data:(NSData *)data
{
    if (!data)
    {
        NSLog(@"Mp3Data 不能为空");
        return nil;
    }
    //    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return str;
}


#pragma mark - download mp3

- (void)downloadMp3:(UIGestureRecognizer *)recognizer
{
    NSInteger tag = [recognizer view].tag;

    NSString *urlStr = [_resultArray[_resultArray.count - 1 - tag] objectForKey:@"content"];

    NSString *name = [FileUtils getFileNameFromUrlString:urlStr];

    NSString *filePath = [kSandboxPathStr stringByAppendingPathComponent:name];

    NSLog(@"filePath:%@", filePath);

    //urlStr = @"http://192.168.0.80:3000/videos/myRecord.mp3";
    NSURL *url = [NSURL URLWithString:urlStr];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {

        if (data.length > 0 && nil == connectionError)
        {
            [data writeToFile:filePath atomically:YES];

            NSURL *fileUrl = [NSURL fileURLWithPath:filePath];

            [self performSelectorOnMainThread:@selector(playMusicWithUrl:) withObject:fileUrl waitUntilDone:NO];

        }
        else if (connectionError != nil)
        {
            NSLog(@"download picture error = %@", connectionError);
        }
    }];
}


#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self getMoreChatList];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{

}


- (void)receivedAlarmNotify:(NSNotification *)notification
{
    [super receivedAlarmNotify:notification];

    NSDictionary *info = [NSDictionary dictionaryWithDictionary:notification.userInfo];

    if ([[info objectForKey:@"notifyType"] isEqualToString:@"CHAT"])
    {
        NSString *alarmId = [info objectForKey:@"alarmId"];

        if ([alarmId isEqualToString:_alarmId])
        {
            [self getChatList];
        }
        else
        {
            if (_controller)
            {
                [_controller setItemUnRead:alarmId];
            }
        }

    }
}

#pragma mark - ChatRightControllerDelegate

- (void)onSelectItem:(NSString *)text withKey:(NSString *)alarmId
{
    if (!_controller.view.hidden)
    {
        _controller.view.hidden = YES;
    }

    [self setNavTitle:text];

    _alarmId = alarmId;

    [self getChatList];
}


@end

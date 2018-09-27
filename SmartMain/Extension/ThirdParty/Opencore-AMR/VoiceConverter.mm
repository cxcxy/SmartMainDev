//
//  VoiceConverter.m
//  Jeans
//
//  Created by Jeans Huang on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VoiceConverter.h"


@implementation VoiceConverter

/**
 *  转换wav到amr
 *
 *  @param aWavPath  wav文件路径
 *  @param aSavePath amr保存路径
 *
 *  @return 0失败 1成功
 */
+ (int)EncodeWavToAmr:(NSString *)aWavPath amrSavePath:(NSString *)aSavePath sampleRateType:(Sample_Rate)sampleRateType
{
    if (sampleRateType == Sample_Rate_8000)
    {
        int result = EncodeNarrowBandWAVEFileToAMRFile([aWavPath cStringUsingEncoding:NSUTF8StringEncoding], [aSavePath cStringUsingEncoding:NSUTF8StringEncoding], 1, 16);
        return  result;
    }
    else
    {
        int result = EncodeWidthBandWAVEFileToAMRFile([aWavPath cStringUsingEncoding:NSUTF8StringEncoding], [aSavePath cStringUsingEncoding:NSUTF8StringEncoding]);
        return  result;
    }
}

/**
 *  转换amr到wav
 *
 *  @param aAmrPath  amr文件路径
 *  @param aSavePath wav保存路径
 *
 *  @return 0失败 1成功
 */
+ (int)DecodeAmrToWav:(NSString *)aAmrPath wavSavePath:(NSString *)aSavePath sampleRateType:(Sample_Rate)sampleRateType
{
    if (sampleRateType == Sample_Rate_8000)
    {
        return  DecodeNarrowBandAMRFileToWAVEFile([aAmrPath cStringUsingEncoding:NSUTF8StringEncoding], [aSavePath cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    else
    {
        return  DecodeWidthBandAMRFileToWAVEFile([aAmrPath cStringUsingEncoding:NSUTF8StringEncoding], [aSavePath cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

#pragma mark - 生成文件路径
+ (NSString*)GetPathByFileName:(NSString *)fileName ofType:(NSString *)_type{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    directory = [directory stringByAppendingPathComponent:@"8KHZFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:fileName]
                                stringByAppendingPathExtension:_type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}
//获取录音设置
+ (NSDictionary*)GetAudioRecorderSettingDictWithSampleRateType:(Sample_Rate)sampleRateType
{
    CGFloat sampleRateValue = 16000.0;
    if(sampleRateType == Sample_Rate_8000)
    {
        sampleRateValue = 8000.0;
    }
    if (sampleRateType == Sample_Rate_16000)
    {
        sampleRateValue = 16000.0;
    }
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: sampleRateValue],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   nil];
    
    return recordSetting;
}
    
@end

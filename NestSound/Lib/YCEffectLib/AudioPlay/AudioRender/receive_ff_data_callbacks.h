
#ifndef ffmpeg_receive_ff_data_callbacks_h
#define ffmpeg_receive_ff_data_callbacks_h

int receive_video_streaming_data(unsigned char *buffer, int length);

int receive_audio_streaming_data(unsigned char *buffer, int length);

#endif

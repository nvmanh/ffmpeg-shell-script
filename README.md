# ffmpeg-shell-script

### 1. checkout project

- Run cmd: chmod +x install_ffmpeg_ubuntu.sh
- Run cmd: chmod +x make_crossfade_ffmpeg_video_from_images.sh
### 2. Help

After installing two apps above (ffmpeg && imagemagick)

- now you can use command followings:

ffmpeg -r 1/5 -loop 1 -i m%01d.jpg -i "TuBo-KhacViet-4822135.mp3" -c:v libx264 -r 30 -y -pix_fmt yuv420p -c:a copy -shortest slide.mp4



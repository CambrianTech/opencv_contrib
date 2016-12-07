#!/bin/sh

if [ -z "$1" ]
  then
   	echo "usage ./build_opencv_ios.sh OPENCV_SRC_ROOT CONTRIB_MODULES_PATH"
   	echo "e.g.\n  ./build_opencv_ios.sh ~/Development/opencv ~/Development/opencv_contrib"
  else
  	#prepare opencv
  	rm -rf $1/build
  	rm -f $1/CMakeCache.txt
  	mkdir $1/build

  	#remove disable in dnn module, add cmake flag for dnn
  	sed -i -e 's/cmake_flags = \[\]/cmake_flags = \[\"-DBUILD_opencv_dnn=ON\"\, \"-Dopencv_dnn_WITH_BLAS=ON\"\]/g' \
  		$1/platforms/ios/build_framework.py

  	python $1/platforms/ios/build_framework.py --opencv $1 --contrib $2 $1/build

  	#add back disable and cmake flag
  	mv -f $1/platforms/ios/build_framework.py-e $1/platforms/ios/build_framework.py 

  	#copy files, make dirs
  	rm -Rf $CB/prebuilts/opencv/opencv-ios
    mkdir $CB/prebuilts/opencv/opencv-ios
    mkdir $CB/prebuilts/opencv/opencv-ios/include

    cp -R $1/build/opencv2.framework/Versions/A/Headers $CB/prebuilts/opencv/opencv-ios/include/opencv2
    cp $1/build/opencv2.framework/Versions/A/opencv2 $CB/prebuilts/opencv/opencv-ios/libopencv2.a
fi

#!/bin/bash

# Hole TensorFlow-Header- und Library-Pfade
TF_INC=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_include())')
TF_LIB=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_lib())')

# Kompiliere die CUDA-Datei
/usr/local/cuda/bin/nvcc tf_sampling_g.cu -o tf_sampling_g.cu.o -c -O2 -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC \
    -I /usr/local/cuda/include \
    -I "$TF_INC"

# Kompiliere das Shared Object mit TensorFlow-spezifischen Includes und Framework-Link
g++ -std=c++11 tf_sampling.cpp tf_sampling_g.cu.o -o tf_sampling_so.so -shared -fPIC \
    -I "$TF_INC" \
    -I "$TF_INC/external/nsync/public" \
    -I /usr/local/cuda/include \
    -L "$TF_LIB" \
    -L "$TF_LIB"/framework \
    -L /usr/local/cuda/lib64 \
    -ltensorflow_framework \
    -D_GLIBCXX_USE_CXX11_ABI=0

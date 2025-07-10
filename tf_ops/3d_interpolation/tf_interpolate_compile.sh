#!/bin/bash

# Hole TensorFlow-Header- und Library-Pfade
TF_INC=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_include())')
TF_LIB=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_lib())')

# Kompiliere die CPU-basierte Op
g++ -std=c++11 tf_interpolate.cpp -o tf_interpolate_so.so -shared -fPIC \
    -I "$TF_INC" \
    -I "$TF_INC/external/nsync/public" \
    -L "$TF_LIB" \
    -L "$TF_LIB"/framework \
    -ltensorflow_framework \
    -D_GLIBCXX_USE_CXX11_ABI=0 \
    -O2

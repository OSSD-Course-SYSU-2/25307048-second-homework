#!/bin/bash

# 华容道多端构建脚本

set -e

echo "🎮 华容道多端构建系统"
echo "========================"

# 构建核心层
build_core() {
    echo "📦 构建核心层..."
    cd core
    npm run build
    cd ..
    echo "✅ 核心层构建完成"
}

# 构建Web版本
build_web() {
    echo "🌐 构建Web版本..."
    cd ui/web
    npm run build
    cd ../..
    echo "✅ Web版本构建完成"
}

# 构建HarmonyOS版本
build_harmonyos() {
    echo "📱 构建HarmonyOS版本..."
    cd ui/harmonyos
    hvigorw assembleHap
    cd ../..
    echo "✅ HarmonyOS版本构建完成"
}

# 构建Android版本
build_android() {
    echo "🤖 构建Android版本..."
    cd ui/android
    ./gradlew assembleRelease
    cd ../..
    echo "✅ Android版本构建完成"
}

# 构建iOS版本
build_ios() {
    echo "🍎 构建iOS版本..."
    cd ui/ios
    xcodebuild -workspace HuaRongDao.xcworkspace -scheme HuaRongDao -configuration Release
    cd ../..
    echo "✅ iOS版本构建完成"
}

# 主构建流程
case "$1" in
    "core")
        build_core
        ;;
    "web")
        build_core
        build_web
        ;;
    "harmonyos")
        build_core
        build_harmonyos
        ;;
    "android")
        build_core
        build_android
        ;;
    "ios")
        build_core
        build_ios
        ;;
    "all")
        build_core
        build_web
        build_harmonyos
        # build_android
        # build_ios
        ;;
    *)
        echo "用法: $0 {core|web|harmonyos|android|ios|all}"
        exit 1
        ;;
esac

echo ""
echo "🎉 构建完成！"
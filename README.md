# QMUIDemo_iOS
Sample Code for QMUI iOS https://github.com/Tencent/QMUI_iOS

支持 iOS 版本：iOS 13.0+

## Sketch Files

https://github.com/QMUI/QMUIDemo_Design

## 内部维护方式

### 如果要在 QMUI 内新增文件

1. 在 Xcode 里创建完文件后，打开 qmui.xcodeproj -> Build Phases -> Headers，展开 Project，右键新增的头文件，选择“Move to Public Group”。如果该头文件是私有的（不想被外部直接使用）则不需要做这一步。
2. 编译项目，此时会通过 `umbrellaHeaderFileCreator.py` 脚本自动生成新的 `QMUIKit.h`，里面会包含所有的 Public Headers。
3. 如果你新增的文件属于 `QMUIComponents`，则需要编辑 QMUI 根目录下的 `QMUIKit.podspec` 文件，在 `QMUIComponents` 模块下增加新的子模块，格式和命名参考已有的即可。注意子模块本身需要声明，而别的模块如果使用了这个新的子模块，也需要添加对新模块的依赖（`dependency`）。如果你新增的文件不属于 `QMUIComponents` 则不需要做这一步。
4. 在 QMUI 根目录下执行 `python3 add_license.py` 终端命令，以给所有的 QMUI 文件统一文件头的开源协议声明。
5. 如果某个 API、功能在新设备发布时需要重新检查，请在该代码处加上“@NEW_DEVICE_CHECKER”的标志。

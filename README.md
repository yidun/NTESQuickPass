接入一键登录请参考文档：doc/一键登录iOS SDK接入指南

接入本机验证请参考文档：doc/本机验证iOS SDK接入指南

# NTESQuickPass

[![CI Status](https://img.shields.io/travis/luolihao123456/NTESQuickPass.svg?style=flat)](https://travis-ci.org/luolihao123456/NTESQuickPass)
[![Version](https://img.shields.io/cocoapods/v/NTESQuickPass.svg?style=flat)](https://cocoapods.org/pods/NTESQuickPass)
[![License](https://img.shields.io/cocoapods/l/NTESQuickPass.svg?style=flat)](https://cocoapods.org/pods/NTESQuickPass)
[![Platform](https://img.shields.io/cocoapods/p/NTESQuickPass.svg?style=flat)](https://cocoapods.org/pods/NTESQuickPass)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

NTESQuickLogin is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:


### 1.Cocoapods 导入
```ruby
pod 'NTESQuickPass'
```
### 注：如果无法导入最新版本，pod  repo update  升级本地的pod库

### 3.如果需要安装指定版本则使用以下方式（以2.0.1版本为例）：
```ruby
pod 'NTESQuickPass',  '2.0.1' 版本号指定为 2.0.1
pod 'NTESQuickPass', '~> 2.0.1' 版本号可以是2.0.1，可以是2.0.2,但必须小于3
```

## Author

luolihao123456, luolihao123456@163.com


#### 版本更新记录：

| 版本号 | 更新日期 | 更新内容 |
| ----- | ------- | ------- |
| 1.5.2.1 | 2019.12.13 | 1. 增加对移动、联通、电信三网在取号阶段异常返回信息的保护逻辑；
| 1.5.2 | 2019.12.6 | 1. 联通 - 可选是否需要授权页的关闭回调；<br>2. 联通 - 授权页隐私协议中可插入自定义分割字符；<br>3. 优化SDK内部流程调用方式；<br>4. SDK接入demo优化；
| 2.0.0 | 2020.3.25 | 1. 统一移动、联通、电信三网的登录界面, 并增加了弹窗模式；
| 2.0.1 | 2020.3.27 | 1. 增加了customViewBlock属性，可在控制器上自定义控件 <br>2.增加了customNavBlock属性，可在导航栏上自定义控件；

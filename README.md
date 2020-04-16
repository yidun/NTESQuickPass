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

NTESQuickPass is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:


## 1.Cocoapods 集成
#### 执行pod repo update更新。
#### Podfile 里面添加以下代码：
```ruby
# 以下两种版本选择方式示例

# 集成最新版SDK:
pod 'NTESQuickPass'

# 集成指定SDK，具体版本号可先执行 pod search NTESQuickPass，根据返回的版本信息自行决定:
pod 'NTESQuickPass', '~> 2.1.1'
```
### 保存并执行pod install即可，若未执行pod repo update，请执行pod install --repo-update

## Author

luolihao123456, luolihao123456@163.com


#### 版本更新记录：

| 版本号 | 更新日期 | 更新内容 |
| ----- | ------- | ------- |
| 1.5.2.1 | 2019.12.13 | 1. 增加对移动、联通、电信三网在取号阶段异常返回信息的保护逻辑；
| 1.5.2 | 2019.12.6 | 1. 联通 - 可选是否需要授权页的关闭回调；<br>2. 联通 - 授权页隐私协议中可插入自定义分割字符；<br>3. 优化SDK内部流程调用方式；<br>4. SDK接入demo优化。
| 2.0.0 | 2020.3.25 | 1. SDK全面升级，支持三网UI界面统一自定义。<br>2.更新移动SDK。
| 2.0.1 | 2020.3.27 | 1. 增加了customViewBlock属性，可在控制器上自定义控件 <br>2.增加了customNavBlock属性，可在导航栏上自定义控件；
| 2.1.0 | 2020.4.10 | 1.授权页背景支持GIF与视频 <br>2.支持Cocopods集成方式。<br>3.适配iOS13 暗黑模式。<br>4.协议checkbox未勾选时登录按钮设计优化。
| 2.1.1 | 2020.4.16 | 1. 运营商协议页面返回按钮支持单独自定义 <br>2. 优化双卡切换后的取号成功率 <br>3. 其他文案细节优化。

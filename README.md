# LSMoyaTool

[![CI Status](https://img.shields.io/travis/墨鱼/LSMoyaTool.svg?style=flat)](https://travis-ci.org/墨鱼/LSMoyaTool)
[![Version](https://img.shields.io/cocoapods/v/LSMoyaTool.svg?style=flat)](https://cocoapods.org/pods/LSMoyaTool)
[![License](https://img.shields.io/cocoapods/l/LSMoyaTool.svg?style=flat)](https://cocoapods.org/pods/LSMoyaTool)
[![Platform](https://img.shields.io/cocoapods/p/LSMoyaTool.svg?style=flat)](https://cocoapods.org/pods/LSMoyaTool)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LSMoyaTool is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LSMoyaTool'
```

## 用法

第一步 创建 moya 枚举 初始化LSMoyaProvider

```ruby
let exampleAPIProvider = LSMoyaProvider<ExampleAPI>()
```

第二步 调用方法

```ruby
        exampleAPIProvider.request(.latestNews).mapToModel(LatestNewsModel.self, keyPath: "")
            .subscribe(onNext: { result in
               
            }, onError: { error in
               let moyaError = error as? LSMoyaError
                
            }).disposed(by: disposeBag)
```

onNext  只关心成功后数据
onError 错误回调 
1: 系统错误（超时，数据解析错误等）
2: 特殊错误码处理 （包含 code， message， data 数据）（比如对错误码201进行特殊处理）

## Author

墨鱼, w1605356103@163.com

## License

LSMoyaTool is available under the MIT license. See the LICENSE file for more info.

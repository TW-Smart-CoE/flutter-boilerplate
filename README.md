# Flutter Boilerplate

一个基于[GetX](https://pub.dev/packages/get)构建的[Flutter](https://flutter.dev/) 项目模板，包含了移动端工程化的一些常用能力，可以直接拿来使用。
> 注：GetX不仅仅是一个状态管理库，它还包含了路由、依赖注入等功能，可以说是一个全能型的库。
但本项目原则上只依赖于它的状态管理功能，其他能力如页面路由、依赖注入等并不是必须的，可以根据自己的喜好选择其他库。
这是一段正文。

## 1. 核心部分

### 1.1 包结构

``` yaml
lib # Flutter代码根目录
├── common # 一些跨页面共享的代码
│   ├── di      # 依赖注入，主要是一些全局单例对象
│   ├── network # 网络请求相关
|   |   ├── animal  # 以业务为单位组织API接口代码
|   |   |   ├── model     # 用于放置同目录下的API接口所用到的数据模型
|   |   |   |   └── animal.dart  # 动物图片相关的数据模型定义
|   |   |   └── api.dart  # 动物图片相关的API接口定义
|   |   └── dio_client.dart # 网络请求客户端
│   └── utils   # 工具类
├── pages # 以页面为单位组织所有相关业务逻辑代码
│   ├── animal_image # 展示动物图片的页面
│   │   ├── page.dart(AnimalImagePage)              # 根据状态渲染UI
│   │   ├── controller.dart(AnimalImageController)  # 状态 + 状态相关的逻辑
│   │   └── repository.dart(AnimalImageRepository)  # 数据相关的逻辑
├── res # 资源相关
|   ├── string  # 字符串资源
|   |   ├── strings.dart  # 字符串资源的入口文件，包括字符串的key定义和字符串资源的获取方法
|   |   └── en_US.dart    # 英文字符串资源
|   ├── theme   # 主题相关
|   |   ├── color.dart      # 调色盘与主题色，App中用到的颜色尽量从这里取
|   |   ├── dimension.dart  # 尺寸相关，包括控件大小、间距等
|   |   ├── shape.dart      # 形状相关
|   |   ├── typography.dart # 字体相关
|   |   └── theme.dart      # Material主题配置
├── main.dart   # 入口文件，必要时可以把MyApp抽离出来
└── routes.dart # 路由配置
```

### 1.2 架构

本项目选用的是MVVM架构，对于一个页面来说，主要包含以下几个部分：

|    | View            | ViewModel       | Model                         |
|----|-----------------|-----------------|-------------------------------|
| 代码 | page.dart       | controller.dart | repository.dart(api, model...) |
| 职责 | 用于渲染UI          | 用于管理状态和状态相关的逻辑  | 用于数据相关的逻辑 |
| 构成 | UI内部状态 + Widget | 业务状态 + UI事件响应   | 数据存取、缓存策略... |

### 1.3 页面路由

目前选用的是GetX的路由能力，但是也可以使用其他的路由库，比如[fluro](https://pub.dev/packages/fluro)、[auto_route](https://pub.dev/packages/auto_route)等。
> TODO: 此处应该对页面路由做个封装，以便于在不同的路由库之间切换。

### 1.4 依赖注入

GetX中有一个机制：在page中如果是通过GetX的依赖注入方法获取到的controller，那么在页面销毁时，会自动调用controller的dispose方法。
因此目前选用的是GetX的依赖注入能力，但是这并不是必须的，controller一般只被page持有，所以在page销毁时，controller也会被销毁，不会造成内存泄漏。
因此也可以使用其他的依赖注入库，比如[get_it](https://pub.dev/packages/get_it)、[kiwi](https://pub.dev/packages/kiwi)等。
值得一提的是，Flutter中的依赖注入库相对于Android来说比较简单，没有像Hilt那样的复杂的依赖注入场景，所以选用哪个依赖注入库并不是很重要。
一般只是用来获取一些全局单例对象，比如网络请求客户端、数据库客户端等。

### 1.5 网络库

目前选用的是[Dio](https://pub.dev/packages/dio) + [retrofit](https://pub.dev/packages/retrofit) +
[json_serializable](https://pub.dev/packages/json_serializable)的组合，这也是目前Flutter中比较流行的网络库组合。
Dio类似于Android中的OkHttp，retrofit类似于Android中的Retrofit，json_serializable类似于Android中的Gson。

### 1.6 持久化

> TODO: 预计选用[hive](https://pub.dev/packages/hive)

### 1.7 对页面异步加载的一个封装

这部分代码在`lib/common/async_loader`中，其目标是让页面不必处理异步加载的逻辑，只需要关注数据成功加载后的UI渲染即可。
`AsyncLoadProcessor`负责异步加载的UI渲染，它会根据`LoadState`的状态来显示不同的UI，`LoadState`的状态有以下几种：
1. `Idle`：表示未开始加载的空状态，此时不会显示任何内容
2. `Loading`：表示正在加载中，此时默认会显示`LoadingPlaceholder`，若`loadingView`不为空，则会显示`loadingView`
3. `Success`：表示加载成功，此时会显示`content`中传入的Widget，一般此处传入的Widget才是页面真正的主体内容
4. `Failure`：表示加载失败，此时默认则会显示`ErrorPlaceholder`，若`errorView`不为空，则会显示`errorView`

`AsyncLoadController`是`AsyncLoadProcessor`的controller，它负责处理异步加载的逻辑。它的构造函数中需要传入一个`DataController`，
`AsyncLoadController`并且会调用`DataController`的`fetch`方法来获取数据，并且会根据`fetch`的执行结果来更新`LoadState`的状态。

`DataController`是一个抽象类，它的子类需要实现`fetch`方法，`fetch`方法需要返回一个`Future`。
`DataController`是页面真正主体（即上面提到的`content`）对应的controller，它虽然要实现`fetch`方法，但它不负责获取数据，
它只用关心数据成功加载后的业务逻辑。

## 2. 非核心部分

### 2.1 Lint

### 2.2 单元测试

### 2.3 Theme

### 2.4 国际化

### 2.5 Dev Menu

### 2.6 环境变量

### 2.7 Feature Toggle

### 2.8 混淆

### 2.9 pipeline

### 2.10 local server

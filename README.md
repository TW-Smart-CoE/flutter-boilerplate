# Flutter Boilerplate

一个 Flutter 项目模板，包含了移动端工程化的一些常用能力，可以直接拿来使用。

## 技术栈

| 能力 | 方案 |
|------|------|
| 路由 | [go_router](https://pub.dev/packages/go_router) |
| 依赖注入 | [get_it](https://pub.dev/packages/get_it) |
| 状态管理 | [flutter_hooks](https://pub.dev/packages/flutter_hooks) |
| 异步数据加载 | [fquery](https://pub.dev/packages/fquery)（类 React Query） |
| 国际化 | Flutter 原生 gen-l10n（ARB） |
| 网络请求 | [Dio](https://pub.dev/packages/dio) + [retrofit](https://pub.dev/packages/retrofit) + [json_serializable](https://pub.dev/packages/json_serializable) |
| 测试 | flutter_test + [mockito](https://pub.dev/packages/mockito) + [flutter_hooks_test](https://pub.dev/packages/flutter_hooks_test) |

## 1. 核心部分

### 1.1 包结构

``` yaml
lib # Flutter代码根目录
├── common # 一些跨页面共享的代码
│   ├── async_loader # 异步加载组件
│   │   ├── async_loader.dart    # 基于 fquery QueryResult 的通用加载状态 Builder
│   │   ├── error_placeholder.dart   # 错误占位 Widget
│   │   └── loading_placeholder.dart # 加载占位 Widget
│   ├── network # 网络请求相关
│   │   ├── animal  # 以业务为单位组织API接口代码
│   │   │   ├── model     # API接口所用到的数据模型
│   │   │   │   └── animal.dart
│   │   │   └── api.dart  # 动物图片相关的API接口定义
│   │   ├── moments # 朋友圈相关API
│   │   │   ├── model
│   │   │   └── api.dart
│   │   └── dio_client.dart # 网络请求客户端
│   ├── scaffold  # 通用页面脚手架
│   └── utils     # 工具类
│       ├── di.dart              # 依赖注入配置（get_it）
│       ├── environment_config.dart # 环境配置
│       └── logger.dart          # 日志工具
├── pages # 以页面为单位组织所有相关业务逻辑代码
│   ├── counter # 计数器页面
│   │   ├── page.dart(CounterPage)         # HookWidget，渲染UI
│   │   └── use_counter.dart(useCounter)   # 自定义 Hook，管理计数状态
│   ├── animal_image # 展示动物图片的页面
│   │   ├── page.dart(AnimalImagePage)              # HookWidget + useQuery
│   │   └── repository.dart(AnimalImageRepository)  # 数据获取逻辑
│   └── moments # 朋友圈页面
│       ├── page.dart(MomentsPage)              # HookWidget + useQuery
│       ├── repository.dart(MomentsRepository)  # 组合 UserRepo + TweetRepo
│       ├── user/
│       │   ├── repository.dart # 用户数据获取
│       │   └── view.dart       # 用户信息 UI
│       └── tweet/
│           ├── repository.dart # 推文数据获取
│           ├── store.dart      # 推文缓存
│           └── view.dart       # 推文列表 UI
├── res # 资源相关
│   ├── string  # 国际化字符串（gen-l10n）
│   │   ├── app_en.arb      # 英文 ARB 源文件
│   │   ├── app_zh.arb      # 中文 ARB 源文件
│   │   ├── strings.dart    # l10n(context) 辅助方法
│   │   └── generated/      # 自动生成的本地化代码
│   └── theme   # 主题相关
│       ├── color.dart      # 调色盘与主题色
│       ├── dimension.dart  # 尺寸相关
│       ├── shape.dart      # 形状相关
│       ├── typography.dart # 字体相关
│       └── theme.dart      # Material主题配置
├── dev_menu  # 开发菜单（仅 debug 模式）
├── main.dart   # 入口文件
└── routes.dart # 路由配置（go_router）
```

### 1.2 架构

本项目采用 **Hook + Repository** 架构模式：

| 层次 | 文件 | 职责 |
|------|------|------|
| **View** | `page.dart` | HookWidget，声明式渲染 UI |
| **State** | 自定义 Hook / `useQuery` | 管理 UI 状态和异步数据加载 |
| **Data** | `repository.dart` | 数据获取、缓存策略、业务转换 |
| **API** | `api.dart` | 网络接口定义（retrofit） |

对于简单状态（如 Counter），使用自定义 Hook（`useState`）即可；
对于异步数据加载（如 AnimalImage、Moments），使用 `useQuery` + `Repository` + `AsyncLoader` 组合。

### 1.3 页面路由

使用 [go_router](https://pub.dev/packages/go_router) 管理路由，配置在 `routes.dart` 中。
go_router 是 Flutter 官方推荐的声明式路由方案，支持深度链接、重定向、路由守卫等。

### 1.4 依赖注入

使用 [get_it](https://pub.dev/packages/get_it) 作为 Service Locator，配置在 `lib/common/utils/di.dart` 中。
仅注册全局基础设施层对象（DioClient、Api），Repository 层按需实例化，不注册到 DI 容器。

### 1.5 状态管理

使用 [flutter_hooks](https://pub.dev/packages/flutter_hooks)：
- `useState` — 简单的局部状态
- `useQuery`（来自 [fquery](https://pub.dev/packages/fquery)）— 异步数据获取、缓存、重试

### 1.6 网络库

使用 [Dio](https://pub.dev/packages/dio) + [retrofit](https://pub.dev/packages/retrofit) +
[json_serializable](https://pub.dev/packages/json_serializable) 组合。
Dio 类似于 Android 中的 OkHttp，retrofit 类似于 Android 中的 Retrofit，json_serializable 类似于 Gson。

### 1.7 异步加载组件

`lib/common/async_loader/async_loader.dart` 提供了 `AsyncLoader<T>` 组件，
基于 fquery 的 `QueryResult` 自动处理 Loading / Error / Success 三种状态的 UI 切换：

```dart
AsyncLoader<List<Animal>>(
  context: context,
  query: animalsQuery,  // 来自 useQuery
  builder: (animals) => /* 成功时的 UI */,
)
```

### 1.8 国际化

使用 Flutter 原生的 `gen-l10n` 方案：
- ARB 文件位于 `lib/res/string/`（`app_en.arb`、`app_zh.arb`）
- 生成代码位于 `lib/res/string/generated/`
- 使用方式：`l10n(context).yourStringKey`
- 添加新字符串后运行 `flutter gen-l10n`

### 1.9 持久化

> TODO: 预计选用 [hive](https://pub.dev/packages/hive)

## 2. 非核心部分

### 2.1 Lint

### 2.2 单元测试

- **Hook 测试**：使用 [flutter_hooks_test](https://pub.dev/packages/flutter_hooks_test) 的 `buildHook()` + `act()`
- **Repository 测试**：使用 mockito mock Api 层
- **Widget 测试**：使用 `flutter_test` + mock repository + `CacheProvider`

### 2.3 Theme

### 2.4 Dev Menu

### 2.5 环境变量

### 2.6 Feature Toggle

### 2.7 混淆

### 2.8 pipeline

### 2.9 local server

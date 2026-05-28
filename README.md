# Flutter Boilerplate

一个 Flutter 项目模板，包含了移动端工程化的一些常用能力，可以直接拿来使用。

## 技术栈

| 能力     | 方案                                                                                                                                                    |
|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------|
| 路由     | [go_router](https://pub.dev/packages/go_router)                                                                                                       |
| 单例管理   | 顶层变量（无需 DI 框架）                                                                                                                                        |
| 全局状态   | [signals](https://pub.dev/packages/signals)                                                                                                           |
| 组件状态   | [flutter_hooks](https://pub.dev/packages/flutter_hooks)                                                                                               |
| 异步数据加载 | [fquery](https://pub.dev/packages/fquery)（类 React Query）                                                                                              |
| 国际化    | Flutter 原生 gen-l10n（ARB）                                                                                                                              |
| 网络请求   | [Dio](https://pub.dev/packages/dio) + [retrofit](https://pub.dev/packages/retrofit) + [json_serializable](https://pub.dev/packages/json_serializable) |
| 测试     | flutter_test + [mockito](https://pub.dev/packages/mockito) + [flutter_hooks_test](https://pub.dev/packages/flutter_hooks_test)                        |

## 1. 核心部分

### 1.1 包结构

``` yaml
lib # Flutter代码根目录
├── common # 一些跨页面共享的代码
│   ├── async_loader # 异步加载组件
│   │   ├── async_loader.dart    # 基于 fquery QueryResult 的通用加载状态 Builder
│   │   ├── error_placeholder.dart   # 错误占位 Widget
│   │   └── loading_placeholder.dart # 加载占位 Widget
│   ├── scaffold  # 通用页面脚手架
│   │   ├── app_bar.dart        # 通用 AppBar
│   │   └── base_scaffold.dart  # 基础页面脚手架
│   ├── states    # 全局状态（Signals）
│   │   └── auth_state.dart     # 认证状态（含顶层单例 authState）
│   └── utils     # 工具类
│       ├── environment_config.dart # 环境配置
│       ├── global_error_handler.dart # 全局错误处理
│       ├── http_client.dart     # 网络请求客户端（含顶层单例 httpClient）
│       ├── token_store.dart     # Token 存储（含顶层单例 tokenStore）
│       └── logger.dart          # 日志工具
├── pages # 以页面为单位组织所有相关业务逻辑代码（含 API、Model）
│   ├── auth # 登录认证页面
│   │   ├── api.dart                        # 登录 API 接口定义（retrofit）
│   │   ├── model.dart                      # AuthRequest / AuthResponse 数据模型
│   │   ├── page.dart(AuthPage)             # HookWidget + useMutation 处理登录
│   │   └── repository.dart(AuthRepository) # 登录 & Token 管理逻辑
│   ├── counter # 计数器页面
│   │   ├── page.dart(CounterPage)         # HookWidget，渲染UI
│   │   └── use_counter.dart(useCounter)   # 自定义 Hook，管理计数状态
│   ├── animal_image # 展示动物图片的页面
│   │   ├── api.dart                        # 动物图片 API 接口定义
│   │   ├── model/
│   │   │   └── animal.dart                 # 动物数据模型
│   │   ├── page.dart(AnimalImagePage)      # HookWidget + useQuery
│   │   └── repository.dart(AnimalImageRepository)  # 数据获取逻辑
│   └── moments # 朋友圈页面
│       ├── api.dart                        # 朋友圈 API 接口定义
│       ├── page.dart(MomentsPage)          # HookWidget + useQuery
│       ├── repository.dart(MomentsRepository)  # 组合 UserRepo + TweetRepo
│       ├── user/
│       │   ├── model/
│       │   │   └── user.dart       # 用户数据模型
│       │   ├── repository.dart     # 用户数据获取
│       │   └── view.dart           # 用户信息 UI
│       └── tweet/
│           ├── model/
│           │   ├── comment.dart    # 评论数据模型
│           │   ├── image.dart      # 图片数据模型
│           │   ├── sender.dart     # 发送者数据模型
│           │   └── tweet.dart      # 推文数据模型
│           ├── repository.dart     # 推文数据获取
│           ├── store.dart          # 推文缓存
│           └── view.dart           # 推文列表 UI
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
│   ├── factory.dart  # 开发菜单工厂
│   └── menu.dart     # 开发菜单页面
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
| **API** | `api.dart`（与页面同目录） | 网络接口定义（retrofit） |

对于简单状态（如 Counter），使用自定义 Hook（`useState`）即可；
对于异步数据加载（如 AnimalImage、Moments），使用 `useQuery` + `Repository` + `AsyncLoader` 组合。
API 接口定义和数据模型与页面代码放在同一目录下，按业务内聚组织。

### 1.3 页面路由与认证守卫

使用 [go_router](https://pub.dev/packages/go_router) 管理路由，配置在 `routes.dart` 中。
go_router 是 Flutter 官方推荐的声明式路由方案，支持深度链接、重定向、路由守卫等。

项目通过 `redirect` + `refreshListenable` 实现响应式路由守卫：

- `authState.isLoggedIn`（Signal）作为 `refreshListenable`，当认证状态变化时路由自动重新评估
- `redirect` 同步读取 signal 值，未登录跳登录页，已登录跳首页

### 1.4 Token 管理与登录

认证状态通过 `AuthState`（Signal）统一管理，位于 `lib/common/state/auth_state.dart`：

- **AuthState**：封装 `isLoggedIn` Signal + TokenStore 持久化，提供 `login()`/`logout()` 方法
- **TokenStore**（`lib/common/utils/token_store.dart`）：底层基于 `SharedPreferences` 持久化存储 Token
- **AuthPage**：使用 `useMutation` 处理登录，成功后 `authState.login(token)` 更新 signal → 路由自动跳转
- **_TokenInterceptor**（`http_client.dart` 内部）：Dio 拦截器，自动附加 `Authorization` 头；收到 401
  时自动调用 `authState.logout()` → 路由自动跳转登录页
- **Dev Menu**：调用 `authState.logout()` 即可，无需手动导航

### 1.5 单例管理

本项目不使用 DI 框架，而是利用 Dart 顶层变量的天然特性来管理单例：

- **顶层变量天然是懒加载且全局唯一的**，适用于全局基础设施（如 `httpClient`、`tokenStore`）
- **组件级对象**（如 Repository）由使用方直接构造，生命周期自然跟随组件
- **测试友好**：Repository 等类通过构造函数可选参数注入依赖，测试时传入 mock 即可

```dart
// token_store.dart — 顶层单例
final tokenStore = TokenStore();

// http_client.dart — 顶层单例
final httpClient = HttpClient();

// repository.dart — 组件级，构造时使用顶层单例作为默认值
class AuthRepository {
  AuthRepository({AuthApi? authApi, TokenStore? store})
    : _authApi = authApi ?? AuthApi(httpClient.dio),
      _tokenStore = store ?? tokenStore;
}
```

### 1.6 状态管理

项目采用双层状态管理策略：

**全局状态** — [signals](https://pub.dev/packages/signals)：

- 适用于跨组件/跨页面共享的响应式状态
- 以 `class XxxState {}` 形式组织，导出顶层变量作为单例
- Signal 实现了 `ValueNotifier`，可直接与 Flutter 生态（如 go_router 的 `refreshListenable`）集成
- 示例：`AuthState.isLoggedIn`

**组件状态** — [flutter_hooks](https://pub.dev/packages/flutter_hooks)：
- `useState` — 简单的局部状态
- `useQuery`（来自 [fquery](https://pub.dev/packages/fquery)）— 异步数据获取、缓存、重试
- `useMutation`（来自 [fquery](https://pub.dev/packages/fquery)）— 异步写操作（如登录、提交表单），支持
  onSuccess/onError 回调

### 1.7 网络库

使用 [Dio](https://pub.dev/packages/dio) + [retrofit](https://pub.dev/packages/retrofit) +
[json_serializable](https://pub.dev/packages/json_serializable) 组合。
Dio 类似于 Android 中的 OkHttp，retrofit 类似于 Android 中的 Retrofit，json_serializable 类似于 Gson。

### 1.8 异步加载组件

`lib/common/async_loader/async_loader.dart` 提供了 `AsyncLoader<T>` 组件，
基于 fquery 的 `QueryResult` 自动处理 Loading / Error / Success 三种状态的 UI 切换：

```dart
AsyncLoader<List<Animal>>(
  context: context,
  query: animalsQuery,  // 来自 useQuery
  builder: (animals) => /* 成功时的 UI */,
)
```

### 1.9 国际化

使用 Flutter 原生的 `gen-l10n` 方案：
- ARB 文件位于 `lib/res/string/`（`app_en.arb`、`app_zh.arb`）
- 生成代码位于 `lib/res/string/generated/`
- 使用方式：`l10n(context).yourStringKey`
- 添加新字符串后运行 `flutter gen-l10n`

### 1.10 持久化

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

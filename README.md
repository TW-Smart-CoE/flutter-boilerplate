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
| 持久化    | [SharedPreferences](https://pub.dev/packages/shared_preferences)                                                                                      |
| 测试     | flutter_test + [mockito](https://pub.dev/packages/mockito) + [flutter_hooks_test](https://pub.dev/packages/flutter_hooks_test)                        |

## 1. 核心部分

### 1.1 包结构

``` yaml
lib # Flutter代码根目录
├── features # 以功能点为单位组织所有相关业务逻辑代码（含 API、Model）
│   ├── auth # 登录认证页面
│   │   ├── api_auth.dart             # 登录 API 接口定义
│   │   ├── model_auth.dart           # Auth 数据模型
│   │   ├── page_auth.dart            # 登录页面
│   │   └── repository_auth.dart      # 登录 & Token 管理逻辑
│   ├── counter # 计数器页面
│   │   ├── page_counter.dart         # 计数器页面
│   │   └── use_counter.dart          # 管理计数状态的 Hook
│   ├── animal_image # 展示动物图片的页面
│   │   ├── api_animal_image.dart         # 动物图片 API 接口定义
│   │   ├── model_animal_image.dart       # 动物图片数据模型
│   │   ├── page_animal_image.dart        # 动物图片页面
│   │   └── repository_animal_image.dart  # 动物图片数据仓库
│   └── moments # 朋友圈页面
│       ├── api_moments.dart          # 朋友圈 API 接口定义
│       ├── page_moments.dart         # 朋友圈页面
│       ├── repository_moments.dart   # 朋友圈数据仓库
│       ├── user/
│       │   ├── model_user.dart       # 用户数据模型
│       │   ├── repository_user.dart  # 用户数据仓库
│       │   └── view_user.dart        # 用户信息 UI
│       └── tweet/
│           ├── model/
│           │   ├── comment.dart      # 评论数据模型
│           │   ├── image.dart        # 图片数据模型
│           │   ├── sender.dart       # 发送者数据模型
│           │   └── tweet.dart        # 推文数据模型
│           ├── repository_tweet.dart # 推文数据仓库
│           ├── store_tweet.dart      # 推文数据缓存
│           └── view_tweet.dart       # 推文列表 UI
├── widgets   # 跨页面共享的 UI 组件
│   ├── async_loader # 异步加载组件
│   │   ├── async_loader.dart         # 配合 useQuery 处理加载动画的组件
│   │   ├── error_placeholder.dart    # 错误占位 Widget
│   │   └── loading_placeholder.dart  # 加载占位 Widget
│   └── scaffold  # 通用页面脚手架
│       ├── app_bar.dart              # 通用 AppBar
│       └── base_scaffold.dart        # 基础页面脚手架
├── states    # 全局状态（Signals）
│   └── state_auth.dart               # 全局登录状态
├── shared    # 跨页面共享的基础设施（单例对象）
│   ├── environment_config.dart       # 环境配置
│   ├── http_client.dart              # 网络请求客户端
│   ├── logger.dart                   # 日志工具
│   └── store_token.dart              # Token 存储
├── utils     # 工具类（无状态、无副作用）
│   └── global_error_handler.dart     # 全局错误处理
├── res # 资源相关
│   ├── string  # 国际化字符串（gen-l10n）
│   │   ├── app_en.arb                # 英文字符串
│   │   ├── app_zh.arb                # 中文字符串
│   │   ├── strings.dart              # 辅助方法
│   │   └── generated/                # 自动生成的本地化代码
│   └── theme   # 主题相关
│       ├── color.dart                # 调色盘与主题色，App中用到的颜色尽量从这里取
│       ├── dimension.dart            # 尺寸相关，包括控件大小、间距等
│       ├── shape.dart                # 形状相关
│       ├── typography.dart           # 字体相关
│       └── theme.dart                # Material主题配置
├── dev_menu  # 调试菜单（仅 debug 模式）
│   ├── factory.dart                  # 调试菜单工厂
│   └── menu.dart                     # 调试菜单页面
├── main.dart   # 入口文件
└── routes.dart # 路由配置（go_router）
```

### 1.2 架构

本项目采用 **三层架构 + 纵向切分**
的设计模式，灵感来源于[通用应用架构](https://juejin.cn/post/7390569548367970314)。

#### 横向分层

| 层次        | 实现方式                                     | 职责                             |
|-----------|------------------------------------------|--------------------------------|
| **UI 层**  | `page_xxx.dart`（HookWidget）              | 声明式渲染 UI，根据 state 显示对应视图       |
| **流程控制层** | 自定义 Hook / `useQuery` / `useMutation`    | 定义 UI State，处理用户事件，衔接 UI 与纯逻辑层 |
| **纯逻辑层**  | `repository_xxx.dart` / `store_xxx.dart` | 业务核心逻辑，数据获取、缓存、计算等（UI 无关）      |

数据流方向：用户事件 → 流程控制层 → 纯逻辑层 → 返回结果 → 更新 UI State → UI 重绘。

#### 各层职责详解

**UI 层**（组件函数）：

- 仅负责根据 state 的值渲染相应的 UI，内部应只包含分支逻辑（如 loading / error / success）
- 用户事件直接分发给流程控制层处理，不包含业务逻辑
- 示例：`CounterPage` 只负责显示数字和按钮，点击事件委托给 `useCounter()`

**流程控制层**（Hooks 函数）：

- 定义 UI State（`useState`），监听生命周期（`useEffect`），处理用户事件
- 承上启下：向上为 UI 层提供 state + 事件处理函数，向下调用纯逻辑层
- 对于简单场景，自定义 Hook 即可（如 `useCounter`）
- 对于异步数据加载，使用通用流程控制组件 `useQuery` / `useMutation`（来自
  fquery），它们标准化了异步操作的状态管理（loading / error / success）

**纯逻辑层**（Repository / Store）：

- 包含所有 UI 无关的业务逻辑：网络请求、数据组合、缓存策略等
- 无状态组件用 Repository 实现（如 `AnimalImageRepository`）
- 有状态组件用 Store 实现（如 `AuthState`，维护登录状态的状态机）
- 检验标准：能否通过命令行调用来实现核心功能

#### 纵向切分（Vertical Slicing）

项目以 **业务单元（数据流）** 为最小单位组织代码，每个页面目录包含该业务完整的三层代码：

``` yaml
features/counter/
├── page_counter.dart             # UI 层
└── use_counter.dart              # 流程控制层（无需纯逻辑层）

features/animal_image/
├── page_animal_image.dart        # UI 层（useQuery 充当流程控制层）
└── repository_animal_image.dart  # 纯逻辑层
```

这种组织方式使得每个业务单元是独立整体，可以单独修改、移动或删除，很好地应对需求变化。

#### 文件命名规则

业务组件文件采用 **类型前置** 的命名规范：`{类型}_{业务名}.dart`，例如：

| 类型         | 命名示例                           | 所在层级  | 说明           |
|------------|--------------------------------|-------|--------------|
| page       | `page_counter.dart`            | UI 层  | 页面 UI 组件     |
| view       | `view_user.dart`               | UI 层  | 子视图组件        |
| use        | `use_counter.dart`             | 流程控制层 | 自定义 Hook     |
| repository | `repository_animal_image.dart` | 纯逻辑层  | 数据仓库         |
| api        | `api_auth.dart`                | 纯逻辑层  | API 接口定义     |
| model      | `model_auth.dart`              | 纯逻辑层  | 数据模型         |
| store      | `store_tweet.dart`             | 纯逻辑层  | 有状态的缓存/存储    |
| state      | `state_auth.dart`              | 纯逻辑层  | 全局状态（Signal） |

这样做的好处是在文件列表中可以快速按类型分组识别，同时避免不同业务模块中出现大量同名的 `page.dart`、
`repository.dart` 等文件。

### 1.3 页面路由与认证守卫

使用 [go_router](https://pub.dev/packages/go_router) 管理路由，配置在 `routes.dart` 中。
go_router 是 Flutter 官方推荐的声明式路由方案，支持深度链接、重定向、路由守卫等。

项目通过 `redirect` + `refreshListenable` 实现响应式路由守卫：

- `authState.isLoggedIn`（Signal）作为 `refreshListenable`，当认证状态变化时路由自动重新评估
- `redirect` 同步读取 signal 值，未登录跳登录页，已登录跳首页

### 1.4 Token 管理与登录

认证状态通过 `AuthState`（Signal）统一管理，位于 `lib/states/state_auth.dart`：

- **AuthState**：封装 `isLoggedIn` Signal + TokenStore 持久化，提供 `login()`/`logout()` 方法
- **TokenStore**（`lib/shared/store_token.dart`）：底层基于 `SharedPreferences` 持久化存储 Token
- **AuthPage**：使用 `useMutation` 处理登录，成功后 `authState.login(token)` 更新 signal → 路由自动跳转
- **_TokenInterceptor**（`http_client.dart` 内部）：Dio 拦截器，自动附加 `Authorization` 头；收到 401
  时自动调用 `authState.logout()` → 路由自动跳转登录页
- **Dev Menu**：调用 `authState.logout()` 即可，无需手动导航

### 1.5 依赖注入

本项目不使用 DI 框架，而是利用 Dart 顶层变量的天然特性来管理单例对象，
同时用 UI 组件直接持有的方式来管理 UI 组件级对象：

- **顶层变量天然是懒加载且全局唯一的**，适用于全局基础设施（如 `httpClient`、`tokenStore`）
- **组件级对象**（如 Repository）由使用方（组件）直接构造，生命周期自然跟随组件
- **测试友好**：本项目规定所有外部依赖都必须通过构造函数参数传入，且以默认值的形式注入进来（单例对象或直接构造对象），
  方便测试时替换为 mock 对象

```dart
// store_token.dart — 顶层单例
final tokenStore = TokenStore();

// http_client.dart — 顶层单例
final httpClient = HttpClient();

// repository.dart — 组件级，会被 UI 组件构造并持有
class AuthRepository {
  AuthRepository({AuthApi? authApi, TokenStore? store})
    : _authApi = authApi ?? AuthApi(httpClient.dio), // 构造依赖对象
      _tokenStore = store ?? tokenStore; // 注入顶层单例
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

### 1.8 持久化

使用 [SharedPreferences](https://pub.dev/packages/shared_preferences) 进行简单的键值对持久化，适用于存储
Token、用户设置等小型数据。对于更复杂的本地数据库需求，可以考虑集成 [Hive](https://pub.dev/packages/hive)。

### 1.9 异步加载组件

`lib/widgets/async_loader/async_loader.dart` 提供了 `AsyncLoader<T>` 组件，
基于 fquery 的 `QueryResult` 自动处理 Loading / Error / Success 三种状态的 UI 切换：

```dart
AsyncLoader<List<Animal>>(
  context: context,
  query: animalsQuery,  // 来自 useQuery
  builder: (animals) => /* 成功时的 UI */,
)
```

### 1.10 国际化

使用 Flutter 原生的 `gen-l10n` 方案：

- ARB 文件位于 `lib/res/string/`（`app_en.arb`、`app_zh.arb`）
- 生成代码位于 `lib/res/string/generated/`
- 使用方式：`stringsOf(context).yourStringKey`
- 添加新字符串后运行 `flutter gen-l10n`

## 2. 非核心部分

### 2.1 Lint

基于 [flutter_lints](https://pub.dev/packages/flutter_lints) 规则集，
并在 `analysis_options.yaml` 中做了以下定制：

- `avoid_print` → **error**：禁止使用 `print()`，强制使用 `logger`
- `parameter_assignments` → **error**：禁止对函数参数重新赋值
- `prefer_single_quotes` → 统一使用单引号
- `prefer_final_fields` / `prefer_final_locals` / `prefer_final_in_for_each` → 尽可能使用 `final`
- `constant_identifier_names` → 常量建议使用大写蛇形命名（如 `SCREAMING_SNAKE_CASE`）
- `lines_longer_than_80_chars` → 关闭（项目使用 100 字符行宽）
- 排除 `**.g.dart` 生成文件

格式化器配置 `page_width: 100`。

### 2.2 单元测试

- **Hook 测试**：使用 [flutter_hooks_test](https://pub.dev/packages/flutter_hooks_test) 的
  `buildHook()` + `act()` 来测试自定义 Hook 的状态变化和副作用。参见 `use_counter_test.dart`。
- **Repository 测试**：使用 mockito mock Api 层来测试 Repository 的业务逻辑。
  参见 `repository_animal_image_test.dart`。
- **Widget 测试**：使用 `flutter_test` 的 `testWidgets` 函数来测试普通 Widget 的渲染和交互。
  对于使用了 `fquery` 的 Widget 可以使用 `test_utils.dart` 中的 `testPage` 函数来测试。
  参见 `page_animal_image_test.dart`。

### 2.3 Theme

主题相关代码位于 `lib/res/theme/`，采用 Material 3 ColorScheme 体系：

| 文件                | 说明                                                                                                                       |
|-------------------|--------------------------------------------------------------------------------------------------------------------------|
| `color.dart`      | 定义 `ColorPalette` 调色盘（含 primary / secondary / tertiary / neutral / error / success 各 11 级色阶），以及 light/dark `ColorScheme` |
| `dimension.dart`  | 统一的尺寸常量：`WidgetSize`（控件大小）、`EdgeInset`（间距）、`BorderWidth`（边框粗细）                                                           |
| `shape.dart`      | 形状（圆角等）                                                                                                                  |
| `typography.dart` | 字体样式                                                                                                                     |
| `theme.dart`      | 基于上述配置组装 `lightTheme` / `darkTheme`                                                                                      |

使用方式：App 中用到的颜色从 `AppColorPalette` 或 `Theme.of(context).colorScheme` 取值，
尺寸从 `WidgetSize` / `EdgeInset` 取值，避免硬编码魔法数字。

### 2.4 Dev Menu

调试菜单仅在 **debug 模式** 下可见，通过 `lib/dev_menu/factory.dart` 的 `createDevMenu()` 工厂函数控制：

```dart
StatelessWidget? createDevMenu() {
  return kDebugMode ? const DevMenu() : null;
}
```

菜单内容（`lib/dev_menu/menu.dart`）：
- 快速跳转到各个页面（Counter、AnimalImage、Moments 等）
- 一键退出登录（清除 Token）

以 Drawer 形式呈现，方便开发阶段快速导航和调试。

### 2.5 环境变量

使用 [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) 加载 `.env` 文件，支持多环境切换：

```
config/
├── dev.env    # 开发环境
├── qa.env     # 测试环境
├── stage.env  # 预发布环境
└── prod.env   # 生产环境
```

通过编译时参数 `--dart-define=ENV=xxx` 指定环境（默认 `dev`）：

```bash
flutter run --dart-define=ENV=prod
```

代码中通过 `Env['BASE_URL']` 等方式读取环境变量。`loadEnvironmentConfig()` 在 `main.dart` 中应用启动时调用。

### 2.6 Git Hooks

使用 [husky](https://pub.dev/packages/husky) 管理 Git Hooks，hook 脚本位于 `.husky/` 目录下并提交到仓库。

| Hook         | 文件                  | 执行内容                                |
|--------------|---------------------|-------------------------------------|
| `pre-commit` | `.husky/pre-commit` | `dart format .` + `flutter analyze` |
| `pre-push`   | `.husky/pre-push`   | 运行测试 + 覆盖率检查                        |

**首次 clone 项目后启用 hooks：**

```bash
dart run husky install
```

**添加新的 hook：**

```bash
dart run husky add .husky/<hook-name> "<command>"
```

跳过 hook 检查（紧急情况）：

```bash
git commit -m "urgent fix" --no-verify
```

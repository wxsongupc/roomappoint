# RoomMind 自习室预约系统 —— 本地开发部署指南

> 适用场景：数据库服务器无法访问 / 需要本地独立开发 / 离线调试

---

## 📋 一、软件环境要求

| 软件 | 版本 | 是否必须 | 用途 |
|---|---|---|---|
| **JDK** | 17+ | ✅ 必须 | 运行 Spring Boot 后端 |
| **MySQL** | 8.0+ | ✅ 必须 | 数据库存储 |
| **Node.js** | 16+ | ✅ 必须 | 运行 Vue 前端 |
| **RabbitMQ** | 3.8+ | ⭕ 可选 | 预约消息队列（无则预约 ToOrder 接口失败） |
| **IDEA** / **Eclipse** | 最新版 | ⭕ 可选 | Java IDE，也可以用 mvn 命令行 |
| **VS Code** | 最新版 | ⭕ 可选 | 前端 IDE |

---

## 🛠️ 二、数据库初始化（MySQL）

### 方法 A：使用图形工具（Navicat / DBeaver / MySQL Workbench）

1. 连接本地 MySQL（默认 127.0.0.1:3306，root/123456）
2. 打开 SQL 文件：`backend/src/main/resources/schema.sql`
3. 全选执行（Ctrl+A → Ctrl+Enter）
4. 验证：查询 `SHOW TABLES;` 应看到 7 张表

### 方法 B：命令行（CMD / PowerShell）

```bash
# 登录 MySQL（根据你的本地密码修改）
mysql -h 127.0.0.1 -u root -p123456

# 在 MySQL 命令行中执行
source D:/net_race_new/RoomMind/backend/src/main/resources/schema.sql;

# 验证
SHOW TABLES;
```

### 预期数据

执行成功后，数据库 `dev_roommind` 包含以下数据：

| 表名 | 数据量 | 说明 |
|---|---|---|
| appuser | 4 条 | 1 管理员 + 3 普通用户 |
| room | 4 条 | 阳光自习室 / 静谧书房 / 深夜自习室 / 考研专区 |
| seat | 80 条 | 每个自习室 4行×5列=20个座位 |
| appointrecord | 10 条 | 3 用户的预约记录（含已完成/已预约/已取消/逾期） |
| integral | 9 条 | 用户积分获取/扣除记录 |
| banner | 3 条 | 首页轮播图 |
| vaildcode | 0 条 | 验证码（运行时动态生成） |

### 测试账号

| 用户名 | 密码 | 角色 | 说明 |
|---|---|---|---|
| **admin** | 123456 | 管理员 | 完整后台权限 |
| **user001** | 123456 | 普通用户 | 张小明，积分 125 |
| **user002** | 123456 | 普通用户 | 李小红，积分 90 |
| **user003** | 123456 | 普通用户 | 王大伟，积分 150 |

> 密码 MD5：`e10adc3949ba59abbe56e057f20f883e`

---

## 🚀 三、后端启动（Spring Boot）

### 方式 A：IDEA 图形化运行

1. 用 IDEA 打开 `backend` 目录（作为 Maven 项目）
2. 等待 Maven 依赖自动下载完成（右下角进度条）
3. 打开文件：`src/main/java/com/example/web/WebApplication.java`
4. 点击 main 方法左侧的 ▶️ 绿色按钮 → **Run 'WebApplication'**
5. 看到以下日志即表示启动成功：

```
Started WebApplication in 12.345 seconds
Tomcat started on port 8080
```

### 方式 B：命令行启动

```bash
cd D:\net_race_new\RoomMind\backend

# 编译并启动（需要已安装 Maven）
mvn spring-boot:run

# 或者先打 jar 包再运行
mvn clean package -DskipTests
java -jar target/RoomMind-0.0.1-SNAPSHOT.jar
```

### 验证后端是否正常

打开浏览器访问：<http://localhost:8080/AI/GetSystemPrompt>

如果返回 JSON（含 Success: true + Data 字段），说明后端 + 数据库连接成功。

也可以直接测试登录：
```bash
curl -X POST http://localhost:8080/User/SignIn \
  -H "Content-Type: application/json" \
  -d '{"UserName":"user001","Password":"e10adc3949ba59abbe56e057f20f883e"}'
```

---

## 🌐 四、前端启动（Vue）

### 方式 A：命令行（推荐）

```bash
cd D:\net_race_new\RoomMind\frontend

# 首次启动需要安装依赖
npm install

# 启动开发服务器（Vue CLI 项目使用 serve）
npm run serve
```

启动成功后，终端会显示：

```
  App running at:
  - Local:   http://localhost:xxxx/
  - Network: http://你的IP:xxxx/
```

在浏览器打开 http://localhost:xxxx 即可访问系统。

### 前端配置说明

文件 `frontend/.env.development` 已配置：

```
VUE_APP_BASE_API = 'http://localhost:8080'  # 后端API地址
VUE_APP_BASE_WS = 'ws://localhost:8080'      # WebSocket地址
```

如果你的后端端口不是 8080，修改此文件即可。

---

## ✅ 五、完整功能测试清单

启动前后端后，按以下顺序测试：

### 🔐 1. 登录功能

打开 http://localhost:xxxx → 登录页 → 输入 `user001 / 123456` → 登录成功

### 🏠 2. 自习室列表

点击导航栏「自习室」→ 应看到 4 个自习室卡片（带图片/地址/介绍）

### 💺 3. 选座预约

进入某自习室详情 → 看到座位布局图 → 选择空闲座位 → 提交预约

> ⚠️ 如果未安装 RabbitMQ，点击预约会失败。这是正常现象。
> 安装 RabbitMQ 后自动恢复（见第七章）。

### 📊 4. 我的预约

进入「我的预约」→ 应看到测试数据中的预约记录（含状态/评分）

### ⭐ 5. 我的积分

进入「我的积分」→ 应看到 125 分（user001），并显示积分明细

### 🤖 6. AI 助手

页面右下角出现 🤖 悬浮图标 → 点击弹出聊天窗口 → 测试以下问题：

| 问题 | 预期回答 |
|---|---|
| 有哪些自习室？ | 列出 4 个自习室的真实名称和地址 |
| 座位情况？ | 回答总座位数 80 个 |
| 我的积分有多少？ | 回答"125 分"及获取记录（需登录 user001）|
| 我的预约有哪些？ | 列出真实预约记录详情 |
| 怎么预约座位？ | 基于业务规则的使用说明 |

> AI 助手使用 **RAG 检索增强生成**技术：根据你的问题查询数据库，再交给 DeepSeek 生成回答，保证回答与系统数据一致。

---

## 📦 六、配置文件说明

所有配置文件位于 `backend/src/main/resources/`：

| 文件 | 用途 | 是否需要修改 |
|---|---|---|
| `application.yml` | 主配置，设置 `profiles.active: dev` | 一般不动 |
| `application-dev.yml` | ⭐ 本地开发环境（本文件） | 根据本机 MySQL 密码修改 |
| `application-prod.yml` | 生产环境（服务器） | 不动 |
| `schema.sql` | 数据库初始化脚本 | 不动 |

### application-dev.yml 中可能需要修改的项

```yaml
spring:
  datasource:
    username: root          # ⬅ 你的MySQL用户名
    password: 123456        # ⬅ 你的MySQL密码（很可能是这里需要改！）
```

如果你的本地 MySQL 端口不是 3306，或用户名不是 root，修改 URL 中对应部分即可。

---

## 🐰 七、（可选）安装 RabbitMQ

如果需要完整使用预约提交消息队列功能，安装 RabbitMQ：

### Windows 安装（使用 Docker，最简单）

```bash
# 如果已安装 Docker Desktop，执行：
docker run -d --name rmq ^
  -p 5672:5672 ^
  -p 15672:15672 ^
  rabbitmq:3-management

# 浏览器访问 http://localhost:15672
# 用户名/密码: guest / guest
```

### Windows 原生安装（不使用 Docker）

1. 下载并安装 **Erlang**：<https://www.erlang.org/downloads>
2. 下载并安装 **RabbitMQ**：<https://www.rabbitmq.com/install-windows.html>
3. 开始菜单中找到 "RabbitMQ Command Prompt" → 输入：

```bash
rabbitmq-plugins enable rabbitmq_management
```

4. 浏览器访问 <http://localhost:15672>（guest/guest）

安装完成后，**重启后端**即可自动连接（application-dev.yml 已配置为 127.0.0.1:5672）。

---

## 🔧 八、常见问题 FAQ

### Q1：启动时报 `Access denied for user 'root'@'localhost'`

**原因**：本地 MySQL 密码不是 `123456`。

**解决**：修改 `backend/src/main/resources/application-dev.yml` 中的 `password` 字段。

---

### Q2：启动时报 `Unknown database 'dev_roommind'`

**原因**：未执行 schema.sql 初始化数据库。

**解决**：按「二、数据库初始化」步骤执行 schema.sql。

---

### Q3：前端页面空白或报错

**原因 1**：后端未启动或端口不匹配。
**解决**：检查后端是否运行在 8080，检查 `frontend/.env.development` 中的 `VUE_APP_BASE_API`。

**原因 2**：node_modules 未安装。
**解决**：在 frontend 目录执行 `npm install`。

---

### Q4：点击预约按钮失败

**原因**：未安装 RabbitMQ，消息队列无法连接。

**解决**：
- 方案 A（推荐）：按第七章安装 RabbitMQ，重启后端
- 方案 B：临时不使用预约功能，其他功能不受影响

---

### Q5：AI 助手回复"API Key 尚未配置"

**原因**：DeepSeek API Key 是示例值。

**解决**：
1. 访问 <https://platform.deepseek.com> 注册账号
2. 生成新的 API Key（格式 `sk-xxxxxxxxxx`）
3. 填入 `application-dev.yml` 中的 `app.deepseek.api-key`
4. 重启后端

---

### Q6：AI 助手可以聊天但回答的信息与系统数据不符

**原因**：RAG 检索服务可能未正常工作。

**排查**：
1. 确认 `AiContextServiceImpl.java` 文件存在
2. 查看 IDEA 控制台日志，确认启动时无异常
3. 在 MySQL 中执行：`SELECT Name FROM room;` 确认有自习室数据
4. 重新启动后端服务

---

### Q7：如何切换回服务器数据库？

修改 `backend/src/main/resources/application.yml`：

```yaml
spring:
  profiles:
    active: prod   # 从 dev 改回 prod
```

然后重启后端即可（此时需要能访问服务器数据库）。

---

## 🗂️ 九、项目文件结构

```
D:\net_race_new\RoomMind\
├── backend\                      # 后端（Spring Boot 3 + MyBatis-Plus）
│   ├── src\main\java\com\example\web\
│   │   ├── WebApplication.java       # ← 启动入口
│   │   ├── controller\                # 控制器（接口层）
│   │   ├── service\                   # 服务层
│   │   │   └── impl\AiContextServiceImpl.java  # ✨ AI 上下文检索
│   │   ├── entity\                    # 实体类（对应数据库表）
│   │   └── dto\                       # 数据传输对象
│   └── src\main\resources\
│       ├── application.yml            # 主配置（默认激活 dev）
│       ├── application-dev.yml        # ✨ 本地开发配置（本文件使用）
│       ├── application-prod.yml       # 生产环境配置（服务器使用）
│       └── schema.sql                 # ✨ 数据库初始化脚本
│
├── frontend\                     # 前端（Vue 2 + ElementUI）
│   ├── src\
│   │   ├── components\AiChatWidget.vue  # ✨ AI 助手悬浮组件
│   │   └── views\Front\              # 前台页面
│   └── .env.development              # ✨ 本地 API 地址（localhost:8080）
│
├── docs\                         # 文档目录
│   ├── LOCAL_DEPLOYMENT.md          # ✨ 本文档
│   ├── AI_ASSISTANT_CHANGELOG.md    # AI 功能变更说明
│   └── AI_ASSISTANT_API.md          # AI 接口文档
│
└── README.md
```

---

## ✨ 十、开发小提示

1. **热部署**：修改前端代码后保存，浏览器自动刷新（无需重启）
2. **SQL 日志**：application-dev.yml 配置了 `StdOutImpl`，控制台可看到每条 SQL 语句
3. **AI 调试**：在 AI 聊天中直接问「有哪些自习室？」可快速验证数据库连接
4. **前后端端口**：后端 8080，前端端口由 vite/webpack 自动分配（查看终端输出）
5. **跨域**：前端请求已通过 axios baseURL 转发到 8080，无需额外配置
6. **重置数据**：如需重置数据库，重新执行 schema.sql 即可

---

> 祝开发顺利！如有疑问，可参考 AI 助手文档或查看后端日志 📚
# 自习室预约管理系统

> 基于 Spring Boot + Vue 的自习室座位预约管理系统，实现自习室资源的高效管理与合理分配。

## ✨ 功能特性

### 用户端功能
| 功能 | 描述 |
| :--- | :--- |
| 用户注册/登录 | 邮箱验证码验证注册，JWT身份认证 |
| 自习室浏览 | 查看自习室列表和详情信息 |
| 座位选择 | 可视化座位分布，选择可用座位 |
| 预约下单 | 选择时间，完成座位预约 |
| 预约管理 | 查看、取消个人预约记录 |
| 签到使用 | 扫码/手动签到开始使用 |
| 评论评分 | 对已完成预约进行评价 |
| 积分系统 | 积分获取、消费、查询 |
| 个人中心 | 个人信息管理、密码修改 |

### 管理端功能
| 功能 | 描述 |
| :--- | :--- |
| 用户管理 | 用户列表、角色管理 |
| 自习室管理 | 自习室CRUD、封面设置 |
| 座位管理 | 座位编排、状态维护 |
| 预约管理 | 全部预约记录管理 |
| 积分管理 | 积分记录、手动增减 |
| 数据统计 | 预约状态统计、积分趋势图表 |
| 实时监控 | 各自习室实时在场人数 |
| 轮播图管理 | 首页封面图管理 |

## 🛠️ 技术栈

### 后端
| 技术 | 版本 | 用途 |
| :--- | :--- | :--- |
| Spring Boot | 3.3.1 | 后端框架 |
| Java | 17 | 编程语言 |
| MyBatis Plus | 3.5.7 | ORM框架 |
| MySQL | 8.0.33 | 数据库 |
| JWT | 3.19.2 | 身份认证 |
| Spring Mail | - | 邮件验证码 |
| WebSocket | - | 实时数据推送 |
| Apache POI | 4.1.0 | Excel导出 |

### 前端
| 技术 | 版本 | 用途 |
| :--- | :--- | :--- |
| Vue | 2.6.14 | 前端框架 |
| Element UI | 2.15.14 | UI组件库 |
| Vue Router | 3.0.6 | 路由管理 |
| Vuex | 3.1.0 | 状态管理 |
| Axios | 0.18.1 | HTTP请求 |
| ECharts | 5.5.1 | 数据可视化 |

## 🚀 快速开始

### 环境要求

- **Java**: 17+
- **Node.js**: 14+
- **MySQL**: 8.0+

### 项目结构

```
roomappoint/
├── RoomAppoint.elementui/    # 前端项目
│   ├── public/               # 静态资源
│   ├── src/
│   │   ├── api/              # API接口封装
│   │   ├── components/       # 公共组件
│   │   ├── router/           # 路由配置
│   │   ├── store/            # 状态管理
│   │   ├── utils/            # 工具函数
│   │   └── views/            # 页面视图
│   │       ├── Admin/        # 管理端页面
│   │       └── Front/        # 用户端页面
│   └── package.json
├── RoomAppoint.springboot/   # 后端项目
│   ├── src/main/java/com/example/web/
│   │   ├── controller/       # 控制器层
│   │   ├── service/          # 服务层
│   │   ├── mapper/           # 数据访问层
│   │   ├── entity/           # 实体类
│   │   ├── dto/              # 数据传输对象
│   │   ├── enums/            # 枚举类
│   │   ├── job/              # 定时任务
│   │   └── tools/            # 工具类
│   ├── src/main/resources/
│   │   └── application.yml   # 配置文件
│   └── pom.xml
└── .gitignore
```

### 安装步骤

#### 1. 数据库配置

创建数据库并导入数据：

```sql
CREATE DATABASE RoomAppoint CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### 2. 后端启动

```bash
cd RoomAppoint.springboot

# 修改配置文件（src/main/resources/application.yml）
# 配置数据库连接信息

# 运行项目
mvn spring-boot:run
```

后端服务默认运行在 `http://localhost:7245`

#### 3. 前端启动

```bash
cd RoomAppoint.elementui

# 安装依赖
npm install

# 开发模式运行
npm run serve
```

前端服务默认运行在 `http://localhost:8080`

### 配置说明

后端配置文件 `application.yml` 关键配置：

| 配置项 | 默认值 | 说明 |
| :--- | :--- | :--- |
| server.port | 7245 | 后端服务端口 |
| spring.datasource.url | jdbc:mysql://localhost:3306/RoomAppoint | 数据库地址 |
| spring.datasource.username | root | 数据库用户名 |
| spring.datasource.password | 123456 | 数据库密码 |
| spring.mail.host | smtp.163.com | 邮件SMTP服务器 |

## 📊 数据库设计

### 核心数据表

| 表名 | 说明 |
| :--- | :--- |
| AppUser | 用户表 |
| Room | 自习室表 |
| Seat | 座位表 |
| AppointRecord | 预约记录表 |
| Integral | 积分表 |
| Banner | 轮播图表 |

### 预约状态

| 状态值 | 状态名称 |
| :--- | :--- |
| 1 | 待使用 |
| 2 | 使用中 |
| 3 | 预约完成 |
| 4 | 用户取消 |
| 5 | 逾期取消 |
| 6 | 待评论 |

### 用户角色

| 角色值 | 角色名称 |
| :--- | :--- |
| 1 | 管理员 |
| 2 | 用户 |

## 🔐 安全机制

- **JWT Token认证**：无状态身份验证，Token有效期2小时
- **角色权限控制**：管理员/普通用户路由隔离
- **密码加密**：BCrypt加密存储
- **请求拦截**：统一Token校验

## ⏰ 定时任务

| 任务 | 执行频率 | 功能 |
| :--- | :--- | :--- |
| AppointRecordJob | 每分钟 | 自动更新预约状态（逾期取消等） |
| IntegralMockJob | 每天 | 积分模拟数据（测试用） |

## 📧 API接口示例

### 用户认证

```bash
# 用户登录
POST /api/appUser/login
Content-Type: application/json

{
  "userName": "admin",
  "password": "123456"
}

# 发送验证码
POST /api/verification/sendCode
Content-Type: application/json

{
  "email": "example@163.com"
}
```

### 预约管理

```bash
# 创建预约
POST /api/appointRecord/add
Content-Type: application/json

{
  "roomId": 1,
  "seatId": 5,
  "beginTime": "2024-01-15 08:00:00",
  "endTime": "2024-01-15 12:00:00"
}
```

## 📝 使用说明

1. **注册登录**：用户通过邮箱注册，登录后获取Token
2. **浏览自习室**：查看自习室列表，点击进入详情
3. **选择座位**：在自习室详情页选择可用座位
4. **预约下单**：选择预约时间，确认下单
5. **签到使用**：到达后进行签到，开始使用
6. **完成评价**：使用结束后对服务进行评价

## 📄 许可证

MIT License

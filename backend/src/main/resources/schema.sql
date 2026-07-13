-- ============================================================
-- RoomMind 自习室预约系统 — 本地数据库初始化脚本
-- 说明：
--   1. 所有表名/字段名与 Entity 类的 @TableName 和 @TableField 保持一致
--   2. 使用 utf8mb4 字符集以支持中文和表情
--   3. 自带测试数据，便于本地开发调试
-- ============================================================

-- 删除旧数据库（可选）
-- DROP DATABASE IF EXISTS dev_roommind;

-- 创建数据库
CREATE DATABASE IF NOT EXISTS dev_roommind
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE dev_roommind;

-- ============================================================
-- 1. AppUser — 用户表（继承 BaseEntity: Id, CreationTime, CreatorId）
-- ============================================================
DROP TABLE IF EXISTS appuser;
CREATE TABLE appuser (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    UserName VARCHAR(100) NOT NULL COMMENT '登录账号',
    Password VARCHAR(200) NOT NULL COMMENT '密码(MD5)',
    Email VARCHAR(100) COMMENT '邮箱',
    ImageUrls VARCHAR(500) DEFAULT '' COMMENT '头像URL',
    Name VARCHAR(100) COMMENT '姓名',
    PhoneNumber VARCHAR(20) COMMENT '手机号',
    Birth DATETIME COMMENT '出生年月',
    RoleType INT DEFAULT 1 COMMENT '角色:1=普通用户, 2=管理员',
    OverdueTimes INT DEFAULT 0 COMMENT '逾期次数',
    CreationTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    CreatorId INT COMMENT '创建人ID',
    INDEX idx_username (UserName),
    INDEX idx_email (Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ============================================================
-- 2. room — 自习室表
-- ============================================================
DROP TABLE IF EXISTS room;
CREATE TABLE room (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '自习室ID',
    Name VARCHAR(200) NOT NULL COMMENT '名称',
    Cover VARCHAR(500) DEFAULT '' COMMENT '封面图片URL',
    Address VARCHAR(300) COMMENT '地址',
    Content TEXT COMMENT '介绍',
    EveryMonCancelCount INT DEFAULT 3 COMMENT '每月可取消次数',
    CreationTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    CreatorId INT,
    INDEX idx_name (Name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自习室表';

-- ============================================================
-- 3. seat — 座位表
-- ============================================================
DROP TABLE IF EXISTS seat;
CREATE TABLE seat (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '座位ID',
    No VARCHAR(50) COMMENT '座位编号（如A01）',
    SRow INT COMMENT '行',
    SCol INT COMMENT '列',
    IsMaintain TINYINT(1) DEFAULT 0 COMMENT '是否维修中 0=否,1=是',
    RoomId INT NOT NULL COMMENT '所属自习室ID',
    CreationTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    CreatorId INT,
    INDEX idx_room (RoomId),
    INDEX idx_maintain (IsMaintain)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='座位表';

-- ============================================================
-- 4. appointrecord — 预约记录表
-- ============================================================
DROP TABLE IF EXISTS appointrecord;
CREATE TABLE appointrecord (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '预约记录ID',
    RoomId INT NOT NULL COMMENT '自习室ID',
    SeatId INT NOT NULL COMMENT '座位ID',
    UserId INT NOT NULL COMMENT '预约人ID',
    No VARCHAR(100) COMMENT '流水编号',
    Phone VARCHAR(20) COMMENT '手机号',
    Name VARCHAR(100) COMMENT '姓名',
    AppointDateType INT DEFAULT 1 COMMENT '预约时间段范围类型',
    AppointDate DATETIME COMMENT '预约日期',
    BeginTime DATETIME COMMENT '起始时间',
    EndTime DATETIME COMMENT '截至时间',
    CommentScore DOUBLE DEFAULT 0 COMMENT '评分',
    SComment VARCHAR(1000) DEFAULT '' COMMENT '评论',
    AppointStatus INT DEFAULT 1 COMMENT '状态:1=已预约,2=已完成,3=已取消,4=逾期',
    CreationTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    CreatorId INT,
    INDEX idx_user (UserId),
    INDEX idx_room (RoomId),
    INDEX idx_seat (SeatId),
    INDEX idx_status (AppointStatus),
    INDEX idx_date (AppointDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预约记录表';

-- ============================================================
-- 5. integral — 积分表
-- ============================================================
DROP TABLE IF EXISTS integral;
CREATE TABLE integral (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '积分记录ID',
    Title VARCHAR(200) COMMENT '标题',
    UserId INT NOT NULL COMMENT '用户ID',
    IntegralValue INT DEFAULT 0 COMMENT '积分值(正=获得,负=扣除)',
    Source VARCHAR(100) COMMENT '来源(如"预约奖励","取消惩罚")',
    RelativeCode VARCHAR(200) COMMENT '关联号',
    CreationTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    CreatorId INT,
    INDEX idx_user (UserId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分表';

-- ============================================================
-- 6. banner — 封面/轮播图表
-- ============================================================
DROP TABLE IF EXISTS banner;
CREATE TABLE banner (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '封面ID',
    Cover VARCHAR(500) COMMENT '封面图片URL',
    Remark VARCHAR(300) COMMENT '备注',
    CreationTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    CreatorId INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='轮播图表';

-- ============================================================
-- 7. vaildcode — 验证码表
-- ============================================================
DROP TABLE IF EXISTS vaildcode;
CREATE TABLE vaildcode (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) COMMENT '邮箱',
    code VARCHAR(50) COMMENT '验证码',
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='验证码表';

-- ============================================================
-- ============ 测试数据 ============
-- ============================================================

-- ---------- 测试用户 ----------
-- 密码均为 "123456" 的MD5: e10adc3949ba59abbe56e057f20f883e
INSERT INTO appuser (UserName, Password, Email, Name, PhoneNumber, RoleType, ImageUrls) VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', 'admin@roommind.com', '系统管理员', '13800000000', 2, 'https://a0ai.marscode.cn/api/ide/v1/text_to_image?prompt=professional%20portrait%20businessman%20avatar&image_size=square'),
('user001', 'e10adc3949ba59abbe56e057f20f883e', 'user001@test.com', '张小明', '13800000001', 1, 'https://a0ai.marscode.cn/api/ide/v1/text_to_image?prompt=young%20chinese%20college%20student%20portrait&image_size=square'),
('user002', 'e10adc3949ba59abbe56e057f20f883e', 'user002@test.com', '李小红', '13800000002', 1, 'https://a0ai.marscode.cn/api/ide/v1/text_to_image?prompt=young%20chinese%20female%20college%20student%20portrait&image_size=square'),
('user003', 'e10adc3949ba59abbe56e057f20f883e', 'user003@test.com', '王大伟', '13800000003', 1, '');

-- ---------- 测试自习室 ----------
INSERT INTO room (Name, Cover, Address, Content, EveryMonCancelCount) VALUES
('阳光自习室',
 'https://a0ai.marscode.cn/api/ide/v1/text_to_image?prompt=bright%20study%20room%20with%20large%20windows%20sunlight%20clean%20desks%20modern%20library&image_size=landscape_16_9',
 '教学楼A座三楼东侧',
 '宽敞明亮的大型自习室，落地窗设计，阳光充足。内设独立书桌40张，配备充电插座、护眼台灯、饮水机。适合长时间集中学习。',
 3),
('静谧书房',
 'https://a0ai.marscode.cn/api/ide/v1/text_to_image?prompt=quiet%20study%20room%20warm%20yellow%20lighting%20wooden%20furniture%20cozy%20library%20interior&image_size=landscape_16_9',
 '图书馆B座二楼',
 '温馨小型自习室，暖黄色灯光设计，配备舒适座椅。适合阅读、写作业，禁止大声交谈。',
 5),
('深夜自习室',
 'https://a0ai.marscode.cn/api/ide/v1/text_to_image?prompt=modern%2024%20hour%20study%20room%20blue%20lighting%20night%20atmosphere%20clean%20desks&image_size=landscape_16_9',
 '学生活动中心地下一层',
 '24小时开放自习室，独立隔音隔间，配备空调。支持通宵学习，夜猫子学霸首选。',
 2),
('考研专区',
 'https://a0ai.marscode.cn/api/ide/v1/text_to_image?prompt=professional%20graduate%20exam%20study%20area%20organized%20desks%20inspirational%20chinese%20classroom&image_size=landscape_16_9',
 '教学楼C座五楼',
 '考研学生专属区域，固定座位制度，配备资料架、公告板。需凭考研报名信息申请。',
 3);

-- ---------- 测试座位（每个自习室 5x4 = 20个座位）----------
-- 自习室1(Id=1): 20个座位
INSERT INTO seat (No, SRow, SCol, IsMaintain, RoomId, CreatorId) VALUES
('A01',1,1,0,1,1),('A02',1,2,0,1,1),('A03',1,3,0,1,1),('A04',1,4,0,1,1),('A05',1,5,0,1,1),
('B01',2,1,0,1,1),('B02',2,2,0,1,1),('B03',2,3,0,1,1),('B04',2,4,0,1,1),('B05',2,5,0,1,1),
('C01',3,1,0,1,1),('C02',3,2,1,1,1),('C03',3,3,0,1,1),('C04',3,4,0,1,1),('C05',3,5,0,1,1),
('D01',4,1,0,1,1),('D02',4,2,0,1,1),('D03',4,3,0,1,1),('D04',4,4,0,1,1),('D05',4,5,0,1,1);

-- 自习室2(Id=2): 20个座位
INSERT INTO seat (No, SRow, SCol, IsMaintain, RoomId, CreatorId) VALUES
('A01',1,1,0,2,1),('A02',1,2,0,2,1),('A03',1,3,0,2,1),('A04',1,4,0,2,1),('A05',1,5,0,2,1),
('B01',2,1,0,2,1),('B02',2,2,0,2,1),('B03',2,3,0,2,1),('B04',2,4,0,2,1),('B05',2,5,0,2,1),
('C01',3,1,0,2,1),('C02',3,2,0,2,1),('C03',3,3,0,2,1),('C04',3,4,0,2,1),('C05',3,5,0,2,1),
('D01',4,1,0,2,1),('D02',4,2,0,2,1),('D03',4,3,0,2,1),('D04',4,4,0,2,1),('D05',4,5,0,2,1);

-- 自习室3(Id=3): 20个座位
INSERT INTO seat (No, SRow, SCol, IsMaintain, RoomId, CreatorId) VALUES
('A01',1,1,0,3,1),('A02',1,2,0,3,1),('A03',1,3,0,3,1),('A04',1,4,0,3,1),('A05',1,5,0,3,1),
('B01',2,1,0,3,1),('B02',2,2,0,3,1),('B03',2,3,0,3,1),('B04',2,4,0,3,1),('B05',2,5,0,3,1),
('C01',3,1,0,3,1),('C02',3,2,0,3,1),('C03',3,3,0,3,1),('C04',3,4,0,3,1),('C05',3,5,0,3,1),
('D01',4,1,0,3,1),('D02',4,2,0,3,1),('D03',4,3,0,3,1),('D04',4,4,0,3,1),('D05',4,5,0,3,1);

-- 自习室4(Id=4): 20个座位
INSERT INTO seat (No, SRow, SCol, IsMaintain, RoomId, CreatorId) VALUES
('A01',1,1,0,4,1),('A02',1,2,0,4,1),('A03',1,3,0,4,1),('A04',1,4,0,4,1),('A05',1,5,0,4,1),
('B01',2,1,0,4,1),('B02',2,2,0,4,1),('B03',2,3,0,4,1),('B04',2,4,0,4,1),('B05',2,5,0,4,1),
('C01',3,1,0,4,1),('C02',3,2,0,4,1),('C03',3,3,0,4,1),('C04',3,4,0,4,1),('C05',3,5,0,4,1),
('D01',4,1,0,4,1),('D02',4,2,0,4,1),('D03',4,3,0,4,1),('D04',4,4,0,4,1),('D05',4,5,0,4,1);

-- ---------- 测试积分 ----------
INSERT INTO integral (Title, UserId, IntegralValue, Source, RelativeCode, CreatorId) VALUES
('首次登录奖励', 2, 100, '新用户奖励', 'INIT_20240101', 1),
('首次登录奖励', 3, 100, '新用户奖励', 'INIT_20240102', 1),
('首次登录奖励', 4, 100, '新用户奖励', 'INIT_20240103', 1),
('预约完成奖励', 2, 10, '预约奖励', 'AP20240701001', 1),
('预约完成奖励', 2, 10, '预约奖励', 'AP20240702002', 1),
('预约完成奖励', 3, 10, '预约奖励', 'AP20240703003', 1),
('优秀评价奖励', 2, 5, '评价奖励', 'CM20240701', 1),
('取消预约扣分', 3, -20, '取消惩罚', 'AP20240630001', 1),
('连续学习7天', 4, 50, '成就奖励', 'ACH_STREAK_7', 1);

-- ---------- 测试预约记录 ----------
INSERT INTO appointrecord (RoomId, SeatId, UserId, No, Phone, Name, AppointDateType, AppointDate, BeginTime, EndTime, CommentScore, SComment, AppointStatus, CreatorId) VALUES
(1, 1, 2, 'AP2026071000001', '13800000001', '张小明', 1, '2026-07-10 00:00:00', '2026-07-10 08:00:00', '2026-07-10 12:00:00', 4.5, '环境很好，安静适合学习', 2, 2),
(1, 2, 2, 'AP2026071100001', '13800000001', '张小明', 1, '2026-07-11 00:00:00', '2026-07-11 14:00:00', '2026-07-11 18:00:00', 0, '', 1, 2),
(2, 6, 3, 'AP2026071000002', '13800000002', '李小红', 1, '2026-07-10 00:00:00', '2026-07-10 09:00:00', '2026-07-10 11:00:00', 5.0, '灯光很舒适，座位也很宽敞', 2, 3),
(3, 11, 4, 'AP2026070900001', '13800000003', '王大伟', 1, '2026-07-09 00:00:00', '2026-07-09 20:00:00', '2026-07-10 02:00:00', 0, '', 1, 4),
(1, 3, 2, 'AP2026071200001', '13800000001', '张小明', 1, '2026-07-12 00:00:00', '2026-07-12 08:00:00', '2026-07-12 12:00:00', 0, '', 1, 2),
(2, 7, 3, 'AP2026071200002', '13800000002', '李小红', 1, '2026-07-12 00:00:00', '2026-07-12 14:00:00', '2026-07-12 17:00:00', 0, '', 1, 3),
(4, 15, 4, 'AP2026071100002', '13800000003', '王大伟', 1, '2026-07-11 00:00:00', '2026-07-11 08:00:00', '2026-07-11 20:00:00', 0, '', 1, 4),
(1, 4, 2, 'AP2026062800001', '13800000001', '张小明', 1, '2026-06-28 00:00:00', '2026-06-28 08:00:00', '2026-06-28 12:00:00', 0, '', 3, 2),
(2, 5, 3, 'AP2026070500001', '13800000002', '李小红', 1, '2026-07-05 00:00:00', '2026-07-05 10:00:00', '2026-07-05 13:00:00', 4.0, '座位有点硬，但整体不错', 2, 3),
(3, 8, 4, 'AP2026070800001', '13800000003', '王大伟', 1, '2026-07-08 00:00:00', '2026-07-08 22:00:00', '2026-07-09 02:00:00', 0, '', 4, 4);

-- ---------- 测试轮播图 ----------
INSERT INTO banner (Cover, Remark, CreatorId) VALUES
('https://a0ai.marscode.cn/api/ide/v1/text_to_image?prompt=modern%20university%20study%20room%20exterior%20building%20banner&image_size=landscape_16_9', '欢迎使用志高自习室预约系统', 1),
('https://a0ai.marscode.cn/api/ide/v1/text_to_image?prompt=students%20studying%20together%20in%20bright%20library%20happy%20learning&image_size=landscape_16_9', '考研加油，一战成硕！', 1),
('https://a0ai.marscode.cn/api/ide/v1/text_to_image?prompt=24%20hour%20study%20center%20modern%20interior%20night%20ambient&image_size=landscape_16_9', '24小时深夜自习室开放中', 1);

-- ============================================================
-- ============ 数据初始化完成 ============
-- ============================================================

-- 查看表列表
SHOW TABLES;

-- 查看各表数据量
SELECT 'appuser' AS tbl, COUNT(*) AS cnt FROM appuser
UNION ALL SELECT 'room', COUNT(*) FROM room
UNION ALL SELECT 'seat', COUNT(*) FROM seat
UNION ALL SELECT 'appointrecord', COUNT(*) FROM appointrecord
UNION ALL SELECT 'integral', COUNT(*) FROM integral
UNION ALL SELECT 'banner', COUNT(*) FROM banner
UNION ALL SELECT 'vaildcode', COUNT(*) FROM vaildcode;

-- ============ 测试账号提示 ============
-- 管理员: admin / 123456
-- 普通用户: user001 / 123456 (张小明, Id=2, 积分 125)
-- 普通用户: user002 / 123456 (李小红, Id=3, 积分 90)
-- 普通用户: user003 / 123456 (王大伟, Id=4, 积分 150)
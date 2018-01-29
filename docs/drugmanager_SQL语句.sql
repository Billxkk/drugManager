----------创建数据库文件
create database drugmanager
on
(name = drugmanager,
filename = 'E:\code\GitCode\数据库课设\drugmanager.mdf',
size = 10,
maxsize = 60,
filegrowth = 5%
)
log on
(name = drugmanager_log,
filename = 'E:\code\GitCode\数据库课设\drugmanager.ldf',
size = 4,
maxsize = 10,
filegrowth = 1
);
go
---------------------------------

-------------创建基本表
use drugmanager
go
create table 员工
(员工ID char(6) primary key,
姓名 varchar(16) NOT NULL,
密码 varchar(16) NOT NULL,
电话 varchar(11) NOT NULL,
职位 varchar(16) NOT NULL,
领导ID char(6) FOREIGN KEY(领导ID) REFERENCES 员工(员工ID)
);
---------员工的职位名约束
alter table 员工
 add constraint 职位名控制 check(职位 in('管理员','药品整理员','售货员','进货员','退货员'));
 
create table 厂家
(厂商ID char(6) primary key,
厂名 varchar(30) NOT NULL,
地址 varchar(30) NOT NULL,
电话 varchar(11) NOT NULL
);
create table 进货单
(进货单ID varchar(11) primary key,
日期 date NOT NULL,
时间 time NOT NULL,
厂家ID char(6) NOT NULL FOREIGN KEY(厂家ID) REFERENCES 厂家(厂商ID),
进货员ID char(6) NOT NULL FOREIGN KEY(进货员ID) REFERENCES 员工(员工ID)
);
create table 客户
(客户ID char(6) primary key,
姓名 varchar(16) NOT NULL,
电话 varchar(11) NOT NULL
);
create table 售货单
(售货单ID varchar(11) primary key,
日期 date NOT NULL,
时间 time NOT NULL,
客户ID char(6) NOT NULL FOREIGN KEY(客户ID) REFERENCES 客户(客户ID),
售货员ID char(6) NOT NULL FOREIGN KEY(售货员ID) REFERENCES 员工(员工ID)
);
create table 种类
(ID char(6) primary key,
名称 varchar(10) NOT NULL,
父类ID char(6) FOREIGN KEY(父类ID) REFERENCES 种类(ID)
);
create table 药品
(药品ID char(6) primary key,
药名 varchar(30) NOT NULL,
种类ID char(6) NOT NULL FOREIGN KEY(种类ID) REFERENCES 种类(ID),
进价 real NOT NULL,
售价 real NOT NULL,
生产商ID char(6) NOT NULL FOREIGN KEY(生产商ID) REFERENCES 厂家(厂商ID)
);
create table 进货单详细表
(进货单ID varchar(11) FOREIGN KEY(进货单ID) REFERENCES 进货单(进货单ID),
药品ID char(6) FOREIGN KEY(药品ID) REFERENCES 药品(药品ID),
primary key(进货单ID,药品ID),
数量 int NOT NULL,
进价 real NOT NULL,
生产日期 date not null
);
create table 售货单详细表
(售货单ID varchar(11) FOREIGN KEY(售货单ID) REFERENCES 售货单(售货单ID),
药品ID char(6) FOREIGN KEY(药品ID) REFERENCES 药品(药品ID),
数量 int NOT NULL,
售价 real NOT NULL,
生产日期 date not null,
primary key(售货单ID,药品ID,生产日期),
);
create table 库存
(药品ID char(6) FOREIGN KEY(药品ID) REFERENCES 药品(药品ID),
生产日期 date NOT NULL,
primary key(药品ID,生产日期),
有效期至 date NOT NULL,
库存 int NOT NULL
);
create table 退厂
(药品ID char(6) FOREIGN KEY(药品ID) REFERENCES 药品(药品ID),
生产日期 date NOT NULL,
primary key(药品ID,生产日期),
有效期至 date NOT NULL,
库存 int NOT NULL
);
go
---------------------------------------------数据库用户 创建
use drugmanager
go
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'shujuku')
DROP LOGIN [shujuku]
GO
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'saler')
DROP LOGIN [saler]
GO
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'buyer')
DROP LOGIN [buyer]
GO
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'drugmanager')
DROP LOGIN [drugmanager]
GO
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'returngooder')
DROP LOGIN [returngooder]
GO
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'shujuku')
DROP USER [shujuku]
GO
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'saler')
DROP USER [saler]
GO
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'buyer')
DROP USER [buyer]
GO
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'drugmanager')
DROP USER [drugmanager]
GO
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'returngooder')
DROP USER [returngooder]
GO

create login shujuku with password='123456',default_database = drugmanager
create user shujuku for login shujuku with default_schema=dbo
GRANT SELECT TO shujuku
GRANT INSERT,UPDATE,DELETE ON 员工 TO shujuku
GRANT DELETE ON 库存 TO shujuku
GRANT INSERT ON 退厂 TO shujuku
go
create login drugmanager with password='drugmanager',default_database = drugmanager
create user drugmanager for login drugmanager with default_schema=dbo
GRANT SELECT ON 员工 TO drugmanager
GRANT SELECT,INSERT,UPDATE,DELETE ON 药品 TO drugmanager
GRANT SELECT,INSERT,UPDATE,DELETE ON 种类 TO drugmanager
go
create login saler with password='saler',default_database = drugmanager
create user saler for login saler with default_schema=dbo
GRANT SELECT ON 员工 TO saler
GRANT SELECT,INSERT,UPDATE,DELETE ON 客户 TO saler
GRANT INSERT ON 售货单 TO saler
GRANT INSERT ON 售货单详细表 TO saler
GRANT DELETE,UPDATE ON 库存 TO saler
go
create login buyer with password='buyer',default_database = drugmanager
create user buyer for login buyer with default_schema=dbo
GRANT SELECT ON 员工 TO buyer
GRANT SELECT,INSERT,UPDATE,DELETE ON 厂家 TO buyer
GRANT INSERT ON 进货单 TO buyer
GRANT INSERT ON 进货单详细表 TO buyer
GRANT INSERT,UPDATE ON 库存 TO buyer
go
create login returngooder with password='returngooder',default_database = drugmanager
create user returngooder for login returngooder with default_schema=dbo
GRANT SELECT ON 员工 TO returngooder
GRANT SELECT,DELETE ON 库存 TO returngooder
GRANT SELECT,INSERT,DELETE ON 退厂 TO returngooder
go
---------------------------------------

insert into 员工
values('000001','老板','123456',
   '1234567890','管理员',null);
insert into 员工
	values('000002','王凌','123456','1234567890',
			'药品整理员','000001');
insert into 员工
	values('000003','陈秋','123456','1234567890',
			'售货员','000001');
insert into 员工
	values('000004','李世明','123456','1234567890',
			'进货员','000001');
insert into 员工
	values('000005','刘莎','123456','1234567890',
			'退货员','000001');
go
---------------------------------------------

use drugmanager
go
---------------原始药品数据
CREATE TABLE ypxx (
  ID varchar(32) NOT NULL,
  BM varchar(32) NOT NULL                ,
  SCQYMC varchar(128) NOT NULL           ,
  SPMC varchar(64) NOT NULL              ,
  ZBJG float NOT NULL                    ,
  ZPDZ varchar(128) DEFAULT NULL         ,
  PZWH varchar(64) DEFAULT NULL          ,
  PZWHYXQ datetime DEFAULT NULL          ,
  JKY char(1) DEFAULT NULL               ,
  BZCZ varchar(64) DEFAULT NULL          ,
  BZDW varchar(64) DEFAULT NULL          ,
  LSJG float DEFAULT NULL                ,
  LSJGCC varchar(64) DEFAULT NULL        ,
  ZLCC varchar(32) DEFAULT NULL          ,
  ZLCCSM varchar(200) DEFAULT NULL       ,
  YPJYBG char(1) DEFAULT NULL            ,
  YPJYBGBM varchar(128) DEFAULT NULL     ,
  YPJYBGYXQ datetime DEFAULT NULL        ,
  CPSM text                              ,
  JYZT char(1) NOT NULL                  ,
  VCHAR1 varchar(128) DEFAULT NULL       ,
  VCHAR2 varchar(128) DEFAULT NULL       ,
  VCHAR3 varchar(128) DEFAULT NULL       ,
  DW varchar(32) DEFAULT NULL            ,
  MC varchar(128) DEFAULT NULL           ,
  JX varchar(32) DEFAULT NULL            ,
  GG varchar(128) DEFAULT NULL           ,
  ZHXS varchar(16) DEFAULT NULL          ,
  PINYIN varchar(768) DEFAULT NULL       ,
  LB varchar(32) DEFAULT NULL            ,
  PRIMARY KEY (ID)
);
go
INSERT INTO ypxx(id, bm, scqymc, spmc, zbjg, zpdz, pzwh, pzwhyxq, jky, bzcz, bzdw, lsjg, lsjgcc, zlcc, zlccsm, ypjybg, ypjybgbm,  ypjybgyxq,  cpsm,  jyzt,  vchar1,  vchar2,  vchar3,  dw,  mc,  jx,  gg,  zhxs,  pinyin,  lb)
VALUES ('4c7c18fa633748568c1f5aecb3d98e1b', '200176', '河南省百泉制药有限公司', '舒肝健胃丸', 22.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '袋', '舒肝健胃丸', '水丸', '12g', '40', 'sgjww', NULL),
  ('4cc4e8160f7641f88a25ef3cd29a2caf', '200177', '商丘市金马药业有限公司', '知柏地黄丸', 3.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '知柏地黄丸', '水蜜丸', '60g', '1', 'zbdhw', NULL),
  ('4dc12e14a6944559b6b592d0efbe0f8b', '200178', '四川志远嘉宝药业有限责任公司', '明目上清片', 9.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '明目上清片', '片剂', '0.64g', '60', 'mmsqp', NULL),
  ('4dd7e4b6faa84d9da58c787346048437', '200179', '河南天地药业股份有限公司', '醒脑静注射液', 30.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '醒脑静注射液', '注射液', '10ml', '1', 'xnjzyy,xnjzsy', NULL),
  ('4eb16cf5d09f42f78a6899bf270b04cd', '200180', '广东恒诚制药有限公司', '结石通片', 4.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '结石通片', '片剂', '干浸膏0.25g', '100', 'jdtp,jstp', NULL),
  ('4f00404998f844fd91f72cf4fedd520c', '200181', '杭州中美华东制药有限公司', '卡博平', 45.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿卡波糖片', '片剂', '50mg', '30', 'eqbtp,ekbtp,akbtp,aqptp,akptp,ekptp,aqbtp,eqptp', NULL),
  ('4fd91a66a78b4a7f9dd20d3f566bf5a6', '200182', '山西华康药业股份有限公司', '壮腰健肾丸', 4.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '壮腰健肾丸', '大蜜丸', '5.6g', '10', 'zyjsw', NULL),
  ('4fe5a49a5a30468c9a42415caf1f5bb1', '200183', '广东强基药业有限公司', '长建宁', 29.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '柳氮磺吡啶', '肠溶胶囊', '0.25g', '24', 'ldhpd,ldhbd', NULL),
  ('4fe9076d6fbd4651b1b9185da2339e03', '200184', '河南润弘制药股份有限公司', '无', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '甲氧氯普胺', '注射液', '1ml:10mg', '1', 'jylpa', NULL),
  ('4ff078a50c5e4b498e90243a4e71d4fd', '200185', '上海衡山药业有限公司', '非诺贝特', 4.93, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '非诺贝特', '片剂', '0.1g', '100', 'fnbt', NULL),
  ('50b7d506a40a41fe8c2bb3e2cd1ae1fc', '200186', '四川禾润制药有限公司', '复方黄连素片', 2.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '复方黄连素片', '片剂', '30mg', '100', 'ffhlsp', NULL),
  ('5155f8d1753a49d58fea8e9d208f7d23', '200187', '河南华峰制药有限公司', '麻仁润肠丸', 8.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '麻仁润肠丸', '水蜜丸', '3.2g（1.6g/10）', '12', 'mrrcw', NULL),
  ('51a68eb4f40d46a8b661d0ab9ec18a51', '200188', '上海现代哈森(商丘)药业有限公司', '二羟丙茶碱注射液', 0.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '二羟丙茶碱', '注射液', '2ml:0.25g', '1', 'eqbcj', NULL),
  ('528bbec5eae34b25a228e606995fcc9b', '200189', '成都天银制药有限公司', '银杏蜜环口服溶液', 25.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银杏蜜环口服溶液', '口服液', '10ml', '10', 'yxmhkfry', NULL),
  ('538ba7f2cff04dd0811ccabf9db9d8f3', '200190', '河南灵佑药业有限公司', '清热解毒口服液', 9.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '清热解毒口服液', '口服液', '10ml(无糖型)', '10', 'qrxdkfy,qrjdkfy', NULL),
  ('53f7e251f3f5480ba88b505a8ea1f31c', '200191', '上海旭东海普药业有限公司', '无', 1.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '谷氨酸钾', '注射液', '20ml:6.3g', '1', 'yasj,gasj', NULL),
  ('5405995fbba44f14a7e052b8bba32a58', '200192', '宜昌人福药业有限责任公司', '辛伐他汀胶囊', 12.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '辛伐他汀', '胶囊', '10mg', '24', 'xftt', NULL),
  ('5410a6c1fb0e4caf9e0fac8e79b737cc', '200193', '天士力制药集团股份有限公司', '柴胡滴丸', 12.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '柴胡滴丸', '滴丸', '0.551g', '10', 'chdw', NULL),
  ('545cc7658f394f968f165a38a1667d37', '200194', '武汉中联药业集团股份有限公司', '乌鸡白凤丸', 4.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '乌鸡白凤丸', '大蜜丸', '9g', '10', 'wjbfw', NULL),
  ('5478c41194f04e75bb4c671d0f6e1bf3', '200195', '湖南科伦制药有限公司', '头孢拉定', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢拉定', '粉针', '1.0g', '1', 'tbld', NULL),
  ('55340070b44f49f7b1c789ec048d3cf2', '200196', '上海朝晖药业有限公司', '盐酸布比卡因注射液', 0.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '布比卡因', '注射液', '5ml:37.5mg', '1', 'bbqy,bbky', NULL),
  ('55890b034e234712b159dfacc34b40cc', '200197', '河北天成药业股份有限公司', '氯化钠注射液', 0.14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '0.9%氯化钠', '注射液', '10ml', '1', '0.9%lhn', NULL),
  ('55c08af7724746e6896330d3999afacb', '200198', '辰欣药业股份有限公司', '马来噻吗洛尔滴眼液', 1.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '噻吗洛尔', '滴眼液', '5ml:25mg', '1', 'smle', NULL),
  ('563723fdae09473ea241337f80e14192', '200199', '江苏恒瑞医药股份有限公司', '吉浩', 7.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '布洛芬', '混悬液', '100ml:2.0g', '1', 'blf', NULL),
  ('57d15cbc5ee048288ef0782875b89612', '200200', '沈阳永大制药有限公司', '益母草胶囊', 21.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '益母草胶囊', '胶囊', '0.35g', '36', 'ymcjn', NULL),
  ('5883b0de354c4873bdb601cb5d8a1eea', '200201', '河南康祺药业股份有限公司', '藿香正气片', 4.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '藿香正气片', '片剂', '0.3g', '36', 'hxzqp', NULL),
  ('86b883c9b69545bd8b6c79bd90515896', '200202', '浙江仙琚制药股份有限公司', '醋酸泼尼松片', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '醋酸泼尼松片', '片剂', '5mg', '100', 'cspnsp', NULL),
  ('86b962408f8840f6a05a58aac720b8b2', '200203', '上海医疗器械(集团)有限公司卫生材料厂', '关节止痛膏', 0.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '袋', '关节止痛膏', '橡胶膏剂', '7cm*10cm', '2', 'gjztg', NULL),
  ('86f8f0650fcd4eaf9ca8ed931e5013be', '200204', '芜湖张恒春药业有限公司', '香砂养胃丸', 2.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '香砂养胃丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'xsyww', NULL),
  ('8716ba5a0c4e447c9859cdaa220ef49f', '200205', '石家庄以岭药业股份有限公司', '连花清瘟胶囊', 11.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '连花清瘟胶囊', '胶囊', '0.35g', '24', 'lhqwjn', NULL),
  ('04f12f0e8de34d0ab6fe104a28eea0e9', '200206', '河北天成药业股份有限公司', '碳酸氢钠注射液', 0.14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '碳酸氢钠', '注射液', '10ml:0.5g', '1', 'tsqn', NULL),
  ('052bd08468054a508945edc0663ef907', '200207', '天津力生制药股份有限公司', '维生素B4', 3.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '维生素B4', '片剂', '10mg', '100', 'wssb4', NULL),
  ('05c4a8928cfa4cd3b27f250a563f7159', '200208', '浙江泰利森药业有限公司', '纳欣同', 26.17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '硝苯地平', '缓释片', '20mg', '60', 'xbdp', NULL),
  ('067bd0c00aa34e8e860a2842f46865a3', '200209', '悦康药业集团北京凯悦制药有限公司', '阿昔洛韦', 0.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '阿昔洛韦', '软膏剂', '10g:0.3g', '1', 'axlw,exlw', NULL),
  ('070d3f60e1964ef98cefadf3f9519525', '200210', '西安安健药业有限公司', '无', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '口服补液盐Ⅲ', '散剂', '5.125g', '6', 'kfbyyⅲ', NULL),
  ('07269f7292594b419ff703da7df3bb4c', '200211', '辽宁好护士药业(集团)有限责任公司', '尪痹片', 35.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '尪痹片', '片剂', '0.5g', '48', 'wbp', NULL),
  ('0740a64ebb9a4c88b9fc8e00d0536a1c', '200212', '湖北东信药业有限公司', '甲硝唑栓', 2.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '甲硝唑', '栓剂', '0.5g', '10', 'jxz', NULL),
  ('086ea1e0ca6e4b22a8d49b1118fcf33b', '200213', '西南药业股份有限公司', '阿莫西林分散片', 1.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿莫西林', '分散片', '0.125g', '12', 'amxl,emxl', NULL),
  ('0893333f6d6d471a96f18979267cc8fa', '200214', '吉林省集安益盛药业股份有限公司', '心脑康胶囊', 4.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '心脑康胶囊', '胶囊', '0.25g', '36', 'xnkjn', NULL),
  ('08fbc75ee63f40718770b4ca671ad75a', '200215', '江西汇仁药业有限公司', '邦能', 9.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '多潘立酮', '分散片', '10mg', '30', 'dplt', NULL),
  ('0947a91fc1c04c6fbd70c20a1c9b6b3f', '200216', '开封制药', '甘草片', 8.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '甘草片', '片剂', '复方', '100', 'gcp', NULL),
  ('09ef367a3eb14edeadbecfbd13d2f718', '200217', '桂林华信制药有限公司', '缬沙坦分散片', 24.32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '缬沙坦', '分散片', '80mg', '14', 'xst', NULL),
  ('09faeb5d29ee4b10adf42a6b6a433272', '200218', '安徽宏业药业有限公司', '干酵母', 0.37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '干酵母', '片剂', '0.2g', '100', 'gjm,gxm', NULL),
  ('0abf9139cd7942e09655a707b83a8237', '200219', '河南科伦药业有限公司', '5%葡萄糖', 1.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '5%葡萄糖', '大输液', '500ml(塑瓶)', '1', '5%ptt', NULL),
  ('2a4377b7d5c445ecb631cdc9dd09754b', '200000', '江苏恒瑞医药股份有限公司', '诺邦', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '克拉霉素', '片剂', '50mg', '12', 'klms', NULL),
  ('2a791556623a49009c6007577d2f5017', '200001', '济南利民制药有限责任公司', '更昔洛韦', 7.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '更昔洛韦', '注射液', '5ml:0.25g', '1', 'gxlw', NULL),
  ('2ab1bb4f45414bda8f7b25567ad481ab', '200002', '江西天之海药业股份有限公司', '西咪替丁', 1.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '西咪替丁', '片剂', '0.4g', '20', 'xmtd,xmtz', NULL),
  ('2b450e8cfbf64827854d02fcfb368b67', '200003', '石药集团中诺药业(石家庄)有限公司', '阿林新', 2.01, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿莫西林', '分散片', '0.25g', '18', 'amxl,emxl', NULL),
  ('2bd18719b0414fb9b4876f60115f760c', '200004', '湖南汉森制药股份有限公司', '四磨汤口服液', 20.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '四磨汤口服液', '口服液', '10ml', '10', 'smskfy,smtkfy', NULL),
  ('2d3f324e78c94600b169577089021f0b', '200005', '山西普德药业股份有限公司', '欣美佳', 14.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '门冬氨酸钾镁', '粉针', '2.0g(门冬氨酸钾1g,门冬氨酸镁1g)', '1', 'mdasjm', NULL),
  ('2e6fed61710d499cba435a4052fd412e', '200006', '浙江众益制药股份有限公司', '红霉素肠溶胶囊', 19.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '红霉素', '肠溶胶囊', '0.25g', '10', 'hms,gms', NULL),
  ('2f02a7e6ef794db5bc9f4fcecc6e25e1', '200007', '成都天银制药有限公司', '银杏蜜环口服溶液', 29.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银杏蜜环口服溶液', '口服液', '10ml', '12', 'yxmhkfry', NULL),
  ('2f7dd370f1cc4c729d12f1be97b9b48c', '200008', '江西药都樟树制药有限公司', '乌鸡白凤丸', 4.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '乌鸡白凤丸', '水蜜丸', '6g', '10', 'wjbfw', NULL),
  ('2f8c128759e54901946571dbae9a80e9', '200009', '四川奥邦药业有限公司', '?', 26.31, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '琥珀酸亚铁', '片剂', '0.1g', '24', 'hpsyt', NULL),
  ('2fb4df2e8c0f4795bc03970e1485781d', '200010', '晋城海斯制药有限公司', '海斯必妥', 1.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '曲克芦丁', '粉针', '0.3g', '1', 'qklz,qkld', NULL),
  ('2fc8d7c2125c4d749bbd9d5d84e66148', '200011', '山西康威制药有限责任公司', '冰硼散', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '冰硼散', '散剂', '3g', '10', 'bps', NULL),
  ('306c515a9727452cb2063d96580a734b', '200012', '湖南恒生制药股份有限公司', '注射用灯盏花素', 11.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '灯盏花素', '粉针', '10mg', '1', 'dzhs', NULL),
  ('30be911509954fcbb3c863c3bca7474a', '200013', '广东南国药业有限公司', '盐酸左旋咪唑片', 8.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '左旋咪唑', '片剂', '25mg', '1000', 'zxmz', NULL),
  ('311276aefc7a406ebc158d9d8679acda', '200014', '天津中新药业集团股份有限公司新新制药厂', '速效救心丸', 25.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '速效救心丸', '滴丸', '40mg', '150', 'sxjxw', NULL),
  ('31fde24225da47bdb21008ff728350da', '200015', '西安天一秦昆制药有限责任公司', '银翘解毒颗粒', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银翘解毒颗粒', '颗粒剂', '5g（无糖型）', '20', 'yqxdkl,yqjdkl', NULL),
  ('334ea3ebcc8f4372a7b95cb58fa9be00', '200016', '国药集团工业有限公司', '奥美拉唑', 1.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '奥美拉唑', '肠溶片', '20mg', '14', 'amlz', NULL),
  ('3365db167fee44a4b115d9e201891570', '200017', '山西正元盛邦制药有限公司', '明目地黄丸', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '明目地黄丸', '水蜜丸', '36g', '1', 'mmdhw', NULL),
  ('3440c68ab3264e5c9c13557a86ecf4a9', '200018', '河南同源制药有限公司', '维生素B6', 0.06, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维生素B6', '注射液', '1ml:50mg', '1', 'wssb6', NULL),
  ('354c5cd20e9a437898823bd04b817cb6', '200019', '上海新亚药业有限公司', '锋克林', 3.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '阿莫西林/克拉维酸钾', '粉针', '1.2g(5:1)', '1', 'emxl/klwsj,amxl/klwsj', NULL),
  ('35a458a2148247a993d7ca880598ae59', '200020', '药都制药集团股份有限公司', '艾附暖宫丸', 3.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '艾附暖宫丸', '小蜜丸', '54g(9g/45粒)', '1', 'yfngw,afngw', NULL),
  ('3630c3269ebe48d89a8ef15ba107cf30', '200021', '江苏润邦药业有限公司', '邦利甘欣', 23.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '甘草酸二铵', '胶囊', '50mg', '48', 'gcsea', NULL),
  ('364ce09e41044380aae60fd591fe993a', '200022', '亚宝药业大同制药有限公司', '开胸顺气丸', 4.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '开胸顺气丸', '水丸', '9g', '10', 'kxsqw', NULL),
  ('36e2aaf5b9074dc99c6bc991a0dd2654', '200023', '广州白云山奇星药业有限公司', '华佗再造丸', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '华佗再造丸', '浓缩丸', '8g', '12', 'htzzw', NULL),
  ('37307c92f7fc417284ce8eb6df19d826', '200024', '河北神威药业有限公司', '参麦注射液', 4.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '参麦注射液', '注射液', '10ml', '1', 'smzyy,cmzsy,cmzyy,smzsy', NULL),
  ('3755766c9e6344ccae64d8fe50a5ac43', '200025', '葛兰素史克制药(苏州)有限公司', '万托林', 19.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '沙丁胺醇', '气雾剂', '100ug/揿*200', '1', 'sdac,szac', NULL),
  ('38b221c483534248b8cd24fd3d56ead8', '200026', '云南白药集团股份有限公司', '香砂养胃片', 18.84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '香砂养胃片', '片剂', '0.6g', '48', 'xsywp', NULL),
  ('39092830a8fd458b8f80ea848dc62182', '200027', '重庆巨琪诺美制药有限公司', '天王补心片', 21.67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '天王补心片', '片剂', '0.5g', '24', 'twbxp', NULL),
  ('3951fdebc9bc4a779ae48c6e25bdd1ae', '200028', '大连美罗中药厂有限公司', '无', 3.13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银杏叶片', '片剂', '总黄酮醇苷19.2mg:萜类内酯4.8mg', '24', 'yxyp,yxxp', NULL),
  ('39986696637e4af3a03c43739148978c', '200029', '北京市永康药业有限公司', '尼可刹米注射液', 4.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '尼可刹米注射液', '注射液', '1.5ml：0.375g', '10', 'nksmzyy,nkcmzyy,nkcmzsy,nksmzsy', NULL),
  ('39b8a6c407ca435b92126f3d0e3f76ce', '200030', '广东嘉博制药有限公司', '丙泊酚注射液', 15.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '丙泊酚', '注射液', '10ml:0.1g', '1', 'bpf,bbf', NULL),
  ('39cce3f440f5411aa1fb4086d0f0c484', '200031', '山东润泽制药有限公司', '头孢他啶', 4.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢他啶', '粉针', '2.0g', '10', 'tbtd', NULL),
  ('39f99968ea90499694b415695e54d603', '200032', '黄石飞云制药有限公司', '抗病毒口服液', 3.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '抗病毒口服液', '口服液', '10ml', '10', 'kbdkfy', NULL),
  ('3a2b79ab0d8248aab2ecc22f5fddb82c', '200033', '山东沃华医药科技股份有限公司', '防风通圣丸', 2.71, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '防风通圣丸', '水丸', '6g', '10', 'fftsw', NULL),
  ('3a338f1c9107406ba11ae7d00ea3e10f', '200034', '天士力制药集团股份有限公司', '复方丹参滴丸', 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '复方丹参滴丸', '滴丸', '薄膜衣丸27mg', '180', 'ffdcdw,ffdsdw', NULL),
  ('3a43452e6ece49c5a810078bb279b981', '200035', '四川科伦药业股份有限公司', '葡萄糖注射液', 2.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '葡萄糖注射液', '大输液', '250ml:12.5g(塑瓶)', '1', 'pttzyy,pttzsy', NULL),
  ('3a4df240c5e442a1b0ad6124e2cbabe7', '200036', '哈尔滨儿童制药厂有限公司', '?', 20.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '小儿泻速停颗粒', '胶囊', '3g', '12', 'xexstkl,xrxstkl', NULL),
  ('3ac517d3567645fdb61cf7179d5d897b', '200037', '石药集团中诺药业(石家庄)有限公司', '青霉素钠', 0.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '青霉素钠', '粉针', '80WU', '1', 'qmsn', NULL),
  ('3af39529587f40edb6fcd18741a0deaa', '200038', '江苏万邦生化医药股份有限公司', '精蛋白锌胰岛素(30%)', 24.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '精蛋白锌胰岛素(30%)', '注射液', '10ml:400IU', '1', 'jdbxyds(30%)', NULL),
  ('3c5195a7c72c41698eab1cb08ce912ad', '200039', '河南太龙药业股份有限公司', '10%葡萄糖', 0.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '10%葡萄糖', '大输液', '100ml', '1', '10%ptt', NULL),
  ('3c80158a806240b3906ba9013b50e104', '200040', '成都第一制药有限公司', '益母草片', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '益母草片', '片剂', '盐酸水苏碱15mg', '48', 'ymcp', NULL),
  ('3cfe38d6289442d8af1f852854a9740d', '200041', '武汉东信医药科技有限责任公司', '阿苯达唑胶囊', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿苯达唑', '胶囊', '0.1g', '10', 'ebdz,abdz', NULL),
  ('3d3be6567abb43528c260414b6f1d5d9', '200042', '辅仁药业集团有限公司', '头孢曲松', 0.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢曲松', '粉针', '0.5g', '1', 'tbqs', NULL),
  ('3d7aba3db5a0466f8af4bbcca85e3624', '200043', '南京易亨制药有限公司', '双氯芬酸钠', 10.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '双氯芬酸钠', '缓释胶囊', '50mg', '24', 'slfsn', NULL),
  ('3da5c436a3ae40b88e83ff57882f8cc4', '200044', '四川升和药业股份有限公司', '丹参注射液', 0.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '丹参注射液', '注射液', '10ml', '1', 'dszyy,dszsy,dczyy,dczsy', NULL),
  ('3da9d295ec9e4bed8f34fd9a72429db2', '200045', '林州市亚神制药有限公司', '硫酸镁注射液', 0.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '硫酸镁', '注射液', '10ml:1.0g', '1', 'lsm', NULL),
  ('3ddf40fc4ec74a78b393053778559d66', '200046', '西南药业股份有限公司', '布洛芬', 7.37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '布洛芬', '缓释片', '0.3g', '20', 'blf', NULL),
  ('3eb9a718d5d64648856bf5e88fb34dee', '200047', '山东方健制药有限公司', '无', 5.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '参苓白术丸', '水丸', '6g', '10', 'clbsw,slbzw,slbsw,clbzw', NULL),
  ('3eba64e22c4c45368c20f6f571d1c735', '200048', '山东罗欣药业股份有限公司', '左氧氟沙星', 0.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '左氧氟沙星', '片剂', '0.2g', '6', 'zyfsx', NULL),
  ('3eca844c938f46c3a6d964b0313bc0e0', '200049', '昆明制药集团股份有限公司', '灯盏花素片', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '灯盏花素片', '片剂', '20mg', '24', 'dzhsp', NULL),
  ('3efa55d8d02749ac9b1a11bcec873075', '200050', '济南利民制药有限责任公司', '左氧氟沙星', 0.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '左氧氟沙星', '注射液', '2ml:0.2g', '1', 'zyfsx', NULL),
  ('3f83f745436344d6aeeeccf63eaaafb5', '200051', '鲁南厚普制药有限公司', '小儿消积止咳口服液', 13.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '小儿消积止咳口服液', '口服液', '10ml', '6', 'xexjzkkfy,xrxjzhkfy,xrxjzkkfy,xexjzhkfy', NULL),
  ('3fc18b2cf9814612b156f0d4a752591f', '200052', '吉林省利华制药有限公司', '头孢拉定', 4.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '头孢拉定', '片剂', '0.5g', '12', 'tbld', NULL),
  ('400f4a7b425d44caa6a23a00cc16acd8', '200053', '苏州东瑞制药有限公司', '安内真', 7.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氨氯地平', '片剂', '2.5mg', '14', 'aldp', NULL),
  ('401ecbb3c34a4b98924ddb9b59633900', '200054', '马应龙药业集团股份有限公司', '吲哚美辛栓', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '吲哚美辛', '栓剂', '50mg', '10', 'ydmx', NULL),
  ('401fba424c2142a48a4dfaccbaf504e0', '200055', '华北制药河北华民药业有限责任公司', '头孢氨苄', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢氨苄', '胶囊', '0.125g', '50', 'tbab', NULL),
  ('40c192ba97bd4aa39e206db91f5983b4', '200056', '河南科伦药业有限公司', '0.9%氯化钠', 1.43, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '0.9%氯化钠', '大输液', '500ml(塑瓶)', '1', '0.9%lhn', NULL),
  ('411fc7dbf44347278234f904f8d7d106', '200057', '河南禹州市药王制药有限公司', '牛黄解毒丸', 2.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '牛黄解毒丸', '大蜜丸', '3g', '10', 'nhjdw,nhxdw', NULL),
  ('412a9d0dd4314ad6b4f04fb9eaca115f', '200058', '四川绿叶宝光药业股份有限公司', '贝希', 43.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿卡波糖', '胶囊', '50mg', '30', 'eqpt,ekpt,akbt,aqpt,aqbt,akpt,eqbt,ekbt', NULL),
  ('4167c66a12da4e17a86357bf3c69184d', '200059', '天津药业集团新郑股份有限公司', '无', 0.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '安乃近', '注射液', '2ml:0.5g', '1', 'anj', NULL),
  ('41fd72d98ae44db88204d167c845a727', '200060', '天津金耀氨基酸有限公司', '无', 0.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '利血平', '注射液', '1ml:1mg', '1', 'lxp', NULL),
  ('42a044c781044853835132e422e40194', '200061', '马应龙药业集团股份有限公司', '马应龙麝香痔疮膏', 7.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '马应龙麝香痔疮膏', '软膏剂', '10g', '1', 'mylsxzcg', NULL),
  ('432c55d4eb9f4e62ae434f0f4af70e33', '200062', '上海禾丰制药有限公司', '维拉帕米', 0.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维拉帕米', '注射液', '2ml:5mg', '1', 'wlpm', NULL),
  ('434d9c3770a4487bbadc22bdc7897eae', '200063', '海南普利制药有限公司', '茶碱缓释胶囊', 7.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '茶碱', '缓释胶囊', '0.1g', '24', 'cj', NULL),
  ('434f3f2847a94071b523456c112fd9f2', '200064', '瑞阳制药有限公司', '常欣', 1.91, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '茶碱', '缓释片', '0.1g', '15', 'cj', NULL),
  ('4389e4c2dced49b693fac4b167dee705', '200065', '广东嘉应制药股份有限公司', '壮腰健肾丸', 4.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '壮腰健肾丸', '水蜜丸', '52g', '1', 'zyjsw', NULL),
  ('4397034547364824be180365f80d25ec', '200066', '石药集团中诺药业(石家庄)有限公司', '青霉素钠', 0.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '青霉素钠', '粉针', '160WU', '1', 'qmsn', NULL),
  ('43cd9ed91c0a42598e44339363231376', '200067', '新乡华青药业有限公司', '无', 0.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '克霉唑', '软膏剂', '10g:0.1g(1%)', '1', 'kmz', NULL),
  ('43e94694392e49c08fe279a9e08d03df', '200068', '山东罗欣药业股份有限公司', '克林霉素', 1.42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '克林霉素', '粉针', '0.3g', '1', 'klms', NULL),
  ('43e9eb51cca64525ab6a79c02c16cfd5', '200069', '北京同仁堂科技发展股份有限公司制药厂', '麻仁润肠软胶囊', 9.84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '麻仁润肠软胶囊', '软胶囊', '0.5g', '24', 'mrrcrjn', NULL),
  ('442f97869f014291968b6d7679ad71d3', '200070', '安徽华佗国药厂', '跌打丸', 5.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '跌打丸', '小蜜丸', '3g/15', '150', 'ddw', NULL),
  ('445304889ec440ad85d314dcfcb328ea', '200071', '珠海联邦制药股份有限公司', '优思灵USLIN50R', 42.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '精蛋白重组人胰岛素混合(50/50)', '注射液', '3ml:300IU(笔芯)', '1', 'jdbzzrydshg(50/50),jdbczrydshg(50/50),jdbczrydshh(50/50),jdbzzrydshh(50/50)', NULL),
  ('447dddd0ae7e4fc3944d9870b59eec60', '200072', '华中药业股份有限公司', '阿苯达唑', 0.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿苯达唑', '片剂', '0.2g', '10', 'ebdz,abdz', NULL),
  ('44b737323b54483988c30f8c34173c8c', '200073', '北京四环制药有限公司', '欣浦澳', 12.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '纳洛酮', '粉针', '2mg', '1', 'nlt', NULL),
  ('44e4018dc2464a9f83829f3b6225ef08', '200074', '辅仁药业集团有限公司', '喷托维林', 1.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '喷托维林', '片剂', '25mg', '100', 'ptwl', NULL),
  ('455d7b92bb2b4b2a8f50f290bcf9f437', '200075', '浙江京新药业股份有限公司', '格列齐特', 6.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '格列齐特', '片剂', '80mg', '60', 'gljt,glqt', NULL),
  ('4593738f01e140f189203f4422845ef7', '200076', '天津太平洋制药有限公司', '氟轻松', 1.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氟轻松', '软膏剂', '10g:2.5mg', '1', 'fqs', NULL),
  ('45eb3e66ead34217bfc6100eb7e2f577', '200077', '齐鲁制药有限公司', '注射用哌拉西林钠', 0.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '哌拉西林', '粉针', '1.0g', '1', 'plxl', NULL),
  ('462b9884a37e4c0980dbda4b48bfd15f', '200078', '齐鲁制药有限公司', '华法林钠片', 15.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '华法林钠', '片剂', '2.5mg', '80', 'hfln', NULL),
  ('462fadc149b64f848da8b7db93897d5f', '200079', '黑龙江珍宝岛药业股份有限公司', '血塞通注射液', 3.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '血塞通注射液', '注射液', '10ml:0.25g', '1', 'xstzyy,xstzsy', NULL),
  ('46bc312d96cf4d44a0b8a8c4786cd1d8', '200080', '河南省宛西制药股份有限公司', '小柴胡汤丸', 9.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '小柴胡汤丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'xchtw,xchsw', NULL),
  ('46bd8e20ae0b4112be54b383bfedf510', '200081', '华北制药股份有限公司', '阿莫西林胶囊', 1.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿莫西林', '胶囊', '0.5g', '10', 'amxl,emxl', NULL),
  ('47445a4aefb34820a04b75e3f2002727', '200082', '山东罗欣药业股份有限公司', '左氧氟沙星', 0.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '左氧氟沙星', '片剂', '0.1g', '6', 'zyfsx', NULL),
  ('48e841ef7cff4168a0e88946efd7495d', '200083', '天津药业集团新郑股份有限公司', '无', 1.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氟康唑', '片剂', '50mg', '3', 'fkz', NULL),
  ('002fe86ad6d44d209a34b802bca46d34', '200084', '山东罗欣药业股份有限公司', '左氧氟沙星', 0.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '左氧氟沙星', '片剂', '0.1g', '10', 'zyfsx', NULL),
  ('0035e28a704c414ea0d957739a1c998d', '200085', '北京利祥制药有限公司', '?', 6.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '水溶性维生素', '粉针', '/', '1', 'srxwss', NULL),
  ('005aacc7a5a24b1087da0d76ff7146e5', '200086', '河南省宛西制药股份有限公司', '复方丹参丸', 13.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '复方丹参丸', '水丸', '0.2g', '120', 'ffdsw,ffdcw', NULL),
  ('0072e55c308c41d2b4a39960ac98d45b', '200087', '江苏润邦药业有限公司', '邦利甘欣', 17.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '甘草酸二铵', '胶囊', '50mg', '36', 'gcsea', NULL),
  ('007698f6ac20453fba40266261718a96', '200088', '江西药都樟树制药有限公司', '六味地黄丸', 3.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '六味地黄丸', '水蜜丸', '6g', '10', 'lwdhw', NULL),
  ('0091756e0a4b4029ab0031a4e7a58a3c', '200089', '贵州圣济堂制药有限公司', '盐酸二甲双胍肠溶片', 6.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '二甲双胍', '肠溶片', '0.5g', '30', 'ejsg', NULL),
  ('01628775298146cb848e5f1fc69c66a8', '200090', '浙江康恩贝制药股份有限公司', '盐酸氨溴索注射液', 3.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氨溴索', '注射液', '2ml:15mg', '1', 'axs', NULL),
  ('0227319a4140473e844219275ce806b7', '200091', '海口奇力制药股份有限公司', '阿奇霉素分散片', 1.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿奇霉素', '分散片', '0.125g', '6', 'ajms,ejms,aqms,eqms', NULL),
  ('0230f23805f348ef81a6deb6a7880fcb', '200092', '黑龙江珍宝岛药业股份有限公司', '血塞通', 23.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '血塞通', '粉针', '0.2g', '1', 'xst', NULL),
  ('02a84b6e2c4e40c484ff76d1bc186570', '200093', '北京星昊医药股份有限公司', '甲钴胺胶囊', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '甲钴胺', '胶囊', '0.5mg', '24', 'jga', NULL),
  ('0314d7c46595495ab38b736286fb9423', '200094', '海南中宝制药股份有限公司', '对乙酰氨基酚', 1.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '对乙酰氨基酚', '胶囊', '0.3g', '20', 'dyxajf', NULL),
  ('032aaa036c3542798eb0049a96309def', '200095', '天津市中央药业有限公司', '无', 4.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '冠心苏合软胶囊', '软胶囊', '0.31g', '20', 'gxsgrjn,gxshrjn', NULL),
  ('034db1a65659488d89fd3ddebaa2e435', '200096', '上海现代哈森(商丘)药业有限公司', '甘草酸二铵注射液', 0.67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '甘草酸二铵', '注射液', '10ml:50mg', '1', 'gcsea', NULL),
  ('03c5eac24a9f4fb7839ffca7c038f7e6', '200097', '天津药业集团新郑股份有限公司', '无', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氟康唑', '片剂', '0.1g', '6', 'fkz', NULL),
  ('03c7afd143414bf78617d48721a6dff8', '200098', '宜昌人福药业有限责任公司', '乙酰螺旋霉素片', 0.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '乙酰螺旋霉素', '片剂', '0.1g', '12', 'yxlxms', NULL),
  ('03d23f9392354be3b2b102529281ab5c', '200099', '哈尔滨华雨制药集团有限公司', '银黄片', 1.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银黄片', '片剂', '0.25g', '24', 'yhp', NULL),
  ('045befb855604a49a85fd35651558473', '200100', '济南永宁制药股份有限公司', '氨苯蝶啶', 5.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '氨苯蝶啶', '片剂', '50mg', '100', 'abdd', NULL),
  ('0498f9597ae3489bbef15ecd502611d5', '200101', '江苏润邦药业有限公司', '邦利甘欣', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '甘草酸二铵', '胶囊', '50mg', '24', 'gcsea', NULL),
  ('04cb0d607cd440c286fa3f8fc3816340', '200102', '武汉健民药业集团股份有限公司', '耳聋左慈丸', 5.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '耳聋左慈丸', '水蜜丸', '60g', '1', 'elzcw', NULL),
  ('190c9d851bd6447386ea3750b21e8468', '200103', '雷允上药业有限公司', '无', 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '六神丸', '水丸', '10(3.125g/1000)', '12', 'lsw', NULL),
  ('1a51b21691b048e397cd8c93e0a96e8d', '200104', '海口奇力制药股份有限公司', '银杏叶片', 1.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银杏叶片', '片剂', '总黄酮醇苷9.6mg:萜类内酯2.4mg', '24', 'yxyp,yxxp', NULL),
  ('1a60fc7daf91429f9e9057beb5bfd6bb', '200105', '山东省平原制药厂', '硝酸甘油片', 2.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '硝酸甘油', '片剂', '0.5mg', '100', 'xsgy', NULL),
  ('1aaa915e053f40a4bb357cccfcef0865', '200106', '浙江昂利康制药有限公司', '多潘立酮片', 2.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '多潘立酮', '片剂', '10mg', '30', 'dplt', NULL),
  ('1b16482b4ee2434887ec529c13faa46f', '200107', '云南白药集团股份有限公司', '云南白药酊', 7.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '云南白药酊', '酊剂', '30ml', '1', 'ynbyd', NULL),
  ('1b7152e2c2964dfeb53ef3ddd6b1dd92', '200108', '悦康药业集团有限公司', '更昔洛韦', 1.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '更昔洛韦', '粉针', '0.25g', '1', 'gxlw', NULL),
  ('1bd5f3b689834a9ba8f8c5f6ffbba35f', '200109', '浙江海正药业股份有限公司', '马来酸依那普利胶囊', 10.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '马来酸依那普利胶囊', '胶囊', '10mg', '10', 'mlsynpljn', NULL),
  ('1bf07719447e44ee9db74115fc8bb3a0', '200110', '沈阳红药制药股份有限公司', '冠心苏合丸', 5.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '冠心苏合丸', '大蜜丸', '1.12g', '30', 'gxshw,gxsgw', NULL),
  ('1c0b56e3bd4140878dc95836dd312d54', '200111', '石家庄四药有限公司', '甘油果糖', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '甘油果糖', '大输液', '250ml:25g:12.5g:2.25g', '1', 'gygt', NULL),
  ('1c235969061842d699bd96717e8860de', '200112', '辰欣药业股份有限公司', '地塞米松磷酸钠注射液', 0.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '地塞米松磷酸钠', '注射液', '1ml:5mg', '1', 'dsmslsn', NULL),
  ('1c7a3942860547dca572acabea052dd9', '200113', '天津药业集团新郑股份有限公司', '无', 0.29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '开塞露', '溶液剂', '20ml', '1', 'ksl', NULL),
  ('1ce3333f192544369d3f452ace6741ad', '200114', '药都制药集团股份有限公司', '艾附暖宫丸', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '艾附暖宫丸', '大蜜丸', '9g', '10', 'yfngw,afngw', NULL),
  ('1d0178b9b21e4819bc573b514bd1adf2', '200115', '必康制药江苏有限公司', '洛伐他汀', 4.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '洛伐他汀', '胶囊', '20mg', '12', 'lftt', NULL),
  ('1e94554188204afe88dcc9ce5422971c', '200116', '哈尔滨圣泰药业有限公司', '?', 17.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '小儿热速清颗粒', '注射液', '2g', '8', 'xrrsqkl,xersqkl', NULL),
  ('1f10ac2dc1ba4b3ea481854e883d5ede', '200117', '河南科伦药业有限公司', '葡萄糖氯化钠', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '葡萄糖氯化钠', '大输液', '500ml(塑瓶)', '1', 'pttlhn', NULL),
  ('1f3806865be74f95b47ccf610b0fb43b', '200118', '湖南五洲通药业有限责任公司', '尼莫地平', 1.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '尼莫地平', '注射液', '10ml:2mg', '1', 'nmdp', NULL),
  ('1f52761d33b242ad948de7018fb6b707', '200119', '湖北潜江制药股份有限公司', '阿昔洛韦', 0.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '阿昔洛韦', '粉针', '0.25g', '1', 'axlw,exlw', NULL),
  ('1f5fcf911f534472a87b8be7135ee72b', '200120', '山东沃华医药科技股份有限公司', '补中益气丸', 3.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '补中益气丸', '大蜜丸', '9g', '10', 'bzyqw', NULL),
  ('1fa5eef6df3d45db839902870e5a3ea3', '200121', '哈药集团三精制药股份有限公司', '阿米卡星', 0.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '阿米卡星', '注射液', '2ml:0.2g', '1', 'amqx,amkx,emkx,emqx', NULL),
  ('1fb005a44a5c429592218b5367dc10ae', '200122', '瑞阳制药有限公司', '无', 0.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '青霉素钠', '粉针', '400WU', '1', 'qmsn', NULL),
  ('20ba154eb76d407cb1055b0b759b4a39', '200123', '甘肃陇神戎发制药有限公司', '元胡止痛滴丸', 22.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '元胡止痛滴丸', '滴丸', '0.5g/10', '180', 'yhztdw', NULL),
  ('20bc317dca9547e39126031f09ba1971', '200124', '上海金不换兰考制药有限公司', '吲哚美辛', 2.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '吲哚美辛', '片剂', '25mg', '100', 'ydmx', NULL),
  ('20d61eab0e6e4cb09edc1f0560f2c6c5', '200125', '河南科伦药业有限公司', '0.9%氯化钠', 1.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '0.9%氯化钠', '大输液', '250ml(塑瓶)', '1', '0.9%lhn', NULL),
  ('213cd1891f1f43a8997ad0d5049583e5', '200126', '山东罗欣药业股份有限公司', '克林霉素', 2.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '克林霉素', '粉针', '0.6g', '1', 'klms', NULL),
  ('2187a10f74994a4e8d9acf8e1f5b48f3', '200127', '江西银涛药业有限公司', '环磷腺苷注射液', 9.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '环磷腺苷', '注射液', '5ml:20mg', '1', 'hlxg', NULL),
  ('21c25a089a1b4c7fa440fe81f3dfa252', '200128', '山东百草药业有限公司', '如意金黄散', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '如意金黄散', '散剂', '9g', '10', 'ryjhs', NULL),
  ('21d2e95dea7e440180809b3e0bcd5ebe', '200129', '海南海灵化学制药有限公司', '辛伐他汀', 2.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '辛伐他汀', '片剂', '20mg', '7', 'xftt', NULL),
  ('2256d6e3c1ef41b6bd0e964f7be667a5', '200130', '成都地奥集团天府药业股份有限公司', '川芎茶调片', 12.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '川芎茶调片', '片剂', '0.48g', '48', 'cxcdp,cxctp', NULL),
  ('228223b576ce4becb3b5f85781b9567e', '200131', '河南辅仁怀庆堂', '安痛定', 0.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氨基比林', '针剂', '2ml', '1', 'ajbl', NULL),
  ('2290cb2228fa4f119fcc3535a37ec3a3', '200132', '云南省腾冲制药厂', '参苓白术颗粒', 23.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '参苓白术颗粒', '颗粒剂', '6g', '10', 'clbzkl,slbzkl,slbskl,clbskl', NULL),
  ('22d0394edbcc4d0abc46f70d5daa9dfe', '200133', '郑州卓峰制药', '地塞米松磷酸钠', 0.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '地塞米松磷酸钠', '注射液', '1ml:2mg', '1', 'dsmslsn', NULL),
  ('22e6340b8d8b42e6b433c9a2faf34b46', '200134', '石药集团欧意药业有限公司', '苯妥英钠片', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '苯妥英钠', '片剂', '50mg', '100', 'btyn', NULL),
  ('23167d3511c64a718fb1b382709d3121', '200135', '石药集团中诺药业(石家庄)有限公司', '苯唑西林', 0.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '苯唑西林', '粉针', '0.5g', '1', 'bzxl', NULL),
  ('2340c610758241e18a147d11ade8d24e', '200136', '辰欣药业股份有限公司', '奥美拉唑肠溶片', 1.37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '奥美拉唑', '肠溶片', '10mg', '14', 'amlz', NULL),
  ('2346896172e840f8b830d25f42b86087', '200137', '湖北午时药业股份有限公司', '通宣理肺颗粒', 9.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '通宣理肺颗粒', '颗粒剂', '9g', '12', 'txlfkl', NULL),
  ('23547ad5440f4d18948a56b304894184', '200138', '桂林三金药业股份有限公司', '三金片', 22.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '三金片', '片剂', '相当于原药材3.5g', '72', 'sjp', NULL),
  ('23a594bd15b645f292e0bd502bed9e02', '200139', '河南太龙药业股份有限公司', '0.9%氯化钠', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '0.9%氯化钠', '大输液', '500ml', '1', '0.9%lhn', NULL),
  ('23af66af483b4a4295fbbd5b4f9da50e', '200140', '南昌弘益药业有限公司', '弘旭光', 13.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氟康唑', '分散片', '50mg', '6', 'fkz', NULL),
  ('23e9fd96c92e4dc7a557df97dc1631b0', '200141', '江苏鹏鹞药业有限公司', '炉甘石洗剂', 1.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '炉甘石洗剂', '洗剂', '100ml', '1', 'lgsxj,lgdxj', NULL),
  ('242c4245c83642a098b2314223e1348c', '200142', '海口市制药厂有限公司', '海克洛', 4.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢克洛', '片剂', '0.25g', '6', 'tbkl', NULL),
  ('2445acbc9616437981803909826fd263', '200143', '哈尔滨儿童制药厂有限公司', '双黄连颗粒', 18.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '双黄连颗粒', '颗粒剂', '5g', '15', 'shlkl', NULL),
  ('24cc4d5c97c84484a45cadf61ddfff67', '200144', '广州欧化药业有限公司', '欧化达', 2.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '雷尼替丁', '片剂', '0.15g', '20', 'lntd,lntz', NULL),
  ('25be889b26eb4811bd4261b0ba590ec0', '200145', '济南永宁制药股份有限公司', '硫酸亚铁', 2.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '硫酸亚铁', '片剂', '0.3g', '100', 'lsyt', NULL),
  ('25c3c91e9aa24757906b11f058720ec5', '200146', '成都华宇制药有限公司', '苏顺', 12.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '特布他林', '注射液', '1ml:0.25mg', '1', 'tbtl', NULL),
  ('25e38198d5ea4c5bb4f6dc240365d9c0', '200147', '珠海润都制药股份有限公司', '吲哒帕胺', 5.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '吲哒帕胺', '胶囊', '2.5mg', '28', 'ydpa', NULL),
  ('25eb571c4a184001bc7693600eabd483', '200148', '石药集团欧意药业有限公司', '勤可息', 2.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '依那普利', '片剂', '10mg', '10', 'ynpl', NULL),
  ('26a6ab67b9b8453d94adc60f6c57354d', '200149', '开封制药(集团)有限公司', '维拉帕米', 2.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '维拉帕米', '片剂', '40mg', '24', 'wlpm', NULL),
  ('26fa02fec8984567847dc9718a3c87f4', '200150', '吉林市鹿王制药股份有限公司', '蛤蚧定喘丸', 5.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '蛤蚧定喘丸', '大蜜丸', '9g', '10', 'gjdcw,hjdcw', NULL),
  ('271680f98c7740689f06efbe68a1f792', '200151', '开封制药(集团)有限公司', '苯妥英钠片', 1.58, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '苯妥英钠片', '片剂', '0.1g', '100', 'btynp', NULL),
  ('27a1973f121e4420b7afa6dd7c663adb', '200152', '湖南麓山天然植物制药有限公司', '无', 28.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银杏叶胶囊', '胶囊', '总黄酮醇苷40mg:萜类内酯10mg', '20', 'yxxjn,yxyjn', NULL),
  ('27dcec481305474c87eb8fd42329ea12', '200153', '瑞阳制药有限公司', '的可', 1.47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '胞磷胆碱', '粉针', '0.25g', '1', 'bldj', NULL),
  ('28e8f64d979040179512fe460354ea50', '200154', '开封制药(集团)有限公司', '25%葡萄糖', 0.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '25%葡萄糖', '注射液', '20ml', '1', '25%ptt', NULL),
  ('2904282525e84cfdacad80553e307bba', '200155', '上海信谊药厂有限公司委托上海信谊黄河制药有限公司', '吡嗪酰胺片', 11.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '吡嗪酰胺片', '片剂', '0.25g', '100', 'bqxap,pqxap', NULL),
  ('29269e57e88c4f6495534c68cc30d517', '200156', '河北长天药业有限公司', '硝酸异山梨酯', 7.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '硝酸异山梨酯', '注射液', '10ml:10mg', '1', 'xsyslz', NULL),
  ('29a5a29829d547889cd35b0df2f7603a', '200157', '广州南新制药有限公司', '辛伐他汀分散片', 15.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '辛伐他汀', '分散片', '10mg', '7', 'xftt', NULL),
  ('2a3f86ef52ab458482d655bdccaa2616', '200158', '成都锦华药业有限责任公司', '利福平胶囊', 10.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '利福平', '胶囊', '0.15g', '100', 'lfp', NULL),
  ('491207c17cf24bccb11d19610eec773e', '200159', '东芝堂药业(安徽)有限公司', '健脾丸', 3.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '健脾丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'jpw', NULL),
  ('4927cab078914b9db1e9da7b002f4fb9', '200160', '山东鲁抗医药股份有限公司', '制霉素', 19.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '制霉素', '片剂', '50WIU', '100', 'zms', NULL),
  ('4958152ba04444af9f27ebae2c5f02d7', '200161', '江西仁丰药业有限公司', '六味地黄丸', 3.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '六味地黄丸', '小蜜丸', '60g', '1', 'lwdhw', NULL),
  ('49637b1cf48e416fac619713cef1d688', '200162', '杭州民生药业有限公司', '毛果芸香碱', 5.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '毛果芸香碱', '滴眼液', '5ml:25mg', '1', 'mgyxj', NULL),
  ('498d8cf828454f8380f0f881a524d81e', '200163', '江苏涟水制药', '地塞米松磷酸钠', 0.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '地塞米松磷酸钠', '注射液', '1ml:2mg', '1', 'dsmslsn', NULL),
  ('4a2872d5775c446e9bd08c3669cbf8e2', '200164', '华润三九医药股份有限公司', '正天丸', 18.26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '正天丸', '水丸', '6g', '15', 'ztw', NULL),
  ('4a5762b07f4a4bdfb31e1e593454f5ff', '200165', '海口奇力制药股份有限公司', '格列吡嗪片', 1.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '格列吡嗪', '片剂', '5mg', '24', 'glbq,glpq', NULL),
  ('4a90b2ea4db44729a643a162403abcaf', '200166', '北京四环科宝制药有限公司', '杏灵分散片', 40.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '杏灵分散片', '分散片', '每片重0.3g(含银杏酮酯40mg)', '12', 'xlfsp', NULL),
  ('4ac1370ca4d147e197b971695ea95c1c', '200167', '悦康药业集团有限公司', '奥美拉唑', 1.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '奥美拉唑', '肠溶胶囊', '10mg', '14', 'amlz', NULL),
  ('4ad8117ab5d74cafba485ae678594269', '200168', '四川禾润制药有限公司', '藿香正气颗粒', 4.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '藿香正气颗粒', '颗粒剂', '10g', '10', 'hxzqkl', NULL),
  ('4adb310111744036a352d731049b0765', '200169', '山东沃华医药科技股份有限公司', '通宣理肺丸', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '通宣理肺丸', '大蜜丸', '6g', '10', 'txlfw', NULL),
  ('4ae1dcabee9d4e4483a51017253dc5c8', '200170', '江西药都樟树制药有限公司', '通宣理肺片', 3.84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '通宣理肺片', '片剂', '0.3g', '48', 'txlfp', NULL),
  ('4b9d2aef759c4ee9bee52ce02ea43216', '200171', '杭州民生药业有限公司', '无', 4.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '山莨菪碱', '片剂', '10mg', '100', 'sldj', NULL),
  ('4bf5fa098bd34416b8bf5fb3e495f121', '200172', '吉林龙鑫药业有限公司', '柏子养心片', 17.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '柏子养心片', '片剂', '0.35g', '60', 'bzyxp', NULL),
  ('4c14171fd470404fa5c6be11a652f4bc', '200173', '湖南迪诺制药有限公司', '氟桂利嗪', 0.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氟桂利嗪', '胶囊', '5mg', '20', 'fglq', NULL),
  ('4c46a203d7c54104a4f455f4cd14bc7c', '200174', '黑龙江珍宝岛药业股份有限公司', '黄芪注射液', 0.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '黄芪注射液', '注射液', '10ml', '1', 'hqzyy,hqzsy', NULL),
  ('4c68f28571974ff7b55ca356fe839f9a', '200175', '上海现代制药股份有限公司', '申优', 7.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢拉定', '分散片', '0.25g', '24', 'tbld', NULL),
  ('ee2e80202d3741a5af1839a5492f0cc4', '200352', '四川奇力制药有限公司', '道安', 8.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '法莫替丁', '分散片', '20mg', '36', 'fmtz,fmtd', NULL),
  ('ee70cafa59e14d17bbf402f58f166bf3', '200353', '瑞阳制药有限公司', '达力平', 1.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿昔洛韦', '片剂', '0.1g', '30', 'axlw,exlw', NULL),
  ('eeb5ff3f7b33444694363fbedeebb75d', '200354', '三门峡赛诺维制药有限公司', '乳酶生', 0.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '乳酶生', '片剂', '0.15g', '100', 'rms', NULL),
  ('eee95a025e1146aaa8c9de27b04344fc', '200355', '江西泽众制药股份有限公司', '鲜竹沥', 2.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '鲜竹沥', '口服液', '30ml', '8', 'xzl', NULL),
  ('f08d50951abe4a4bbce949bc0eb636c6', '200356', '马鞍山丰原制药有限公司', '辅酶A', 1.26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '辅酶A', '粉针', '200U', '1', 'fma', NULL),
  ('f09bd5ff8814402194c86c3067138c1d', '200357', '兰州太宝制药有限公司', '内消瘰疬丸', 19.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '内消瘰疬丸', '浓缩丸', '1.85g/10', '96', 'nxllw', NULL),
  ('f0c6dfbf5a4648b78f562cc401203290', '200358', '国药集团容生制药有限公司', '氯苯那敏', 3.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '氯苯那敏', '片剂', '4mg', '1000', 'lbnm', NULL),
  ('f2072d1d12e84c959b95c3902629845b', '200359', '悦康药业集团有限公司', '奥美拉唑', 0.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '奥美拉唑', '粉针', '40mg', '1', 'amlz', NULL),
  ('f2ad0c9e44794f3fa4b2b8a670062c75', '200360', '哈尔滨华雨制药集团有限公司', '刺五加片', 1.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '刺五加片', '片剂', '0.2g', '100', 'cwjp', NULL),
  ('f30ccd5c66cb4c01a4eb2ff5fb510b1d', '200361', '河南辅仁怀庆堂制药有限公司', '川芎嗪', 0.09, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '川芎嗪', '注射液', '2ml:40mg', '1', 'cxq', NULL),
  ('f3393e3870b043cd9b411f88ee1623aa', '200362', '江西药都樟树制药有限公司', '补中益气丸', 2.53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '补中益气丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'bzyqw', NULL),
  ('f34f5fc6b69c44ac820f04d9346b5a82', '200363', '山东科伦药业有限公司', '氧氟沙星氯化钠', 0.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '氧氟沙星氯化钠', '大输液', '100ml:0.2g:0.9g', '1', 'yfsxlhn', NULL),
  ('f37a59b45c5746d7b117f96a6bbb659d', '200364', '河南同源制药有限公司', '香丹注射液', 0.57, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '香丹注射液', '注射液', '10ml', '1', 'xdzyy,xdzsy', NULL),
  ('f39303d518194aa69dc8b384c0658ba9', '200365', '江西药都樟树制药有限公司', '六味地黄丸', 3.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '六味地黄丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'lwdhw', NULL),
  ('f3a91ba502584eb1bc06c1c5f590545a', '200366', '河北瑞森药业', '阿司匹林', 0.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '阿司匹林', '肠溶片', '25mg', '100', 'aspl,espl,asyl,esyl', NULL),
  ('f3c806965f8642be9d4e78c84249848b', '200367', '珠海联邦制药股份有限公司中山分公司', '头孢呋辛酯片', 9.29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢呋辛酯片', '片剂', '0.125g', '12', 'tbfxzp', NULL),
  ('f3cd8e3b5bbc44d1bb3080411d4655b9', '200368', '云南白药集团股份有限公司', '云南白药气雾剂', 29.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '云南白药气雾剂', '气雾剂', '50g:60g', '1', 'ynbyqwj', NULL),
  ('f450af0387604205b7ce23c283eacfb9', '200369', '珠海经济特区生物化学制药厂', '恩久平', 17.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '盐酸氨溴索分散片', '分散片', '30mg', '50', 'ysaxsfsp', NULL),
  ('f49d0bd14b784e70a64bf402fdca051b', '200370', '河南禹州市药王制药有限公司', '明目地黄丸', 3.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '明目地黄丸', '大蜜丸', '9g', '10', 'mmdhw', NULL),
  ('f4f30ddd6e0644ad8c0a12e83014505f', '200371', '芜湖张恒春药业有限公司', '附子理中丸', 3.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '附子理中丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'fzlzw', NULL),
  ('f56f78235e7941ec902a41dcb3ff5164', '200372', '海南惠普森医药生物技术有限公司', '希诺', 9.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢克洛', '分散片', '0.125g', '12', 'tbkl', NULL),
  ('f58e5e4887c34b4b9069f0aed1c872c0', '200373', '辅仁药业集团有限公司', '异丙嗪', 1.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '异丙嗪', '片剂', '25mg', '100', 'ybq', NULL),
  ('f5f1be7323584e57980f72a7a0198fc3', '200374', '四川科伦药业股份有限公司', '替硝唑氯化钠', 0.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '替硝唑氯化钠', '大输液', '100ml:0.4g:0.9g', '1', 'txzlhn', NULL),
  ('f7445f59bf6b481d9d52cc1b0e74fcb9', '200375', '山东齐都药业有限公司', '20%甘露醇', 1.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '20%甘露醇', '大输液', '250ml', '1', '20%glc', NULL),
  ('f744915a53014f20b3bfbf7ca9bc9dd1', '200376', '山东罗欣药业股份有限公司', '氨溴索', 1.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氨溴索', '片剂', '30mg', '20', 'axs', NULL),
  ('f7be5ba0a7fe4d6d8244da42ef4365dc', '200377', '江苏亚邦爱普森药业有限公司', '呋塞米片', 2.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '呋塞米片', '片剂', '20mg', '100', 'fsmp', NULL),
  ('f8249a85dd73480198e73e180ac1fd9b', '200378', '山东方明药业集团股份有限公司', '丙戊酸钠片', 8.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '丙戊酸钠', '片剂', '0.2g', '100', 'bwsn', NULL),
  ('f83499b85b804910a7396ce0b52b681a', '200379', '上海玉丹药业有限公司', '无', 36.22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '荣心丸', '大蜜丸', '1.5g', '36', 'rxw', NULL),
  ('f87653e12ca547e492ae2779f45e25a4', '200380', '山东华信制药集团股份有限公司', '葛根素', 0.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '葛根素', '注射液', '2ml:0.1g', '1', 'ggs', NULL),
  ('f91593131ed640269eb4a6d7b4b7b5e4', '200381', '烟台天正药业有限公司', '防风通圣颗粒', 23.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '防风通圣颗粒', '颗粒剂', '3g', '18', 'fftskl', NULL),
  ('f961fbe96c414819a86a41140c4eae19', '200382', '北京华润高科天然药物有限公司', '茵栀黄口服液', 18.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '茵栀黄口服液', '口服液', '10ml', '6', 'yzhkfy', NULL),
  ('3ca9d45b437442b8a9f1b8ef6f83f3ad', '200383', '河南天方药业股份有限公司', '维生素B6', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维生素B6', '注射液', '2ml:0.1g', '1', 'wssb6', NULL),
  ('0db63f8dc6ee4bee844b12d2a54402c4', '200384', '上海信谊药厂有限公司', '无', 15.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '氢化可的松', '片剂', '20mg', '100', 'qhkds', NULL),
  ('1dc13a2ab4204d629a0431dc117d7c62', '200385', '江西荣裕药业集团有限公司', '元胡止痛胶囊', 3.62, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '元胡止痛胶囊', '胶囊', '0.25g', '24', 'yhztjn', NULL),
  ('2a22e69f9f5e4806be9ef860a2346254', '200386', '江苏万邦生化医药股份有限公司', '肝素钠', 7.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '肝素钠', '注射液', '2ml:1.25WIU', '1', 'gsn', NULL),
  ('579624a400cd442ba930572492053557', '200387', '杭州国光药业有限公司', '佐凯', 7.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '左氧氟沙星', '滴眼液', '8ml:24mg', '1', 'zyfsx', NULL),
  ('9051c1b4d16e44cdabb287ed7332b6b1', '200388', '湖南洞庭药业股份有限公司', '无', 2.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氟哌啶醇', '注射液', '1ml:5mg', '1', 'fpdc', NULL),
  ('a8464dd6e3e34009a07d549a65d86474', '200389', '石药集团中诺药业(石家庄)有限公司', '中诺奇奥', 1.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢他啶', '粉针', '0.5g', '1', 'tbtd', NULL),
  ('b775c07e5c074d3ba724f2e2f5f6aef0', '200390', '广州贵港冠峰药业', '刺五加片', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '刺五加片', '片剂', '0.2g', '100', 'cwjp', NULL),
  ('9bb97df8bbbd4efea86079f880110b58', '200391', '河南省百泉制药有限公司', '舒筋活血片', 1.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '舒筋活血片', '片剂', '/', '100', 'sjhxp', NULL),
  ('675bfa44762f41dfac50673d00015ddc', '200392', '山东鲁抗医药股份有限公司', '无', 0.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢唑林', '粉针', '0.5g', '1', 'tbzl', NULL),
  ('f8939741e16749a8be469f2691bb24bf', '200393', '河北天成药业股份有限公司', '葡萄糖酸钙注射液', 0.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '葡萄糖酸钙', '注射液', '10ml:1.0g', '1', 'pttsg', NULL),
  ('c83fa745f67c40ecb1412cd0ebbc8806', '200394', '九寨沟天然药业集团有限责任公司', '银翘解毒颗粒', 2.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银翘解毒颗粒', '颗粒剂', '15g', '10', 'yqxdkl,yqjdkl', NULL),
  ('e9cbc95f4eb344c1a2deee8380d822c2', '200395', '烟台益生药业有限公司', '博尔卡', 13.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '乳酸菌素', '咀嚼片', '0.4g', '24', 'rsjs', NULL),
  ('2deacc28ec5042f6a93b4a7f8e1c967c', '200396', '河南爱民药业集团股份有限公司', '感冒清热颗粒', 2.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '感冒清热颗粒', '颗粒剂', '12g', '9', 'gmqrkl', NULL),
  ('3341ca189cbe4e55b791a9e735411404', '200397', '湖南洞庭药业股份有限公司', '无', 16.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氨甲苯酸', '片剂', '0.25g', '100', 'ajbs', NULL),
  ('3664cde69bec4bb798f8bc2446b11931', '200398', '江西民济药业有限公司', '归脾合剂', 20.01, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '归脾合剂', '口服液', '10ml', '18', 'gpgj,gphj', NULL),
  ('395cd731ec904ad3aca204227d4aaf89', '200399', '湖南科伦制药有限公司', '甲硝唑氯化钠', 0.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '甲硝唑氯化钠', '大输液', '100ml:0.5g:0.9g', '1', 'jxzlhn', NULL),
  ('3a665a407b6c445f9edb8f9134e8593b', '200400', '安徽九方制药有限公司', '保和颗粒', 11.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '保和颗粒', '颗粒剂', '4.5g', '20', 'bhkl', NULL),
  ('3d6b1bab47c444028257c2c33f96a96e', '200401', '山东鲁北药业有限公司', '甲状腺片', 2.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '甲状腺', '片剂', '40mg', '100', 'jzx', NULL),
  ('3f94129556714597a7a681026535371c', '200402', '河南科伦药业有限公司', '10%葡萄糖', 0.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '10%葡萄糖', '大输液', '100ml(塑瓶)', '1', '10%ptt', NULL),
  ('41dc60b4380e4b37924ce939bca5be84', '200403', '药都制药集团', '四神丸', 6.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '四神丸', '水丸', '6g', '10', 'ssw', NULL),
  ('43bb185316e447928e64b86ae700f613', '200404', '深圳致君制药有限公司', '达力清', 19.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢唑肟', '粉针', '0.5g', '1', 'tbzw', NULL),
  ('44f068dbb53d4bed9af82d469cc8f88e', '200405', '华北制药股份有限公司', '注射用氨苄西林钠', 0.58, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氨苄西林', '粉针', '1.0g', '1', 'abxl', NULL),
  ('48a167a4f621474bbfe0f12b80cc8939', '200406', '上海现代制药股份有限公司', '替硝唑', 18.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '替硝唑', '栓剂', '1.0g', '6', 'txz', NULL),
  ('021a69980e874d5781460c3bd7e3b994', '200407', '远大医药（中国）有限公司', '酒石酸美托洛尔片', 6.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '美托洛尔', '片剂', '50mg', '20', 'mtle', NULL),
  ('04605292170b4a8d89e92cef56a3a88f', '200408', '四川逢春制药有限公司', '复方丹参片', 3.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '复方丹参片', '片剂', '/', '60', 'ffdsp,ffdcp', NULL),
  ('07e12db4a973415b844e31ac60059bdd', '200409', '上海旭东海普药业有限公司', '无', 2.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '加兰他敏', '注射液', '1ml:5mg', '1', 'jltm', NULL),
  ('0b9dca622532445383ede91dd4ecf509', '200410', '石家庄四药有限公司', '右旋糖酐40氯化钠', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '右旋糖酐40氯化钠', '大输液', '500ml:30g:4.5g', '1', 'yxtg40lhn', NULL),
  ('0d958164677e4d64a23b25e145b4c3fd', '200411', '烟台只楚药业有限公司', '硫酸庆大霉素片', 8.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '庆大霉素', '片剂', '40mg', '100', 'qdms', NULL),
  ('10ab120cecb540cb894280efbd99c4be', '200412', '哈药集团三精制药股份有限公司', '氨茶碱', 0.22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氨茶碱', '注射液', '10ml:0.25g', '1', 'acj', NULL),
  ('123ffec8da544c15948be6fa3cd5924c', '200413', '河南天地药业股份有限公司', '醒脑静注射液', 8.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '醒脑静注射液', '注射液', '2ml', '1', 'xnjzyy,xnjzsy', NULL),
  ('17c80d1031244812b1134e64bf91e4a2', '200414', '九寨沟天然药业集团有限责任公司', '壮骨麝香止痛膏', 2.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '壮骨麝香止痛膏', '橡胶膏剂', '7cm*10cm', '10', 'zgsxztg', NULL),
  ('1aa03c627911414db92c25d54a208b01', '200415', '远大医药（中国）有限公司', '复方阿司匹林', 2.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '复方阿司匹林', '片剂', '乙酰水杨酸0.22g:非那西丁0.15g:咖啡因35mg', '100', 'ffesyl,ffespl,ffasyl,ffaspl', NULL),
  ('1d194c40b8fd48729ec8ecd555f8ae2e', '200416', '深圳致君制药有限公司', '联力克', 20.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '愈酚伪麻待因', '口服液', '60ml(每10ml溶液含磷酸可待因20mg:愈创木酚甘油醚200mg:盐酸伪麻黄碱60mg)', '1', 'yfwmdy', NULL),
  ('1fae266bd1324b8881c70bd3154a283b', '200417', '河南禹州市药王制药有限公司', '人参健脾丸', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '人参健脾丸', '大蜜丸', '6g', '10', 'rsjpw,rcjpw', NULL),
  ('227bd6d535b94832b1a36e9b36ec0901', '200418', '安徽联谊药业股份有限公司', '无', 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '格列齐特', '缓释片', '30mg', '30', 'gljt,glqt', NULL),
  ('239e326dd9c04034a440e25beaff5d83', '200419', '四川省宜宾五粮液集团宜宾制药有限责任公司', '生脉注射液', 19.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '生脉注射液', '注射液', '20ml', '3', 'smzyy,smzsy', NULL),
  ('26f5981f2f8345fe84bde3f6daaacc5b', '200420', '辅仁药业集团有限公司', '清热解毒口服液', 6.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '清热解毒口服液', '口服液', '10ml', '10', 'qrxdkfy,qrjdkfy', NULL),
  ('2a2a20857cdf420789aad79d7df3c3c3', '200421', '海口市制药厂有限公司', '海维素', 1.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维生素C', '粉针', '0.5g', '1', 'wssc', NULL),
  ('4a049b0a4aaa48e8b50ddeb2e5cc7d0a', '200422', '陕西步长制药有限公司', '脑心通胶囊', 25.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '脑心通胶囊', '胶囊', '0.4g', '36', 'nxtjn', NULL),
  ('4b3fe0c59c63461bbb4f5a001265a35d', '200423', '上海信谊金朱药业有限公司', '无', 2.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '精氨酸', '注射液', '20ml:5.0g', '1', 'jas', NULL),
  ('4e42f8ea371a4d2abd7096eaac29728f', '200424', '上海玉丹药业有限公司', '无', 28.84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '参桂胶囊', '胶囊', '0.3g', '30', 'cgjn,sgjn', NULL),
  ('512a8f89b25841e794e1b29b563497c5', '200425', '山东罗欣药业股份有限公司', '左沙', 0.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '左氧氟沙星', '片剂', '0.1g', '12', 'zyfsx', NULL),
  ('541cd9a3cd8b4896ab3cd22607f4d11e', '200426', '宜昌长江药业有限公司', '氟康唑', 1.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氟康唑', '胶囊', '50mg', '6', 'fkz', NULL),
  ('567c91aa949b4c14904cf603aae316d7', '200427', '南宁康诺生化制药有限责任公司', '大黄碳酸氢钠片', 1.54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '大黄碳酸氢钠', '片剂', '大黄0.15g，碳酸氢钠0.15g，薄荷油0.001ml', '100', 'dhtsqn', NULL),
  ('8714835dd68a470f92d88b5deeb6c5bd', '200428', '安徽宏业药业有限公司', '硫糖铝', 1.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '硫糖铝', '片剂', '0.25g', '100', 'ltl', NULL),
  ('887cb5f86b174b40b22962698f086163', '200429', '江苏克胜药业有限公司', '辅酶Q10胶囊', 2.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '辅酶Q10', '胶囊', '5mg', '30', 'fmq10', NULL),
  ('8aee814ecd394c04b291213ef76a72bc', '200430', '桂龙药业（安徽）有限公司', '更年安片', 8.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '更年安片', '片剂', '0.3g', '100', 'gnap', NULL),
  ('8d9f30a063ec49f09d5cde51043f10ec', '200431', '石药集团欧意药业有限公司', '腺苷钴胺片', 2.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '腺苷钴胺', '片剂', '0.25mg', '100', 'xgga', NULL),
  ('8f8944a533194d5f9315abda29555255', '200432', '科伦集团(四川科伦)', '脂肪乳注射液(C14-24)', 27.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '脂肪乳注射液(C14-24)', '大输液', '20% 250ml:50g:3g', '1', 'zfrzyy(c14-24),zfrzsy(c14-24)', NULL),
  ('9cfd5f4c59044020bca5522fb9b9773e', '200433', '济南利民制药有限责任公司', '克霉唑', 15.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '克霉唑', '阴道片', '0.5g', '3', 'kmz', NULL),
  ('9fc0ebec8e3d44b787f68e0d6bf9e4aa', '200434', '广东一力集团', '复方丹参片', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '复方丹参片', '片剂', '/', '60', 'ffdsp,ffdcp', NULL),
  ('a274f15a7b6f4659918cf5383e9e47e4', '200435', '西南药业股份有限公司', '异丙嗪', 6.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '异丙嗪', '片剂', '12.5mg', '1000', 'ybq', NULL),
  ('a4c824d9423f46a1a1d2e9e441b4ae0f', '200436', '华润三九医药股份有限公司', '三九胃泰颗粒', 12.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '三九胃泰颗粒', '颗粒剂', '20g', '10', 'sjwtkl', NULL),
  ('a7a559fb7dc748909d9ef133f4249d8d', '200437', '悦康药业集团有限公司', '悦康辛', 1.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '奥扎格雷钠', '粉针', '80mg', '1', 'azgln', NULL),
  ('aabda4b52ed84e93a3b34690d10b9785', '200438', '河南太龙药业股份有限公司', '5%葡萄糖', 0.91, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '5%葡萄糖', '大输液', '250ml', '1', '5%ptt', NULL),
  ('ac069dc3a62e49d797e1deb702b1255e', '200439', '山东罗欣药业股份有限公司', '左氧氟沙星', 1.58, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '左氧氟沙星', '片剂', '0.2g', '12', 'zyfsx', NULL),
  ('b04915d9fb134e0ba88c408393d58dc1', '200440', '辰欣药业股份有限公司', '胞磷胆碱钠注射液', 0.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '胞磷胆碱', '注射液', '2ml:0.25g', '1', 'bldj', NULL),
  ('b32861e5658a43ecb5d0129a54762eed', '200441', '江西药都樟树制药有限公司', '知柏地黄丸', 2.42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '知柏地黄丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'zbdhw', NULL),
  ('b4a94ecaf1fc4dbda0a1ca7b7377a717', '200442', '天津药业集团新郑股份有限公司', '法莫替丁注射液', 3.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '法莫替丁注射液', '注射剂', '2ml:20mg', '10', 'fmtzzyy,fmtdzyy,fmtzzsy,fmtdzsy', NULL),
  ('915b1a077b184c1a806c86b51595c567', '200443', '成都百裕科技制药有限公司', '盐酸氨溴索注射液', 7.36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氨溴索', '注射液', '4ml:30mg', '1', 'axs', NULL),
  ('93cc9d26c2ac4d69bc2e627e7c86dba5', '200444', '天津金耀氨基酸有限公司', '甲氧氯普胺', 0.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '甲氧氯普胺', '注射液', '2ml:10mg', '1', 'jylpa', NULL),
  ('95b455abf7d04c3ca1629459389a30d8', '200445', '山东罗欣药业股份有限公司', '宁沙', 1.06, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '左氧氟沙星', '粉针', '0.2g', '1', 'zyfsx', NULL),
  ('98737f88856b4792af9aab61141fb75d', '200446', '黄石三九药业有限公司', '八珍益母丸', 4.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '八珍益母丸', '水蜜丸', '60g', '1', 'bzymw', NULL),
  ('9a38111f32f942a2893e72115d485c4f', '200447', '河南省洛正制药厂', '筋骨痛消丸', 26.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '筋骨痛消丸', '颗粒剂', '6g', '12', 'jgtxw', NULL),
  ('599ae0549d9d4052b88710a0209e246a', '200448', '福建太平洋制药有限公司', '布洛芬', 2.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '布洛芬', '缓释胶囊', '0.3g', '10', 'blf', NULL),
  ('f99c542b87ca482e8b321e3ba52b4cbe', '200449', '上海旭东海普药业有限公司', '无', 1.62, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '谷氨酸钠', '注射液', '20ml:5.75g', '1', 'yasn,gasn', NULL),
  ('fa2438c3f61b4edcba6db03c0e881e2a', '200450', '南京天朗制药有限公司', '氧氟沙星滴眼液', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氧氟沙星', '滴眼液', '8ml:24mg', '1', 'yfsx', NULL),
  ('fa6ee2d5cb304b41bd5d44a37ffdf7f5', '200451', '宜昌人福药业有限责任公司', '维生素C注射液', 0.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维生素C', '注射液', '5ml:1.0g', '1', 'wssc', NULL),
  ('fb71d409055f419fa66913e60f39f361', '200452', '上海现代制药股份有限公司', '欣然', 29.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '硝苯地平控释片', '控释片', '30mg', '12', 'xbdpksp', NULL),
  ('fba13efe35b7412ea82f665c55ed28de', '200453', '新乡恒久远药业有限公司', '无', 2.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '倍他司汀', '片剂', '4mg', '100', 'btst', NULL),
  ('fba872f2c845467f8fa683909cd37337', '200454', '吉林省集安益盛药业股份有限公司', '生脉注射液', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '生脉注射液', '注射液', '10ml', '1', 'smzyy,smzsy', NULL),
  ('fc036e664cfb4641a61b0515f762a8c1', '200455', '河南科伦药业有限公司', '10%葡萄糖', 1.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '10%葡萄糖', '大输液', '250ml(塑瓶)', '1', '10%ptt', NULL),
  ('fc4535139c7c47d8b9351fe7f57bf36a', '200456', '山东健康药业有限公司', '美西律', 8.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '美西律', '片剂', '0.1g', '100', 'mxl', NULL),
  ('fc98d27ef5e24d48a557915bf1e8c96a', '200457', '山东罗欣药业股份有限公司', '叶酸', 8.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '叶酸', '粉针', '15mg', '1', 'xs,ys', NULL),
  ('fc9ce3913e774d018b3aa074f19dc13a', '200458', '江西药都樟树制药有限公司', '逍遥颗粒', 5.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '逍遥颗粒', '颗粒剂', '15g', '10', 'xykl', NULL),
  ('fd58d9907c6a4540a644c38f9fabef42', '200459', '海口奇力制药股份有限公司', '盐酸左氧氟沙星胶囊', 2.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '左氧氟沙星', '胶囊', '0.2g', '12', 'zyfsx', NULL),
  ('fddf8bc0c65c4617be6db136462160b5', '200460', '广州白云山星群(药业)股份有限公司', '安神补脑液', 9.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '安神补脑液', '口服液', '10ml', '10', 'asbny', NULL),
  ('fdf9147d54e0414caddea72dcbb858b9', '200461', '四川省宜宾五粮液集团宜宾制药有限责任公司', '益母草颗粒', 4.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '益母草颗粒', '颗粒剂', '15g', '20', 'ymckl', NULL),
  ('fe53a71997ab4eabbacd1b39b2e84cf0', '200462', '宜昌人福药业有限责任公司', '卡马西平片', 2.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '卡马西平', '片剂', '0.1g', '100', 'qmxp,kmxp', NULL),
  ('fe77af3aa95e40d48575f8b77a70d0eb', '200463', '江西天施康弋阳制药有限公司', '牛黄上清胶囊', 22.91, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '牛黄上清胶囊', '胶囊', '0.3g', '36', 'nhsqjn', NULL),
  ('ff1a0b01ffbc4e54abc869cdda08e7db', '200464', '华中药业股份有限公司', '葡醛内酯', 0.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '葡醛内酯', '片剂', '50mg', '100', 'pqnz', NULL),
  ('ff3042c999bd43c6b122d3381ca089b7', '200465', '河南同源制药有限公司', '生脉饮(党参)', 3.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '生脉饮(党参)', '口服液', '10ml', '10', 'smy(dc),smy(ds)', NULL),
  ('8743a95fb3d34107bfab4870741932ea', '200466', '江苏吴中医药集团有限公司苏州制药厂', '盐酸纳洛酮注射液', 7.29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '纳洛酮', '注射液', '2ml:2mg', '1', 'nlt', NULL),
  ('87644063ad9c40259117ee26e896d846', '200467', '山东健康药业有限公司', '尼莫地平', 3.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '尼莫地平', '片剂', '30mg', '100', 'nmdp', NULL),
  ('87b2bb249f974044a664536234f05ee1', '200468', '长春海悦药业有限公司', '乙酰谷酰胺', 3.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '乙酰谷酰胺', '粉针', '0.25g', '1', 'yxgxa,yxyxa', NULL),
  ('87d11329049d4209b6b318db774dba41', '200469', '浙江奥托康制药集团股份有限公司', '阿奇霉素片', 64.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '硫唑嘌呤', '片剂', '50mg', '100', 'lzpl', NULL),
  ('87d24184ba0a467da5756189f82adfd2', '200470', '蓬莱诺康药业有限公司', '注射用血凝酶', 39.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '血凝酶', '粉针', '1IU', '1', 'xnm', NULL),
  ('87dbcc2fe29c4cc48e7c0c50326358fd', '200471', '天津天药药业股份有限公司', '无', 1.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '地塞米松', '片剂', '0.75mg', '100', 'dsms', NULL),
  ('8845cb2b448143838cb9e11e554561b2', '200472', '江西南昌济生制药厂', '?', 18.91, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '排石颗粒', '颗粒剂', '5g(无糖型)', '10', 'pskl,pdkl', NULL),
  ('88b4815bd5b7462b91146183462a03dd', '200473', '河南怀庆药业有限责任公司', '槐角丸', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '槐角丸', '大蜜丸', '9g', '10', 'hjw', NULL),
  ('88ebadddad5045b2a82198242957e691', '200474', '石药集团中诺药业(石家庄)有限公司', '氨溴索', 6.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氨溴索', '口服液', '10ml:30mg', '10', 'axs', NULL),
  ('8902fe3737544717985f72cafc587907', '200475', '石药集团中诺药业(石家庄)有限公司', '头孢曲松钠', 0.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢曲松钠', '粉针', '1.0g', '1', 'tbqsn', NULL),
  ('895501c3fac5404283cf744d076e340d', '200476', '湖南科伦制药有限公司', '红霉素', 1.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '红霉素', '粉针', '0.25g', '1', 'hms,gms', NULL),
  ('8976adc2d0f64991a21917f9d49857ee', '200477', '哈尔滨珍宝制药有限公司', '刺五加注射液', 1.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '刺五加注射液', '注射液', '20ml:0.1g', '1', 'cwjzyy,cwjzsy', NULL),
  ('8a1aea11cd9a4990a5a2b241d96fceb0', '200478', '广东台城制药股份有限公司', '金匮肾气片', 24.33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '金匮肾气片', '片剂', '0.27g', '100', 'jksqp', NULL),
  ('8a6ed42d416d470e8136ac1bf22e35d6', '200479', '河南康祺药业股份有限公司', '银翘解毒片', 3.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '银翘解毒片', '片剂', '/', '48', 'yqjdp,yqxdp', NULL),
  ('8aa3bee08f7f4fd1903dfd5205cef411', '200480', '江苏四环生物制药有限公司', '甲钴胺', 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '甲钴胺', '分散片', '0.5mg　　', '20', 'jga', NULL),
  ('8b13f47d76ec452e9dae39e202c47144', '200481', '河北万岁药业有限公司', '脑立清胶囊', 3.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '脑立清胶囊', '胶囊', '0.33g', '24', 'nlqjn', NULL),
  ('8b299d0c04674bdabb2e2d71b0316585', '200482', '哈尔滨一洲制药有限公司', '旨泰', 12.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '辛伐他汀', '胶囊', '20mg', '10', 'xftt', NULL),
  ('8b669f75d964462f911799c63a357bc7', '200483', '武汉五景药业有限公司', '氧氟沙星滴耳液', 1.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氧氟沙星', '滴耳液', '5ml:15mg', '1', 'yfsx', NULL),
  ('8bfc9364b93d4c01a65b5d6b687d4bb2', '200484', '济南利民制药有限责任公司', '克霉唑', 10.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '克霉唑', '阴道片', '0.5g', '2', 'kmz', NULL),
  ('a3eb4a2777964821aed55df0036b1b6e', '200529', '山东华信制药集团股份有限公司', '护肝片', 3.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '护肝片', '片剂', '0.36g', '100', 'hgp', NULL),
  ('a3f349a3c5cb4facb267b912eed43ba4', '200530', '上海现代哈森(商丘)药业有限公司', '磺胺嘧啶钠注射液', 0.33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '磺胺嘧啶', '注射液', '2ml:0.4g', '1', 'hamd', NULL),
  ('a431fbe79f2748db89c2bdef23869bb5', '200531', '湖北东信药业有限公司', '吲哚美辛栓', 2.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '吲哚美辛', '栓剂', '0.1g', '10', 'ydmx', NULL),
  ('a4ac7040a2d8424b8f6f514836ae3c01', '200532', '上海海虹实业（集团）巢湖今辰药业有限公司', '黄连上清胶囊', 18.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '黄连上清胶囊', '胶囊', '0.4g', '30', 'hlsqjn', NULL),
  ('a5a7f2272cfe44b8aa677babae3d76b5', '200533', '山东鲁抗医药股份有限公司', '无', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢唑林', '粉针', '1.0g', '1', 'tbzl', NULL),
  ('a5c443ec83b647fea5a10c65935a31db', '200534', '辰欣药业股份有限公司', '氧氟沙星滴眼液', 0.92, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氧氟沙星', '滴眼液', '5ml:15mg', '1', 'yfsx', NULL),
  ('a5c8ef8014bf49ecbced613ee558bd62', '200535', '新乡华青药业有限公司', '无', 0.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '红霉素', '软膏剂', '8g:80mg(1%)', '1', 'hms,gms', NULL),
  ('a5dfa2efadab4bf49af227f2319e64fa', '200536', '上海玉瑞生物科技（安阳）药业有限公司', '维生素B1片', 5.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '维生素B1', '片剂', '5mg', '1000', 'wssb1', NULL),
  ('a660cb1fec894aac8b49d76fdc4e3290', '200537', '南京白敬宇制药有限责任公司', '酮康唑', 4.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '酮康唑', '乳膏剂', '15g:0.3g', '1', 'tkz', NULL),
  ('a6dbe8fdf8514d018f5c37d45e79318b', '200538', '瑞阳制药有限公司', '无', 1.93, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '地芬尼多', '片剂', '25mg', '100', 'dfnd', NULL),
  ('a723d0e20165445a9a0b94fefd4d7312', '200539', '东北制药集团沈阳第一制药有限公司', '无', 7.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '对乙酰氨基酚', '片剂', '0.5g', '400', 'dyxajf', NULL),
  ('a74564066e4f40b99aacfd2a37898ad3', '200540', '药都制药集团股份有限公司', '血府逐瘀丸', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '血府逐瘀丸', '大蜜丸', '9g', '10', 'xfzyw', NULL),
  ('a83981a230d5446697b393f5a96ca0ea', '200541', '华润双鹤药业股份有限公司', '复方利血平氨苯蝶啶片', 8.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '复方利血平氨苯蝶啶', '片剂', '复方', '10', 'fflxpabdd', NULL),
  ('a83ff4713c2d4de190d47f8a9a850579', '200542', '齐鲁制药有限公司', '硝酸异山梨酯注射液', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '硝酸异山梨酯', '注射液', '5ml:5mg', '1', 'xsyslz', NULL),
  ('a85664a1b05d414db83b0aa0ac1b0220', '200543', '东北制药集团沈阳第一制药有限公司', '无', 2.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '磷霉素钠', '粉针', '2.0g', '1', 'lmsn', NULL),
  ('a89406e8ad02457e96c6163aa3e7780e', '200544', '河南太龙药业股份有限公司', '10%葡萄糖', 0.91, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '10%葡萄糖', '大输液', '250ml', '1', '10%ptt', NULL),
  ('a8a9222a11ec4cd686069b842d9aae52', '200545', '江西药都仁和制药有限公司', '硝酸咪康唑栓', 2.53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '咪康唑', '栓剂', '0.2g', '7', 'mkz', NULL),
  ('a8d4d457795a460f935845dc85b3da1e', '200546', '华中药业股份有限公司', '硝酸异山梨酯', 15.59, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '硝酸异山梨酯', '缓释片', '20mg', '30', 'xsyslz', NULL),
  ('a95e48c393f2409a982bc4e078f70395', '200547', '河南华利制药股份有限公司', '葡萄糖氯化钠注射液', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '葡萄糖氯化钠注射液', '大输液', '500ml:25g:4.5g((塑瓶)', '1', 'pttlhnzyy,pttlhnzsy', NULL),
  ('aa101489823e4043badfe327ff1da563', '200548', '临汾宝珠制药有限公司', '吲哚美辛', 0.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '吲哚美辛', '肠溶片', '25mg', '100', 'ydmx', NULL),
  ('aa9c36a328144b65b2b1b5013437ba99', '200549', '远大医药（中国）有限公司', '*', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '去甲肾上腺素', '注射液', '1ml:2mg', '1', 'qjssxs', NULL),
  ('aaa06e36203d4370bb966023da86b8a5', '200550', '马鞍山丰原制药有限公司', '绒促性素', 2.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '绒促性素', '粉针', '500IU', '1', 'rcxs', NULL),
  ('aacd68e6dda542f7b5b3466ba2b093a9', '200551', '浙江泰利森药业有限公司', '纳欣同', 9.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '硝苯地平缓释片', '缓释片', '20mg', '20', 'xbdphsp', NULL),
  ('aad4d42b810a407f905add48e8cca52d', '200552', '陕西永寿制药有限责任公司', '四神片', 18.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '四神片', '片剂', '0.35g', '36', 'ssp', NULL),
  ('aaf43b9420784963a6d4a51d3160d8af', '200553', '浙江仙琚制药股份有限公司', '甲羟孕酮', 3.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '甲羟孕酮', '片剂', '2mg', '100', 'jqyt', NULL),
  ('ab0eea5fec71421c9d3ebb0f05fed044', '200554', '哈尔滨珍宝制药有限公司', '血塞通注射液', 1.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '血塞通注射液', '注射液', '2ml:0.1g', '1', 'xstzyy,xstzsy', NULL),
  ('ab0ffbca75964f1b810e7c395b316dab', '200555', '江西民康制药有限公司', '橘红颗粒', 4.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '橘红颗粒', '颗粒剂', '11g(相当于原生药7g)', '10', 'jhkl,jgkl', NULL),
  ('ab1a654ddd2246b7b51e5d3fc2a92ef0', '200556', '山东罗欣药业股份有限公司', '克霉唑', 7.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '克霉唑', '阴道泡腾片', '0.15g', '10', 'kmz', NULL),
  ('abfe920562794846b844f1d6c9512392', '200557', '河南怀庆药业有限责任公司', '杞菊地黄丸', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '杞菊地黄丸', '大蜜丸', '9g', '10', 'qjdhw', NULL),
  ('ad1dc1afed9c49d484ebc2ab215a8286', '200558', '山东方明药业集团股份有限公司', '无', 0.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '乙酰谷酰胺', '注射液', '2ml:0.1g', '1', 'yxgxa,yxyxa', NULL),
  ('ad956ceef6de4427a5d20c6cfcfab3b6', '200559', '湖北东信药业有限公司', '甲硝唑阴道泡腾片', 1.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '甲硝唑', '阴道泡腾片', '0.2g', '14', 'jxz', NULL),
  ('add8f7a906f9466b862ad98240731a31', '200560', '海南中化联合制药工业股份有限公司', '头孢美唑', 11.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢美唑', '粉针', '0.5g', '1', 'tbmz', NULL),
  ('ae093d8e38c649a5a61b2bd85100ad14', '200561', '新乡华青药业有限公司', '无', 0.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '诺氟沙星', '滴眼液', '8ml:24mg', '1', 'nfsx', NULL),
  ('ae5b6c7c65b8449aa5e38705435f9e07', '200562', '广州白云山明兴制药有限公司', '迪克司', 20.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '清开灵胶囊', '胶囊', '0.4g', '24', 'qkljn', NULL),
  ('af3b242712044c85abde65bb1b6ecaca', '200563', '江苏方强制药厂有限责任公司', '地巴唑', 1.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '地巴唑', '片剂', '10mg', '100', 'dbz', NULL),
  ('af6d253622a44c0cb9500d6e39a7dbfa', '200564', '四川百利药业有限责任公司', '新博林', 2.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '利巴韦林', '颗粒剂', '0.15g', '12', 'lbwl', NULL),
  ('afa2174b65ec48538cde4a472d3977c8', '200565', '浙江南洋药业有限公司', '消咳喘片', 6.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '消咳喘片', '片剂', '0.3g', '24', 'xkcp,xhcp', NULL),
  ('afbdb5ae0fc64fec9a78fbfecd8c5cf1', '200566', '海南碧凯药业有限公司', '晴尔', 12.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '奥扎格雷钠', '注射液', '2ml:40mg', '1', 'azgln', NULL),
  ('b04dc599beea4714b36732e558d8e776', '200567', '武汉华龙生物制药有限公司', '菲克芯康', 16.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '单硝酸异山梨酯', '粉针', '25mg', '1', 'cxsyslz,sxsyslz,dxsyslz', NULL),
  ('b050f8b15afe48f79fee92be40e93e9d', '200568', '山东淄博新达制药有限公司', '新达贝宁', 1.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿莫西林', '颗粒剂', '0.125g', '12', 'amxl,emxl', NULL),
  ('b066ca1f23234453abc4b0b85ca0de36', '200569', '丽珠集团丽珠制药厂', '绒促性素', 5.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '绒促性素', '粉针', '2000IU', '1', 'rcxs', NULL),
  ('b0b39067c5ca49ffa1efb933bd7a10fb', '200570', '河南天方药业股份有限公司', '维生素C注射液', 0.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '维生素C注射液', '注射液', '2ml:0.5g', '10', 'wssczsy,wssczyy', NULL),
  ('b0b42065abc7470c8b2ecc21dd7eebaa', '200571', '云南白药集团', '血塞通注射液', 1.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '血塞通注射液', '注射液', '2ml:0.1g', '10', 'xstzyy,xstzsy', NULL),
  ('8c285b91ac07457ab8686668fa740a6d', '200485', '河北天成药业股份有限公司', '注射用维生素C', 1.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维生素C', '粉针', '1.0g', '1', 'wssc', NULL),
  ('8ca78455c9f2452898e2e61e0ccb1c2a', '200486', '西安天一秦昆制药有限责任公司', '银黄颗粒', 18.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银黄颗粒', '颗粒剂', '4g(无糖型)', '16', 'yhkl', NULL),
  ('8cb157bed4cd44b6bed3edca34de2798', '200487', '山东罗欣药业股份有限公司', '阿奇霉素', 0.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '阿奇霉素', '粉针', '0.25g', '1', 'ajms,ejms,aqms,eqms', NULL),
  ('8cfab39efad64a1da64775568a9fe239', '200488', '山东罗欣药业股份有限公司', '氯雷他定', 2.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氯雷他定', '胶囊', '10mg', '6', 'lltd', NULL),
  ('8da40830742e4657884e6179d0ccd891', '200489', '郑州瑞康制药有限公司', '盐酸特拉唑嗪片', 6.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '特拉唑嗪', '片剂', '2mg', '28', 'tlzq', NULL),
  ('8e1d53a6d63c46b8b78365feee416d33', '200490', '拜耳医药保健有限公司', '拜阿司匹灵', 13.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿司匹林', '肠溶片', '0.1g（增加适应症）', '30', 'aspl,espl,asyl,esyl', NULL),
  ('8e42d9d098a3433cac8337f3c737ab1a', '200491', '河南省百泉制药有限公司', '柴胡口服液', 5.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '柴胡口服液', '口服液', '10ml', '10', 'chkfy', NULL),
  ('8e5d807ff8ca4a829a25f4e14d0308c3', '200492', '上海现代哈森(商丘)药业有限公司', '西咪替丁注射液', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '西咪替丁', '注射液', '2ml:0.2g', '1', 'xmtd,xmtz', NULL),
  ('8ed2f8cc77154b40bd3f76ff0cb359c7', '200493', '无锡济民可信山禾药业股份有限公司', '黄氏响声丸', 18.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '黄氏响声丸', '水丸', '0.133g', '108', 'hsxsw,hzxsw', NULL),
  ('8f33724ecc5c4aeebded9cc3bd321ec5', '200494', '国药集团容生制药有限公司', '辅酶A', 0.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '辅酶A', '粉针', '100U', '1', 'fma', NULL),
  ('8f452d16345a4bd78ee6d15e33772c5c', '200495', '云南个旧生物药业有限公司', '顺铂注射液', 9.32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '顺铂', '注射液', '2ml:10mg', '1', 'sb', NULL),
  ('8f8c55351de649579286ba2809a4ff33', '200496', '河北万岁药业有限公司', '脑立清丸', 0.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '脑立清丸', '水丸', '1.1g/10', '100', 'nlqw', NULL),
  ('8fadbcc4fcf44aadb277779355906ba1', '200497', '石药银湖制药有限公司', '红花注射液', 1.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '红花注射液', '注射液', '5ml', '1', 'hhzsy,ghzsy,hhzyy,ghzyy', NULL),
  ('8fb022716f4b4cc6945c2eae867f825b', '200498', '湖南方盛制药股份有限公司', '蒙脱石散', 5.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '蒙脱石', '散剂', '3.0g', '10', 'mts,mtd', NULL),
  ('8fce5c2a18c545369f2dabde73ece92e', '200499', '上海信谊药厂有限公司', '无', 8.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '丙米嗪', '片剂', '25mg', '100', 'bmq', NULL),
  ('8fe9ca1f221e4612b8712007a11934fe', '200500', '湖南科伦制药有限公司', '倍斯平', 1.33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '穿琥宁', '粉针', '0.2g', '1', 'chn', NULL),
  ('90847ff258b440ffbfe0b75150af619e', '200501', '浙江普洛康裕天然药物有限公司', '雷公藤多苷片', 9.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '雷公藤多甙片', '片剂', '10mg', '50', 'lgtddp', NULL),
  ('90ac734f3b7a4f8eaada414d58e8e0ed', '200502', '常州四药制药有限公司', '美托洛尔', 4.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '美托洛尔', '片剂', '25mg', '20', 'mtle', NULL),
  ('90bbfaa46f4f47bc83ec517f84d438cb', '200503', '太极集团重庆涪陵制药厂有限公司', '急支颗粒', 12.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '急支颗粒', '颗粒剂', '4g', '12', 'jzkl', NULL),
  ('9c9fec88fbc64ab3a6a0ff7ae0ae392c', '200504', '海口市制药厂有限公司', '盐酸克林霉素注射液', 7.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '盐酸克林霉素注射液', '注射液', '2ml:0.15g', '10', 'ysklmszyy,ysklmszsy', NULL),
  ('9ca85be39b0644a5ace19ea5e0324d85', '200505', '神威药业集团有限公司', '茵栀黄注射液', 1.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '茵栀黄注射液', '注射液', '10ml', '1', 'yzhzsy,yzhzyy', NULL),
  ('9cd0981bc9614e1c9ad62d36e35a1972', '200506', '湖南汉森制药股份有限公司', '缩泉胶囊', 33.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '缩泉胶囊', '胶囊', '0.3g', '60', 'sqjn', NULL),
  ('9ce45cd8150e4c69ba897da6039bf383', '200507', '河南太龙药业股份有限公司', '双黄连合剂', 5.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '双黄连合剂', '口服液', '100ml', '1', 'shlgj,shlhj', NULL),
  ('9cef6b129d2f4cbd8380b2a1414cfc1b', '200508', '安徽安科余良卿药业有限公司', '狗皮膏', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '狗皮膏', '膏药', '15g', '10', 'gpg', NULL),
  ('9d01fac0f77e44f3b073d99417000a86', '200509', '广西玉林制药集团有限责任公司', '无', 10.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '三七伤药胶囊', '胶囊', '0.25g', '24', 'sqsyjn', NULL),
  ('9d048f7b37c04cc7aca2625b1d4ad5ad', '200510', '河南科伦药业有限公司', '5%葡萄糖', 1.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '5%葡萄糖', '大输液', '250ml(塑瓶)', '1', '5%ptt', NULL),
  ('9d628616e28a477b99caacd4d2275b14', '200511', '昆明制药集团', '血塞通注射液', 1.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '血塞通注射液', '注射液', '2ml:0.1g', '10', 'xstzyy,xstzsy', NULL),
  ('9dc2b134053e4feeb3c54d0d51b410e9', '200512', '山东罗欣药业股份有限公司', '叶酸', 13.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '叶酸', '粉针', '30mg', '1', 'xs,ys', NULL),
  ('9e1c7893d13c477c9342783a7ce57e26', '200513', '常州康普药业有限公司', '苯海索', 2.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '苯海索', '片剂', '2mg', '100', 'bhs', NULL),
  ('9e40273bc8044750811bb91dddb9531f', '200514', '齐鲁制药有限公司', '氯氮平片', 1.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '氯氮平', '片剂', '25mg', '100', 'ldp', NULL),
  ('9e51e06f8b9e495997521e54e9918bc4', '200515', '天津药业集团新郑股份有限公司', '无', 0.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '雷尼替丁', '注射液', '2ml:50mg', '1', 'lntd,lntz', NULL),
  ('9f7e1b49a6644244b7734cefab44d98e', '200516', '上海美优制药有限公司', '复方甘草口服溶液', 5.37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '复方甘草合剂', '口服液', '10ml', '10', 'ffgcgj,ffgchj', NULL),
  ('9ffd740773534ce48341843651c4b1da', '200517', '河南禹州市药王制药有限公司', '香砂养胃丸', 3.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '香砂养胃丸', '水丸', '6g', '10', 'xsyww', NULL),
  ('a01f09d252b348c48a89dbc1721a12e3', '200518', '天津药业集团有限公司', '无', 0.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '鱼石脂', '软膏剂', '10g:1g', '1', 'ysz,ydz', NULL),
  ('a13b4d6d47a544d49291a1a5140cf6be', '200519', '山东罗欣药业股份有限公司', '洛伐他汀', 2.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '洛伐他汀', '片剂', '20mg', '10', 'lftt', NULL),
  ('a1893931748a472f8f5f1ffdb2ceff91', '200520', '山东方明药业集团股份有限公司', '无', 6.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '单硝酸异山梨酯', '片剂', '20mg', '48', 'cxsyslz,sxsyslz,dxsyslz', NULL),
  ('a1983f6ce18b463c8fe3b8d41b38720d', '200521', '四川禾润制药有限公司', '小柴胡颗粒', 1.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '小柴胡颗粒', '颗粒剂', '10g', '6', 'xchkl', NULL),
  ('a22fd0807ea44f7caf0c24ccc1149d9a', '200522', '河南天方药业股份有限公司', '麦克罗辛', 5.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '盐酸二甲双胍缓释片', '缓释片', '0.5g', '24', 'ysejsghsp', NULL),
  ('a23997cfd6e74835a6d0f8859cdcb13c', '200523', '上海现代哈森(商丘)药业有限公司', '门冬氨酸钾镁注射液', 0.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '门冬氨酸钾镁', '注射液', '10ml:0.452g:0.4g', '1', 'mdasjm', NULL),
  ('a239a1a29d004b5daeb6ea9b7b7b0385', '200524', '宜昌人福药业有限责任公司', '甲硝唑片', 1.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '甲硝唑', '片剂', '0.2g', '100', 'jxz', NULL),
  ('a28cf1908f8540c3bc69ebe52f59bf6e', '200525', '苏州二叶制药有限公司', '苯唑西林', 0.93, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '苯唑西林', '粉针', '1.0g', '1', 'bzxl', NULL),
  ('a2c2e925e89a4b7dbcfcabce50fb2055', '200526', '齐鲁制药有限公司', '洛伐他汀分散片', 14.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '洛伐他汀', '分散片', '20mg', '12', 'lftt', NULL),
  ('a31ca46bcb91441d89ca190cb68358a6', '200527', '华中药业股份有限公司', '泼尼松龙', 1.29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '泼尼松龙', '注射液', '5ml:0.125g', '1', 'pnsl', NULL),
  ('a37caa4cce7642078c5a7ea8f133c19e', '200528', '河南同源制药有限公司', '维生素C', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维生素C', '注射液', '2ml:0.1g', '1', 'wssc', NULL),
  ('0bc5fbcc037e4ed08d803f060a10a62d', '200220', '亚宝药业集团股份有限公司', '亚宝力维', 6.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '甲钴胺', '片剂', '0.5mg', '20', 'jga', NULL),
  ('0bf087a5ab8a49c6b5cbbffe953bd1ff', '200221', '西南药业股份有限公司', '散列通', 5.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '复方对乙酰氨基酚(II)', '片剂', '对乙酰氨基酚0.25g:无水咖啡因50mg:异丙安替比林0.15g', '10', 'ffdyxajf(ii)', NULL),
  ('0c437a8b2ef94d77b8e332516be8bf8b', '200222', '广州白云山天心制药股份有限公司', '施迪欣', 5.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '阿莫西林/克拉维酸钾', '粉针', '0.3g(5:1)', '1', 'emxl/klwsj,amxl/klwsj', NULL),
  ('0cc65179571d4bf79288241a9c8b5c09', '200223', '武汉五景药业有限公司', '利福平', 0.62, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '利福平', '滴眼液', '10ml:5mg', '1', 'lfp', NULL),
  ('0ce5764adb6942089d8656c038d5fd55', '200224', '江苏亚邦爱普森药业有限公司', '盐酸左氧氟沙星滴眼液', 4.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '左氧氟沙星', '滴眼液', '5ml:15mg', '1', 'zyfsx', NULL),
  ('0d66d3b2c5c44a6b86c41005cc69e0d6', '200225', '东药集团沈阳施德药业有限公司', '泰洛平', 25.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '吡格列酮', '胶囊', '15mg', '20', 'pglt,bglt', NULL),
  ('0d96f45f6023450daef5bacb8c2b8be4', '200226', '天津药业集团新郑股份有限公司', '无', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '肾上腺素', '注射液', '1ml:1mg', '1', 'ssxs', NULL),
  ('0da3e9def2ad4002bb1ffce8324cd9eb', '200227', '雷允上药业有限公司', '六神丸', 10.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '六神丸', '水丸', '10(3.125g/1000)', '6', 'lsw', NULL),
  ('0dc9b8d94643428488fbc7bcf6826a84', '200228', '武汉人福药业有限责任公司', '迪尔诺', 2.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '布洛芬', '混悬液', '25ml:0.5g', '1', 'blf', NULL),
  ('0df54ee3f0aa4b339b7b81569938e792', '200229', '山东健康药业有限公司', '咪康唑', 1.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '咪康唑', '软膏剂', '10g:0.2g', '1', 'mkz', NULL),
  ('0e64c6a4e76f45ea9cead3cb44a6319a', '200230', '湖南千金湘江药业股份有限公司', '缬沙坦', 7.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '缬沙坦', '胶囊', '80mg', '7', 'xst', NULL),
  ('0f28ec9fcd8c4f90af5bea7253edb026', '200231', '通化东宝药业股份有限公司', '甘舒霖30R', 46.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '30/70混合重组人胰岛素', '注射液', '10ml:400IU', '1', '30/70hhczryds,30/70hgzzryds,30/70hgczryds,30/70hhzzryds', NULL),
  ('0f2b57c01238482ea8eb816081782baf', '200232', '广东益和堂制药有限公司', '无', 3.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '槐角丸', '水蜜丸', '60g', '1', 'hjw', NULL),
  ('0f4cd71400ff400c9ae752518a529199', '200233', '辅仁药业集团有限公司', '双嘧达莫', 1.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '双嘧达莫', '片剂', '25mg', '100', 'smdm', NULL),
  ('0f71ca345cee465e8d7898f7fd5589b2', '200234', '马鞍山丰原制药有限公司', '缩宫素', 0.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '缩宫素', '注射液', '1ml:10U', '1', 'sgs', NULL),
  ('0f81075ffd8149a5be9953850820a6f2', '200235', '亚宝药业集团股份有限公司', '葛根素', 1.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '葛根素', '注射液', '5ml:0.2g', '1', 'ggs', NULL),
  ('0fa4efc77f6941acbf690c5e6c793d92', '200236', '苏州第三制药厂有限责任公司', '尼莫地平胶囊', 3.54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '尼莫地平', '胶囊', '20mg', '50', 'nmdp', NULL),
  ('10eaea9fbd434bf39096cf6268057445', '200237', '深圳信立泰药业股份有限公司', '信希汀', 26.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢西丁', '粉针', '1.0g', '1', 'tbxd,tbxz', NULL),
  ('1115dd8d105940d99a93c52a849b1735', '200238', '河南百年康鑫药业有限公司', '黄连上清丸', 3.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '黄连上清丸', '水丸', '6g', '10', 'hlsqw', NULL),
  ('1136d643e1ce4e5dac51bf0f471ee73c', '200239', '山东罗欣药业股份有限公司', '罗欣快宇', 1.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿奇霉素', '颗粒剂', '0.1g', '4', 'ajms,ejms,aqms,eqms', NULL),
  ('113ed8a58b904d399f2b8953f3c511d6', '200240', '芜湖张恒春药业有限公司', '香砂六君丸', 3.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '香砂六君丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'xsljw', NULL),
  ('1163be770fac40ffbd89ec681d13ac07', '200241', '河南太龙药业股份有限公司', '10%葡萄糖', 1.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '10%葡萄糖', '大输液', '500ml', '1', '10%ptt', NULL),
  ('11af73a58269462b958d5e6ab7e78b17', '200242', '江西银涛药业有限公司', '布洛芬胶囊', 1.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '布洛芬', '胶囊', '0.2g', '20', 'blf', NULL),
  ('1203a215994e4948a5c718c180ba6d6f', '200243', '杭州民生药业有限公司', '无', 2.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '山莨菪碱', '片剂', '5mg', '100', 'sldj', NULL),
  ('120d5e41f9634390b3112a1f43fd5b9e', '200244', '广东环球制药有限公司', '/', 14.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '生脉胶囊', '胶囊', '/', '30', 'smjn', NULL),
  ('135c294b1178417aa22a99873a2fe647', '200245', '天津金耀集团湖北天药药业股份有限公司', '利巴韦林', 0.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '利巴韦林', '注射液', '2ml:0.25g', '1', 'lbwl', NULL),
  ('1369c8e22f4d46e7aac6c875bc546d0a', '200246', '山西杨文水', '银翘解毒丸', 3.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银翘解毒丸', '大蜜丸', '9g', '10', 'yqjdw,yqxdw', NULL),
  ('1374ac5a82d547c48ec9def9d6488511', '200247', '山东华鲁制药有限公司', '非诺贝特胶囊', 2.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '非诺贝特', '胶囊', '0.1g', '20', 'fnbt', NULL),
  ('147104c23dcc4de78a464f40248c9283', '200248', '上海禾丰制药有限公司', '洛贝林', 0.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '洛贝林', '注射液', '1ml:3mg', '1', 'lbl', NULL),
  ('14cd5dea3eff4f11919fa13667045a43', '200249', '开封制药(集团)有限公司', '50%葡萄糖', 0.26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '50%葡萄糖', '注射液', '20ml', '1', '50%ptt', NULL),
  ('16118b75471343d5b2a7a5e72ee22612', '200250', '浙江众益药业有限公司', '盐酸环丙沙星胶囊', 1.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '环丙沙星', '胶囊', '0.25g', '10', 'hbsx', NULL),
  ('16162f8aaebc49d0a00ffc3d8d60a7c9', '200251', '湖北诺得胜制药有限公司', '天王补心丸', 3.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '天王补心丸', '水蜜丸', '60g', '1', 'twbxw', NULL),
  ('175f0c9d3f2e4d8a8e6cb8eedceebda6', '200252', '河南天方药业股份有限公司', '曲克芦丁', 4.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '曲克芦丁', '片剂', '60mg', '100', 'qklz,qkld', NULL),
  ('1777a34e931a4d4b9b0e3e80752252da', '200253', '河北神威药业有限公司', '清开灵注射液', 1.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '清开灵注射液', '注射液', '10ml', '1', 'qklzsy,qklzyy', NULL),
  ('17c2b806bb0b46ebaaf482d40457cb34', '200254', '百善（唐山）药业有限公司', '人参健脾片', 16.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '人参健脾片', '片剂', '0.25g', '24', 'rcjpp,rsjpp', NULL),
  ('18162392eecc40dead7ec721644096a5', '200255', '亚宝药业大同制药有限公司', '牛黄上清丸', 2.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '牛黄上清丸', '大蜜丸', '6g', '10', 'nhsqw', NULL),
  ('1817b2127f5549fc8ad7d5579778208b', '200256', '成都康弘制药有限公司', '松龄血脉康胶囊', 49.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '松龄血脉康胶囊', '胶囊', '0.5g', '60', 'slxmkjn', NULL),
  ('18b869252b814daca4b06dc363d11f5a', '200257', '四川禾润制药有限公司', '元胡止痛片', 4.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '元胡止痛片', '片剂', '/', '100', 'yhztp', NULL),
  ('18e228817fb745fa8cfd1e0c025aa6e9', '200258', '上海现代制药股份有限公司', '依那普利', 3.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '依那普利', '片剂', '5mg', '16', 'ynpl', NULL),
  ('6979e47cb0674b1aa00664b666fa1412', '200259', '华北制药股份有限公司', '注射用头孢噻肟钠', 0.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢噻肟', '粉针', '1.0g', '1', 'tbsw', NULL),
  ('6a516d400b4846fda944c50241518ff9', '200260', '哈尔滨圣泰生物制药有限公司', '血栓通', 2.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '血栓通', '注射液', '2ml:70mg', '1', 'xst', NULL),
  ('6a941e35409542438460ac93788eaaed', '200261', '浙江众益药业有限公司', '门冬氨酸钾镁片', 7.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '门冬氨酸钾镁', '片剂', '无水门冬氨酸钾79mg:无水门冬氨酸镁70mg', '100', 'mdasjm', NULL),
  ('6b44848eaee14786b6165f3adbd8e06b', '200262', '河南科伦药业有限公司', '10%葡萄糖', 1.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '10%葡萄糖', '大输液', '500ml(塑瓶)', '1', '10%ptt', NULL),
  ('6bdaf0e4a68e49a0a4ed2986e2443a74', '200263', '杭州民生药业有限公司', '螺内酯', 6.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '螺内酯', '片剂', '20mg', '100', 'lnz', NULL),
  ('6d308572837645bcb7a0c5f37d09fd55', '200264', '山东方明药业集团股份有限公司', '维A酸乳膏', 7.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维A酸', '乳膏剂', '15g:15mg', '1', 'was', NULL),
  ('6d77a12479a74f778d7916297c24ce1a', '200265', '山西正元盛邦制药有限公司', '养阴清肺丸', 4.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '养阴清肺丸', '大蜜丸', '9g', '10', 'yyqfw', NULL),
  ('6db80c96679f4546a5da693ddb534b64', '200266', '江西佑美制药有限公司', '三七伤药片', 4.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '三七伤药片', '片剂', '0.3g', '36', 'sqsyp', NULL),
  ('6e0ff7c60c6e4abeac9373a36e8899fd', '200267', '安徽新和成皖南药业有限公司', '地塞米松', 0.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '地塞米松', '乳膏剂', '10g:5mg', '1', 'dsms', NULL),
  ('6e90f5d6b51f4f28903c5e13a58cbcdc', '200268', '广东环球制药有限公司', '/', 23.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '玉屏风颗粒', '颗粒剂', '5g', '15', 'ypfkl,ybfkl', NULL),
  ('6ed9ed461c1a4b74912391c2457eae21', '200269', '开封制药(集团)有限公司', '卡托普利', 1.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '卡托普利', '片剂', '25mg', '100', 'ktpl,qtpl', NULL),
  ('6fe789f257994e1bae3199b484596aa0', '200270', '上海旭东海普药业有限公司', '舒可捷', 13.53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '硫糖铝', '混悬液', '5ml:1.0g', '12', 'ltl', NULL),
  ('6ff4a2a459a34b1f88a4cc77777a9648', '200271', '石药集团中诺药业(石家庄)有限公司', '中诺新', 11.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '地尔硫卓', '粉针', '10mg', '1', 'delz', NULL),
  ('7087e11ce08548aa8197a7f0a83330ea', '200272', '广东科伦药业有限公司', '柳氮磺吡啶', 17.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '柳氮磺吡啶', '栓剂', '0.5g', '6', 'ldhpd,ldhbd', NULL),
  ('716b6cf33408448ca41a20a8e50aa30d', '200273', '开封制药(集团)有限公司', '枸橼酸喷托维林片', 2.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '枸橼酸喷托维林片', '片剂', '25mg', '100', 'jysptwlp,gysptwlp', NULL),
  ('719ea6ea93e94eaea17835fa429f032b', '200274', '浙江一新制药股份有限公司', '必利那', 19.94, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '依那普利', '胶囊', '5mg', '36', 'ynpl', NULL),
  ('71d543e7dd524aae8f5b576505fa57b8', '200275', '四川科伦药业股份有限公司', '阿昔洛韦片', 2.22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿昔洛韦片', '片剂', '0.1g', '24', 'axlwp,exlwp', NULL),
  ('72171a6bb3a04fd8a7c5076322fd4262', '200276', '湖南五洲通药业有限责任公司', '氧氟沙星', 2.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氧氟沙星', '粉针', '0.4g', '1', 'yfsx', NULL),
  ('72972e11db6c41ad945ad3d45b5d0a59', '200277', '贵州同济堂制药有限公司', '仙灵骨葆胶囊', 28.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '仙灵骨葆胶囊', '胶囊', '0.5g', '40', 'xlgbjn', NULL),
  ('72a266d54e5e4f5ebe47837ea6b030ac', '200278', '武汉中联集团四药药业有限公司', '酮康唑胶囊', 5.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '酮康唑', '胶囊', '0.2g', '12', 'tkz', NULL),
  ('72e7844eae97404ab5fff33a99e8eb14', '200279', '上海现代哈森(商丘)药业有限公司', '曲克芦丁注射液', 0.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '曲克芦丁', '注射液', '2ml:60mg', '1', 'qklz,qkld', NULL),
  ('731eae09c63d40d78eda5620eef75cd8', '200280', '湖南百草制药有限公司', '头孢拉定片', 5.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢拉定', '片剂', '0.25g', '24', 'tbld', NULL),
  ('7369bed2e64242d49c17bb8eebc90627', '200281', '四川升和药业股份有限公司', '参麦注射液', 1.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '参麦注射液', '注射液', '2ml', '1', 'smzyy,cmzsy,cmzyy,smzsy', NULL),
  ('73b1dc51f66143c99bb85d42339de4f5', '200282', '上海复旦复华药业有限公司', '酚妥拉明', 1.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '酚妥拉明', '粉针', '10mg', '1', 'ftlm', NULL),
  ('73ea12afacd84cf098c054558b5122d6', '200283', '河南科伦药业有限公司', '0.9%氯化钠', 0.93, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '0.9%氯化钠', '大输液', '100ml(塑瓶)', '1', '0.9%lhn', NULL),
  ('73f7360a9d404946af74451701456de1', '200284', '武汉福星生物药业有限公司', '甲硝唑', 1.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '甲硝唑', '大输液', '250ml:1.25g', '1', 'jxz', NULL),
  ('7403a26afc0d43cd835edbdf32c4ca25', '200285', '上海爱的发制药有限公司', '利必非', 31.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '非诺贝特', '缓释胶囊', '0.25g', '10', 'fnbt', NULL),
  ('7447ffa30c4d4408b35265d5606e4c5d', '200286', '河南省宛西制药股份有限公司', '藿香正气丸', 6.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '藿香正气丸', '水丸', '6g', '10', 'hxzqw', NULL),
  ('7472990959574422a0e6073fe593ce77', '200287', '河南天方药业股份有限公司', '麦克罗辛', 7.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '二甲双胍', '缓释片', '0.5g', '32', 'ejsg', NULL),
  ('74b02231f3e64abaa36cc0a31fc95d8a', '200288', '辰欣药业股份有限公司', '中/长链脂肪乳(C8-24)注射液', 81.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '中/长链脂肪乳(C8-24)', '大输液', '250ml(20%)', '1', 'z/clzfr(c8-24),z/zlzfr(c8-24)', NULL),
  ('756b8b3211784943a1384ef8c24c0ea6', '200289', '浙江震元制药有限公司', '泰罗', 1.09, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '罗红霉素', '片剂', '0.15g', '6', 'lgms,lhms', NULL),
  ('7578ce34534046f8b2da7ab29d13b1e4', '200290', '西南药业股份有限公司', '布洛芬', 3.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '布洛芬', '缓释片', '0.3g', '10', 'blf', NULL),
  ('757ba73b9a5b40409fd5648b70a31c88', '200291', '陕西步长制药有限公司', '脑心通胶囊', 33.66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '脑心通胶囊', '胶囊', '0.4g', '48', 'nxtjn', NULL),
  ('7634afa372764b959aea15e1e1c7b431', '200292', '江西药都樟树制药有限公司', '杞菊地黄丸', 2.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '杞菊地黄丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'qjdhw', NULL),
  ('76785f61dc3348de906fd6e72f223303', '200293', '石药集团中诺药业(石家庄)有限公司', '氨苄西林', 0.32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氨苄西林', '粉针', '0.5g', '1', 'abxl', NULL),
  ('769cae6d859d4aef980cc76eb759a694', '200294', '四川科伦药业股份有限公司', '葡萄糖注射液', 2.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '葡萄糖注射液', '大输液', '100ml：5g(塑瓶)', '1', 'pttzyy,pttzsy', NULL),
  ('76d15eb3b7fa4bd8a033dc7476ae14cd', '200295', '上海黄海制药有限责任公司', '氯化钾', 4.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氯化钾', '缓释片', '0.5g', '24', 'lhj', NULL),
  ('7733abc9a10c402cb433e4d2c502ff1c', '200296', '广州白云山明兴制药有限公司', '清开灵颗粒', 15.36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '清开灵颗粒', '颗粒剂', '3g', '12', 'qklkl', NULL),
  ('776f4381510a416f87567e4d0aaa2a4c', '200297', '华北制药股份有限公司', '注射用头孢噻肟钠', 0.66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢噻肟', '粉针', '0.5g', '1', 'tbsw', NULL),
  ('777a66de1d854a288f500a5e2540a4af', '200298', '湖北航天杜勒制药有限公司', '复方氨基酸注射液18AA', 13.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '复方氨基酸(18AA)', '大输液', '250ml:30g', '1', 'ffajs(18aa)', NULL),
  ('77ced6cdf88e4e1aac57cd948b91b92c', '200299', '河南康祺药业股份有限公司', '龙胆泻肝丸', 2.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '龙胆泻肝丸', '水丸', '6g', '10', 'ldxgw', NULL),
  ('781f949b0cf74aa58b072a0551dc11f2', '200300', '山东方明药业集团股份有限公司', '维A酸乳膏', 5.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维A酸', '乳膏剂', '15g:3.75mg', '1', 'was', NULL),
  ('785bfdec61c347adaed1f9c470dfdfff', '200301', '石药集团中诺药业(石家庄)有限公司', '中诺立新', 1.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢呋辛', '粉针', '0.75g', '1', 'tbfx', NULL),
  ('78b962622aa24e7c83e8584faefa481f', '200302', '天津金耀集团湖北天药药业股份有限公司', '三磷酸腺苷二钠', 0.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '三磷酸腺苷二钠', '注射液', '2ml:20mg', '1', 'slsxgen', NULL),
  ('78e321aca48344c49993b22679d53aca', '200303', '东北制药集团沈阳第一制药有限公司', '无', 1.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '磷霉素钠', '粉针', '1.0g', '1', 'lmsn', NULL),
  ('79c107fc0ac64c91ac4dd1c426548fc9', '200304', '上海普康药业有限公司', '熊去氧胆酸', 6.13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '熊去氧胆酸', '片剂', '50mg', '30', 'xqyds', NULL),
  ('7a679107a4b645938014f4a9c7b5713c', '200305', '浙江亚太药业股份有限公司', '普罗帕酮', 2.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '普罗帕酮', '片剂', '50mg', '100', 'plpt', NULL),
  ('7b65916811354281b4a3adad9f49a596', '200306', '广州白云山明兴制药有限公司', '东莨菪碱', 0.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '东莨菪碱', '注射液', '1ml:0.3mg', '1', 'dldj', NULL),
  ('7c0717abaea842838c18e50ac4a1cb5d', '200307', '石药银湖制药有限公司', '舒血宁注射液', 6.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '舒血宁注射液', '注射液', '5ml', '1', 'sxnzyy,sxnzsy', NULL),
  ('7c0f6d5dbcad4121aff8a2187e9af4cf', '200308', '河南润弘制药股份有限公司', '无', 0.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '硝酸甘油', '注射液', '1ml:5mg', '1', 'xsgy', NULL),
  ('7c177a1e82854d69868316e41478e6a8', '200309', '上海现代制药股份有限公司', '欣然', 15.23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '硝苯地平控释片', '控释片', '30mg', '6', 'xbdpksp', NULL),
  ('7d205d31529a4eca8e2919f18804c4e3', '200310', '辅仁药业集团有限公司', '枸橼酸铋钾', 9.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '枸橼酸铋钾', '胶囊', '0.3g(0.11g)', '40', 'jysbj,gysbj', NULL),
  ('7d4096abe3db4af9a8c1f03bfec13105', '200311', '上海旭东海普药业有限公司', '无', 4.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '曲安奈德', '注射液', '5ml:50mg', '1', 'qand', NULL),
  ('7deae9b879cb49079cc8018e02b0896c', '200312', '浙江天瑞药业有限公司', '氯化钾', 0.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氯化钾', '注射液', '10ml:1.5g', '1', 'lhj', NULL),
  ('7dedadad3512487d937e9e383f543c50', '200313', '石家庄四药有限公司', '无', 5.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '地尔硫卓', '片剂', '30mg', '60', 'delz', NULL),
  ('7e52483bc4304e6ea37e8ece76d77eb4', '200314', '四川依科制药有限公司', '多酶', 2.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '多酶', '片剂', '胰酶0.3g:胃蛋白酶13mg', '100', 'dm', NULL),
  ('7e6d914cf1ee441dac78054e60c2f9f8', '200315', '山东健康药业有限公司', '氟桂利嗪', 9.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '氟桂利嗪', '片剂', '5mg', '40', 'fglq', NULL),
  ('7e6f21748f5d4688960553dc6d42fe0a', '200316', '华润三九医药股份有限公司', '补脾益肠丸', 11.13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '补脾益肠丸', '水蜜丸', '90g', '1', 'bpycw', NULL),
  ('7efd9e96bd6b424ab180f930a683fb34', '200317', '河南润弘制药股份有限公司', '无', 0.22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '门冬氨酸钾镁', '注射液', '10ml:0.85g:0.114g:42mg', '1', 'mdasjm', NULL),
  ('7f216de2f4af450d9a39b67907c5aec6', '200318', '重庆科瑞制药（集团）有限公司', '利巴韦林', 2.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '利巴韦林', '片剂', '0.1g', '20', 'lbwl', NULL),
  ('7fd4aed67c3243529ce270a2a363583b', '200319', '华润三九医药股份有限公司', '三九胃泰颗粒', 14.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '三九胃泰颗粒', '颗粒剂', '2.5g（无糖型）', '10', 'sjwtkl', NULL),
  ('7fdd90eab1ac4055b95380e678b65c30', '200320', '江西药都仁和制药有限公司', '杞菊地黄丸', 3.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '杞菊地黄丸', '水蜜丸', '6g', '10', 'qjdhw', NULL),
  ('7ffa850b596b4334ad0d413002226c67', '200321', '江苏万邦生化医药股份有限公司', '精蛋白锌胰岛素', 12.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '精蛋白锌胰岛素', '注射液', '10ml:400IU', '1', 'jdbxyds', NULL),
  ('80160429d3a34e36805a2592b31e8883', '200322', '上海福达制药有限公司', '左旋多巴', 15.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '左旋多巴', '片剂', '0.25g', '100', 'zxdb', NULL),
  ('811874538aab425a8bf65e209888a71f', '200323', '安徽福康药业有限责任公司', '益母草膏', 6.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '益母草膏', '煎膏剂', '250g', '1', 'ymcg', NULL),
  ('81286286ef2a42ab9d557deecca0366b', '200324', '北京嘉林药业股份有限公司', '胺碘酮', 9.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '胺碘酮', '片剂', '0.2g', '24', 'adt', NULL),
  ('815082459c1a43b5a6f00dd9d4222b0b', '200325', '河南太龙药业股份有限公司', '葡萄糖氯化钠', 1.26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '葡萄糖氯化钠', '大输液', '500ml', '1', 'pttlhn', NULL),
  ('8184e03103ac4ed2a9f6850db5cde399', '200326', '华夏药业集团有限公司原(华夏药业有限公司)', '元坦', 19.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '格列吡嗪分散片', '分散片', '5mg', '40', 'glbqfsp,glpqfsp', NULL),
  ('82678db3ce444b9a9d2812a65bd5d929', '200327', '广州白云山明兴制药有限公司', '普罗帕酮', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '普罗帕酮', '注射液', '10ml:35mg', '1', 'plpt', NULL),
  ('826fcc8916f840c5a1d35e85832d5612', '200328', '成都锦华药业有限责任公司', '阿莫西林胶囊', 2.53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿莫西林', '胶囊', '0.125g', '50', 'amxl,emxl', NULL),
  ('8275157efe7b47a7b635f3f573c75075', '200329', '辰欣药业股份有限公司', '红霉素软膏', 0.54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '红霉素', '软膏剂', '10g:0.1g(1%)', '1', 'hms,gms', NULL),
  ('8291628c992f46be881786de8cf342ee', '200330', '上海通用药业股份有限公司', '丙酸睾酮注射液', 0.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '丙酸睾酮', '注射液', '1ml:25mg', '1', 'bsgt', NULL),
  ('83ca759a00e0479c8b303f0b83dcd936', '200331', '辰欣药业股份有限公司', '克霉唑', 0.62, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '克霉唑', '软膏剂', '10g:0.3g(3%)', '1', 'kmz', NULL),
  ('8401e81d57e744adb455003d1c4a0293', '200332', '安阳市华安药业有限责任公司', '冬凌草片', 6.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '冬凌草片', '片剂', '0.25g', '100', 'dlcp', NULL),
  ('853f86f2e9e548cb99c564d12cfd93ed', '200333', '湖北汇瑞药业股份有限公司', '吲达帕胺缓释片', 17.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '吲哒帕胺', '缓释片', '1.5mg', '30', 'ydpa', NULL),
  ('8540fbc178594e95906e38780da970a4', '200334', '天津药业集团新郑股份有限公司', '无', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '灭菌注射用水', '注射液', '5ml', '1', 'mjzyys,mjzsys', NULL),
  ('855a471edd20484c996f821595d1c064', '200335', '江西药都樟树制药有限公司', '归脾丸', 3.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '归脾丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'gpw', NULL),
  ('8579112e67534c49bc3881d984844b14', '200336', '成都恒瑞制药有限公司', '亦明', 12.47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '克拉霉素', '分散片', '0.125g', '12', 'klms', NULL),
  ('85832d2699734e398118c86c90fc9e41', '200337', '天津红日药业股份有限公司', '博璞青', 28.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '低分子肝素钙', '注射液', '0.6ml:6000AXaIU', '1', 'dfzgsg', NULL),
  ('8588889818184c5b84c7ae2dccc288f3', '200338', '天津中新药业集团股份有限公司乐仁堂制药厂', '乌鸡白凤片', 26.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '乌鸡白凤片', '片剂', '0.5g', '24', 'wjbfp', NULL),
  ('85aa0dec365b4f248abfb631761486e0', '200339', '石药集团中诺药业(石家庄)有限公司', '舒配', 1.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢噻肟', '粉针', '2.0g', '1', 'tbsw', NULL),
  ('ea4d687bdc35455dbb2cb891893397d1', '200340', '亚宝药业集团股份有限公司', '莫沙必利', 17.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '莫沙必利', '片剂', '5mg', '24', 'msbl', NULL),
  ('ea64ed5a06354f2a8884e93a65d79cde', '200341', '广西梧州制药集团股份有限公司', '注射用血栓通', 33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '注射用血栓通', '冻干粉针剂', '0.15g', '1', 'zsyxst,zyyxst', NULL),
  ('ea9d86cd77e44763b20a0c8f39cb3f7e', '200342', '黑龙江科伦制药有限公司', '环丙沙星氯化钠', 0.84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '环丙沙星氯化钠', '大输液', '100ml:0.2g', '1', 'hbsxlhn', NULL),
  ('eab3812405074c899ef53f207c955683', '200343', '浙江普洛康裕天然药物有限公司', '板蓝根颗粒', 4.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '包', '板蓝根颗粒', '颗粒剂', '3g', '20', 'blgkl', NULL),
  ('eb498b7eb0254a109ca8cfe3a8477d6b', '200344', '宜昌长江药业有限公司', '阿奇霉素', 2.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿奇霉素', '分散片', '0.25g', '6', 'ajms,ejms,aqms,eqms', NULL),
  ('eb9128117118467d88446139bde1542a', '200345', '浙江康恩贝制药股份有限公司', '前列康', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '普乐安胶囊', '胶囊', '0.375g', '120', 'plajn,pyajn', NULL),
  ('eba67f8a507b4ea992371e874bb7a463', '200346', '重庆科瑞制药（集团）有限公司', '阿奇霉素', 3.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿奇霉素', '片剂', '0.125g', '12', 'ajms,ejms,aqms,eqms', NULL),
  ('ec18ce5788264824b8896c14fa3b8bc2', '200347', '上海旭东海普药业有限公司', '无', 6.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '辅酶Q10', '胶囊', '10mg', '60', 'fmq10', NULL),
  ('ec19b738a1b64f7ba253c4b0c89ddef0', '200348', '天津力生制药股份有限公司', '甲睾酮', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '甲睾酮', '片剂', '5mg', '100', 'jgt', NULL),
  ('ed4f138d412a4283b802e387513b324a', '200349', '四川升和药业股份有限公司', '银黄颗粒', 2.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银黄颗粒', '颗粒剂', '4g', '10', 'yhkl', NULL),
  ('edcb314a41d24d608514eec9ae3c0ae4', '200350', '河北天成药业股份有限公司', '阿司匹林肠溶片', 0.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '阿司匹林', '肠溶片', '25mg', '100', 'aspl,espl,asyl,esyl', NULL),
  ('edfe3f293efe4c6b87cf831770583c86', '200351', '江西南昌济生制药厂', '板蓝根颗粒', 5.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '袋', '板蓝根颗粒', '颗粒剂', '10g', '24', 'blgkl', NULL),
  ('b1aafb82f3594c7da158d501a7bf7265', '200572', '济南利民制药有限责任公司', '浓氯化钠注射液', 0.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '浓氯化钠注射液', '注射液', '10ml', '5', 'nlhnzyy,nlhnzsy', NULL),
  ('b20e96632ed54c02b038216320e30efe', '200573', '辽宁华润本溪三药有限公司', '气滞胃痛颗粒', 20.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '气滞胃痛颗粒', '颗粒剂', '2.5g(无糖型)', '12', 'qzwtkl', NULL),
  ('b32d10f7a49a4012a9319b6eefbf82e8', '200574', '西南药业股份有限公司', '氨茶碱', 4.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氨茶碱', '缓释片', '0.1g', '20', 'acj', NULL),
  ('b36893914bd744ff9801f670d271afdb', '200575', '北京双鹭药业股份有限公司', '雷宁', 13.13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氯雷他定', '分散片', '10mg', '6', 'lltd', NULL),
  ('b3d9abd4d89446f5abd484b2de52a874', '200576', '佛山德众药业A', '银翘解毒片', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银翘解毒片', '片剂', '0.52g*12s*2板 薄膜衣', '1', 'yqjdp,yqxdp', NULL),
  ('b3f0d8f877ee4ae6b4cd3b30355b5de2', '200577', '北京赛升药业股份有限公司', '注射用葛根素', 9.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '葛根素', '粉针', '0.1g', '1', 'ggs', NULL),
  ('b41ca64433f048e19c3ea784abdd10c1', '200578', '齐鲁制药有限公司', '舒必利片', 4.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '舒必利', '片剂', '0.1g', '100', 'sbl', NULL),
  ('b42ac170d1624e38b6a097ea19b462de', '200579', '辅仁药业集团有限公司', '红霉素', 8.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '红霉素', '肠溶片', '0.125g', '100', 'hms,gms', NULL),
  ('b464078d5d704b67884d5698130d96d4', '200580', '江西泽众制药股份有限公司', '鲜竹沥', 1.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '鲜竹沥', '口服液', '10ml', '6', 'xzl', NULL),
  ('b49bc84560614bc5af94f4b4eec87837', '200581', '莱阳永康制药有限公司', '丹栀逍遥丸', 4.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '丹栀逍遥丸', '水丸', '6g', '10', 'dzxyw', NULL),
  ('b54327096b0d4a8588fc0f1a0b3740bd', '200582', '河北天成药业股份有限公司', '盐酸利多卡因注射液', 0.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '利多卡因', '注射液', '20ml:0.4g', '1', 'ldky,ldqy', NULL),
  ('b5c8bbaf32724fb098cb8b8dc01993ba', '200583', '成都天台山制药有限公司', '注射用盐酸罗哌卡因', 26.47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '罗哌卡因', '粉针', '75mg', '1', 'lpky,lpqy', NULL),
  ('b61b880916274ea683dff56dbf212e3b', '200584', '上海新亚药业高邮有限公司', '丹参注射液', 0.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '丹参注射液', '注射液', '2ml', '1', 'dszyy,dszsy,dczyy,dczsy', NULL),
  ('b69db0f329514388bae6d0c143e01135', '200585', '浙江九旭药业有限公司', '/', 12.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '丁卡因', '粉针', '25mg', '1', 'dky,zky,zqy,dqy', NULL),
  ('b751154e058e4529886ab955cfc78b07', '200586', '华北制药股份有限公司', '注射用头孢拉定', 0.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢拉定', '粉针', '0.5g', '1', 'tbld', NULL),
  ('90cfd057c5fc46b2a43a9ac90da47f2b', '200587', '河南太龙药业股份有限公司', '5%葡萄糖', 1.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '5%葡萄糖', '大输液', '500ml', '1', '5%ptt', NULL),
  ('90ff35714f3142b0ad758139cd611c83', '200588', '兰州太宝制药有限公司', '耳聋左慈丸', 8.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '耳聋左慈丸', '浓缩丸', '每8丸相当于原药材3g', '192', 'elzcw', NULL),
  ('9176a950542346ecab0cfdb58b9e04bc', '200589', '云南白药集团股份有限公司', '藿香正气胶囊', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '藿香正气胶囊', '胶囊', '0.3g', '24', 'hxzqjn', NULL),
  ('918a7ce568aa4d1997294882f46ccfb1', '200590', '荣昌制药（淄博）有限公司', '痔疮栓', 14.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '痔疮栓', '栓剂', '2g', '5', 'zcs', NULL),
  ('91b72a742be5431886f83ad674cd38a7', '200591', '上海禾丰制药有限公司', '多巴胺', 0.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '多巴胺', '注射液', '2ml:20mg', '1', 'dba', NULL),
  ('928133006e084036870a35e844828c39', '200592', '悦康药业集团有限公司', '豪林钠', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '炎琥宁', '粉针', '0.2g', '1', 'yhn', NULL),
  ('92a20865d989406ab927355ee686e2b0', '200593', '河南龙都药业有限公司', '晕痛定胶囊', 20.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '晕痛定胶囊', '胶囊', '0.4g', '27', 'ytdjn', NULL),
  ('92c334bb3c994f84907681fdc53c2e18', '200594', '浙江仙琚制药股份有限公司', '益玛欣', 31.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '黄体酮', '胶囊', '50mg', '20', 'hbt,htt', NULL),
  ('935ca3063bd24a02b091572257e8d137', '200595', '马鞍山丰原制药有限公司', '尿激酶', 4.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '尿激酶', '粉针', '1WIU', '1', 'sjm,njm', NULL),
  ('935f8bedb4844454aa0f2224a59f34b9', '200596', '浙江亚太药业股份有限公司', '亚力希', 1.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '罗红霉素', '胶囊', '50mg', '10', 'lgms,lhms', NULL),
  ('9390406eb3be4f3cba22b92c92a7c768', '200597', '江西赣南海欣药业股份有限公司', '无', 19.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维生素D2', '注射液', '1ml:5mg(20WIU)', '1', 'wssd2', NULL),
  ('93e9feb76297423984d4ae9a7c81de44', '200598', '山西普德药业股份有限公司', '甲氨蝶呤', 2.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '甲氨蝶呤', '粉针', '5mg', '1', 'jadl', NULL),
  ('9408033439aa4bd0b3bc05e2d337e1e5', '200599', '扬子江药业集团江苏制药股份有限公司', '无', 7.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '胃苏颗粒', '颗粒剂', '5g(无糖型)', '3', 'wskl', NULL),
  ('94548226629a405f82ae0d364bf57889', '200600', '北京益民药业有限公司', '普鲁卡因', 0.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '普鲁卡因', '注射液', '10ml:0.1g', '1', 'plky,plqy', NULL),
  ('945aee1f58ff4efba6d50723d49555f0', '200601', '广州白云山天心制药股份有限公司', '司佩定', 6.42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢呋辛酯', '片剂', '0.25g', '6', 'tbfxz', NULL),
  ('945e9eeff215496294985ca6eec229f7', '200602', '四川禾润制药有限公司', '逍遥丸', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '逍遥丸', '水丸', '6g', '20', 'xyw', NULL),
  ('94cada274bfd4964a774a97ce00c147f', '200603', '浙江万邦药业股份有限公司', '万邦信诺康', 25.58, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '银杏叶滴丸', '滴丸', '63mg(相当于银杏叶提取物16mg)', '60', 'yxxdw,yxydw', NULL),
  ('94f71020e25f4ef1beab33b0dcad4c55', '200604', '辰欣药业股份有限公司', '甲硝唑氯化钠注射液', 0.92, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '甲硝唑', '大输液', '250ml:0.5g', '1', 'jxz', NULL),
  ('95b521d957e646ac80b2d748b48f818f', '200605', '河南天方药业股份有限公司', '倍他司汀', 0.93, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '倍他司汀', '注射液', '2ml:10mg', '1', 'btst', NULL),
  ('95c199ba2266491aa0926b59485d40bc', '200606', '山东罗欣药业股份有限公司', '辛伐他汀', 1.66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '辛伐他汀', '片剂', '5mg', '20', 'xftt', NULL),
  ('95e8a59670b94abcaf59fead537dd215', '200607', '上海新亚药业闵行有限公司', '单硝酸异山梨酯', 10.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '单硝酸异山梨酯', '缓释片', '40mg', '14', 'cxsyslz,sxsyslz,dxsyslz', NULL),
  ('960a7e3b940e409985a7cd910523da92', '200608', '宜昌人福药业有限责任公司', '头孢氨苄颗粒', 1.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢氨苄', '颗粒剂', '0.125g', '12', 'tbab', NULL),
  ('96c554ac17264ffd97ddd2d4b5f2d4ce', '200609', '江西南昌济生制药厂', '生脉饮(党参)', 5.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '生脉饮(党参)', '口服液', '10ml（无糖型）', '10', 'smy(dc),smy(ds)', NULL),
  ('9748817e24f14599b1aa63cb9b0aa2e7', '200610', '北京北大维信生物科技有限公司', '血脂康胶囊', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '血脂康胶囊', '胶囊', '0.3g', '24', 'xzkjn', NULL),
  ('97bc3913d34e41d2a6c95f6c8fc51ffa', '200611', '重庆东方药业股份有限公司', '黄连上清颗粒', 12.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '黄连上清颗粒', '颗粒剂', '2g', '12', 'hlsqkl', NULL),
  ('9816fef12b144f188d86bf00af2f33af', '200612', '山东淄博新达制药有限公司', '道奇', 1.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿奇霉素', '片剂', '0.25g', '6', 'ajms,ejms,aqms,eqms', NULL),
  ('988e5274fb6c4989878cd84f11883bb6', '200613', '辰欣药业股份有限公司', '克林霉素磷酸酯注射液', 0.67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '克林霉素磷酸酯', '注射液', '2ml:0.3g', '1', 'klmslsz', NULL),
  ('98e0d02bf7334c138ee88b736445bff1', '200614', '河南百年康鑫药业有限公司', '木香顺气丸', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '木香顺气丸', '水丸', '6g(3g/50)', '10', 'mxsqw', NULL),
  ('997f35834c0a469aab4185872a686d69', '200615', '扬子江药业集团江苏制药股份有限公司', '无', 7.41, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '胃苏颗粒', '颗粒剂', '15g', '3', 'wskl', NULL),
  ('99b59540f851408f97718282a0d151c3', '200616', '新乡恒久远药业有限公司', '无', 1.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '对乙酰氨基酚', '片剂', '0.3g', '100', 'dyxajf', NULL),
  ('e2a06dd4750841d2b3cb6309b0b3f890', '200750', '湖北潜江制药股份有限公司', '珍珠明目滴眼液', 0.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '珍珠明目滴眼液', '滴眼液', '8ml', '1', 'zzmmdyy', NULL),
  ('e3b9754a7968433fa398247bbec8f9dc', '200751', '河南天方药业股份有限公司', '麦克罗辛', 3.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '盐酸二甲双胍缓释片', '缓释片', '0.5g', '16', 'ysejsghsp', NULL),
  ('e3c877a2627f446aa2a52fa5e6df5138', '200752', '江苏万邦生化医药股份有限公司', '万苏敏', 44.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '盐酸吡格列酮分散片', '分散片', '15mg', '30', 'yspgltfsp,ysbgltfsp', NULL),
  ('e3e325fc2b26496586c862f02303408a', '200753', '九寨沟天然药业集团有限责任公司', '九味羌活颗粒', 10.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '九味羌活颗粒', '颗粒剂', '15g', '20', 'jwqhkl', NULL),
  ('e46bcca9f8c340d69cbd79a5a32bae9b', '200754', '天津金耀氨基酸有限公司', '氟尿嘧啶', 1.17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氟尿嘧啶', '注射液', '10ml:0.25g', '1', 'fsmd,fnmd', NULL),
  ('e4da056d0f984f678e7b6389f8968b5c', '200755', '东北制药集团沈阳第一制药有限公司', '无', 0.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '金刚烷胺', '片剂', '0.1g', '24', 'jgwa', NULL),
  ('e5a30d71da984f998b8b3c18c852fc44', '200756', '山东华鲁制药有限公司', '布比卡因', 0.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '布比卡因', '注射液', '5ml:25mg', '1', 'bbqy,bbky', NULL),
  ('e5bb2e93211a48429687dd7d596c1306', '200757', '辽宁好护士药业(集团)有限责任公司', '乳癖消片', 15.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '乳癖消片', '片剂', '0.34g', '60', 'rpxp', NULL),
  ('e64903a37b4748acb6cc09f34dfb589d', '200758', '上海宝龙安庆药业有限公司', '明目地黄丸', 3.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '明目地黄丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'mmdhw', NULL),
  ('e683f49dd38540a9aa43d938923fc880', '200759', '贵州天安药业股份有限公司', '盐酸吡格列酮分散片', 41.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '盐酸吡格列酮分散片', '分散片', '30mg', '14', 'yspgltfsp,ysbgltfsp', NULL),
  ('e70a326038a8455484db3c8ff847ab42', '200760', '成都地奥制药集团有限公司', '地奥心血康胶囊', 8.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '地奥心血康胶囊', '胶囊', '含甾体总皂苷100mg(相当于甾体总皂苷元35mg)', '20', 'daxxkjn', NULL),
  ('e726466bacdb481894ea1f3525e3dc4f', '200761', '石家庄四药有限公司', '羟乙基淀粉40氯化钠', 2.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '羟乙基淀粉40氯化钠', '大输液', '500ml:30g:4.5g', '1', 'qyjdf40lhn', NULL),
  ('e77d0cf047eb419f84293ebf92c0c30c', '200762', '哈尔滨一洲制药有限公司', '消炎利胆胶囊', 5.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '消炎利胆胶囊', '胶囊', '0.45g', '36', 'xyldjn', NULL),
  ('e7d62445698d4d72be74f8330fe6ce22', '200763', '河南信心药业有限公司', '清肝利胆口服液', 23.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '清肝利胆口服液', '口服液', '10ml', '12', 'qgldkfy', NULL),
  ('e81c7d4bd28140eebada9e405ed6b260', '200764', '安徽新陇海药业有限公司', '普乐安片', 3.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '普乐安片', '片剂', '0.5g', '60', 'plap,pyap', NULL),
  ('e8a2459b0c914879a425e80a17cf88c8', '200765', '山西正元盛邦制药有限公司', '六味地黄丸', 3.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '六味地黄丸', '大蜜丸', '9g', '10', 'lwdhw', NULL),
  ('e8b25eb142194adb9b6d515dff856d53', '200766', '杭州民生药业有限公司', '无', 0.09, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '山莨菪碱', '注射液', '1ml:10mg', '1', 'sldj', NULL),
  ('e8fb33e4b52b4d5d953ad28964dcff70', '200767', '江苏吴中医药集团有限公司苏州制药厂', '盐酸纳洛酮注射液', 1.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '纳洛酮', '注射液', '1ml:0.4mg', '1', 'nlt', NULL),
  ('e9d253ee9e254d008e13358d5a549bd6', '200768', '上海衡山药业有限公司', '溴己新', 1.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '溴己新', '片剂', '8mg', '100', 'xjx', NULL),
  ('e9ea9776d0174ea59b7ab0ce57a0944c', '200769', '山东步长制药有限公司', '稳心颗粒(无蔗糖)', 27.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '稳心颗粒', '颗粒剂', '5g(无糖型)', '9', 'wxkl', NULL),
  ('f33f36860f614464b4db2ef762aafb21', '200770', '天津金世制药有限公司', '抗病毒片', 10.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '抗病毒片', '片剂', '0.32g', '36', 'kbdp', NULL),
  ('f3df74760e15482cbbf16c07e9bcd20d', '200771', '江苏万邦生化医药股份有限公司', '万苏林', 17.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '低精蛋白锌胰岛素', '注射液', '10ml:400IU', '1', 'djdbxyds', NULL),
  ('f7bc2fc97daf45caa5a33f4c295830a5', '200772', '湖北民康制药有限公司', '美怡欣', 19.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '银杏达莫', '注射液', '10ml', '1', 'yxdm', NULL),
  ('bce6817b1a9c4568a014cd4b3b487df9', '200773', '河南科伦药业有限公司', '葡萄糖氯化钠', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '葡萄糖氯化钠', '大输液', '100ml(塑瓶)', '1', 'pttlhn', NULL),
  ('bfdaeabbd76e47c8825b9789f4ec3573', '200774', '湖北人民制药有限公司', '更昔洛韦注射液', 7.09, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '更昔洛韦', '注射液', '5ml:0.15g', '1', 'gxlw', NULL),
  ('c23fdfc4910c413e8545a3b476c36637', '200775', '天津药业集团新郑股份有限公司', '无', 2.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '过氧化氢', '溶液剂', '500ml', '1', 'gyhq', NULL),
  ('c5e7ec3e5db44d1db44313d96d002f05', '200776', '湖北福人药业股份有限公司', '龙胆泻肝胶囊', 26.17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '龙胆泻肝胶囊', '胶囊', '0.25g', '48', 'ldxgjn', NULL),
  ('ca0b0646371944d2a0261df2d521d76c', '200777', '江西南昌桑海制药厂', '八珍益母胶囊', 22.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '八珍益母胶囊', '胶囊', '0.28g', '36', 'bzymjn', NULL),
  ('cd1913df11f4491bbebe654a44ca4131', '200778', '海南惠普森医药生物技术有限公司', '倍沙', 2.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '罗红霉素', '分散片', '0.15g', '8', 'lgms,lhms', NULL),
  ('d3119280d78d44729b74ce4acceaa67b', '200779', '赤峰丹龙药业有限公司', '连翘败毒丸', 3.42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '连翘败毒丸', '水丸', '9g', '6', 'lqbdw', NULL),
  ('d63f204d290946e88d90201965ea36ff', '200780', '丹东医创药业有限责任公司', '复方氢氧化铝片', 1.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '复方氢氧化铝', '片剂', '氢氧化铝0.245g/三硅酸镁0.105g/颠茄流浸膏0.0026ml', '100', 'ffqyhl', NULL),
  ('d747ac7618d94c06b4ecd47668fa20c5', '200781', '晋城海斯制药有限公司', '胞磷胆碱', 3.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '胞磷胆碱', '粉针', '0.5g', '1', 'bldj', NULL),
  ('d9b5d1f5cae347d49b13f7799f35874a', '200782', '西南药业股份有限公司', '泼尼松', 17.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '泼尼松', '片剂', '5mg', '1000', 'pns', NULL),
  ('dc8a290c0b9a449f8426f2a969cee35d', '200783', '鲁南贝特制药有限公司', '鲁南贝特', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '复方氯唑沙宗分散片', '分散片', '（0.15+0.125）', '12', 'fflzszfsp', NULL),
  ('e108cc9b0b8b4ce2a14fc46b0377d88a', '200784', '珠海经济特区生物化学制药厂', '盐酸氨溴索分散片', 10.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氨溴索', '分散片', '30mg', '30', 'axs', NULL),
  ('e5e2c073e115443cb7056caf6cc0f478', '200785', '莱阳市江波制药有限责任公司', '无', 3.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '益母草膏', '煎膏剂', '125g', '1', 'ymcg', NULL),
  ('e7270059f0f24bddb9f3781fa76eb183', '200786', '湖南五洲通药业有限责任公司', '氢化可的松', 8.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氢化可的松', '乳膏剂', '10g:10mg', '1', 'qhkds', NULL),
  ('ea480b446e9d49e9ab8aa8bcda11aca0', '200787', '山东绿因药业有限公司', '埃利雅', 31.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '马来酸依那普利分散片', '分散片', '5mg', '36', 'mlsynplfsp', NULL),
  ('36128e67f5d24145a5c7f67b434429a1', '200788', '株洲千金药业股份有限公司', '妇科千金片', 23.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '妇科千金片', '片剂', '复方', '144', 'fkqjp', NULL),
  ('09ba295471b7453e92443155b1ac77b5', '200789', '上海信谊药厂有限公司', '无', 16.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '甲氨蝶呤', '片剂', '2.5mg', '100', 'jadl', NULL),
  ('8c1d809fa27a4d6e97cfa2a0181e81f4', '200790', '山东华鲁制药有限公司', '灭菌注射用水', 1.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '灭菌注射用水', '大输液', '500ml(塑瓶)', '1', 'mjzyys,mjzsys', NULL),
  ('a502856ca0cf4f14bb871ad3ec9f56b3', '200791', '河南福森药业有限公司', '森克', 31.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '克拉霉素缓释片', '缓释片', '0.5g', '6', 'klmshsp', NULL),
  ('c073cc82860e458e9c5cdb18f9fa9aac', '200835', '华北制药股份有限公司', '注射用葛根素', 16.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '葛根素', '粉针', '0.2g', '1', 'ggs', NULL),
  ('c09cf270036d43d99aca9659eae4dfc8', '200836', '鲁南厚普制药有限公司', '茵栀黄颗粒', 19.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '茵栀黄颗粒', '颗粒剂', '3g', '10', 'yzhkl', NULL),
  ('c0a0d01fa68b4d86ae887fc991c3cc55', '200837', '四川科伦药业股份有限公司', '奥美拉唑', 1.17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '奥美拉唑', '肠溶胶囊', '20mg', '14', 'amlz', NULL),
  ('c0ac174764d84c4484b15aad0d727d6f', '200838', '华北制药河北华民药业有限责任公司', '头孢氨苄', 2.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢氨苄', '片剂', '0.25g', '24', 'tbab', NULL),
  ('c16993becae7492b99c187dd8118bab4', '200839', '圣大（张家口）药业有限公司', '尤林加', 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿莫西林/克拉维酸钾', '分散片', '0.1875g(2:1)', '12', 'emxl/klwsj,amxl/klwsj', NULL),
  ('c19c1db5ac0c4fe0a832f9daadda76b8', '200840', '山东华鲁制药有限公司', '左氧氟沙星', 1.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '左氧氟沙星', '大输液', '100ml:0.3g', '1', 'zyfsx', NULL),
  ('c1e77e369dcf4e5fa90c89f2a38d9e7a', '200841', '天士力制药集团股份有限公司', '藿香正气滴丸', 8.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '藿香正气滴丸', '滴丸', '2.6g', '9', 'hxzqdw', NULL),
  ('c20d1ecfbaf84f58b9225061abee134c', '200842', '河南怀庆药业有限责任公司', '四神丸', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '四神丸', '水丸', '9g', '10', 'ssw', NULL),
  ('c2663f7982c04bf38d6744caca1c72c3', '200843', '亚宝药业集团股份有限公司', '红花注射液', 8.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '红花注射液', '注射液', '20ml', '1', 'hhzsy,ghzsy,hhzyy,ghzyy', NULL),
  ('c2c2d7cfe1d34ad28e33ca64b2ad6fb4', '200844', '宜昌长江药业有限公司', '辛伐他汀片', 0.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '辛伐他汀片', '片剂', '10mg', '10', 'xfttp', NULL),
  ('c2f83a037abd4a75800deb110e5556e3', '200845', '上海信谊黄河制药有限公司受托于上海信谊药', '异烟肼片', 2.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '异烟肼片', '片剂', '100mg', '100', 'yyjp', NULL),
  ('c36b2db1be5c464eb2404b385c12ddeb', '200846', '湖南五洲通药业有限责任公司', '?', 28.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '泮托拉唑', '粉针', '60mg', '1', 'ptlz', NULL),
  ('c3bc3f73fcff4b0c89f3767e33cb684a', '200847', '瑞阳制药有限公司', '知力', 2.29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢呋辛', '粉针', '1.5g', '1', 'tbfx', NULL),
  ('c3bcb00fa4084b6f86eed56b2fca12b2', '200848', '郑州瑞康制药有限公司', '特拉唑嗪', 3.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '特拉唑嗪', '片剂', '2mg', '14', 'tlzq', NULL),
  ('b4a798240cc7475ea179c9b9ff3fdc0f', '200792', '吉林市鹿王制药股份有限公司', '龙胆泻肝丸', 3.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '龙胆泻肝丸', '大蜜丸', '6g', '10', 'ldxgw', NULL),
  ('926265d70b4345daadf3ff2ac7e59ef0', '200793', '通化东宝药业股份有限公司', '甘舒霖30R(笔芯)', 46.22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '30/70混合重组人胰岛素', '注射液', '3ml:300IU', '1', '30/70hgczryds,30/70hhzzryds,30/70hgzzryds,30/70hhczryds', NULL),
  ('6a17ce71523e433799ee8f9f1ad0ba93', '200794', '成都康弘制药有限公司', '松龄血脉康胶囊', 25.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '松龄血脉康胶囊', '胶囊', '0.5g', '30', 'slxmkjn', NULL),
  ('f1136433271645f68dd52ef2a8bd002e', '200795', '宜昌长江药业有限公司', '格列吡嗪胶囊', 2.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '格列吡嗪胶囊', '胶囊', '5mg', '30', 'glbqjn,glpqjn', NULL),
  ('bc5963c6aebd4644922a7d14dded8056', '200796', '哈尔滨圣泰药业有限公司', '清开灵片', 23.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '清开灵片', '片剂', '0.5g', '36', 'qklp', NULL),
  ('d66e3c9d6bbd4873afd595e6f2aecee8', '200797', '山东罗欣药业股份有限公司', '罗欣快宇', 1.13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿奇霉素', '颗粒剂', '0.25g', '2', 'ajms,ejms,aqms,eqms', NULL),
  ('ff7cf4efcfda4813b10516f189c71791', '200798', '四川好医生制药有限公司', '罗红霉素', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '罗红霉素', '分散片', '50mg', '12', 'lgms,lhms', NULL),
  ('ffb4e018b4c04b59b32af607eb26b60c', '200799', '云南白药集团股份有限公司', '黄连上清片', 0.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '黄连上清片', '片剂', '相当于原生药0.655g', '36', 'hlsqp', NULL),
  ('ffdb605748164b59af0e508e1e5ae2bd', '200800', '山东沃华医药科技股份有限公司', '橘红丸', 3.31, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '橘红丸', '大蜜丸', '6g', '10', 'jgw,jhw', NULL),
  ('5d7f597675c848fa83bc7d23b051930b', '200801', '丹东医创药业有限责任公司', '盐酸二氧丙嗪片', 1.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '二氧丙嗪', '片剂', '5mg', '100', 'eybq', NULL),
  ('5fb313814f434a73b36bf02582f32bdf', '200802', '太极集团重庆涪陵制药厂有限公司', '急支糖浆', 9.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '急支糖浆', '糖浆剂', '200ml', '1', 'jztj', NULL),
  ('616cfd4611404dd0b61fcd572fbf798b', '200803', '广东益和堂制药有限公司', '排石颗粒', 11.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '排石颗粒', '颗粒剂', '20g', '10', 'pskl,pdkl', NULL),
  ('637afbcae68147669d9b505c94a5cb12', '200804', '湖北午时药业股份有限公司', '保和丸', 4.33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '保和丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'bhw', NULL),
  ('67d7b863da7d40348220e68fb8b925bd', '200805', '河南太龙药业股份有限公司', '0.9%氯化钠', 0.68, NULL, NULL, '2014-04-01 00:00:00', '1', NULL, NULL, NULL, NULL, '00401', NULL, '1', NULL, '2014-04-02 00:00:00', NULL, '2', NULL, NULL, NULL, '瓶', '0.9%氯化钠', '大输液', '100ml', '1', '0.9%lhn', NULL),
  ('69150c43c1f34189b806d71a68610095', '200806', '河南禹州市药王制药有限公司', '归脾丸', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '归脾丸', '大蜜丸', '9g', '10', 'gpw', NULL),
  ('6bcdec36519a4e21b29d46459032f646', '200807', '华北制药秦皇岛有限公司', '头孢拉定胶囊', 3.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢拉定', '胶囊', '0.25g', '24', 'tbld', NULL),
  ('705686b622674a838190bcf5060367b3', '200808', '河南天方药业股份有限公司', '麦克罗辛', 15.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '盐酸二甲双胍缓释片', '缓释片', '0.5g', '64', 'ysejsghsp', NULL),
  ('738d6286925d486a96656efaac3a557e', '200809', '上海玉瑞生物科技（安阳）药业有限公司', '呋喃唑酮片', 1.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '呋喃唑酮', '片剂', '0.1g', '100', 'fnzt', NULL),
  ('7581b2b895a9498396d40383c0673baf', '200810', '西安利君制药有限责任公司', '颠茄片', 5.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '颠茄', '片剂', '10mg', '1000', 'dj,dq', NULL),
  ('785be4fdc07445b2804a6e56facc9083', '200811', '河北天成药业股份有限公司', '硫酸镁注射液', 0.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '硫酸镁', '注射液', '10ml:2.5g', '1', 'lsm', NULL),
  ('7c4e13842a9c40dcb54716eb2bb316ca', '200812', '安徽精方药业股份有限公司', '颈舒颗粒', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '颈舒颗粒', '颗粒剂', '6g', '9', 'gskl,jskl', NULL),
  ('7e73ad419510435a8fe4800f269a1cf6', '200813', '宜昌长江药业有限公司', '法莫替丁胶囊', 1.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '法莫替丁胶囊', '胶囊', '20mg', '24', 'fmtzjn,fmtdjn', NULL),
  ('81393aa920004c7182897250812de77d', '200814', '辅仁药业集团有限公司', '炎琥宁', 0.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '炎琥宁', '粉针', '80mg', '1', 'yhn', NULL),
  ('838703579dac4138ad036440ad56c228', '200815', '广州白云山明兴制药有限公司', '氨茶碱', 0.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氨茶碱', '注射液', '2ml:0.5g', '1', 'acj', NULL),
  ('85869e40455945648864c9073e74dabd', '200816', '颈复康药业集团有限公司', '颈复康颗粒', 20.67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '颈复康颗粒', '颗粒剂', '5g', '10', 'jfkkl,gfkkl', NULL),
  ('ec06c1a3b07c42aa89b4bb5eba4a1a0d', '200817', '雅安三九药业有限公司', '参附注射液', 21.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '参附注射液', '注射液', '10ml', '1', 'sfzsy,sfzyy,cfzyy,cfzsy', NULL),
  ('eeebf885ff874480aa01f45cba7f0255', '200818', '山东罗欣药业股份有限公司', '头孢氨苄', 2.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢氨苄', '胶囊', '0.25g', '24', 'tbab', NULL),
  ('b820283c6c9541bc83826e46718c44eb', '200819', '河南双鹤华利药业有限公司', '氯化钠注射液', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '氯化钠注射液', '大输液', '500ml：4.5g(玻璃瓶)', '1', 'lhnzyy,lhnzsy', NULL),
  ('b90fbe788f794c998fbfa9129b29d6c3', '200820', '湖南五洲通药业有限责任公司', '林可霉素', 1.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '林可霉素', '粉针', '0.6g', '1', 'lkms', NULL),
  ('b92af38b86f34a91b3eaf750c8c3b47a', '200821', '四川科伦药业股份有限公司', '阿昔洛韦', 2.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿昔洛韦', '片剂', '0.2g', '24', 'axlw,exlw', NULL),
  ('bbafa0d8e5794e9c8b0450fb2108b5aa', '200822', '杭州胡庆余堂药业有限公司', '金匮肾气丸', 7.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '金匮肾气丸', '水蜜丸', '60g', '1', 'jksqw', NULL),
  ('bc6d4e73aeb24673b89334a3b0186871', '200823', '上海海虹实业（集团）巢湖今辰药业有限公司', '牛黄上清片', 2.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '牛黄上清片', '片剂', '0.25g', '48', 'nhsqp', NULL),
  ('bcbe3e3a16854daca75fcadfd94ee446', '200824', '湖南科伦制药有限公司', '瑞美特', 1.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氧氟沙星', '粉针', '0.2g', '1', 'yfsx', NULL),
  ('bd74e6b65bcb44dbb5634e0f93694f4d', '200825', '悦康药业集团有限公司', '悦康辛', 1.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '奥扎格雷钠', '粉针', '40mg', '1', 'azgln', NULL),
  ('bdec8586b60b40618afb08a2df901231', '200826', '南京中山制药有限公司', '活血止痛胶囊', 19.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '活血止痛胶囊', '胶囊', '0.25g', '60', 'hxztjn', NULL),
  ('be8cd74148b741c5b4b841c9213bd29e', '200827', '江西药都樟树制药有限公司', '柏子养心丸', 5.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '柏子养心丸', '水蜜丸', '120g', '1', 'bzyxw', NULL),
  ('bedae1ea6b804054bf3a25d716e45d80', '200828', '华中药业股份有限公司', '维生素B6', 0.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '维生素B6', '片剂', '10mg', '100', 'wssb6', NULL),
  ('bf01b2b0920b4308acf6d51c52111a45', '200829', '四川禾邦阳光制药股份有限公司', '藿香正气水', 2.36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '藿香正气水', '酊剂', '10ml', '10', 'hxzqs', NULL),
  ('bf0a2c69dee14ef99df216b27faeb975', '200830', '浙江巨泰药业有限公司', '巨泰', 25.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿莫西林/克拉维酸钾', '胶囊', '0.15625g(4:1)', '18', 'emxl/klwsj,amxl/klwsj', NULL),
  ('bf735bd3a9a842b1baa1e8ecb836cf2a', '200831', '江苏正大天晴药业股份有限公司', '天晴甘平', 26.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '甘草酸二铵', '肠溶胶囊', '50mg', '24', 'gcsea', NULL),
  ('bf7f44c9c4ba4af8a7cc0e41d5444095', '200832', '国药集团容生制药有限公司', '氢化可的松', 1.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氢化可的松', '注射液', '20ml:0.1g', '1', 'qhkds', NULL),
  ('bfa73499e98441078a92aa3d630c12a1', '200833', '吉林市鹿王制药股份有限公司', '蛤蚧定喘丸', 6.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '蛤蚧定喘丸', '水蜜丸', '6g', '10', 'gjdcw,hjdcw', NULL),
  ('c0699c0611a84d2e88c69076a30259d6', '200834', '广州白云山制药股份有限公司广州白云山制药总厂', '侨合安', 8.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氨氯地平', '片剂', '5mg', '14', 'aldp', NULL),
  ('99c612ff7bfa4d138d09c3fef2ce1e56', '200617', '辰欣药业股份有限公司', '乳酸钠林格注射液', 1.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '乳酸钠林格', '大输液', '500ml(玻瓶)', '1', 'rsnlg', NULL),
  ('9a2233dafe984117b8c2de01df0918b0', '200618', '河南科伦药业有限公司', '葡萄糖氯化钠', 1.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '葡萄糖氯化钠', '大输液', '250ml(塑瓶)', '1', 'pttlhn', NULL),
  ('9a2925e2edc3424fb361acd0e0ddab60', '200619', '山东罗欣药业股份有限公司', '洛伐他汀', 3.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '洛伐他汀', '片剂', '10mg', '20', 'lftt', NULL),
  ('9a2c10956f274dbdbf7ae6769a152aea', '200620', '西南药业股份有限公司', '阿托品', 3.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '阿托品', '片剂', '0.3mg', '1000', 'etp,atp', NULL),
  ('9a85a5eb17d143e3852f6f2704c15803', '200621', '山东罗欣药业股份有限公司', '宁沙', 0.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '左氧氟沙星', '粉针', '0.1g', '1', 'zyfsx', NULL),
  ('9ac4a69acccd4d999a1061a7e14cc3bf', '200622', '常州四药制药有限公司', '阿米替林', 13.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '阿米替林', '片剂', '25mg', '100', 'amtl,emtl', NULL),
  ('9ad11ca401054dce95b8c5735066aabc', '200623', '云南维和药业股份有限公司', '活血止痛散', 9.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '活血止痛散', '散剂', '3g', '6', 'hxzts', NULL),
  ('9b3f2038caef49ac913891ace2daaf53', '200624', '通化东宝药业股份有限公司', '镇脑宁胶囊', 16.67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '镇脑宁胶囊', '胶囊', '0.3g', '60', 'znnjn', NULL),
  ('9b804bc43d5a4b5f8f0431eb1a7b96cd', '200625', '辰欣药业股份有限公司', '复方氨基酸注射液(18AA)', 3.04, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '复方氨基酸(18AA)', '大输液', '250ml:12.5g', '1', 'ffajs(18aa)', NULL),
  ('9beb14a3e1d2499fa6e675643b8c122f', '200626', '成都锦华药业有限责任公司', '吡嗪酰胺片', 5.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '吡嗪酰胺', '片剂', '0.25g', '100', 'pqxa,bqxa', NULL),
  ('9c6ceb52455749ddbab6f3d6f0fc1888', '200627', '河南怀庆药业有限责任公司', '银翘解毒丸', 2.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '盒', '银翘解毒丸', '大蜜丸', '9g', '10', 'yqjdw,yqxdw', NULL),
  ('9c9a51d073e246268afbb6af53519688', '200628', '开封制药(集团)有限公司', '复方硫黄乳膏', 4.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '复方硫黄乳膏', '软膏剂', '250g', '1', 'fflhrg', NULL),
  ('58b7d7f3b11246b49a20edc74c478226', '200629', '新乡市常乐制药有限责任公司', '维生素B6', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '维生素B6', '片剂', '10mg', '1000', 'wssb6', NULL),
  ('599260dda45f4190a4d8e298c3805fb4', '200630', '上海雷允上药业有限公司', '藿胆滴丸', 36.47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '藿胆滴丸', '滴丸', '0.05g', '60', 'hddw', NULL),
  ('5a621014fa8a4b3cacf37f051039b5fa', '200631', '深圳致君制药有限公司', '氨溴索', 6.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '氨溴索', '口服液', '100ml:0.3g(无糖型)', '1', 'axs', NULL),
  ('5a62b1236c0947dc9ffe4efd9cb91b88', '200632', '海南惠普森医药生物技术有限公司', '倍沙', 1.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '罗红霉素', '分散片', '0.15g', '6', 'lgms,lhms', NULL),
  ('5a9783aa349f4ef988e04163f52a6b93', '200633', '上海现代哈森(商丘)药业有限公司', '氢化可的松注射液', 0.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氢化可的松', '注射液', '2ml:10mg', '1', 'qhkds', NULL),
  ('5b0292282f1b46cc9f178fce96cc3459', '200634', '石药集团中诺药业(石家庄)有限公司', '阿林新', 1.36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿莫西林', '分散片', '0.25g', '12', 'amxl,emxl', NULL),
  ('5b0942fb6f15450884f3382a9e48a907', '200635', '河南省百泉制药有限公司', '柴胡口服液', 6.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '柴胡口服液', '口服液', '10ml', '12', 'chkfy', NULL),
  ('5b972dfb841e44e9af507ba88c4f614d', '200636', '新乡华青药业有限公司', '无', 0.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '克霉唑', '溶液剂', '8ml:0.12g(1.5%)', '1', 'kmz', NULL),
  ('5d87628cc5f74315b275375055a63fe6', '200637', '扬州市三药制药有限公司', '氨溴索', 5.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '氨溴索', '口服液', '100ml:0.3g', '1', 'axs', NULL),
  ('5e09d3361d0a48b98e31a7faa2d53c3b', '200638', '辽宁海思科制药有限公司', '中/长链脂肪乳(C8-24)', 83.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '中/长链脂肪乳(C8-24)', '大输液', '500ml(10%)', '1', 'z/clzfr(c8-24),z/zlzfr(c8-24)', NULL),
  ('5e4502488ff4490b900c1288c7863687', '200639', '华北制药股份有限公司', '注射用头孢他啶', 1.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢他啶', '粉针', '1.0g', '1', 'tbtd', NULL),
  ('5e9f3538f9e448c3bc8b23a2d4631235', '200640', '武汉人福药业有限责任公司', '万祥', 7.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '硝普钠', '粉针', '50mg', '1', 'xpn', NULL),
  ('5eecaee339d34eaca3d416500e39ebe5', '200641', '开封制药(集团)有限公司', '卡托普利', 1.54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '卡托普利', '片剂', '12.5mg', '100', 'ktpl,qtpl', NULL),
  ('5ef880f0a2ad4fabbf2441fa1557af5b', '200642', '江西生物制品研究所', '破伤风抗毒素', 2.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '破伤风抗毒素', '注射液', '1500IU', '1', 'psfkds', NULL),
  ('5f1218a457c049fab7a3cf648ca4ca7b', '200643', '河南润弘制药股份有限公司', '无', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维生素C', '注射液', '2ml:0.25g', '1', 'wssc', NULL),
  ('5f63dcf472f64497b1db3f9a59e5e75a', '200644', '深圳信立泰药业股份有限公司', '信立欣', 4.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '头孢呋辛', '粉针', '0.5g', '1', 'tbfx', NULL),
  ('5f8901d60c1b4d6892a0709108c31648', '200645', '上海信谊药厂有限公司', '格列本脲片', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '格列本脲片', '片剂', '2.5mg', '100', 'glbnp', NULL),
  ('5fbaca9af0764e00b3b08feba6caaba8', '200646', '河南太龙药业股份有限公司', '0.9%氯化钠', 0.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '0.9%氯化钠', '大输液', '250ml', '1', '0.9%lhn', NULL),
  ('5fd952631ec94be381520e07bac6767b', '200647', '河南天方药业股份有限公司', '西咪替丁', 2.47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '西咪替丁', '片剂', '0.2g', '100', 'xmtd,xmtz', NULL),
  ('5fda3a2daa434a54b015fdbaa68d60f2', '200648', '兰州太宝制药有限公司', '川芎茶调丸', 6.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '川芎茶调丸', '浓缩丸', '每8丸相当于原药材3g', '192', 'cxcdw,cxctw', NULL),
  ('604e8946a90d40808ba20010a482f24d', '200649', '广州白云山中一药业有限公司', '消渴丸', 24.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '消渴丸', '丸剂', '每10丸重2.5g（含格列本脲2.5mg）', '210', 'xkw', NULL),
  ('6058d0f33b7c4cccaad9b538e634acad', '200650', '开开援生制药股份有限公司', '乳酸左氧氟沙星氯化钠注射液', 2.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '乳酸左氧氟沙星氯化钠注射液', '大输液', '100ml:0.2g', '1', 'rszyfsxlhnzyy,rszyfsxlhnzsy', NULL),
  ('61671ccab3f041b2b0981b5f9eec66f4', '200651', '山东罗欣药业股份有限公司', '阿奇霉素', 0.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '阿奇霉素', '粉针', '0.125g', '1', 'ajms,ejms,aqms,eqms', NULL),
  ('61c797e1bdf3474fb099d3574c3e596d', '200652', '湖北午时药业股份有限公司', '妇科十味片', 3.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '妇科十味片', '片剂', '0.3g', '100', 'fkswp', NULL),
  ('62110d8b2cca4187aeb03cea9e40c28f', '200653', '重庆东方药业股份有限公司', '五苓片', 14.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '五苓片', '片剂', '0.35g', '100', 'wlp', NULL),
  ('626f37a66b82444d9f7b60b672f65bbc', '200654', '山东华鲁制药有限公司', '利多卡因', 0.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '利多卡因', '注射液', '10ml:0.2g', '1', 'ldky,ldqy', NULL),
  ('62b2a2281a59473d9c0228d5a09825ea', '200655', '湖南恒生制药股份有限公司', '注射用灯盏花素', 41.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '灯盏花素', '粉针', '50mg', '1', 'dzhs', NULL),
  ('63125a4e20054ff7af70e9a106b8e17c', '200656', '三门峡赛诺维制药有限公司', '乳酶生', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '乳酶生', '片剂', '0.15g', '1000', 'rms', NULL),
  ('636ed5ab5ab24f84a183fe2a3ce97679', '200657', '湖南金沙药业有限责任公司', '接骨七厘片', 40.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '接骨七厘片', '片剂', '相当于原生药量0.3g', '75', 'jgqlp', NULL),
  ('6393e96a1f4d4b3081cf9fb5fd07aa85', '200658', '株洲千金药业股份有限公司', '妇科千金胶囊', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '妇科千金胶囊', '胶囊', '0.4g', '36', 'fkqjjn', NULL),
  ('64f2be1fc08c4979915f3f014622dce0', '200659', '江苏康缘药业股份有限公司', '逍遥丸', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '逍遥丸', '浓缩丸', '每8丸相当于原药材3g', '200', 'xyw', NULL),
  ('65640b32e11c4632af3e71fb08cf9c2c', '200660', '上海现代制药股份有限公司', '浦虹', 1.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '罗红霉素', '片剂', '50mg', '10', 'lgms,lhms', NULL),
  ('659f6917051349288ec4edc5c8e931cf', '200661', '河北天成药业股份有限公司', '氯化钾注射液', 0.14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氯化钾', '注射液', '10ml:1.0g', '1', 'lhj', NULL),
  ('662a6d83dd3841b6ad123ba70a08e42a', '200662', '辰欣药业股份有限公司', '四环素可的松眼膏', 0.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '四环素可的松', '眼膏剂', '2.0g', '1', 'shskds', NULL),
  ('664e7ef3006c4a0098485e61703b3b6b', '200663', '海口市制药厂有限公司', '橘红片', 7.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '橘红片', '片剂', '0.3g', '40', 'jgp,jhp', NULL),
  ('66575cd57a17483dafc4c6db213eb463', '200664', '贵州圣济堂制药有限公司', '盐酸二甲双胍肠溶片', 9.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '二甲双胍', '肠溶片', '0.5g', '45', 'ejsg', NULL),
  ('66a5a6c996324beebf0b4571dbdd2772', '200665', '马应龙药业集团股份有限公司', '水杨酸软膏', 1.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '水杨酸', '软膏剂', '10g:0.5g', '1', 'sys', NULL),
  ('66ac6980b6de4a30bd46c97a2c520f9a', '200666', '山东步长制药有限公司', '稳心颗粒', 24.54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '稳心颗粒', '颗粒剂', '9g', '9', 'wxkl', NULL),
  ('67f0d60a5dd148caabfa6dd95ab4ee83', '200667', '上海信谊金朱药业有限公司', '无', 0.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氨基己酸', '注射液', '10ml:2.0g', '1', 'ajjs', NULL),
  ('67f5a7a216f3441a9f3bcdef1487e99a', '200668', '辰欣药业股份有限公司', '维生素K1注射液', 0.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '维生素K1', '注射液', '1ml:10mg', '1', 'wssk1', NULL),
  ('684339be2be44eee8541013b7713a96f', '200669', '悦康药业集团北京凯悦制药有限公司', '头孢氨苄', 1.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢氨苄', '片剂', '0.125g', '30', 'tbab', NULL),
  ('68d4692e94354413bd341a4d9166db09', '200670', '朗致集团万荣药业有限公司', '桂枝茯苓丸', 35.94, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '桂枝茯苓丸', '水丸', '2.2g/10', '120', 'gqflw,gzflw', NULL),
  ('690862a7004647a6a73396b775f315d7', '200671', '河南禹州市药王制药有限公司', '八珍益母丸', 2.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '八珍益母丸', '大蜜丸', '9g', '10', 'bzymw', NULL),
  ('690e110d41bf4277abfad2e1011d3f93', '200672', '开封制药(集团)有限公司', '环丙沙星', 0.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '环丙沙星', '片剂', '0.25g', '10', 'hbsx', NULL),
  ('69197f9f90e14fe3971c2800c56baba0', '200673', '上海现代哈森(商丘)药业有限公司', '曲克芦丁注射液', 1.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '曲克芦丁', '注射液', '10ml:0.3g', '1', 'qklz,qkld', NULL),
  ('c42a19775600447ea9c5a5fcc8369ea6', '200674', '华北制药股份有限公司', '注射用硫酸链霉素', 0.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '链霉素', '粉针', '100WU', '1', 'lms', NULL),
  ('c5a9c15e69414b14b68a06aa9bad4d6d', '200675', '辅仁药业集团有限公司', '尼群地平', 0.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '尼群地平', '片剂', '10mg', '100', 'nqdp', NULL),
  ('c5b20e7d0df24f4091570645d697693a', '200676', '宜昌长江药业有限公司', '克拉霉素分散片', 6.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '克拉霉素分散片', '分散片', '0.25g', '6', 'klmsfsp', NULL),
  ('c5f6ece950bc4e12bf39d454146db4c8', '200677', '山西正元盛邦制药有限公司', '保和丸', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '保和丸', '大蜜丸', '9g', '10', 'bhw', NULL),
  ('c6020fac8d7348178ded2393e6613d67', '200678', '黑龙江珍宝岛药业股份有限公司', '血塞通注射液', 3.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '血塞通注射液', '注射液', '5ml:0.25g', '1', 'xstzyy,xstzsy', NULL),
  ('c6b892525d8846309145980ebd9858b8', '200679', '河南润弘制药股份有限公司', '无', 0.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氨茶碱', '注射液', '2ml:0.25g', '1', 'acj', NULL),
  ('c6e49851d9d54b39a93eca778dc05f4b', '200680', '神威药业集团有限公司', '藿香正气软胶囊', 8.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '藿香正气软胶囊', '软胶囊', '0.45g', '24', 'hxzqrjn', NULL),
  ('c6ec2b52dc144d26b6ebd238de8c49d5', '200681', '海南三风友制药有限公司', '复方氨酚愈敏', 12.94, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '复方氨酚愈敏', '口服液', '60ml', '1', 'ffafym', NULL),
  ('c7c6fde5a9134e2a90bf4a6aa7158635', '200682', '药都制药集团股份有限公司', '石斛夜光丸', 13.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '石斛夜光丸', '大蜜丸', '9g', '10', 'shygw,dhygw', NULL),
  ('c82e23efe33e437aa74900a35ddbe6ed', '200683', '山东新华制药股份有限公司', '地塞米松磷酸钠', 0.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '地塞米松磷酸钠', '注射液', '1ml:2mg', '1', 'dsmslsn', NULL),
  ('c84f0d9528654f6d8119dc424a5ed2cf', '200684', '惠州市九惠制药股份有限公司', '无', 24.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '安胃疡胶囊', '胶囊', '0.2g', '24', 'awyjn', NULL),
  ('c854f23aceed482cad4aacff529c4b5a', '200685', '海口奇力制药股份有限公司', '盐酸克林霉素胶囊', 1.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '克林霉素', '胶囊', '0.15g', '10', 'klms', NULL),
  ('c8be6c86565d4cf79d94a2130f7a119c', '200686', '成都永康制药有限公司', '消咳喘胶囊', 17.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '消咳喘胶囊', '胶囊', '0.35g', '36', 'xkcjn,xhcjn', NULL),
  ('c907b7b8790e463c95cfa290717dd9ad', '200687', '江西泽众制药股份有限公司', '红霉素', 22.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '红霉素', '肠溶片', '0.25g', '100', 'hms,gms', NULL),
  ('c933a417fbb94c09947ce089dbf4449e', '200688', '通化东宝药业股份有限公司', '甘舒霖R', 46.43, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '重组人胰岛素', '注射液', '10ml:400IU', '1', 'czryds,zzryds', NULL),
  ('c99c01ca0182466f922eb2508fb78b96', '200689', '上海信谊金朱药业有限公司', '无', 3.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '新斯的明', '注射液', '2ml:1mg', '1', 'xsdm', NULL),
  ('c99ec832ae704f9f80da453acfea0dfd', '200690', '湖南迪诺制药有限公司', '法莫替丁', 1.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '法莫替丁', '片剂', '20mg', '24', 'fmtz,fmtd', NULL),
  ('ca100c434e6844cca04dce4372f73f44', '200691', '山西华康药业股份有限公司', '橘红丸', 3.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '橘红丸', '水蜜丸', '7.2g(10g/100）', '6', 'jgw,jhw', NULL),
  ('ca65802b4d55429dab1b5f5126d725b9', '200692', '辰欣药业股份有限公司', '桂利嗪片', 1.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '桂利嗪', '片剂', '25mg', '100', 'glq', NULL),
  ('cbd09dd39d55452ea8aba836ec49c784', '200693', '华中药业股份有限公司', '葡醛内酯片', 1.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '葡醛内酯', '片剂', '0.1g', '100', 'pqnz', NULL),
  ('cbf0c00b6094420f81f098655f19bcee', '200694', '美吉斯制药（厦门）有限公司', '惠滋养', 1.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '氯雷他定', '片剂', '10mg', '6', 'lltd', NULL),
  ('cc04d6df62a245abaf1413383911bf59', '200695', '北京嘉林药业股份有限公司', '硫唑嘌呤', 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '硫唑嘌呤', '片剂', '0.1g', '36', 'lzpl', NULL),
  ('cc451c455a9d4099be0cf6c45a99f754', '200696', '天士力制药集团股份有限公司', '柴胡滴丸', 7.92, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '柴胡滴丸', '滴丸', '0.551g', '6', 'chdw', NULL),
  ('cc518215bd0345a3ae9c19bdd5a0ea58', '200697', '鲁南贝特制药有限公司', '吉舒', 52.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '布地奈德', '气雾剂', '100ug/喷*200', '1', 'bdnd', NULL),
  ('cc56541a644b43bba7cd8b5d0f68b2f0', '200698', '湖南迪诺制药有限公司', '替硝唑', 0.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '替硝唑', '片剂', '0.5g', '8', 'txz', NULL),
  ('cc7400bccdea43c2889892101fd79cd5', '200699', '江苏晨牌药业集团股份有限公司', '复方氯唑沙宗', 22.36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '复方氯唑沙宗', '胶囊', '0.125g:0.15g', '48', 'fflzsz', NULL),
  ('cdae9dfbce424e08904d3d1320ca11e3', '200700', '江苏吉贝尔药业有限公司', '利可君', 33.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '利可君', '片剂', '20mg', '48', 'lkj', NULL),
  ('cf1c4ab918f44a2ea12228d6ca8c03ff', '200701', '湖南千金湘江药业股份有限公司', '利巴韦林', 2.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '利巴韦林', '颗粒剂', '50mg', '18', 'lbwl', NULL),
  ('cfb14d6917174aedab247179fec490df', '200702', '云南白药集团无锡药业有限公司', '云南白药膏', 42.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '云南白药膏', '橡胶膏剂', '6.5cm*10cm', '10', 'ynbyg', NULL),
  ('d0d8e1fa42f84d688315a04f4c2d1999', '200703', '河南太龙药业股份有限公司', '葡萄糖氯化钠', 0.94, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '葡萄糖氯化钠', '大输液', '250ml', '1', 'pttlhn', NULL),
  ('d12b5368326341e4804e64feb4273d79', '200704', '江西桔王药业有限公司', '?', 18.59, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '宫炎平胶囊', '片剂', '0.2g', '36', 'gypjn', NULL),
  ('d1dd346156a34ace97afcaea7a30a859', '200705', '药都制药集团股份有限公司', '跌打丸', 4.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '跌打丸', '大蜜丸', '3g', '10', 'ddw', NULL),
  ('d219da987e1d4289af803f363ae4e647', '200706', '沈阳红旗制药有限公司', '盐酸乙胺丁醇胶囊', 15.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '乙胺丁醇', '胶囊', '0.25g', '100', 'yadc,yazc', NULL),
  ('d24276345f844fd4a52e507b9e856acb', '200707', '南宁市维威制药', '益母草膏', 3.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '益母草膏', '煎膏剂', '125g', '1', 'ymcg', NULL),
  ('d2dd8a7bc8fc46e3af57672cae6c2bc9', '200708', '上海信谊药厂有限公司', '美唯宁', 24.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '莫沙必利', '胶囊', '5mg', '24', 'msbl', NULL),
  ('d34f8025c7d74c57b866f71ea8a0f076', '200709', '海口市制药厂有限公司', '头孢克洛颗粒', 3.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢克洛', '颗粒剂', '0.125g', '6', 'tbkl', NULL),
  ('d3516afc4ac2413b9e3ee4794780b2f3', '200710', '深圳致君制药有限公司', '达力新', 8.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '头孢呋辛酯', '胶囊', '0.125g', '12', 'tbfxz', NULL),
  ('d357409542fb4ddfad677e5c90741bc1', '200711', '西南药业股份有限公司', '?', 27.41, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '天麻素', '粉针', '5ml:0.5g', '1', 'tms', NULL),
  ('d3c5082c22f1472287bf7c6beef03e02', '200712', '辰欣药业股份有限公司', '盐酸金霉素眼膏', 0.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '金霉素', '眼膏剂', '2g:10mg(0.5%)', '1', 'jms', NULL),
  ('d44112fe297942ca8f618bf54edd7c5e', '200713', '山东省平原制药厂', '富马酸酮替芬片', 2.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '酮替芬', '片剂', '1mg', '100', 'ttf', NULL),
  ('d45118b3a8244b4ea2c28ed78cdb4475', '200714', '广东省罗浮山白鹤制药厂', '保济丸', 5.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '保济丸', '水丸', '3.7g', '20', 'bjw', NULL),
  ('d45b0f45eb8d4004966ec29f58fc248d', '200715', '海口奇力制药股份有限公司', '注射用阿莫西林钠克拉维酸钾', 1.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '阿莫西林/克拉维酸钾', '粉针', '0.6g(5:1)', '1', 'emxl/klwsj,amxl/klwsj', NULL),
  ('d68622a325d1473db985c86550cc66d6', '200716', '晋城海斯制药有限公司', '曲克芦丁', 1.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '曲克芦丁', '粉针', '0.48g', '1', 'qklz,qkld', NULL),
  ('d6a6dbf624524fed86297ba6a9024d4e', '200717', '河南科伦药业有限公司', '5%葡萄糖', 0.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '5%葡萄糖', '大输液', '100ml(塑瓶)', '1', '5%ptt', NULL),
  ('d6a78044a49e450d9f3fc8d91775fc3e', '200718', '河南太龙药业股份有限公司', '5%葡萄糖', 0.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '瓶', '5%葡萄糖', '大输液', '100ml', '1', '5%ptt', NULL),
  ('d6a908446e6a4588a60a39bd9b4d1af9', '200719', '河南润弘制药股份有限公司', '无', 1.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '新斯的明', '注射液', '1ml:0.5mg', '1', 'xsdm', NULL),
  ('d6c8b594c842442b885ae6a4971dee4c', '200720', '石药集团中诺药业(石家庄)有限公司', '阿莫西林', 3.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '阿莫西林', '胶囊', '0.25g', '50', 'amxl,emxl', NULL),
  ('d6e00f1b27394a9a9ad51e3d788366dd', '200721', '山东鲁西药业有限公司', '布洛芬片', 2.58, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '布洛芬', '片剂', '0.2g', '100', 'blf', NULL),
  ('d6ed482eec5c49f9b4231730edf6283f', '200722', '成都第一制药有限公司', '克霉唑', 2.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '克霉唑', '栓剂', '0.15g', '10', 'kmz', NULL),
  ('d70a9e7d285446a69d6cccec171bc299', '200723', '山东华信制药', '20%甘露醇', 2.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '20%甘露醇', '大输液', '250ml', '1', '20%glc', NULL),
  ('d730a4d7c517463f985614f50ae7c22e', '200724', '上海现代哈森(商丘)药业有限公司', '单硝酸异山梨酯注射液', 1.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '支', '单硝酸异山梨酯', '注射液', '5ml:20mg', '1', 'cxsyslz,sxsyslz,dxsyslz', NULL),
  ('d748686eaeb64dab90db742bc8707eb4', '200725', '河南禹州市药王制药有限公司', '保和丸', 3.17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '保和丸', '水丸', '6g', '10', 'bhw', NULL),
  ('d78ff6b6fb0c427daa97f6a152e571d1', '200726', '河南中杰药业有限公司', '布洛芬片', 1.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '布洛芬', '片剂', '0.1g', '100', 'blf', NULL),
  ('d80e1bce4a3641e7a3aee87aca8129b1', '200727', '南京天朗制药有限公司', '氧氟沙星滴耳液', 1.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '氧氟沙星', '滴耳液', '8ml:24mg', '1', 'yfsx', NULL),
  ('d8e4dcb0536c4c48b9a39937a535f6a4', '200728', '齐鲁制药有限公司', '注射用顺铂', 8.14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '顺铂', '粉针', '20mg', '1', 'sb', NULL),
  ('d8f456b6a75d424abf650613e993d39d', '200729', '哈尔滨泰华药业股份有限公司', '乳癖消颗粒', 21.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '乳癖消颗粒', '颗粒剂', '8g(相当于原药材6g)', '6', 'rpxkl', NULL),
  ('d9927c1e020f4e14a2e8cafcfe83ea6f', '200730', '珠海联邦制药股份有限公司', '重组人胰岛素', 42.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '重组人胰岛素', '注射液', '3ml:300IU', '1', 'czryds,zzryds', NULL),
  ('d9f3c4422ffb49109dfc40f9431dd01d', '200731', '成都蓉药集团四川长威制药有限公司', '口服补液盐散(Ⅰ)', 7.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '口服补液盐Ⅰ', '散剂', '14.75g', '20', 'kfbyyⅰ', NULL),
  ('da207317cf174dce9875eb6e367d3f5b', '200732', '精华制药集团股份有限公司', '王氏保赤丸', 28.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '王氏保赤丸', '水丸', '0.15g(0.15g/60)', '20', 'wsbcw,wzbcw', NULL),
  ('da82dfae1923417faaac79dd3f7b2c42', '200733', '北京华润高科天然药物有限公司', '茵栀黄口服液', 29.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '茵栀黄口服液', '口服液', '10ml', '10', 'yzhkfy', NULL),
  ('da90291a932d4f08bc7aafc2d632dba2', '200734', '江苏远恒药业有限公司', '制霉素', 17.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '制霉素', '栓剂', '20WU', '14', 'zms', NULL),
  ('db890a8915bd4e4ea99aa6e8920c044d', '200735', '通化茂祥制药有限公司', '环磷酰胺', 3.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '环磷酰胺', '注射液', '0.2g', '10', 'hlxa', NULL),
  ('dbdfb66449c941a3b94d4c242424b3a7', '200736', '四川依科制药有限公司', '双氯芬酸钠', 0.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '双氯芬酸钠', '肠溶片', '25mg', '100', 'slfsn', NULL),
  ('dc334b70b1ee436fab37f256f4b7e17b', '200737', '开封康诺药业有限公司', '法莫替丁', 1.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '法莫替丁', '粉针', '20mg', '1', 'fmtz,fmtd', NULL),
  ('dca7f43153da44cf9dcd0ffb2f09413c', '200738', '天津中新药业集团股份有限公司第六中药厂', '清咽滴丸', 23.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '清咽滴丸', '滴丸', '20mg', '100', 'qydw', NULL),
  ('dcc4ed4cf6a843b8959274b62f04b3f3', '200739', '北京以岭药业有限公司', '参松养心胶囊', 26.01, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '参松养心胶囊', '胶囊', '0.4g', '36', 'csyxjn,ssyxjn', NULL),
  ('dd3e24fc3f124c689b761743160cf390', '200740', '云南个旧生物药业有限公司', '参麦注射液', 9.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '参麦注射液', '注射液', '20ml', '1', 'smzyy,cmzsy,cmzyy,smzsy', NULL),
  ('dda1d882853c440b9009a58def30d7b0', '200741', '马鞍山丰原制药有限公司', '三磷酸腺苷二钠', 1.14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '三磷酸腺苷二钠', '粉针', '20mg', '1', 'slsxgen', NULL),
  ('de55e55530cc42b79193f555fa1df04a', '200742', '湖南汉森制药股份有限公司', '泛影葡胺', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '泛影葡胺', '注射液', '20ml:12g', '1', 'fypa', NULL),
  ('dfbc19498e9a4a60af55fce22f5f5dc0', '200743', '哈尔滨一洲制药有限公司', '正舒', 5.26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '特拉唑嗪', '胶囊', '2mg', '14', 'tlzq', NULL),
  ('dfc14eabd54744d8a63d23362718f2a8', '200744', '海口奇力制药股份有限公司', '注射用利巴韦林', 0.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '利巴韦林', '粉针', '0.25g', '1', 'lbwl', NULL),
  ('e0817b62caf0441b8c67c98e089a055e', '200745', '保定市金钟制药有限公司', '无', 0.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '过氧化氢', '溶液剂', '100ml', '1', 'gyhq', NULL),
  ('e0a6cdb9a6b9400ab4955e4ea4ee166d', '200746', '安徽辉克药业有限公司', '维生素C', 0.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '瓶', '维生素C', '片剂', '50mg', '100', 'wssc', NULL),
  ('e1028caa072942c0aa0220607636bc27', '200747', '天津药业集团有限公司', '无', 1.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '支', '酮康唑', '乳膏剂', '10g:0.2g', '1', 'tkz', NULL),
  ('e1ebeb5616904091bdae58929b184ad5', '200748', '海口奇力制药股份有限公司', '盐酸左氧氟沙星胶囊', 1.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '左氧氟沙星', '胶囊', '0.1g', '12', 'zyfsx', NULL),
  ('e2454624ffbb430fb103cbc3f97bed51', '200749', '武汉健民集团随州药业有限公司', '健胃消食片', 4.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '盒', '健胃消食片', '片剂', '0.8g', '32', 'jwxsp,jwxyp', NULL);
  
  
  go
  --插入种类
Begin
	IF EXISTS(Select * From tempdb.dbo.Sysobjects Where 
		id = object_id(N'tempdb..#test') and type='U')  --查询表名是否存在  
		DROP table #test  
	create table #test(
		id int IDENTITY(1,1),
		name varchar(30));
	insert into #test(name) select distinct JX from ypxx;
	insert into 种类(ID,名称) select * from #test
end
go

--插入生产商
alter table 厂家
	alter column 厂名 varchar(128) not null;
Begin
	IF EXISTS(Select * From tempdb.dbo.Sysobjects Where 
		id = object_id(N'tempdb..#test3') and type='U')  --查询表名是否存在  
		DROP table #test3  ;
	create table #test3(
		id int IDENTITY(1,1),
		name varchar(128),
		addres char(3) not null default '123',
		tele char(3) not null default '123');
	insert into #test3(name) select distinct SCQYMC from ypxx;
	insert into 厂家(厂商ID,厂名,地址,电话) select * from #test3;
end
go
--插入药品
begin
insert into 药品(药品ID,药名,种类ID,进价,售价,生产商ID)
 select	BM,MC,种类.ID,ZBJG,ZBJG+1,厂商ID
	from ypxx,种类,厂家
		where 种类.名称 = JX and 厂家.厂名 = SCQYMC;
end

go
-------------原始客户数据
CREATE TABLE  userjd  (
   ID  varchar(64) NOT NULL,
   MC  varchar(128) NOT NULL,
   DZ  varchar(256) DEFAULT NULL,
   YZBM  varchar(32) DEFAULT NULL,
   XLR  varchar(64) DEFAULT NULL  ,
   DH  varchar(64) DEFAULT NULL   ,
   CZ  varchar(64) DEFAULT NULL   ,
   DZYX  varchar(128) DEFAULT NULL ,
   WZ  varchar(128) DEFAULT NULL   ,
   VCHAR1  varchar(128) DEFAULT NULL,
   VCHAR2  varchar(128) DEFAULT NULL,
   VCHAR3  varchar(128) DEFAULT NULL,
   DQ  varchar(1024) DEFAULT NULL  ,
  PRIMARY KEY (ID)
);
go
-- ----------------------------
-- Records of userjd
-- ----------------------------
INSERT INTO  userjd  VALUES ('0d498b73-067e-11e3-8a3c-0019d2ce5116', '荥阳市卫生局', null, null, null, null, null, null, null, null, null, null, '1.');
INSERT INTO  userjd  VALUES ('15819c06-09a1-11e3-8a4f-60a44cea4388', '崔庙镇卫生院', '崔庙镇工业路', '410131', null, '32', '432', 'fdsfds', '432', null, null, null, '1.1.');
INSERT INTO  userjd  VALUES ('2084aa4a-067e-11e3-8a3c-0019d2ce5116', '汜水镇卫生院', null, null, null, null, null, null, null, null, null, null, '1.10.');
INSERT INTO  userjd  VALUES ('c4c1c750-067e-11e3-8a3c-0019d2ce5116', '高山镇卫生院', null, null, null, null, null, null, null, null, null, null, '1.11.');
INSERT INTO  userjd  VALUES ('c58c043a-067e-11e3-8a3c-0019d2ce5116', '城关乡卫生院', null, null, null, null, null, null, null, null, null, null, '1.12.');
INSERT INTO  userjd  VALUES ('c890f6ee-067e-11e3-8a3c-0019d2ce5116', '刘河镇卫生院', '刘河镇兴刘路北段', '450132', null, null, null, null, null, null, null, null, '1.13.');
INSERT INTO  userjd  VALUES ('c994c0bb-067e-11e3-8a3c-0019d2ce5116', '环翠峪卫生院', '荥阳市环翠峪', '450132', null, null, null, null, null, null, null, null, '1.14.');
INSERT INTO  userjd  VALUES ('c9c7c495-067e-11e3-8a3c-0019d2ce5116', '贾峪镇卫生院', null, '450123', null, null, null, null, null, null, null, null, '1.15.');
INSERT INTO  userjd  VALUES ('cbb4d0be-067e-11e3-8a3c-0019d2ce5116', '豫龙镇卫生院', null, null, null, null, null, null, null, null, null, null, '1.2.');
INSERT INTO  userjd  VALUES ('cd69a32c-067e-11e3-8a3c-0019d2ce5116', '索河卫生院', null, '450100', null, null, null, null, null, null, null, null, '1.3.');
INSERT INTO  userjd  VALUES ('cd9a55a7-067e-11e3-8a3c-0019d2ce5116', '京城卫生院', null, '4501000', null, null, null, null, null, null, null, null, '1.4.');
INSERT INTO  userjd  VALUES ('ce9ddaa9-067e-11e3-8a3c-0019d2ce5116', '乔楼镇卫生院', null, null, null, null, null, null, null, null, null, null, '1.5.');
INSERT INTO  userjd  VALUES ('cf4025a8-067e-11e3-8a3c-0019d2ce5116', '广武镇卫生院', '荥阳市广武镇中心卫生院', '450100', null, null, null, null, null, null, null, null, '1.6.');
INSERT INTO  userjd  VALUES ('d2b358ef-067e-11e3-8a3c-0019d2ce5116', '高村乡卫生院', null, null, null, null, null, null, null, null, null, null, '1.7.');
INSERT INTO  userjd  VALUES ('d48cb84b-067e-11e3-8a3c-0019d2ce5116', '金寨乡卫生院', '荥阳市金寨同心路', '450100', null, null, null, null, null, null, null, null, '1.8.');
INSERT INTO  userjd  VALUES ('d4aaf7bd-067e-11e3-8a3c-0019d2ce5116', '王村镇卫生院', '王村镇金滩市场', '450142', null, null, null, null, null, null, null, null, '1.9.');
go
--插入客户
Begin
alter table 客户
	alter column 姓名 varchar(64) not null
	IF EXISTS(Select * From tempdb.dbo.Sysobjects Where 
		id = object_id(N'tempdb..#test2') and type='U')  --查询表名是否存在  
		DROP table #test2  
	create table #test2(
		id int IDENTITY(1,1),
		name varchar(64),
		tele char(11) not null default '123');
	insert into #test2(name) select distinct MC from userjd;
	insert into 客户(客户ID,姓名,电话) select * from #test2;
end
go
---------插入进货单相关数据
insert into 进货单
	values('00000000010',
	GETDATE(),GETDATE(),
	'1','000004'
	);
	
insert into 进货单详细表
	values('00000000010',
	'200001','12','7.1','2017-12-1'),
	('00000000010',
	'200000','25','3.5','2017-5-24'),
	('00000000010',
	'200002','45','1.6','2017-12-1');
	
--------插入售货单相关数据
insert into 售货单
	values('00000000010',
	GETDATE(),GETDATE(),
	'1','000003'
	);

insert into 售货单详细表
values('00000000010',
	'200001','2','8.1','2017-12-1'),
	('00000000010',
	'200000','5','4.5','2017-5-24');

---------库存数据
insert into 库存
	values('200001','2017-12-1',
	'2018-12-1','10'),
	('200000','2017-5-24',
	'2018-5-24','20'),
	('200002','2017-12-1',
	'2018-12-1','45');
go
------------------------------------------------------------------------

------------分割字符串函数
CREATE FUNCTION dbo.f_splitstr(@SourceSql   NVARCHAR(MAX),@StrSeprate   VARCHAR(100))   
  RETURNS   @temp   TABLE(F1   VARCHAR(100))   
  AS     
  BEGIN   
  DECLARE   @ch   AS   VARCHAR(100)   
  SET   @SourceSql=@SourceSql+@StrSeprate     
  WHILE(@SourceSql<>'')   
                  BEGIN   
                  SET   @ch=LEFT(@SourceSql,CHARINDEX(@StrSeprate,@SourceSql,1)-1)   
  INSERT   @temp   VALUES(@ch)   
  SET   @SourceSql=STUFF(@SourceSql,1,CHARINDEX(@StrSeprate,@SourceSql,1),'')   
                  END   
  RETURN   
  END
GO
 
--测试 SELECT * FROM dbo.f_splitstr('300,2000,3000,4000',',')


--插入进货单数据
--参数：@buyID 进货单ID,
--	@produceID 厂家ID,@buyerID 进货员ID,
--	@drugID 药品ID,@num 数量,
--	@produceDate 生产日期,@vaildDate 有效期至
go
create procedure dbo.insert_buy_data(@buyID varchar(11),
	@produceID varchar(6),@buyerID varchar(6),
	@drugID varchar(MAX),@num varchar(MAX),
	@produceDate varchar(MAX),@vaildDate varchar(MAX))
as
begin
	begin try 
	begin transaction innerTrans 
	save transaction savepoint --创建事务保存点 
	
	declare @i as int --药品行，插入成功返回0，否则返回对应行
	insert into 进货单
		values(@buyID,GETDATE(),GETDATE(),
		@produceID,@buyerID);
	DECLARE @table1 TABLE (ID1 INT IDENTITY(1,1),F1 varchar(50));--药品ID
	DECLARE @table2 TABLE (ID2 INT IDENTITY(1,1),F2 int);--数量
	DECLARE @table3 TABLE (ID3 INT IDENTITY(1,1),F3 varchar(20));--生产日期
	DECLARE @table4 TABLE (ID4 INT IDENTITY(1,1),F4 varchar(20));--有效期
	
	insert into @table1 select * from dbo.f_splitstr(@drugID,',');
	insert into @table2 select * from dbo.f_splitstr(@num,',');
	insert into @table3 select * from dbo.f_splitstr(@produceDate,',');
	insert into @table4 select * from dbo.f_splitstr(@vaildDate,',');
	
	insert into dbo.进货单详细表(进货单ID,药品ID,数量,进价,生产日期)
		select @buyID,F1,F2,进价,F3 
		from @table1,@table2,@table3,
			(select 药品ID,进价 from dbo.药品) as price
			 where ID1=ID2 and ID2=ID3 and F1 = price.药品ID;
	
	declare searchCursor cursor    --声明一个游标，查询满足条件的数据
        for select F1,F2,F3,F4 from @table1,@table2,@table3,@table4
			 where ID1=ID2 and ID2=ID3 and ID3=ID4;
    
    open searchCursor    --打开
    
    declare @name varchar(50),@num1 int,
		@date1 varchar(20),@date2 varchar(20)    --声明一个变量，用于读取游标中的值
        fetch next from searchCursor into @name,@num1,@date1,@date2;
    
    while @@fetch_status=0    --循环读取
        begin
        --print @noToUpdate
			IF EXISTS(Select * From dbo.库存 Where 
				药品ID = @name and 生产日期 = @date1) 
				begin 
					update dbo.库存 set 库存 = 库存 + @num1 where 
						药品ID = @name and 生产日期 = @date1
					fetch next from searchCursor into @name,@num1,@date1,@date2
				end
			else
				begin
					insert into dbo.库存  values
						(@name,@date1,@date2,@num1);
					fetch next from searchCursor into @name,@num1,@date1,@date2
				end
        end
    
    close searchCursor    --关闭
    
   deallocate searchCursor    --删除

	commit transaction innerTrans 
	end try 
	begin catch 
	rollback transaction savepoint --回滚到保存点 
	commit transaction innerTrans 
	end catch 
	
	end
go
--测试 插入进货数据
--exec dbo.insert_buy_data '00000000004','1','000004',
--	'200002,200001,200006','11,12,13','2017-2-1,2017-2-1,2017-1-3',
--	'2018-1-1,2018-1-1,2018-1-3'
	
	
--插入售货单数据
--参数：@saleID 售货单ID,
--	@customerID 客户ID,@salerID 售货员ID,
--	@drugID 药品ID,@num 数量
go
create procedure dbo.insert_sale_data(@saleID varchar(11),
	@customerID varchar(6),@salerID varchar(6),
	@drugID varchar(MAX),@num varchar(MAX))
as
begin
	begin try 
	begin transaction innerTrans 
	save transaction savepoint --创建事务保存点 
	
	insert into 售货单
		values(@saleID,GETDATE(),GETDATE(),
		@customerID,@salerID);
	DECLARE @table1 TABLE (ID1 INT IDENTITY(1,1),F1 varchar(50));--药品ID
	DECLARE @table2 TABLE (ID2 INT IDENTITY(1,1),F2 int);--数量
	
	insert into @table1 select * from dbo.f_splitstr(@drugID,',');
	insert into @table2 select * from dbo.f_splitstr(@num,',');
	
	declare searchCursor cursor    --声明一个游标，查询满足条件的数据
        for select F1,F2 from @table1,@table2 where ID1=ID2;
    
    open searchCursor    --打开
    
    declare @name varchar(50),@num1 int  --声明一个变量，用于读取游标中的值
        fetch next from searchCursor into @name,@num1;
    
    while @@fetch_status=0    --循环读取
        begin
        --print @noToUpdate
			IF EXISTS(Select * From dbo.库存 Where 
				药品ID = @name and @num1<=(select sum(库存) from dbo.库存 Where 
												药品ID = @name)) --所有的库存总额满足需求
			begin
				declare @i int
				while @num1<>0
				begin
					set @i = (select 库存 from dbo.库存 where @name=药品ID and 生产日期=
							(select MAX(生产日期) from dbo.库存 where @name=药品ID ));
					if @i<=@num1 --最早的药不够卖or刚刚好
					begin
						insert into dbo.售货单详细表
							(售货单ID,药品ID,数量,售价,生产日期)
						select @saleID,@name,@i,售价,a 
						from (select 售价 from dbo.药品 where 药品ID=@name) as price,
							 (select MAX(生产日期) a from dbo.库存 where @name=药品ID) as dateBiao;
						delete from dbo.库存  where 
							药品ID = @name and 生产日期 = (select MAX(生产日期) 
														from dbo.库存 where @name=药品ID );
						set @num1 = @num1 - @i;
					end
					else --最早的药够卖
					begin
						insert into dbo.售货单详细表
							(售货单ID,药品ID,数量,售价,生产日期)
						select @saleID,@name,@num1,售价,a 
						from (select 售价 from dbo.药品 where 药品ID=@name) as price,
							 (select MAX(生产日期) a from dbo.库存 where @name=药品ID) as dateBiao;
						update dbo.库存 set 库存=库存-@num1  where 
							药品ID = @name and 生产日期 = (select MAX(生产日期) 
													from dbo.库存 where @name=药品ID );
						break
					end
				end
				fetch next from searchCursor into @name,@num1
			end
			else --药品不存在or不满足需求
				begin
					rollback transaction savepoint --回滚到保存点 
					break
				end
        end
    
    close searchCursor    --关闭
    
   deallocate searchCursor    --删除

	commit transaction innerTrans 
	end try 
	begin catch 
	select error_number() as error_number ,  
             error_message() as error_message --输出异常信息
	rollback transaction savepoint --回滚到保存点 
	commit transaction innerTrans 
	end catch 
	
	end
go
--测试 
--exec dbo.insert_sale_data '00000000005','1','000003',
--	'200002,200001,200006','22,45,61'
	
--测试 插入进货数据
--exec dbo.insert_buy_data '00000000007','1','000004',
--	'200002,200001,200006','11,50,13','2017-2-1,2017-1-1,2017-1-3',
--	'2018-1-1,2018-1-1,2018-1-3'


---------------------------
-----权限
GRANT EXECUTE ON dbo.insert_buy_data TO buyer;

GRANT EXECUTE ON dbo.insert_sale_data To saler;

--------------------------------------------------------
go
CREATE function get_SaleNO()
	Returns int
  AS     
  BEGIN   
   declare @i int
   set @i = ( select Max(售货单ID) from 售货单) + 1
   return @i
  END
go
GRANT EXECUTE ON dbo.get_SaleNO TO saler;--saler的执行权限
DENY SELECT ON dbo.f_splitstr TO saler;--删除分割函数的权限
go
--get_SaleNO()函数功能：获取要创建的售货单ID（即获取当前数据库中的最大ID加1后返回）
--测试 select dbo.get_SaleNO()

CREATE function get_BuyNO()
	Returns int
  AS     
  BEGIN   
   declare @i int
   set @i = ( select Max(进货单ID) from 进货单) + 1
   return @i
  END
go
GRANT EXECUTE ON dbo.get_BuyNO TO buyer;--buyer的执行权限
DENY SELECT ON dbo.f_splitstr TO buyer;--删除分割函数的权限
go
--get_BuyNO()函数功能：获取要创建的进货单ID（即获取当前数据库中的最大ID加1后返回）
--测试 select dbo.get_BuyNO()

CREATE function get_员工NO()
	Returns int
  AS     
  BEGIN   
   declare @i int
   set @i = ( select Max(员工ID) from 员工) + 1
   return @i
  END
go
GRANT EXECUTE ON dbo.get_员工NO TO shujuku;
go
--get_员工NO()函数功能：获取要创建的员工ID（即获取当前数据库中的最大ID加1后返回）
--测试 select dbo.get_员工NO()


--------------------------
--检查库存内的药品是否过期的存储过程
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[check_invaildDrug]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT',N'X',N'P'))
DROP procedure [dbo].[check_invaildDrug]
GO
CREATE procedure check_invaildDrug
  AS     
  BEGIN   
	begin try 
	begin transaction innerTrans 
	save transaction savepoint --创建事务保存点 
	
	declare searchCursor cursor    --声明一个游标，查询满足条件的数据
        for select 药品ID,生产日期,有效期至 from 库存;
    
    open searchCursor    --打开
    
    declare @ID varchar(6),
		@date1 varchar(20),@date2 varchar(20)    --声明一个变量，用于读取游标中的值
        fetch next from searchCursor into @ID,@date1,@date2;
    
    while @@fetch_status=0    --循环读取
        begin
			IF  GETDATE()>@date2
				begin 
					IF EXISTS(Select * From dbo.退厂 Where 
						药品ID = @ID and 生产日期 = @date1) 
					begin
						declare @num int;
						set @num = (select 库存 from 库存 
						where 药品ID=@ID and 生产日期=@date1);
						update dbo.退厂 set 库存 = 库存 + @num where 
						药品ID = @ID and 生产日期 = @date1;
						delete from 库存 where 药品ID=@ID and 生产日期=@date1;
					end
					else
					begin
						insert into 退厂 select * from 库存 
						where 药品ID=@ID and 生产日期=@date1;
						delete from 库存 where 药品ID=@ID and 生产日期=@date1;
					end
					fetch next from searchCursor into @ID,@date1,@date2
				end
			else
				begin
					fetch next from searchCursor into @ID,@date1,@date2
				end
        end
    
    close searchCursor    --关闭
    
   deallocate searchCursor    --删除
	
	commit transaction innerTrans 
	end try 
	begin catch 
	select error_number() as error_number ,  
             error_message() as error_message --输出异常信息
	rollback transaction savepoint --回滚到保存点 
	commit transaction innerTrans 
	end catch 
  END
go
GRANT EXECUTE ON dbo.check_invaildDrug TO shujuku;--管理员的执行权限
go
--测试 exec dbo.check_invaildDrug
--------------------------

------------------------------------------------------
--管理员的进货单视图 及 授权
create view view_admin_进货单(进货单ID,日期,时间,厂家ID,厂家名,进货员ID,进货员名称)
as 
select 进货单ID,日期,时间,厂家ID,厂名,进货员ID,姓名
	from 员工,进货单,厂家
		where 进货单.厂家ID=厂家.厂商ID and 进货单.进货员ID=员工.员工ID;
go
GRANT select on dbo.view_admin_进货单 to shujuku;
go

--管理员的售货单视图 及 授权
create view view_admin_售货单(售货单ID,日期,时间,客户ID,客户名,售货员ID,售货员名称)
as 
select 售货单ID,日期,时间,客户.客户ID,客户.姓名,售货员ID,员工.姓名
	from 员工,售货单,客户
		where 售货单.客户ID=客户.客户ID and 售货单.售货员ID=员工.员工ID;
go
GRANT select on dbo.view_admin_售货单 to shujuku;
go

--管理员的药品表视图 及 授权
create view view_admin_药品总表 (药品ID,药名,种类ID,种类名称,进价,售价,
						厂家ID,厂家名称,库存总量)
as 
select 药品.药品ID,药名,种类ID,名称,进价,售价,厂家.厂商ID,厂名,总量
	from 药品,种类,厂家,(select 药品ID,SUM(库存) 总量 from 库存 group by 药品ID) as 库存量
		where 药品.种类ID=种类.ID and 药品.生产商ID=厂家.厂商ID and 药品.药品ID=库存量.药品ID;
go
GRANT select on dbo.view_admin_药品总表 to shujuku;
go

--管理员的药品种类表视图 及 授权
create view view_admin_药品信息 (药品ID,药名,种类ID,种类名称,进价,售价,
						厂家ID,厂家名称)
as 
select 药品.药品ID,药名,种类ID,名称,进价,售价,厂家.厂商ID,厂名
	from 药品,种类,厂家
		where 药品.种类ID=种类.ID and 药品.生产商ID=厂家.厂商ID;
go
GRANT select on dbo.view_admin_药品信息 to drugmanager;
go

--添加视图
-------------管理员的 退厂视图 及 授权
create view view_admin_退厂 (药品ID,药名,生产日期,有效期,库存)
as 
select 药品.药品ID,药名,生产日期,有效期至,库存
	from 药品,退厂
		where 药品.药品ID=退厂.药品ID;
go
GRANT select on dbo.view_admin_退厂 to shujuku;
go

-------------管理员的 库存视图 及 授权
create view view_admin_库存 (药品ID,药名,生产日期,有效期,库存)
as 
select 药品.药品ID,药名,生产日期,有效期至,库存
	from 药品,库存
		where 药品.药品ID=库存.药品ID;
go
GRANT select on dbo.view_admin_库存 to shujuku;
go

-------------管理员的 进货单详细表视图 及 授权
create view view_admin_进货单详细 (进货单ID,药品ID,药名,数量,进价,生产日期,厂家ID,厂名,进货员ID,进货员名)
as 
select 进货单详细表.进货单ID,进货单详细表.药品ID,药名,数量,进货单详细表.进价,进货单详细表.生产日期,
		进货单.厂家ID,厂家.厂名,进货单.进货员ID,员工.姓名
	from 进货单,进货单详细表,药品,员工,厂家
		where 进货单详细表.进货单ID=进货单.进货单ID and 进货单详细表.药品ID=药品.药品ID and
			进货单.进货员ID=员工.员工ID and 进货单.厂家ID=厂家.厂商ID;
go
GRANT select on dbo.view_admin_进货单详细 to shujuku;
go

-------------管理员的 售货单详细表视图 及 授权
create view view_admin_售货单详细 (售货单ID,药品ID,药名,数量,售价,生产日期,客户ID,客户名,售货员ID,售货员名)
as 
select 售货单详细表.售货单ID,售货单详细表.药品ID,药名,数量,售货单详细表.售价,售货单详细表.生产日期,
		售货单.客户ID,客户.姓名,售货单.售货员ID,员工.姓名
	from 售货单,售货单详细表,药品,员工,客户
		where 售货单详细表.售货单ID=售货单.售货单ID and 售货单详细表.药品ID=药品.药品ID and
			售货单.售货员ID=员工.员工ID and 售货单.客户ID=客户.客户ID;
go
GRANT select on dbo.view_admin_售货单详细 to shujuku;
go

---------------------------------------------
-------索引
  create index 药名索引 on 药品(药名);
  create index 厂名索引 on 厂家(厂名);
  create index 客户名索引 on 客户(姓名);
go
-----------------------------------------------



----------�������ݿ��ļ�
create database drugmanager
on
(name = drugmanager,
filename = 'E:\code\GitCode\���ݿ����\drugmanager.mdf',
size = 10,
maxsize = 60,
filegrowth = 5%
)
log on
(name = drugmanager_log,
filename = 'E:\code\GitCode\���ݿ����\drugmanager.ldf',
size = 4,
maxsize = 10,
filegrowth = 1
);
go
---------------------------------

-------------����������
use drugmanager
go
create table Ա��
(Ա��ID char(6) primary key,
���� varchar(16) NOT NULL,
���� varchar(16) NOT NULL,
�绰 varchar(11) NOT NULL,
ְλ varchar(16) NOT NULL,
�쵼ID char(6) FOREIGN KEY(�쵼ID) REFERENCES Ա��(Ա��ID)
);
---------Ա����ְλ��Լ��
alter table Ա��
 add constraint ְλ������ check(ְλ in('����Ա','ҩƷ����Ա','�ۻ�Ա','����Ա','�˻�Ա'));
 
create table ����
(����ID char(6) primary key,
���� varchar(30) NOT NULL,
��ַ varchar(30) NOT NULL,
�绰 varchar(11) NOT NULL
);
create table ������
(������ID varchar(11) primary key,
���� date NOT NULL,
ʱ�� time NOT NULL,
����ID char(6) NOT NULL FOREIGN KEY(����ID) REFERENCES ����(����ID),
����ԱID char(6) NOT NULL FOREIGN KEY(����ԱID) REFERENCES Ա��(Ա��ID)
);
create table �ͻ�
(�ͻ�ID char(6) primary key,
���� varchar(16) NOT NULL,
�绰 varchar(11) NOT NULL
);
create table �ۻ���
(�ۻ���ID varchar(11) primary key,
���� date NOT NULL,
ʱ�� time NOT NULL,
�ͻ�ID char(6) NOT NULL FOREIGN KEY(�ͻ�ID) REFERENCES �ͻ�(�ͻ�ID),
�ۻ�ԱID char(6) NOT NULL FOREIGN KEY(�ۻ�ԱID) REFERENCES Ա��(Ա��ID)
);
create table ����
(ID char(6) primary key,
���� varchar(10) NOT NULL,
����ID char(6) FOREIGN KEY(����ID) REFERENCES ����(ID)
);
create table ҩƷ
(ҩƷID char(6) primary key,
ҩ�� varchar(30) NOT NULL,
����ID char(6) NOT NULL FOREIGN KEY(����ID) REFERENCES ����(ID),
���� real NOT NULL,
�ۼ� real NOT NULL,
������ID char(6) NOT NULL FOREIGN KEY(������ID) REFERENCES ����(����ID)
);
create table ��������ϸ��
(������ID varchar(11) FOREIGN KEY(������ID) REFERENCES ������(������ID),
ҩƷID char(6) FOREIGN KEY(ҩƷID) REFERENCES ҩƷ(ҩƷID),
primary key(������ID,ҩƷID),
���� int NOT NULL,
���� real NOT NULL,
�������� date not null
);
create table �ۻ�����ϸ��
(�ۻ���ID varchar(11) FOREIGN KEY(�ۻ���ID) REFERENCES �ۻ���(�ۻ���ID),
ҩƷID char(6) FOREIGN KEY(ҩƷID) REFERENCES ҩƷ(ҩƷID),
���� int NOT NULL,
�ۼ� real NOT NULL,
�������� date not null,
primary key(�ۻ���ID,ҩƷID,��������),
);
create table ���
(ҩƷID char(6) FOREIGN KEY(ҩƷID) REFERENCES ҩƷ(ҩƷID),
�������� date NOT NULL,
primary key(ҩƷID,��������),
��Ч���� date NOT NULL,
��� int NOT NULL
);
create table �˳�
(ҩƷID char(6) FOREIGN KEY(ҩƷID) REFERENCES ҩƷ(ҩƷID),
�������� date NOT NULL,
primary key(ҩƷID,��������),
��Ч���� date NOT NULL,
��� int NOT NULL
);
go
---------------------------------------------���ݿ��û� ����
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
GRANT INSERT,UPDATE,DELETE ON Ա�� TO shujuku
GRANT DELETE ON ��� TO shujuku
GRANT INSERT ON �˳� TO shujuku
go
create login drugmanager with password='drugmanager',default_database = drugmanager
create user drugmanager for login drugmanager with default_schema=dbo
GRANT SELECT ON Ա�� TO drugmanager
GRANT SELECT,INSERT,UPDATE,DELETE ON ҩƷ TO drugmanager
GRANT SELECT,INSERT,UPDATE,DELETE ON ���� TO drugmanager
go
create login saler with password='saler',default_database = drugmanager
create user saler for login saler with default_schema=dbo
GRANT SELECT ON Ա�� TO saler
GRANT SELECT,INSERT,UPDATE,DELETE ON �ͻ� TO saler
GRANT INSERT ON �ۻ��� TO saler
GRANT INSERT ON �ۻ�����ϸ�� TO saler
GRANT DELETE,UPDATE ON ��� TO saler
go
create login buyer with password='buyer',default_database = drugmanager
create user buyer for login buyer with default_schema=dbo
GRANT SELECT ON Ա�� TO buyer
GRANT SELECT,INSERT,UPDATE,DELETE ON ���� TO buyer
GRANT INSERT ON ������ TO buyer
GRANT INSERT ON ��������ϸ�� TO buyer
GRANT INSERT,UPDATE ON ��� TO buyer
go
create login returngooder with password='returngooder',default_database = drugmanager
create user returngooder for login returngooder with default_schema=dbo
GRANT SELECT ON Ա�� TO returngooder
GRANT SELECT,DELETE ON ��� TO returngooder
GRANT SELECT,INSERT,DELETE ON �˳� TO returngooder
go
---------------------------------------

insert into Ա��
values('000001','�ϰ�','123456',
   '1234567890','����Ա',null);
insert into Ա��
	values('000002','����','123456','1234567890',
			'ҩƷ����Ա','000001');
insert into Ա��
	values('000003','����','123456','1234567890',
			'�ۻ�Ա','000001');
insert into Ա��
	values('000004','������','123456','1234567890',
			'����Ա','000001');
insert into Ա��
	values('000005','��ɯ','123456','1234567890',
			'�˻�Ա','000001');
go
---------------------------------------------

use drugmanager
go
---------------ԭʼҩƷ����
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
VALUES ('4c7c18fa633748568c1f5aecb3d98e1b', '200176', '����ʡ��Ȫ��ҩ���޹�˾', '��ν�θ��', 22.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ν�θ��', 'ˮ��', '12g', '40', 'sgjww', NULL),
  ('4cc4e8160f7641f88a25ef3cd29a2caf', '200177', '�����н���ҩҵ���޹�˾', '֪�صػ���', 3.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '֪�صػ���', 'ˮ����', '60g', '1', 'zbdhw', NULL),
  ('4dc12e14a6944559b6b592d0efbe0f8b', '200178', '�Ĵ�־Զ�α�ҩҵ�������ι�˾', '��Ŀ����Ƭ', 9.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��Ŀ����Ƭ', 'Ƭ��', '0.64g', '60', 'mmsqp', NULL),
  ('4dd7e4b6faa84d9da58c787346048437', '200179', '�������ҩҵ�ɷ����޹�˾', '���Ծ�ע��Һ', 30.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���Ծ�ע��Һ', 'ע��Һ', '10ml', '1', 'xnjzyy,xnjzsy', NULL),
  ('4eb16cf5d09f42f78a6899bf270b04cd', '200180', '�㶫�����ҩ���޹�˾', '��ʯͨƬ', 4.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ʯͨƬ', 'Ƭ��', '�ɽ���0.25g', '100', 'jdtp,jstp', NULL),
  ('4f00404998f844fd91f72cf4fedd520c', '200181', '��������������ҩ���޹�˾', '����ƽ', 45.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������Ƭ', 'Ƭ��', '50mg', '30', 'eqbtp,ekbtp,akbtp,aqptp,akptp,ekptp,aqbtp,eqptp', NULL),
  ('4fd91a66a78b4a7f9dd20d3f566bf5a6', '200182', 'ɽ������ҩҵ�ɷ����޹�˾', '׳��������', 4.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '׳��������', '������', '5.6g', '10', 'zyjsw', NULL),
  ('4fe5a49a5a30468c9a42415caf1f5bb1', '200183', '�㶫ǿ��ҩҵ���޹�˾', '������', 29.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���������', '���ܽ���', '0.25g', '24', 'ldhpd,ldhbd', NULL),
  ('4fe9076d6fbd4651b1b9185da2339e03', '200184', '���������ҩ�ɷ����޹�˾', '��', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�������հ�', 'ע��Һ', '1ml:10mg', '1', 'jylpa', NULL),
  ('4ff078a50c5e4b498e90243a4e71d4fd', '200185', '�Ϻ���ɽҩҵ���޹�˾', '��ŵ����', 4.93, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ŵ����', 'Ƭ��', '0.1g', '100', 'fnbt', NULL),
  ('50b7d506a40a41fe8c2bb3e2cd1ae1fc', '200186', '�Ĵ�������ҩ���޹�˾', '����������Ƭ', 2.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����������Ƭ', 'Ƭ��', '30mg', '100', 'ffhlsp', NULL),
  ('5155f8d1753a49d58fea8e9d208f7d23', '200187', '���ϻ�����ҩ���޹�˾', '��������', 8.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', 'ˮ����', '3.2g��1.6g/10��', '12', 'mrrcw', NULL),
  ('51a68eb4f40d46a8b661d0ab9ec18a51', '200188', '�Ϻ��ִ���ɭ(����)ҩҵ���޹�˾', '���Ǳ����ע��Һ', 0.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���Ǳ����', 'ע��Һ', '2ml:0.25g', '1', 'eqbcj', NULL),
  ('528bbec5eae34b25a228e606995fcc9b', '200189', '�ɶ�������ҩ���޹�˾', '�����ۻ��ڷ���Һ', 25.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����ۻ��ڷ���Һ', '�ڷ�Һ', '10ml', '10', 'yxmhkfry', NULL),
  ('538ba7f2cff04dd0811ccabf9db9d8f3', '200190', '��������ҩҵ���޹�˾', '���Ƚⶾ�ڷ�Һ', 9.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���Ƚⶾ�ڷ�Һ', '�ڷ�Һ', '10ml(������)', '10', 'qrxdkfy,qrjdkfy', NULL),
  ('53f7e251f3f5480ba88b505a8ea1f31c', '200191', '�Ϻ��񶫺���ҩҵ���޹�˾', '��', 1.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '�Ȱ����', 'ע��Һ', '20ml:6.3g', '1', 'yasj,gasj', NULL),
  ('5405995fbba44f14a7e052b8bba32a58', '200192', '�˲��˸�ҩҵ�������ι�˾', '������͡����', 12.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������͡', '����', '10mg', '24', 'xftt', NULL),
  ('5410a6c1fb0e4caf9e0fac8e79b737cc', '200193', '��ʿ����ҩ���Źɷ����޹�˾', '�������', 12.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������', '����', '0.551g', '10', 'chdw', NULL),
  ('545cc7658f394f968f165a38a1667d37', '200194', '�人����ҩҵ���Źɷ����޹�˾', '�ڼ��׷���', 4.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ڼ��׷���', '������', '9g', '10', 'wjbfw', NULL),
  ('5478c41194f04e75bb4c671d0f6e1bf3', '200195', '���Ͽ�����ҩ���޹�˾', 'ͷ������', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ������', '����', '1.0g', '1', 'tbld', NULL),
  ('55340070b44f49f7b1c789ec048d3cf2', '200196', '�Ϻ�����ҩҵ���޹�˾', '���᲼�ȿ���ע��Һ', 0.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���ȿ���', 'ע��Һ', '5ml:37.5mg', '1', 'bbqy,bbky', NULL),
  ('55890b034e234712b159dfacc34b40cc', '200197', '�ӱ����ҩҵ�ɷ����޹�˾', '�Ȼ���ע��Һ', 0.14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '0.9%�Ȼ���', 'ע��Һ', '10ml', '1', '0.9%lhn', NULL),
  ('55c08af7724746e6896330d3999afacb', '200198', '����ҩҵ�ɷ����޹�˾', '���������������Һ', 1.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�������', '����Һ', '5ml:25mg', '1', 'smle', NULL),
  ('563723fdae09473ea241337f80e14192', '200199', '���պ���ҽҩ�ɷ����޹�˾', '����', 7.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�����', '����Һ', '100ml:2.0g', '1', 'blf', NULL),
  ('57d15cbc5ee048288ef0782875b89612', '200200', '����������ҩ���޹�˾', '��ĸ�ݽ���', 21.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ĸ�ݽ���', '����', '0.35g', '36', 'ymcjn', NULL),
  ('5883b0de354c4873bdb601cb5d8a1eea', '200201', '���Ͽ���ҩҵ�ɷ����޹�˾', '޽������Ƭ', 4.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '޽������Ƭ', 'Ƭ��', '0.3g', '36', 'hxzqp', NULL),
  ('86b883c9b69545bd8b6c79bd90515896', '200202', '�㽭�����ҩ�ɷ����޹�˾', '����������Ƭ', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����������Ƭ', 'Ƭ��', '5mg', '100', 'cspnsp', NULL),
  ('86b962408f8840f6a05a58aac720b8b2', '200203', '�Ϻ�ҽ����е(����)���޹�˾�������ϳ�', '�ؽ�ֹʹ��', 0.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ؽ�ֹʹ��', '�𽺸��', '7cm*10cm', '2', 'gjztg', NULL),
  ('86f8f0650fcd4eaf9ca8ed931e5013be', '200204', '�ߺ��ź㴺ҩҵ���޹�˾', '��ɰ��θ��', 2.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ɰ��θ��', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'xsyww', NULL),
  ('8716ba5a0c4e447c9859cdaa220ef49f', '200205', 'ʯ��ׯ����ҩҵ�ɷ����޹�˾', '������������', 11.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������������', '����', '0.35g', '24', 'lhqwjn', NULL),
  ('04f12f0e8de34d0ab6fe104a28eea0e9', '200206', '�ӱ����ҩҵ�ɷ����޹�˾', '̼������ע��Һ', 0.14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '̼������', 'ע��Һ', '10ml:0.5g', '1', 'tsqn', NULL),
  ('052bd08468054a508945edc0663ef907', '200207', '���������ҩ�ɷ����޹�˾', 'ά����B4', 3.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', 'ά����B4', 'Ƭ��', '10mg', '100', 'wssb4', NULL),
  ('05c4a8928cfa4cd3b27f250a563f7159', '200208', '�㽭̩��ɭҩҵ���޹�˾', '����ͬ', 26.17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ƽ', '����Ƭ', '20mg', '60', 'xbdp', NULL),
  ('067bd0c00aa34e8e860a2842f46865a3', '200209', '�ÿ�ҩҵ���ű���������ҩ���޹�˾', '������Τ', 0.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������Τ', '����', '10g:0.3g', '1', 'axlw,exlw', NULL),
  ('070d3f60e1964ef98cefadf3f9519525', '200210', '��������ҩҵ���޹�˾', '��', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ڷ���Һ�΢�', 'ɢ��', '5.125g', '6', 'kfbyy��', NULL),
  ('07269f7292594b419ff703da7df3bb4c', '200211', '�����û�ʿҩҵ(����)�������ι�˾', '����Ƭ', 35.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Ƭ', 'Ƭ��', '0.5g', '48', 'wbp', NULL),
  ('0740a64ebb9a4c88b9fc8e00d0536a1c', '200212', '��������ҩҵ���޹�˾', '������˨', 2.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '˨��', '0.5g', '10', 'jxz', NULL),
  ('086ea1e0ca6e4b22a8d49b1118fcf33b', '200213', '����ҩҵ�ɷ����޹�˾', '��Ī���ַ�ɢƬ', 1.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī����', '��ɢƬ', '0.125g', '12', 'amxl,emxl', NULL),
  ('0893333f6d6d471a96f18979267cc8fa', '200214', '����ʡ������ʢҩҵ�ɷ����޹�˾', '���Կ�����', 4.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���Կ�����', '����', '0.25g', '36', 'xnkjn', NULL),
  ('08fbc75ee63f40718770b4ca671ad75a', '200215', '��������ҩҵ���޹�˾', '����', 9.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ͪ', '��ɢƬ', '10mg', '30', 'dplt', NULL),
  ('0947a91fc1c04c6fbd70c20a1c9b6b3f', '200216', '������ҩ', '�ʲ�Ƭ', 8.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�ʲ�Ƭ', 'Ƭ��', '����', '100', 'gcp', NULL),
  ('09ef367a3eb14edeadbecfbd13d2f718', '200217', '���ֻ�����ҩ���޹�˾', '��ɳ̹��ɢƬ', 24.32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ɳ̹', '��ɢƬ', '80mg', '14', 'xst', NULL),
  ('09faeb5d29ee4b10adf42a6b6a433272', '200218', '���պ�ҵҩҵ���޹�˾', '�ɽ�ĸ', 0.37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�ɽ�ĸ', 'Ƭ��', '0.2g', '100', 'gjm,gxm', NULL),
  ('0abf9139cd7942e09655a707b83a8237', '200219', '���Ͽ���ҩҵ���޹�˾', '5%������', 1.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '5%������', '����Һ', '500ml(��ƿ)', '1', '5%ptt', NULL),
  ('2a4377b7d5c445ecb631cdc9dd09754b', '200000', '���պ���ҽҩ�ɷ����޹�˾', 'ŵ��', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '����ù��', 'Ƭ��', '50mg', '12', 'klms', NULL),
  ('2a791556623a49009c6007577d2f5017', '200001', '����������ҩ�������ι�˾', '������Τ', 7.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������Τ', 'ע��Һ', '5ml:0.25g', '1', 'gxlw', NULL),
  ('2ab1bb4f45414bda8f7b25567ad481ab', '200002', '������֮��ҩҵ�ɷ����޹�˾', '�����涡', 1.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����涡', 'Ƭ��', '0.4g', '20', 'xmtd,xmtz', NULL),
  ('2b450e8cfbf64827854d02fcfb368b67', '200003', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '������', 2.01, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī����', '��ɢƬ', '0.25g', '18', 'amxl,emxl', NULL),
  ('2bd18719b0414fb9b4876f60115f760c', '200004', '���Ϻ�ɭ��ҩ�ɷ����޹�˾', '��ĥ���ڷ�Һ', 20.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ĥ���ڷ�Һ', '�ڷ�Һ', '10ml', '10', 'smskfy,smtkfy', NULL),
  ('2d3f324e78c94600b169577089021f0b', '200005', 'ɽ���յ�ҩҵ�ɷ����޹�˾', '������', 14.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�Ŷ������þ', '����', '2.0g(�Ŷ������1g,�Ŷ�����þ1g)', '1', 'mdasjm', NULL),
  ('2e6fed61710d499cba435a4052fd412e', '200006', '�㽭������ҩ�ɷ����޹�˾', '��ù�س��ܽ���', 19.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ù��', '���ܽ���', '0.25g', '10', 'hms,gms', NULL),
  ('2f02a7e6ef794db5bc9f4fcecc6e25e1', '200007', '�ɶ�������ҩ���޹�˾', '�����ۻ��ڷ���Һ', 29.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����ۻ��ڷ���Һ', '�ڷ�Һ', '10ml', '12', 'yxmhkfry', NULL),
  ('2f7dd370f1cc4c729d12f1be97b9b48c', '200008', '����ҩ��������ҩ���޹�˾', '�ڼ��׷���', 4.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ڼ��׷���', 'ˮ����', '6g', '10', 'wjbfw', NULL),
  ('2f8c128759e54901946571dbae9a80e9', '200009', '�Ĵ��°�ҩҵ���޹�˾', '?', 26.31, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������', 'Ƭ��', '0.1g', '24', 'hpsyt', NULL),
  ('2fb4df2e8c0f4795bc03970e1485781d', '200010', '���Ǻ�˹��ҩ���޹�˾', '��˹����', 1.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����«��', '����', '0.3g', '1', 'qklz,qkld', NULL),
  ('2fc8d7c2125c4d749bbd9d5d84e66148', '200011', 'ɽ��������ҩ�������ι�˾', '����ɢ', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ɢ', 'ɢ��', '3g', '10', 'bps', NULL),
  ('306c515a9727452cb2063d96580a734b', '200012', '���Ϻ�����ҩ�ɷ����޹�˾', 'ע���õ�յ����', 11.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��յ����', '����', '10mg', '1', 'dzhs', NULL),
  ('30be911509954fcbb3c863c3bca7474a', '200013', '�㶫�Ϲ�ҩҵ���޹�˾', '������������Ƭ', 8.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������', 'Ƭ��', '25mg', '1000', 'zxmz', NULL),
  ('311276aefc7a406ebc158d9d8679acda', '200014', '�������ҩҵ���Źɷ����޹�˾������ҩ��', '��Ч������', 25.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ч������', '����', '40mg', '150', 'sxjxw', NULL),
  ('31fde24225da47bdb21008ff728350da', '200015', '������һ������ҩ�������ι�˾', '���̽ⶾ����', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���̽ⶾ����', '������', '5g�������ͣ�', '20', 'yqxdkl,yqjdkl', NULL),
  ('334ea3ebcc8f4372a7b95cb58fa9be00', '200016', '��ҩ���Ź�ҵ���޹�˾', '��������', 1.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '����Ƭ', '20mg', '14', 'amlz', NULL),
  ('3365db167fee44a4b115d9e201891570', '200017', 'ɽ����Ԫʢ����ҩ���޹�˾', '��Ŀ�ػ���', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��Ŀ�ػ���', 'ˮ����', '36g', '1', 'mmdhw', NULL),
  ('3440c68ab3264e5c9c13557a86ecf4a9', '200018', '����ͬԴ��ҩ���޹�˾', 'ά����B6', 0.06, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ά����B6', 'ע��Һ', '1ml:50mg', '1', 'wssb6', NULL),
  ('354c5cd20e9a437898823bd04b817cb6', '200019', '�Ϻ�����ҩҵ���޹�˾', '�����', 3.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��Ī����/����ά���', '����', '1.2g(5:1)', '1', 'emxl/klwsj,amxl/klwsj', NULL),
  ('35a458a2148247a993d7ca880598ae59', '200020', 'ҩ����ҩ���Źɷ����޹�˾', '����ů����', 3.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ů����', 'С����', '54g(9g/45��)', '1', 'yfngw,afngw', NULL),
  ('3630c3269ebe48d89a8ef15ba107cf30', '200021', '�������ҩҵ���޹�˾', '��������', 23.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ʲ�����', '����', '50mg', '48', 'gcsea', NULL),
  ('364ce09e41044380aae60fd591fe993a', '200022', '�Ǳ�ҩҵ��ͬ��ҩ���޹�˾', '����˳����', 4.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����˳����', 'ˮ��', '9g', '10', 'kxsqw', NULL),
  ('36e2aaf5b9074dc99c6bc991a0dd2654', '200023', '���ݰ���ɽ����ҩҵ���޹�˾', '��٢������', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��٢������', 'Ũ����', '8g', '12', 'htzzw', NULL),
  ('37307c92f7fc417284ce8eb6df19d826', '200024', '�ӱ�����ҩҵ���޹�˾', '����ע��Һ', 4.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ע��Һ', 'ע��Һ', '10ml', '1', 'smzyy,cmzsy,cmzyy,smzsy', NULL),
  ('3755766c9e6344ccae64d8fe50a5ac43', '200025', '������ʷ����ҩ(����)���޹�˾', '������', 19.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ɳ������', '�����', '100ug/��*200', '1', 'sdac,szac', NULL),
  ('38b221c483534248b8cd24fd3d56ead8', '200026', '���ϰ�ҩ���Źɷ����޹�˾', '��ɰ��θƬ', 18.84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ɰ��θƬ', 'Ƭ��', '0.6g', '48', 'xsywp', NULL),
  ('39092830a8fd458b8f80ea848dc62182', '200027', '�������ŵ����ҩ���޹�˾', '��������Ƭ', 21.67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������Ƭ', 'Ƭ��', '0.5g', '24', 'twbxp', NULL),
  ('3951fdebc9bc4a779ae48c6e25bdd1ae', '200028', '����������ҩ�����޹�˾', '��', 3.13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ҶƬ', 'Ƭ��', '�ܻ�ͪ����19.2mg:��������4.8mg', '24', 'yxyp,yxxp', NULL),
  ('39986696637e4af3a03c43739148978c', '200029', '����������ҩҵ���޹�˾', '���ɲ��ע��Һ', 4.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ɲ��ע��Һ', 'ע��Һ', '1.5ml��0.375g', '10', 'nksmzyy,nkcmzyy,nkcmzsy,nksmzsy', NULL),
  ('39b8a6c407ca435b92126f3d0e3f76ce', '200030', '�㶫�β���ҩ���޹�˾', '������ע��Һ', 15.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������', 'ע��Һ', '10ml:0.1g', '1', 'bpf,bbf', NULL),
  ('39cce3f440f5411aa1fb4086d0f0c484', '200031', 'ɽ��������ҩ���޹�˾', 'ͷ�����', 4.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ�����', '����', '2.0g', '10', 'tbtd', NULL),
  ('39f99968ea90499694b415695e54d603', '200032', '��ʯ������ҩ���޹�˾', '�������ڷ�Һ', 3.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������ڷ�Һ', '�ڷ�Һ', '10ml', '10', 'kbdkfy', NULL),
  ('3a2b79ab0d8248aab2ecc22f5fddb82c', '200033', 'ɽ���ֻ�ҽҩ�Ƽ��ɷ����޹�˾', '����ͨʥ��', 2.71, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ͨʥ��', 'ˮ��', '6g', '10', 'fftsw', NULL),
  ('3a338f1c9107406ba11ae7d00ea3e10f', '200034', '��ʿ����ҩ���Źɷ����޹�˾', '�������ε���', 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������ε���', '����', '��Ĥ����27mg', '180', 'ffdcdw,ffdsdw', NULL),
  ('3a43452e6ece49c5a810078bb279b981', '200035', '�Ĵ�����ҩҵ�ɷ����޹�˾', '������ע��Һ', 2.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '������ע��Һ', '����Һ', '250ml:12.5g(��ƿ)', '1', 'pttzyy,pttzsy', NULL),
  ('3a4df240c5e442a1b0ad6124e2cbabe7', '200036', '��������ͯ��ҩ�����޹�˾', '?', 20.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'С��к��ͣ����', '����', '3g', '12', 'xexstkl,xrxstkl', NULL),
  ('3ac517d3567645fdb61cf7179d5d897b', '200037', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '��ù����', 0.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù����', '����', '80WU', '1', 'qmsn', NULL),
  ('3af39529587f40edb6fcd18741a0deaa', '200038', '�����������ҽҩ�ɷ����޹�˾', '������п�ȵ���(30%)', 24.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������п�ȵ���(30%)', 'ע��Һ', '10ml:400IU', '1', 'jdbxyds(30%)', NULL),
  ('3c5195a7c72c41698eab1cb08ce912ad', '200039', '����̫��ҩҵ�ɷ����޹�˾', '10%������', 0.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '10%������', '����Һ', '100ml', '1', '10%ptt', NULL),
  ('3c80158a806240b3906ba9013b50e104', '200040', '�ɶ���һ��ҩ���޹�˾', '��ĸ��Ƭ', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '��ĸ��Ƭ', 'Ƭ��', '����ˮ�ռ�15mg', '48', 'ymcp', NULL),
  ('3cfe38d6289442d8af1f852854a9740d', '200041', '�人����ҽҩ�Ƽ��������ι�˾', '����������', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '����', '0.1g', '10', 'ebdz,abdz', NULL),
  ('3d3be6567abb43528c260414b6f1d5d9', '200042', '����ҩҵ�������޹�˾', 'ͷ������', 0.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ������', '����', '0.5g', '1', 'tbqs', NULL),
  ('3d7aba3db5a0466f8af4bbcca85e3624', '200043', '�Ͼ��׺���ҩ���޹�˾', '˫�ȷ�����', 10.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '˫�ȷ�����', '���ͽ���', '50mg', '24', 'slfsn', NULL),
  ('3da5c436a3ae40b88e83ff57882f8cc4', '200044', '�Ĵ�����ҩҵ�ɷ����޹�˾', '����ע��Һ', 0.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ע��Һ', 'ע��Һ', '10ml', '1', 'dszyy,dszsy,dczyy,dczsy', NULL),
  ('3da9d295ec9e4bed8f34fd9a72429db2', '200045', '������������ҩ���޹�˾', '����þע��Һ', 0.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '����þ', 'ע��Һ', '10ml:1.0g', '1', 'lsm', NULL),
  ('3ddf40fc4ec74a78b393053778559d66', '200046', '����ҩҵ�ɷ����޹�˾', '�����', 7.37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����', '����Ƭ', '0.3g', '20', 'blf', NULL),
  ('3eb9a718d5d64648856bf5e88fb34dee', '200047', 'ɽ��������ҩ���޹�˾', '��', 5.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���߰�����', 'ˮ��', '6g', '10', 'clbsw,slbzw,slbsw,clbzw', NULL),
  ('3eba64e22c4c45368c20f6f571d1c735', '200048', 'ɽ������ҩҵ�ɷ����޹�˾', '������ɳ��', 0.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ɳ��', 'Ƭ��', '0.2g', '6', 'zyfsx', NULL),
  ('3eca844c938f46c3a6d964b0313bc0e0', '200049', '������ҩ���Źɷ����޹�˾', '��յ����Ƭ', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��յ����Ƭ', 'Ƭ��', '20mg', '24', 'dzhsp', NULL),
  ('3efa55d8d02749ac9b1a11bcec873075', '200050', '����������ҩ�������ι�˾', '������ɳ��', 0.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������ɳ��', 'ע��Һ', '2ml:0.2g', '1', 'zyfsx', NULL),
  ('3f83f745436344d6aeeeccf63eaaafb5', '200051', '³�Ϻ�����ҩ���޹�˾', 'С������ֹ�ȿڷ�Һ', 13.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'С������ֹ�ȿڷ�Һ', '�ڷ�Һ', '10ml', '6', 'xexjzkkfy,xrxjzhkfy,xrxjzkkfy,xexjzhkfy', NULL),
  ('3fc18b2cf9814612b156f0d4a752591f', '200052', '����ʡ������ҩ���޹�˾', 'ͷ������', 4.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', 'ͷ������', 'Ƭ��', '0.5g', '12', 'tbld', NULL),
  ('400f4a7b425d44caa6a23a00cc16acd8', '200053', '���ݶ�����ҩ���޹�˾', '������', 7.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ȵ�ƽ', 'Ƭ��', '2.5mg', '14', 'aldp', NULL),
  ('401ecbb3c34a4b98924ddb9b59633900', '200054', '��Ӧ��ҩҵ���Źɷ����޹�˾', '��������˨', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '˨��', '50mg', '10', 'ydmx', NULL),
  ('401fba424c2142a48a4dfaccbaf504e0', '200055', '������ҩ�ӱ�����ҩҵ�������ι�˾', 'ͷ�߰���', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ�߰���', '����', '0.125g', '50', 'tbab', NULL),
  ('40c192ba97bd4aa39e206db91f5983b4', '200056', '���Ͽ���ҩҵ���޹�˾', '0.9%�Ȼ���', 1.43, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '0.9%�Ȼ���', '����Һ', '500ml(��ƿ)', '1', '0.9%lhn', NULL),
  ('411fc7dbf44347278234f904f8d7d106', '200057', '����������ҩ����ҩ���޹�˾', 'ţ�ƽⶾ��', 2.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ţ�ƽⶾ��', '������', '3g', '10', 'nhjdw,nhxdw', NULL),
  ('412a9d0dd4314ad6b4f04fb9eaca115f', '200058', '�Ĵ���Ҷ����ҩҵ�ɷ����޹�˾', '��ϣ', 43.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '����', '50mg', '30', 'eqpt,ekpt,akbt,aqpt,aqbt,akpt,eqbt,ekbt', NULL),
  ('4167c66a12da4e17a86357bf3c69184d', '200059', '���ҩҵ������֣�ɷ����޹�˾', '��', 0.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���˽�', 'ע��Һ', '2ml:0.5g', '1', 'anj', NULL),
  ('41fd72d98ae44db88204d167c845a727', '200060', '����ҫ���������޹�˾', '��', 0.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��Ѫƽ', 'ע��Һ', '1ml:1mg', '1', 'lxp', NULL),
  ('42a044c781044853835132e422e40194', '200061', '��Ӧ��ҩҵ���Źɷ����޹�˾', '��Ӧ�������̴���', 7.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��Ӧ�������̴���', '����', '10g', '1', 'mylsxzcg', NULL),
  ('432c55d4eb9f4e62ae434f0f4af70e33', '200062', '�Ϻ��̷���ҩ���޹�˾', 'ά������', 0.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ά������', 'ע��Һ', '2ml:5mg', '1', 'wlpm', NULL),
  ('434d9c3770a4487bbadc22bdc7897eae', '200063', '����������ҩ���޹�˾', '���ͽ���', 7.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '���', '���ͽ���', '0.1g', '24', 'cj', NULL),
  ('434f3f2847a94071b523456c112fd9f2', '200064', '������ҩ���޹�˾', '����', 1.91, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���', '����Ƭ', '0.1g', '15', 'cj', NULL),
  ('4389e4c2dced49b693fac4b167dee705', '200065', '�㶫��Ӧ��ҩ�ɷ����޹�˾', '׳��������', 4.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '׳��������', 'ˮ����', '52g', '1', 'zyjsw', NULL),
  ('4397034547364824be180365f80d25ec', '200066', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '��ù����', 0.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù����', '����', '160WU', '1', 'qmsn', NULL),
  ('43cd9ed91c0a42598e44339363231376', '200067', '���绪��ҩҵ���޹�˾', '��', 0.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù��', '����', '10g:0.1g(1%)', '1', 'kmz', NULL),
  ('43e94694392e49c08fe279a9e08d03df', '200068', 'ɽ������ҩҵ�ɷ����޹�˾', '����ù��', 1.42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ù��', '����', '0.3g', '1', 'klms', NULL),
  ('43e9eb51cca64525ab6a79c02c16cfd5', '200069', '����ͬ���ÿƼ���չ�ɷ����޹�˾��ҩ��', '����������', 9.84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������', '����', '0.5g', '24', 'mrrcrjn', NULL),
  ('442f97869f014291968b6d7679ad71d3', '200070', '���ջ�٢��ҩ��', '������', 5.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '������', 'С����', '3g/15', '150', 'ddw', NULL),
  ('445304889ec440ad85d314dcfcb328ea', '200071', '�麣������ҩ�ɷ����޹�˾', '��˼��USLIN50R', 42.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�������������ȵ��ػ��(50/50)', 'ע��Һ', '3ml:300IU(��о)', '1', 'jdbzzrydshg(50/50),jdbczrydshg(50/50),jdbczrydshh(50/50),jdbzzrydshh(50/50)', NULL),
  ('447dddd0ae7e4fc3944d9870b59eec60', '200072', '����ҩҵ�ɷ����޹�˾', '��������', 0.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', 'Ƭ��', '0.2g', '10', 'ebdz,abdz', NULL),
  ('44b737323b54483988c30f8c34173c8c', '200073', '�����Ļ���ҩ���޹�˾', '���ְ�', 12.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ͪ', '����', '2mg', '1', 'nlt', NULL),
  ('44e4018dc2464a9f83829f3b6225ef08', '200074', '����ҩҵ�������޹�˾', '����ά��', 1.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����ά��', 'Ƭ��', '25mg', '100', 'ptwl', NULL),
  ('455d7b92bb2b4b2a8f50f290bcf9f437', '200075', '�㽭����ҩҵ�ɷ����޹�˾', '��������', 6.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', 'Ƭ��', '80mg', '60', 'gljt,glqt', NULL),
  ('4593738f01e140f189203f4422845ef7', '200076', '���̫ƽ����ҩ���޹�˾', '������', 1.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������', '����', '10g:2.5mg', '1', 'fqs', NULL),
  ('45eb3e66ead34217bfc6100eb7e2f577', '200077', '��³��ҩ���޹�˾', 'ע��������������', 0.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', '����', '1.0g', '1', 'plxl', NULL),
  ('462b9884a37e4c0980dbda4b48bfd15f', '200078', '��³��ҩ���޹�˾', '��������Ƭ', 15.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '��������', 'Ƭ��', '2.5mg', '80', 'hfln', NULL),
  ('462fadc149b64f848da8b7db93897d5f', '200079', '�������䱦��ҩҵ�ɷ����޹�˾', 'Ѫ��ͨע��Һ', 3.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'Ѫ��ͨע��Һ', 'ע��Һ', '10ml:0.25g', '1', 'xstzyy,xstzsy', NULL),
  ('46bc312d96cf4d44a0b8a8c4786cd1d8', '200080', '����ʡ������ҩ�ɷ����޹�˾', 'С�������', 9.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', 'С�������', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'xchtw,xchsw', NULL),
  ('46bd8e20ae0b4112be54b383bfedf510', '200081', '������ҩ�ɷ����޹�˾', '��Ī���ֽ���', 1.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī����', '����', '0.5g', '10', 'amxl,emxl', NULL),
  ('47445a4aefb34820a04b75e3f2002727', '200082', 'ɽ������ҩҵ�ɷ����޹�˾', '������ɳ��', 0.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ɳ��', 'Ƭ��', '0.1g', '6', 'zyfsx', NULL),
  ('48e841ef7cff4168a0e88946efd7495d', '200083', '���ҩҵ������֣�ɷ����޹�˾', '��', 1.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', 'Ƭ��', '50mg', '3', 'fkz', NULL),
  ('002fe86ad6d44d209a34b802bca46d34', '200084', 'ɽ������ҩҵ�ɷ����޹�˾', '������ɳ��', 0.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ɳ��', 'Ƭ��', '0.1g', '10', 'zyfsx', NULL),
  ('0035e28a704c414ea0d957739a1c998d', '200085', '����������ҩ���޹�˾', '?', 6.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ˮ����ά����', '����', '/', '1', 'srxwss', NULL),
  ('005aacc7a5a24b1087da0d76ff7146e5', '200086', '����ʡ������ҩ�ɷ����޹�˾', '����������', 13.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����������', 'ˮ��', '0.2g', '120', 'ffdsw,ffdcw', NULL),
  ('0072e55c308c41d2b4a39960ac98d45b', '200087', '�������ҩҵ���޹�˾', '��������', 17.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ʲ�����', '����', '50mg', '36', 'gcsea', NULL),
  ('007698f6ac20453fba40266261718a96', '200088', '����ҩ��������ҩ���޹�˾', '��ζ�ػ���', 3.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ζ�ػ���', 'ˮ����', '6g', '10', 'lwdhw', NULL),
  ('0091756e0a4b4029ab0031a4e7a58a3c', '200089', '����ʥ������ҩ���޹�˾', '�������˫�ҳ���Ƭ', 6.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����˫��', '����Ƭ', '0.5g', '30', 'ejsg', NULL),
  ('01628775298146cb848e5f1fc69c66a8', '200090', '�㽭��������ҩ�ɷ����޹�˾', '���ᰱ����ע��Һ', 3.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������', 'ע��Һ', '2ml:15mg', '1', 'axs', NULL),
  ('0227319a4140473e844219275ce806b7', '200091', '����������ҩ�ɷ����޹�˾', '����ù�ط�ɢƬ', 1.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ù��', '��ɢƬ', '0.125g', '6', 'ajms,ejms,aqms,eqms', NULL),
  ('0230f23805f348ef81a6deb6a7880fcb', '200092', '�������䱦��ҩҵ�ɷ����޹�˾', 'Ѫ��ͨ', 23.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'Ѫ��ͨ', '����', '0.2g', '1', 'xst', NULL),
  ('02a84b6e2c4e40c484ff76d1bc186570', '200093', '�������ҽҩ�ɷ����޹�˾', '���ܰ�����', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ܰ�', '����', '0.5mg', '24', 'jga', NULL),
  ('0314d7c46595495ab38b736286fb9423', '200094', '�����б���ҩ�ɷ����޹�˾', '������������', 1.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������������', '����', '0.3g', '20', 'dyxajf', NULL),
  ('032aaa036c3542798eb0049a96309def', '200095', '���������ҩҵ���޹�˾', '��', 4.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����պ�����', '����', '0.31g', '20', 'gxsgrjn,gxshrjn', NULL),
  ('034db1a65659488d89fd3ddebaa2e435', '200096', '�Ϻ��ִ���ɭ(����)ҩҵ���޹�˾', '�ʲ�����ע��Һ', 0.67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�ʲ�����', 'ע��Һ', '10ml:50mg', '1', 'gcsea', NULL),
  ('03c5eac24a9f4fb7839ffca7c038f7e6', '200097', '���ҩҵ������֣�ɷ����޹�˾', '��', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', 'Ƭ��', '0.1g', '6', 'fkz', NULL),
  ('03c7afd143414bf78617d48721a6dff8', '200098', '�˲��˸�ҩҵ�������ι�˾', '��������ù��Ƭ', 0.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������ù��', 'Ƭ��', '0.1g', '12', 'yxlxms', NULL),
  ('03d23f9392354be3b2b102529281ab5c', '200099', '������������ҩ�������޹�˾', '����Ƭ', 1.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Ƭ', 'Ƭ��', '0.25g', '24', 'yhp', NULL),
  ('045befb855604a49a85fd35651558473', '200100', '����������ҩ�ɷ����޹�˾', '�������', 5.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������', 'Ƭ��', '50mg', '100', 'abdd', NULL),
  ('0498f9597ae3489bbef15ecd502611d5', '200101', '�������ҩҵ���޹�˾', '��������', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ʲ�����', '����', '50mg', '24', 'gcsea', NULL),
  ('04cb0d607cd440c286fa3f8fc3816340', '200102', '�人����ҩҵ���Źɷ����޹�˾', '���������', 5.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���������', 'ˮ����', '60g', '1', 'elzcw', NULL),
  ('190c9d851bd6447386ea3750b21e8468', '200103', '������ҩҵ���޹�˾', '��', 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', 'ˮ��', '10(3.125g/1000)', '12', 'lsw', NULL),
  ('1a51b21691b048e397cd8c93e0a96e8d', '200104', '����������ҩ�ɷ����޹�˾', '����ҶƬ', 1.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ҶƬ', 'Ƭ��', '�ܻ�ͪ����9.6mg:��������2.4mg', '24', 'yxyp,yxxp', NULL),
  ('1a60fc7daf91429f9e9057beb5bfd6bb', '200105', 'ɽ��ʡƽԭ��ҩ��', '�������Ƭ', 2.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������', 'Ƭ��', '0.5mg', '100', 'xsgy', NULL),
  ('1aaa915e053f40a4bb357cccfcef0865', '200106', '�㽭��������ҩ���޹�˾', '������ͪƬ', 2.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ͪ', 'Ƭ��', '10mg', '30', 'dplt', NULL),
  ('1b16482b4ee2434887ec529c13faa46f', '200107', '���ϰ�ҩ���Źɷ����޹�˾', '���ϰ�ҩ��', 7.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '���ϰ�ҩ��', '����', '30ml', '1', 'ynbyd', NULL),
  ('1b7152e2c2964dfeb53ef3ddd6b1dd92', '200108', '�ÿ�ҩҵ�������޹�˾', '������Τ', 1.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������Τ', '����', '0.25g', '1', 'gxlw', NULL),
  ('1bd5f3b689834a9ba8f8c5f6ffbba35f', '200109', '�㽭����ҩҵ�ɷ����޹�˾', '������������������', 10.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������������������', '����', '10mg', '10', 'mlsynpljn', NULL),
  ('1bf07719447e44ee9db74115fc8bb3a0', '200110', '������ҩ��ҩ�ɷ����޹�˾', '�����պ���', 5.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����պ���', '������', '1.12g', '30', 'gxshw,gxsgw', NULL),
  ('1c0b56e3bd4140878dc95836dd312d54', '200111', 'ʯ��ׯ��ҩ���޹�˾', '���͹���', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '���͹���', '����Һ', '250ml:25g:12.5g:2.25g', '1', 'gygt', NULL),
  ('1c235969061842d699bd96717e8860de', '200112', '����ҩҵ�ɷ����޹�˾', '��������������ע��Һ', 0.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������������', 'ע��Һ', '1ml:5mg', '1', 'dsmslsn', NULL),
  ('1c7a3942860547dca572acabea052dd9', '200113', '���ҩҵ������֣�ɷ����޹�˾', '��', 0.29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����¶', '��Һ��', '20ml', '1', 'ksl', NULL),
  ('1ce3333f192544369d3f452ace6741ad', '200114', 'ҩ����ҩ���Źɷ����޹�˾', '����ů����', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ů����', '������', '9g', '10', 'yfngw,afngw', NULL),
  ('1d0178b9b21e4819bc573b514bd1adf2', '200115', '�ؿ���ҩ�������޹�˾', '�工��͡', 4.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�工��͡', '����', '20mg', '12', 'lftt', NULL),
  ('1e94554188204afe88dcc9ce5422971c', '200116', '������ʥ̩ҩҵ���޹�˾', '?', 17.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'С�����������', 'ע��Һ', '2g', '8', 'xrrsqkl,xersqkl', NULL),
  ('1f10ac2dc1ba4b3ea481854e883d5ede', '200117', '���Ͽ���ҩҵ���޹�˾', '�������Ȼ���', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������Ȼ���', '����Һ', '500ml(��ƿ)', '1', 'pttlhn', NULL),
  ('1f3806865be74f95b47ccf610b0fb43b', '200118', '��������ͨҩҵ�������ι�˾', '��Ī��ƽ', 1.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��Ī��ƽ', 'ע��Һ', '10ml:2mg', '1', 'nmdp', NULL),
  ('1f52761d33b242ad948de7018fb6b707', '200119', '����Ǳ����ҩ�ɷ����޹�˾', '������Τ', 0.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������Τ', '����', '0.25g', '1', 'axlw,exlw', NULL),
  ('1f5fcf911f534472a87b8be7135ee72b', '200120', 'ɽ���ֻ�ҽҩ�Ƽ��ɷ����޹�˾', '����������', 3.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������', '������', '9g', '10', 'bzyqw', NULL),
  ('1fa5eef6df3d45db839902870e5a3ea3', '200121', '��ҩ����������ҩ�ɷ����޹�˾', '���׿���', 0.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���׿���', 'ע��Һ', '2ml:0.2g', '1', 'amqx,amkx,emkx,emqx', NULL),
  ('1fb005a44a5c429592218b5367dc10ae', '200122', '������ҩ���޹�˾', '��', 0.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù����', '����', '400WU', '1', 'qmsn', NULL),
  ('20ba154eb76d407cb1055b0b759b4a39', '200123', '����¤���ַ���ҩ���޹�˾', 'Ԫ��ֹʹ����', 22.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', 'Ԫ��ֹʹ����', '����', '0.5g/10', '180', 'yhztdw', NULL),
  ('20bc317dca9547e39126031f09ba1971', '200124', '�Ϻ��𲻻�������ҩ���޹�˾', '��������', 2.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������', 'Ƭ��', '25mg', '100', 'ydmx', NULL),
  ('20d61eab0e6e4cb09edc1f0560f2c6c5', '200125', '���Ͽ���ҩҵ���޹�˾', '0.9%�Ȼ���', 1.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '0.9%�Ȼ���', '����Һ', '250ml(��ƿ)', '1', '0.9%lhn', NULL),
  ('213cd1891f1f43a8997ad0d5049583e5', '200126', 'ɽ������ҩҵ�ɷ����޹�˾', '����ù��', 2.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ù��', '����', '0.6g', '1', 'klms', NULL),
  ('2187a10f74994a4e8d9acf8e1f5b48f3', '200127', '��������ҩҵ���޹�˾', '��������ע��Һ', 9.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', 'ע��Һ', '5ml:20mg', '1', 'hlxg', NULL),
  ('21c25a089a1b4c7fa440fe81f3dfa252', '200128', 'ɽ���ٲ�ҩҵ���޹�˾', '������ɢ', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ɢ', 'ɢ��', '9g', '10', 'ryjhs', NULL),
  ('21d2e95dea7e440180809b3e0bcd5ebe', '200129', '���Ϻ��黯ѧ��ҩ���޹�˾', '������͡', 2.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������͡', 'Ƭ��', '20mg', '7', 'xftt', NULL),
  ('2256d6e3c1ef41b6bd0e964f7be667a5', '200130', '�ɶ��ذ¼����츮ҩҵ�ɷ����޹�˾', '��ܺ���Ƭ', 12.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ܺ���Ƭ', 'Ƭ��', '0.48g', '48', 'cxcdp,cxctp', NULL),
  ('228223b576ce4becb3b5f85781b9567e', '200131', '���ϸ��ʻ�����', '��ʹ��', 0.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', '���', '2ml', '1', 'ajbl', NULL),
  ('2290cb2228fa4f119fcc3535a37ec3a3', '200132', '����ʡ�ڳ���ҩ��', '���߰�������', 23.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���߰�������', '������', '6g', '10', 'clbzkl,slbzkl,slbskl,clbskl', NULL),
  ('22d0394edbcc4d0abc46f70d5daa9dfe', '200133', '֣��׿����ҩ', '��������������', 0.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������������', 'ע��Һ', '1ml:2mg', '1', 'dsmslsn', NULL),
  ('22e6340b8d8b42e6b433c9a2faf34b46', '200134', 'ʯҩ����ŷ��ҩҵ���޹�˾', '����Ӣ��Ƭ', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '����Ӣ��', 'Ƭ��', '50mg', '100', 'btyn', NULL),
  ('23167d3511c64a718fb1b382709d3121', '200135', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '��������', 0.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', '����', '0.5g', '1', 'bzxl', NULL),
  ('2340c610758241e18a147d11ade8d24e', '200136', '����ҩҵ�ɷ����޹�˾', '����������Ƭ', 1.37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '����Ƭ', '10mg', '14', 'amlz', NULL),
  ('2346896172e840f8b830d25f42b86087', '200137', '������ʱҩҵ�ɷ����޹�˾', 'ͨ����ο���', 9.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͨ����ο���', '������', '9g', '12', 'txlfkl', NULL),
  ('23547ad5440f4d18948a56b304894184', '200138', '��������ҩҵ�ɷ����޹�˾', '����Ƭ', 22.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Ƭ', 'Ƭ��', '�൱��ԭҩ��3.5g', '72', 'sjp', NULL),
  ('23a594bd15b645f292e0bd502bed9e02', '200139', '����̫��ҩҵ�ɷ����޹�˾', '0.9%�Ȼ���', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '0.9%�Ȼ���', '����Һ', '500ml', '1', '0.9%lhn', NULL),
  ('23af66af483b4a4295fbbd5b4f9da50e', '200140', '�ϲ�����ҩҵ���޹�˾', '�����', 13.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '��ɢƬ', '50mg', '6', 'fkz', NULL),
  ('23e9fd96c92e4dc7a557df97dc1631b0', '200141', '��������ҩҵ���޹�˾', '¯��ʯϴ��', 1.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '¯��ʯϴ��', 'ϴ��', '100ml', '1', 'lgsxj,lgdxj', NULL),
  ('242c4245c83642a098b2314223e1348c', '200142', '��������ҩ�����޹�˾', '������', 4.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ�߿���', 'Ƭ��', '0.25g', '6', 'tbkl', NULL),
  ('2445acbc9616437981803909826fd263', '200143', '��������ͯ��ҩ�����޹�˾', '˫��������', 18.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '˫��������', '������', '5g', '15', 'shlkl', NULL),
  ('24cc4d5c97c84484a45cadf61ddfff67', '200144', '����ŷ��ҩҵ���޹�˾', 'ŷ����', 2.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����涡', 'Ƭ��', '0.15g', '20', 'lntd,lntz', NULL),
  ('25be889b26eb4811bd4261b0ba590ec0', '200145', '����������ҩ�ɷ����޹�˾', '��������', 2.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������', 'Ƭ��', '0.3g', '100', 'lsyt', NULL),
  ('25c3c91e9aa24757906b11f058720ec5', '200146', '�ɶ�������ҩ���޹�˾', '��˳', 12.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�ز�����', 'ע��Һ', '1ml:0.25mg', '1', 'tbtl', NULL),
  ('25e38198d5ea4c5bb4f6dc240365d9c0', '200147', '�麣����ҩ�ɷ����޹�˾', '��������', 5.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '����', '2.5mg', '28', 'ydpa', NULL),
  ('25eb571c4a184001bc7693600eabd483', '200148', 'ʯҩ����ŷ��ҩҵ���޹�˾', '�ڿ�Ϣ', 2.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', 'Ƭ��', '10mg', '10', 'ynpl', NULL),
  ('26a6ab67b9b8453d94adc60f6c57354d', '200149', '������ҩ(����)���޹�˾', 'ά������', 2.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ά������', 'Ƭ��', '40mg', '24', 'wlpm', NULL),
  ('26fa02fec8984567847dc9718a3c87f4', '200150', '������¹����ҩ�ɷ����޹�˾', '��򻶨����', 5.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��򻶨����', '������', '9g', '10', 'gjdcw,hjdcw', NULL),
  ('271680f98c7740689f06efbe68a1f792', '200151', '������ҩ(����)���޹�˾', '����Ӣ��Ƭ', 1.58, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����Ӣ��Ƭ', 'Ƭ��', '0.1g', '100', 'btynp', NULL),
  ('27a1973f121e4420b7afa6dd7c663adb', '200152', '����´ɽ��Ȼֲ����ҩ���޹�˾', '��', 28.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Ҷ����', '����', '�ܻ�ͪ����40mg:��������10mg', '20', 'yxxjn,yxyjn', NULL),
  ('27dcec481305474c87eb8fd42329ea12', '200153', '������ҩ���޹�˾', '�Ŀ�', 1.47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���׵���', '����', '0.25g', '1', 'bldj', NULL),
  ('28e8f64d979040179512fe460354ea50', '200154', '������ҩ(����)���޹�˾', '25%������', 0.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '25%������', 'ע��Һ', '20ml', '1', '25%ptt', NULL),
  ('2904282525e84cfdacad80553e307bba', '200155', '�Ϻ�����ҩ�����޹�˾ί���Ϻ�����ƺ���ҩ���޹�˾', '�������Ƭ', 11.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������Ƭ', 'Ƭ��', '0.25g', '100', 'bqxap,pqxap', NULL),
  ('29269e57e88c4f6495534c68cc30d517', '200156', '�ӱ�����ҩҵ���޹�˾', '������ɽ����', 7.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '������ɽ����', 'ע��Һ', '10ml:10mg', '1', 'xsyslz', NULL),
  ('29a5a29829d547889cd35b0df2f7603a', '200157', '����������ҩ���޹�˾', '������͡��ɢƬ', 15.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������͡', '��ɢƬ', '10mg', '7', 'xftt', NULL),
  ('2a3f86ef52ab458482d655bdccaa2616', '200158', '�ɶ�����ҩҵ�������ι�˾', '����ƽ����', 10.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����ƽ', '����', '0.15g', '100', 'lfp', NULL),
  ('491207c17cf24bccb11d19610eec773e', '200159', '��֥��ҩҵ(����)���޹�˾', '��Ƣ��', 3.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��Ƣ��', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'jpw', NULL),
  ('4927cab078914b9db1e9da7b002f4fb9', '200160', 'ɽ��³��ҽҩ�ɷ����޹�˾', '��ù��', 19.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ù��', 'Ƭ��', '50WIU', '100', 'zms', NULL),
  ('4958152ba04444af9f27ebae2c5f02d7', '200161', '�����ʷ�ҩҵ���޹�˾', '��ζ�ػ���', 3.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ζ�ػ���', 'С����', '60g', '1', 'lwdhw', NULL),
  ('49637b1cf48e416fac619713cef1d688', '200162', '��������ҩҵ���޹�˾', 'ë��ܿ���', 5.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ë��ܿ���', '����Һ', '5ml:25mg', '1', 'mgyxj', NULL),
  ('498d8cf828454f8380f0f881a524d81e', '200163', '������ˮ��ҩ', '��������������', 0.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������������', 'ע��Һ', '1ml:2mg', '1', 'dsmslsn', NULL),
  ('4a2872d5775c446e9bd08c3669cbf8e2', '200164', '��������ҽҩ�ɷ����޹�˾', '������', 18.26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', 'ˮ��', '6g', '15', 'ztw', NULL),
  ('4a5762b07f4a4bdfb31e1e593454f5ff', '200165', '����������ҩ�ɷ����޹�˾', '�������Ƭ', 1.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������', 'Ƭ��', '5mg', '24', 'glbq,glpq', NULL),
  ('4a90b2ea4db44729a643a162403abcaf', '200166', '�����Ļ��Ʊ���ҩ���޹�˾', '�����ɢƬ', 40.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����ɢƬ', '��ɢƬ', 'ÿƬ��0.3g(������ͪ��40mg)', '12', 'xlfsp', NULL),
  ('4ac1370ca4d147e197b971695ea95c1c', '200167', '�ÿ�ҩҵ�������޹�˾', '��������', 1.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '���ܽ���', '10mg', '14', 'amlz', NULL),
  ('4ad8117ab5d74cafba485ae678594269', '200168', '�Ĵ�������ҩ���޹�˾', '޽����������', 4.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '޽����������', '������', '10g', '10', 'hxzqkl', NULL),
  ('4adb310111744036a352d731049b0765', '200169', 'ɽ���ֻ�ҽҩ�Ƽ��ɷ����޹�˾', 'ͨ�������', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͨ�������', '������', '6g', '10', 'txlfw', NULL),
  ('4ae1dcabee9d4e4483a51017253dc5c8', '200170', '����ҩ��������ҩ���޹�˾', 'ͨ�����Ƭ', 3.84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', 'ͨ�����Ƭ', 'Ƭ��', '0.3g', '48', 'txlfp', NULL),
  ('4b9d2aef759c4ee9bee52ce02ea43216', '200171', '��������ҩҵ���޹�˾', '��', 4.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', 'ɽݹ�м�', 'Ƭ��', '10mg', '100', 'sldj', NULL),
  ('4bf5fa098bd34416b8bf5fb3e495f121', '200172', '��������ҩҵ���޹�˾', '��������Ƭ', 17.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������Ƭ', 'Ƭ��', '0.35g', '60', 'bzyxp', NULL),
  ('4c14171fd470404fa5c6be11a652f4bc', '200173', '���ϵ�ŵ��ҩ���޹�˾', '�������', 0.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������', '����', '5mg', '20', 'fglq', NULL),
  ('4c46a203d7c54104a4f455f4cd14bc7c', '200174', '�������䱦��ҩҵ�ɷ����޹�˾', '����ע��Һ', 0.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ע��Һ', 'ע��Һ', '10ml', '1', 'hqzyy,hqzsy', NULL),
  ('4c68f28571974ff7b55ca356fe839f9a', '200175', '�Ϻ��ִ���ҩ�ɷ����޹�˾', '����', 7.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ������', '��ɢƬ', '0.25g', '24', 'tbld', NULL),
  ('ee2e80202d3741a5af1839a5492f0cc4', '200352', '�Ĵ�������ҩ���޹�˾', '����', 8.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī�涡', '��ɢƬ', '20mg', '36', 'fmtz,fmtd', NULL),
  ('ee70cafa59e14d17bbf402f58f166bf3', '200353', '������ҩ���޹�˾', '����ƽ', 1.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������Τ', 'Ƭ��', '0.1g', '30', 'axlw,exlw', NULL),
  ('eeb5ff3f7b33444694363fbedeebb75d', '200354', '����Ͽ��ŵά��ҩ���޹�˾', '��ø��', 0.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ø��', 'Ƭ��', '0.15g', '100', 'rms', NULL),
  ('eee95a025e1146aaa8c9de27b04344fc', '200355', '����������ҩ�ɷ����޹�˾', '������', 2.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '�ڷ�Һ', '30ml', '8', 'xzl', NULL),
  ('f08d50951abe4a4bbce949bc0eb636c6', '200356', '��ɽ��ԭ��ҩ���޹�˾', '��øA', 1.26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��øA', '����', '200U', '1', 'fma', NULL),
  ('f09bd5ff8814402194c86c3067138c1d', '200357', '����̫����ҩ���޹�˾', '���������', 19.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���������', 'Ũ����', '1.85g/10', '96', 'nxllw', NULL),
  ('f0c6dfbf5a4648b78f562cc401203290', '200358', '��ҩ����������ҩ���޹�˾', '�ȱ�����', 3.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�ȱ�����', 'Ƭ��', '4mg', '1000', 'lbnm', NULL),
  ('f2072d1d12e84c959b95c3902629845b', '200359', '�ÿ�ҩҵ�������޹�˾', '��������', 0.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', '����', '40mg', '1', 'amlz', NULL),
  ('f2ad0c9e44794f3fa4b2b8a670062c75', '200360', '������������ҩ�������޹�˾', '�����Ƭ', 1.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '�����Ƭ', 'Ƭ��', '0.2g', '100', 'cwjp', NULL),
  ('f30ccd5c66cb4c01a4eb2ff5fb510b1d', '200361', '���ϸ��ʻ�������ҩ���޹�˾', '��ܺ�', 0.09, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ܺ�', 'ע��Һ', '2ml:40mg', '1', 'cxq', NULL),
  ('f3393e3870b043cd9b411f88ee1623aa', '200362', '����ҩ��������ҩ���޹�˾', '����������', 2.53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '����������', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'bzyqw', NULL),
  ('f34f5fc6b69c44ac820f04d9346b5a82', '200363', 'ɽ������ҩҵ���޹�˾', '����ɳ���Ȼ���', 0.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����ɳ���Ȼ���', '����Һ', '100ml:0.2g:0.9g', '1', 'yfsxlhn', NULL),
  ('f37a59b45c5746d7b117f96a6bbb659d', '200364', '����ͬԴ��ҩ���޹�˾', '�㵤ע��Һ', 0.57, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�㵤ע��Һ', 'ע��Һ', '10ml', '1', 'xdzyy,xdzsy', NULL),
  ('f39303d518194aa69dc8b384c0658ba9', '200365', '����ҩ��������ҩ���޹�˾', '��ζ�ػ���', 3.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ζ�ػ���', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'lwdhw', NULL),
  ('f3a91ba502584eb1bc06c1c5f590545a', '200366', '�ӱ���ɭҩҵ', '��˾ƥ��', 0.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��˾ƥ��', '����Ƭ', '25mg', '100', 'aspl,espl,asyl,esyl', NULL),
  ('f3c806965f8642be9d4e78c84249848b', '200367', '�麣������ҩ�ɷ����޹�˾��ɽ�ֹ�˾', 'ͷ��߻����Ƭ', 9.29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ��߻����Ƭ', 'Ƭ��', '0.125g', '12', 'tbfxzp', NULL),
  ('f3cd8e3b5bbc44d1bb3080411d4655b9', '200368', '���ϰ�ҩ���Źɷ����޹�˾', '���ϰ�ҩ�����', 29.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '���ϰ�ҩ�����', '�����', '50g:60g', '1', 'ynbyqwj', NULL),
  ('f450af0387604205b7ce23c283eacfb9', '200369', '�麣�����������ﻯѧ��ҩ��', '����ƽ', 17.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ᰱ������ɢƬ', '��ɢƬ', '30mg', '50', 'ysaxsfsp', NULL),
  ('f49d0bd14b784e70a64bf402fdca051b', '200370', '����������ҩ����ҩ���޹�˾', '��Ŀ�ػ���', 3.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ŀ�ػ���', '������', '9g', '10', 'mmdhw', NULL),
  ('f4f30ddd6e0644ad8c0a12e83014505f', '200371', '�ߺ��ź㴺ҩҵ���޹�˾', '����������', 3.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����������', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'fzlzw', NULL),
  ('f56f78235e7941ec902a41dcb3ff5164', '200372', '���ϻ���ɭҽҩ���＼�����޹�˾', 'ϣŵ', 9.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ�߿���', '��ɢƬ', '0.125g', '12', 'tbkl', NULL),
  ('f58e5e4887c34b4b9069f0aed1c872c0', '200373', '����ҩҵ�������޹�˾', '����', 1.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����', 'Ƭ��', '25mg', '100', 'ybq', NULL),
  ('f5f1be7323584e57980f72a7a0198fc3', '200374', '�Ĵ�����ҩҵ�ɷ����޹�˾', '�������Ȼ���', 0.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������Ȼ���', '����Һ', '100ml:0.4g:0.9g', '1', 'txzlhn', NULL),
  ('f7445f59bf6b481d9d52cc1b0e74fcb9', '200375', 'ɽ���붼ҩҵ���޹�˾', '20%��¶��', 1.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '20%��¶��', '����Һ', '250ml', '1', '20%glc', NULL),
  ('f744915a53014f20b3bfbf7ca9bc9dd1', '200376', 'ɽ������ҩҵ�ɷ����޹�˾', '������', 1.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', 'Ƭ��', '30mg', '20', 'axs', NULL),
  ('f7be5ba0a7fe4d6d8244da42ef4365dc', '200377', '�����ǰ��ɭҩҵ���޹�˾', '߻����Ƭ', 2.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '߻����Ƭ', 'Ƭ��', '20mg', '100', 'fsmp', NULL),
  ('f8249a85dd73480198e73e180ac1fd9b', '200378', 'ɽ������ҩҵ���Źɷ����޹�˾', '��������Ƭ', 8.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������', 'Ƭ��', '0.2g', '100', 'bwsn', NULL),
  ('f83499b85b804910a7396ce0b52b681a', '200379', '�Ϻ���ҩҵ���޹�˾', '��', 36.22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '������', '1.5g', '36', 'rxw', NULL),
  ('f87653e12ca547e492ae2779f45e25a4', '200380', 'ɽ��������ҩ���Źɷ����޹�˾', '�����', 0.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�����', 'ע��Һ', '2ml:0.1g', '1', 'ggs', NULL),
  ('f91593131ed640269eb4a6d7b4b7b5e4', '200381', '��̨����ҩҵ���޹�˾', '����ͨʥ����', 23.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ͨʥ����', '������', '3g', '18', 'fftskl', NULL),
  ('f961fbe96c414819a86a41140c4eae19', '200382', '��������߿���Ȼҩ�����޹�˾', '���ٻƿڷ�Һ', 18.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ٻƿڷ�Һ', '�ڷ�Һ', '10ml', '6', 'yzhkfy', NULL),
  ('3ca9d45b437442b8a9f1b8ef6f83f3ad', '200383', '�����췽ҩҵ�ɷ����޹�˾', 'ά����B6', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ά����B6', 'ע��Һ', '2ml:0.1g', '1', 'wssb6', NULL),
  ('0db63f8dc6ee4bee844b12d2a54402c4', '200384', '�Ϻ�����ҩ�����޹�˾', '��', 15.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�⻯�ɵ���', 'Ƭ��', '20mg', '100', 'qhkds', NULL),
  ('1dc13a2ab4204d629a0431dc117d7c62', '200385', '������ԣҩҵ�������޹�˾', 'Ԫ��ֹʹ����', 3.62, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'Ԫ��ֹʹ����', '����', '0.25g', '24', 'yhztjn', NULL),
  ('2a22e69f9f5e4806be9ef860a2346254', '200386', '�����������ҽҩ�ɷ����޹�˾', '������', 7.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������', 'ע��Һ', '2ml:1.25WIU', '1', 'gsn', NULL),
  ('579624a400cd442ba930572492053557', '200387', '���ݹ���ҩҵ���޹�˾', '����', 7.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������ɳ��', '����Һ', '8ml:24mg', '1', 'zyfsx', NULL),
  ('9051c1b4d16e44cdabb287ed7332b6b1', '200388', '���϶�ͥҩҵ�ɷ����޹�˾', '��', 2.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ऴ�', 'ע��Һ', '1ml:5mg', '1', 'fpdc', NULL),
  ('a8464dd6e3e34009a07d549a65d86474', '200389', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '��ŵ���', 1.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ�����', '����', '0.5g', '1', 'tbtd', NULL),
  ('b775c07e5c074d3ba724f2e2f5f6aef0', '200390', '���ݹ�۹ڷ�ҩҵ', '�����Ƭ', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�����Ƭ', 'Ƭ��', '0.2g', '100', 'cwjp', NULL),
  ('9bb97df8bbbd4efea86079f880110b58', '200391', '����ʡ��Ȫ��ҩ���޹�˾', '����ѪƬ', 1.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ѪƬ', 'Ƭ��', '/', '100', 'sjhxp', NULL),
  ('675bfa44762f41dfac50673d00015ddc', '200392', 'ɽ��³��ҽҩ�ɷ����޹�˾', '��', 0.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ������', '����', '0.5g', '1', 'tbzl', NULL),
  ('f8939741e16749a8be469f2691bb24bf', '200393', '�ӱ����ҩҵ�ɷ����޹�˾', '���������ע��Һ', 0.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���������', 'ע��Һ', '10ml:1.0g', '1', 'pttsg', NULL),
  ('c83fa745f67c40ecb1412cd0ebbc8806', '200394', '��կ����Ȼҩҵ�����������ι�˾', '���̽ⶾ����', 2.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���̽ⶾ����', '������', '15g', '10', 'yqxdkl,yqjdkl', NULL),
  ('e9cbc95f4eb344c1a2deee8380d822c2', '200395', '��̨����ҩҵ���޹�˾', '������', 13.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������', '�׽�Ƭ', '0.4g', '24', 'rsjs', NULL),
  ('2deacc28ec5042f6a93b4a7f8e1c967c', '200396', '���ϰ���ҩҵ���Źɷ����޹�˾', '��ð���ȿ���', 2.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ð���ȿ���', '������', '12g', '9', 'gmqrkl', NULL),
  ('3341ca189cbe4e55b791a9e735411404', '200397', '���϶�ͥҩҵ�ɷ����޹�˾', '��', 16.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ױ���', 'Ƭ��', '0.25g', '100', 'ajbs', NULL),
  ('3664cde69bec4bb798f8bc2446b11931', '200398', '�������ҩҵ���޹�˾', '��Ƣ�ϼ�', 20.01, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ƣ�ϼ�', '�ڷ�Һ', '10ml', '18', 'gpgj,gphj', NULL),
  ('395cd731ec904ad3aca204227d4aaf89', '200399', '���Ͽ�����ҩ���޹�˾', '�������Ȼ���', 0.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������Ȼ���', '����Һ', '100ml:0.5g:0.9g', '1', 'jxzlhn', NULL),
  ('3a665a407b6c445f9edb8f9134e8593b', '200400', '���վŷ���ҩ���޹�˾', '���Ϳ���', 11.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���Ϳ���', '������', '4.5g', '20', 'bhkl', NULL),
  ('3d6b1bab47c444028257c2c33f96a96e', '200401', 'ɽ��³��ҩҵ���޹�˾', '��״��Ƭ', 2.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��״��', 'Ƭ��', '40mg', '100', 'jzx', NULL),
  ('3f94129556714597a7a681026535371c', '200402', '���Ͽ���ҩҵ���޹�˾', '10%������', 0.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '10%������', '����Һ', '100ml(��ƿ)', '1', '10%ptt', NULL),
  ('41dc60b4380e4b37924ce939bca5be84', '200403', 'ҩ����ҩ����', '������', 6.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', 'ˮ��', '6g', '10', 'ssw', NULL),
  ('43bb185316e447928e64b86ae700f613', '200404', '�����¾���ҩ���޹�˾', '������', 19.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ�����', '����', '0.5g', '1', 'tbzw', NULL),
  ('44f068dbb53d4bed9af82d469cc8f88e', '200405', '������ҩ�ɷ����޹�˾', 'ע���ð���������', 0.58, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', '����', '1.0g', '1', 'abxl', NULL),
  ('48a167a4f621474bbfe0f12b80cc8939', '200406', '�Ϻ��ִ���ҩ�ɷ����޹�˾', '������', 18.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '˨��', '1.0g', '6', 'txz', NULL),
  ('021a69980e874d5781460c3bd7e3b994', '200407', 'Զ��ҽҩ���й������޹�˾', '��ʯ���������Ƭ', 6.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������', 'Ƭ��', '50mg', '20', 'mtle', NULL),
  ('04605292170b4a8d89e92cef56a3a88f', '200408', '�Ĵ��괺��ҩ���޹�˾', '��������Ƭ', 3.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '��������Ƭ', 'Ƭ��', '/', '60', 'ffdsp,ffdcp', NULL),
  ('07e12db4a973415b844e31ac60059bdd', '200409', '�Ϻ��񶫺���ҩҵ���޹�˾', '��', 2.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', 'ע��Һ', '1ml:5mg', '1', 'jltm', NULL),
  ('0b9dca622532445383ede91dd4ecf509', '200410', 'ʯ��ׯ��ҩ���޹�˾', '��������40�Ȼ���', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������40�Ȼ���', '����Һ', '500ml:30g:4.5g', '1', 'yxtg40lhn', NULL),
  ('0d958164677e4d64a23b25e145b4c3fd', '200411', '��ֻ̨��ҩҵ���޹�˾', '�������ù��Ƭ', 8.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '���ù��', 'Ƭ��', '40mg', '100', 'qdms', NULL),
  ('10ab120cecb540cb894280efbd99c4be', '200412', '��ҩ����������ҩ�ɷ����޹�˾', '�����', 0.22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�����', 'ע��Һ', '10ml:0.25g', '1', 'acj', NULL),
  ('123ffec8da544c15948be6fa3cd5924c', '200413', '�������ҩҵ�ɷ����޹�˾', '���Ծ�ע��Һ', 8.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���Ծ�ע��Һ', 'ע��Һ', '2ml', '1', 'xnjzyy,xnjzsy', NULL),
  ('17c80d1031244812b1134e64bf91e4a2', '200414', '��կ����Ȼҩҵ�����������ι�˾', '׳������ֹʹ��', 2.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '׳������ֹʹ��', '�𽺸��', '7cm*10cm', '10', 'zgsxztg', NULL),
  ('1aa03c627911414db92c25d54a208b01', '200415', 'Զ��ҽҩ���й������޹�˾', '������˾ƥ��', 2.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������˾ƥ��', 'Ƭ��', '����ˮ����0.22g:��������0.15g:������35mg', '100', 'ffesyl,ffespl,ffasyl,ffaspl', NULL),
  ('1d194c40b8fd48729ec8ecd555f8ae2e', '200416', '�����¾���ҩ���޹�˾', '������', 20.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����α�����', '�ڷ�Һ', '60ml(ÿ10ml��Һ������ɴ���20mg:����ľ�Ӹ�����200mg:����α��Ƽ�60mg)', '1', 'yfwmdy', NULL),
  ('1fae266bd1324b8881c70bd3154a283b', '200417', '����������ҩ����ҩ���޹�˾', '�˲ν�Ƣ��', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�˲ν�Ƣ��', '������', '6g', '10', 'rsjpw,rcjpw', NULL),
  ('227bd6d535b94832b1a36e9b36ec0901', '200418', '��������ҩҵ�ɷ����޹�˾', '��', 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '����Ƭ', '30mg', '30', 'gljt,glqt', NULL),
  ('239e326dd9c04034a440e25beaff5d83', '200419', '�Ĵ�ʡ�˱�����Һ�����˱���ҩ�������ι�˾', '����ע��Һ', 19.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ע��Һ', 'ע��Һ', '20ml', '3', 'smzyy,smzsy', NULL),
  ('26f5981f2f8345fe84bde3f6daaacc5b', '200420', '����ҩҵ�������޹�˾', '���Ƚⶾ�ڷ�Һ', 6.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���Ƚⶾ�ڷ�Һ', '�ڷ�Һ', '10ml', '10', 'qrxdkfy,qrjdkfy', NULL),
  ('2a2a20857cdf420789aad79d7df3c3c3', '200421', '��������ҩ�����޹�˾', '��ά��', 1.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ά����C', '����', '0.5g', '1', 'wssc', NULL),
  ('4a049b0a4aaa48e8b50ddeb2e5cc7d0a', '200422', '����������ҩ���޹�˾', '����ͨ����', 25.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ͨ����', '����', '0.4g', '36', 'nxtjn', NULL),
  ('4b3fe0c59c63461bbb4f5a001265a35d', '200423', '�Ϻ��������ҩҵ���޹�˾', '��', 2.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������', 'ע��Һ', '20ml:5.0g', '1', 'jas', NULL),
  ('4e42f8ea371a4d2abd7096eaac29728f', '200424', '�Ϻ���ҩҵ���޹�˾', '��', 28.84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ι���', '����', '0.3g', '30', 'cgjn,sgjn', NULL),
  ('512a8f89b25841e794e1b29b563497c5', '200425', 'ɽ������ҩҵ�ɷ����޹�˾', '��ɳ', 0.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ɳ��', 'Ƭ��', '0.1g', '12', 'zyfsx', NULL),
  ('541cd9a3cd8b4896ab3cd22607f4d11e', '200426', '�˲�����ҩҵ���޹�˾', '������', 1.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '����', '50mg', '6', 'fkz', NULL),
  ('567c91aa949b4c14904cf603aae316d7', '200427', '������ŵ������ҩ�������ι�˾', '���̼������Ƭ', 1.54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '���̼������', 'Ƭ��', '���0.15g��̼������0.15g��������0.001ml', '100', 'dhtsqn', NULL),
  ('8714835dd68a470f92d88b5deeb6c5bd', '200428', '���պ�ҵҩҵ���޹�˾', '������', 1.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', 'Ƭ��', '0.25g', '100', 'ltl', NULL),
  ('887cb5f86b174b40b22962698f086163', '200429', '���տ�ʤҩҵ���޹�˾', '��øQ10����', 2.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '��øQ10', '����', '5mg', '30', 'fmq10', NULL),
  ('8aee814ecd394c04b291213ef76a72bc', '200430', '����ҩҵ�����գ����޹�˾', '���갲Ƭ', 8.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '���갲Ƭ', 'Ƭ��', '0.3g', '100', 'gnap', NULL),
  ('8d9f30a063ec49f09d5cde51043f10ec', '200431', 'ʯҩ����ŷ��ҩҵ���޹�˾', '�����ܰ�Ƭ', 2.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�����ܰ�', 'Ƭ��', '0.25mg', '100', 'xgga', NULL),
  ('8f8944a533194d5f9315abda29555255', '200432', '���׼���(�Ĵ�����)', '֬����ע��Һ(C14-24)', 27.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '֬����ע��Һ(C14-24)', '����Һ', '20% 250ml:50g:3g', '1', 'zfrzyy(c14-24),zfrzsy(c14-24)', NULL),
  ('9cfd5f4c59044020bca5522fb9b9773e', '200433', '����������ҩ�������ι�˾', '��ù��', 15.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ù��', '����Ƭ', '0.5g', '3', 'kmz', NULL),
  ('9fc0ebec8e3d44b787f68e0d6bf9e4aa', '200434', '�㶫һ������', '��������Ƭ', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������Ƭ', 'Ƭ��', '/', '60', 'ffdsp,ffdcp', NULL),
  ('a274f15a7b6f4659918cf5383e9e47e4', '200435', '����ҩҵ�ɷ����޹�˾', '����', 6.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����', 'Ƭ��', '12.5mg', '1000', 'ybq', NULL),
  ('a4c824d9423f46a1a1d2e9e441b4ae0f', '200436', '��������ҽҩ�ɷ����޹�˾', '����θ̩����', 12.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����θ̩����', '������', '20g', '10', 'sjwtkl', NULL),
  ('a7a559fb7dc748909d9ef133f4249d8d', '200437', '�ÿ�ҩҵ�������޹�˾', '�ÿ���', 1.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����������', '����', '80mg', '1', 'azgln', NULL),
  ('aabda4b52ed84e93a3b34690d10b9785', '200438', '����̫��ҩҵ�ɷ����޹�˾', '5%������', 0.91, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '5%������', '����Һ', '250ml', '1', '5%ptt', NULL),
  ('ac069dc3a62e49d797e1deb702b1255e', '200439', 'ɽ������ҩҵ�ɷ����޹�˾', '������ɳ��', 1.58, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ɳ��', 'Ƭ��', '0.2g', '12', 'zyfsx', NULL),
  ('b04915d9fb134e0ba88c408393d58dc1', '200440', '����ҩҵ�ɷ����޹�˾', '���׵�����ע��Һ', 0.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���׵���', 'ע��Һ', '2ml:0.25g', '1', 'bldj', NULL),
  ('b32861e5658a43ecb5d0129a54762eed', '200441', '����ҩ��������ҩ���޹�˾', '֪�صػ���', 2.42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '֪�صػ���', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'zbdhw', NULL),
  ('b4a94ecaf1fc4dbda0a1ca7b7377a717', '200442', '���ҩҵ������֣�ɷ����޹�˾', '��Ī�涡ע��Һ', 3.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī�涡ע��Һ', 'ע���', '2ml:20mg', '10', 'fmtzzyy,fmtdzyy,fmtzzsy,fmtdzsy', NULL),
  ('915b1a077b184c1a806c86b51595c567', '200443', '�ɶ���ԣ�Ƽ���ҩ���޹�˾', '���ᰱ����ע��Һ', 7.36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������', 'ע��Һ', '4ml:30mg', '1', 'axs', NULL),
  ('93cc9d26c2ac4d69bc2e627e7c86dba5', '200444', '����ҫ���������޹�˾', '�������հ�', 0.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�������հ�', 'ע��Һ', '2ml:10mg', '1', 'jylpa', NULL),
  ('95b455abf7d04c3ca1629459389a30d8', '200445', 'ɽ������ҩҵ�ɷ����޹�˾', '��ɳ', 1.06, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������ɳ��', '����', '0.2g', '1', 'zyfsx', NULL),
  ('98737f88856b4792af9aab61141fb75d', '200446', '��ʯ����ҩҵ���޹�˾', '������ĸ��', 4.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ĸ��', 'ˮ����', '60g', '1', 'bzymw', NULL),
  ('9a38111f32f942a2893e72115d485c4f', '200447', '����ʡ������ҩ��', '���ʹ����', 26.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ʹ����', '������', '6g', '12', 'jgtxw', NULL),
  ('599ae0549d9d4052b88710a0209e246a', '200448', '����̫ƽ����ҩ���޹�˾', '�����', 2.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����', '���ͽ���', '0.3g', '10', 'blf', NULL),
  ('f99c542b87ca482e8b321e3ba52b4cbe', '200449', '�Ϻ��񶫺���ҩҵ���޹�˾', '��', 1.62, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�Ȱ�����', 'ע��Һ', '20ml:5.75g', '1', 'yasn,gasn', NULL),
  ('fa2438c3f61b4edcba6db03c0e881e2a', '200450', '�Ͼ�������ҩ���޹�˾', '����ɳ�ǵ���Һ', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ɳ��', '����Һ', '8ml:24mg', '1', 'yfsx', NULL),
  ('fa6ee2d5cb304b41bd5d44a37ffdf7f5', '200451', '�˲��˸�ҩҵ�������ι�˾', 'ά����Cע��Һ', 0.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ά����C', 'ע��Һ', '5ml:1.0g', '1', 'wssc', NULL),
  ('fb71d409055f419fa66913e60f39f361', '200452', '�Ϻ��ִ���ҩ�ɷ����޹�˾', '��Ȼ', 29.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ƽ����Ƭ', '����Ƭ', '30mg', '12', 'xbdpksp', NULL),
  ('fba13efe35b7412ea82f665c55ed28de', '200453', '������Զҩҵ���޹�˾', '��', 2.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����˾͡', 'Ƭ��', '4mg', '100', 'btst', NULL),
  ('fba872f2c845467f8fa683909cd37337', '200454', '����ʡ������ʢҩҵ�ɷ����޹�˾', '����ע��Һ', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ע��Һ', 'ע��Һ', '10ml', '1', 'smzyy,smzsy', NULL),
  ('fc036e664cfb4641a61b0515f762a8c1', '200455', '���Ͽ���ҩҵ���޹�˾', '10%������', 1.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '10%������', '����Һ', '250ml(��ƿ)', '1', '10%ptt', NULL),
  ('fc4535139c7c47d8b9351fe7f57bf36a', '200456', 'ɽ������ҩҵ���޹�˾', '������', 8.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', 'Ƭ��', '0.1g', '100', 'mxl', NULL),
  ('fc98d27ef5e24d48a557915bf1e8c96a', '200457', 'ɽ������ҩҵ�ɷ����޹�˾', 'Ҷ��', 8.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', 'Ҷ��', '����', '15mg', '1', 'xs,ys', NULL),
  ('fc9ce3913e774d018b3aa074f19dc13a', '200458', '����ҩ��������ҩ���޹�˾', '��ң����', 5.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '��ң����', '������', '15g', '10', 'xykl', NULL),
  ('fd58d9907c6a4540a644c38f9fabef42', '200459', '����������ҩ�ɷ����޹�˾', '����������ɳ�ǽ���', 2.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ɳ��', '����', '0.2g', '12', 'zyfsx', NULL),
  ('fddf8bc0c65c4617be6db136462160b5', '200460', '���ݰ���ɽ��Ⱥ(ҩҵ)�ɷ����޹�˾', '������Һ', 9.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������Һ', '�ڷ�Һ', '10ml', '10', 'asbny', NULL),
  ('fdf9147d54e0414caddea72dcbb858b9', '200461', '�Ĵ�ʡ�˱�����Һ�����˱���ҩ�������ι�˾', '��ĸ�ݿ���', 4.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ĸ�ݿ���', '������', '15g', '20', 'ymckl', NULL),
  ('fe53a71997ab4eabbacd1b39b2e84cf0', '200462', '�˲��˸�ҩҵ�������ι�˾', '������ƽƬ', 2.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������ƽ', 'Ƭ��', '0.1g', '100', 'qmxp,kmxp', NULL),
  ('fe77af3aa95e40d48575f8b77a70d0eb', '200463', '������ʩ��߮����ҩ���޹�˾', 'ţ�����彺��', 22.91, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ţ�����彺��', '����', '0.3g', '36', 'nhsqjn', NULL),
  ('ff1a0b01ffbc4e54abc869cdda08e7db', '200464', '����ҩҵ�ɷ����޹�˾', '��ȩ����', 0.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ȩ����', 'Ƭ��', '50mg', '100', 'pqnz', NULL),
  ('ff3042c999bd43c6b122d3381ca089b7', '200465', '����ͬԴ��ҩ���޹�˾', '������(����)', 3.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������(����)', '�ڷ�Һ', '10ml', '10', 'smy(dc),smy(ds)', NULL),
  ('8743a95fb3d34107bfab4870741932ea', '200466', '��������ҽҩ�������޹�˾������ҩ��', '��������ͪע��Һ', 7.29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '����ͪ', 'ע��Һ', '2ml:2mg', '1', 'nlt', NULL),
  ('87644063ad9c40259117ee26e896d846', '200467', 'ɽ������ҩҵ���޹�˾', '��Ī��ƽ', 3.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��Ī��ƽ', 'Ƭ��', '30mg', '100', 'nmdp', NULL),
  ('87b2bb249f974044a664536234f05ee1', '200468', '��������ҩҵ���޹�˾', '����������', 3.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '����������', '����', '0.25g', '1', 'yxgxa,yxyxa', NULL),
  ('87d11329049d4209b6b318db774dba41', '200469', '�㽭���п���ҩ���Źɷ����޹�˾', '����ù��Ƭ', 64.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '��������', 'Ƭ��', '50mg', '100', 'lzpl', NULL),
  ('87d24184ba0a467da5756189f82adfd2', '200470', '����ŵ��ҩҵ���޹�˾', 'ע����Ѫ��ø', 39.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'Ѫ��ø', '����', '1IU', '1', 'xnm', NULL),
  ('87dbcc2fe29c4cc48e7c0c50326358fd', '200471', '�����ҩҩҵ�ɷ����޹�˾', '��', 1.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������', 'Ƭ��', '0.75mg', '100', 'dsms', NULL),
  ('8845cb2b448143838cb9e11e554561b2', '200472', '�����ϲ�������ҩ��', '?', 18.91, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ʯ����', '������', '5g(������)', '10', 'pskl,pdkl', NULL),
  ('88b4815bd5b7462b91146183462a03dd', '200473', '���ϻ���ҩҵ�������ι�˾', '������', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '������', '9g', '10', 'hjw', NULL),
  ('88ebadddad5045b2a82198242957e691', '200474', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '������', 6.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '�ڷ�Һ', '10ml:30mg', '10', 'axs', NULL),
  ('8902fe3737544717985f72cafc587907', '200475', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', 'ͷ��������', 0.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ��������', '����', '1.0g', '1', 'tbqsn', NULL),
  ('895501c3fac5404283cf744d076e340d', '200476', '���Ͽ�����ҩ���޹�˾', '��ù��', 1.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù��', '����', '0.25g', '1', 'hms,gms', NULL),
  ('8976adc2d0f64991a21917f9d49857ee', '200477', '�������䱦��ҩ���޹�˾', '�����ע��Һ', 1.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '�����ע��Һ', 'ע��Һ', '20ml:0.1g', '1', 'cwjzyy,cwjzsy', NULL),
  ('8a1aea11cd9a4990a5a2b241d96fceb0', '200478', '�㶫̨����ҩ�ɷ����޹�˾', '��������Ƭ', 24.33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������Ƭ', 'Ƭ��', '0.27g', '100', 'jksqp', NULL),
  ('8a6ed42d416d470e8136ac1bf22e35d6', '200479', '���Ͽ���ҩҵ�ɷ����޹�˾', '���̽ⶾƬ', 3.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '���̽ⶾƬ', 'Ƭ��', '/', '48', 'yqjdp,yqxdp', NULL),
  ('8aa3bee08f7f4fd1903dfd5205cef411', '200480', '�����Ļ�������ҩ���޹�˾', '���ܰ�', 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ܰ�', '��ɢƬ', '0.5mg����', '20', 'jga', NULL),
  ('8b13f47d76ec452e9dae39e202c47144', '200481', '�ӱ�����ҩҵ���޹�˾', '�����彺��', 3.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����彺��', '����', '0.33g', '24', 'nlqjn', NULL),
  ('8b299d0c04674bdabb2e2d71b0316585', '200482', '������һ����ҩ���޹�˾', 'ּ̩', 12.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������͡', '����', '20mg', '10', 'xftt', NULL),
  ('8b669f75d964462f911799c63a357bc7', '200483', '�人�徰ҩҵ���޹�˾', '����ɳ�ǵζ�Һ', 1.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ɳ��', '�ζ�Һ', '5ml:15mg', '1', 'yfsx', NULL),
  ('8bfc9364b93d4c01a65b5d6b687d4bb2', '200484', '����������ҩ�������ι�˾', '��ù��', 10.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ù��', '����Ƭ', '0.5g', '2', 'kmz', NULL),
  ('a3eb4a2777964821aed55df0036b1b6e', '200529', 'ɽ��������ҩ���Źɷ����޹�˾', '����Ƭ', 3.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Ƭ', 'Ƭ��', '0.36g', '100', 'hgp', NULL),
  ('a3f349a3c5cb4facb267b912eed43ba4', '200530', '�Ϻ��ִ���ɭ(����)ҩҵ���޹�˾', '�ǰ������ע��Һ', 0.33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '�ǰ����', 'ע��Һ', '2ml:0.4g', '1', 'hamd', NULL),
  ('a431fbe79f2748db89c2bdef23869bb5', '200531', '��������ҩҵ���޹�˾', '��������˨', 2.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '˨��', '0.1g', '10', 'ydmx', NULL),
  ('a4ac7040a2d8424b8f6f514836ae3c01', '200532', '�Ϻ�����ʵҵ�����ţ�������ҩҵ���޹�˾', '�������彺��', 18.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������彺��', '����', '0.4g', '30', 'hlsqjn', NULL),
  ('a5a7f2272cfe44b8aa677babae3d76b5', '200533', 'ɽ��³��ҽҩ�ɷ����޹�˾', '��', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ������', '����', '1.0g', '1', 'tbzl', NULL),
  ('a5c443ec83b647fea5a10c65935a31db', '200534', '����ҩҵ�ɷ����޹�˾', '����ɳ�ǵ���Һ', 0.92, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ɳ��', '����Һ', '5ml:15mg', '1', 'yfsx', NULL),
  ('a5c8ef8014bf49ecbced613ee558bd62', '200535', '���绪��ҩҵ���޹�˾', '��', 0.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù��', '����', '8g:80mg(1%)', '1', 'hms,gms', NULL),
  ('a5dfa2efadab4bf49af227f2319e64fa', '200536', '�Ϻ���������Ƽ���������ҩҵ���޹�˾', 'ά����B1Ƭ', 5.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', 'ά����B1', 'Ƭ��', '5mg', '1000', 'wssb1', NULL),
  ('a660cb1fec894aac8b49d76fdc4e3290', '200537', '�Ͼ��׾�����ҩ�������ι�˾', 'ͪ����', 4.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͪ����', '����', '15g:0.3g', '1', 'tkz', NULL),
  ('a6dbe8fdf8514d018f5c37d45e79318b', '200538', '������ҩ���޹�˾', '��', 1.93, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�ط����', 'Ƭ��', '25mg', '100', 'dfnd', NULL),
  ('a723d0e20165445a9a0b94fefd4d7312', '200539', '������ҩ����������һ��ҩ���޹�˾', '��', 7.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������������', 'Ƭ��', '0.5g', '400', 'dyxajf', NULL),
  ('a74564066e4f40b99aacfd2a37898ad3', '200540', 'ҩ����ҩ���Źɷ����޹�˾', 'Ѫ��������', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'Ѫ��������', '������', '9g', '10', 'xfzyw', NULL),
  ('a83981a230d5446697b393f5a96ca0ea', '200541', '����˫��ҩҵ�ɷ����޹�˾', '������Ѫƽ�������Ƭ', 8.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������Ѫƽ�������', 'Ƭ��', '����', '10', 'fflxpabdd', NULL),
  ('a83ff4713c2d4de190d47f8a9a850579', '200542', '��³��ҩ���޹�˾', '������ɽ����ע��Һ', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '������ɽ����', 'ע��Һ', '5ml:5mg', '1', 'xsyslz', NULL),
  ('a85664a1b05d414db83b0aa0ac1b0220', '200543', '������ҩ����������һ��ҩ���޹�˾', '��', 2.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù����', '����', '2.0g', '1', 'lmsn', NULL),
  ('a89406e8ad02457e96c6163aa3e7780e', '200544', '����̫��ҩҵ�ɷ����޹�˾', '10%������', 0.91, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '10%������', '����Һ', '250ml', '1', '10%ptt', NULL),
  ('a8a9222a11ec4cd686069b842d9aae52', '200545', '����ҩ���ʺ���ҩ���޹�˾', '�����俵��˨', 2.53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '�俵��', '˨��', '0.2g', '7', 'mkz', NULL),
  ('a8d4d457795a460f935845dc85b3da1e', '200546', '����ҩҵ�ɷ����޹�˾', '������ɽ����', 15.59, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ɽ����', '����Ƭ', '20mg', '30', 'xsyslz', NULL),
  ('a95e48c393f2409a982bc4e078f70395', '200547', '���ϻ�����ҩ�ɷ����޹�˾', '�������Ȼ���ע��Һ', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '�������Ȼ���ע��Һ', '����Һ', '500ml:25g:4.5g((��ƿ)', '1', 'pttlhnzyy,pttlhnzsy', NULL),
  ('aa101489823e4043badfe327ff1da563', '200548', '�ٷڱ�����ҩ���޹�˾', '��������', 0.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������', '����Ƭ', '25mg', '100', 'ydmx', NULL),
  ('aa9c36a328144b65b2b1b5013437ba99', '200549', 'Զ��ҽҩ���й������޹�˾', '*', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ȥ����������', 'ע��Һ', '1ml:2mg', '1', 'qjssxs', NULL),
  ('aaa06e36203d4370bb966023da86b8a5', '200550', '��ɽ��ԭ��ҩ���޹�˾', '�޴�����', 2.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�޴�����', '����', '500IU', '1', 'rcxs', NULL),
  ('aacd68e6dda542f7b5b3466ba2b093a9', '200551', '�㽭̩��ɭҩҵ���޹�˾', '����ͬ', 9.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ƽ����Ƭ', '����Ƭ', '20mg', '20', 'xbdphsp', NULL),
  ('aad4d42b810a407f905add48e8cca52d', '200552', '����������ҩ�������ι�˾', '����Ƭ', 18.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Ƭ', 'Ƭ��', '0.35g', '36', 'ssp', NULL),
  ('aaf43b9420784963a6d4a51d3160d8af', '200553', '�㽭�����ҩ�ɷ����޹�˾', '������ͪ', 3.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������ͪ', 'Ƭ��', '2mg', '100', 'jqyt', NULL),
  ('ab0eea5fec71421c9d3ebb0f05fed044', '200554', '�������䱦��ҩ���޹�˾', 'Ѫ��ͨע��Һ', 1.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'Ѫ��ͨע��Һ', 'ע��Һ', '2ml:0.1g', '1', 'xstzyy,xstzsy', NULL),
  ('ab0ffbca75964f1b810e7c395b316dab', '200555', '��������ҩ���޹�˾', '�ٺ����', 4.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ٺ����', '������', '11g(�൱��ԭ��ҩ7g)', '10', 'jhkl,jgkl', NULL),
  ('ab1a654ddd2246b7b51e5d3fc2a92ef0', '200556', 'ɽ������ҩҵ�ɷ����޹�˾', '��ù��', 7.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '��ù��', '��������Ƭ', '0.15g', '10', 'kmz', NULL),
  ('abfe920562794846b844f1d6c9512392', '200557', '���ϻ���ҩҵ�������ι�˾', '轾յػ���', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '轾յػ���', '������', '9g', '10', 'qjdhw', NULL),
  ('ad1dc1afed9c49d484ebc2ab215a8286', '200558', 'ɽ������ҩҵ���Źɷ����޹�˾', '��', 0.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����������', 'ע��Һ', '2ml:0.1g', '1', 'yxgxa,yxyxa', NULL),
  ('ad956ceef6de4427a5d20c6cfcfab3b6', '200559', '��������ҩҵ���޹�˾', '��������������Ƭ', 1.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '��������Ƭ', '0.2g', '14', 'jxz', NULL),
  ('add8f7a906f9466b862ad98240731a31', '200560', '�����л�������ҩ��ҵ�ɷ����޹�˾', 'ͷ������', 11.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ������', '����', '0.5g', '1', 'tbmz', NULL),
  ('ae093d8e38c649a5a61b2bd85100ad14', '200561', '���绪��ҩҵ���޹�˾', '��', 0.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ŵ��ɳ��', '����Һ', '8ml:24mg', '1', 'nfsx', NULL),
  ('ae5b6c7c65b8449aa5e38705435f9e07', '200562', '���ݰ���ɽ������ҩ���޹�˾', '�Ͽ�˾', 20.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�忪�齺��', '����', '0.4g', '24', 'qkljn', NULL),
  ('af3b242712044c85abde65bb1b6ecaca', '200563', '���շ�ǿ��ҩ���������ι�˾', '�ذ���', 1.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�ذ���', 'Ƭ��', '10mg', '100', 'dbz', NULL),
  ('af6d253622a44c0cb9500d6e39a7dbfa', '200564', '�Ĵ�����ҩҵ�������ι�˾', '�²���', 2.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Τ��', '������', '0.15g', '12', 'lbwl', NULL),
  ('afa2174b65ec48538cde4a472d3977c8', '200565', '�㽭����ҩҵ���޹�˾', '���ȴ�Ƭ', 6.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ȴ�Ƭ', 'Ƭ��', '0.3g', '24', 'xkcp,xhcp', NULL),
  ('afbdb5ae0fc64fec9a78fbfecd8c5cf1', '200566', '���ϱ̿�ҩҵ���޹�˾', '���', 12.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����������', 'ע��Һ', '2ml:40mg', '1', 'azgln', NULL),
  ('b04dc599beea4714b36732e558d8e776', '200567', '�人����������ҩ���޹�˾', '�ƿ�о��', 16.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������ɽ����', '����', '25mg', '1', 'cxsyslz,sxsyslz,dxsyslz', NULL),
  ('b050f8b15afe48f79fee92be40e93e9d', '200568', 'ɽ���Ͳ��´���ҩ���޹�˾', '�´ﱴ��', 1.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī����', '������', '0.125g', '12', 'amxl,emxl', NULL),
  ('b066ca1f23234453abc4b0b85ca0de36', '200569', '���鼯��������ҩ��', '�޴�����', 5.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�޴�����', '����', '2000IU', '1', 'rcxs', NULL),
  ('b0b39067c5ca49ffa1efb933bd7a10fb', '200570', '�����췽ҩҵ�ɷ����޹�˾', 'ά����Cע��Һ', 0.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ά����Cע��Һ', 'ע��Һ', '2ml:0.5g', '10', 'wssczsy,wssczyy', NULL),
  ('b0b42065abc7470c8b2ecc21dd7eebaa', '200571', '���ϰ�ҩ����', 'Ѫ��ͨע��Һ', 1.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'Ѫ��ͨע��Һ', 'ע��Һ', '2ml:0.1g', '10', 'xstzyy,xstzsy', NULL),
  ('8c285b91ac07457ab8686668fa740a6d', '200485', '�ӱ����ҩҵ�ɷ����޹�˾', 'ע����ά����C', 1.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ά����C', '����', '1.0g', '1', 'wssc', NULL),
  ('8ca78455c9f2452898e2e61e0ccb1c2a', '200486', '������һ������ҩ�������ι�˾', '���ƿ���', 18.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ƿ���', '������', '4g(������)', '16', 'yhkl', NULL),
  ('8cb157bed4cd44b6bed3edca34de2798', '200487', 'ɽ������ҩҵ�ɷ����޹�˾', '����ù��', 0.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ù��', '����', '0.25g', '1', 'ajms,ejms,aqms,eqms', NULL),
  ('8cfab39efad64a1da64775568a9fe239', '200488', 'ɽ������ҩҵ�ɷ����޹�˾', '��������', 2.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '����', '10mg', '6', 'lltd', NULL),
  ('8da40830742e4657884e6179d0ccd891', '200489', '֣������ҩ���޹�˾', '�����������Ƭ', 6.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������', 'Ƭ��', '2mg', '28', 'tlzq', NULL),
  ('8e1d53a6d63c46b8b78365feee416d33', '200490', '�ݶ�ҽҩ�������޹�˾', '�ݰ�˾ƥ��', 13.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��˾ƥ��', '����Ƭ', '0.1g��������Ӧ֢��', '30', 'aspl,espl,asyl,esyl', NULL),
  ('8e42d9d098a3433cac8337f3c737ab1a', '200491', '����ʡ��Ȫ��ҩ���޹�˾', '����ڷ�Һ', 5.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ڷ�Һ', '�ڷ�Һ', '10ml', '10', 'chkfy', NULL),
  ('8e5d807ff8ca4a829a25f4e14d0308c3', '200492', '�Ϻ��ִ���ɭ(����)ҩҵ���޹�˾', '�����涡ע��Һ', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�����涡', 'ע��Һ', '2ml:0.2g', '1', 'xmtd,xmtz', NULL),
  ('8ed2f8cc77154b40bd3f76ff0cb359c7', '200493', '�����������ɽ��ҩҵ�ɷ����޹�˾', '����������', 18.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����������', 'ˮ��', '0.133g', '108', 'hsxsw,hzxsw', NULL),
  ('8f33724ecc5c4aeebded9cc3bd321ec5', '200494', '��ҩ����������ҩ���޹�˾', '��øA', 0.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��øA', '����', '100U', '1', 'fma', NULL),
  ('8f452d16345a4bd78ee6d15e33772c5c', '200495', '���ϸ�������ҩҵ���޹�˾', '˳��ע��Һ', 9.32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '˳��', 'ע��Һ', '2ml:10mg', '1', 'sb', NULL),
  ('8f8c55351de649579286ba2809a4ff33', '200496', '�ӱ�����ҩҵ���޹�˾', '��������', 0.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', 'ˮ��', '1.1g/10', '100', 'nlqw', NULL),
  ('8fadbcc4fcf44aadb277779355906ba1', '200497', 'ʯҩ������ҩ���޹�˾', '�컨ע��Һ', 1.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�컨ע��Һ', 'ע��Һ', '5ml', '1', 'hhzsy,ghzsy,hhzyy,ghzyy', NULL),
  ('8fb022716f4b4cc6945c2eae867f825b', '200498', '���Ϸ�ʢ��ҩ�ɷ����޹�˾', '����ʯɢ', 5.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ʯ', 'ɢ��', '3.0g', '10', 'mts,mtd', NULL),
  ('8fce5c2a18c545369f2dabde73ece92e', '200499', '�Ϻ�����ҩ�����޹�˾', '��', 8.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�����', 'Ƭ��', '25mg', '100', 'bmq', NULL),
  ('8fe9ca1f221e4612b8712007a11934fe', '200500', '���Ͽ�����ҩ���޹�˾', '��˹ƽ', 1.33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������', '����', '0.2g', '1', 'chn', NULL),
  ('90847ff258b440ffbfe0b75150af619e', '200501', '�㽭���念ԣ��Ȼҩ�����޹�˾', '�׹��ٶ���Ƭ', 9.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�׹��ٶ�߰Ƭ', 'Ƭ��', '10mg', '50', 'lgtddp', NULL),
  ('90ac734f3b7a4f8eaada414d58e8e0ed', '200502', '������ҩ��ҩ���޹�˾', '�������', 4.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������', 'Ƭ��', '25mg', '20', 'mtle', NULL),
  ('90bbfaa46f4f47bc83ec517f84d438cb', '200503', '̫���������츢����ҩ�����޹�˾', '��֧����', 12.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��֧����', '������', '4g', '12', 'jzkl', NULL),
  ('9c9fec88fbc64ab3a6a0ff7ae0ae392c', '200504', '��������ҩ�����޹�˾', '�������ù��ע��Һ', 7.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������ù��ע��Һ', 'ע��Һ', '2ml:0.15g', '10', 'ysklmszyy,ysklmszsy', NULL),
  ('9ca85be39b0644a5ace19ea5e0324d85', '200505', '����ҩҵ�������޹�˾', '���ٻ�ע��Һ', 1.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���ٻ�ע��Һ', 'ע��Һ', '10ml', '1', 'yzhzsy,yzhzyy', NULL),
  ('9cd0981bc9614e1c9ad62d36e35a1972', '200506', '���Ϻ�ɭ��ҩ�ɷ����޹�˾', '��Ȫ����', 33.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ȫ����', '����', '0.3g', '60', 'sqjn', NULL),
  ('9ce45cd8150e4c69ba897da6039bf383', '200507', '����̫��ҩҵ�ɷ����޹�˾', '˫�����ϼ�', 5.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '˫�����ϼ�', '�ڷ�Һ', '100ml', '1', 'shlgj,shlhj', NULL),
  ('9cef6b129d2f4cbd8380b2a1414cfc1b', '200508', '���հ���������ҩҵ���޹�˾', '��Ƥ��', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ƥ��', '��ҩ', '15g', '10', 'gpg', NULL),
  ('9d01fac0f77e44f3b073d99417000a86', '200509', '����������ҩ�����������ι�˾', '��', 10.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ҩ����', '����', '0.25g', '24', 'sqsyjn', NULL),
  ('9d048f7b37c04cc7aca2625b1d4ad5ad', '200510', '���Ͽ���ҩҵ���޹�˾', '5%������', 1.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '5%������', '����Һ', '250ml(��ƿ)', '1', '5%ptt', NULL),
  ('9d628616e28a477b99caacd4d2275b14', '200511', '������ҩ����', 'Ѫ��ͨע��Һ', 1.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'Ѫ��ͨע��Һ', 'ע��Һ', '2ml:0.1g', '10', 'xstzyy,xstzsy', NULL),
  ('9dc2b134053e4feeb3c54d0d51b410e9', '200512', 'ɽ������ҩҵ�ɷ����޹�˾', 'Ҷ��', 13.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', 'Ҷ��', '����', '30mg', '1', 'xs,ys', NULL),
  ('9e1c7893d13c477c9342783a7ce57e26', '200513', '���ݿ���ҩҵ���޹�˾', '������', 2.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', 'Ƭ��', '2mg', '100', 'bhs', NULL),
  ('9e40273bc8044750811bb91dddb9531f', '200514', '��³��ҩ���޹�˾', '�ȵ�ƽƬ', 1.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�ȵ�ƽ', 'Ƭ��', '25mg', '100', 'ldp', NULL),
  ('9e51e06f8b9e495997521e54e9918bc4', '200515', '���ҩҵ������֣�ɷ����޹�˾', '��', 0.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�����涡', 'ע��Һ', '2ml:50mg', '1', 'lntd,lntz', NULL),
  ('9f7e1b49a6644244b7734cefab44d98e', '200516', '�Ϻ�������ҩ���޹�˾', '�����ʲݿڷ���Һ', 5.37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����ʲݺϼ�', '�ڷ�Һ', '10ml', '10', 'ffgcgj,ffgchj', NULL),
  ('9ffd740773534ce48341843651c4b1da', '200517', '����������ҩ����ҩ���޹�˾', '��ɰ��θ��', 3.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ɰ��θ��', 'ˮ��', '6g', '10', 'xsyww', NULL),
  ('a01f09d252b348c48a89dbc1721a12e3', '200518', '���ҩҵ�������޹�˾', '��', 0.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ʯ֬', '����', '10g:1g', '1', 'ysz,ydz', NULL),
  ('a13b4d6d47a544d49291a1a5140cf6be', '200519', 'ɽ������ҩҵ�ɷ����޹�˾', '�工��͡', 2.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�工��͡', 'Ƭ��', '20mg', '10', 'lftt', NULL),
  ('a1893931748a472f8f5f1ffdb2ceff91', '200520', 'ɽ������ҩҵ���Źɷ����޹�˾', '��', 6.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������ɽ����', 'Ƭ��', '20mg', '48', 'cxsyslz,sxsyslz,dxsyslz', NULL),
  ('a1983f6ce18b463c8fe3b8d41b38720d', '200521', '�Ĵ�������ҩ���޹�˾', 'С�������', 1.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'С�������', '������', '10g', '6', 'xchkl', NULL),
  ('a22fd0807ea44f7caf0c24ccc1149d9a', '200522', '�����췽ҩҵ�ɷ����޹�˾', '�������', 5.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������˫�һ���Ƭ', '����Ƭ', '0.5g', '24', 'ysejsghsp', NULL),
  ('a23997cfd6e74835a6d0f8859cdcb13c', '200523', '�Ϻ��ִ���ɭ(����)ҩҵ���޹�˾', '�Ŷ������þע��Һ', 0.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�Ŷ������þ', 'ע��Һ', '10ml:0.452g:0.4g', '1', 'mdasjm', NULL),
  ('a239a1a29d004b5daeb6ea9b7b7b0385', '200524', '�˲��˸�ҩҵ�������ι�˾', '������Ƭ', 1.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', 'Ƭ��', '0.2g', '100', 'jxz', NULL),
  ('a28cf1908f8540c3bc69ebe52f59bf6e', '200525', '���ݶ�Ҷ��ҩ���޹�˾', '��������', 0.93, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '��������', '����', '1.0g', '1', 'bzxl', NULL),
  ('a2c2e925e89a4b7dbcfcabce50fb2055', '200526', '��³��ҩ���޹�˾', '�工��͡��ɢƬ', 14.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�工��͡', '��ɢƬ', '20mg', '12', 'lftt', NULL),
  ('a31ca46bcb91441d89ca190cb68358a6', '200527', '����ҩҵ�ɷ����޹�˾', '��������', 1.29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', 'ע��Һ', '5ml:0.125g', '1', 'pnsl', NULL),
  ('a37caa4cce7642078c5a7ea8f133c19e', '200528', '����ͬԴ��ҩ���޹�˾', 'ά����C', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ά����C', 'ע��Һ', '2ml:0.1g', '1', 'wssc', NULL),
  ('0bc5fbcc037e4ed08d803f060a10a62d', '200220', '�Ǳ�ҩҵ���Źɷ����޹�˾', '�Ǳ���ά', 6.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ܰ�', 'Ƭ��', '0.5mg', '20', 'jga', NULL),
  ('0bf087a5ab8a49c6b5cbbffe953bd1ff', '200221', '����ҩҵ�ɷ����޹�˾', 'ɢ��ͨ', 5.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������������(II)', 'Ƭ��', '������������0.25g:��ˮ������50mg:����������0.15g', '10', 'ffdyxajf(ii)', NULL),
  ('0c437a8b2ef94d77b8e332516be8bf8b', '200222', '���ݰ���ɽ������ҩ�ɷ����޹�˾', 'ʩ����', 5.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��Ī����/����ά���', '����', '0.3g(5:1)', '1', 'emxl/klwsj,amxl/klwsj', NULL),
  ('0cc65179571d4bf79288241a9c8b5c09', '200223', '�人�徰ҩҵ���޹�˾', '����ƽ', 0.62, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ƽ', '����Һ', '10ml:5mg', '1', 'lfp', NULL),
  ('0ce5764adb6942089d8656c038d5fd55', '200224', '�����ǰ��ɭҩҵ���޹�˾', '����������ɳ�ǵ���Һ', 4.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������ɳ��', '����Һ', '5ml:15mg', '1', 'zyfsx', NULL),
  ('0d66d3b2c5c44a6b86c41005cc69e0d6', '200225', '��ҩ��������ʩ��ҩҵ���޹�˾', '̩��ƽ', 25.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ͪ', '����', '15mg', '20', 'pglt,bglt', NULL),
  ('0d96f45f6023450daef5bacb8c2b8be4', '200226', '���ҩҵ������֣�ɷ����޹�˾', '��', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', 'ע��Һ', '1ml:1mg', '1', 'ssxs', NULL),
  ('0da3e9def2ad4002bb1ffce8324cd9eb', '200227', '������ҩҵ���޹�˾', '������', 10.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', 'ˮ��', '10(3.125g/1000)', '6', 'lsw', NULL),
  ('0dc9b8d94643428488fbc7bcf6826a84', '200228', '�人�˸�ҩҵ�������ι�˾', '�϶�ŵ', 2.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�����', '����Һ', '25ml:0.5g', '1', 'blf', NULL),
  ('0df54ee3f0aa4b339b7b81569938e792', '200229', 'ɽ������ҩҵ���޹�˾', '�俵��', 1.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�俵��', '����', '10g:0.2g', '1', 'mkz', NULL),
  ('0e64c6a4e76f45ea9cead3cb44a6319a', '200230', '����ǧ���潭ҩҵ�ɷ����޹�˾', '��ɳ̹', 7.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ɳ̹', '����', '80mg', '7', 'xst', NULL),
  ('0f28ec9fcd8c4f90af5bea7253edb026', '200231', 'ͨ������ҩҵ�ɷ����޹�˾', '������30R', 46.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '30/70����������ȵ���', 'ע��Һ', '10ml:400IU', '1', '30/70hhczryds,30/70hgzzryds,30/70hgczryds,30/70hhzzryds', NULL),
  ('0f2b57c01238482ea8eb816081782baf', '200232', '�㶫�������ҩ���޹�˾', '��', 3.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', 'ˮ����', '60g', '1', 'hjw', NULL),
  ('0f4cd71400ff400c9ae752518a529199', '200233', '����ҩҵ�������޹�˾', '˫�״�Ī', 1.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '˫�״�Ī', 'Ƭ��', '25mg', '100', 'smdm', NULL),
  ('0f71ca345cee465e8d7898f7fd5589b2', '200234', '��ɽ��ԭ��ҩ���޹�˾', '������', 0.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������', 'ע��Һ', '1ml:10U', '1', 'sgs', NULL),
  ('0f81075ffd8149a5be9953850820a6f2', '200235', '�Ǳ�ҩҵ���Źɷ����޹�˾', '�����', 1.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '�����', 'ע��Һ', '5ml:0.2g', '1', 'ggs', NULL),
  ('0fa4efc77f6941acbf690c5e6c793d92', '200236', '���ݵ�����ҩ���������ι�˾', '��Ī��ƽ����', 3.54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī��ƽ', '����', '20mg', '50', 'nmdp', NULL),
  ('10eaea9fbd434bf39096cf6268057445', '200237', '��������̩ҩҵ�ɷ����޹�˾', '��ϣ͡', 26.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ������', '����', '1.0g', '1', 'tbxd,tbxz', NULL),
  ('1115dd8d105940d99a93c52a849b1735', '200238', '���ϰ��꿵��ҩҵ���޹�˾', '����������', 3.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������', 'ˮ��', '6g', '10', 'hlsqw', NULL),
  ('1136d643e1ce4e5dac51bf0f471ee73c', '200239', 'ɽ������ҩҵ�ɷ����޹�˾', '��������', 1.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ù��', '������', '0.1g', '4', 'ajms,ejms,aqms,eqms', NULL),
  ('113ed8a58b904d399f2b8953f3c511d6', '200240', '�ߺ��ź㴺ҩҵ���޹�˾', '��ɰ������', 3.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ɰ������', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'xsljw', NULL),
  ('1163be770fac40ffbd89ec681d13ac07', '200241', '����̫��ҩҵ�ɷ����޹�˾', '10%������', 1.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '10%������', '����Һ', '500ml', '1', '10%ptt', NULL),
  ('11af73a58269462b958d5e6ab7e78b17', '200242', '��������ҩҵ���޹�˾', '����ҽ���', 1.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����', '����', '0.2g', '20', 'blf', NULL),
  ('1203a215994e4948a5c718c180ba6d6f', '200243', '��������ҩҵ���޹�˾', '��', 2.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', 'ɽݹ�м�', 'Ƭ��', '5mg', '100', 'sldj', NULL),
  ('120d5e41f9634390b3112a1f43fd5b9e', '200244', '�㶫������ҩ���޹�˾', '/', 14.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '����', '/', '30', 'smjn', NULL),
  ('135c294b1178417aa22a99873a2fe647', '200245', '����ҫ���ź�����ҩҩҵ�ɷ����޹�˾', '����Τ��', 0.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����Τ��', 'ע��Һ', '2ml:0.25g', '1', 'lbwl', NULL),
  ('1369c8e22f4d46e7aac6c875bc546d0a', '200246', 'ɽ������ˮ', '���̽ⶾ��', 3.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���̽ⶾ��', '������', '9g', '10', 'yqjdw,yqxdw', NULL),
  ('1374ac5a82d547c48ec9def9d6488511', '200247', 'ɽ����³��ҩ���޹�˾', '��ŵ���ؽ���', 2.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ŵ����', '����', '0.1g', '20', 'fnbt', NULL),
  ('147104c23dcc4de78a464f40248c9283', '200248', '�Ϻ��̷���ҩ���޹�˾', '�屴��', 0.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�屴��', 'ע��Һ', '1ml:3mg', '1', 'lbl', NULL),
  ('14cd5dea3eff4f11919fa13667045a43', '200249', '������ҩ(����)���޹�˾', '50%������', 0.26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '50%������', 'ע��Һ', '20ml', '1', '50%ptt', NULL),
  ('16118b75471343d5b2a7a5e72ee22612', '200250', '�㽭����ҩҵ���޹�˾', '���ỷ��ɳ�ǽ���', 1.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ɳ��', '����', '0.25g', '10', 'hbsx', NULL),
  ('16162f8aaebc49d0a00ffc3d8d60a7c9', '200251', '����ŵ��ʤ��ҩ���޹�˾', '����������', 3.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����������', 'ˮ����', '60g', '1', 'twbxw', NULL),
  ('175f0c9d3f2e4d8a8e6cb8eedceebda6', '200252', '�����췽ҩҵ�ɷ����޹�˾', '����«��', 4.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����«��', 'Ƭ��', '60mg', '100', 'qklz,qkld', NULL),
  ('1777a34e931a4d4b9b0e3e80752252da', '200253', '�ӱ�����ҩҵ���޹�˾', '�忪��ע��Һ', 1.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�忪��ע��Һ', 'ע��Һ', '10ml', '1', 'qklzsy,qklzyy', NULL),
  ('17c2b806bb0b46ebaaf482d40457cb34', '200254', '���ƣ���ɽ��ҩҵ���޹�˾', '�˲ν�ƢƬ', 16.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�˲ν�ƢƬ', 'Ƭ��', '0.25g', '24', 'rcjpp,rsjpp', NULL),
  ('18162392eecc40dead7ec721644096a5', '200255', '�Ǳ�ҩҵ��ͬ��ҩ���޹�˾', 'ţ��������', 2.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ţ��������', '������', '6g', '10', 'nhsqw', NULL),
  ('1817b2127f5549fc8ad7d5579778208b', '200256', '�ɶ�������ҩ���޹�˾', '����Ѫ��������', 49.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Ѫ��������', '����', '0.5g', '60', 'slxmkjn', NULL),
  ('18b869252b814daca4b06dc363d11f5a', '200257', '�Ĵ�������ҩ���޹�˾', 'Ԫ��ֹʹƬ', 4.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', 'Ԫ��ֹʹƬ', 'Ƭ��', '/', '100', 'yhztp', NULL),
  ('18e228817fb745fa8cfd1e0c025aa6e9', '200258', '�Ϻ��ִ���ҩ�ɷ����޹�˾', '��������', 3.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', 'Ƭ��', '5mg', '16', 'ynpl', NULL),
  ('6979e47cb0674b1aa00664b666fa1412', '200259', '������ҩ�ɷ����޹�˾', 'ע����ͷ�������', 0.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ�����', '����', '1.0g', '1', 'tbsw', NULL),
  ('6a516d400b4846fda944c50241518ff9', '200260', '������ʥ̩������ҩ���޹�˾', 'Ѫ˨ͨ', 2.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'Ѫ˨ͨ', 'ע��Һ', '2ml:70mg', '1', 'xst', NULL),
  ('6a941e35409542438460ac93788eaaed', '200261', '�㽭����ҩҵ���޹�˾', '�Ŷ������þƬ', 7.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '�Ŷ������þ', 'Ƭ��', '��ˮ�Ŷ������79mg:��ˮ�Ŷ�����þ70mg', '100', 'mdasjm', NULL),
  ('6b44848eaee14786b6165f3adbd8e06b', '200262', '���Ͽ���ҩҵ���޹�˾', '10%������', 1.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '10%������', '����Һ', '500ml(��ƿ)', '1', '10%ptt', NULL),
  ('6bdaf0e4a68e49a0a4ed2986e2443a74', '200263', '��������ҩҵ���޹�˾', '������', 6.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', 'Ƭ��', '20mg', '100', 'lnz', NULL),
  ('6d308572837645bcb7a0c5f37d09fd55', '200264', 'ɽ������ҩҵ���Źɷ����޹�˾', 'άA�����', 7.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'άA��', '����', '15g:15mg', '1', 'was', NULL),
  ('6d77a12479a74f778d7916297c24ce1a', '200265', 'ɽ����Ԫʢ����ҩ���޹�˾', '���������', 4.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���������', '������', '9g', '10', 'yyqfw', NULL),
  ('6db80c96679f4546a5da693ddb534b64', '200266', '����������ҩ���޹�˾', '������ҩƬ', 4.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ҩƬ', 'Ƭ��', '0.3g', '36', 'sqsyp', NULL),
  ('6e0ff7c60c6e4abeac9373a36e8899fd', '200267', '�����ºͳ�����ҩҵ���޹�˾', '��������', 0.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', '����', '10g:5mg', '1', 'dsms', NULL),
  ('6e90f5d6b51f4f28903c5e13a58cbcdc', '200268', '�㶫������ҩ���޹�˾', '/', 23.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���������', '������', '5g', '15', 'ypfkl,ybfkl', NULL),
  ('6ed9ed461c1a4b74912391c2457eae21', '200269', '������ҩ(����)���޹�˾', '��������', 1.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������', 'Ƭ��', '25mg', '100', 'ktpl,qtpl', NULL),
  ('6fe789f257994e1bae3199b484596aa0', '200270', '�Ϻ��񶫺���ҩҵ���޹�˾', '��ɽ�', 13.53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '����Һ', '5ml:1.0g', '12', 'ltl', NULL),
  ('6ff4a2a459a34b1f88a4cc77777a9648', '200271', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '��ŵ��', 11.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '�ض���׿', '����', '10mg', '1', 'delz', NULL),
  ('7087e11ce08548aa8197a7f0a83330ea', '200272', '�㶫����ҩҵ���޹�˾', '���������', 17.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���������', '˨��', '0.5g', '6', 'ldhpd,ldhbd', NULL),
  ('716b6cf33408448ca41a20a8e50aa30d', '200273', '������ҩ(����)���޹�˾', '����������ά��Ƭ', 2.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����������ά��Ƭ', 'Ƭ��', '25mg', '100', 'jysptwlp,gysptwlp', NULL),
  ('719ea6ea93e94eaea17835fa429f032b', '200274', '�㽭һ����ҩ�ɷ����޹�˾', '������', 19.94, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '����', '5mg', '36', 'ynpl', NULL),
  ('71d543e7dd524aae8f5b576505fa57b8', '200275', '�Ĵ�����ҩҵ�ɷ����޹�˾', '������ΤƬ', 2.22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ΤƬ', 'Ƭ��', '0.1g', '24', 'axlwp,exlwp', NULL),
  ('72171a6bb3a04fd8a7c5076322fd4262', '200276', '��������ͨҩҵ�������ι�˾', '����ɳ��', 2.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ɳ��', '����', '0.4g', '1', 'yfsx', NULL),
  ('72972e11db6c41ad945ad3d45b5d0a59', '200277', '����ͬ������ҩ���޹�˾', '������ὺ��', 28.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ὺ��', '����', '0.5g', '40', 'xlgbjn', NULL),
  ('72a266d54e5e4f5ebe47837ea6b030ac', '200278', '�人����������ҩҩҵ���޹�˾', 'ͪ������', 5.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͪ����', '����', '0.2g', '12', 'tkz', NULL),
  ('72e7844eae97404ab5fff33a99e8eb14', '200279', '�Ϻ��ִ���ɭ(����)ҩҵ���޹�˾', '����«��ע��Һ', 0.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����«��', 'ע��Һ', '2ml:60mg', '1', 'qklz,qkld', NULL),
  ('731eae09c63d40d78eda5620eef75cd8', '200280', '���ϰٲ���ҩ���޹�˾', 'ͷ������Ƭ', 5.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ������', 'Ƭ��', '0.25g', '24', 'tbld', NULL),
  ('7369bed2e64242d49c17bb8eebc90627', '200281', '�Ĵ�����ҩҵ�ɷ����޹�˾', '����ע��Һ', 1.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ע��Һ', 'ע��Һ', '2ml', '1', 'smzyy,cmzsy,cmzyy,smzsy', NULL),
  ('73b1dc51f66143c99bb85d42339de4f5', '200282', '�Ϻ���������ҩҵ���޹�˾', '��������', 1.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', '����', '10mg', '1', 'ftlm', NULL),
  ('73ea12afacd84cf098c054558b5122d6', '200283', '���Ͽ���ҩҵ���޹�˾', '0.9%�Ȼ���', 0.93, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '0.9%�Ȼ���', '����Һ', '100ml(��ƿ)', '1', '0.9%lhn', NULL),
  ('73f7360a9d404946af74451701456de1', '200284', '�人��������ҩҵ���޹�˾', '������', 1.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', '����Һ', '250ml:1.25g', '1', 'jxz', NULL),
  ('7403a26afc0d43cd835edbdf32c4ca25', '200285', '�Ϻ����ķ���ҩ���޹�˾', '���ط�', 31.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ŵ����', '���ͽ���', '0.25g', '10', 'fnbt', NULL),
  ('7447ffa30c4d4408b35265d5606e4c5d', '200286', '����ʡ������ҩ�ɷ����޹�˾', '޽��������', 6.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '޽��������', 'ˮ��', '6g', '10', 'hxzqw', NULL),
  ('7472990959574422a0e6073fe593ce77', '200287', '�����췽ҩҵ�ɷ����޹�˾', '�������', 7.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����˫��', '����Ƭ', '0.5g', '32', 'ejsg', NULL),
  ('74b02231f3e64abaa36cc0a31fc95d8a', '200288', '����ҩҵ�ɷ����޹�˾', '��/����֬����(C8-24)ע��Һ', 81.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��/����֬����(C8-24)', '����Һ', '250ml(20%)', '1', 'z/clzfr(c8-24),z/zlzfr(c8-24)', NULL),
  ('756b8b3211784943a1384ef8c24c0ea6', '200289', '�㽭��Ԫ��ҩ���޹�˾', '̩��', 1.09, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�޺�ù��', 'Ƭ��', '0.15g', '6', 'lgms,lhms', NULL),
  ('7578ce34534046f8b2da7ab29d13b1e4', '200290', '����ҩҵ�ɷ����޹�˾', '�����', 3.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����', '����Ƭ', '0.3g', '10', 'blf', NULL),
  ('757ba73b9a5b40409fd5648b70a31c88', '200291', '����������ҩ���޹�˾', '����ͨ����', 33.66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ͨ����', '����', '0.4g', '48', 'nxtjn', NULL),
  ('7634afa372764b959aea15e1e1c7b431', '200292', '����ҩ��������ҩ���޹�˾', '轾յػ���', 2.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '轾յػ���', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'qjdhw', NULL),
  ('76785f61dc3348de906fd6e72f223303', '200293', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '��������', 0.32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', '����', '0.5g', '1', 'abxl', NULL),
  ('769cae6d859d4aef980cc76eb759a694', '200294', '�Ĵ�����ҩҵ�ɷ����޹�˾', '������ע��Һ', 2.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '������ע��Һ', '����Һ', '100ml��5g(��ƿ)', '1', 'pttzyy,pttzsy', NULL),
  ('76d15eb3b7fa4bd8a033dc7476ae14cd', '200295', '�Ϻ��ƺ���ҩ�������ι�˾', '�Ȼ���', 4.52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�Ȼ���', '����Ƭ', '0.5g', '24', 'lhj', NULL),
  ('7733abc9a10c402cb433e4d2c502ff1c', '200296', '���ݰ���ɽ������ҩ���޹�˾', '�忪�����', 15.36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�忪�����', '������', '3g', '12', 'qklkl', NULL),
  ('776f4381510a416f87567e4d0aaa2a4c', '200297', '������ҩ�ɷ����޹�˾', 'ע����ͷ�������', 0.66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ�����', '����', '0.5g', '1', 'tbsw', NULL),
  ('777a66de1d854a288f500a5e2540a4af', '200298', '�������������ҩ���޹�˾', '����������ע��Һ18AA', 13.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����������(18AA)', '����Һ', '250ml:30g', '1', 'ffajs(18aa)', NULL),
  ('77ced6cdf88e4e1aac57cd948b91b92c', '200299', '���Ͽ���ҩҵ�ɷ����޹�˾', '����к����', 2.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����к����', 'ˮ��', '6g', '10', 'ldxgw', NULL),
  ('781f949b0cf74aa58b072a0551dc11f2', '200300', 'ɽ������ҩҵ���Źɷ����޹�˾', 'άA�����', 5.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'άA��', '����', '15g:3.75mg', '1', 'was', NULL),
  ('785bfdec61c347adaed1f9c470dfdfff', '200301', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '��ŵ����', 1.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ��߻��', '����', '0.75g', '1', 'tbfx', NULL),
  ('78b962622aa24e7c83e8584faefa481f', '200302', '����ҫ���ź�����ҩҩҵ�ɷ����޹�˾', '���������ն���', 0.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���������ն���', 'ע��Һ', '2ml:20mg', '1', 'slsxgen', NULL),
  ('78e321aca48344c49993b22679d53aca', '200303', '������ҩ����������һ��ҩ���޹�˾', '��', 1.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù����', '����', '1.0g', '1', 'lmsn', NULL),
  ('79c107fc0ac64c91ac4dd1c426548fc9', '200304', '�Ϻ��տ�ҩҵ���޹�˾', '��ȥ������', 6.13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ȥ������', 'Ƭ��', '50mg', '30', 'xqyds', NULL),
  ('7a679107a4b645938014f4a9c7b5713c', '200305', '�㽭��̫ҩҵ�ɷ����޹�˾', '������ͪ', 2.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������ͪ', 'Ƭ��', '50mg', '100', 'plpt', NULL),
  ('7b65916811354281b4a3adad9f49a596', '200306', '���ݰ���ɽ������ҩ���޹�˾', '��ݹ�м�', 0.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ݹ�м�', 'ע��Һ', '1ml:0.3mg', '1', 'dldj', NULL),
  ('7c0717abaea842838c18e50ac4a1cb5d', '200307', 'ʯҩ������ҩ���޹�˾', '��Ѫ��ע��Һ', 6.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��Ѫ��ע��Һ', 'ע��Һ', '5ml', '1', 'sxnzyy,sxnzsy', NULL),
  ('7c0f6d5dbcad4121aff8a2187e9af4cf', '200308', '���������ҩ�ɷ����޹�˾', '��', 0.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�������', 'ע��Һ', '1ml:5mg', '1', 'xsgy', NULL),
  ('7c177a1e82854d69868316e41478e6a8', '200309', '�Ϻ��ִ���ҩ�ɷ����޹�˾', '��Ȼ', 15.23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ƽ����Ƭ', '����Ƭ', '30mg', '6', 'xbdpksp', NULL),
  ('7d205d31529a4eca8e2919f18804c4e3', '200310', '����ҩҵ�������޹�˾', '���������', 9.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���������', '����', '0.3g(0.11g)', '40', 'jysbj,gysbj', NULL),
  ('7d4096abe3db4af9a8c1f03bfec13105', '200311', '�Ϻ��񶫺���ҩҵ���޹�˾', '��', 4.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�����ε�', 'ע��Һ', '5ml:50mg', '1', 'qand', NULL),
  ('7deae9b879cb49079cc8018e02b0896c', '200312', '�㽭����ҩҵ���޹�˾', '�Ȼ���', 0.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�Ȼ���', 'ע��Һ', '10ml:1.5g', '1', 'lhj', NULL),
  ('7dedadad3512487d937e9e383f543c50', '200313', 'ʯ��ׯ��ҩ���޹�˾', '��', 5.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ض���׿', 'Ƭ��', '30mg', '60', 'delz', NULL),
  ('7e52483bc4304e6ea37e8ece76d77eb4', '200314', '�Ĵ�������ҩ���޹�˾', '��ø', 2.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ø', 'Ƭ��', '��ø0.3g:θ����ø13mg', '100', 'dm', NULL),
  ('7e6d914cf1ee441dac78054e60c2f9f8', '200315', 'ɽ������ҩҵ���޹�˾', '�������', 9.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������', 'Ƭ��', '5mg', '40', 'fglq', NULL),
  ('7e6f21748f5d4688960553dc6d42fe0a', '200316', '��������ҽҩ�ɷ����޹�˾', '��Ƣ�泦��', 11.13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��Ƣ�泦��', 'ˮ����', '90g', '1', 'bpycw', NULL),
  ('7efd9e96bd6b424ab180f930a683fb34', '200317', '���������ҩ�ɷ����޹�˾', '��', 0.22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�Ŷ������þ', 'ע��Һ', '10ml:0.85g:0.114g:42mg', '1', 'mdasjm', NULL),
  ('7f216de2f4af450d9a39b67907c5aec6', '200318', '���������ҩ�����ţ����޹�˾', '����Τ��', 2.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Τ��', 'Ƭ��', '0.1g', '20', 'lbwl', NULL),
  ('7fd4aed67c3243529ce270a2a363583b', '200319', '��������ҽҩ�ɷ����޹�˾', '����θ̩����', 14.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����θ̩����', '������', '2.5g�������ͣ�', '10', 'sjwtkl', NULL),
  ('7fdd90eab1ac4055b95380e678b65c30', '200320', '����ҩ���ʺ���ҩ���޹�˾', '轾յػ���', 3.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '轾յػ���', 'ˮ����', '6g', '10', 'qjdhw', NULL),
  ('7ffa850b596b4334ad0d413002226c67', '200321', '�����������ҽҩ�ɷ����޹�˾', '������п�ȵ���', 12.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������п�ȵ���', 'ע��Һ', '10ml:400IU', '1', 'jdbxyds', NULL),
  ('80160429d3a34e36805a2592b31e8883', '200322', '�Ϻ�������ҩ���޹�˾', '�������', 15.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������', 'Ƭ��', '0.25g', '100', 'zxdb', NULL),
  ('811874538aab425a8bf65e209888a71f', '200323', '���ո���ҩҵ�������ι�˾', '��ĸ�ݸ�', 6.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ĸ�ݸ�', '����', '250g', '1', 'ymcg', NULL),
  ('81286286ef2a42ab9d557deecca0366b', '200324', '��������ҩҵ�ɷ����޹�˾', '����ͪ', 9.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ͪ', 'Ƭ��', '0.2g', '24', 'adt', NULL),
  ('815082459c1a43b5a6f00dd9d4222b0b', '200325', '����̫��ҩҵ�ɷ����޹�˾', '�������Ȼ���', 1.26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '�������Ȼ���', '����Һ', '500ml', '1', 'pttlhn', NULL),
  ('8184e03103ac4ed2a9f6850db5cde399', '200326', '����ҩҵ�������޹�˾ԭ(����ҩҵ���޹�˾)', 'Ԫ̹', 19.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ື�ɢƬ', '��ɢƬ', '5mg', '40', 'glbqfsp,glpqfsp', NULL),
  ('82678db3ce444b9a9d2812a65bd5d929', '200327', '���ݰ���ɽ������ҩ���޹�˾', '������ͪ', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������ͪ', 'ע��Һ', '10ml:35mg', '1', 'plpt', NULL),
  ('826fcc8916f840c5a1d35e85832d5612', '200328', '�ɶ�����ҩҵ�������ι�˾', '��Ī���ֽ���', 2.53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī����', '����', '0.125g', '50', 'amxl,emxl', NULL),
  ('8275157efe7b47a7b635f3f573c75075', '200329', '����ҩҵ�ɷ����޹�˾', '��ù�����', 0.54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù��', '����', '10g:0.1g(1%)', '1', 'hms,gms', NULL),
  ('8291628c992f46be881786de8cf342ee', '200330', '�Ϻ�ͨ��ҩҵ�ɷ����޹�˾', '����غͪע��Һ', 0.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����غͪ', 'ע��Һ', '1ml:25mg', '1', 'bsgt', NULL),
  ('83ca759a00e0479c8b303f0b83dcd936', '200331', '����ҩҵ�ɷ����޹�˾', '��ù��', 0.62, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù��', '����', '10g:0.3g(3%)', '1', 'kmz', NULL),
  ('8401e81d57e744adb455003d1c4a0293', '200332', '�����л���ҩҵ�������ι�˾', '�����Ƭ', 6.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����Ƭ', 'Ƭ��', '0.25g', '100', 'dlcp', NULL),
  ('853f86f2e9e548cb99c564d12cfd93ed', '200333', '��������ҩҵ�ɷ����޹�˾', '�Ŵ���������Ƭ', 17.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '����Ƭ', '1.5mg', '30', 'ydpa', NULL),
  ('8540fbc178594e95906e38780da970a4', '200334', '���ҩҵ������֣�ɷ����޹�˾', '��', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���ע����ˮ', 'ע��Һ', '5ml', '1', 'mjzyys,mjzsys', NULL),
  ('855a471edd20484c996f821595d1c064', '200335', '����ҩ��������ҩ���޹�˾', '��Ƣ��', 3.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��Ƣ��', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'gpw', NULL),
  ('8579112e67534c49bc3881d984844b14', '200336', '�ɶ�������ҩ���޹�˾', '����', 12.47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ù��', '��ɢƬ', '0.125g', '12', 'klms', NULL),
  ('85832d2699734e398118c86c90fc9e41', '200337', '������ҩҵ�ɷ����޹�˾', '�����', 28.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�ͷ��Ӹ��ظ�', 'ע��Һ', '0.6ml:6000AXaIU', '1', 'dfzgsg', NULL),
  ('8588889818184c5b84c7ae2dccc288f3', '200338', '�������ҩҵ���Źɷ����޹�˾��������ҩ��', '�ڼ��׷�Ƭ', 26.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ڼ��׷�Ƭ', 'Ƭ��', '0.5g', '24', 'wjbfp', NULL),
  ('85aa0dec365b4f248abfb631761486e0', '200339', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '����', 1.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ�����', '����', '2.0g', '1', 'tbsw', NULL),
  ('ea4d687bdc35455dbb2cb891893397d1', '200340', '�Ǳ�ҩҵ���Źɷ����޹�˾', 'Īɳ����', 17.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'Īɳ����', 'Ƭ��', '5mg', '24', 'msbl', NULL),
  ('ea64ed5a06354f2a8884e93a65d79cde', '200341', '����������ҩ���Źɷ����޹�˾', 'ע����Ѫ˨ͨ', 33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ע����Ѫ˨ͨ', '���ɷ����', '0.15g', '1', 'zsyxst,zyyxst', NULL),
  ('ea9d86cd77e44763b20a0c8f39cb3f7e', '200342', '������������ҩ���޹�˾', '����ɳ���Ȼ���', 0.84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����ɳ���Ȼ���', '����Һ', '100ml:0.2g', '1', 'hbsxlhn', NULL),
  ('eab3812405074c899ef53f207c955683', '200343', '�㽭���念ԣ��Ȼҩ�����޹�˾', '����������', 4.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������', '������', '3g', '20', 'blgkl', NULL),
  ('eb498b7eb0254a109ca8cfe3a8477d6b', '200344', '�˲�����ҩҵ���޹�˾', '����ù��', 2.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ù��', '��ɢƬ', '0.25g', '6', 'ajms,ejms,aqms,eqms', NULL),
  ('eb9128117118467d88446139bde1542a', '200345', '�㽭��������ҩ�ɷ����޹�˾', 'ǰ�п�', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '���ְ�����', '����', '0.375g', '120', 'plajn,pyajn', NULL),
  ('eba67f8a507b4ea992371e874bb7a463', '200346', '���������ҩ�����ţ����޹�˾', '����ù��', 3.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ù��', 'Ƭ��', '0.125g', '12', 'ajms,ejms,aqms,eqms', NULL),
  ('ec18ce5788264824b8896c14fa3b8bc2', '200347', '�Ϻ��񶫺���ҩҵ���޹�˾', '��', 6.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��øQ10', '����', '10mg', '60', 'fmq10', NULL),
  ('ec19b738a1b64f7ba253c4b0c89ddef0', '200348', '���������ҩ�ɷ����޹�˾', '��غͪ', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��غͪ', 'Ƭ��', '5mg', '100', 'jgt', NULL),
  ('ed4f138d412a4283b802e387513b324a', '200349', '�Ĵ�����ҩҵ�ɷ����޹�˾', '���ƿ���', 2.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ƿ���', '������', '4g', '10', 'yhkl', NULL),
  ('edcb314a41d24d608514eec9ae3c0ae4', '200350', '�ӱ����ҩҵ�ɷ����޹�˾', '��˾ƥ�ֳ���Ƭ', 0.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '��˾ƥ��', '����Ƭ', '25mg', '100', 'aspl,espl,asyl,esyl', NULL),
  ('edfe3f293efe4c6b87cf831770583c86', '200351', '�����ϲ�������ҩ��', '����������', 5.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������', '������', '10g', '24', 'blgkl', NULL),
  ('b1aafb82f3594c7da158d501a7bf7265', '200572', '����������ҩ�������ι�˾', 'Ũ�Ȼ���ע��Һ', 0.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'Ũ�Ȼ���ע��Һ', 'ע��Һ', '10ml', '5', 'nlhnzyy,nlhnzsy', NULL),
  ('b20e96632ed54c02b038216320e30efe', '200573', '��������Ϫ��ҩ���޹�˾', '����θʹ����', 20.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����θʹ����', '������', '2.5g(������)', '12', 'qzwtkl', NULL),
  ('b32d10f7a49a4012a9319b6eefbf82e8', '200574', '����ҩҵ�ɷ����޹�˾', '�����', 4.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����', '����Ƭ', '0.1g', '20', 'acj', NULL),
  ('b36893914bd744ff9801f670d271afdb', '200575', '����˫��ҩҵ�ɷ����޹�˾', '����', 13.13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '��ɢƬ', '10mg', '6', 'lltd', NULL),
  ('b3d9abd4d89446f5abd484b2de52a874', '200576', '��ɽ����ҩҵA', '���̽ⶾƬ', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���̽ⶾƬ', 'Ƭ��', '0.52g*12s*2�� ��Ĥ��', '1', 'yqjdp,yqxdp', NULL),
  ('b3f0d8f877ee4ae6b4cd3b30355b5de2', '200577', '��������ҩҵ�ɷ����޹�˾', 'ע���ø����', 9.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�����', '����', '0.1g', '1', 'ggs', NULL),
  ('b41ca64433f048e19c3ea784abdd10c1', '200578', '��³��ҩ���޹�˾', '�����Ƭ', 4.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�����', 'Ƭ��', '0.1g', '100', 'sbl', NULL),
  ('b42ac170d1624e38b6a097ea19b462de', '200579', '����ҩҵ�������޹�˾', '��ù��', 8.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ù��', '����Ƭ', '0.125g', '100', 'hms,gms', NULL),
  ('b464078d5d704b67884d5698130d96d4', '200580', '����������ҩ�ɷ����޹�˾', '������', 1.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '�ڷ�Һ', '10ml', '6', 'xzl', NULL),
  ('b49bc84560614bc5af94f4b4eec87837', '200581', '����������ҩ���޹�˾', '������ң��', 4.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ң��', 'ˮ��', '6g', '10', 'dzxyw', NULL),
  ('b54327096b0d4a8588fc0f1a0b3740bd', '200582', '�ӱ����ҩҵ�ɷ����޹�˾', '�������࿨��ע��Һ', 0.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���࿨��', 'ע��Һ', '20ml:0.4g', '1', 'ldky,ldqy', NULL),
  ('b5c8bbaf32724fb098cb8b8dc01993ba', '200583', '�ɶ���̨ɽ��ҩ���޹�˾', 'ע�����������߿���', 26.47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���߿���', '����', '75mg', '1', 'lpky,lpqy', NULL),
  ('b61b880916274ea683dff56dbf212e3b', '200584', '�Ϻ�����ҩҵ�������޹�˾', '����ע��Һ', 0.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ע��Һ', 'ע��Һ', '2ml', '1', 'dszyy,dszsy,dczyy,dczsy', NULL),
  ('b69db0f329514388bae6d0c143e01135', '200585', '�㽭����ҩҵ���޹�˾', '/', 12.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '������', '����', '25mg', '1', 'dky,zky,zqy,dqy', NULL),
  ('b751154e058e4529886ab955cfc78b07', '200586', '������ҩ�ɷ����޹�˾', 'ע����ͷ������', 0.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ������', '����', '0.5g', '1', 'tbld', NULL),
  ('90cfd057c5fc46b2a43a9ac90da47f2b', '200587', '����̫��ҩҵ�ɷ����޹�˾', '5%������', 1.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '5%������', '����Һ', '500ml', '1', '5%ptt', NULL),
  ('90ff35714f3142b0ad758139cd611c83', '200588', '����̫����ҩ���޹�˾', '���������', 8.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���������', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '192', 'elzcw', NULL),
  ('9176a950542346ecab0cfdb58b9e04bc', '200589', '���ϰ�ҩ���Źɷ����޹�˾', '޽����������', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '޽����������', '����', '0.3g', '24', 'hxzqjn', NULL),
  ('918a7ce568aa4d1997294882f46ccfb1', '200590', '�ٲ���ҩ���Ͳ������޹�˾', '�̴�˨', 14.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�̴�˨', '˨��', '2g', '5', 'zcs', NULL),
  ('91b72a742be5431886f83ad674cd38a7', '200591', '�Ϻ��̷���ҩ���޹�˾', '��Ͱ�', 0.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��Ͱ�', 'ע��Һ', '2ml:20mg', '1', 'dba', NULL),
  ('928133006e084036870a35e844828c39', '200592', '�ÿ�ҩҵ�������޹�˾', '������', 1.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������', '����', '0.2g', '1', 'yhn', NULL),
  ('92a20865d989406ab927355ee686e2b0', '200593', '��������ҩҵ���޹�˾', '��ʹ������', 20.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ʹ������', '����', '0.4g', '27', 'ytdjn', NULL),
  ('92c334bb3c994f84907681fdc53c2e18', '200594', '�㽭�����ҩ�ɷ����޹�˾', '������', 31.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ͪ', '����', '50mg', '20', 'hbt,htt', NULL),
  ('935ca3063bd24a02b091572257e8d137', '200595', '��ɽ��ԭ��ҩ���޹�˾', '��ø', 4.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ø', '����', '1WIU', '1', 'sjm,njm', NULL),
  ('935f8bedb4844454aa0f2224a59f34b9', '200596', '�㽭��̫ҩҵ�ɷ����޹�˾', '����ϣ', 1.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�޺�ù��', '����', '50mg', '10', 'lgms,lhms', NULL),
  ('9390406eb3be4f3cba22b92c92a7c768', '200597', '�������Ϻ���ҩҵ�ɷ����޹�˾', '��', 19.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ά����D2', 'ע��Һ', '1ml:5mg(20WIU)', '1', 'wssd2', NULL),
  ('93e9feb76297423984d4ae9a7c81de44', '200598', 'ɽ���յ�ҩҵ�ɷ����޹�˾', '�װ�����', 2.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�װ�����', '����', '5mg', '1', 'jadl', NULL),
  ('9408033439aa4bd0b3bc05e2d337e1e5', '200599', '���ӽ�ҩҵ���Ž�����ҩ�ɷ����޹�˾', '��', 7.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'θ�տ���', '������', '5g(������)', '3', 'wskl', NULL),
  ('94548226629a405f82ae0d364bf57889', '200600', '��������ҩҵ���޹�˾', '��³����', 0.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��³����', 'ע��Һ', '10ml:0.1g', '1', 'plky,plqy', NULL),
  ('945aee1f58ff4efba6d50723d49555f0', '200601', '���ݰ���ɽ������ҩ�ɷ����޹�˾', '˾�嶨', 6.42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ��߻����', 'Ƭ��', '0.25g', '6', 'tbfxz', NULL),
  ('945e9eeff215496294985ca6eec229f7', '200602', '�Ĵ�������ҩ���޹�˾', '��ң��', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ң��', 'ˮ��', '6g', '20', 'xyw', NULL),
  ('94cada274bfd4964a774a97ce00c147f', '200603', '�㽭���ҩҵ�ɷ����޹�˾', '�����ŵ��', 25.58, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Ҷ����', '����', '63mg(�൱������Ҷ��ȡ��16mg)', '60', 'yxxdw,yxydw', NULL),
  ('94f71020e25f4ef1beab33b0dcad4c55', '200604', '����ҩҵ�ɷ����޹�˾', '�������Ȼ���ע��Һ', 0.92, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', '����Һ', '250ml:0.5g', '1', 'jxz', NULL),
  ('95b521d957e646ac80b2d748b48f818f', '200605', '�����췽ҩҵ�ɷ����޹�˾', '����˾͡', 0.93, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����˾͡', 'ע��Һ', '2ml:10mg', '1', 'btst', NULL),
  ('95c199ba2266491aa0926b59485d40bc', '200606', 'ɽ������ҩҵ�ɷ����޹�˾', '������͡', 1.66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������͡', 'Ƭ��', '5mg', '20', 'xftt', NULL),
  ('95e8a59670b94abcaf59fead537dd215', '200607', '�Ϻ�����ҩҵ�������޹�˾', '��������ɽ����', 10.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������ɽ����', '����Ƭ', '40mg', '14', 'cxsyslz,sxsyslz,dxsyslz', NULL),
  ('960a7e3b940e409985a7cd910523da92', '200608', '�˲��˸�ҩҵ�������ι�˾', 'ͷ�߰��п���', 1.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ�߰���', '������', '0.125g', '12', 'tbab', NULL),
  ('96c554ac17264ffd97ddd2d4b5f2d4ce', '200609', '�����ϲ�������ҩ��', '������(����)', 5.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������(����)', '�ڷ�Һ', '10ml�������ͣ�', '10', 'smy(dc),smy(ds)', NULL),
  ('9748817e24f14599b1aa63cb9b0aa2e7', '200610', '��������ά������Ƽ����޹�˾', 'Ѫ֬������', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'Ѫ֬������', '����', '0.3g', '24', 'xzkjn', NULL),
  ('97bc3913d34e41d2a6c95f6c8fc51ffa', '200611', '���춫��ҩҵ�ɷ����޹�˾', '�����������', 12.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����������', '������', '2g', '12', 'hlsqkl', NULL),
  ('9816fef12b144f188d86bf00af2f33af', '200612', 'ɽ���Ͳ��´���ҩ���޹�˾', '����', 1.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ù��', 'Ƭ��', '0.25g', '6', 'ajms,ejms,aqms,eqms', NULL),
  ('988e5274fb6c4989878cd84f11883bb6', '200613', '����ҩҵ�ɷ����޹�˾', '����ù��������ע��Һ', 0.67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ù��������', 'ע��Һ', '2ml:0.3g', '1', 'klmslsz', NULL),
  ('98e0d02bf7334c138ee88b736445bff1', '200614', '���ϰ��꿵��ҩҵ���޹�˾', 'ľ��˳����', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ľ��˳����', 'ˮ��', '6g(3g/50)', '10', 'mxsqw', NULL),
  ('997f35834c0a469aab4185872a686d69', '200615', '���ӽ�ҩҵ���Ž�����ҩ�ɷ����޹�˾', '��', 7.41, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'θ�տ���', '������', '15g', '3', 'wskl', NULL),
  ('99b59540f851408f97718282a0d151c3', '200616', '������Զҩҵ���޹�˾', '��', 1.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������������', 'Ƭ��', '0.3g', '100', 'dyxajf', NULL),
  ('e2a06dd4750841d2b3cb6309b0b3f890', '200750', '����Ǳ����ҩ�ɷ����޹�˾', '������Ŀ����Һ', 0.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������Ŀ����Һ', '����Һ', '8ml', '1', 'zzmmdyy', NULL),
  ('e3b9754a7968433fa398247bbec8f9dc', '200751', '�����췽ҩҵ�ɷ����޹�˾', '�������', 3.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������˫�һ���Ƭ', '����Ƭ', '0.5g', '16', 'ysejsghsp', NULL),
  ('e3c877a2627f446aa2a52fa5e6df5138', '200752', '�����������ҽҩ�ɷ����޹�˾', '������', 44.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������ͪ��ɢƬ', '��ɢƬ', '15mg', '30', 'yspgltfsp,ysbgltfsp', NULL),
  ('e3e325fc2b26496586c862f02303408a', '200753', '��կ����Ȼҩҵ�����������ι�˾', '��ζǼ�����', 10.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ζǼ�����', '������', '15g', '20', 'jwqhkl', NULL),
  ('e46bcca9f8c340d69cbd79a5a32bae9b', '200754', '����ҫ���������޹�˾', '�������', 1.17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�������', 'ע��Һ', '10ml:0.25g', '1', 'fsmd,fnmd', NULL),
  ('e4da056d0f984f678e7b6389f8968b5c', '200755', '������ҩ����������һ��ҩ���޹�˾', '��', 0.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����鰷', 'Ƭ��', '0.1g', '24', 'jgwa', NULL),
  ('e5a30d71da984f998b8b3c18c852fc44', '200756', 'ɽ����³��ҩ���޹�˾', '���ȿ���', 0.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���ȿ���', 'ע��Һ', '5ml:25mg', '1', 'bbqy,bbky', NULL),
  ('e5bb2e93211a48429687dd7d596c1306', '200757', '�����û�ʿҩҵ(����)�������ι�˾', '�����Ƭ', 15.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����Ƭ', 'Ƭ��', '0.34g', '60', 'rpxp', NULL),
  ('e64903a37b4748acb6cc09f34dfb589d', '200758', '�Ϻ���������ҩҵ���޹�˾', '��Ŀ�ػ���', 3.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��Ŀ�ػ���', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'mmdhw', NULL),
  ('e683f49dd38540a9aa43d938923fc880', '200759', '�����찲ҩҵ�ɷ����޹�˾', '����������ͪ��ɢƬ', 41.21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������ͪ��ɢƬ', '��ɢƬ', '30mg', '14', 'yspgltfsp,ysbgltfsp', NULL),
  ('e70a326038a8455484db3c8ff847ab42', '200760', '�ɶ��ذ���ҩ�������޹�˾', '�ذ���Ѫ������', 8.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ذ���Ѫ������', '����', '������������100mg(�൱������������Ԫ35mg)', '20', 'daxxkjn', NULL),
  ('e726466bacdb481894ea1f3525e3dc4f', '200761', 'ʯ��ׯ��ҩ���޹�˾', '���һ����40�Ȼ���', 2.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '���һ����40�Ȼ���', '����Һ', '500ml:30g:4.5g', '1', 'qyjdf40lhn', NULL),
  ('e77d0cf047eb419f84293ebf92c0c30c', '200762', '������һ����ҩ���޹�˾', '������������', 5.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������������', '����', '0.45g', '36', 'xyldjn', NULL),
  ('e7d62445698d4d72be74f8330fe6ce22', '200763', '��������ҩҵ���޹�˾', '��������ڷ�Һ', 23.64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������ڷ�Һ', '�ڷ�Һ', '10ml', '12', 'qgldkfy', NULL),
  ('e81c7d4bd28140eebada9e405ed6b260', '200764', '������¤��ҩҵ���޹�˾', '���ְ�Ƭ', 3.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ְ�Ƭ', 'Ƭ��', '0.5g', '60', 'plap,pyap', NULL),
  ('e8a2459b0c914879a425e80a17cf88c8', '200765', 'ɽ����Ԫʢ����ҩ���޹�˾', '��ζ�ػ���', 3.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ζ�ػ���', '������', '9g', '10', 'lwdhw', NULL),
  ('e8b25eb142194adb9b6d515dff856d53', '200766', '��������ҩҵ���޹�˾', '��', 0.09, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ɽݹ�м�', 'ע��Һ', '1ml:10mg', '1', 'sldj', NULL),
  ('e8fb33e4b52b4d5d953ad28964dcff70', '200767', '��������ҽҩ�������޹�˾������ҩ��', '��������ͪע��Һ', 1.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '����ͪ', 'ע��Һ', '1ml:0.4mg', '1', 'nlt', NULL),
  ('e9d253ee9e254d008e13358d5a549bd6', '200768', '�Ϻ���ɽҩҵ���޹�˾', '�强��', 1.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�强��', 'Ƭ��', '8mg', '100', 'xjx', NULL),
  ('e9ea9776d0174ea59b7ab0ce57a0944c', '200769', 'ɽ��������ҩ���޹�˾', '���Ŀ���(������)', 27.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���Ŀ���', '������', '5g(������)', '9', 'wxkl', NULL),
  ('f33f36860f614464b4db2ef762aafb21', '200770', '��������ҩ���޹�˾', '������Ƭ', 10.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������Ƭ', 'Ƭ��', '0.32g', '36', 'kbdp', NULL),
  ('f3df74760e15482cbbf16c07e9bcd20d', '200771', '�����������ҽҩ�ɷ����޹�˾', '������', 17.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�;�����п�ȵ���', 'ע��Һ', '10ml:400IU', '1', 'djdbxyds', NULL),
  ('f7bc2fc97daf45caa5a33f4c295830a5', '200772', '��������ҩ���޹�˾', '������', 19.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���Ӵ�Ī', 'ע��Һ', '10ml', '1', 'yxdm', NULL),
  ('bce6817b1a9c4568a014cd4b3b487df9', '200773', '���Ͽ���ҩҵ���޹�˾', '�������Ȼ���', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '�������Ȼ���', '����Һ', '100ml(��ƿ)', '1', 'pttlhn', NULL),
  ('bfdaeabbd76e47c8825b9789f4ec3573', '200774', '����������ҩ���޹�˾', '������Τע��Һ', 7.09, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������Τ', 'ע��Һ', '5ml:0.15g', '1', 'gxlw', NULL),
  ('c23fdfc4910c413e8545a3b476c36637', '200775', '���ҩҵ������֣�ɷ����޹�˾', '��', 2.39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������', '��Һ��', '500ml', '1', 'gyhq', NULL),
  ('c5e7ec3e5db44d1db44313d96d002f05', '200776', '��������ҩҵ�ɷ����޹�˾', '����к�ν���', 26.17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����к�ν���', '����', '0.25g', '48', 'ldxgjn', NULL),
  ('ca0b0646371944d2a0261df2d521d76c', '200777', '�����ϲ�ɣ����ҩ��', '������ĸ����', 22.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ĸ����', '����', '0.28g', '36', 'bzymjn', NULL),
  ('cd1913df11f4491bbebe654a44ca4131', '200778', '���ϻ���ɭҽҩ���＼�����޹�˾', '��ɳ', 2.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�޺�ù��', '��ɢƬ', '0.15g', '8', 'lgms,lhms', NULL),
  ('d3119280d78d44729b74ce4acceaa67b', '200779', '��嵤��ҩҵ���޹�˾', '���̰ܶ���', 3.42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���̰ܶ���', 'ˮ��', '9g', '6', 'lqbdw', NULL),
  ('d63f204d290946e88d90201965ea36ff', '200780', '����ҽ��ҩҵ�������ι�˾', '������������Ƭ', 1.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������������', 'Ƭ��', '��������0.245g/������þ0.105g/����������0.0026ml', '100', 'ffqyhl', NULL),
  ('d747ac7618d94c06b4ecd47668fa20c5', '200781', '���Ǻ�˹��ҩ���޹�˾', '���׵���', 3.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���׵���', '����', '0.5g', '1', 'bldj', NULL),
  ('d9b5d1f5cae347d49b13f7799f35874a', '200782', '����ҩҵ�ɷ����޹�˾', '������', 17.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', 'Ƭ��', '5mg', '1000', 'pns', NULL),
  ('dc8a290c0b9a449f8426f2a969cee35d', '200783', '³�ϱ�����ҩ���޹�˾', '³�ϱ���', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '��������ɳ�ڷ�ɢƬ', '��ɢƬ', '��0.15+0.125��', '12', 'fflzszfsp', NULL),
  ('e108cc9b0b8b4ce2a14fc46b0377d88a', '200784', '�麣�����������ﻯѧ��ҩ��', '���ᰱ������ɢƬ', 10.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '��ɢƬ', '30mg', '30', 'axs', NULL),
  ('e5e2c073e115443cb7056caf6cc0f478', '200785', '�����н�����ҩ�������ι�˾', '��', 3.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '��ĸ�ݸ�', '����', '125g', '1', 'ymcg', NULL),
  ('e7270059f0f24bddb9f3781fa76eb183', '200786', '��������ͨҩҵ�������ι�˾', '�⻯�ɵ���', 8.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�⻯�ɵ���', '����', '10g:10mg', '1', 'qhkds', NULL),
  ('ea480b446e9d49e9ab8aa8bcda11aca0', '200787', 'ɽ������ҩҵ���޹�˾', '������', 31.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������������ɢƬ', '��ɢƬ', '5mg', '36', 'mlsynplfsp', NULL),
  ('36128e67f5d24145a5c7f67b434429a1', '200788', '����ǧ��ҩҵ�ɷ����޹�˾', '����ǧ��Ƭ', 23.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ǧ��Ƭ', 'Ƭ��', '����', '144', 'fkqjp', NULL),
  ('09ba295471b7453e92443155b1ac77b5', '200789', '�Ϻ�����ҩ�����޹�˾', '��', 16.97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�װ�����', 'Ƭ��', '2.5mg', '100', 'jadl', NULL),
  ('8c1d809fa27a4d6e97cfa2a0181e81f4', '200790', 'ɽ����³��ҩ���޹�˾', '���ע����ˮ', 1.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '���ע����ˮ', '����Һ', '500ml(��ƿ)', '1', 'mjzyys,mjzsys', NULL),
  ('a502856ca0cf4f14bb871ad3ec9f56b3', '200791', '���ϸ�ɭҩҵ���޹�˾', 'ɭ��', 31.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ù�ػ���Ƭ', '����Ƭ', '0.5g', '6', 'klmshsp', NULL),
  ('c073cc82860e458e9c5cdb18f9fa9aac', '200835', '������ҩ�ɷ����޹�˾', 'ע���ø����', 16.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�����', '����', '0.2g', '1', 'ggs', NULL),
  ('c09cf270036d43d99aca9659eae4dfc8', '200836', '³�Ϻ�����ҩ���޹�˾', '���ٻƿ���', 19.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ٻƿ���', '������', '3g', '10', 'yzhkl', NULL),
  ('c0a0d01fa68b4d86ae887fc991c3cc55', '200837', '�Ĵ�����ҩҵ�ɷ����޹�˾', '��������', 1.17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', '���ܽ���', '20mg', '14', 'amlz', NULL),
  ('c0ac174764d84c4484b15aad0d727d6f', '200838', '������ҩ�ӱ�����ҩҵ�������ι�˾', 'ͷ�߰���', 2.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ�߰���', 'Ƭ��', '0.25g', '24', 'tbab', NULL),
  ('c16993becae7492b99c187dd8118bab4', '200839', 'ʥ���żҿڣ�ҩҵ���޹�˾', '���ּ�', 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī����/����ά���', '��ɢƬ', '0.1875g(2:1)', '12', 'emxl/klwsj,amxl/klwsj', NULL),
  ('c19c1db5ac0c4fe0a832f9daadda76b8', '200840', 'ɽ����³��ҩ���޹�˾', '������ɳ��', 1.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������ɳ��', '����Һ', '100ml:0.3g', '1', 'zyfsx', NULL),
  ('c1e77e369dcf4e5fa90c89f2a38d9e7a', '200841', '��ʿ����ҩ���Źɷ����޹�˾', '޽����������', 8.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '޽����������', '����', '2.6g', '9', 'hxzqdw', NULL),
  ('c20d1ecfbaf84f58b9225061abee134c', '200842', '���ϻ���ҩҵ�������ι�˾', '������', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '������', 'ˮ��', '9g', '10', 'ssw', NULL),
  ('c2663f7982c04bf38d6744caca1c72c3', '200843', '�Ǳ�ҩҵ���Źɷ����޹�˾', '�컨ע��Һ', 8.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�컨ע��Һ', 'ע��Һ', '20ml', '1', 'hhzsy,ghzsy,hhzyy,ghzyy', NULL),
  ('c2c2d7cfe1d34ad28e33ca64b2ad6fb4', '200844', '�˲�����ҩҵ���޹�˾', '������͡Ƭ', 0.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������͡Ƭ', 'Ƭ��', '10mg', '10', 'xfttp', NULL),
  ('c2f83a037abd4a75800deb110e5556e3', '200845', '�Ϻ�����ƺ���ҩ���޹�˾�������Ϻ�����ҩ', '������Ƭ', 2.83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������Ƭ', 'Ƭ��', '100mg', '100', 'yyjp', NULL),
  ('c36b2db1be5c464eb2404b385c12ddeb', '200846', '��������ͨҩҵ�������ι�˾', '?', 28.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', '����', '60mg', '1', 'ptlz', NULL),
  ('c3bc3f73fcff4b0c89f3767e33cb684a', '200847', '������ҩ���޹�˾', '֪��', 2.29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ��߻��', '����', '1.5g', '1', 'tbfx', NULL),
  ('c3bcb00fa4084b6f86eed56b2fca12b2', '200848', '֣������ҩ���޹�˾', '�������', 3.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������', 'Ƭ��', '2mg', '14', 'tlzq', NULL),
  ('b4a798240cc7475ea179c9b9ff3fdc0f', '200792', '������¹����ҩ�ɷ����޹�˾', '����к����', 3.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����к����', '������', '6g', '10', 'ldxgw', NULL),
  ('926265d70b4345daadf3ff2ac7e59ef0', '200793', 'ͨ������ҩҵ�ɷ����޹�˾', '������30R(��о)', 46.22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '30/70����������ȵ���', 'ע��Һ', '3ml:300IU', '1', '30/70hgczryds,30/70hhzzryds,30/70hgzzryds,30/70hhczryds', NULL),
  ('6a17ce71523e433799ee8f9f1ad0ba93', '200794', '�ɶ�������ҩ���޹�˾', '����Ѫ��������', 25.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Ѫ��������', '����', '0.5g', '30', 'slxmkjn', NULL),
  ('f1136433271645f68dd52ef2a8bd002e', '200795', '�˲�����ҩҵ���޹�˾', '������ຽ���', 2.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ຽ���', '����', '5mg', '30', 'glbqjn,glpqjn', NULL),
  ('bc5963c6aebd4644922a7d14dded8056', '200796', '������ʥ̩ҩҵ���޹�˾', '�忪��Ƭ', 23.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�忪��Ƭ', 'Ƭ��', '0.5g', '36', 'qklp', NULL),
  ('d66e3c9d6bbd4873afd595e6f2aecee8', '200797', 'ɽ������ҩҵ�ɷ����޹�˾', '��������', 1.13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ù��', '������', '0.25g', '2', 'ajms,ejms,aqms,eqms', NULL),
  ('ff7cf4efcfda4813b10516f189c71791', '200798', '�Ĵ���ҽ����ҩ���޹�˾', '�޺�ù��', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�޺�ù��', '��ɢƬ', '50mg', '12', 'lgms,lhms', NULL),
  ('ffb4e018b4c04b59b32af607eb26b60c', '200799', '���ϰ�ҩ���Źɷ����޹�˾', '��������Ƭ', 0.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������Ƭ', 'Ƭ��', '�൱��ԭ��ҩ0.655g', '36', 'hlsqp', NULL),
  ('ffdb605748164b59af0e508e1e5ae2bd', '200800', 'ɽ���ֻ�ҽҩ�Ƽ��ɷ����޹�˾', '�ٺ���', 3.31, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ٺ���', '������', '6g', '10', 'jgw,jhw', NULL),
  ('5d7f597675c848fa83bc7d23b051930b', '200801', '����ҽ��ҩҵ�������ι�˾', '����������Ƭ', 1.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������', 'Ƭ��', '5mg', '100', 'eybq', NULL),
  ('5fb313814f434a73b36bf02582f32bdf', '200802', '̫���������츢����ҩ�����޹�˾', '��֧�ǽ�', 9.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��֧�ǽ�', '�ǽ���', '200ml', '1', 'jztj', NULL),
  ('616cfd4611404dd0b61fcd572fbf798b', '200803', '�㶫�������ҩ���޹�˾', '��ʯ����', 11.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ʯ����', '������', '20g', '10', 'pskl,pdkl', NULL),
  ('637afbcae68147669d9b505c94a5cb12', '200804', '������ʱҩҵ�ɷ����޹�˾', '������', 4.33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'bhw', NULL),
  ('67d7b863da7d40348220e68fb8b925bd', '200805', '����̫��ҩҵ�ɷ����޹�˾', '0.9%�Ȼ���', 0.68, NULL, NULL, '2014-04-01 00:00:00', '1', NULL, NULL, NULL, NULL, '00401', NULL, '1', NULL, '2014-04-02 00:00:00', NULL, '2', NULL, NULL, NULL, 'ƿ', '0.9%�Ȼ���', '����Һ', '100ml', '1', '0.9%lhn', NULL),
  ('69150c43c1f34189b806d71a68610095', '200806', '����������ҩ����ҩ���޹�˾', '��Ƣ��', 3.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ƣ��', '������', '9g', '10', 'gpw', NULL),
  ('6bcdec36519a4e21b29d46459032f646', '200807', '������ҩ�ػʵ����޹�˾', 'ͷ����������', 3.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ������', '����', '0.25g', '24', 'tbld', NULL),
  ('705686b622674a838190bcf5060367b3', '200808', '�����췽ҩҵ�ɷ����޹�˾', '�������', 15.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������˫�һ���Ƭ', '����Ƭ', '0.5g', '64', 'ysejsghsp', NULL),
  ('738d6286925d486a96656efaac3a557e', '200809', '�Ϻ���������Ƽ���������ҩҵ���޹�˾', '߻���ͪƬ', 1.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '߻���ͪ', 'Ƭ��', '0.1g', '100', 'fnzt', NULL),
  ('7581b2b895a9498396d40383c0673baf', '200810', '����������ҩ�������ι�˾', '����Ƭ', 5.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����', 'Ƭ��', '10mg', '1000', 'dj,dq', NULL),
  ('785be4fdc07445b2804a6e56facc9083', '200811', '�ӱ����ҩҵ�ɷ����޹�˾', '����þע��Һ', 0.25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����þ', 'ע��Һ', '10ml:2.5g', '1', 'lsm', NULL),
  ('7c4e13842a9c40dcb54716eb2bb316ca', '200812', '���վ���ҩҵ�ɷ����޹�˾', '�������', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������', '������', '6g', '9', 'gskl,jskl', NULL),
  ('7e73ad419510435a8fe4800f269a1cf6', '200813', '�˲�����ҩҵ���޹�˾', '��Ī�涡����', 1.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī�涡����', '����', '20mg', '24', 'fmtzjn,fmtdjn', NULL),
  ('81393aa920004c7182897250812de77d', '200814', '����ҩҵ�������޹�˾', '������', 0.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������', '����', '80mg', '1', 'yhn', NULL),
  ('838703579dac4138ad036440ad56c228', '200815', '���ݰ���ɽ������ҩ���޹�˾', '�����', 0.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�����', 'ע��Һ', '2ml:0.5g', '1', 'acj', NULL),
  ('85869e40455945648864c9073e74dabd', '200816', '������ҩҵ�������޹�˾', '����������', 20.67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������', '������', '5g', '10', 'jfkkl,gfkkl', NULL),
  ('ec06c1a3b07c42aa89b4bb5eba4a1a0d', '200817', '�Ű�����ҩҵ���޹�˾', '�θ�ע��Һ', 21.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�θ�ע��Һ', 'ע��Һ', '10ml', '1', 'sfzsy,sfzyy,cfzyy,cfzsy', NULL),
  ('eeebf885ff874480aa01f45cba7f0255', '200818', 'ɽ������ҩҵ�ɷ����޹�˾', 'ͷ�߰���', 2.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ�߰���', '����', '0.25g', '24', 'tbab', NULL),
  ('b820283c6c9541bc83826e46718c44eb', '200819', '����˫�׻���ҩҵ���޹�˾', '�Ȼ���ע��Һ', 1.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�Ȼ���ע��Һ', '����Һ', '500ml��4.5g(����ƿ)', '1', 'lhnzyy,lhnzsy', NULL),
  ('b90fbe788f794c998fbfa9129b29d6c3', '200820', '��������ͨҩҵ�������ι�˾', '�ֿ�ù��', 1.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�ֿ�ù��', '����', '0.6g', '1', 'lkms', NULL),
  ('b92af38b86f34a91b3eaf750c8c3b47a', '200821', '�Ĵ�����ҩҵ�ɷ����޹�˾', '������Τ', 2.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������Τ', 'Ƭ��', '0.2g', '24', 'axlw,exlw', NULL),
  ('bbafa0d8e5794e9c8b0450fb2108b5aa', '200822', '���ݺ�������ҩҵ���޹�˾', '����������', 7.03, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������', 'ˮ����', '60g', '1', 'jksqw', NULL),
  ('bc6d4e73aeb24673b89334a3b0186871', '200823', '�Ϻ�����ʵҵ�����ţ�������ҩҵ���޹�˾', 'ţ������Ƭ', 2.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ţ������Ƭ', 'Ƭ��', '0.25g', '48', 'nhsqp', NULL),
  ('bcbe3e3a16854daca75fcadfd94ee446', '200824', '���Ͽ�����ҩ���޹�˾', '������', 1.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ɳ��', '����', '0.2g', '1', 'yfsx', NULL),
  ('bd74e6b65bcb44dbb5634e0f93694f4d', '200825', '�ÿ�ҩҵ�������޹�˾', '�ÿ���', 1.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����������', '����', '40mg', '1', 'azgln', NULL),
  ('bdec8586b60b40618afb08a2df901231', '200826', '�Ͼ���ɽ��ҩ���޹�˾', '��Ѫֹʹ����', 19.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ѫֹʹ����', '����', '0.25g', '60', 'hxztjn', NULL),
  ('be8cd74148b741c5b4b841c9213bd29e', '200827', '����ҩ��������ҩ���޹�˾', '����������', 5.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������', 'ˮ����', '120g', '1', 'bzyxw', NULL),
  ('bedae1ea6b804054bf3a25d716e45d80', '200828', '����ҩҵ�ɷ����޹�˾', 'ά����B6', 0.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', 'ά����B6', 'Ƭ��', '10mg', '100', 'wssb6', NULL),
  ('bf01b2b0920b4308acf6d51c52111a45', '200829', '�Ĵ��̰�������ҩ�ɷ����޹�˾', '޽������ˮ', 2.36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '޽������ˮ', '����', '10ml', '10', 'hxzqs', NULL),
  ('bf0a2c69dee14ef99df216b27faeb975', '200830', '�㽭��̩ҩҵ���޹�˾', '��̩', 25.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī����/����ά���', '����', '0.15625g(4:1)', '18', 'emxl/klwsj,amxl/klwsj', NULL),
  ('bf735bd3a9a842b1baa1e8ecb836cf2a', '200831', '������������ҩҵ�ɷ����޹�˾', '�����ƽ', 26.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ʲ�����', '���ܽ���', '50mg', '24', 'gcsea', NULL),
  ('bf7f44c9c4ba4af8a7cc0e41d5444095', '200832', '��ҩ����������ҩ���޹�˾', '�⻯�ɵ���', 1.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�⻯�ɵ���', 'ע��Һ', '20ml:0.1g', '1', 'qhkds', NULL),
  ('bfa73499e98441078a92aa3d630c12a1', '200833', '������¹����ҩ�ɷ����޹�˾', '��򻶨����', 6.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��򻶨����', 'ˮ����', '6g', '10', 'gjdcw,hjdcw', NULL),
  ('c0699c0611a84d2e88c69076a30259d6', '200834', '���ݰ���ɽ��ҩ�ɷ����޹�˾���ݰ���ɽ��ҩ�ܳ�', '�Ⱥϰ�', 8.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ȵ�ƽ', 'Ƭ��', '5mg', '14', 'aldp', NULL),
  ('99c612ff7bfa4d138d09c3fef2ce1e56', '200617', '����ҩҵ�ɷ����޹�˾', '�������ָ�ע��Һ', 1.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '�������ָ�', '����Һ', '500ml(��ƿ)', '1', 'rsnlg', NULL),
  ('9a2233dafe984117b8c2de01df0918b0', '200618', '���Ͽ���ҩҵ���޹�˾', '�������Ȼ���', 1.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������Ȼ���', '����Һ', '250ml(��ƿ)', '1', 'pttlhn', NULL),
  ('9a2925e2edc3424fb361acd0e0ddab60', '200619', 'ɽ������ҩҵ�ɷ����޹�˾', '�工��͡', 3.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�工��͡', 'Ƭ��', '10mg', '20', 'lftt', NULL),
  ('9a2c10956f274dbdbf7ae6769a152aea', '200620', '����ҩҵ�ɷ����޹�˾', '����Ʒ', 3.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����Ʒ', 'Ƭ��', '0.3mg', '1000', 'etp,atp', NULL),
  ('9a85a5eb17d143e3852f6f2704c15803', '200621', 'ɽ������ҩҵ�ɷ����޹�˾', '��ɳ', 0.96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������ɳ��', '����', '0.1g', '1', 'zyfsx', NULL),
  ('9ac4a69acccd4d999a1061a7e14cc3bf', '200622', '������ҩ��ҩ���޹�˾', '��������', 13.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������', 'Ƭ��', '25mg', '100', 'amtl,emtl', NULL),
  ('9ad11ca401054dce95b8c5735066aabc', '200623', '����ά��ҩҵ�ɷ����޹�˾', '��Ѫֹʹɢ', 9.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ѫֹʹɢ', 'ɢ��', '3g', '6', 'hxzts', NULL),
  ('9b3f2038caef49ac913891ace2daaf53', '200624', 'ͨ������ҩҵ�ɷ����޹�˾', '����������', 16.67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����������', '����', '0.3g', '60', 'znnjn', NULL),
  ('9b804bc43d5a4b5f8f0431eb1a7b96cd', '200625', '����ҩҵ�ɷ����޹�˾', '����������ע��Һ(18AA)', 3.04, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����������(18AA)', '����Һ', '250ml:12.5g', '1', 'ffajs(18aa)', NULL),
  ('9beb14a3e1d2499fa6e675643b8c122f', '200626', '�ɶ�����ҩҵ�������ι�˾', '�������Ƭ', 5.82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�������', 'Ƭ��', '0.25g', '100', 'pqxa,bqxa', NULL),
  ('9c6ceb52455749ddbab6f3d6f0fc1888', '200627', '���ϻ���ҩҵ�������ι�˾', '���̽ⶾ��', 2.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '��', '���̽ⶾ��', '������', '9g', '10', 'yqjdw,yqxdw', NULL),
  ('9c9a51d073e246268afbb6af53519688', '200628', '������ҩ(����)���޹�˾', '����������', 4.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����������', '����', '250g', '1', 'fflhrg', NULL),
  ('58b7d7f3b11246b49a20edc74c478226', '200629', '�����г�����ҩ�������ι�˾', 'ά����B6', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', 'ά����B6', 'Ƭ��', '10mg', '1000', 'wssb6', NULL),
  ('599260dda45f4190a4d8e298c3805fb4', '200630', '�Ϻ�������ҩҵ���޹�˾', '޽������', 36.47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '޽������', '����', '0.05g', '60', 'hddw', NULL),
  ('5a621014fa8a4b3cacf37f051039b5fa', '200631', '�����¾���ҩ���޹�˾', '������', 6.63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', '�ڷ�Һ', '100ml:0.3g(������)', '1', 'axs', NULL),
  ('5a62b1236c0947dc9ffe4efd9cb91b88', '200632', '���ϻ���ɭҽҩ���＼�����޹�˾', '��ɳ', 1.77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�޺�ù��', '��ɢƬ', '0.15g', '6', 'lgms,lhms', NULL),
  ('5a9783aa349f4ef988e04163f52a6b93', '200633', '�Ϻ��ִ���ɭ(����)ҩҵ���޹�˾', '�⻯�ɵ���ע��Һ', 0.15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�⻯�ɵ���', 'ע��Һ', '2ml:10mg', '1', 'qhkds', NULL),
  ('5b0292282f1b46cc9f178fce96cc3459', '200634', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '������', 1.36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī����', '��ɢƬ', '0.25g', '12', 'amxl,emxl', NULL),
  ('5b0942fb6f15450884f3382a9e48a907', '200635', '����ʡ��Ȫ��ҩ���޹�˾', '����ڷ�Һ', 6.56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ڷ�Һ', '�ڷ�Һ', '10ml', '12', 'chkfy', NULL),
  ('5b972dfb841e44e9af507ba88c4f614d', '200636', '���绪��ҩҵ���޹�˾', '��', 0.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ù��', '��Һ��', '8ml:0.12g(1.5%)', '1', 'kmz', NULL),
  ('5d87628cc5f74315b275375055a63fe6', '200637', '��������ҩ��ҩ���޹�˾', '������', 5.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������', '�ڷ�Һ', '100ml:0.3g', '1', 'axs', NULL),
  ('5e09d3361d0a48b98e31a7faa2d53c3b', '200638', '������˼����ҩ���޹�˾', '��/����֬����(C8-24)', 83.79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '��/����֬����(C8-24)', '����Һ', '500ml(10%)', '1', 'z/clzfr(c8-24),z/zlzfr(c8-24)', NULL),
  ('5e4502488ff4490b900c1288c7863687', '200639', '������ҩ�ɷ����޹�˾', 'ע����ͷ�����', 1.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ�����', '����', '1.0g', '1', 'tbtd', NULL),
  ('5e9f3538f9e448c3bc8b23a2d4631235', '200640', '�人�˸�ҩҵ�������ι�˾', '����', 7.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '������', '����', '50mg', '1', 'xpn', NULL),
  ('5eecaee339d34eaca3d416500e39ebe5', '200641', '������ҩ(����)���޹�˾', '��������', 1.54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������', 'Ƭ��', '12.5mg', '100', 'ktpl,qtpl', NULL),
  ('5ef880f0a2ad4fabbf2441fa1557af5b', '200642', '����������Ʒ�о���', '���˷翹����', 2.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���˷翹����', 'ע��Һ', '1500IU', '1', 'psfkds', NULL),
  ('5f1218a457c049fab7a3cf648ca4ca7b', '200643', '���������ҩ�ɷ����޹�˾', '��', 0.07, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ά����C', 'ע��Һ', '2ml:0.25g', '1', 'wssc', NULL),
  ('5f63dcf472f64497b1db3f9a59e5e75a', '200644', '��������̩ҩҵ�ɷ����޹�˾', '������', 4.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͷ��߻��', '����', '0.5g', '1', 'tbfx', NULL),
  ('5f8901d60c1b4d6892a0709108c31648', '200645', '�Ϻ�����ҩ�����޹�˾', '���б���Ƭ', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '���б���Ƭ', 'Ƭ��', '2.5mg', '100', 'glbnp', NULL),
  ('5fbaca9af0764e00b3b08feba6caaba8', '200646', '����̫��ҩҵ�ɷ����޹�˾', '0.9%�Ȼ���', 0.86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '0.9%�Ȼ���', '����Һ', '250ml', '1', '0.9%lhn', NULL),
  ('5fd952631ec94be381520e07bac6767b', '200647', '�����췽ҩҵ�ɷ����޹�˾', '�����涡', 2.47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�����涡', 'Ƭ��', '0.2g', '100', 'xmtd,xmtz', NULL),
  ('5fda3a2daa434a54b015fdbaa68d60f2', '200648', '����̫����ҩ���޹�˾', '��ܺ�����', 6.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ܺ�����', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '192', 'cxcdw,cxctw', NULL),
  ('604e8946a90d40808ba20010a482f24d', '200649', '���ݰ���ɽ��һҩҵ���޹�˾', '������', 24.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '���', 'ÿ10����2.5g�������б���2.5mg��', '210', 'xkw', NULL),
  ('6058d0f33b7c4cccaad9b538e634acad', '200650', '����Ԯ����ҩ�ɷ����޹�˾', '����������ɳ���Ȼ���ע��Һ', 2.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����������ɳ���Ȼ���ע��Һ', '����Һ', '100ml:0.2g', '1', 'rszyfsxlhnzyy,rszyfsxlhnzsy', NULL),
  ('61671ccab3f041b2b0981b5f9eec66f4', '200651', 'ɽ������ҩҵ�ɷ����޹�˾', '����ù��', 0.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ù��', '����', '0.125g', '1', 'ajms,ejms,aqms,eqms', NULL),
  ('61c797e1bdf3474fb099d3574c3e596d', '200652', '������ʱҩҵ�ɷ����޹�˾', '����ʮζƬ', 3.74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ʮζƬ', 'Ƭ��', '0.3g', '100', 'fkswp', NULL),
  ('62110d8b2cca4187aeb03cea9e40c28f', '200653', '���춫��ҩҵ�ɷ����޹�˾', '����Ƭ', 14.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����Ƭ', 'Ƭ��', '0.35g', '100', 'wlp', NULL),
  ('626f37a66b82444d9f7b60b672f65bbc', '200654', 'ɽ����³��ҩ���޹�˾', '���࿨��', 0.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���࿨��', 'ע��Һ', '10ml:0.2g', '1', 'ldky,ldqy', NULL),
  ('62b2a2281a59473d9c0228d5a09825ea', '200655', '���Ϻ�����ҩ�ɷ����޹�˾', 'ע���õ�յ����', 41.95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��յ����', '����', '50mg', '1', 'dzhs', NULL),
  ('63125a4e20054ff7af70e9a106b8e17c', '200656', '����Ͽ��ŵά��ҩ���޹�˾', '��ø��', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ø��', 'Ƭ��', '0.15g', '1000', 'rms', NULL),
  ('636ed5ab5ab24f84a183fe2a3ce97679', '200657', '���Ͻ�ɳҩҵ�������ι�˾', '�ӹ�����Ƭ', 40.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ӹ�����Ƭ', 'Ƭ��', '�൱��ԭ��ҩ��0.3g', '75', 'jgqlp', NULL),
  ('6393e96a1f4d4b3081cf9fb5fd07aa85', '200658', '����ǧ��ҩҵ�ɷ����޹�˾', '����ǧ����', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ǧ����', '����', '0.4g', '36', 'fkqjjn', NULL),
  ('64f2be1fc08c4979915f3f014622dce0', '200659', '���տ�Եҩҵ�ɷ����޹�˾', '��ң��', 2.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ң��', 'Ũ����', 'ÿ8���൱��ԭҩ��3g', '200', 'xyw', NULL),
  ('65640b32e11c4632af3e71fb08cf9c2c', '200660', '�Ϻ��ִ���ҩ�ɷ����޹�˾', '�ֺ�', 1.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�޺�ù��', 'Ƭ��', '50mg', '10', 'lgms,lhms', NULL),
  ('659f6917051349288ec4edc5c8e931cf', '200661', '�ӱ����ҩҵ�ɷ����޹�˾', '�Ȼ���ע��Һ', 0.14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�Ȼ���', 'ע��Һ', '10ml:1.0g', '1', 'lhj', NULL),
  ('662a6d83dd3841b6ad123ba70a08e42a', '200662', '����ҩҵ�ɷ����޹�˾', '�Ļ��ؿɵ����۸�', 0.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�Ļ��ؿɵ���', '�۸��', '2.0g', '1', 'shskds', NULL),
  ('664e7ef3006c4a0098485e61703b3b6b', '200663', '��������ҩ�����޹�˾', '�ٺ�Ƭ', 7.51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ٺ�Ƭ', 'Ƭ��', '0.3g', '40', 'jgp,jhp', NULL),
  ('66575cd57a17483dafc4c6db213eb463', '200664', '����ʥ������ҩ���޹�˾', '�������˫�ҳ���Ƭ', 9.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����˫��', '����Ƭ', '0.5g', '45', 'ejsg', NULL),
  ('66a5a6c996324beebf0b4571dbdd2772', '200665', '��Ӧ��ҩҵ���Źɷ����޹�˾', 'ˮ�������', 1.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ˮ����', '����', '10g:0.5g', '1', 'sys', NULL),
  ('66ac6980b6de4a30bd46c97a2c520f9a', '200666', 'ɽ��������ҩ���޹�˾', '���Ŀ���', 24.54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���Ŀ���', '������', '9g', '9', 'wxkl', NULL),
  ('67f0d60a5dd148caabfa6dd95ab4ee83', '200667', '�Ϻ��������ҩҵ���޹�˾', '��', 0.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', 'ע��Һ', '10ml:2.0g', '1', 'ajjs', NULL),
  ('67f5a7a216f3441a9f3bcdef1487e99a', '200668', '����ҩҵ�ɷ����޹�˾', 'ά����K1ע��Һ', 0.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ά����K1', 'ע��Һ', '1ml:10mg', '1', 'wssk1', NULL),
  ('684339be2be44eee8541013b7713a96f', '200669', '�ÿ�ҩҵ���ű���������ҩ���޹�˾', 'ͷ�߰���', 1.85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ�߰���', 'Ƭ��', '0.125g', '30', 'tbab', NULL),
  ('68d4692e94354413bd341a4d9166db09', '200670', '���¼�������ҩҵ���޹�˾', '��֦������', 35.94, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��֦������', 'ˮ��', '2.2g/10', '120', 'gqflw,gzflw', NULL),
  ('690862a7004647a6a73396b775f315d7', '200671', '����������ҩ����ҩ���޹�˾', '������ĸ��', 2.87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ĸ��', '������', '9g', '10', 'bzymw', NULL),
  ('690e110d41bf4277abfad2e1011d3f93', '200672', '������ҩ(����)���޹�˾', '����ɳ��', 0.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ɳ��', 'Ƭ��', '0.25g', '10', 'hbsx', NULL),
  ('69197f9f90e14fe3971c2800c56baba0', '200673', '�Ϻ��ִ���ɭ(����)ҩҵ���޹�˾', '����«��ע��Һ', 1.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����«��', 'ע��Һ', '10ml:0.3g', '1', 'qklz,qkld', NULL),
  ('c42a19775600447ea9c5a5fcc8369ea6', '200674', '������ҩ�ɷ����޹�˾', 'ע����������ù��', 0.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù��', '����', '100WU', '1', 'lms', NULL),
  ('c5a9c15e69414b14b68a06aa9bad4d6d', '200675', '����ҩҵ�������޹�˾', '��Ⱥ��ƽ', 0.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��Ⱥ��ƽ', 'Ƭ��', '10mg', '100', 'nqdp', NULL),
  ('c5b20e7d0df24f4091570645d697693a', '200676', '�˲�����ҩҵ���޹�˾', '����ù�ط�ɢƬ', 6.24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ù�ط�ɢƬ', '��ɢƬ', '0.25g', '6', 'klmsfsp', NULL),
  ('c5f6ece950bc4e12bf39d454146db4c8', '200677', 'ɽ����Ԫʢ����ҩ���޹�˾', '������', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '������', '9g', '10', 'bhw', NULL),
  ('c6020fac8d7348178ded2393e6613d67', '200678', '�������䱦��ҩҵ�ɷ����޹�˾', 'Ѫ��ͨע��Һ', 3.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', 'Ѫ��ͨע��Һ', 'ע��Һ', '5ml:0.25g', '1', 'xstzyy,xstzsy', NULL),
  ('c6b892525d8846309145980ebd9858b8', '200679', '���������ҩ�ɷ����޹�˾', '��', 0.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�����', 'ע��Һ', '2ml:0.25g', '1', 'acj', NULL),
  ('c6e49851d9d54b39a93eca778dc05f4b', '200680', '����ҩҵ�������޹�˾', '޽����������', 8.49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '޽����������', '����', '0.45g', '24', 'hxzqrjn', NULL),
  ('c6ec2b52dc144d26b6ebd238de8c49d5', '200681', '������������ҩ���޹�˾', '������������', 12.94, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '������������', '�ڷ�Һ', '60ml', '1', 'ffafym', NULL),
  ('c7c6fde5a9134e2a90bf4a6aa7158635', '200682', 'ҩ����ҩ���Źɷ����޹�˾', 'ʯ��ҹ����', 13.02, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ʯ��ҹ����', '������', '9g', '10', 'shygw,dhygw', NULL),
  ('c82e23efe33e437aa74900a35ddbe6ed', '200683', 'ɽ���»���ҩ�ɷ����޹�˾', '��������������', 0.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '��������������', 'ע��Һ', '1ml:2mg', '1', 'dsmslsn', NULL),
  ('c84f0d9528654f6d8119dc424a5ed2cf', '200684', '�����оŻ���ҩ�ɷ����޹�˾', '��', 24.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��θ����', '����', '0.2g', '24', 'awyjn', NULL),
  ('c854f23aceed482cad4aacff529c4b5a', '200685', '����������ҩ�ɷ����޹�˾', '�������ù�ؽ���', 1.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����ù��', '����', '0.15g', '10', 'klms', NULL),
  ('c8be6c86565d4cf79d94a2130f7a119c', '200686', '�ɶ�������ҩ���޹�˾', '���ȴ�����', 17.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ȴ�����', '����', '0.35g', '36', 'xkcjn,xhcjn', NULL),
  ('c907b7b8790e463c95cfa290717dd9ad', '200687', '����������ҩ�ɷ����޹�˾', '��ù��', 22.28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ù��', '����Ƭ', '0.25g', '100', 'hms,gms', NULL),
  ('c933a417fbb94c09947ce089dbf4449e', '200688', 'ͨ������ҩҵ�ɷ����޹�˾', '������R', 46.43, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�������ȵ���', 'ע��Һ', '10ml:400IU', '1', 'czryds,zzryds', NULL),
  ('c99c01ca0182466f922eb2508fb78b96', '200689', '�Ϻ��������ҩҵ���޹�˾', '��', 3.75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��˹����', 'ע��Һ', '2ml:1mg', '1', 'xsdm', NULL),
  ('c99ec832ae704f9f80da453acfea0dfd', '200690', '���ϵ�ŵ��ҩ���޹�˾', '��Ī�涡', 1.08, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī�涡', 'Ƭ��', '20mg', '24', 'fmtz,fmtd', NULL),
  ('ca100c434e6844cca04dce4372f73f44', '200691', 'ɽ������ҩҵ�ɷ����޹�˾', '�ٺ���', 3.6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ٺ���', 'ˮ����', '7.2g(10g/100��', '6', 'jgw,jhw', NULL),
  ('ca65802b4d55429dab1b5f5126d725b9', '200692', '����ҩҵ�ɷ����޹�˾', '�����Ƭ', 1.65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�����', 'Ƭ��', '25mg', '100', 'glq', NULL),
  ('cbd09dd39d55452ea8aba836ec49c784', '200693', '����ҩҵ�ɷ����޹�˾', '��ȩ����Ƭ', 1.55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��ȩ����', 'Ƭ��', '0.1g', '100', 'pqnz', NULL),
  ('cbf0c00b6094420f81f098655f19bcee', '200694', '����˹��ҩ�����ţ����޹�˾', '������', 1.76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', 'Ƭ��', '10mg', '6', 'lltd', NULL),
  ('cc04d6df62a245abaf1413383911bf59', '200695', '��������ҩҵ�ɷ����޹�˾', '��������', 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������', 'Ƭ��', '0.1g', '36', 'lzpl', NULL),
  ('cc451c455a9d4099be0cf6c45a99f754', '200696', '��ʿ����ҩ���Źɷ����޹�˾', '�������', 7.92, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������', '����', '0.551g', '6', 'chdw', NULL),
  ('cc518215bd0345a3ae9c19bdd5a0ea58', '200697', '³�ϱ�����ҩ���޹�˾', '����', 52.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�����ε�', '�����', '100ug/��*200', '1', 'bdnd', NULL),
  ('cc56541a644b43bba7cd8b5d0f68b2f0', '200698', '���ϵ�ŵ��ҩ���޹�˾', '������', 0.68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', 'Ƭ��', '0.5g', '8', 'txz', NULL),
  ('cc7400bccdea43c2889892101fd79cd5', '200699', '���ճ���ҩҵ���Źɷ����޹�˾', '��������ɳ��', 22.36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��������ɳ��', '����', '0.125g:0.15g', '48', 'fflzsz', NULL),
  ('cdae9dfbce424e08904d3d1320ca11e3', '200700', '���ռ�����ҩҵ���޹�˾', '���ɾ�', 33.35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ɾ�', 'Ƭ��', '20mg', '48', 'lkj', NULL),
  ('cf1c4ab918f44a2ea12228d6ca8c03ff', '200701', '����ǧ���潭ҩҵ�ɷ����޹�˾', '����Τ��', 2.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '����Τ��', '������', '50mg', '18', 'lbwl', NULL),
  ('cfb14d6917174aedab247179fec490df', '200702', '���ϰ�ҩ��������ҩҵ���޹�˾', '���ϰ�ҩ��', 42.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ϰ�ҩ��', '�𽺸��', '6.5cm*10cm', '10', 'ynbyg', NULL),
  ('d0d8e1fa42f84d688315a04f4c2d1999', '200703', '����̫��ҩҵ�ɷ����޹�˾', '�������Ȼ���', 0.94, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '�������Ȼ���', '����Һ', '250ml', '1', 'pttlhn', NULL),
  ('d12b5368326341e4804e64feb4273d79', '200704', '��������ҩҵ���޹�˾', '?', 18.59, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '����ƽ����', 'Ƭ��', '0.2g', '36', 'gypjn', NULL),
  ('d1dd346156a34ace97afcaea7a30a859', '200705', 'ҩ����ҩ���Źɷ����޹�˾', '������', 4.45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', '������', '3g', '10', 'ddw', NULL),
  ('d219da987e1d4289af803f363ae4e647', '200706', '����������ҩ���޹�˾', '�����Ұ���������', 15.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�Ұ�����', '����', '0.25g', '100', 'yadc,yazc', NULL),
  ('d24276345f844fd4a52e507b9e856acb', '200707', '������ά����ҩ', '��ĸ�ݸ�', 3.1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ĸ�ݸ�', '����', '125g', '1', 'ymcg', NULL),
  ('d2dd8a7bc8fc46e3af57672cae6c2bc9', '200708', '�Ϻ�����ҩ�����޹�˾', '��Ψ��', 24.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'Īɳ����', '����', '5mg', '24', 'msbl', NULL),
  ('d34f8025c7d74c57b866f71ea8a0f076', '200709', '��������ҩ�����޹�˾', 'ͷ�߿������', 3.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ�߿���', '������', '0.125g', '6', 'tbkl', NULL),
  ('d3516afc4ac2413b9e3ee4794780b2f3', '200710', '�����¾���ҩ���޹�˾', '������', 8.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', 'ͷ��߻����', '����', '0.125g', '12', 'tbfxz', NULL),
  ('d357409542fb4ddfad677e5c90741bc1', '200711', '����ҩҵ�ɷ����޹�˾', '?', 27.41, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '������', '����', '5ml:0.5g', '1', 'tms', NULL),
  ('d3c5082c22f1472287bf7c6beef03e02', '200712', '����ҩҵ�ɷ����޹�˾', '�����ù���۸�', 0.48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��ù��', '�۸��', '2g:10mg(0.5%)', '1', 'jms', NULL),
  ('d44112fe297942ca8f618bf54edd7c5e', '200713', 'ɽ��ʡƽԭ��ҩ��', '������ͪ���Ƭ', 2.46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', 'ͪ���', 'Ƭ��', '1mg', '100', 'ttf', NULL),
  ('d45118b3a8244b4ea2c28ed78cdb4475', '200714', '�㶫ʡ�޸�ɽ�׺���ҩ��', '������', 5.16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', 'ˮ��', '3.7g', '20', 'bjw', NULL),
  ('d45b0f45eb8d4004966ec29f58fc248d', '200715', '����������ҩ�ɷ����޹�˾', 'ע���ð�Ī�����ƿ���ά���', 1.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��Ī����/����ά���', '����', '0.6g(5:1)', '1', 'emxl/klwsj,amxl/klwsj', NULL),
  ('d68622a325d1473db985c86550cc66d6', '200716', '���Ǻ�˹��ҩ���޹�˾', '����«��', 1.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����«��', '����', '0.48g', '1', 'qklz,qkld', NULL),
  ('d6a6dbf624524fed86297ba6a9024d4e', '200717', '���Ͽ���ҩҵ���޹�˾', '5%������', 0.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '5%������', '����Һ', '100ml(��ƿ)', '1', '5%ptt', NULL),
  ('d6a78044a49e450d9f3fc8d91775fc3e', '200718', '����̫��ҩҵ�ɷ����޹�˾', '5%������', 0.73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, 'ƿ', '5%������', '����Һ', '100ml', '1', '5%ptt', NULL),
  ('d6a908446e6a4588a60a39bd9b4d1af9', '200719', '���������ҩ�ɷ����޹�˾', '��', 1.78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��˹����', 'ע��Һ', '1ml:0.5mg', '1', 'xsdm', NULL),
  ('d6c8b594c842442b885ae6a4971dee4c', '200720', 'ʯҩ������ŵҩҵ(ʯ��ׯ)���޹�˾', '��Ī����', 3.12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��Ī����', '����', '0.25g', '50', 'amxl,emxl', NULL),
  ('d6e00f1b27394a9a9ad51e3d788366dd', '200721', 'ɽ��³��ҩҵ���޹�˾', '�����Ƭ', 2.58, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�����', 'Ƭ��', '0.2g', '100', 'blf', NULL),
  ('d6ed482eec5c49f9b4231730edf6283f', '200722', '�ɶ���һ��ҩ���޹�˾', '��ù��', 2.19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ù��', '˨��', '0.15g', '10', 'kmz', NULL),
  ('d70a9e7d285446a69d6cccec171bc299', '200723', 'ɽ��������ҩ', '20%��¶��', 2.4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '20%��¶��', '����Һ', '250ml', '1', '20%glc', NULL),
  ('d730a4d7c517463f985614f50ae7c22e', '200724', '�Ϻ��ִ���ɭ(����)ҩҵ���޹�˾', '��������ɽ����ע��Һ', 1.27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, '֧', '��������ɽ����', 'ע��Һ', '5ml:20mg', '1', 'cxsyslz,sxsyslz,dxsyslz', NULL),
  ('d748686eaeb64dab90db742bc8707eb4', '200725', '����������ҩ����ҩ���޹�˾', '������', 3.17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������', 'ˮ��', '6g', '10', 'bhw', NULL),
  ('d78ff6b6fb0c427daa97f6a152e571d1', '200726', '�����н�ҩҵ���޹�˾', '�����Ƭ', 1.34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '�����', 'Ƭ��', '0.1g', '100', 'blf', NULL),
  ('d80e1bce4a3641e7a3aee87aca8129b1', '200727', '�Ͼ�������ҩ���޹�˾', '����ɳ�ǵζ�Һ', 1.69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ɳ��', '�ζ�Һ', '8ml:24mg', '1', 'yfsx', NULL),
  ('d8e4dcb0536c4c48b9a39937a535f6a4', '200728', '��³��ҩ���޹�˾', 'ע����˳��', 8.14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '˳��', '����', '20mg', '1', 'sb', NULL),
  ('d8f456b6a75d424abf650613e993d39d', '200729', '������̩��ҩҵ�ɷ����޹�˾', '���������', 21.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���������', '������', '8g(�൱��ԭҩ��6g)', '6', 'rpxkl', NULL),
  ('d9927c1e020f4e14a2e8cafcfe83ea6f', '200730', '�麣������ҩ�ɷ����޹�˾', '�������ȵ���', 42.89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '�������ȵ���', 'ע��Һ', '3ml:300IU', '1', 'czryds,zzryds', NULL),
  ('d9f3c4422ffb49109dfc40f9431dd01d', '200731', '�ɶ���ҩ�����Ĵ�������ҩ���޹�˾', '�ڷ���Һ��ɢ(��)', 7.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�ڷ���Һ�΢�', 'ɢ��', '14.75g', '20', 'kfbyy��', NULL),
  ('da207317cf174dce9875eb6e367d3f5b', '200732', '������ҩ���Źɷ����޹�˾', '���ϱ�����', 28.72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ϱ�����', 'ˮ��', '0.15g(0.15g/60)', '20', 'wsbcw,wzbcw', NULL),
  ('da82dfae1923417faaac79dd3f7b2c42', '200733', '��������߿���Ȼҩ�����޹�˾', '���ٻƿڷ�Һ', 29.61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ٻƿڷ�Һ', '�ڷ�Һ', '10ml', '10', 'yzhkfy', NULL),
  ('da90291a932d4f08bc7aafc2d632dba2', '200734', '����Զ��ҩҵ���޹�˾', '��ù��', 17.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��ù��', '˨��', '20WU', '14', 'zms', NULL),
  ('db890a8915bd4e4ea99aa6e8920c044d', '200735', 'ͨ��ï����ҩ���޹�˾', '��������', 3.44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��������', 'ע��Һ', '0.2g', '10', 'hlxa', NULL),
  ('dbdfb66449c941a3b94d4c242424b3a7', '200736', '�Ĵ�������ҩ���޹�˾', '˫�ȷ�����', 0.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '˫�ȷ�����', '����Ƭ', '25mg', '100', 'slfsn', NULL),
  ('dc334b70b1ee436fab37f256f4b7e17b', '200737', '���⿵ŵҩҵ���޹�˾', '��Ī�涡', 1.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��Ī�涡', '����', '20mg', '1', 'fmtz,fmtd', NULL),
  ('dca7f43153da44cf9dcd0ffb2f09413c', '200738', '�������ҩҵ���Źɷ����޹�˾������ҩ��', '���ʵ���', 23.38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '���ʵ���', '����', '20mg', '100', 'qydw', NULL),
  ('dcc4ed4cf6a843b8959274b62f04b3f3', '200739', '��������ҩҵ���޹�˾', '�������Ľ���', 26.01, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������Ľ���', '����', '0.4g', '36', 'csyxjn,ssyxjn', NULL),
  ('dd3e24fc3f124c689b761743160cf390', '200740', '���ϸ�������ҩҵ���޹�˾', '����ע��Һ', 9.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����ע��Һ', 'ע��Һ', '20ml', '1', 'smzyy,cmzsy,cmzyy,smzsy', NULL),
  ('dda1d882853c440b9009a58def30d7b0', '200741', '��ɽ��ԭ��ҩ���޹�˾', '���������ն���', 1.14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '���������ն���', '����', '20mg', '1', 'slsxgen', NULL),
  ('de55e55530cc42b79193f555fa1df04a', '200742', '���Ϻ�ɭ��ҩ�ɷ����޹�˾', '��Ӱ�ϰ�', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '��Ӱ�ϰ�', 'ע��Һ', '20ml:12g', '1', 'fypa', NULL),
  ('dfbc19498e9a4a60af55fce22f5f5dc0', '200743', '������һ����ҩ���޹�˾', '����', 5.26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '�������', '����', '2mg', '14', 'tlzq', NULL),
  ('dfc14eabd54744d8a63d23362718f2a8', '200744', '����������ҩ�ɷ����޹�˾', 'ע��������Τ��', 0.88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', '����Τ��', '����', '0.25g', '1', 'lbwl', NULL),
  ('e0817b62caf0441b8c67c98e089a055e', '200745', '�����н�����ҩ���޹�˾', '��', 0.7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', '��������', '��Һ��', '100ml', '1', 'gyhq', NULL),
  ('e0a6cdb9a6b9400ab4955e4ea4ee166d', '200746', '���ջԿ�ҩҵ���޹�˾', 'ά����C', 0.81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, 'ƿ', 'ά����C', 'Ƭ��', '50mg', '100', 'wssc', NULL),
  ('e1028caa072942c0aa0220607636bc27', '200747', '���ҩҵ�������޹�˾', '��', 1.2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '֧', 'ͪ����', '����', '10g:0.2g', '1', 'tkz', NULL),
  ('e1ebeb5616904091bdae58929b184ad5', '200748', '����������ҩ�ɷ����޹�˾', '����������ɳ�ǽ���', 1.18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '������ɳ��', '����', '0.1g', '12', 'zyfsx', NULL),
  ('e2454624ffbb430fb103cbc3f97bed51', '200749', '�人����������ҩҵ���޹�˾', '��θ��ʳƬ', 4.05, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '��', '��θ��ʳƬ', 'Ƭ��', '0.8g', '32', 'jwxsp,jwxyp', NULL);
  
  
  go
  --��������
Begin
	IF EXISTS(Select * From tempdb.dbo.Sysobjects Where 
		id = object_id(N'tempdb..#test') and type='U')  --��ѯ�����Ƿ����  
		DROP table #test  
	create table #test(
		id int IDENTITY(1,1),
		name varchar(30));
	insert into #test(name) select distinct JX from ypxx;
	insert into ����(ID,����) select * from #test
end
go

--����������
alter table ����
	alter column ���� varchar(128) not null;
Begin
	IF EXISTS(Select * From tempdb.dbo.Sysobjects Where 
		id = object_id(N'tempdb..#test3') and type='U')  --��ѯ�����Ƿ����  
		DROP table #test3  ;
	create table #test3(
		id int IDENTITY(1,1),
		name varchar(128),
		addres char(3) not null default '123',
		tele char(3) not null default '123');
	insert into #test3(name) select distinct SCQYMC from ypxx;
	insert into ����(����ID,����,��ַ,�绰) select * from #test3;
end
go
--����ҩƷ
begin
insert into ҩƷ(ҩƷID,ҩ��,����ID,����,�ۼ�,������ID)
 select	BM,MC,����.ID,ZBJG,ZBJG+1,����ID
	from ypxx,����,����
		where ����.���� = JX and ����.���� = SCQYMC;
end

go
-------------ԭʼ�ͻ�����
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
INSERT INTO  userjd  VALUES ('0d498b73-067e-11e3-8a3c-0019d2ce5116', '������������', null, null, null, null, null, null, null, null, null, null, '1.');
INSERT INTO  userjd  VALUES ('15819c06-09a1-11e3-8a4f-60a44cea4388', '����������Ժ', '������ҵ·', '410131', null, '32', '432', 'fdsfds', '432', null, null, null, '1.1.');
INSERT INTO  userjd  VALUES ('2084aa4a-067e-11e3-8a3c-0019d2ce5116', '��ˮ������Ժ', null, null, null, null, null, null, null, null, null, null, '1.10.');
INSERT INTO  userjd  VALUES ('c4c1c750-067e-11e3-8a3c-0019d2ce5116', '��ɽ������Ժ', null, null, null, null, null, null, null, null, null, null, '1.11.');
INSERT INTO  userjd  VALUES ('c58c043a-067e-11e3-8a3c-0019d2ce5116', '�ǹ�������Ժ', null, null, null, null, null, null, null, null, null, null, '1.12.');
INSERT INTO  userjd  VALUES ('c890f6ee-067e-11e3-8a3c-0019d2ce5116', '����������Ժ', '����������·����', '450132', null, null, null, null, null, null, null, null, '1.13.');
INSERT INTO  userjd  VALUES ('c994c0bb-067e-11e3-8a3c-0019d2ce5116', '����������Ժ', '�����л�����', '450132', null, null, null, null, null, null, null, null, '1.14.');
INSERT INTO  userjd  VALUES ('c9c7c495-067e-11e3-8a3c-0019d2ce5116', '����������Ժ', null, '450123', null, null, null, null, null, null, null, null, '1.15.');
INSERT INTO  userjd  VALUES ('cbb4d0be-067e-11e3-8a3c-0019d2ce5116', 'ԥ��������Ժ', null, null, null, null, null, null, null, null, null, null, '1.2.');
INSERT INTO  userjd  VALUES ('cd69a32c-067e-11e3-8a3c-0019d2ce5116', '��������Ժ', null, '450100', null, null, null, null, null, null, null, null, '1.3.');
INSERT INTO  userjd  VALUES ('cd9a55a7-067e-11e3-8a3c-0019d2ce5116', '��������Ժ', null, '4501000', null, null, null, null, null, null, null, null, '1.4.');
INSERT INTO  userjd  VALUES ('ce9ddaa9-067e-11e3-8a3c-0019d2ce5116', '��¥������Ժ', null, null, null, null, null, null, null, null, null, null, '1.5.');
INSERT INTO  userjd  VALUES ('cf4025a8-067e-11e3-8a3c-0019d2ce5116', '����������Ժ', '�����й�������������Ժ', '450100', null, null, null, null, null, null, null, null, '1.6.');
INSERT INTO  userjd  VALUES ('d2b358ef-067e-11e3-8a3c-0019d2ce5116', '�ߴ�������Ժ', null, null, null, null, null, null, null, null, null, null, '1.7.');
INSERT INTO  userjd  VALUES ('d48cb84b-067e-11e3-8a3c-0019d2ce5116', '��կ������Ժ', '�����н�կͬ��·', '450100', null, null, null, null, null, null, null, null, '1.8.');
INSERT INTO  userjd  VALUES ('d4aaf7bd-067e-11e3-8a3c-0019d2ce5116', '����������Ժ', '�������̲�г�', '450142', null, null, null, null, null, null, null, null, '1.9.');
go
--����ͻ�
Begin
alter table �ͻ�
	alter column ���� varchar(64) not null
	IF EXISTS(Select * From tempdb.dbo.Sysobjects Where 
		id = object_id(N'tempdb..#test2') and type='U')  --��ѯ�����Ƿ����  
		DROP table #test2  
	create table #test2(
		id int IDENTITY(1,1),
		name varchar(64),
		tele char(11) not null default '123');
	insert into #test2(name) select distinct MC from userjd;
	insert into �ͻ�(�ͻ�ID,����,�绰) select * from #test2;
end
go
---------����������������
insert into ������
	values('00000000010',
	GETDATE(),GETDATE(),
	'1','000004'
	);
	
insert into ��������ϸ��
	values('00000000010',
	'200001','12','7.1','2017-12-1'),
	('00000000010',
	'200000','25','3.5','2017-5-24'),
	('00000000010',
	'200002','45','1.6','2017-12-1');
	
--------�����ۻ����������
insert into �ۻ���
	values('00000000010',
	GETDATE(),GETDATE(),
	'1','000003'
	);

insert into �ۻ�����ϸ��
values('00000000010',
	'200001','2','8.1','2017-12-1'),
	('00000000010',
	'200000','5','4.5','2017-5-24');

---------�������
insert into ���
	values('200001','2017-12-1',
	'2018-12-1','10'),
	('200000','2017-5-24',
	'2018-5-24','20'),
	('200002','2017-12-1',
	'2018-12-1','45');
go
------------------------------------------------------------------------

------------�ָ��ַ�������
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
 
--���� SELECT * FROM dbo.f_splitstr('300,2000,3000,4000',',')


--�������������
--������@buyID ������ID,
--	@produceID ����ID,@buyerID ����ԱID,
--	@drugID ҩƷID,@num ����,
--	@produceDate ��������,@vaildDate ��Ч����
go
create procedure dbo.insert_buy_data(@buyID varchar(11),
	@produceID varchar(6),@buyerID varchar(6),
	@drugID varchar(MAX),@num varchar(MAX),
	@produceDate varchar(MAX),@vaildDate varchar(MAX))
as
begin
	begin try 
	begin transaction innerTrans 
	save transaction savepoint --�������񱣴�� 
	
	declare @i as int --ҩƷ�У�����ɹ�����0�����򷵻ض�Ӧ��
	insert into ������
		values(@buyID,GETDATE(),GETDATE(),
		@produceID,@buyerID);
	DECLARE @table1 TABLE (ID1 INT IDENTITY(1,1),F1 varchar(50));--ҩƷID
	DECLARE @table2 TABLE (ID2 INT IDENTITY(1,1),F2 int);--����
	DECLARE @table3 TABLE (ID3 INT IDENTITY(1,1),F3 varchar(20));--��������
	DECLARE @table4 TABLE (ID4 INT IDENTITY(1,1),F4 varchar(20));--��Ч��
	
	insert into @table1 select * from dbo.f_splitstr(@drugID,',');
	insert into @table2 select * from dbo.f_splitstr(@num,',');
	insert into @table3 select * from dbo.f_splitstr(@produceDate,',');
	insert into @table4 select * from dbo.f_splitstr(@vaildDate,',');
	
	insert into dbo.��������ϸ��(������ID,ҩƷID,����,����,��������)
		select @buyID,F1,F2,����,F3 
		from @table1,@table2,@table3,
			(select ҩƷID,���� from dbo.ҩƷ) as price
			 where ID1=ID2 and ID2=ID3 and F1 = price.ҩƷID;
	
	declare searchCursor cursor    --����һ���α꣬��ѯ��������������
        for select F1,F2,F3,F4 from @table1,@table2,@table3,@table4
			 where ID1=ID2 and ID2=ID3 and ID3=ID4;
    
    open searchCursor    --��
    
    declare @name varchar(50),@num1 int,
		@date1 varchar(20),@date2 varchar(20)    --����һ�����������ڶ�ȡ�α��е�ֵ
        fetch next from searchCursor into @name,@num1,@date1,@date2;
    
    while @@fetch_status=0    --ѭ����ȡ
        begin
        --print @noToUpdate
			IF EXISTS(Select * From dbo.��� Where 
				ҩƷID = @name and �������� = @date1) 
				begin 
					update dbo.��� set ��� = ��� + @num1 where 
						ҩƷID = @name and �������� = @date1
					fetch next from searchCursor into @name,@num1,@date1,@date2
				end
			else
				begin
					insert into dbo.���  values
						(@name,@date1,@date2,@num1);
					fetch next from searchCursor into @name,@num1,@date1,@date2
				end
        end
    
    close searchCursor    --�ر�
    
   deallocate searchCursor    --ɾ��

	commit transaction innerTrans 
	end try 
	begin catch 
	rollback transaction savepoint --�ع�������� 
	commit transaction innerTrans 
	end catch 
	
	end
go
--���� �����������
--exec dbo.insert_buy_data '00000000004','1','000004',
--	'200002,200001,200006','11,12,13','2017-2-1,2017-2-1,2017-1-3',
--	'2018-1-1,2018-1-1,2018-1-3'
	
	
--�����ۻ�������
--������@saleID �ۻ���ID,
--	@customerID �ͻ�ID,@salerID �ۻ�ԱID,
--	@drugID ҩƷID,@num ����
go
create procedure dbo.insert_sale_data(@saleID varchar(11),
	@customerID varchar(6),@salerID varchar(6),
	@drugID varchar(MAX),@num varchar(MAX))
as
begin
	begin try 
	begin transaction innerTrans 
	save transaction savepoint --�������񱣴�� 
	
	insert into �ۻ���
		values(@saleID,GETDATE(),GETDATE(),
		@customerID,@salerID);
	DECLARE @table1 TABLE (ID1 INT IDENTITY(1,1),F1 varchar(50));--ҩƷID
	DECLARE @table2 TABLE (ID2 INT IDENTITY(1,1),F2 int);--����
	
	insert into @table1 select * from dbo.f_splitstr(@drugID,',');
	insert into @table2 select * from dbo.f_splitstr(@num,',');
	
	declare searchCursor cursor    --����һ���α꣬��ѯ��������������
        for select F1,F2 from @table1,@table2 where ID1=ID2;
    
    open searchCursor    --��
    
    declare @name varchar(50),@num1 int  --����һ�����������ڶ�ȡ�α��е�ֵ
        fetch next from searchCursor into @name,@num1;
    
    while @@fetch_status=0    --ѭ����ȡ
        begin
        --print @noToUpdate
			IF EXISTS(Select * From dbo.��� Where 
				ҩƷID = @name and @num1<=(select sum(���) from dbo.��� Where 
												ҩƷID = @name)) --���еĿ���ܶ���������
			begin
				declare @i int
				while @num1<>0
				begin
					set @i = (select ��� from dbo.��� where @name=ҩƷID and ��������=
							(select MAX(��������) from dbo.��� where @name=ҩƷID ));
					if @i<=@num1 --�����ҩ������or�ոպ�
					begin
						insert into dbo.�ۻ�����ϸ��
							(�ۻ���ID,ҩƷID,����,�ۼ�,��������)
						select @saleID,@name,@i,�ۼ�,a 
						from (select �ۼ� from dbo.ҩƷ where ҩƷID=@name) as price,
							 (select MAX(��������) a from dbo.��� where @name=ҩƷID) as dateBiao;
						delete from dbo.���  where 
							ҩƷID = @name and �������� = (select MAX(��������) 
														from dbo.��� where @name=ҩƷID );
						set @num1 = @num1 - @i;
					end
					else --�����ҩ����
					begin
						insert into dbo.�ۻ�����ϸ��
							(�ۻ���ID,ҩƷID,����,�ۼ�,��������)
						select @saleID,@name,@num1,�ۼ�,a 
						from (select �ۼ� from dbo.ҩƷ where ҩƷID=@name) as price,
							 (select MAX(��������) a from dbo.��� where @name=ҩƷID) as dateBiao;
						update dbo.��� set ���=���-@num1  where 
							ҩƷID = @name and �������� = (select MAX(��������) 
													from dbo.��� where @name=ҩƷID );
						break
					end
				end
				fetch next from searchCursor into @name,@num1
			end
			else --ҩƷ������or����������
				begin
					rollback transaction savepoint --�ع�������� 
					break
				end
        end
    
    close searchCursor    --�ر�
    
   deallocate searchCursor    --ɾ��

	commit transaction innerTrans 
	end try 
	begin catch 
	select error_number() as error_number ,  
             error_message() as error_message --����쳣��Ϣ
	rollback transaction savepoint --�ع�������� 
	commit transaction innerTrans 
	end catch 
	
	end
go
--���� 
--exec dbo.insert_sale_data '00000000005','1','000003',
--	'200002,200001,200006','22,45,61'
	
--���� �����������
--exec dbo.insert_buy_data '00000000007','1','000004',
--	'200002,200001,200006','11,50,13','2017-2-1,2017-1-1,2017-1-3',
--	'2018-1-1,2018-1-1,2018-1-3'


---------------------------
-----Ȩ��
GRANT EXECUTE ON dbo.insert_buy_data TO buyer;

GRANT EXECUTE ON dbo.insert_sale_data To saler;

--------------------------------------------------------
go
CREATE function get_SaleNO()
	Returns int
  AS     
  BEGIN   
   declare @i int
   set @i = ( select Max(�ۻ���ID) from �ۻ���) + 1
   return @i
  END
go
GRANT EXECUTE ON dbo.get_SaleNO TO saler;--saler��ִ��Ȩ��
DENY SELECT ON dbo.f_splitstr TO saler;--ɾ���ָ����Ȩ��
go
--get_SaleNO()�������ܣ���ȡҪ�������ۻ���ID������ȡ��ǰ���ݿ��е����ID��1�󷵻أ�
--���� select dbo.get_SaleNO()

CREATE function get_BuyNO()
	Returns int
  AS     
  BEGIN   
   declare @i int
   set @i = ( select Max(������ID) from ������) + 1
   return @i
  END
go
GRANT EXECUTE ON dbo.get_BuyNO TO buyer;--buyer��ִ��Ȩ��
DENY SELECT ON dbo.f_splitstr TO buyer;--ɾ���ָ����Ȩ��
go
--get_BuyNO()�������ܣ���ȡҪ�����Ľ�����ID������ȡ��ǰ���ݿ��е����ID��1�󷵻أ�
--���� select dbo.get_BuyNO()

CREATE function get_Ա��NO()
	Returns int
  AS     
  BEGIN   
   declare @i int
   set @i = ( select Max(Ա��ID) from Ա��) + 1
   return @i
  END
go
GRANT EXECUTE ON dbo.get_Ա��NO TO shujuku;
go
--get_Ա��NO()�������ܣ���ȡҪ������Ա��ID������ȡ��ǰ���ݿ��е����ID��1�󷵻أ�
--���� select dbo.get_Ա��NO()


--------------------------
--������ڵ�ҩƷ�Ƿ���ڵĴ洢����
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[check_invaildDrug]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT',N'X',N'P'))
DROP procedure [dbo].[check_invaildDrug]
GO
CREATE procedure check_invaildDrug
  AS     
  BEGIN   
	begin try 
	begin transaction innerTrans 
	save transaction savepoint --�������񱣴�� 
	
	declare searchCursor cursor    --����һ���α꣬��ѯ��������������
        for select ҩƷID,��������,��Ч���� from ���;
    
    open searchCursor    --��
    
    declare @ID varchar(6),
		@date1 varchar(20),@date2 varchar(20)    --����һ�����������ڶ�ȡ�α��е�ֵ
        fetch next from searchCursor into @ID,@date1,@date2;
    
    while @@fetch_status=0    --ѭ����ȡ
        begin
			IF  GETDATE()>@date2
				begin 
					IF EXISTS(Select * From dbo.�˳� Where 
						ҩƷID = @ID and �������� = @date1) 
					begin
						declare @num int;
						set @num = (select ��� from ��� 
						where ҩƷID=@ID and ��������=@date1);
						update dbo.�˳� set ��� = ��� + @num where 
						ҩƷID = @ID and �������� = @date1;
						delete from ��� where ҩƷID=@ID and ��������=@date1;
					end
					else
					begin
						insert into �˳� select * from ��� 
						where ҩƷID=@ID and ��������=@date1;
						delete from ��� where ҩƷID=@ID and ��������=@date1;
					end
					fetch next from searchCursor into @ID,@date1,@date2
				end
			else
				begin
					fetch next from searchCursor into @ID,@date1,@date2
				end
        end
    
    close searchCursor    --�ر�
    
   deallocate searchCursor    --ɾ��
	
	commit transaction innerTrans 
	end try 
	begin catch 
	select error_number() as error_number ,  
             error_message() as error_message --����쳣��Ϣ
	rollback transaction savepoint --�ع�������� 
	commit transaction innerTrans 
	end catch 
  END
go
GRANT EXECUTE ON dbo.check_invaildDrug TO shujuku;--����Ա��ִ��Ȩ��
go
--���� exec dbo.check_invaildDrug
--------------------------

------------------------------------------------------
--����Ա�Ľ�������ͼ �� ��Ȩ
create view view_admin_������(������ID,����,ʱ��,����ID,������,����ԱID,����Ա����)
as 
select ������ID,����,ʱ��,����ID,����,����ԱID,����
	from Ա��,������,����
		where ������.����ID=����.����ID and ������.����ԱID=Ա��.Ա��ID;
go
GRANT select on dbo.view_admin_������ to shujuku;
go

--����Ա���ۻ�����ͼ �� ��Ȩ
create view view_admin_�ۻ���(�ۻ���ID,����,ʱ��,�ͻ�ID,�ͻ���,�ۻ�ԱID,�ۻ�Ա����)
as 
select �ۻ���ID,����,ʱ��,�ͻ�.�ͻ�ID,�ͻ�.����,�ۻ�ԱID,Ա��.����
	from Ա��,�ۻ���,�ͻ�
		where �ۻ���.�ͻ�ID=�ͻ�.�ͻ�ID and �ۻ���.�ۻ�ԱID=Ա��.Ա��ID;
go
GRANT select on dbo.view_admin_�ۻ��� to shujuku;
go

--����Ա��ҩƷ����ͼ �� ��Ȩ
create view view_admin_ҩƷ�ܱ� (ҩƷID,ҩ��,����ID,��������,����,�ۼ�,
						����ID,��������,�������)
as 
select ҩƷ.ҩƷID,ҩ��,����ID,����,����,�ۼ�,����.����ID,����,����
	from ҩƷ,����,����,(select ҩƷID,SUM(���) ���� from ��� group by ҩƷID) as �����
		where ҩƷ.����ID=����.ID and ҩƷ.������ID=����.����ID and ҩƷ.ҩƷID=�����.ҩƷID;
go
GRANT select on dbo.view_admin_ҩƷ�ܱ� to shujuku;
go

--����Ա��ҩƷ�������ͼ �� ��Ȩ
create view view_admin_ҩƷ��Ϣ (ҩƷID,ҩ��,����ID,��������,����,�ۼ�,
						����ID,��������)
as 
select ҩƷ.ҩƷID,ҩ��,����ID,����,����,�ۼ�,����.����ID,����
	from ҩƷ,����,����
		where ҩƷ.����ID=����.ID and ҩƷ.������ID=����.����ID;
go
GRANT select on dbo.view_admin_ҩƷ��Ϣ to drugmanager;
go

--�����ͼ
-------------����Ա�� �˳���ͼ �� ��Ȩ
create view view_admin_�˳� (ҩƷID,ҩ��,��������,��Ч��,���)
as 
select ҩƷ.ҩƷID,ҩ��,��������,��Ч����,���
	from ҩƷ,�˳�
		where ҩƷ.ҩƷID=�˳�.ҩƷID;
go
GRANT select on dbo.view_admin_�˳� to shujuku;
go

-------------����Ա�� �����ͼ �� ��Ȩ
create view view_admin_��� (ҩƷID,ҩ��,��������,��Ч��,���)
as 
select ҩƷ.ҩƷID,ҩ��,��������,��Ч����,���
	from ҩƷ,���
		where ҩƷ.ҩƷID=���.ҩƷID;
go
GRANT select on dbo.view_admin_��� to shujuku;
go

-------------����Ա�� ��������ϸ����ͼ �� ��Ȩ
create view view_admin_��������ϸ (������ID,ҩƷID,ҩ��,����,����,��������,����ID,����,����ԱID,����Ա��)
as 
select ��������ϸ��.������ID,��������ϸ��.ҩƷID,ҩ��,����,��������ϸ��.����,��������ϸ��.��������,
		������.����ID,����.����,������.����ԱID,Ա��.����
	from ������,��������ϸ��,ҩƷ,Ա��,����
		where ��������ϸ��.������ID=������.������ID and ��������ϸ��.ҩƷID=ҩƷ.ҩƷID and
			������.����ԱID=Ա��.Ա��ID and ������.����ID=����.����ID;
go
GRANT select on dbo.view_admin_��������ϸ to shujuku;
go

-------------����Ա�� �ۻ�����ϸ����ͼ �� ��Ȩ
create view view_admin_�ۻ�����ϸ (�ۻ���ID,ҩƷID,ҩ��,����,�ۼ�,��������,�ͻ�ID,�ͻ���,�ۻ�ԱID,�ۻ�Ա��)
as 
select �ۻ�����ϸ��.�ۻ���ID,�ۻ�����ϸ��.ҩƷID,ҩ��,����,�ۻ�����ϸ��.�ۼ�,�ۻ�����ϸ��.��������,
		�ۻ���.�ͻ�ID,�ͻ�.����,�ۻ���.�ۻ�ԱID,Ա��.����
	from �ۻ���,�ۻ�����ϸ��,ҩƷ,Ա��,�ͻ�
		where �ۻ�����ϸ��.�ۻ���ID=�ۻ���.�ۻ���ID and �ۻ�����ϸ��.ҩƷID=ҩƷ.ҩƷID and
			�ۻ���.�ۻ�ԱID=Ա��.Ա��ID and �ۻ���.�ͻ�ID=�ͻ�.�ͻ�ID;
go
GRANT select on dbo.view_admin_�ۻ�����ϸ to shujuku;
go

---------------------------------------------
-------����
  create index ҩ������ on ҩƷ(ҩ��);
  create index �������� on ����(����);
  create index �ͻ������� on �ͻ�(����);
go
-----------------------------------------------



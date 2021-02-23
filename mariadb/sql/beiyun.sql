/*
Navicat MySQL Data Transfer

Source Server         : 192.168.31.76
Source Server Version : 50730
Source Host           : 192.168.31.76:3306
Source Database       : beiyun

Target Server Type    : MYSQL
Target Server Version : 50730
File Encoding         : 65001

Date: 2020-05-09 19:43:25
*/
use beiyun;

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for app
-- ----------------------------
DROP TABLE IF EXISTS `app`;
CREATE TABLE `app` (
  `code` varchar(64) NOT NULL,
  `name` varchar(250) NOT NULL,
  `description` text,
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of app
-- ----------------------------
INSERT INTO `app` VALUES ('1', '备云', null, '2019-12-05 06:09:47');
INSERT INTO `app` VALUES ('2', '视云', null, '2019-12-05 06:09:56');

-- ----------------------------
-- Table structure for by_cert_download_token
-- ----------------------------
DROP TABLE IF EXISTS `by_cert_download_token`;
CREATE TABLE `by_cert_download_token` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `user_cert_id` bigint(20) NOT NULL,
  `token` varchar(128) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '1 - normal, 2 - invalid',
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fky_user_id_idx` (`user_id`),
  KEY `fky_user_cert_id_idx` (`user_cert_id`),
  CONSTRAINT `fky_user_cert_id` FOREIGN KEY (`user_cert_id`) REFERENCES `by_user_certs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fky_user_id` FOREIGN KEY (`user_id`) REFERENCES `by_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of by_cert_download_token
-- ----------------------------

-- ----------------------------
-- Table structure for by_exception_log
-- ----------------------------
DROP TABLE IF EXISTS `by_exception_log`;
CREATE TABLE `by_exception_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `module` varchar(250) NOT NULL,
  `service` varchar(255) DEFAULT NULL,
  `parameter` longtext,
  `content` longtext NOT NULL,
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of by_exception_log
-- ----------------------------

-- ----------------------------
-- Table structure for by_fault_domain
-- ----------------------------
DROP TABLE IF EXISTS `by_fault_domain`;
CREATE TABLE `by_fault_domain` (
  `id` varchar(64) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text,
  `level` int(11) NOT NULL DEFAULT '2' COMMENT '故障域级别，1- 盘阵，2-主机，3-机柜， 4-数据中心',
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='故障域';

-- ----------------------------
-- Records of by_fault_domain
-- ----------------------------

-- ----------------------------
-- Table structure for by_fault_domain_has_osd
-- ----------------------------
DROP TABLE IF EXISTS `by_fault_domain_has_osd`;
CREATE TABLE `by_fault_domain_has_osd` (
  `domain_id` varchar(64) NOT NULL,
  `osd_id` varchar(64) NOT NULL,
  PRIMARY KEY (`domain_id`,`osd_id`),
  KEY `fky_osd_id_idx` (`osd_id`),
  CONSTRAINT `fky_domain_id` FOREIGN KEY (`domain_id`) REFERENCES `by_fault_domain` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fky_osd_id` FOREIGN KEY (`osd_id`) REFERENCES `monit_osd` (`uuid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='故障域 - OSD关联关系';

-- ----------------------------
-- Records of by_fault_domain_has_osd
-- ----------------------------

-- ----------------------------
-- Table structure for by_fault_domain_has_volume
-- ----------------------------
DROP TABLE IF EXISTS `by_fault_domain_has_volume`;
CREATE TABLE `by_fault_domain_has_volume` (
  `domain_id` varchar(64) NOT NULL,
  `volume_id` varchar(64) NOT NULL,
  PRIMARY KEY (`domain_id`,`volume_id`),
  CONSTRAINT `fky_domain_id_1` FOREIGN KEY (`domain_id`) REFERENCES `by_fault_domain` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='故障域 - 数据卷关联关系';

-- ----------------------------
-- Records of by_fault_domain_has_volume
-- ----------------------------

-- ----------------------------
-- Table structure for by_group
-- ----------------------------
DROP TABLE IF EXISTS `by_group`;
CREATE TABLE `by_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `gid` varchar(45) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  `group_name` varchar(200) NOT NULL,
  `is_tenant_group` int(11) NOT NULL DEFAULT '0' COMMENT '是否租户对应的组，0 - 管理员新建组，1- 系统自建租户组',
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gid_UNIQUE` (`gid`),
  KEY `fk_group_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_group_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `by_tenant` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of by_group
-- ----------------------------
INSERT INTO `by_group` VALUES ('21', 'QmN4heh6NN', '21', 'Strawberry_Cake group', '1', '2020-02-23 09:12:44');


-- ----------------------------
-- Table structure for by_ldap_config
-- ----------------------------
DROP TABLE IF EXISTS `by_ldap_config`;
CREATE TABLE `by_ldap_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL,
  `basedn` varchar(255) DEFAULT NULL COMMENT '根信息',
  `root` varchar(64) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL COMMENT '公司名',
  `tel` varchar(64) DEFAULT NULL COMMENT '手机或电话',
  `contacts` varchar(255) DEFAULT NULL COMMENT '联系人',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `type` int(2) DEFAULT NULL COMMENT '0: LDAP 1:AD 2:NIS',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for by_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `by_operation_log`;
CREATE TABLE `by_operation_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `foreign_user_id` varchar(100) DEFAULT NULL,
  `uid` varchar(100) NOT NULL,
  `account_type` int(11) NOT NULL DEFAULT '1' COMMENT '与user 表中admin_level 对应\\n1-超级管理员，2-租户管理员，3-普通用户，4- LDAP用户',
  `opt_type` int(11) NOT NULL COMMENT '1- 管理平台登录， 2- 客户端登录，3- 挂载数据卷，4- 创建租户， 5- 设置租户信息，6- 冻结/解冻租户， 7- 设置/取消管理员， 8- 设置租户过期时间， 9- 删除租户，10- 设置租户权限\n11- 创建新用户， 12- 设置租户信息， 13- 冻结/解冻租户，14- 用户修改密码，15- 用户注销，16- 删除用户，17- 发送证书\n20- 客户端登录，21- 客户端请求证书，22- web客户端登录，',
  `opt_content` text COMMENT 'Json 字符串，操作附加信息',
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_uid` (`uid`),
  KEY `idx_foreign_uid` (`foreign_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of by_operation_log
-- ----------------------------

-- ----------------------------
-- Table structure for by_permission
-- ----------------------------
DROP TABLE IF EXISTS `by_permission`;
CREATE TABLE `by_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `perm_name` varchar(250) NOT NULL,
  `description` text,
  `default_value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `per_UNIQUE` (`perm_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of by_permission
-- ----------------------------
INSERT INTO `by_permission` VALUES ('1', 'Statistics', '统计分析', '0');
INSERT INTO `by_permission` VALUES ('2', 'Node', '数据节点管理', '0');
INSERT INTO `by_permission` VALUES ('3', 'Volume', '逻辑数据卷', '0');
INSERT INTO `by_permission` VALUES ('4', 'PhysicalStoragePool', '物理存储池', '0');
INSERT INTO `by_permission` VALUES ('5', 'Tenant', '租户管理', '0');
INSERT INTO `by_permission` VALUES ('6', 'Maintain', '维护管理', '0');
INSERT INTO `by_permission` VALUES ('7', 'Qos', 'Qos配置', '0');
INSERT INTO `by_permission` VALUES ('8', 'DS', '数据同步', '0');
INSERT INTO `by_permission` VALUES ('9', 'FaultDomain', '故障域设置', '0');
INSERT INTO `by_permission` VALUES ('10', 'Log', '日志管理', '0');
INSERT INTO `by_permission` VALUES ('11', 'Clustering', '集群管理', '0');
INSERT INTO `by_permission` VALUES ('12', 'Home', '个人中心', '0');
INSERT INTO `by_permission` VALUES ('13', 'SubAdmin', '管理员管理', '0');
INSERT INTO `by_permission` VALUES ('14', 'BarrelsUser', '桶用户', '0');
INSERT INTO `by_permission` VALUES ('15', 'BucketList', '存储桶列表', '0');
INSERT INTO `by_permission` VALUES ('16', 'Monit', '运行监控', '0');

-- ----------------------------
-- Table structure for by_permission_has_user
-- ----------------------------
DROP TABLE IF EXISTS `by_permission_has_user`;
CREATE TABLE `by_permission_has_user` (
  `permission_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `perm_value` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`permission_id`,`user_id`),
  KEY `fk_permission_has_tenant_tenant1_idx` (`user_id`),
  KEY `fk_permission_has_tenant_permission1_idx` (`permission_id`),
  CONSTRAINT `fk_permission_has_tenant_permission1` FOREIGN KEY (`permission_id`) REFERENCES `by_permission` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_permission_has_tenant_tenant1` FOREIGN KEY (`user_id`) REFERENCES `by_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of by_permission_has_user
-- ----------------------------
insert into by_permission_has_user values(1, 30, 1);
insert into by_permission_has_user values(2, 30, 1);
insert into by_permission_has_user values(3, 30, 1);
insert into by_permission_has_user values(4, 30, 1);
insert into by_permission_has_user values(5, 30, 1);
insert into by_permission_has_user values(6, 30, 1);
insert into by_permission_has_user values(7, 30, 1);
insert into by_permission_has_user values(8, 30, 1);
insert into by_permission_has_user values(9, 30, 1);
insert into by_permission_has_user values(10, 30, 1);
insert into by_permission_has_user values(11, 30, 1);
insert into by_permission_has_user values(12, 30, 1);
insert into by_permission_has_user values(13, 30, 1);
insert into by_permission_has_user values(14, 30, 1);
insert into by_permission_has_user values(15, 30, 1);
insert into by_permission_has_user values(16, 30, 1);

-- ----------------------------
-- Table structure for by_tenant
-- ----------------------------
DROP TABLE IF EXISTS `by_tenant`;
CREATE TABLE `by_tenant` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tenant_admin_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `address` text,
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '1- 正常，2- 冻结 3-删除',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '0- 文件，1- 对象 ',
  `quota` bigint(20) NOT NULL COMMENT '租户总限额，单位：G',
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expire_datetime` datetime DEFAULT '2099-12-31 00:00:00',
  `config_file_path` text,
  `mount_dirs` text,
  `is_started` int(11) DEFAULT '1' COMMENT '0:启动 1：未启动',
  PRIMARY KEY (`id`),
  KEY `fk_tenant_user1_idx` (`tenant_admin_id`),
  CONSTRAINT `fk_tenant_user1` FOREIGN KEY (`tenant_admin_id`) REFERENCES `by_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of by_tenant
-- ----------------------------
INSERT INTO `by_tenant` VALUES ('21', '30', '21', 'Strawberry_Cake', '新康园', '2', 0, '128', '2020-02-23 09:12:44', '2021-02-22 00:00:00', '','',1);

-- ----------------------------
-- Table structure for by_user
-- ----------------------------
DROP TABLE IF EXISTS `by_user`;
CREATE TABLE `by_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(64) NOT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `username` varchar(250) NOT NULL,
  `password` varchar(250) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '1- 正常，2- 冻结',
  `name` varchar(200) NOT NULL COMMENT '姓名',
  `email` varchar(250) NOT NULL,
  `cellphone` varchar(20) DEFAULT NULL,
  `quota` bigint(20) NOT NULL DEFAULT '128' COMMENT '用户硬盘空间限额，单位：G',
  `admin_level` int(11) NOT NULL DEFAULT '3' COMMENT '是否超级管理员 1-超级管理员，2-租户管理员，3-普通用户',
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  KEY `fk_user_tenant1_idx` (`tenant_id`),
  CONSTRAINT `fk_user_tenant1` FOREIGN KEY (`tenant_id`) REFERENCES `by_tenant` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of by_user
-- ----------------------------
INSERT INTO `by_user` VALUES ('30', '6ddbb0e3-84be-4cdf-8577-add1d584df37', '21', 'Strawberry', '96e79218965eb72c92a549dd5a330112', '2', 'Strawberry_cake', '13835409638@qq.com', '13835409638', '128', '1', '2020-03-31 06:40:00');

-- ----------------------------
-- Table structure for by_user_certs
-- ----------------------------
DROP TABLE IF EXISTS `by_user_certs`;
CREATE TABLE `by_user_certs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `serial_no` varchar(45) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '1- 正常，2- 吊销， 3-过期',
  `type` int(11) NOT NULL DEFAULT '1' COMMENT '1- 服务端使用，2-客户端证书(密码随机生成)',
  `p12_path` text,
  `pem_cert_path` text,
  `pem_key_path` text,
  `pem_ca_cert_path` text,
  `key_key_path` text,
  `crt_cert_path` text,
  `create_dateteime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expire_datetime` datetime NOT NULL,
  `ldap_user_id` varchar(255) DEFAULT NULL,
  `ldap_config_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `serial_no_UNIQUE` (`serial_no`),
  KEY `fk_user_certs_user1_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=217 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of by_user_certs
-- ----------------------------

-- ----------------------------
-- Table structure for by_user_has_group
-- ----------------------------
DROP TABLE IF EXISTS `by_user_has_group`;
CREATE TABLE `by_user_has_group` (
  `user_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`group_id`),
  KEY `fk_user_has_group_group1_idx` (`group_id`),
  KEY `fk_user_has_group_user1_idx` (`user_id`),
  CONSTRAINT `fk_user_has_group_group1` FOREIGN KEY (`group_id`) REFERENCES `by_group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_group_user1` FOREIGN KEY (`user_id`) REFERENCES `by_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of by_user_has_group
-- ----------------------------
INSERT INTO `by_user_has_group` VALUES ('30', '21');

-- ----------------------------
-- Table structure for by_verify_code
-- ----------------------------
DROP TABLE IF EXISTS `by_verify_code`;
CREATE TABLE `by_verify_code` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `verify_code` varchar(20) NOT NULL,
  `type` int(11) NOT NULL COMMENT '1- 修改Email',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '1- 正常， 2-已使用，3-已过期',
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `verify_code_UNIQUE` (`verify_code`),
  KEY `idx_create_dt` (`create_datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of by_verify_code
-- ----------------------------

-- ----------------------------
-- Table structure for conf_comm_log
-- ----------------------------
DROP TABLE IF EXISTS `conf_comm_log`;
CREATE TABLE `conf_comm_log` (
  `id` bigint(20) NOT NULL,
  `src_id` varchar(64) NOT NULL COMMENT '服务-> 终端： src_id 存入 server_id，dst_id 存入terminal_id， 终端->服务：src_id 存入 terminal_id, dst_id存入 server_id',
  `dest_id` varchar(64) NOT NULL COMMENT '服务-> 终端： src_id 存入 server_id，dst_id 存入terminal_id， 终端->服务：src_id 存入 terminal_id, dst_id存入 server_id。多台配置服务主机并行处理时，',
  `serial_no` varchar(64) DEFAULT NULL COMMENT '除终端注册 消息以外，其他所有通讯都必须具有序列号。',
  `param` longtext NOT NULL,
  `direction` int(11) NOT NULL COMMENT '1: 服务-> 终端, 2: 终端 -> 服务端',
  `create_datetime` datetime NOT NULL,
  `is_success` int(11) DEFAULT NULL COMMENT '0- 处理失败，可能产生异常，1- 处理成功',
  `exception_log_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_exception_log_id_idx` (`exception_log_id`),
  CONSTRAINT `fk_exception_log_id` FOREIGN KEY (`exception_log_id`) REFERENCES `support_exceptionlog` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='服务器 - 终端上下行通讯的日志记录';

-- ----------------------------
-- Records of conf_comm_log
-- ----------------------------

-- ----------------------------
-- Table structure for conf_dir_field
-- ----------------------------
DROP TABLE IF EXISTS `conf_dir_field`;
CREATE TABLE `conf_dir_field` (
  `id` int(11) NOT NULL,
  `conf_cn_name` varchar(250) DEFAULT NULL,
  `conf_name` varchar(250) NOT NULL,
  `conf_value` text,
  `value_range` text,
  `conf_type` varchar(255) DEFAULT NULL,
  `conf_note` text,
  `is_editable` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of conf_dir_field
-- ----------------------------
INSERT INTO `conf_dir_field` VALUES ('1', '用户密码', 'admin_password', 'passphrase', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_dir_field` VALUES ('2', '元数据库 基本目录', 'babudb.baseDir', '/var/lib/xtreemfs/dir/database', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_dir_field` VALUES ('3', '元数据库数据存储文件名称', 'babudb.cfgFile', 'config.db', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_dir_field` VALUES ('4', '元数据库 检查间隔', 'babudb.checkInterval', '300', '{\"type\": \"Integer\",\"max_integer\": 300,\"min_integer\":0}', 'Integer', null, '0');
INSERT INTO `conf_dir_field` VALUES ('5', '元数据库是否压缩', 'babudb.compression', 'false', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', '是否开启数据压缩', '1');
INSERT INTO `conf_dir_field` VALUES ('6', '元数据库调试信息输出等级', 'babudb.debug.level', '4', '{\"type\": \"Integer\",\"max_integer\": 7,\"min_integer\":0}', 'Integer', 'babu调试信息输出级别，数字越大输出级别越高', '1');
INSERT INTO `conf_dir_field` VALUES ('7', '元数据库日志目录', 'babudb.logDir', '/var/lib/xtreemfs/dir/db-log', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_dir_field` VALUES ('8', '元数据库最大日志文件大小', 'babudb.maxLogfileSize', '16777216', '{\"type\":\"Integer\"}', 'Integer', '最大日志文件大小,单位 bytes', '0');
INSERT INTO `conf_dir_field` VALUES ('9', '元数据库同步时间(毫秒)', 'babudb.pseudoSyncWait', '200', '{\"type\": \"Integer\",\"max_integer\": 500,\"min_integer\":0}', 'Integer', '单位:毫秒,数据盘日志同步延迟,延时越大同一批次同步的数据越多.0 表示,进行实时同步', '0');
INSERT INTO `conf_dir_field` VALUES ('10', '元数据库同步模式', 'babudb.sync', ' FDATASYNC', '{\"type\": \"String\",\"options\": [\"ASYNC\", \"SYNC_WRITE_METADATA\",\"SYNC_WRITE\",\"FDATASYNC\",\" FSYNC\"]}', 'String', null, '0');
INSERT INTO `conf_dir_field` VALUES ('11', '可在队列中请求的最大数量', 'babudb.worker.maxQueueLength', '250', '{\"type\":\"Integer\"}', 'Integer', null, '0');
INSERT INTO `conf_dir_field` VALUES ('12', '工作线程数', 'babudb.worker.numThreads', '0', '{\"type\":\"Integer\"}', 'Integer', null, '0');
INSERT INTO `conf_dir_field` VALUES ('13', '调试信息输出等级', 'debug.level', '6', '{\"type\": \"Integer\",\"max_integer\": 7,\"min_integer\":0}', 'Integer', null, '1');
INSERT INTO `conf_dir_field` VALUES ('14', '调试信息输出类别', 'debug.categories', 'all', '{\"type\": \"String\",\"options\": [\"all\", \"lifecycle\",\"net\",\"auth\",\" stage\",\"proc\",\"db\",\"misc\"]}', 'String', null, '1');
INSERT INTO `conf_dir_field` VALUES ('15', 'http端口', 'http_port', '30638', '{\"type\": \"Integer\",\"max_integer\": 65535,\"min_integer\":1}', 'Integer', null, '1');
INSERT INTO `conf_dir_field` VALUES ('16', '指定服务地址', 'listen.address', '0.0.0.0', '{\"type\":\"Ip\"}', 'String', null, '1');
INSERT INTO `conf_dir_field` VALUES ('17', '指定服务端口', 'listen.port', '32638', '{\"type\": \"Integer\",\"max_integer\": 65535,\"min_integer\":1}', 'Integer', '指定服务端口号', '1');
INSERT INTO `conf_dir_field` VALUES ('18', '是否开启目录服务内置的监控功能', 'monitoring', 'true', '{\"type\":\"Boolean\"}', 'Boolean', '是否开启DIR服务内置的监控功能', '1');
INSERT INTO `conf_dir_field` VALUES ('19', '设置邮件发送程序系统绝对路径', 'monitoring.email.program', '/usr/sbin/sendmail', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_dir_field` VALUES ('20', '告警通知邮件接收人', 'monitoring.email.receiver', null, '{\"type\":\"Email\"}', 'String', null, '1');
INSERT INTO `conf_dir_field` VALUES ('21', '告警邮件发送人', 'monitoring.email.sender', 'user', '{\"type\":\"Email\"}', 'String', null, '1');
INSERT INTO `conf_dir_field` VALUES ('22', '通知发送的最大数量', 'monitoring.max_warnings', '1', '{\"type\":\"Integer\"}', 'Integer', '每个服务每种告警,通知发送的最大数量', '1');
INSERT INTO `conf_dir_field` VALUES ('23', '政策目录', 'policy_dir', '/etc/xos/xtreemfs/policies', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_dir_field` VALUES ('24', '是否启用SNMP协议', 'snmp.enabled', 'false', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', null, '0');
INSERT INTO `conf_dir_field` VALUES ('25', '指定SNMP代理监听的主机IP', 'snmp.address', 'localhost', '{\"type\":\"Ip\"}', 'String', null, '0');
INSERT INTO `conf_dir_field` VALUES ('26', '指定SNMP代理监听的端口', 'snmp.port', '34638', '{\"type\": \"Integer\",\"max_integer\": 65535,\"min_integer\":1}', 'Integer', null, '0');
INSERT INTO `conf_dir_field` VALUES ('27', '指定SNMP访问的ACL文件位置', 'snmp.aclfile', '/etc/xos/xtreemfs/snmp.acl', '{\"type\":\"String\"}', 'String', '指定SNMP访问的ACL文件位置', '0');
INSERT INTO `conf_dir_field` VALUES ('28', '是否启用SSL协议', 'ssl.enabled', 'true', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', null, '1');
INSERT INTO `conf_dir_field` VALUES ('29', '网络SSL', 'ssl.grid_ssl', 'false', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', null, '1');
INSERT INTO `conf_dir_field` VALUES ('30', 'SSL服务目录', 'ssl.service_creds', '/etc/xos/xtreemfs/truststore/certs/dir.p12', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_dir_field` VALUES ('31', 'SSL服务容器', 'ssl.service_creds.container', 'pkcs12', '{\"type\": \"String\",\"options\": [\"pkcs12\", \"JKS\"]}', 'String', null, '1');
INSERT INTO `conf_dir_field` VALUES ('32', 'SSL服务输出', 'ssl.service_creds.pw', '11111111', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_dir_field` VALUES ('33', 'SSL证书目录', 'ssl.trusted_certs', '/etc/xos/xtreemfs/truststore/certs/trusted.jks', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_dir_field` VALUES ('34', 'SSL证书容器', 'ssl.trusted_certs.container', 'jks', '{\"type\": \"String\",\"options\": [\"pkcs12\", \"JKS\"]}', 'String', null, '1');
INSERT INTO `conf_dir_field` VALUES ('35', 'SSL证书管理', 'ssl.trust_manager', 'org.xtreemfs.auth.plugin.SSLX509TrustManager', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_dir_field` VALUES ('36', 'SSL证书输出', 'ssl.trusted_certs.pw', '11111111', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_dir_field` VALUES ('37', '唯一标识符', 'uuid', null, '{\"type\":\"String\"}', 'String', '每个节点自动生成', '0');
INSERT INTO `conf_dir_field` VALUES ('38', '启动等待目录时间', 'startup.wait_for_dir', '30', '{\"type\":\"Integer\"}', 'Integer', null, '1');
INSERT INTO `conf_dir_field` VALUES ('39', '元数据库调试信息输出类别', 'babudb.debug.category', 'all', '{\"type\": \"String\",\"options\": [\"all\", \"lifecycle\",\"net\",\"auth\",\" stage\",\"proc\",\"db\",\"misc\"]}', 'String', null, '0');
INSERT INTO `conf_dir_field` VALUES ('40', '元数据库最大记录数', 'babudb.maxNumRecordsPerBlock', '16', '{\"type\":\"Integer\"}', 'Integer', null, '0');
INSERT INTO `conf_dir_field` VALUES ('41', '元数据库最大记录文件大小', 'babudb.maxBlockFileSize', '52428800', '{\"type\":\"Integer\"}', 'Integer', null, '0');
INSERT INTO `conf_dir_field` VALUES ('42', '元数据库插件', 'babudb.plugin.0', '/etc/xos/xtreemfs/server-repl-plugin/dir.properties', '{\"type\":\"String\"}', 'String', null, '0');

-- ----------------------------
-- Table structure for conf_mrc_field
-- ----------------------------
DROP TABLE IF EXISTS `conf_mrc_field`;
CREATE TABLE `conf_mrc_field` (
  `id` int(11) NOT NULL,
  `conf_cn_name` varchar(250) DEFAULT NULL,
  `conf_name` varchar(250) NOT NULL,
  `conf_value` text,
  `value_range` text,
  `conf_type` varchar(255) DEFAULT NULL,
  `conf_note` text,
  `is_editable` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of conf_mrc_field
-- ----------------------------
INSERT INTO `conf_mrc_field` VALUES ('1', '用户密码', 'admin_password', 'passphrase', '{\"type\":\"String\"}', 'String', '原后台界面管理员密码,不需在配置界面中显示,设置默认密码', '0');
INSERT INTO `conf_mrc_field` VALUES ('2', '身份验证提供者', 'authentication_provider', 'org.xtreemfs.common.auth.XsfsX509AuthProvider', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('3', '元数据库基本目录', 'babudb.baseDir', '/var/lib/xtreemfs/mrc/database', '{\"type\":\"String\"}', 'String', '目录服务或MRC将在其中存储其数据库的目录。如果两个服务都驻留在同一台机器上，则该目录不应与任何OSD数据处于同一分区上。否则，如果分区用完可用磁盘空间，可能会发生死锁', '0');
INSERT INTO `conf_mrc_field` VALUES ('4', '元数据库数据存储文件名称', 'babudb.cfgFile', 'config.db', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('5', '元数据库检查间隔', 'babudb.checkInterval', '300', '{\"type\": \"Integer\",\"max_integer\": 300,\"min_integer\":0}', 'Integer', '自动检查点两次检查磁盘日志大小之间的秒数。将此值设置为0可禁用自动检查点', '0');
INSERT INTO `conf_mrc_field` VALUES ('6', '元数据库是否压缩', 'babudb.compression', 'false', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', '是否开启数据压缩', '1');
INSERT INTO `conf_mrc_field` VALUES ('7', '元数据库调试信息输出等级', 'babudb.debug.level', '4', '{\"type\": \"Integer\",\"max_integer\": 7,\"min_integer\":0}', 'Integer', 'babu调试信息输出级别，数字越大输出级别越高。', '0');
INSERT INTO `conf_mrc_field` VALUES ('8', '元数据库日志目录', 'babudb.logDir', '/var/lib/xtreemfs/mrc/db-log', '{\"type\":\"String\"}', 'String', '日志文件目录', '0');
INSERT INTO `conf_mrc_field` VALUES ('9', '元数据库最大日志文件大小', 'babudb.maxLogfileSize', '16777216', '{\"type\":\"Integer\"}', 'Integer', '最大日志文件大小，单位 bytes', '0');
INSERT INTO `conf_mrc_field` VALUES ('10', '元数据库同步时间(毫秒)', 'babudb.pseudoSyncWait', '0', '{\"type\": \"Integer\",\"max_integer\": 500,\"min_integer\":0}', 'Integer', '单位:毫秒,数据盘日志同步延迟,延时越大同一批次同步的数据越多.0 表示,进行实时同步', '0');
INSERT INTO `conf_mrc_field` VALUES ('11', '元数据库同步模式', 'babudb.sync', 'ASYNC', '{\"type\": \"String\",\"options\": [\"ASYNC\", \"SYNC_WRITE_METADATA\",\"SYNC_WRITE\",\"FDATASYNC\",\" FSYNC\"]}', 'String', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('12', '可在队列中请求的最大数量', 'babudb.worker.maxQueueLength', '250', '{\"type\":\"Integer\"}', 'Integer', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('13', '工作线程数', 'babudb.worker.numThreads', '0', '{\"type\":\"Integer\"}', 'Integer', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('14', '注册服务分发给存储服务用于数据签名的token', 'capability_secret', 'secretPassphrase', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('15', '超时时间', 'capability_timeout', '600', '{\"type\":\"Integer\"}', 'Integer', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('16', '调试信息输出等级', 'debug.level', '6', '{\"type\": \"Integer\",\"max_integer\": 7,\"min_integer\":0}', 'Integer', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('17', '调试信息输出类别', 'debug.categories', 'all', '{\"type\": \"String\",\"options\": [\"all\", \"lifecycle\",\"net\",\"auth\",\" stage\",\"proc\",\"db\",\"misc\"]}', 'String', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('18', '目录服务的IP地址或主机名', 'dir_service.host', 'localhost', '{\"type\":\"Ip\"}', 'String', 'DIR服务的服务的IPIP地址或主机名地址或主机名', '1');
INSERT INTO `conf_mrc_field` VALUES ('19', '目录服务的端口', 'dir_service.port', '32638', '{\"type\": \"Integer\",\"max_integer\": 65535,\"min_integer\":1}', 'Integer', 'DIR服务的端口号服务的端口号', '0');
INSERT INTO `conf_mrc_field` VALUES ('20', '主机名', 'hostname', 'foo.bar.com', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('21', 'http端口', 'http_port', '30636', '{\"type\":\"Integer\"}', 'Integer', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('22', '指定服务地址', 'listen.address', '0.0.0.0', '{\"type\":\"Ip\"}', 'String', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('23', '指定服务端口', 'listen.port', '32636', '{\"type\": \"Integer\",\"max_integer\": 65535,\"min_integer\":1}', 'Integer', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('24', '当前服务与系统时钟同步间隔', 'local_clock_renewal', '0', '{\"type\":\"Integer\"}', 'Integer', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('25', '关闭间隔时间', 'no_atime', 'true', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('26', '存储服务检查间隔', 'osd_check_interval', '10', '{\"type\": \"Integer\"}', 'Integer', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('27', '政策目录', 'policy_dir', '/etc/xos/xtreemfs/policies', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('28', '注册服务,存储服务与从目录服务进行时间同步的间隔', 'remote_time_sync', '60000', '{\"type\":\"Integer\"}', 'Integer', 'MRC,OSD服务与从DIR服务进行时间同步的间隔', '1');
INSERT INTO `conf_mrc_field` VALUES ('29', '开启snmp.enabled选项同时需要指定SNMP代理', 'snmp.enabled', 'true', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', '开启snmp.enabled选项同时需要指定SNMP代理', '0');
INSERT INTO `conf_mrc_field` VALUES ('30', '指定SNMP代理监听的主机IP', 'snmp.address', 'localhost', '{\"type\": \"Ip\"}', 'String', '指定SNMP代理监听的主机IP', '0');
INSERT INTO `conf_mrc_field` VALUES ('31', '指定SNMP代理监听的端口', 'snmp.port', '34636', '{\"type\": \"Integer\",\"max_integer\": 65535,\"min_integer\":1}', 'Integer', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('32', '指定SNMP访问的ACL文件位置', 'snmp.aclfile', '/etc/xos/xtreemfs/snmp.acl', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('33', '是否启用SSL协议', 'ssl.enabled', 'true', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('34', '网络SSL', 'ssl.grid_ssl', 'false', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('35', 'SSL服务目录', 'ssl.service_creds', '/etc/xos/xtreemfs/truststore/certs/mrc.p12', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('36', 'SSL服务容器', 'ssl.service_creds.container', 'pkcs12', '{\"type\": \"String\",\"options\": [\"pkcs12\", \"JKS\"]}', 'String', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('37', 'SSL服务输出', 'ssl.service_creds.pw', '11111111', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('38', 'SSL证书目录', 'ssl.trusted_certs', '/etc/xos/xtreemfs/truststore/certs/trusted.jks', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('39', 'SSL证书容器', 'ssl.trusted_certs.container', 'jks', '{\"type\": \"String\",\"options\": [\"pkcs12\", \"JKS\"]}', 'String', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('40', 'SSL证书管理', 'ssl.trust_manager', 'org.xtreemfs.auth.plugin.SSLX509TrustManager', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('41', 'SSL证书输出', 'ssl.trusted_certs.pw', '11111111', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_mrc_field` VALUES ('42', '唯一标识符', 'uuid', null, '{\"type\":\"String\"}', 'String', '每个节点自动生成', '0');
INSERT INTO `conf_mrc_field` VALUES ('43', '元数据库调试信息输出类别', 'babudb.debug.category', 'all', '{\"type\": \"String\",\"options\": [\"all\", \"lifecycle\",\"net\",\"auth\",\" stage\",\"proc\",\"db\",\"misc\"]}', 'String', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('44', '元数据库最大记录数', 'babudb.maxNumRecordsPerBlock', '16', '{\"type\": \"Integer\"}', 'Integer', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('45', '元数据库最大记录文件大小', 'babudb.maxBlockFileSize', '52428800', '{\"type\": \"Integer\"}', 'Integer', null, '0');
INSERT INTO `conf_mrc_field` VALUES ('46', '元数据库插件', 'babudb.plugin.0', '/etc/xos/xtreemfs/server-repl-plugin/mrc.properties', '{\"type\":\"String\"}', 'String', null, '0');

-- ----------------------------
-- Table structure for conf_osd_field
-- ----------------------------
DROP TABLE IF EXISTS `conf_osd_field`;
CREATE TABLE `conf_osd_field` (
  `id` int(11) NOT NULL,
  `conf_cn_name` varchar(250) DEFAULT NULL,
  `conf_name` varchar(250) DEFAULT NULL,
  `conf_value` text,
  `value_range` text,
  `conf_type` varchar(255) DEFAULT NULL,
  `conf_note` text,
  `is_editable` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of conf_osd_field
-- ----------------------------
INSERT INTO `conf_osd_field` VALUES ('1', '注册服务分发给存储服务用于数据签名的token', 'capability_secret', 'secretPassphrase', '{\"type\":\"String\"}', 'String', 'MRC分发给一个或多个OSD服务用于数据签名的token', '1');
INSERT INTO `conf_osd_field` VALUES ('2', '开启数据 sums 验证', 'checksums.enabled', 'false', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', '开启数据sums验证', '0');
INSERT INTO `conf_osd_field` VALUES ('3', '如果开启 sums 验证，必须设置验证算法', 'checksums.algorithm', 'Adler32', '{\"type\": \"String\",\"options\": [\"Adler32\", \"CRC32\"]}', 'String', '如果开启sums验证,必须设置验证算法', '0');
INSERT INTO `conf_osd_field` VALUES ('4', '调试信息输出等级', 'debug.level', '6', '{\"type\": \"Integer\",\"max_integer\": 7,\"min_integer\":0}', 'Integer', null, '1');
INSERT INTO `conf_osd_field` VALUES ('5', '调试信息输出类别', 'debug.categories', 'all', '{\"type\": \"String\",\"options\": [\"all\", \"lifecycle\",\"net\",\"auth\",\" stage\",\"proc\",\"db\",\"misc\"]}', 'String', null, '1');
INSERT INTO `conf_osd_field` VALUES ('6', '目录服务的IP地址或主机名', 'dir_service.host', 'localhost', '{\"type\": \"Ip\"}', 'String', 'DIR服务的服务的IPIP地址或主机名地址或主机名', '1');
INSERT INTO `conf_osd_field` VALUES ('7', '目录服务的端口', 'dir_service.port', '32638', '{\"type\": \"Integer\",\"max_integer\": 65535,\"min_integer\":1}', 'Integer', 'DIR服务的端口号服务的端口号', '0');
INSERT INTO `conf_osd_field` VALUES ('8', '主机名', 'hostname', 'foo.bar.com', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_osd_field` VALUES ('9', 'http端口', 'http_port', '30640', '{\"type\": \"Integer\",\"max_integer\": 65535,\"min_integer\":1}', 'Integer', '指定HTTP服务监听的端口', '1');
INSERT INTO `conf_osd_field` VALUES ('10', '指定服务地址', 'listen.address', '0.0.0.0', '{\"type\":\"Ip\"}', 'String', null, '1');
INSERT INTO `conf_osd_field` VALUES ('11', '指定服务端口', 'listen.port', '32640', '{\"type\": \"Integer\",\"max_integer\": 65535,\"min_integer\":1}', 'Integer', null, '1');
INSERT INTO `conf_osd_field` VALUES ('12', '当前服务与系统时钟同步间隔', 'local_clock_renewal', '0', '{\"type\":\"Integer\"}', 'Integer', '单位:毫秒,当前服务与系统时钟同步间隔', '1');
INSERT INTO `conf_osd_field` VALUES ('13', '目录服务对象', 'object_dir', '/var/lib/xtreemfs/objs/', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_osd_field` VALUES ('14', '目录服务政策', 'policy_dir', '/etc/xos/xtreemfs/policies', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_osd_field` VALUES ('15', '注册服务,存储服务与从目录服务进行时间同步的间隔', 'remote_time_sync', '60000', '{\"type\":\"Integer\"}', 'Integer', 'MRC,OSD服务与从DIR服务进行时间同步的间隔', '1');
INSERT INTO `conf_osd_field` VALUES ('16', '可用空间', 'report_free_space', 'true', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', null, '1');
INSERT INTO `conf_osd_field` VALUES ('17', 'socket通讯缓冲区大小', 'socket.send_buffer_size', '262144', '{\"type\":\"Integer\"}', 'Integer', '单位:byte,socket通讯缓冲区大小,默认-1表示128K,正整数', '1');
INSERT INTO `conf_osd_field` VALUES ('18', '开启snmp.enabled选项同时需要指定SNMP代理', 'snmp.enabled', 'true', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', null, '1');
INSERT INTO `conf_osd_field` VALUES ('19', '指定SNMP代理监听的主机IP', 'snmp.address', 'localhost', '{\"type\":\"Ip\"}', 'String', null, '0');
INSERT INTO `conf_osd_field` VALUES ('20', '指定SNMP代理监听的端口', 'snmp.port', '34640', '{\"type\": \"Integer\",\"max_integer\": 65535,\"min_integer\":1}', 'Integer', null, '0');
INSERT INTO `conf_osd_field` VALUES ('21', '指定SNMP访问的ACL文件位置', 'snmp.aclfile', '/etc/xos/xtreemfs/snmp.acl', '{\"type\":\"String\"}', 'String', '指定SNMP访问的ACL 文件位置', '1');
INSERT INTO `conf_osd_field` VALUES ('22', '是否启用SSL协议', 'ssl.enabled', 'true', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', null, '1');
INSERT INTO `conf_osd_field` VALUES ('23', '网络SSL', 'ssl.grid_ssl', 'false', '{\"type\": \"Boolean\",\"options\": [\"true\", \"false\"]}', 'Boolean', null, '1');
INSERT INTO `conf_osd_field` VALUES ('24', 'SSL服务目录', 'ssl.service_creds', '/etc/xos/xtreemfs/truststore/certs/osd.p12', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_osd_field` VALUES ('25', 'SSL服务容器', 'ssl.service_creds.container', 'pkcs12', '{\"type\": \"String\",\"options\": [\"pkcs12\", \"JKS\"]}', 'String', null, '1');
INSERT INTO `conf_osd_field` VALUES ('26', 'SSL服务输出', 'ssl.service_creds.pw', '11111111', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_osd_field` VALUES ('27', 'SSL证书目录', 'ssl.trusted_certs', '/etc/xos/xtreemfs/truststore/certs/trusted.jks', '{\"type\":\"String\"}', 'String', null, '0');
INSERT INTO `conf_osd_field` VALUES ('28', 'SSL证书容器', 'ssl.trusted_certs.container', 'jks', '{\"type\": \"String\",\"options\": [\"pkcs12\", \"JKS\"]}', 'String', null, '1');
INSERT INTO `conf_osd_field` VALUES ('29', 'SSL证书管理', 'ssl.trust_manager', 'org.xtreemfs.auth.plugin.SSLX509TrustManager', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_osd_field` VALUES ('30', 'SSL证书输出', 'ssl.trusted_certs.pw', '11111111', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_osd_field` VALUES ('31', '启动等待目录时间', 'startup.wait_for_dir', '30', '{\"type\":\"Integer\"}', 'Integer', null, '1');
INSERT INTO `conf_osd_field` VALUES ('32', '存储线程', 'storage_threads', '1', '{\"type\":\"Integer\"}', 'Integer', null, '1');
INSERT INTO `conf_osd_field` VALUES ('33', '唯一标识符', 'uuid', null, '{\"type\":\"String\"}', 'String', '每个节点自动生成', '0');
INSERT INTO `conf_osd_field` VALUES ('34', 'socket接受缓冲区大小', 'socket.recv_buffer_size', '262144', '{\"type\":\"Integer\"}', 'Integer', null, '1');
INSERT INTO `conf_osd_field` VALUES ('35', '用户密码', 'admin_password', 'passphrase', '{\"type\":\"String\"}', 'String', null, '1');
INSERT INTO `conf_osd_field` VALUES ('36', '检查状态', 'health_check', '/usr/share/xtreemfs/osd_health_check.sh', '{\"type\":\"String\"}', 'String', null, '0');

-- ----------------------------
-- Table structure for conf_service_config
-- ----------------------------
DROP TABLE IF EXISTS `conf_service_config`;
CREATE TABLE `conf_service_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `service_type` int(11) NOT NULL COMMENT '1- DIR, 2- MRC, 3- OSD',
  `terminal_id` varchar(64) NOT NULL COMMENT '服务所在 设备（物理机、虚机、docker）配置终端ID。  服务配置与配置终端记录成 多对一关系。',
  `conf_cn_name` varchar(250) NOT NULL,
  `conf_name` varchar(250) NOT NULL COMMENT '配置项英文名称作为， config pair 的key使用',
  `conf_value` text NOT NULL,
  `value_range` text NOT NULL COMMENT '取值范围，json字符串表示\n{\n    "type": "",     // string, ip_address, email, integer boolean (0 / 1), enum\n    "max_integer": "", // integer 类型最大值\n    "min_integer": "",  // integer 类型最小值\n    "enum_options": ["value1", "value2", ... ]\n}',
  `conf_description` text NOT NULL COMMENT '配置详细描述信息',
  `create_datetime` datetime NOT NULL,
  `is_editable` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_biz_unq` (`terminal_id`,`service_type`,`conf_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of conf_service_config
-- ----------------------------

-- ----------------------------
-- Table structure for conf_service_info
-- ----------------------------
DROP TABLE IF EXISTS `conf_service_info`;
CREATE TABLE `conf_service_info` (
  `id` varchar(32) NOT NULL,
  `major_osd_uuid` varchar(64) DEFAULT NULL,
  `host_ip_address` varchar(64) DEFAULT NULL,
  `terminal_id` varchar(64) DEFAULT NULL,
  `serial_no` varchar(64) DEFAULT NULL,
  `opt_type` varchar(32) DEFAULT NULL,
  `hw_status` text,
  `report_datetime` datetime DEFAULT NULL,
  `report_time` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for conf_terminal
-- ----------------------------
DROP TABLE IF EXISTS `conf_terminal`;
CREATE TABLE `conf_terminal` (
  `terminal_id` varchar(64) NOT NULL,
  `secret_key` varchar(45) NOT NULL COMMENT '创建时有代码自动生成的8位数字 安全码， 用于终端激活',
  `ip_address` varchar(45) DEFAULT NULL COMMENT '配置终端IP地址，终端激活时上报。',
  `status` int(11) NOT NULL COMMENT '1- 新建（刚刚由后台建立，未激活），2- 正在激活，收到终端激活请求，但未收到响应确认， 3- 在线，4- 更新配置， 5- 离线， 6- 故障， 7- 测试',
  `name` varchar(250) DEFAULT NULL COMMENT '终端名称，可空',
  `description` text,
  `create_datetime` datetime NOT NULL,
  `serial_no` varchar(64) NOT NULL,
  PRIMARY KEY (`terminal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of conf_terminal
-- ----------------------------

-- ----------------------------
-- Table structure for email_set
-- ----------------------------
DROP TABLE IF EXISTS `email_set`;
CREATE TABLE `email_set` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `s_port` varchar(11) DEFAULT NULL,
  `smtp` varchar(255) DEFAULT NULL,
  `p_port` varchar(11) DEFAULT NULL,
  `pop3` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `eamil` varchar(255) DEFAULT NULL,
  `head` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of email_set
-- ----------------------------
INSERT INTO `email_set` VALUES ('1', '465', 'smtp.mxhichina.com', null, null, '霍因企业邮箱', 'beiyun@dnapiece.com', '[beiyun]', 'Admin12345', '2019-12-05 10:33:12', null, '0');

-- ----------------------------
-- Table structure for maintain_info
-- ----------------------------
DROP TABLE IF EXISTS `maintain_info`;
CREATE TABLE `maintain_info` (
  `task_id` varchar(64) NOT NULL COMMENT '任务id',
  `plan_id` varchar(64) DEFAULT NULL,
  `operate_type` int(2) DEFAULT NULL COMMENT '执行类型',
  `operate_data` varchar(255) DEFAULT NULL COMMENT '数据',
  `start_time` datetime DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '执行结束时间',
  `operate_result` text COMMENT '返回结果',
  `status` int(2) DEFAULT NULL COMMENT '维护策咯执行状态 0：未执行 1：执行中 2:成功 3：失败 ',
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of maintain_info
-- ----------------------------

-- ----------------------------
-- Table structure for maintain_plan
-- ----------------------------
DROP TABLE IF EXISTS `maintain_plan`;
CREATE TABLE `maintain_plan` (
  `plan_id` varchar(64) NOT NULL COMMENT '计划id',
  `plan_name` varchar(255) DEFAULT NULL,
  `task_cycle` int(2) DEFAULT NULL COMMENT '任务周期  0：立即执行  1：执行一次  2：重复执行',
  `start_time` datetime DEFAULT NULL COMMENT '开始执行时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束执行时间',
  `time_type` int(2) DEFAULT NULL COMMENT '1:month 2:week 3:day 4:hour ',
  `time_value` int(2) DEFAULT NULL COMMENT '执行频率  ',
  `operate_type` int(2) NOT NULL COMMENT '0：数据卷校验  1：数据卷清理  4:元数据备份 5：元数据还原',
  `operate_data` text COMMENT '执行数据',
  `cron` varchar(64) DEFAULT NULL COMMENT '任务时间',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `status` int(2) DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of maintain_plan
-- ----------------------------

-- ----------------------------
-- Table structure for monit_dir_mrc
-- ----------------------------
DROP TABLE IF EXISTS `monit_dir_mrc`;
CREATE TABLE `monit_dir_mrc` (
  `id` varchar(64) NOT NULL,
  `uuid` varchar(64) NOT NULL,
  `server_type` int(2) DEFAULT NULL,
  `server_name` varchar(255) DEFAULT NULL,
  `host_ip` varchar(255) DEFAULT NULL,
  `port` varchar(10) DEFAULT NULL,
  `connections` int(10) DEFAULT NULL,
  `write_iops` varchar(255) DEFAULT NULL,
  `write_speed_rate` double DEFAULT NULL,
  `read_iops` double DEFAULT NULL,
  `read_speed_rate` double DEFAULT NULL,
  `cpu` double DEFAULT NULL,
  `db_size` bigint(20) DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of monit_dir_mrc
-- ----------------------------
INSERT INTO `monit_dir_mrc` VALUES ('1', '5a7bdbe9-12d1-41f2-8de9-663a8a020566', '0', '目录', '192.168.31.199', '32638', '5', null, null, null, null, '30', null, '0', '2020-02-25 10:07:12', null);
INSERT INTO `monit_dir_mrc` VALUES ('2', '78ac13af-74a2-4ce4-b1d9-874b9b98bbe6', '1', '元数据', '192.168.31.199', '32636', null, null, null, null, null, '30', null, '0', '2020-02-25 10:07:50', null);

-- ----------------------------
-- Table structure for monit_label
-- ----------------------------
DROP TABLE IF EXISTS `monit_label`;
CREATE TABLE `monit_label` (
  `label_id` varchar(64) NOT NULL,
  `label_name` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  PRIMARY KEY (`label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of monit_label
-- ----------------------------

-- ----------------------------
-- Table structure for monit_osd
-- ----------------------------
DROP TABLE IF EXISTS `monit_osd`;
CREATE TABLE `monit_osd` (
  `id` varchar(64) NOT NULL,
  `uuid` varchar(64) DEFAULT NULL,
  `osd_name` varchar(255) DEFAULT NULL,
  `host_ip` varchar(255) DEFAULT NULL,
  `port` varchar(255) DEFAULT NULL,
  `snmp_port` varchar(32) DEFAULT NULL,
  `write_iops` double DEFAULT NULL,
  `write_speed_rate` double DEFAULT NULL,
  `read_iops` double DEFAULT NULL,
  `read_speed_rate` double DEFAULT NULL,
  `cpu` double DEFAULT NULL,
  `space` bigint(20) DEFAULT NULL,
  `lnglnt` varchar(255) DEFAULT NULL COMMENT '经纬度',
  `location` varchar(255) DEFAULT NULL COMMENT '地理位置',
  `performance` varchar(255) DEFAULT NULL COMMENT '性能',
  `used_space` bigint(20) DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `cmd`  varchar(255) DEFAULT NULL,
  `net_adapter`  varchar(255) DEFAULT NULL,
  `net_info` text,
  `conn_number` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_osd_uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for monit_osd_label
-- ----------------------------
DROP TABLE IF EXISTS `monit_osd_label`;
CREATE TABLE `monit_osd_label` (
  `id` varchar(255) NOT NULL,
  `uuid` varchar(64) NOT NULL,
  `label_id` varchar(64) NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid_label_id_unq` (`uuid`,`label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of monit_osd_label
-- ----------------------------

-- ----------------------------
-- Table structure for monit_warn
-- ----------------------------
DROP TABLE IF EXISTS `monit_warn`;
CREATE TABLE `monit_warn` (
  `warn_id` varchar(64) NOT NULL,
  `warn_type` int(10) DEFAULT NULL COMMENT '0: cpu   1:space ',
  `warn_value` varchar(255) DEFAULT NULL,
  `email` text NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  PRIMARY KEY (`warn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of monit_warn
-- ----------------------------

-- ----------------------------
-- Table structure for rule_type
-- ----------------------------
DROP TABLE IF EXISTS `rule_type`;
CREATE TABLE `rule_type` (
  `id` varchar(32) NOT NULL,
  `type_name` varchar(64) DEFAULT NULL,
  `type_value` varchar(64) DEFAULT NULL,
  `create_datetime` varchar(14) DEFAULT NULL,
  `creater` varchar(32) DEFAULT NULL,
  `update_datetime` varchar(14) DEFAULT NULL,
  `updater` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of rule_type
-- ----------------------------

-- ----------------------------
-- Table structure for SPRING_SESSION
-- ----------------------------
DROP TABLE IF EXISTS `SPRING_SESSION`;
CREATE TABLE `SPRING_SESSION` (
  `PRIMARY_ID` char(36) NOT NULL,
  `SESSION_ID` char(36) NOT NULL,
  `CREATION_TIME` bigint(20) NOT NULL,
  `LAST_ACCESS_TIME` bigint(20) NOT NULL,
  `MAX_INACTIVE_INTERVAL` int(11) NOT NULL,
  `EXPIRY_TIME` bigint(20) NOT NULL,
  `PRINCIPAL_NAME` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`PRIMARY_ID`),
  UNIQUE KEY `SPRING_SESSION_IX1` (`SESSION_ID`),
  KEY `SPRING_SESSION_IX2` (`EXPIRY_TIME`),
  KEY `SPRING_SESSION_IX3` (`PRINCIPAL_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of SPRING_SESSION
-- ----------------------------
INSERT INTO `SPRING_SESSION` VALUES ('05f7e2ff-995b-4168-bd86-b33de39c51dd', '53ff7e89-6969-4040-b907-27702fffe12a', '1589021416342', '1589024492507', '1800', '1589026292507', null);
INSERT INTO `SPRING_SESSION` VALUES ('07883127-ae19-47b3-a352-5083f2c5225c', '2efa5905-3b9a-4f66-afda-165a53321266', '1589023290689', '1589023290689', '1800', '1589025090689', null);
INSERT INTO `SPRING_SESSION` VALUES ('127e332b-8ef6-4826-9a0f-1949f7ccf957', '248279e6-623e-43a9-b7d0-50223368d266', '1589023890733', '1589023890733', '1800', '1589025690733', null);
INSERT INTO `SPRING_SESSION` VALUES ('20d8c3af-3fd0-4497-a1b9-6ce1633dcc1e', 'a2150d41-7786-40ef-8f51-fec002939f05', '1589024415077', '1589024415077', '1800', '1589026215077', null);
INSERT INTO `SPRING_SESSION` VALUES ('2459a0af-a706-4b70-a641-d6a6c35be2c8', 'bcf18fcb-b368-422b-a7f2-3807f0313c0c', '1589023245465', '1589023245465', '1800', '1589025045465', null);
INSERT INTO `SPRING_SESSION` VALUES ('277882f2-7316-4f2c-a317-7afa91fec80e', '5a90b1b5-7963-412f-994d-fbd0d4925002', '1589023245579', '1589023245579', '1800', '1589025045579', null);
INSERT INTO `SPRING_SESSION` VALUES ('3a0e7c41-b426-4287-8960-9a895d4a9f0c', 'eaabd95b-a9d0-4ffe-8cab-c9402b524bf3', '1589024490563', '1589024490563', '1800', '1589026290563', null);
INSERT INTO `SPRING_SESSION` VALUES ('3a9be4e3-65f8-489c-84d3-3af9a22bb15f', 'dde05efb-7ce5-43a0-9cf0-eb5e515d331f', '1589023875637', '1589023875637', '1800', '1589025675637', null);
INSERT INTO `SPRING_SESSION` VALUES ('3fd9450e-7749-4339-a57f-bc3ae8aa337e', '6d4fadfc-e7fe-4e2b-af11-76c96a0d82aa', '1589023890637', '1589023890637', '1800', '1589025690637', null);
INSERT INTO `SPRING_SESSION` VALUES ('402af5a7-2ec1-45c2-aa2a-8a6c56b0bab2', '38e4b5ef-e2b4-4f39-ae0c-5f7a083ec5d2', '1589023830091', '1589023830091', '1800', '1589025630091', null);
INSERT INTO `SPRING_SESSION` VALUES ('4293e841-53a9-4f6e-8eae-e0efe2e04cff', '3ce7238b-599c-451b-ad92-8baf6134cc3b', '1589023230233', '1589023230233', '1800', '1589025030233', null);
INSERT INTO `SPRING_SESSION` VALUES ('44a869fb-3a22-42af-b7b6-d70daee46c97', '4294d094-e133-4004-b49e-4ea43e5d59fb', '1589024460579', '1589024460579', '1800', '1589026260579', null);
INSERT INTO `SPRING_SESSION` VALUES ('450f8dca-825d-42d9-b9c8-0188a226c8ac', 'd5a80a5e-e87e-4d04-adeb-d963fd8c24c6', '1589024430078', '1589024430078', '1800', '1589026230078', null);
INSERT INTO `SPRING_SESSION` VALUES ('47fdb315-4496-4e84-aad1-77af7d54509c', 'c76158bf-46d7-4a67-b817-5b5732bd6ffe', '1589023815319', '1589023815319', '1800', '1589025615319', null);
INSERT INTO `SPRING_SESSION` VALUES ('4bc6a7fa-fc07-4994-9ba5-ce525d536902', '9d4604f9-8e07-47ee-affb-e22b44aca96f', '1589023260566', '1589023260566', '1800', '1589025060566', null);
INSERT INTO `SPRING_SESSION` VALUES ('5159ebfc-b6b2-4fe8-8bdb-2ac17bb6a9a3', '13dd1d89-fada-4da8-a02c-11ff1e3862ba', '1589023815091', '1589023815091', '1800', '1589025615091', null);
INSERT INTO `SPRING_SESSION` VALUES ('559ee4f7-4a04-4757-b836-67b20a9344b4', 'f77347e6-4ddd-488d-a6fd-f59ad250c6ae', '1589024460413', '1589024460413', '1800', '1589026260413', null);
INSERT INTO `SPRING_SESSION` VALUES ('59e93ac7-2ac0-4823-b335-13c37e5334ab', '8e919a97-38a9-4114-9815-9d914af1f409', '1589023875749', '1589023875749', '1800', '1589025675749', null);
INSERT INTO `SPRING_SESSION` VALUES ('6174b9b7-c2e3-473d-9412-7d2fccf80a4e', '9b0829bd-868a-4ce9-9426-6d1e747600c2', '1589023275791', '1589023275791', '1800', '1589025075791', null);
INSERT INTO `SPRING_SESSION` VALUES ('619aba04-841b-43b6-b576-fda90b5a5d1c', '245bb977-9335-42b0-b9de-f3eb8286ccc8', '1589023305777', '1589023305777', '1800', '1589025105777', null);
INSERT INTO `SPRING_SESSION` VALUES ('6323ed48-a19e-445c-858a-c7c1783600b5', '0612dde9-4c9c-40a6-aab9-46624f1d28b0', '1589024445324', '1589024445324', '1800', '1589026245324', null);
INSERT INTO `SPRING_SESSION` VALUES ('65a7728d-eea1-4e74-a8d7-f3a29902cf72', 'b31e5f10-17ae-427c-bd2d-bad226ab92e9', '1589023860402', '1589023860402', '1800', '1589025660402', null);
INSERT INTO `SPRING_SESSION` VALUES ('6655de42-7c76-4db0-92ea-f19fa2bba3c7', '186c8ead-d3f0-4144-9ce9-ae3936d58ebf', '1589024430280', '1589024430280', '1800', '1589026230280', null);
INSERT INTO `SPRING_SESSION` VALUES ('680f712a-a75f-4de8-8736-79aadbca5e83', '11fed2ae-b65a-41cd-8428-f906416dd6c5', '1589023860649', '1589023860649', '1800', '1589025660649', null);
INSERT INTO `SPRING_SESSION` VALUES ('6c25bc58-417c-439f-9686-f2ed40275ba1', '94767468-3f9d-4b8a-b156-a69b29d2f12a', '1589023905734', '1589023905734', '1800', '1589025705734', null);
INSERT INTO `SPRING_SESSION` VALUES ('77c354a9-3e4d-4e04-bca7-a0884ec289b7', 'f9dc4ceb-a735-471d-aa0f-fa0d54881736', '1589023275688', '1589023275688', '1800', '1589025075688', null);
INSERT INTO `SPRING_SESSION` VALUES ('78a2f250-03d6-4ce5-8729-1711e11fa997', '9e5eed2a-b628-4bc6-8498-2f58d9a66ec2', '1589023845401', '1589023845401', '1800', '1589025645401', null);
INSERT INTO `SPRING_SESSION` VALUES ('8369ff1d-8aec-44c5-a2c8-0eab261e61ce', 'f9bb7374-076c-4a5b-9a91-c06558c81038', '1589023230481', '1589023230481', '1800', '1589025030481', null);
INSERT INTO `SPRING_SESSION` VALUES ('87c86bd2-8c62-4f0d-b239-57bd0d012a25', 'e1d6f3f9-299a-472b-a8cd-aca32c2cb083', '1589023290776', '1589023290776', '1800', '1589025090776', null);
INSERT INTO `SPRING_SESSION` VALUES ('8ab55f80-44d2-40e5-b83b-2b3f5383e56e', '0f7a8e33-c4bf-41a5-adb6-2afcec2ac66e', '1589023830303', '1589023830303', '1800', '1589025630303', null);
INSERT INTO `SPRING_SESSION` VALUES ('8c62898b-af8c-4907-9401-e19cd59554ad', '7eefae19-9beb-4f41-9da9-82490b76aa7c', '1589023260703', '1589023260703', '1800', '1589025060703', null);
INSERT INTO `SPRING_SESSION` VALUES ('8e74361a-70b2-4dbd-b59b-ceb38e48c963', '9c641115-3499-4bbe-aaf2-9e49da6bd756', '1589023260465', '1589023260466', '1800', '1589025060466', null);
INSERT INTO `SPRING_SESSION` VALUES ('91531065-21ea-4ae1-85b3-5cf178cd6ece', '1dd925e0-d9d4-4126-8181-3a2e6e0015d4', '1589023875499', '1589023875499', '1800', '1589025675499', null);
INSERT INTO `SPRING_SESSION` VALUES ('940cc184-108a-4d4f-842d-295429cf3b61', '1b32dcc2-8dfc-4ffa-a16e-ac700cd02376', '1589023800106', '1589023800106', '1800', '1589025600106', null);
INSERT INTO `SPRING_SESSION` VALUES ('942afc66-d959-4e97-82da-15461c27134f', 'ef7c860f-2abf-4215-ba28-7009cc656212', '1589023215339', '1589023215339', '1800', '1589025015339', null);
INSERT INTO `SPRING_SESSION` VALUES ('9bb9ac17-8d26-40db-a468-29da8a39afa6', 'ad350c4f-ae23-446f-83db-a82a0f403f4b', '1589023230323', '1589023230323', '1800', '1589025030323', null);
INSERT INTO `SPRING_SESSION` VALUES ('a7f07739-f03d-482c-92f8-7a9d23daacab', 'd97dc0fd-29d8-46a8-b5bb-a6642057a103', '1589024430214', '1589024430214', '1800', '1589026230214', null);
INSERT INTO `SPRING_SESSION` VALUES ('adb0260a-8af5-4bac-8202-119ff2b41ffd', '2b679d29-e294-4569-a087-3776981e2816', '1589024415180', '1589024415180', '1800', '1589026215180', null);
INSERT INTO `SPRING_SESSION` VALUES ('b5b9668c-e620-4dfa-8166-f43cea840ebc', '97eed1a3-2d1c-49d3-b416-1fe970ee1c36', '1589024475688', '1589024475688', '1800', '1589026275688', null);
INSERT INTO `SPRING_SESSION` VALUES ('b7856111-03ff-4994-9f41-c4f59c586474', 'ec984953-7457-443e-b976-5d805e539638', '1589024460266', '1589024460266', '1800', '1589026260266', null);
INSERT INTO `SPRING_SESSION` VALUES ('c8b585aa-a677-4509-b9c8-e090a90db695', '79f5369c-74e4-4859-8b33-3d428a8b6bac', '1589023830416', '1589023830416', '1800', '1589025630416', null);
INSERT INTO `SPRING_SESSION` VALUES ('ca3779da-1fac-403a-8e5f-afdab89f0158', '0fbc8223-3c2d-4925-8193-d5af94ff6f4b', '1589023845304', '1589023845304', '1800', '1589025645304', null);
INSERT INTO `SPRING_SESSION` VALUES ('ccee9c60-868e-4f0b-8f36-f156829b200d', '16d7ea58-75b7-4419-90ef-38b799befdd7', '1589023275566', '1589023275566', '1800', '1589025075566', null);
INSERT INTO `SPRING_SESSION` VALUES ('cd8e1c34-090b-4372-8874-74a42f559183', 'f5526388-0218-4d27-8949-d63d1a429c74', '1589023374405', '1589023374405', '1800', '1589025174405', null);
INSERT INTO `SPRING_SESSION` VALUES ('ce06d05a-5d20-453a-8cf2-357d5384db9d', '7a9bd292-66a3-4e7a-a253-81e26f5c716e', '1589024505674', '1589024505674', '1800', '1589026305674', null);
INSERT INTO `SPRING_SESSION` VALUES ('cec62e0e-3666-463e-aeef-a055ca45ee02', '07df933c-ba95-46c3-af45-a57ba6addec0', '1589024475414', '1589024475414', '1800', '1589026275414', null);
INSERT INTO `SPRING_SESSION` VALUES ('d5f725e2-0c50-43b8-84bb-326f0b2b29a6', 'ea9b239b-ab44-4cac-901a-e1e3c2ccbb76', '1589023845514', '1589023845514', '1800', '1589025645514', null);
INSERT INTO `SPRING_SESSION` VALUES ('d886c213-9fe2-485f-8edf-a370251e3b51', '4d8a77c1-29fd-4e6f-aa28-c382f90618bf', '1589024490673', '1589024490673', '1800', '1589026290673', null);
INSERT INTO `SPRING_SESSION` VALUES ('e3e85b48-17e9-4325-a4c8-0b25c2f3bedf', '1ad9edb0-6da3-48be-8363-ae8db36fefff', '1589024400093', '1589024400093', '1800', '1589026200093', null);
INSERT INTO `SPRING_SESSION` VALUES ('e4d4f220-c55a-4756-bd3d-45dcad18e190', 'f2f0ae27-9164-4069-b721-6e1807c0348a', '1589023200248', '1589023200248', '1800', '1589025000248', null);
INSERT INTO `SPRING_SESSION` VALUES ('e80d592c-785c-4ce5-a02b-9b3cdd322a6b', '4a02cb95-11ab-46bf-93fa-0492c14fc9be', '1589023215233', '1589023215233', '1800', '1589025015233', null);
INSERT INTO `SPRING_SESSION` VALUES ('ea29c021-b2b2-4e4a-97c9-da7f1743dadd', '253618dd-34f5-4516-be18-0226da770b60', '1589024475562', '1589024475562', '1800', '1589026275562', null);
INSERT INTO `SPRING_SESSION` VALUES ('eae43c81-373e-404f-bc97-433ad971fee9', 'e751159a-3812-42b1-9a97-869689255d3b', '1589023245323', '1589023245323', '1800', '1589025045323', null);
INSERT INTO `SPRING_SESSION` VALUES ('edd85692-fa27-49fe-859b-772d2acd59f3', 'e01eb4ec-98a2-4704-832b-c4fca0250c20', '1589021524669', '1589023284318', '1800', '1589025084318', null);
INSERT INTO `SPRING_SESSION` VALUES ('edeab366-b468-4678-aede-dd2b42bc2556', '00dc8d13-4e92-46ea-bc17-07581869a2e1', '1589024445427', '1589024445427', '1800', '1589026245427', null);
INSERT INTO `SPRING_SESSION` VALUES ('f4460897-9129-433b-a0d7-6fb1cf5d4e52', 'e626b40a-f870-4274-b9a3-4aebcccd9fc3', '1589023860498', '1589023860498', '1800', '1589025660498', null);
INSERT INTO `SPRING_SESSION` VALUES ('ff34ffbb-adb4-4e3b-b934-14425f6779eb', 'f65e7f57-3bbc-47ba-b34f-437bd79e3a85', '1589024445167', '1589024445167', '1800', '1589026245167', null);

-- ----------------------------
-- Table structure for SPRING_SESSION_ATTRIBUTES
-- ----------------------------
DROP TABLE IF EXISTS `SPRING_SESSION_ATTRIBUTES`;
CREATE TABLE `SPRING_SESSION_ATTRIBUTES` (
  `SESSION_PRIMARY_ID` char(36) NOT NULL,
  `ATTRIBUTE_NAME` varchar(200) NOT NULL,
  `ATTRIBUTE_BYTES` blob NOT NULL,
  PRIMARY KEY (`SESSION_PRIMARY_ID`,`ATTRIBUTE_NAME`),
  CONSTRAINT `SPRING_SESSION_ATTRIBUTES_FK` FOREIGN KEY (`SESSION_PRIMARY_ID`) REFERENCES `SPRING_SESSION` (`PRIMARY_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of SPRING_SESSION_ATTRIBUTES
-- ----------------------------
INSERT INTO `SPRING_SESSION_ATTRIBUTES` VALUES ('05f7e2ff-995b-4168-bd86-b33de39c51dd', 'userInfo', 0xACED00057401037B226372656174654461746574696D65223A22323032302D30332D33312030363A34303A3030222C22756964223A2236646462623065332D383462652D346364662D383537372D616464316435383464663337222C2261646D696E4C6576656C223A2231222C2271756F7461223A22313238222C2274656E616E744964223A223231222C226E616D65223A22537472617762657272795F63616B65222C2263656C6C70686F6E65223A223133383335343039363338222C226964223A223330222C22656D61696C223A2231333833353430393633384071712E636F6D222C22757365726E616D65223A2253747261776265727279222C22737461747573223A2232227D);
INSERT INTO `SPRING_SESSION_ATTRIBUTES` VALUES ('edd85692-fa27-49fe-859b-772d2acd59f3', 'userInfo', 0xACED00057401037B226372656174654461746574696D65223A22323032302D30332D33312030363A34303A3030222C22756964223A2236646462623065332D383462652D346364662D383537372D616464316435383464663337222C2261646D696E4C6576656C223A2231222C2271756F7461223A22313238222C2274656E616E744964223A223231222C226E616D65223A22537472617762657272795F63616B65222C2263656C6C70686F6E65223A223133383335343039363338222C226964223A223330222C22656D61696C223A2231333833353430393633384071712E636F6D222C22757365726E616D65223A2253747261776265727279222C22737461747573223A2232227D);

-- ----------------------------
-- Table structure for statistic_file
-- ----------------------------
DROP TABLE IF EXISTS `statistic_file`;
CREATE TABLE `statistic_file` (
  `id` varchar(255) NOT NULL,
  `tenant_id` varchar(64) NOT NULL,
  `tenant_name` varchar(255) DEFAULT NULL,
  `user_id` varchar(64) NOT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `volume_id` varchar(64) DEFAULT NULL,
  `volume_name` varchar(255) NOT NULL,
  `quota` varchar(255) DEFAULT NULL,
  `file_type` int(11) NOT NULL COMMENT '0:图片 1：视频 2：音频 3：文件 4：压缩 5：其他',
  `file_num` int(11) NOT NULL DEFAULT '0',
  `file_space` bigint(20) NOT NULL DEFAULT '0',
  `create_time` datetime DEFAULT NULL,
  `updte_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of statistic_file
-- ----------------------------
INSERT INTO `statistic_file` VALUES ('05ddd6ffa3264b67b3b0f8ab9fd91cf2', '1-17', 'group-17', '1-23', 'user-23', '94a60ff0-afb5-4eea-b943-ee70d6795c77', 'user-23', '10G', '4', '0', '0', '2020-05-09 16:50:00', '2020-05-09 19:10:00');
INSERT INTO `statistic_file` VALUES ('1475054b39514117b76c6baec0bca7b2', '1-17', 'group-17', '1-14', 'user-14', 'aa2c33e9-29e3-4040-bee3-b30e8b8428d0', 'user-14', '10G', '1', '0', '0', '2020-05-09 16:50:06', '2020-05-09 19:10:05');
INSERT INTO `statistic_file` VALUES ('176262a156544c96b90c6ca11227c7ce', '1-17', 'group-17', '1-21', 'user-21', 'f0ded840-144c-4343-9406-c08ea2ec6434', 'user-21', '10G', '4', '0', '0', '2020-05-09 16:50:03', '2020-05-09 19:10:03');
INSERT INTO `statistic_file` VALUES ('17790f8586564b7ea21c9d6a274ec816', '1-17', 'group-17', '1-22', 'user-22', '7f117743-ec47-4805-9a6f-90c36e209b41', 'user-22', '10G', '0', '0', '0', '2020-05-09 16:50:04', '2020-05-09 19:10:04');
INSERT INTO `statistic_file` VALUES ('18d6941128314d779d081349105ebc12', '1-17', 'group-17', '1-19', 'user-19', '8d75f75c-958d-4857-bbc1-5dea2d18c3fe', 'user-19', '10G', '3', '0', '0', '2020-05-09 16:50:02', '2020-05-09 19:10:02');
INSERT INTO `statistic_file` VALUES ('2341490b1ed1406d87e26a2b1a987fc0', '1-17', 'group-17', '1-14', 'user-14', 'aa2c33e9-29e3-4040-bee3-b30e8b8428d0', 'user-14', '10G', '0', '0', '0', '2020-05-09 16:50:06', '2020-05-09 19:10:05');
INSERT INTO `statistic_file` VALUES ('235e8e2bc5dc4549877c53d7a19ebb93', '1-17', 'group-17', '1-21', 'user-21', 'f0ded840-144c-4343-9406-c08ea2ec6434', 'user-21', '10G', '2', '0', '0', '2020-05-09 16:50:03', '2020-05-09 19:10:03');
INSERT INTO `statistic_file` VALUES ('2f2a88cb2b0f4bb7a07033a662dbe039', '1-17', 'group-17', '1-19', 'user-19', '8d75f75c-958d-4857-bbc1-5dea2d18c3fe', 'user-19', '10G', '1', '0', '0', '2020-05-09 16:50:02', '2020-05-09 19:10:02');
INSERT INTO `statistic_file` VALUES ('47bf819cc85b46acaca2ba325da08bbb', '1-17', 'group-17', '1-22', 'user-22', '7f117743-ec47-4805-9a6f-90c36e209b41', 'user-22', '10G', '1', '0', '0', '2020-05-09 16:50:04', '2020-05-09 19:10:04');
INSERT INTO `statistic_file` VALUES ('47eff41e6ced4e21967a554ce3e1dad1', '1-17', 'group-17', '1-14', 'user-14', 'aa2c33e9-29e3-4040-bee3-b30e8b8428d0', 'user-14', '10G', '5', '0', '0', '2020-05-09 16:50:06', '2020-05-09 19:10:06');
INSERT INTO `statistic_file` VALUES ('5980903f3d2e4c9d9e1d7abf039aa53b', 'WTloEQ3G9n', 'zhongguan', '05f40dff-aab1-452b-aab9-75c36e916748', 'wangwenqing1234568@dnapiece.com', '644d4e42-f5ec-4d4b-8261-462c85ada5cb', '汪文清的测试数据卷', '12G', '3', '0', '0', '2020-05-09 16:50:07', '2020-05-09 19:10:07');
INSERT INTO `statistic_file` VALUES ('5991698e56944ccea3ff297f7b07b846', '1-17', 'group-17', '1-19', 'user-19', '8d75f75c-958d-4857-bbc1-5dea2d18c3fe', 'user-19', '10G', '4', '0', '0', '2020-05-09 16:50:02', '2020-05-09 19:10:02');
INSERT INTO `statistic_file` VALUES ('5d3127e987b64e53a6e03c053553e55d', '1-17', 'group-17', '1-23', 'user-23', '94a60ff0-afb5-4eea-b943-ee70d6795c77', 'user-23', '10G', '5', '0', '0', '2020-05-09 16:50:01', '2020-05-09 19:10:00');
INSERT INTO `statistic_file` VALUES ('67a13e20758544389454657bff99cc72', '1-17', 'group-17', '1-19', 'user-19', '8d75f75c-958d-4857-bbc1-5dea2d18c3fe', 'user-19', '10G', '0', '0', '0', '2020-05-09 16:50:02', '2020-05-09 19:10:02');
INSERT INTO `statistic_file` VALUES ('70c6559c0c994d9d8f4c0ec6e7ed3751', '1-17', 'group-17', '1-22', 'user-22', '7f117743-ec47-4805-9a6f-90c36e209b41', 'user-22', '10G', '3', '0', '0', '2020-05-09 16:50:04', '2020-05-09 19:10:04');
INSERT INTO `statistic_file` VALUES ('760666a5afd74e25bb73a9aa533e99b0', '1-17', 'group-17', '1-22', 'user-22', '7f117743-ec47-4805-9a6f-90c36e209b41', 'user-22', '10G', '4', '0', '0', '2020-05-09 16:50:04', '2020-05-09 19:10:04');
INSERT INTO `statistic_file` VALUES ('9218ac8f27d541009b40cf045b19788d', '1-17', 'group-17', '1-14', 'user-14', 'aa2c33e9-29e3-4040-bee3-b30e8b8428d0', 'user-14', '10G', '4', '0', '0', '2020-05-09 16:50:06', '2020-05-09 19:10:06');
INSERT INTO `statistic_file` VALUES ('92f8a20ad4e9465889d23ba0242fc826', '1-17', 'group-17', '1-14', 'user-14', 'aa2c33e9-29e3-4040-bee3-b30e8b8428d0', 'user-14', '10G', '2', '0', '0', '2020-05-09 16:50:06', '2020-05-09 19:10:05');
INSERT INTO `statistic_file` VALUES ('9c09f590fde7437785fe46a0c9f01d34', '1-17', 'group-17', '1-22', 'user-22', '7f117743-ec47-4805-9a6f-90c36e209b41', 'user-22', '10G', '5', '0', '0', '2020-05-09 16:50:04', '2020-05-09 19:10:04');
INSERT INTO `statistic_file` VALUES ('a7259f13461c41629f731d5f0d0ea043', '1-17', 'group-17', '1-19', 'user-19', '8d75f75c-958d-4857-bbc1-5dea2d18c3fe', 'user-19', '10G', '2', '0', '0', '2020-05-09 16:50:02', '2020-05-09 19:10:02');
INSERT INTO `statistic_file` VALUES ('b24d062904d1456e8eb32cfef8bf095b', 'WTloEQ3G9n', 'zhongguan', '05f40dff-aab1-452b-aab9-75c36e916748', 'wangwenqing1234568@dnapiece.com', '644d4e42-f5ec-4d4b-8261-462c85ada5cb', '汪文清的测试数据卷', '12G', '4', '0', '0', '2020-05-09 16:50:07', '2020-05-09 19:10:07');
INSERT INTO `statistic_file` VALUES ('b540c9d4d896435991a990c7a788b036', 'WTloEQ3G9n', 'zhongguan', '05f40dff-aab1-452b-aab9-75c36e916748', 'wangwenqing1234568@dnapiece.com', '644d4e42-f5ec-4d4b-8261-462c85ada5cb', '汪文清的测试数据卷', '12G', '1', '0', '0', '2020-05-09 16:50:07', '2020-05-09 19:10:07');
INSERT INTO `statistic_file` VALUES ('bda6f5495a3045db8a09e8f79e980ae9', '1-17', 'group-17', '1-14', 'user-14', 'aa2c33e9-29e3-4040-bee3-b30e8b8428d0', 'user-14', '10G', '3', '0', '0', '2020-05-09 16:50:06', '2020-05-09 19:10:06');
INSERT INTO `statistic_file` VALUES ('c909e8cbef9d4cb99a9b556db8c7d598', '1-17', 'group-17', '1-23', 'user-23', '94a60ff0-afb5-4eea-b943-ee70d6795c77', 'user-23', '10G', '2', '0', '0', '2020-05-09 16:50:00', '2020-05-09 19:10:00');
INSERT INTO `statistic_file` VALUES ('cd2c3f8e01d44f9d8373508edc891644', '1-17', 'group-17', '1-22', 'user-22', '7f117743-ec47-4805-9a6f-90c36e209b41', 'user-22', '10G', '2', '0', '0', '2020-05-09 16:50:04', '2020-05-09 19:10:04');
INSERT INTO `statistic_file` VALUES ('d850c04db2d44e5997d59c480d6c0c91', '1-17', 'group-17', '1-21', 'user-21', 'f0ded840-144c-4343-9406-c08ea2ec6434', 'user-21', '10G', '0', '0', '0', '2020-05-09 16:50:03', '2020-05-09 19:10:03');
INSERT INTO `statistic_file` VALUES ('da947747574f4085bf9fab0483ebac40', '1-17', 'group-17', '1-23', 'user-23', '94a60ff0-afb5-4eea-b943-ee70d6795c77', 'user-23', '10G', '0', '0', '0', '2020-05-09 16:50:00', '2020-05-09 19:10:00');
INSERT INTO `statistic_file` VALUES ('dbf85ef8978a4393a28318bac9037959', 'WTloEQ3G9n', 'zhongguan', '05f40dff-aab1-452b-aab9-75c36e916748', 'wangwenqing1234568@dnapiece.com', '644d4e42-f5ec-4d4b-8261-462c85ada5cb', '汪文清的测试数据卷', '12G', '2', '0', '0', '2020-05-09 16:50:07', '2020-05-09 19:10:07');
INSERT INTO `statistic_file` VALUES ('df3e949e98434017a64752ae1f08c99c', '1-17', 'group-17', '1-23', 'user-23', '94a60ff0-afb5-4eea-b943-ee70d6795c77', 'user-23', '10G', '1', '0', '0', '2020-05-09 16:50:00', '2020-05-09 19:10:00');
INSERT INTO `statistic_file` VALUES ('e947f6610d964fe1a28cb1394ab6ede7', '1-17', 'group-17', '1-21', 'user-21', 'f0ded840-144c-4343-9406-c08ea2ec6434', 'user-21', '10G', '5', '0', '0', '2020-05-09 16:50:03', '2020-05-09 19:10:03');
INSERT INTO `statistic_file` VALUES ('eb3346d093134ab8a900cae38a46d91b', '1-17', 'group-17', '1-21', 'user-21', 'f0ded840-144c-4343-9406-c08ea2ec6434', 'user-21', '10G', '1', '0', '0', '2020-05-09 16:50:03', '2020-05-09 19:10:03');
INSERT INTO `statistic_file` VALUES ('f091db8af18b4382a14ea8572f2c0a33', 'WTloEQ3G9n', 'zhongguan', '05f40dff-aab1-452b-aab9-75c36e916748', 'wangwenqing1234568@dnapiece.com', '644d4e42-f5ec-4d4b-8261-462c85ada5cb', '汪文清的测试数据卷', '12G', '5', '0', '0', '2020-05-09 16:50:07', '2020-05-09 19:10:07');
INSERT INTO `statistic_file` VALUES ('f70a837804e3448cb7b82c4998dde655', 'WTloEQ3G9n', 'zhongguan', '05f40dff-aab1-452b-aab9-75c36e916748', 'wangwenqing1234568@dnapiece.com', '644d4e42-f5ec-4d4b-8261-462c85ada5cb', '汪文清的测试数据卷', '12G', '0', '0', '0', '2020-05-09 16:50:07', '2020-05-09 19:10:07');
INSERT INTO `statistic_file` VALUES ('faf8fa7536964da784b55df2a04cf25b', '1-17', 'group-17', '1-21', 'user-21', 'f0ded840-144c-4343-9406-c08ea2ec6434', 'user-21', '10G', '3', '0', '0', '2020-05-09 16:50:03', '2020-05-09 19:10:03');
INSERT INTO `statistic_file` VALUES ('fc58d1292dd04201be708c53ebf7ebd4', '1-17', 'group-17', '1-19', 'user-19', '8d75f75c-958d-4857-bbc1-5dea2d18c3fe', 'user-19', '10G', '5', '0', '0', '2020-05-09 16:50:02', '2020-05-09 19:10:02');
INSERT INTO `statistic_file` VALUES ('fcaa5a50bf5e46f7abf481dae58c23d2', '1-17', 'group-17', '1-23', 'user-23', '94a60ff0-afb5-4eea-b943-ee70d6795c77', 'user-23', '10G', '3', '0', '0', '2020-05-09 16:50:00', '2020-05-09 19:10:00');

-- ----------------------------
-- Table structure for statistic_map_info
-- ----------------------------
DROP TABLE IF EXISTS `statistic_map_info`;
CREATE TABLE `statistic_map_info` (
  `id` varchar(64) NOT NULL,
  `volume_id` varchar(64) NOT NULL,
  `province` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `lng` varchar(255) DEFAULT NULL,
  `lat` varchar(255) DEFAULT NULL,
  `file_num` int(11) DEFAULT NULL,
  `file_space` bigint(20) DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of statistic_map_info
-- ----------------------------

-- ----------------------------
-- Table structure for statistic_volume
-- ----------------------------
DROP TABLE IF EXISTS `statistic_volume`;
CREATE TABLE `statistic_volume` (
  `volume_id` varchar(64) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `taskid` varchar(64) DEFAULT NULL,
  `owner_gid` varchar(64) DEFAULT NULL COMMENT '数据卷租户ID',
  `owner_gname` varchar(255) DEFAULT NULL COMMENT '数据卷用户ID',
  `owner_uid` varchar(64) DEFAULT NULL,
  `owner_uname` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL COMMENT '数据卷创建状态',
  `quota` varchar(255) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`volume_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for support_accesslog
-- ----------------------------
DROP TABLE IF EXISTS `support_accesslog`;
CREATE TABLE `support_accesslog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(5) unsigned NOT NULL,
  `method` varchar(10) NOT NULL,
  `url` varchar(255) NOT NULL,
  `parameters` longtext,
  `response_code` varchar(5) DEFAULT NULL,
  `result` longtext,
  `time_consuming` int(11) DEFAULT NULL COMMENT '耗时（单位：毫秒）',
  `create_datetime` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of support_accesslog
-- ----------------------------

-- ----------------------------
-- Table structure for support_exceptionlog
-- ----------------------------
DROP TABLE IF EXISTS `support_exceptionlog`;
CREATE TABLE `support_exceptionlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module` varchar(45) NOT NULL,
  `service` varchar(45) DEFAULT NULL,
  `parameter` longtext,
  `content` longtext NOT NULL,
  `create_datetime` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of support_exceptionlog
-- ----------------------------

-- ----------------------------
-- Table structure for to_email
-- ----------------------------
DROP TABLE IF EXISTS `to_email`;
CREATE TABLE `to_email` (
  `id` varchar(32) COLLATE utf8_bin NOT NULL,
  `sender` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `receiver` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `title` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `content` text COLLATE utf8_bin,
  `create_time` datetime DEFAULT NULL,
  `type` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of to_email
-- ----------------------------

-- ----------------------------
-- Table structure for user_appid_token
-- ----------------------------
DROP TABLE IF EXISTS `user_appid_token`;
CREATE TABLE `user_appid_token` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app_code` varchar(64) NOT NULL,
  `user_app_id` varchar(45) NOT NULL,
  `token` varchar(250) NOT NULL,
  `update_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_code` varchar(32) DEFAULT NULL,
  `email` varchar(64) NOT NULL,
  `status` int(2) DEFAULT '0' COMMENT '0:未激活  1：已激活',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_appid_token
-- ----------------------------

-- ----------------------------
-- Table structure for user_config_info
-- ----------------------------
DROP TABLE IF EXISTS `user_config_info`;
CREATE TABLE `user_config_info` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `user_code` varchar(32) DEFAULT NULL COMMENT '用户编码',
  `user_config_code` varchar(32) DEFAULT NULL COMMENT '编码',
  `user_config_name` varchar(64) DEFAULT NULL COMMENT '名称',
  `user_config_item` varchar(255) DEFAULT NULL COMMENT '配置',
  `user_config_status` varchar(1) DEFAULT '0' COMMENT '0 有效 1 作废',
  `user_config_notes` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_datetime` varchar(14) DEFAULT NULL,
  `creater` varchar(32) DEFAULT NULL,
  `update_datetime` varchar(14) DEFAULT NULL,
  `updater` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_config_info
-- ----------------------------

-- ----------------------------
-- Table structure for user_login
-- ----------------------------
DROP TABLE IF EXISTS `user_login`;
CREATE TABLE `user_login` (
  `user_login_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(32) DEFAULT NULL,
  `user_code` varchar(32) DEFAULT NULL,
  `user_name` varchar(32) DEFAULT NULL,
  `login_datetime` char(14) DEFAULT NULL,
  `login_ip` varchar(20) DEFAULT NULL,
  `error_level` int(11) DEFAULT NULL,
  `error_type` int(11) DEFAULT NULL,
  `error_description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_login_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_login
-- ----------------------------

-- ----------------------------
-- Table structure for warn
-- ----------------------------
DROP TABLE IF EXISTS `warn`;
CREATE TABLE `warn` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(2) DEFAULT NULL,
  `title` varchar(32) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `status` varchar(32) DEFAULT NULL COMMENT '0:未读 1:已读 2:删除',
  `operate` varchar(32) DEFAULT NULL COMMENT '操作人',
  `area_name` varchar(32) DEFAULT NULL,
  `note_name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of warn
-- ----------------------------


SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for conf_rsync
-- ----------------------------
DROP TABLE IF EXISTS `conf_rsync`;
CREATE TABLE `conf_rsync` (
  `id` varchar(64) NOT NULL,
  `host_ip` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `to_dir` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for conf_rsync_volume
-- ----------------------------
DROP TABLE IF EXISTS `conf_rsync_volume`;
CREATE TABLE `conf_rsync_volume` (
  `id` varchar(64) NOT NULL,
  `volume_id` varchar(64) DEFAULT NULL,
  `volume_name` varchar(255) DEFAULT NULL,
  `rsync_id` varchar(64) DEFAULT NULL,
  `status` int(2) DEFAULT NULL COMMENT '0:未同步 1:同步中 2:同步完成 3:同步失败',
  `syn_time` datetime DEFAULT NULL COMMENT '同步时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




CREATE TABLE `admin_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(200) NOT NULL,
  `password` varchar(128) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `admin_opt_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `opt_type` int(11) NOT NULL COMMENT '1- 登录，2-注销，3-创建License，4- 更新功能，5- 修改有效期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `feature` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL COMMENT '功能名称',
  `code` varchar(45) NOT NULL COMMENT '功能编码',
  `type` varchar(45) NOT NULL COMMENT '1- 功能，2- 规格',
  `spec_limit` varchar(45) DEFAULT NULL COMMENT '规格限制，类型数字。表示规格的具体限制数量',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `license` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(200) NOT NULL,
  `alias` varchar(200) DEFAULT NULL COMMENT '别名',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `activate_dt` datetime DEFAULT NULL,
  `validity` int(11) NOT NULL DEFAULT '30',
  `expire_dt` datetime DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '1- 生效，2- 停用，2- 过期',
  `type` int(11) NOT NULL DEFAULT '1' COMMENT '1- 在线证书，必须进行在线校验，2- 离线证书，不必进行在线校验',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `license_features` (
  `feature_id` int(11) NOT NULL,
  `license_code` varchar(200) NOT NULL,
  PRIMARY KEY (`feature_id`,`license_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `recipient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL COMMENT '1- 个人，2- 公司',
  `name` varchar(200) NOT NULL COMMENT '公司名或个人姓名',
  `contact_number` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `address` text,
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='使用人/公司信息';

CREATE TABLE `verify_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license_code` varchar(200) NOT NULL,
  `host_ip` varchar(45) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '2' COMMENT '1- 激活，2- 验证，租户服务每次启动时会使用保存在本地的验证码发起与服务器间的校验\\n',
  `create_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='License 激活和验证记录，每次重启租户服务后的第一次登录时，发起license验证';
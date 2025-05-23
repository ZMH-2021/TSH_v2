#数据库表
#创建数据库
DROP DATABASE IF EXISTS `0voice_tuchuang`;
CREATE DATABASE `0voice_tuchuang`;

#使用数据库
use `0voice_tuchuang`;


DROP TABLE IF EXISTS `file_info`;
# 文件表
CREATE TABLE `file_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '文件序号，自动递增，主键',
  `md5` varchar(256) NOT NULL COMMENT '文件md5',
  `file_id` varchar(256) NOT NULL COMMENT '文件id:/group1/M00/00/00/xxx.png',
  `url` varchar(512) NOT NULL COMMENT '文件url 192.168.52.139:80/group1/M00/00/00/xxx.png',
  `size` bigint(20) DEFAULT '0' COMMENT '文件大小, 以字节为单位',
  `type` varchar(32) DEFAULT '' COMMENT '文件类型： png, zip, mp4……',
  `count` int(11) DEFAULT '0' COMMENT '文件引用计数,默认为1。每增加一个用户拥有此文件，此计数器+1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_md5` (`md5`)
  -- KEY `uq_md5` (`md5`(8))  -- 前缀索引
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 COMMENT='文件信息表';


DROP TABLE IF EXISTS `share_file_list`;
# 共享文件表
CREATE TABLE `share_file_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user` varchar(32) NOT NULL COMMENT '文件所属用户',
  `md5` varchar(256) NOT NULL COMMENT '文件md5',
  `file_name` varchar(128) DEFAULT NULL COMMENT '文件名字',
  `pv` int(11) DEFAULT '1' COMMENT '文件下载量，默认值为1，下载一次加1',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '文件共享时间',
  PRIMARY KEY (`id`),
  key `idx_filename_md5_user` (`file_name`, `md5`, `user`),
  key `idx_md5_user` (`md5`, `user`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='共享文件列表';


DROP TABLE IF EXISTS `share_picture_list`;
# 共享图片表
CREATE TABLE `share_picture_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user` varchar(32) NOT NULL COMMENT '文件所属用户',
  `filemd5` varchar(256) NOT NULL COMMENT '文件md5',
  `file_name` varchar(128) DEFAULT NULL COMMENT '文件名字',
  `urlmd5` varchar(256) NOT NULL COMMENT '图床urlmd5',
  `key` varchar(8) NOT NULL COMMENT '提取码',
  `pv` int(11) DEFAULT '1' COMMENT '文件下载量，默认值为1，下载一次加1',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '文件创建时间',
  PRIMARY KEY (`id`),
  KEY   `idx_user_filemd5` (`user`, `filemd5`), 
  KEY   `idx_urlmd5_user` (`urlmd5`, `user`) 
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='图床文件列表';


DROP TABLE IF EXISTS `user_file_list`;
# 用户文件表
CREATE TABLE `user_file_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user` varchar(32) NOT NULL COMMENT '文件所属用户',
  `md5` varchar(256) NOT NULL COMMENT '文件md5',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '文件创建时间',
  `file_name` varchar(128) DEFAULT NULL COMMENT '文件名字',
  `shared_status` int(11) DEFAULT NULL COMMENT '共享状态, 0为没有共享， 1为共享',
  `pv` int(11) DEFAULT NULL COMMENT '文件下载量，默认值为0，下载一次加1',
  --  `type` varchar(32) DEFAULT '' COMMENT '文件类型： png, zip, mp4……',
  PRIMARY KEY (`id`),
  UNIQUE  KEY   `idx_user_md5_file_name` (`user`,`md5`, `file_name`) 
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COMMENT='用户文件列表';


DROP TABLE IF EXISTS `user_info`;
# 用户表
CREATE TABLE `user_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户序号，自动递增，主键',
  `user_name` varchar(32) NOT NULL DEFAULT '' COMMENT '用户名称',
  `nick_name` varchar(32) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '用户昵称',
  `password` varchar(32) NOT NULL DEFAULT '' COMMENT '密码',
  `phone` varchar(16) NOT NULL DEFAULT '' COMMENT '手机号码',
  `email` varchar(64) DEFAULT '' COMMENT '邮箱',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_nick_name` (`nick_name`),
  UNIQUE KEY `uq_user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='用户信息表';

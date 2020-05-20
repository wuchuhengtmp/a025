-- phpMyAdmin SQL Dump
-- version phpStudy 2014
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2020 �?04 �?25 �?19:10
-- 服务器版本: 5.5.53
-- PHP 版本: 5.5.38

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `taojin`
--

-- --------------------------------------------------------

--
-- 表的结构 `dhc_admin`
--

CREATE TABLE IF NOT EXISTS `dhc_admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user` varchar(100) NOT NULL COMMENT '用户名',
  `salt` varchar(100) NOT NULL COMMENT '盐值',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `role` tinyint(4) NOT NULL COMMENT '角色(1管理员 2 操作员)',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态',
  `createtime` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `jurisdiction` varchar(100) DEFAULT '' COMMENT '权限',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='后台管理员表' AUTO_INCREMENT=14 ;

--
-- 转存表中的数据 `dhc_admin`
--

INSERT INTO `dhc_admin` (`id`, `user`, `salt`, `password`, `role`, `status`, `createtime`, `jurisdiction`) VALUES
(1, 'admin', 'djnn', '6bbd2fb125c5b00e100775e2fca87bdd', 1, 1, 0, '1-2-3-4-5-6-7-8-9-10'),
(12, 'admin888', 'djnn', '6bbd2fb125c5b00e100775e2fca87bdd', 2, 1, 1495456361, '1-2--4-5-6-7-8--'),
(13, '123456', '495846', '7a7e8b94a203e4a709c6b59f49088883', 2, 1, 1495849376, '1-2--4-5-6-7-8--');

-- --------------------------------------------------------

--
-- 表的结构 `dhc_admin_jurisdiction`
--

CREATE TABLE IF NOT EXISTS `dhc_admin_jurisdiction` (
  `role` int(11) NOT NULL COMMENT '角色id',
  `rolename` varchar(100) NOT NULL COMMENT '角色名称',
  `jurisdiction` varchar(100) NOT NULL COMMENT '权限列表',
  PRIMARY KEY (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户组权限列表';

--
-- 转存表中的数据 `dhc_admin_jurisdiction`
--

INSERT INTO `dhc_admin_jurisdiction` (`role`, `rolename`, `jurisdiction`) VALUES
(1, 'admin', '1-2-3-4-5-6-7-8'),
(2, 'operate', '1-2-3-4-5-6-7-8'),
(3, 'user', '');

-- --------------------------------------------------------

--
-- 表的结构 `dhc_article_category`
--

CREATE TABLE IF NOT EXISTS `dhc_article_category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `pid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '父类id',
  `title` varchar(100) NOT NULL COMMENT '分类名称',
  `thumb` varchar(255) DEFAULT NULL COMMENT '缩略图',
  `remark` varchar(255) NOT NULL COMMENT '备注',
  `createtime` int(11) unsigned NOT NULL COMMENT '创建时间',
  `icon` varchar(255) DEFAULT NULL COMMENT '图标',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='文章分类表' AUTO_INCREMENT=7 ;

--
-- 转存表中的数据 `dhc_article_category`
--

INSERT INTO `dhc_article_category` (`id`, `pid`, `title`, `thumb`, `remark`, `createtime`, `icon`) VALUES
(1, 0, '关于我们', NULL, '关于我们', 1495875069, '/upload/image/20170527/20170527165108_55289.png'),
(2, 0, '游戏公告', NULL, 'd', 1495423140, '/upload/image/20170318/20170318205830_84666.png'),
(3, 0, '公告', NULL, '公告', 1498011403, ''),
(4, 0, '新闻列表', NULL, '新闻列表', 1493432218, ''),
(5, 0, '攻略列表', NULL, '攻略列表', 1493432227, ''),
(6, 0, '游戏界面', NULL, '淘金农场', 1495869664, '/upload/image/20170527/20170527152016_35273.jpg');

-- --------------------------------------------------------

--
-- 表的结构 `dhc_article_list`
--

CREATE TABLE IF NOT EXISTS `dhc_article_list` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '文章id',
  `cid` int(11) unsigned NOT NULL COMMENT '文章分类id',
  `title` varchar(255) NOT NULL COMMENT '文章标题',
  `thumb` varchar(128) DEFAULT NULL COMMENT '缩略图',
  `from` varchar(128) NOT NULL COMMENT '文章来源',
  `readTimes` int(11) unsigned DEFAULT NULL COMMENT '阅读次数',
  `description` varchar(128) NOT NULL COMMENT '简述',
  `content` longtext NOT NULL COMMENT '文章内容',
  `updateTime` int(11) unsigned NOT NULL COMMENT '更新时间',
  `createTime` int(11) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8mb4 COMMENT='文章列表' AUTO_INCREMENT=26 ;

--
-- 转存表中的数据 `dhc_article_list`
--

INSERT INTO `dhc_article_list` (`id`, `cid`, `title`, `thumb`, `from`, `readTimes`, `description`, `content`, `updateTime`, `createTime`) VALUES
(9, 5, '下面都是攻略', '', '系统攻略', 22, '下面都是攻略下面都是攻略下面都是攻略下面都是攻略下面都是攻略下面都是攻略', '下面都是攻略下面都是攻略下面都是攻略下面都是攻略', 1490603716, 1490603716),
(11, 3, '1', '', '来自系统', 3, '都是公告', '下面都是公告下面都是公告下面都是公告下面都是公告', 1490604339, 1490603662),
(14, 3, '下面都是新闻', NULL, '新闻系统', 8, '下面都是新闻下面都是新闻下面都是新闻下面都是新闻下面都是新闻', '下面都是新闻下面都是新闻下面都是新闻下面都是新闻下面都是新闻下面都是新闻', 1501234098, 1490603687),
(16, 3, '321321565', '', '来自系统', 2, '都是公告', '下面都是公告下面都是公告下面都是公告下面都是公告', 1490604339, 1490603662),
(17, 3, '下面都是新闻', NULL, '新闻系统', 4, '下面都是新闻下面都是新闻下面都是新闻下面都是新闻下面都是新闻', '<img src="/upload/image/20170815/20170815111953_69933.jpg" alt="" />下面都是新闻下面都是新闻下面都是新闻下面都是新闻下面都是新闻下面都是新闻', 1502767195, 1490603687),
(18, 3, '9', '', '来自系统', NULL, '都是公告', '下面都是公告下面都是公告下面都是公告下面都是公告', 1490604339, 1490603662),
(19, 3, '8', '', '来自系统', NULL, '都是公告', '下面都是公告下面都是公告下面都是公告下面都是公告', 1490604339, 1490603662),
(20, 3, '7', '', '来自系统', NULL, '都是公告', '下面都是公告下面都是公告下面都是公告下面都是公告', 1490604339, 1490603662),
(21, 3, '6', '', '来自系统', 6, '都是公告', '下面都是公告下面都是公告下面都是公告下面都是公告', 1490604339, 1490603662),
(22, 3, '5', '', '来自系统', 2, '都是公告', '下面都是公告下面都是公告下面都是公告下面都是公告', 1490604339, 1490603662),
(23, 3, '4', '', '来自系统', NULL, '都是公告', '下面都是公告下面都是公告下面都是公告下面都是公告', 1490604339, 1490603662);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_article_raiders`
--

CREATE TABLE IF NOT EXISTS `dhc_article_raiders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `operator` int(11) DEFAULT NULL COMMENT '操作员id',
  `auth` varchar(100) NOT NULL COMMENT '用户帐号',
  `title` varchar(100) NOT NULL COMMENT '攻略标题',
  `content` longtext NOT NULL COMMENT '攻略内容',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '审核状态',
  `createtime` int(11) unsigned NOT NULL COMMENT '发表日期',
  `readtimes` int(11) unsigned DEFAULT '1' COMMENT '阅读次数',
  `reward` int(11) unsigned DEFAULT '0' COMMENT '打赏',
  `praise` int(11) unsigned DEFAULT '0' COMMENT '好评',
  `comments` int(11) unsigned DEFAULT '0' COMMENT '中评',
  `bad` int(11) unsigned DEFAULT '0' COMMENT '差评',
  `type` tinyint(4) NOT NULL COMMENT '阅读类型',
  `reason` varchar(100) DEFAULT '' COMMENT '审核原因',
  `rewardproduct` int(11) DEFAULT NULL COMMENT '打赏产品',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='攻略表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_article_raiderss`
--

CREATE TABLE IF NOT EXISTS `dhc_article_raiderss` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `operator` int(11) DEFAULT NULL COMMENT '操作员id',
  `auth` varchar(100) NOT NULL COMMENT '用户帐号',
  `title` varchar(100) NOT NULL COMMENT '攻略标题',
  `content` longtext NOT NULL COMMENT '攻略内容',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '审核状态',
  `createtime` int(11) unsigned NOT NULL COMMENT '发表日期',
  `readtimes` int(11) unsigned DEFAULT '1' COMMENT '阅读次数',
  `reward` int(11) unsigned DEFAULT '0' COMMENT '打赏',
  `praise` int(11) unsigned DEFAULT '0' COMMENT '好评',
  `comments` int(11) unsigned DEFAULT '0' COMMENT '中评',
  `bad` int(11) unsigned DEFAULT '0' COMMENT '差评',
  `type` tinyint(4) NOT NULL COMMENT '阅读类型',
  `reason` varchar(100) DEFAULT '' COMMENT '审核原因',
  `rewardproduct` int(11) DEFAULT NULL COMMENT '打赏产品',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_config`
--

CREATE TABLE IF NOT EXISTS `dhc_config` (
  `key` varchar(200) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `dhc_config`
--

INSERT INTO `dhc_config` (`key`, `value`) VALUES
('', ''),
('1', 'a:2:{s:7:"crystal";a:3:{s:8:"product1";a:5:{s:4:"pid1";s:5:"80004";s:4:"num1";s:3:"100";s:4:"pid2";s:5:"80004";s:4:"num2";s:3:"100";s:7:"crystal";s:3:"500";}s:8:"product2";a:5:{s:4:"pid1";s:5:"80004";s:4:"num1";s:0:"";s:4:"pid2";s:5:"80004";s:4:"num2";s:0:"";s:7:"crystal";s:0:"";}s:8:"product3";a:5:{s:4:"pid1";s:5:"80004";s:4:"num1";s:0:"";s:4:"pid2";s:5:"80004";s:4:"num2";s:0:"";s:7:"crystal";s:0:"";}}s:2:"id";s:1:"1";}'),
('channel_billing_type', '1'),
('copyright', 'a:5:{s:11:"companyName";s:6:"黄金";s:11:"companyWord";s:6:"黄金";s:11:"companyinfo";s:12:"啊啊啊啊";s:9:"copyright";s:6:"啊啊";s:6:"record";s:6:"啊啊";}'),
('crystal', 'a:1:{s:7:"crystal";a:8:{s:4:"pid1";s:5:"80007";s:4:"num1";s:4:"2000";s:4:"pid2";s:5:"80013";s:4:"num2";s:4:"2000";s:4:"pid3";s:5:"80005";s:4:"num3";s:4:"2000";s:7:"crystal";s:3:"100";s:6:"status";s:1:"1";}}'),
('game', 'a:10:{s:4:"name";s:21:"淘金农场测试站";s:8:"keyWords";s:3:"231";s:4:"logo";s:47:"/upload/image/20170628/20170628100521_95392.png";s:8:"gameinfo";s:9:"123123123";s:6:"fruits";s:1:"1";s:3:"fee";s:3:"0.1";s:6:"appurl";s:20:"http://www.baidu.com";s:3:"url";s:6:"123123";s:12:"wechat_appid";s:18:"wxad33c56a3cc506c1";s:16:"wechat_appSecret";s:32:"856949626c969cd87f897cfe1af43bcc";}'),
('images', 'a:12:{s:6:"market";s:0:"";s:11:"SmallMarket";s:0:"";s:4:"news";s:0:"";s:9:"SmallNews";s:0:"";s:8:"strategy";s:0:"";s:13:"SmallStrategy";s:0:"";s:10:"helpCenter";s:0:"";s:15:"SmallHelpCenter";s:0:"";s:7:"aboutUs";s:47:"/upload/image/20170727/20170727165506_28418.png";s:12:"SmallAboutUs";s:47:"/upload/image/20170727/20170727165513_95765.png";s:10:"userCenter";s:0:"";s:15:"SmallUserCenter";s:0:"";}'),
('jh', 'a:5:{s:6:"tpl_id";s:5:"38400";s:3:"key";s:32:"8294eaadf023b9bc40ae7a30ee9cffd3";s:4:"type";s:2:"jh";s:6:"status";s:1:"1";s:3:"url";s:25:"http://v.juhe.cn/sms/send";}'),
('message', 'a:7:{s:6:"userid";s:3:"170";s:7:"account";s:4:"fxwl";s:8:"password";s:6:"fx1234";s:4:"sign";s:12:"乐众农场";s:6:"status";s:1:"1";s:4:"type";s:7:"message";s:3:"url";s:44:"http://47.96.1.184:8088/sms.aspx?action=send";}'),
('productConfig', 'a:6:{s:8:"buyLevel";s:1:"1";s:9:"sellLevel";s:1:"4";s:8:"openTime";s:1:"8";s:9:"closeTime";s:2:"24";s:11:"tradeStatus";s:1:"1";s:13:"orchardStatus";s:1:"9";}'),
('rebate', '{"1":{"common":{"1":"11","2":"1"}},"2":{"common":{"1":"2","2":"1"}},"3":{"common":{"1":"0","0":"0"}}}'),
('web', 'a:3:{s:9:"pageTitle";s:18:"淘金测试网站";s:4:"info";s:54:"淘金测试网站淘金测试网站淘金测试网站";s:4:"logo";s:47:"/upload/image/20170627/20170627105923_17968.png";}');

-- --------------------------------------------------------

--
-- 表的结构 `dhc_config_slide`
--

CREATE TABLE IF NOT EXISTS `dhc_config_slide` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `title` varchar(100) NOT NULL COMMENT '标题',
  `status` int(11) NOT NULL COMMENT '状态',
  `address` varchar(100) NOT NULL COMMENT '地址',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='幻灯片' AUTO_INCREMENT=11 ;

--
-- 转存表中的数据 `dhc_config_slide`
--

INSERT INTO `dhc_config_slide` (`id`, `title`, `status`, `address`) VALUES
(7, '测试5', 1, '/upload/image/20170329/20170329143807_57708.jpg'),
(10, '123123', 0, '/upload/image/20170721/20170721120019_74229.jpg');

-- --------------------------------------------------------

--
-- 表的结构 `dhc_distribution_list`
--

CREATE TABLE IF NOT EXISTS `dhc_distribution_list` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL,
  `cUid` int(11) unsigned NOT NULL COMMENT '下级uid',
  `level` tinyint(1) unsigned NOT NULL COMMENT '层级',
  `gold` float(11,4) NOT NULL COMMENT '金币变化',
  `type` tinyint(1) unsigned NOT NULL COMMENT '返佣类型: 兑换钻石=1 大盘手续费=2',
  `disType` enum('common','channel') NOT NULL COMMENT '分销商类型1',
  `rebate` float(11,2) unsigned NOT NULL COMMENT '当前分佣比例',
  `amount` float(11,4) unsigned NOT NULL COMMENT '佣金数量',
  `effectTime` int(11) unsigned NOT NULL COMMENT '生效时间',
  `createTime` int(11) unsigned NOT NULL COMMENT '创建时间',
  `updateTime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '领取时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0=未到账 1=已到账',
  `log` varchar(255) NOT NULL COMMENT '日志备注',
  PRIMARY KEY (`id`),
  KEY `createTime` (`createTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_menus`
--

CREATE TABLE IF NOT EXISTS `dhc_menus` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '父级ID',
  `title` varchar(255) NOT NULL,
  `icon` varchar(255) NOT NULL,
  `route` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- 转存表中的数据 `dhc_menus`
--

INSERT INTO `dhc_menus` (`id`, `pid`, `title`, `icon`, `route`) VALUES
(1, 0, '文章管理', 'icon-folder-close', 'aticle'),
(2, 1, '文章分类', '', 'aticle/category'),
(3, 1, '文章列表', '', 'article/list');

-- --------------------------------------------------------

--
-- 表的结构 `dhc_operator_log`
--

CREATE TABLE IF NOT EXISTS `dhc_operator_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `title` varchar(255) NOT NULL COMMENT '操作内容',
  `operator` int(11) NOT NULL COMMENT '操作员',
  `createtime` int(11) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='后台操作员操作日志' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_background`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_background` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL DEFAULT '0',
  `backId` tinyint(11) unsigned NOT NULL DEFAULT '1',
  `backName` varchar(50) NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0',
  `updatetime` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`,`backId`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='果园背景管理' AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `dhc_orchard_background`
--

INSERT INTO `dhc_orchard_background` (`id`, `uid`, `backId`, `backName`, `status`, `createtime`, `updatetime`) VALUES
(1, 1, 1, '初始背景', 1, 1537417210, 1537417210),
(2, 2, 1, '初始背景', 1, 1537422352, 1537422352);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_config`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `total` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '库存种子',
  `upGrade` tinyint(2) unsigned NOT NULL DEFAULT '12' COMMENT '用户最高等级',
  `landInfo` longtext NOT NULL COMMENT '土地信息',
  `landFruit` varchar(500) NOT NULL DEFAULT '0' COMMENT '产生果实信息',
  `landUpInfo` varchar(500) NOT NULL DEFAULT '0' COMMENT '土地升级信息',
  `duiInfo` varchar(500) NOT NULL DEFAULT '0' COMMENT '兑换设置',
  `houseInfo` varchar(2000) NOT NULL DEFAULT '0' COMMENT '房屋升级耗材',
  `dogInfo` text NOT NULL COMMENT '宠物升级经验信息',
  `statueInfo` varchar(500) NOT NULL DEFAULT '0' COMMENT '神像设置',
  `recharge` varchar(500) NOT NULL DEFAULT '0' COMMENT '充值信息',
  `background` varchar(500) NOT NULL DEFAULT '0' COMMENT '背景信息',
  `rebate` varchar(500) NOT NULL DEFAULT '0' COMMENT '充值返佣金额',
  `package` varchar(5000) DEFAULT '0' COMMENT '礼包信息',
  `indemnify` varchar(500) NOT NULL DEFAULT '0' COMMENT '补偿礼包',
  `newGiftPack` text COMMENT '新人礼包信息',
  `sign` varchar(500) NOT NULL DEFAULT '0' COMMENT '签到信息',
  `steal` varchar(5000) NOT NULL DEFAULT '0' COMMENT '好友互偷信息',
  `downgrade` varchar(500) DEFAULT NULL COMMENT '土地降级信息',
  `EMG` varchar(500) DEFAULT NULL COMMENT 'emg授权',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0',
  `updatetime` int(11) unsigned NOT NULL DEFAULT '0',
  `Ouid` int(11) unsigned NOT NULL DEFAULT '0',
  `transferfee` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '金币转账手续费',
  `msgprice` int(11) NOT NULL DEFAULT '100' COMMENT '世界消息价格',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='淘金果园参数' AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `dhc_orchard_config`
--

INSERT INTO `dhc_orchard_config` (`id`, `title`, `total`, `upGrade`, `landInfo`, `landFruit`, `landUpInfo`, `duiInfo`, `houseInfo`, `dogInfo`, `statueInfo`, `recharge`, `background`, `rebate`, `package`, `indemnify`, `newGiftPack`, `sign`, `steal`, `downgrade`, `EMG`, `status`, `createtime`, `updatetime`, `Ouid`, `transferfee`, `msgprice`) VALUES
(1, '乐众农场', 4294923515, 12, '{"1":[{"id":"80004","chance":"100"},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"2":[{"id":"80004","chance":"100"},{"id":"80005","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":"100"},"2":{"id":"80006","chance":""},"3":{"id":"80007","chance":""},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80006","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":"100"},"2":{"id":"80006","chance":""},"3":{"id":"80007","chance":""},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80007","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":"100"},"2":{"id":"80006","chance":""},"3":{"id":"80007","chance":""},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80008","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":"100"},"2":{"id":"80006","chance":""},"3":{"id":"80007","chance":""},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"3":[{"id":"80004","chance":"100"},{"id":"80005","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":""},"2":{"id":"80006","chance":"100"},"3":{"id":"80007","chance":""},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80006","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":""},"2":{"id":"80006","chance":"100"},"3":{"id":"80007","chance":""},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80007","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":""},"2":{"id":"80006","chance":"100"},"3":{"id":"80007","chance":""},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80008","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":""},"2":{"id":"80006","chance":"100"},"3":{"id":"80007","chance":""},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"4":[{"id":"80004","chance":"100"},{"id":"80005","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":""},"2":{"id":"80006","chance":""},"3":{"id":"80007","chance":"100"},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80006","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":""},"2":{"id":"80006","chance":""},"3":{"id":"80007","chance":"100"},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80007","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":""},"2":{"id":"80006","chance":""},"3":{"id":"80007","chance":"100"},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80008","chance":"","0":{"id":"80004","chance":""},"1":{"id":"80005","chance":""},"2":{"id":"80006","chance":""},"3":{"id":"80007","chance":"100"},"4":{"id":"80008","chance":""},"5":{"id":"80009","chance":""},"6":{"id":"80010","chance":""},"7":{"id":"80011","chance":""},"8":{"id":"80012","chance":""},"9":{"id":"80013","chance":""},"10":{"id":"80014","chance":""},"11":{"id":"80015","chance":""}},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"5":{"1":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":"100"},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"2":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":"100"},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"3":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":"100"},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"4":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":"100"},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}]},"6":{"1":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":"100"},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"2":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":"100"},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"3":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":"100"},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"4":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":"100"},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}]},"7":{"1":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":"100"},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"2":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":"100"},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"3":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":"100"},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"4":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":"100"},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}]},"8":{"1":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":"100"},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"2":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":"100"},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"3":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":"100"},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"4":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":"100"},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}]},"9":{"1":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":"100"},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"2":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":"100"},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"3":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":"100"},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}],"4":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":"100"},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":""}]},"10":{"1":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":"100"},{"id":"80014","chance":""},{"id":"80015","chance":""}],"2":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":"100"},{"id":"80014","chance":""},{"id":"80015","chance":""}],"3":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":"100"},{"id":"80014","chance":""},{"id":"80015","chance":""}],"4":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":"100"},{"id":"80014","chance":""},{"id":"80015","chance":""}]},"11":{"1":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":"100"},{"id":"80015","chance":""}],"2":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":"100"},{"id":"80015","chance":""}],"3":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":"100"},{"id":"80015","chance":""}],"4":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":"100"},{"id":"80015","chance":""}]},"12":{"1":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":"100"}],"2":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":"100"}],"3":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":"100"}],"4":[{"id":"80004","chance":""},{"id":"80005","chance":""},{"id":"80006","chance":""},{"id":"80007","chance":""},{"id":"80008","chance":""},{"id":"80009","chance":""},{"id":"80010","chance":""},{"id":"80011","chance":""},{"id":"80012","chance":""},{"id":"80013","chance":""},{"id":"80014","chance":""},{"id":"80015","chance":"100"}]}}', '{"seed":"1000","num":[{"min":"990","med":"995","max":"1000"},{"min":"1040","med":"1045","max":"1050"},{"min":"1090","med":"1095","max":"1100"},{"min":"1190","med":"1195","max":"1200"}]}', '{"2":[{"num":"5000000"},{"pid":"80004","num":"10000"},{"pid":"80005","num":"10000"}],"3":[{"num":"10000000"},{"pid":"80006","num":"10000"},{"pid":"80007","num":"10000"}],"4":[{"num":"20000000"},{"pid":"80012","num":"10000"},{"pid":"80013","num":"10000"}]}', '{"1":{"1":{"pid":"80004","num":"75"},"2":{"pid":"80005","num":"75"}},"2":{"1":{"pid":"80006","num":"150"},"2":{"pid":"80007","num":"150"}},"3":{"1":{"pid":"80012","num":"225"},"2":{"pid":"80013","num":"225"}}}', '{"1":["4000000","","",""],"2":["4000000","","",""],"3":["4000000","","",""],"4":["4000000","","",""],"5":["4000000","","",""],"6":["4000000","","",""],"7":["4000000","","",""],"8":["4000000","","",""],"9":["4000000","","",""],"10":["4000000","","",""],"11":["4000000","","",""]}', '{"experience":{"1":"40","2":"200","3":"300","4":"400","5":"500","6":"600","7":"700","8":"800","9":"900"},"uplimit":"10","num":"1","info":{"1":{"pid":"80004","num":"1","tName":"普通狗粮","depict":"普通狗粮"},"2":{"pid":"80004","num":"2","tName":"优质狗粮","depict":"优质狗粮"}},"power":{"1":"100","0":"10","2":"10","3":"10"},"lucky":{"1":"10","2":"1"},"attack":{"1":{"min":"10","max":"25"},"2":{"min":"2","max":"4"}},"defense":{"1":{"min":"5","max":"14"},"2":{"min":"1","max":"2"}},"speed":{"1":{"min":"8","max":"20"},"2":{"min":"1","max":"3"}},"powerUlimit":{"2":{"min":"2","max":"4"}},"skill":{"1":"48","2":"48","3":"","0":"1000","4":"5","5":"10"}}', '{"1":{"tName":"弑草之神","depict":"供奉弑草之神，可护佑土地上的作物，不受杂草之害。","tId":"13","price":"1","time":"72"},"2":{"tName":"屠虫之神","depict":"供奉屠虫之神，可护佑土地上的作物，不受害虫之坏。","tId":"14","price":"1","time":"72"},"3":{"tName":"雨露之神","depict":"供奉屠虫之神，可护佑土地上的作物，不受干旱之坏。","tId":"15","price":"1","time":"72"},"4":{"tName":"丰收之神","depict":"供奉丰收之神，可护佑土地上的作物，获得没有灾害的最大收益。","tId":"16","price":"1","time":"72"}}', '{"1":{"id":"1","diamonds":"2000","money":"20","give":"0"},"2":{"id":"2","diamonds":"20000","money":"200","give":"800"},"3":{"id":"3","diamonds":"200000","money":"2000","give":"10000"}}', '{"2":{"1":{"pid":"80012","num":"1"},"2":{"pid":"80005","num":"1"},"3":{"num":"4000000"}},"3":{"1":{"pid":"80007","num":"1"},"2":{"pid":"80006","num":"1"},"3":{"num":"6000000"}},"4":{"1":{"pid":"80008","num":"1"},"2":{"pid":"80013","num":"1"},"3":{"num":"8000000"}}}', '0', '{"seed":"50","diamonds":"100000","cfert":"3","hcide":"5","icide":"5","wcan":"5","emerald":"5","purplegem":"5","sapphire":"5","topaz":"5","info":"您成功推荐新玩家获得此礼包","status":"1"}', '{"seed":"","diamonds":"10","cfert":"","hcide":"","icide":"","wcan":"1","emerald":"","purplegem":"","sapphire":"1","topaz":"","info":"123","status":"0"}', '{"seed":"1000","diamonds":"10000","cfert":"1","hcide":"34","icide":"54","wcan":"56","emerald":"34","purplegem":"34","sapphire":"34","topaz":"54","info":"23123","starttime":"1515655871","status":"1"}', '{"daySize":"1","seed":"30","diamonds":"3000","cfert":"1","hcide":"2","icide":"3","wcan":"1","emerald":"1","purplegem":"1","sapphire":"1","topaz":"1","types":"2","status":"1"}', '{"goods":{"1":["80004","80005","80006","80007","80008","80009","80010","80011","80012","80013","80014","80015"],"4":["80004","80005","80006","80007","80008","80009","80010","80011","80012","80013","80014"],"6":["80004","80005","80006","80007","80008","80009","80010","80011","80012","80013","80014","80015"],"7":["80004","80005","80006","80007","80008","80009","80010","80011","80012","80013","80014"],"8":["80004","80005","80006","80007","80008","80009","80010","80011","80012","80013","80014","80015"],"9":["80004","80005","80006","80007","80008","80009","80010","80011","80012","80013","80014","80015"],"10":["80004","80005","80006","80007","80008","80009","80010","80011","80012","80013","80014","80015"],"11":["80004","80005","80006","80007","80008","80009","80010","80011","80012","80013"],"12":["80004","80005","80006","80007","80008","80009","80010","80011","80012","80013","80014","80015"]},"success":{"min":"1","max":"2","power":"10"},"error":{"power":"20","experience":"1"},"chance":["60","10","20"],"dayInfo":{"1":"1000","2":"5"},"status":"1"}', '{"grade":"2","land":{"2":{"day":"0.01","grade":"1"},"3":{"day":"0.01","grade":"2"},"4":{"day":"0.01","grade":"3"},"5":{"day":"0.01","grade":"4"},"6":{"day":"0.01","grade":"5"},"7":{"day":"0.01","grade":"6"},"8":{"day":"0.01","grade":"7"},"9":{"day":"0.1","grade":"8"},"10":{"day":"1","grade":"9"},"11":{"day":"1","grade":"10"}},"status":"0"}', '{"appkey":"EMG201710181607","appSecret":"56ADF02D86494B40A0E44C757D4E228E","httpUrl":"http:\\/\\/test.emghk.net\\/Api\\/"}', 1, 1492095500, 1537411712, 0, '5.00', 40000);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_dog`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_dog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户编号',
  `nickname` varchar(50) NOT NULL COMMENT '用户昵称',
  `mobile` varchar(50) NOT NULL COMMENT '用户电话',
  `goodsId` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品id或0',
  `dogName` varchar(50) NOT NULL COMMENT '宠物昵称',
  `dogLevel` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '宠物等级',
  `experience` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '宠物经验值',
  `power` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '体力活力动力值',
  `powerUlimit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '体力生活上限',
  `otherInfo` varchar(500) NOT NULL DEFAULT '0' COMMENT '宠物其他基本信息',
  `harvestTime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '收货时效',
  `sowingTime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '播种时效',
  `speed` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '进度玫瑰1000 规0',
  `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评分',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `optime` int(11) unsigned NOT NULL DEFAULT '0',
  `isDel` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '删除状态 1',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='淘金果园宠物记录表' AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `dhc_orchard_dog`
--

INSERT INTO `dhc_orchard_dog` (`id`, `uid`, `nickname`, `mobile`, `goodsId`, `dogName`, `dogLevel`, `experience`, `power`, `powerUlimit`, `otherInfo`, `harvestTime`, `sowingTime`, `speed`, `score`, `status`, `createtime`, `updatetime`, `optime`, `isDel`) VALUES
(1, 1, '天镜爱城', '15383205920', 0, '松狮', 1, 0, 0, 100, '{"lucky":"10","attack":{"min":"10","max":"25"},"defense":{"min":"5","max":"14"},"speed":{"min":"8","max":"20"}}', 0, 0, 0, 182, 1, 1537417214, 1545448993, 1544414672, 0),
(2, 2, '通沽临汾', '13932049739', 0, '松狮', 1, 0, 0, 100, '{"lucky":"10","attack":{"min":"10","max":"25"},"defense":{"min":"5","max":"14"},"speed":{"min":"8","max":"20"}}', 0, 0, 0, 182, 0, 1537422356, 1537422356, 1537422356, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_double_effect`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_double_effect` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `types` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  `mark` varchar(50) NOT NULL DEFAULT '0',
  `nums` int(11) unsigned NOT NULL DEFAULT '0',
  `msg` varchar(500) NOT NULL DEFAULT '0' COMMENT '消息',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `lasttime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '到期时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_downgrade`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_downgrade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL DEFAULT '0',
  `houseLv` int(11) unsigned NOT NULL DEFAULT '0',
  `grade` int(11) unsigned NOT NULL DEFAULT '0',
  `htime` int(11) unsigned NOT NULL DEFAULT '0',
  `info` varchar(500) NOT NULL,
  `createtime` int(11) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`,`houseLv`,`grade`,`htime`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='房屋掉级记录' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_goods`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_goods` (
  `tId` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `type` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '定义类型',
  `tName` varchar(50) NOT NULL COMMENT '商品名字',
  `depict` varchar(500) NOT NULL COMMENT '商品简介',
  `price` decimal(10,3) unsigned NOT NULL DEFAULT '0.000' COMMENT '商品价格',
  `effect` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '效果值',
  `pack` int(11) unsigned NOT NULL DEFAULT '1' COMMENT '一次性购买量 打包购买',
  `buyOut` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '购买上限',
  `cost` varchar(500) NOT NULL COMMENT '宝箱需要信息',
  `chanceInfo` varchar(500) NOT NULL COMMENT '各商品概率',
  `reclaimLimit` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '会员购买需等级',
  `seedUser` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '赠送种子用户',
  `seedShop` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '返回平台种子数量',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态',
  `isDel` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='淘金果园商品表' AUTO_INCREMENT=21 ;

--
-- 转存表中的数据 `dhc_orchard_goods`
--

INSERT INTO `dhc_orchard_goods` (`tId`, `type`, `tName`, `depict`, `price`, `effect`, `pack`, `buyOut`, `cost`, `chanceInfo`, `reclaimLimit`, `seedUser`, `seedShop`, `createtime`, `updatetime`, `status`, `isDel`) VALUES
(1, 1, '种子', '谜一样的种子121323', '1.525', 9000, 1000, 9999999, '0', '{"winning":[{"goodsId":"80004","min":"","max":""},{"goodsId":"80004","min":"","max":""},{"goodsId":"coin","min":"","max":""}],"desc":"","power":{"1":""},"lucky":{"1":""},"attack":{"1":{"min":"","max":""}},"defense":{"1":{"min":"","max":""}},"speed":{"1":{"min":"","max":""}},"count":{"size":""},"baoshi":{"1":{"chance":"","mark":"emerald"},"2":{"chance":"","mark":"purplegem"},"3":{"chance":"","mark":"sapphire"},"4":{"chance":"","mark":"topaz"}}}', 0, 0, 0, 1491891927, 1502356410, 1, 0),
(2, 4, '铜锄头', '用它来铲地，可产生种子,限时5折。', '1.500', 0, 100, 0, '0', '{"winning":[{"goodsId":"80004","min":"","max":""},{"goodsId":"80004","min":"","max":""},{"goodsId":"coin","min":"","max":""}],"desc":"","power":{"1":""},"lucky":{"1":""},"attack":{"1":{"min":"","max":""}},"defense":{"1":{"min":"","max":""}},"speed":{"1":{"min":"","max":""}},"count":{"size":"20"},"baoshi":{"1":{"chance":"25","mark":"emerald"},"2":{"chance":"25","mark":"purplegem"},"3":{"chance":"25","mark":"sapphire"},"4":{"chance":"25","mark":"topaz"}}}', 6, 3, 17, 1491914334, 1499068449, 1, 0),
(3, 4, '银锄头', '用它来铲地，可产生种子,限时5折。', '4.000', 0, 100, 0, '0', '{"winning":[{"goodsId":"80004","min":"","max":""},{"goodsId":"80004","min":"","max":""},{"goodsId":"coin","min":"","max":""}],"desc":"","power":{"1":""},"lucky":{"1":""},"attack":{"1":{"min":"","max":""}},"defense":{"1":{"min":"","max":""}},"speed":{"1":{"min":"","max":""}},"count":{"size":"40"},"baoshi":{"1":{"chance":"25","mark":"emerald"},"2":{"chance":"25","mark":"purplegem"},"3":{"chance":"25","mark":"sapphire"},"4":{"chance":"25","mark":"topaz"}}}', 8, 8, 12, 1491914358, 1495935487, 1, 0),
(4, 3, '铜宝箱', '用200萝卜、100苹果，抽出大奖！', '100.000', 0, 1, 0, '[["80004","200"],["80005","100"]]', '{"winning":[{"goodsId":"80004","min":"200","max":"300"},{"goodsId":"80005","min":"100","max":"200"},{"goodsId":"coin","min":"100","max":"150"}],"desc":"","power":{"1":""},"lucky":{"1":""},"attack":{"1":{"min":"","max":""}},"defense":{"1":{"min":"","max":""}},"speed":{"1":{"min":"","max":""}}}', 0, 0, 0, 1491917742, 1495605647, 1, 0),
(5, 3, '银宝箱', '6666', '200.000', 0, 1, 0, '[["80006","100"],["80007","50"]]', '{"winning":[{"goodsId":"80004","min":"","max":""},{"goodsId":"80004","min":"","max":""},{"goodsId":"coin","min":"","max":""}],"desc":"6666","power":{"1":""},"lucky":{"1":""},"attack":{"1":{"min":"","max":""}},"defense":{"1":{"min":"","max":""}},"speed":{"1":{"min":"","max":""}},"count":{"size":""},"baoshi":{"1":{"chance":"","mark":"emerald"},"2":{"chance":"","mark":"purplegem"},"3":{"chance":"","mark":"sapphire"},"4":{"chance":"","mark":"topaz"}}}', 0, 0, 0, 1491917790, 1501142026, 1, 0),
(6, 3, '金宝箱', '用50南瓜、25草莓，抽出大奖！', '500.000', 0, 1, 0, '[["80012","50"],["80013","25"]]', '{"winning":[{"goodsId":"80012","min":"30","max":"80"},{"goodsId":"80013","min":"20","max":"60"},{"goodsId":"coin","min":"100","max":"600"}],"desc":"","power":{"1":""},"lucky":{"1":""},"attack":{"1":{"min":"","max":""}},"defense":{"1":{"min":"","max":""}},"speed":{"1":{"min":"","max":""}}}', 0, 0, 0, 1491917790, 1495605933, 1, 0),
(7, 3, '钻石宝箱', '123123', '500.000', 0, 1, 0, '[["80011","2"],["80004","122"]]', '{"winning":[{"goodsId":"80011","min":"","max":""},{"goodsId":"80009","min":"","max":""},{"goodsId":"coin","min":"1","max":"1500"}],"desc":"可能获得的奖励： 1000~10000金币","power":{"1":""},"lucky":{"1":""},"attack":{"1":{"min":"","max":""}},"defense":{"1":{"min":"","max":""}},"speed":{"1":{"min":"","max":""}},"count":{"size":""},"baoshi":{"1":{"chance":"","mark":"emerald"},"2":{"chance":"","mark":"purplegem"},"3":{"chance":"","mark":"sapphire"},"4":{"chance":"","mark":"topaz"}}}', 0, 0, 0, 1491917790, 1500861099, 1, 0),
(8, 5, '松狮', '松狮犬，1000钻石，限时五折，8级可购买', '500.000', 0, 1, 0, '0', '{"winning":[{"goodsId":"80004","min":"","max":""},{"goodsId":"80004","min":"","max":""},{"goodsId":"coin","min":"","max":""}],"desc":"","power":{"1":"1000"},"lucky":{"1":"10"},"attack":{"1":{"min":"1","max":"5"}},"defense":{"1":{"min":"1","max":"5"}},"speed":{"1":{"min":"1","max":"5"}},"count":{"size":""},"baoshi":{"1":{"chance":"","mark":"emerald"},"2":{"chance":"","mark":"purplegem"},"3":{"chance":"","mark":"sapphire"},"4":{"chance":"","mark":"topaz"}}}', 8, 0, 0, 1491917790, 1499068553, 1, 0),
(9, 6, '化肥', '减少生长时间3小时，每个阶段仅限施肥一次。', '200.000', 10800, 1, 0, '', '', 0, 0, 0, 1491917790, 1492413757, 1, 0),
(10, 7, '洒水壶', '用来浇水', '5.000', 9000, 1, 0, '0', '{"winning":[{"goodsId":"80004","min":"","max":""},{"goodsId":"80004","min":"","max":""},{"goodsId":"coin","min":"","max":""}],"desc":"","power":{"1":""},"lucky":{"1":""},"attack":{"1":{"min":"","max":""}},"defense":{"1":{"min":"","max":""}},"speed":{"1":{"min":"","max":""}},"count":{"size":""},"baoshi":{"1":{"chance":"","mark":"emerald"},"2":{"chance":"","mark":"purplegem"},"3":{"chance":"","mark":"sapphire"},"4":{"chance":"","mark":"topaz"}}}', 0, 0, 0, 1491917790, 1499479704, 1, 0),
(11, 8, '除草剂', '清除地里杂草。', '5.000', 9000, 1, 0, ' ', '', 0, 0, 0, 1491917790, 1491969121, 1, 0),
(12, 9, '除虫剂', '清除地里害虫。', '5.000', 9000, 1, 0, ' ', '', 0, 0, 0, 1491917790, 1491969137, 1, 0),
(13, 10, '绿宝石', '绿色的宝石，用于供奉弑草之神。', '100.000', 9000, 1, 0, ' ', '', 0, 0, 0, 1491917790, 1491969098, 1, 0),
(14, 11, '紫宝石', '紫色的宝石，用于供奉屠虫之神。', '100.000', 9000, 1, 0, ' ', '', 0, 0, 0, 1491917790, 1491969212, 1, 0),
(15, 12, '蓝宝石', '蓝色的宝石，用于供奉雨露之神。', '100.000', 9000, 1, 0, '', '', 0, 0, 0, 1491917790, 1492221026, 1, 0),
(16, 13, '黄宝石', '用于供奉丰收之神', '100.000', 9000, 1, 0, '', '', 0, 0, 0, 1492169371, 1492220968, 0, 0),
(17, 13, '黄宝石', '黄色的宝石，用于供奉丰收之神。', '100.000', 9000, 0, 0, '0', '{"winning":[{"goodsId":"80004","min":"","max":""},{"goodsId":"80004","min":"","max":""},{"goodsId":"coin","min":"","max":""}],"desc":"","power":{"1":""},"lucky":{"1":""},"attack":{"1":{"min":"","max":""}},"defense":{"1":{"min":"","max":""}},"speed":{"1":{"min":"","max":""}},"count":{"size":""},"baoshi":{"1":{"chance":"","mark":"emerald"},"2":{"chance":"","mark":"purplegem"},"3":{"chance":"","mark":"sapphire"},"4":{"chance":"","mark":"topaz"}}}', 0, 0, 0, 1495905212, 1495905295, 1, 0),
(18, 15, '红土地卡', '用于免费将黄土地升级为红土地', '1000.000', 0, 1, 0, '', '', 0, 0, 0, 0, 0, 0, 0),
(19, 15, '黑土地卡', '可以免费将红土地升级为黑土地', '3000.000', 0, 1, 0, '', '', 0, 0, 0, 0, 0, 0, 0),
(20, 15, '金土地卡', '可以免费将黑土地升级为金土地', '5000.000', 0, 1, 0, '', '', 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_hail_fellow`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_hail_fellow` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL DEFAULT '0',
  `huid` int(11) unsigned NOT NULL DEFAULT '0',
  `nickname` varchar(50) NOT NULL,
  `mobile` varchar(50) NOT NULL,
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1 通过 0 审核 9 拒绝',
  `isAdd` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '发起身份',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0',
  `updatetime` int(11) unsigned NOT NULL DEFAULT '0',
  `isDel` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='淘金果园好友记录表' AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `dhc_orchard_hail_fellow`
--

INSERT INTO `dhc_orchard_hail_fellow` (`id`, `uid`, `huid`, `nickname`, `mobile`, `status`, `isAdd`, `createtime`, `updatetime`, `isDel`) VALUES
(1, 2, 1, '天镜爱城', '15383205920', 1, 1, 1537422352, 1537422352, 0),
(2, 1, 2, '通沽临汾', '13932049739', 1, 0, 1537422352, 1537422352, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_land`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_land` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL DEFAULT '0',
  `nickname` varchar(50) NOT NULL DEFAULT '无昵称',
  `mobile` varchar(50) NOT NULL DEFAULT '0',
  `landLevel` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '土地类型 1普 2红 3 黑 4 金',
  `landId` tinyint(2) NOT NULL DEFAULT '1',
  `goodsId` int(11) NOT NULL DEFAULT '0' COMMENT '产生种子ID',
  `goodsNums` int(11) NOT NULL DEFAULT '0' COMMENT '产生种子数量',
  `goodsName` varchar(50) NOT NULL DEFAULT '无',
  `fertilize` varchar(500) NOT NULL DEFAULT '0' COMMENT '施肥次数状态',
  `plowing` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '翻地状态',
  `landStatus` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '土地状态',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后一次更新时间',
  `optime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户操作时间',
  `seedtime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '种子播种时间',
  `wcan` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '浇水状态',
  `hcide` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '除草状态',
  `icide` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '除虫状态',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_2` (`uid`,`landId`) USING BTREE,
  KEY `uid` (`uid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `dhc_orchard_land`
--

INSERT INTO `dhc_orchard_land` (`id`, `uid`, `nickname`, `mobile`, `landLevel`, `landId`, `goodsId`, `goodsNums`, `goodsName`, `fertilize`, `plowing`, `landStatus`, `createtime`, `updatetime`, `optime`, `seedtime`, `wcan`, `hcide`, `icide`) VALUES
(1, 1, '天镜爱城', '15383205920', 1, 0, 80004, 996, '萝卜', '0', 0, 5, 1537417210, 1537417210, 1545448992, 1537417225, 5, 5, 5),
(2, 2, '通沽临汾', '13932049739', 1, 0, 0, 0, '无', '0', 1, 0, 1537422352, 1537928031, 1537928033, 1537422363, 0, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_logs`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL DEFAULT '0',
  `mobile` varchar(50) NOT NULL,
  `disUid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '来源uid',
  `landId` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '土地编号',
  `types` varchar(50) NOT NULL,
  `nums` decimal(11,2) NOT NULL DEFAULT '0.00',
  `msg` varchar(500) NOT NULL,
  `dataInfo` varchar(5000) NOT NULL DEFAULT '0' COMMENT '附带数据存储',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `uid_2` (`uid`,`landId`,`types`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='淘金果园日志表' AUTO_INCREMENT=28 ;

--
-- 转存表中的数据 `dhc_orchard_logs`
--

INSERT INTO `dhc_orchard_logs` (`id`, `uid`, `mobile`, `disUid`, `landId`, `types`, `nums`, `msg`, `dataInfo`, `createtime`, `status`) VALUES
(1, 1, '15383205920', 0, 0, 'addseed', '1000.00', '新手礼包礼包获得普通种子*1000', '0', 1537417219, 1),
(2, 1, '15383205920', 0, 0, 'adddiamonds', '10000.00', '新手礼包礼包获得金币*10000', '0', 1537417219, 1),
(3, 1, '15383205920', 0, 0, 'addcfert', '1.00', '新手礼包礼包获得化肥*1', '0', 1537417219, 1),
(4, 1, '15383205920', 0, 0, 'addhcide', '34.00', '新手礼包礼包获得除草剂*34', '0', 1537417219, 1),
(5, 1, '15383205920', 0, 0, 'addicide', '54.00', '新手礼包礼包获得除虫剂*54', '0', 1537417219, 1),
(6, 1, '15383205920', 0, 0, 'addwcan', '56.00', '新手礼包礼包获得洒水壶*56', '0', 1537417219, 1),
(7, 1, '15383205920', 0, 0, 'addemerald', '34.00', '新手礼包礼包获得绿宝石*34', '0', 1537417219, 1),
(8, 1, '15383205920', 0, 0, 'addpurplegem', '34.00', '新手礼包礼包获得紫宝石*34', '0', 1537417219, 1),
(9, 1, '15383205920', 0, 0, 'addsapphire', '34.00', '新手礼包礼包获得蓝宝石*34', '0', 1537417219, 1),
(10, 1, '15383205920', 0, 0, 'addtopaz', '54.00', '新手礼包礼包获得黄宝石*54', '0', 1537417219, 1),
(11, 1, '15383205920', 0, 0, 'addwcan', '1.00', '天镜爱城签到获得洒水壶*1', '0', 1537417223, 1),
(12, 1, '15383205920', 0, 0, 'dedseed', '-1000.00', '【0号土地】播种扣除种子1000个', '0', 1537417225, 1),
(13, 2, '13932049739', 0, 0, 'addseed', '1000.00', '新手礼包礼包获得普通种子*1000', '0', 1537422359, 1),
(14, 2, '13932049739', 0, 0, 'adddiamonds', '10000.00', '新手礼包礼包获得金币*10000', '0', 1537422359, 1),
(15, 2, '13932049739', 0, 0, 'addcfert', '1.00', '新手礼包礼包获得化肥*1', '0', 1537422359, 1),
(16, 2, '13932049739', 0, 0, 'addhcide', '34.00', '新手礼包礼包获得除草剂*34', '0', 1537422359, 1),
(17, 2, '13932049739', 0, 0, 'addicide', '54.00', '新手礼包礼包获得除虫剂*54', '0', 1537422359, 1),
(18, 2, '13932049739', 0, 0, 'addwcan', '56.00', '新手礼包礼包获得洒水壶*56', '0', 1537422359, 1),
(19, 2, '13932049739', 0, 0, 'addemerald', '34.00', '新手礼包礼包获得绿宝石*34', '0', 1537422359, 1),
(20, 2, '13932049739', 0, 0, 'addpurplegem', '34.00', '新手礼包礼包获得紫宝石*34', '0', 1537422359, 1),
(21, 2, '13932049739', 0, 0, 'addsapphire', '34.00', '新手礼包礼包获得蓝宝石*34', '0', 1537422359, 1),
(22, 2, '13932049739', 0, 0, 'addtopaz', '54.00', '新手礼包礼包获得黄宝石*54', '0', 1537422359, 1),
(23, 2, '13932049739', 0, 0, 'addcfert', '1.00', '通沽临汾签到获得化肥*1', '0', 1537422361, 1),
(24, 2, '13932049739', 0, 0, 'dedseed', '-1000.00', '【0号土地】播种扣除种子1000个', '0', 1537422363, 1),
(25, 2, '13932049739', 0, 0, 'addhcide', '2.00', '通沽临汾签到获得除草剂*2', '0', 1537928029, 1),
(26, 2, '13932049739', 0, 0, 'addgoods', '996.00', '【0】号土地收获萝卜996颗', '0', 1537928031, 1),
(27, 1, '15383205920', 0, 0, 'addwcan', '1.00', '天镜爱城签到获得洒水壶*1', '0', 1544414669, 1);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_order`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员uid',
  `nickname` varchar(50) NOT NULL COMMENT '会员信息',
  `mobile` varchar(50) NOT NULL COMMENT '会员信息',
  `orderId` varchar(50) NOT NULL COMMENT '订单号',
  `types` varchar(50) NOT NULL COMMENT '类型',
  `coing` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '扣除数量',
  `fruit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '获得数量',
  `payStatus` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '支付状态',
  `payTime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='淘金果园订单记录表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_package`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL,
  `types` varchar(50) NOT NULL,
  `info` varchar(500) NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0',
  `updatetime` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='果园礼包' AUTO_INCREMENT=4 ;

--
-- 转存表中的数据 `dhc_orchard_package`
--

INSERT INTO `dhc_orchard_package` (`id`, `uid`, `types`, `info`, `status`, `createtime`, `updatetime`) VALUES
(1, 1, 'newGiftPack', '{"seed":"1000","diamonds":"10000","cfert":"1","hcide":"34","icide":"54","wcan":"56","emerald":"34","purplegem":"34","sapphire":"34","topaz":"54","info":"23123","starttime":"1515655871","status":"1"}', 1, 1537417208, 1537417219),
(2, 2, 'newGiftPack', '{"seed":"1000","diamonds":"10000","cfert":"1","hcide":"34","icide":"54","wcan":"56","emerald":"34","purplegem":"34","sapphire":"34","topaz":"54","info":"23123","starttime":"1515655871","status":"1"}', 1, 1537422349, 1537422359),
(3, 3, 'newGiftPack', '{"seed":"1000","diamonds":"10000","cfert":"1","hcide":"34","icide":"54","wcan":"56","emerald":"34","purplegem":"34","sapphire":"34","topaz":"54","info":"23123","starttime":"1515655871","status":"1"}', 0, 1537422431, 1537422431);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_sign`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_sign` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL DEFAULT '0',
  `config` varchar(500) NOT NULL DEFAULT '0',
  `signLevel` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `info` varchar(500) NOT NULL DEFAULT '0',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='果园签到记录表' AUTO_INCREMENT=5 ;

--
-- 转存表中的数据 `dhc_orchard_sign`
--

INSERT INTO `dhc_orchard_sign` (`id`, `uid`, `config`, `signLevel`, `info`, `createtime`) VALUES
(1, 1, '{"daySize":"1","seed":"30","diamonds":"3000","cfert":"1","hcide":"2","icide":"3","wcan":"1","emerald":"1","purplegem":"1","sapphire":"1","topaz":"1","types":"2","status":"1"}', 2, '{"wcan":"1"}', 1537417223),
(2, 2, '{"daySize":"1","seed":"30","diamonds":"3000","cfert":"1","hcide":"2","icide":"3","wcan":"1","emerald":"1","purplegem":"1","sapphire":"1","topaz":"1","types":"2","status":"1"}', 2, '{"cfert":"1"}', 1537422361),
(3, 2, '{"daySize":"1","seed":"30","diamonds":"3000","cfert":"1","hcide":"2","icide":"3","wcan":"1","emerald":"1","purplegem":"1","sapphire":"1","topaz":"1","types":"2","status":"1"}', 2, '{"hcide":"2"}', 1537928029),
(4, 1, '{"daySize":"1","seed":"30","diamonds":"3000","cfert":"1","hcide":"2","icide":"3","wcan":"1","emerald":"1","purplegem":"1","sapphire":"1","topaz":"1","types":"2","status":"1"}', 2, '{"wcan":"1"}', 1544414669);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_statue`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_statue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'uid',
  `model` varchar(50) NOT NULL DEFAULT '0' COMMENT '类型',
  `statueName` varchar(50) NOT NULL DEFAULT '0' COMMENT '名称',
  `nums` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '兑换数量',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `lasttime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_2` (`uid`,`model`) USING BTREE,
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='果园神像记录表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_steal`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_steal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `huid` int(11) NOT NULL,
  `dogInfo` text NOT NULL,
  `dogStatus` tinyint(1) NOT NULL DEFAULT '0' COMMENT '宠物状态',
  `chance` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `mt` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `landInfo` varchar(5000) NOT NULL DEFAULT '0',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_orchard_user`
--

CREATE TABLE IF NOT EXISTS `dhc_orchard_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '会员uid',
  `nickname` varchar(50) NOT NULL DEFAULT '无' COMMENT '昵称',
  `mobile` varchar(50) NOT NULL DEFAULT '0',
  `avatar` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '头像选择id',
  `diamonds` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '钻石',
  `skin` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '皮肤',
  `wood` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '木材',
  `stone` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '石材',
  `steel` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '钢材',
  `grade` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '房屋等级',
  `dogFood1` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通狗粮',
  `dogFood2` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '优质狗粮2',
  `roseSeed` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '玫瑰花种子',
  `seed` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通种子 废弃',
  `choe` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '铜锄头',
  `shoe` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '银锄头',
  `cchest` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '铜宝箱',
  `schest` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '银宝箱',
  `gchest` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '金宝箱',
  `dchest` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '钻石宝箱',
  `cfert` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '化肥',
  `wcan` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '洒水壶',
  `hcide` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '除草剂',
  `icide` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '除虫剂',
  `emerald` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '绿宝石',
  `purplegem` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '紫宝石',
  `sapphire` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '蓝宝石',
  `topaz` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '黄宝石',
  `kuguazhi` int(11) unsigned NOT NULL DEFAULT '0',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0',
  `updatetime` int(11) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态 1正常 9 禁用',
  `redcard` int(11) NOT NULL DEFAULT '0' COMMENT '红土地卡',
  `blackcard` int(11) NOT NULL DEFAULT '0' COMMENT '黑土地卡',
  `goldcard` int(11) NOT NULL DEFAULT '0' COMMENT '金土地卡',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='果园会员信息表' AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `dhc_orchard_user`
--

INSERT INTO `dhc_orchard_user` (`id`, `uid`, `nickname`, `mobile`, `avatar`, `diamonds`, `skin`, `wood`, `stone`, `steel`, `grade`, `dogFood1`, `dogFood2`, `roseSeed`, `seed`, `choe`, `shoe`, `cchest`, `schest`, `gchest`, `dchest`, `cfert`, `wcan`, `hcide`, `icide`, `emerald`, `purplegem`, `sapphire`, `topaz`, `kuguazhi`, `createtime`, `updatetime`, `status`, `redcard`, `blackcard`, `goldcard`) VALUES
(1, 1, '天镜爱城', '15383205920', 4, 10000, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 58, 34, 54, 34, 34, 34, 54, 0, 1537417210, 1544414669, 1, 0, 0, 0),
(2, 2, '通沽临汾', '13932049739', 4, 10000, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 56, 36, 54, 34, 34, 34, 54, 0, 1537422352, 1537928029, 1, 0, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_raiders_reward`
--

CREATE TABLE IF NOT EXISTS `dhc_raiders_reward` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `rid` int(11) unsigned NOT NULL COMMENT '攻略id',
  `uid` int(11) unsigned NOT NULL COMMENT '打赏用户id',
  `auth` int(11) unsigned NOT NULL COMMENT '作者id',
  `productid` int(11) unsigned NOT NULL COMMENT '打赏产品id',
  `productnum` int(11) unsigned NOT NULL COMMENT '打赏产品数量',
  `createtime` int(11) unsigned NOT NULL COMMENT '打赏时间',
  `discuss` varchar(100) NOT NULL COMMENT '评论',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='打赏记录表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_trade_dailydate`
--

CREATE TABLE IF NOT EXISTS `dhc_trade_dailydate` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `sid` int(11) unsigned NOT NULL COMMENT '产品id',
  `OpeningPrice` decimal(10,5) unsigned DEFAULT '0.00000' COMMENT '开盘价格',
  `ClosingPrice` decimal(10,5) unsigned DEFAULT '0.00000' COMMENT '收盘价格',
  `HighestPrice` decimal(10,5) unsigned NOT NULL COMMENT '最高价格',
  `LowestPrice` decimal(10,5) unsigned NOT NULL COMMENT '最低价格',
  `Volume` int(11) unsigned DEFAULT '0' COMMENT '成交数量',
  `Date` int(11) unsigned NOT NULL COMMENT '当日时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='日数据表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_trade_dailydates`
--

CREATE TABLE IF NOT EXISTS `dhc_trade_dailydates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `sid` int(11) unsigned NOT NULL COMMENT '产品id',
  `OpeningPrice` decimal(10,5) unsigned DEFAULT '0.00000' COMMENT '开盘价格',
  `ClosingPrice` decimal(10,5) unsigned DEFAULT '0.00000' COMMENT '收盘价格',
  `HighestPrice` decimal(10,5) unsigned NOT NULL COMMENT '最高价格',
  `LowestPrice` decimal(10,5) unsigned NOT NULL COMMENT '最低价格',
  `Volume` int(11) unsigned DEFAULT '0' COMMENT '成交数量',
  `Date` int(11) unsigned NOT NULL COMMENT '当日时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='日数据表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_trade_logs`
--

CREATE TABLE IF NOT EXISTS `dhc_trade_logs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uid` int(11) unsigned NOT NULL COMMENT '用户id',
  `mobile` varchar(100) NOT NULL COMMENT '手机号',
  `num` decimal(10,5) unsigned NOT NULL COMMENT '数量',
  `logs` varchar(255) NOT NULL COMMENT '操作内容',
  `createtime` int(11) unsigned NOT NULL COMMENT '操作时间',
  `status` tinyint(4) unsigned NOT NULL COMMENT '状态',
  `type` varchar(100) NOT NULL COMMENT '操作类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='大盘日志表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_trade_order`
--

CREATE TABLE IF NOT EXISTS `dhc_trade_order` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uid` int(11) unsigned NOT NULL COMMENT '挂单用户id',
  `sid` int(11) unsigned NOT NULL COMMENT '产品id',
  `number` int(11) unsigned NOT NULL COMMENT '挂单数量',
  `price` decimal(10,5) unsigned NOT NULL COMMENT '挂单价格',
  `goods` varchar(255) NOT NULL COMMENT '挂单货物名称',
  `createtime` int(11) unsigned NOT NULL COMMENT '挂单时间',
  `type` tinyint(4) NOT NULL COMMENT '挂单类型',
  `status` int(11) unsigned NOT NULL COMMENT '挂单状态',
  `endtime` int(11) unsigned DEFAULT NULL COMMENT '结束时间',
  `dealnum` int(11) unsigned DEFAULT '0' COMMENT '已成交数量',
  `bid` int(11) unsigned DEFAULT NULL COMMENT '交易用户id',
  `fee` decimal(10,5) DEFAULT '0.00000' COMMENT '手续费',
  `dealprice` decimal(10,5) DEFAULT NULL COMMENT '成交价格',
  `dealMoney` decimal(11,5) DEFAULT '0.00000' COMMENT '成交价格',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE,
  KEY `sid` (`sid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='挂单表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_trade_product`
--

CREATE TABLE IF NOT EXISTS `dhc_trade_product` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `thumb` varchar(255) NOT NULL COMMENT '产品缩略图',
  `startprice` decimal(10,5) unsigned NOT NULL COMMENT '初始价格',
  `createtime` int(11) NOT NULL COMMENT '创建时间',
  `status` tinyint(4) NOT NULL COMMENT '状态',
  `title` varchar(255) NOT NULL COMMENT '产品名称',
  `depict` varchar(500) DEFAULT NULL COMMENT '简介',
  `rise` decimal(10,4) NOT NULL COMMENT '涨幅',
  `fall` decimal(10,4) NOT NULL COMMENT '跌幅',
  `poundage` decimal(10,4) NOT NULL COMMENT '交易手续费',
  `seedTime` decimal(5,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '种子周期',
  `sproutingTime` decimal(5,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '发芽周期',
  `growTime` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT '生长周期',
  `displayorder` int(11) unsigned DEFAULT '0',
  `tradeStatus` tinyint(4) DEFAULT '1' COMMENT '开盘状态',
  `chanceinfo` varchar(3000) NOT NULL COMMENT '使用获得道具概率信息',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='产品表' AUTO_INCREMENT=80017 ;

--
-- 转存表中的数据 `dhc_trade_product`
--

INSERT INTO `dhc_trade_product` (`id`, `thumb`, `startprice`, `createtime`, `status`, `title`, `depict`, `rise`, `fall`, `poundage`, `seedTime`, `sproutingTime`, `growTime`, `displayorder`, `tradeStatus`, `chanceinfo`) VALUES
(1, '/upload/image/20170331/20170331153132_36103.png', '100.00000', 1490945505, 1, '种子', '', '0.0003', '0.0003', '0.0100', '8.00', '8.00', '8.00', 0, 1, ''),
(80004, '/upload/image/20170711/20170711175601_46564.jpg', '2040.00000', 1492095591, 1, '萝卜', '萝卜可用于普通土地升级红土地，也可兑换木头，升级房屋。', '0.2000', '0.1000', '0.0100', '8.00', '8.00', '8.00', 2, 0, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2100"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"0","min":"0","max":"0"},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"2"},{"tid":"10","percent":"5","min":"1","max":"2"},{"tid":"11","percent":"5","min":"1","max":"2"},{"tid":"12","percent":"5","min":"1","max":"2"},{"tid":"13","percent":"","min":"","max":""},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}'),
(80005, '/upload/image/20170711/20170711175617_89672.jpg', '2060.00000', 1492095942, 1, '苹果', '苹果可用于普通土地升级红土地，也可兑换木头，升级房屋。', '0.1000', '0.1000', '0.0005', '8.00', '8.00', '8.00', 0, 1, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2100"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"","min":"","max":""},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"1"},{"tid":"10","percent":"3","min":"1","max":"3"},{"tid":"11","percent":"3","min":"1","max":"3"},{"tid":"12","percent":"3","min":"1","max":"3"},{"tid":"13","percent":"","min":"","max":""},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}'),
(80006, '/upload/image/20170414/20170414145604_37067.png', '2062.00000', 1492095987, 1, '辣椒', '', '0.0100', '0.0050', '0.0100', '8.00', '8.00', '8.00', 0, 1, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2200"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"","min":"","max":""},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"1"},{"tid":"10","percent":"3","min":"1","max":"3"},{"tid":"11","percent":"3","min":"1","max":"3"},{"tid":"12","percent":"3","min":"1","max":"3"},{"tid":"13","percent":"","min":"","max":""},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}'),
(80007, '/upload/image/20170414/20170414145617_32763.png', '2064.00000', 1492096002, 1, '西瓜', '', '0.1000', '0.0002', '0.1000', '8.00', '8.00', '8.00', 0, 1, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2200"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"","min":"","max":""},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"1"},{"tid":"10","percent":"3","min":"1","max":"3"},{"tid":"11","percent":"3","min":"1","max":"3"},{"tid":"12","percent":"3","min":"1","max":"3"},{"tid":"13","percent":"","min":"","max":""},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}'),
(80008, '/upload/image/20170414/20170414145830_93671.png', '2066.00000', 1492096326, 1, '核桃', '', '0.1000', '0.1000', '0.0100', '8.00', '8.00', '8.00', 0, 1, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2200"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"","min":"","max":""},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"1"},{"tid":"10","percent":"3","min":"1","max":"3"},{"tid":"11","percent":"3","min":"1","max":"3"},{"tid":"12","percent":"3","min":"1","max":"3"},{"tid":"13","percent":"","min":"","max":""},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}'),
(80009, '/upload/image/20170414/20170414145659_40517.png', '2068.00000', 1492096340, 1, '可可', '', '0.1000', '0.1000', '0.0100', '8.00', '8.00', '8.00', 0, 1, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2200"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"","min":"","max":""},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"1"},{"tid":"10","percent":"3","min":"1","max":"3"},{"tid":"11","percent":"3","min":"1","max":"3"},{"tid":"12","percent":"3","min":"1","max":"3"},{"tid":"13","percent":"","min":"","max":""},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}'),
(80010, '/upload/image/20170414/20170414145712_58578.png', '2070.00000', 1492096368, 1, '人参', '人参人参人参人参人参人参', '0.1000', '0.1000', '0.0100', '8.00', '8.00', '8.00', 0, 1, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2200"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"","min":"","max":""},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"1"},{"tid":"10","percent":"3","min":"1","max":"3"},{"tid":"11","percent":"3","min":"1","max":"3"},{"tid":"12","percent":"3","min":"1","max":"3"},{"tid":"13","percent":"","min":"","max":""},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}'),
(80011, '/upload/image/20170414/20170414145646_97423.png', '2072.00000', 1492096391, 1, '玫瑰', '', '9999.0000', '0.1000', '0.0100', '8.00', '8.00', '8.00', 0, 1, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2200"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"","min":"","max":""},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"1"},{"tid":"10","percent":"3","min":"1","max":"3"},{"tid":"11","percent":"3","min":"1","max":"3"},{"tid":"12","percent":"3","min":"1","max":"3"},{"tid":"13","percent":"","min":"","max":""},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}'),
(80012, '/upload/image/20170414/20170414145816_15102.png', '2074.00000', 1492096606, 1, '南瓜', '', '0.1000', '0.1000', '0.0100', '8.00', '8.00', '8.00', 0, 1, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2200"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"","min":"","max":""},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"1"},{"tid":"10","percent":"3","min":"1","max":"3"},{"tid":"11","percent":"3","min":"1","max":"3"},{"tid":"12","percent":"3","min":"1","max":"3"},{"tid":"13","percent":"","min":"","max":""},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}'),
(80013, '/upload/image/20170414/20170414145508_63087.png', '2076.00000', 1492096693, 1, '草莓', '', '1.0000', '0.1000', '0.0100', '8.00', '8.00', '8.00', 0, 1, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2200"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"","min":"","max":""},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"1"},{"tid":"10","percent":"3","min":"1","max":"3"},{"tid":"11","percent":"3","min":"1","max":"3"},{"tid":"12","percent":"3","min":"1","max":"3"},{"tid":"13","percent":"3","min":"1","max":"3"},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}'),
(80014, '/upload/image/20170720/20170720191907_83628.png', '2078.00000', 1492096391, 1, '开心果', '', '0.1000', '0.1000', '0.0100', '8.00', '8.00', '8.00', 0, 0, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2200"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"","min":"","max":""},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"1"},{"tid":"10","percent":"3","min":"1","max":"3"},{"tid":"11","percent":"3","min":"1","max":"3"},{"tid":"12","percent":"3","min":"1","max":"3"},{"tid":"13","percent":"","min":"","max":""},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}'),
(80015, '/upload/image/20170720/20170720191853_64568.png', '2080.00000', 1492096391, 1, '雪莲花', '', '1.0000', '0.1000', '0.0100', '8.00', '8.00', '8.00', 0, 1, '{"nullpercent":"30","desc":"可获得金币、道具或者使用掉","win":[{"tid":"diamonds","percent":"50","min":"500","max":"2200"},{"tid":"1","percent":"40","min":"1","max":"1"},{"tid":"2","percent":"","min":"","max":""},{"tid":"3","percent":"","min":"","max":""},{"tid":"4","percent":"","min":"","max":""},{"tid":"5","percent":"","min":"","max":""},{"tid":"6","percent":"","min":"","max":""},{"tid":"7","percent":"","min":"","max":""},{"tid":"9","percent":"0.5","min":"1","max":"1"},{"tid":"10","percent":"3","min":"1","max":"3"},{"tid":"11","percent":"3","min":"1","max":"3"},{"tid":"12","percent":"3","min":"1","max":"3"},{"tid":"13","percent":"","min":"","max":""},{"tid":"14","percent":"","min":"","max":""},{"tid":"15","percent":"","min":"","max":""},{"tid":"16","percent":"","min":"","max":""},{"tid":"17","percent":"","min":"","max":""},{"tid":"18","percent":"0.005","min":"1","max":"1"},{"tid":"19","percent":"0.005","min":"1","max":"1"},{"tid":"20","percent":"0.005","min":"1","max":"1"}]}');

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user`
--

CREATE TABLE IF NOT EXISTS `dhc_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user` varchar(50) NOT NULL COMMENT '用户账号',
  `superior` varchar(2000) NOT NULL DEFAULT '0' COMMENT '导师推广码',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '用户状态(1启用 9 停用)',
  `salt` varchar(100) NOT NULL COMMENT '盐值',
  `token` varchar(500) DEFAULT NULL COMMENT 'token 验证信息',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `nickname` varchar(255) DEFAULT NULL COMMENT '用户昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '用户头像',
  `balance` int(11) DEFAULT '0' COMMENT '用户余额',
  `coing` decimal(12,5) unsigned DEFAULT '0.00000' COMMENT '用户金币数量',
  `level` int(11) DEFAULT '1' COMMENT '用户等级',
  `realname` varchar(255) DEFAULT NULL COMMENT '用户真实姓名',
  `idcard` varchar(255) DEFAULT NULL COMMENT '用户身份证号',
  `idcardFront` varchar(255) DEFAULT NULL COMMENT '身份证正面照片',
  `idcardback` varchar(255) DEFAULT NULL COMMENT '身份证反面照片',
  `Frozen` decimal(15,5) unsigned DEFAULT '0.00000' COMMENT '金币冻结数量',
  `spread` int(11) DEFAULT '0' COMMENT '推广码',
  `tencent` varchar(100) DEFAULT NULL COMMENT 'qq号',
  `wechet` varchar(100) DEFAULT NULL COMMENT '微信',
  `telphone` varchar(100) DEFAULT NULL COMMENT '手机号',
  `phone` varchar(100) DEFAULT NULL COMMENT '联系手机号',
  `dueBankAccount` varchar(255) DEFAULT NULL COMMENT '开户行用户名',
  `dueBank` varchar(255) DEFAULT NULL COMMENT '提现银行',
  `accountNumber` varchar(255) DEFAULT NULL COMMENT '提现账户',
  `province` varchar(100) DEFAULT NULL COMMENT '省/直辖市',
  `city` varchar(100) DEFAULT NULL COMMENT '市/县',
  `country` varchar(100) DEFAULT NULL COMMENT '开户区',
  `bankaccount` varchar(100) DEFAULT NULL COMMENT '开户行',
  `channelRebate` float(10,2) unsigned DEFAULT '0.00' COMMENT '渠道分佣比例',
  `salesmanRebate` varchar(500) DEFAULT NULL COMMENT '推广佣金',
  `usergroup` varchar(100) DEFAULT '普通用户' COMMENT '用户组',
  `spreadfee` decimal(10,5) DEFAULT NULL COMMENT '推广手续费',
  `smallfruit` tinyint(4) DEFAULT '0' COMMENT '小额果实赠送开关（1开启 0 关闭）',
  `authLevel` tinyint(4) DEFAULT '0' COMMENT '作者认证等级',
  `idcardStatus` tinyint(4) DEFAULT '0' COMMENT '用户身份证图片验证状态(0为空或失败2审核中1审核通过)',
  `lasttime` int(11) DEFAULT NULL COMMENT '登录时间',
  `createTime` int(11) NOT NULL COMMENT '注册时间',
  `trade_limit_level` int(11) DEFAULT '0' COMMENT '领取大礼包等级',
  `payPassword` varchar(100) DEFAULT NULL COMMENT '支付密码',
  `userCode` varchar(50) DEFAULT NULL COMMENT 'EMG编号',
  `openid` varchar(255) DEFAULT NULL COMMENT '微信openid',
  `authEndTime` int(11) NOT NULL DEFAULT '0' COMMENT '授权登陆有效截止时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user` (`user`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='用户表' AUTO_INCREMENT=4 ;

--
-- 转存表中的数据 `dhc_user`
--

INSERT INTO `dhc_user` (`id`, `user`, `superior`, `status`, `salt`, `token`, `password`, `nickname`, `avatar`, `balance`, `coing`, `level`, `realname`, `idcard`, `idcardFront`, `idcardback`, `Frozen`, `spread`, `tencent`, `wechet`, `telphone`, `phone`, `dueBankAccount`, `dueBank`, `accountNumber`, `province`, `city`, `country`, `bankaccount`, `channelRebate`, `salesmanRebate`, `usergroup`, `spreadfee`, `smallfruit`, `authLevel`, `idcardStatus`, `lasttime`, `createTime`, `trade_limit_level`, `payPassword`, `userCode`, `openid`, `authEndTime`) VALUES
(1, '15383205920', '0', 1, '421628', 'MV8xNTQ1NDQ4OTkyXy9INml4UkEwZGhzMVdzaEhmU2g4VW9xMkJ1c0U0MWsvOEE=', '58c7d76f8296070e1973efd2ecd86c6e68621dc0', NULL, NULL, 0, '0.00000', 1, NULL, NULL, NULL, NULL, '0.00000', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, NULL, '普通用户', NULL, 0, 0, 0, 1537417205, 1537417205, 0, NULL, NULL, NULL, 1537418535),
(2, '13932049739', '0', 1, '974919', 'Ml8xNTM3OTI4MDI2Xy9DUDN4MDB4Y0JvMldzaEFmeVY2VW9POUF1WUI1bFk4OFE=', 'aa9e0a251a1ae34817a2ab78c2f51f14c81cf89a', NULL, NULL, 0, '0.00000', 1, NULL, NULL, NULL, NULL, '0.00000', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, NULL, '普通用户', NULL, 0, 0, 0, 1537422051, 1537422051, 0, NULL, NULL, NULL, 1537928145),
(3, '13312345678', '0', 1, '116064', 'M18xNTM3NDIzNjc2Xy95MzB3UkZoSkJnM1dzaEFmeWg2V1lXNEF1NEg1Rjg3L0E=', '133899dcbdbf918a74b556e604e99f1a7b695250', NULL, NULL, 0, '0.00000', 1, NULL, NULL, NULL, NULL, '0.00000', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, NULL, '普通用户', NULL, 0, 0, 0, 1537422428, 1537422428, 0, NULL, NULL, NULL, 1537423795);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user_config`
--

CREATE TABLE IF NOT EXISTS `dhc_user_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `payType` varchar(100) NOT NULL COMMENT '支付类型',
  `merchant_no` varchar(100) NOT NULL COMMENT '商户号',
  `terminal_id` varchar(100) NOT NULL COMMENT '终端号',
  `status` tinyint(4) NOT NULL COMMENT '支付启用状态',
  `access_token` varchar(100) DEFAULT NULL COMMENT '签名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='支付配置表' AUTO_INCREMENT=4 ;

--
-- 转存表中的数据 `dhc_user_config`
--

INSERT INTO `dhc_user_config` (`id`, `payType`, `merchant_no`, `terminal_id`, `status`, `access_token`) VALUES
(1, 'fuyou', '858400203000022', '10139455', 1, 'cb5fa8b0c2e74626892a1b4f065c4b48'),
(2, 'wft', '101590069558', '101590069558', 1, '902d4dbcc13cc9f34841cbef07d77946'),
(3, 'YB', '8886338', '8886338', 0, '07036e8414034084a08313d47e11e053');

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user_cost`
--

CREATE TABLE IF NOT EXISTS `dhc_user_cost` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `orderNumber` varchar(255) NOT NULL COMMENT '订单号',
  `createtime` int(11) NOT NULL COMMENT '创建时间',
  `endtime` int(11) unsigned DEFAULT NULL COMMENT '结束时间',
  `sum` decimal(10,5) NOT NULL COMMENT '消费金额',
  `charge` decimal(10,5) DEFAULT '0.00000' COMMENT '手续费',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态1 成功 0 审核 2失败',
  `type` varchar(100) NOT NULL COMMENT '消费类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户消费表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user_give`
--

CREATE TABLE IF NOT EXISTS `dhc_user_give` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) unsigned NOT NULL COMMENT '赠送用户id',
  `accept` varchar(100) NOT NULL COMMENT '接受用户id或者帐号',
  `productid` int(11) unsigned NOT NULL COMMENT '产品id',
  `number` int(11) unsigned NOT NULL COMMENT '产品数量',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '赠送状态1结束（接受或者2退回撤销），0等待接受',
  `title` varchar(100) NOT NULL COMMENT '产品名称',
  `createtime` int(11) NOT NULL COMMENT '赠送时间',
  `fee` decimal(10,5) NOT NULL COMMENT '手续费',
  `giveGold` int(11) unsigned DEFAULT '0' COMMENT '索取金币数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户赠送产品表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user_gold`
--

CREATE TABLE IF NOT EXISTS `dhc_user_gold` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `oid` int(11) unsigned NOT NULL COMMENT '操作员id',
  `uid` int(11) unsigned NOT NULL COMMENT '充值用户id',
  `gold` float(11,2) DEFAULT '0.00' COMMENT '充值金币数量',
  `frozen` float(11,2) DEFAULT '0.00' COMMENT '冻结金币数量',
  `createtime` int(11) unsigned NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值操作表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user_log`
--

CREATE TABLE IF NOT EXISTS `dhc_user_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `user` varchar(100) NOT NULL COMMENT '用户帐号',
  `ip` varchar(100) NOT NULL COMMENT '用户ip',
  `logintime` int(11) NOT NULL COMMENT '用户登录时间',
  `info` text NOT NULL COMMENT '用户信息',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户登录表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user_message`
--

CREATE TABLE IF NOT EXISTS `dhc_user_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mobile` varchar(100) NOT NULL COMMENT '手机号',
  `sendTime` int(11) NOT NULL COMMENT '发送时间',
  `code` varchar(100) NOT NULL COMMENT '验证码',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='用户验证短信表' AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `dhc_user_message`
--

INSERT INTO `dhc_user_message` (`id`, `mobile`, `sendTime`, `code`, `status`) VALUES
(1, '18003108768', 1515673344, '407317', 1);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user_product`
--

CREATE TABLE IF NOT EXISTS `dhc_user_product` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) unsigned NOT NULL COMMENT '用户id',
  `sid` int(11) unsigned NOT NULL COMMENT '产品id',
  `number` int(11) unsigned DEFAULT '0' COMMENT '产品数量',
  `frozen` int(11) unsigned DEFAULT '0' COMMENT '产品冻结数量',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`,`sid`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='用户产品仓库表' AUTO_INCREMENT=4 ;

--
-- 转存表中的数据 `dhc_user_product`
--

INSERT INTO `dhc_user_product` (`id`, `uid`, `sid`, `number`, `frozen`, `createtime`, `updatetime`) VALUES
(1, 1, 1, 0, 0, 1537417219, 1537417225),
(2, 2, 1, 0, 0, 1537422359, 1537422363),
(3, 2, 80004, 996, 0, 1537928031, 1537928031);

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user_recharge`
--

CREATE TABLE IF NOT EXISTS `dhc_user_recharge` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uid` int(11) unsigned NOT NULL COMMENT '用户id',
  `orderNumber` varchar(100) NOT NULL COMMENT '订单号',
  `number` int(11) unsigned NOT NULL COMMENT '充值数量',
  `payType` varchar(100) NOT NULL COMMENT '支付类型',
  `payStatus` tinyint(3) unsigned NOT NULL DEFAULT '2' COMMENT '支付状态（1支付成功2待支付3支付失败）',
  `createTime` int(11) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户充值表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user_renascence`
--

CREATE TABLE IF NOT EXISTS `dhc_user_renascence` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL COMMENT '重生用户',
  `title` varchar(100) NOT NULL COMMENT '产品名称',
  `price` decimal(10,5) NOT NULL COMMENT '当前价格',
  `number` varchar(100) NOT NULL COMMENT '重生数量',
  `createtime` int(11) NOT NULL COMMENT '创建时间',
  `charge` decimal(10,5) NOT NULL COMMENT '手续费',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户产品重生表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user_service`
--

CREATE TABLE IF NOT EXISTS `dhc_user_service` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `title` varchar(100) NOT NULL COMMENT '服务名称',
  `way` varchar(100) NOT NULL COMMENT '联系方式',
  `type` varchar(20) DEFAULT '0' COMMENT '服务类型',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='前台服务联系方式展示' AUTO_INCREMENT=33 ;

--
-- 转存表中的数据 `dhc_user_service`
--

INSERT INTO `dhc_user_service` (`id`, `title`, `way`, `type`) VALUES
(12, '官方微信', 'guanfangssd123456', 'weixin'),
(13, '官方微博', '012132132', 'weibo'),
(16, '商务合作', '13212313245@qqq', 'shangwu'),
(25, '服务时间', '上午9：00-下午16：00', 'time'),
(26, '公司地址', '测试地址', 'address'),
(27, 'QQ群', '123456789', 'QQ'),
(30, '白菜', '43243214321', '2'),
(31, '萝卜', '4564564654', '2'),
(32, '土豆', '55', '3');

-- --------------------------------------------------------

--
-- 表的结构 `dhc_user_withdraw`
--

CREATE TABLE IF NOT EXISTS `dhc_user_withdraw` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createtime` int(11) NOT NULL COMMENT '创建时间',
  `accountnumber` varchar(100) NOT NULL COMMENT '银行帐号',
  `goldnumber` int(11) NOT NULL COMMENT '提现金币数量',
  `fee` decimal(10,5) NOT NULL COMMENT '手续费',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态1审核通过 0 审核中 2已完成 3返回信息有误',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `bankaccount` varchar(100) NOT NULL COMMENT '收款开户银行',
  `withdrawtype` varchar(4) DEFAULT NULL COMMENT '提现类型（1行内转账 2 同城跨行3异地跨行）',
  `province` varchar(100) NOT NULL COMMENT '省份/直辖市',
  `city` varchar(100) NOT NULL COMMENT '市/县',
  `costname` varchar(100) NOT NULL COMMENT '消费类型',
  `realname` varchar(100) DEFAULT NULL COMMENT '提现用户',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户提现表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_virtual_withdraw`
--

CREATE TABLE IF NOT EXISTS `dhc_virtual_withdraw` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `goldnumber` decimal(11,5) NOT NULL COMMENT '提现金币数量',
  `number` decimal(11,5) NOT NULL COMMENT '提现数量',
  `address` varchar(255) NOT NULL COMMENT '收货地址',
  `createtime` int(11) NOT NULL COMMENT '提现时间',
  `rebate` decimal(10,2) NOT NULL COMMENT '兑换比例',
  `status` tinyint(4) DEFAULT '0' COMMENT '审核状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='虚拟币提现表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dhc_withdraw_address`
--

CREATE TABLE IF NOT EXISTS `dhc_withdraw_address` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uid` int(11) unsigned NOT NULL COMMENT '用户id',
  `address` varchar(255) NOT NULL COMMENT '收货地址',
  `createtime` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户虚拟币提现收货地址表' AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

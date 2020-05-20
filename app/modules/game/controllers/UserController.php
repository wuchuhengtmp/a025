<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Dhc\Modules\Game\Controllers;

use Dhc\Library\EmgApi;
use Dhc\Library\IDCardApi;
use Dhc\Models\User;
use Dhc\Models\Orchard;
use Dhc\Models\OrchardUser;
use Dhc\Models\OrchardGoods;
use Dhc\Models\OrchardLand;
use Dhc\Models\Product;
use Dhc\Models\UserProduct;
use Phalcon\Http\Response;
use function PHPSTORM_META\elementType;


class UserController extends ControllerBase
{
    public function initialize()
    {
        $this->checkToken();
        $this->config = $this->getConfig("houseInfo");
    }

    /**
     * 用户仓库
     */
    public function wareHouseAction()
    {
        $data[0] = $this->getProduct("sid");//种子信息
        $data[1] = $this->getDui();//材料
        $data[2] = $this->gemstone();//宝石
        $data[3] = $this->getprop();//道具
        $data[4] = $this->getSkin();//皮肤//背景信息
        $data = array_merge($data[0], $data[1], $data[2], $data[3], $data[4]);
        $this->ajaxResponse($data, "用户仓库信息", 0);
    }

    //房屋等级
    function houseInfoAction()
    {
        $data = $this->getHouseInfo();
        $this->ajaxResponse($data, "房屋信息返回成功！", 0);
    }

    //房屋升级
    function upHouseAction()
    {
        $dataInfo = $this->getHouseInfo();
        $config = $this->getConfig("houseInfo");
        $this->db->begin();
        if ($dataInfo["grade"] > count($config) || $dataInfo["upgrade"] - 1 > count($config)) {
            $this->db->rollback();
            $this->ajaxResponse("", "暂无更高级别，无法进行升级！", 1);
        }
        if ($dataInfo["userInfo"]["diamonds"] < $dataInfo["upInfo"]["0"] && $dataInfo["upInfo"]["0"] > 0) {
            $this->db->rollback();
            $this->ajaxResponse("", "{$this->zuanshiTitle}不足，暂无法升级！", 1);
        }
        if ($dataInfo["userInfo"]["wood"] < $dataInfo["upInfo"]["1"] && $dataInfo["upInfo"]["1"] > 0) {
            $this->db->rollback();
            $this->ajaxResponse("", "木材不足，暂无法升级！", 1);
        }
        if ($dataInfo["userInfo"]["stone"] < $dataInfo["upInfo"]["2"] && $dataInfo["upInfo"]["2"] > 0) {
            $this->db->rollback();
            $this->ajaxResponse("", "石材不足，暂无法升级！", 1);
        }
        if ($dataInfo["userInfo"]["steel"] < $dataInfo["upInfo"]["3"] && $dataInfo["upInfo"]["3"] > 0) {
            $this->db->rollback();
            $this->ajaxResponse("", "钢材不足，暂无法升级！", 1);
        }
        if (!empty($dataInfo["upInfo"][$this->kuguazhiId]) && $dataInfo["userInfo"]["kuguazhi"] < $dataInfo["upInfo"][$this->kuguazhiId]) {
            $this->db->rollback();
            $this->ajaxResponse("", "苦瓜汁不足，暂无法升级！", 1);
        }
        $user = new OrchardUser();
        $user = $user->findFirst("uid='{$this->userid}' AND grade='{$dataInfo["grade"]}'");
        if ($user == false) {
            $this->db->rollback();
            $this->ajaxResponse("", "会员信息获取失败，无法升级，请重试！", 1);
        }
        $upGrade = $this->getConfig("upGrade");
        if ($user->grade >= $upGrade && $upGrade > 0) {
            $this->db->rollback();
            $this->ajaxResponse("", "已达到当前最高等级，暂无法升级！", 1);
        }
        $user->diamonds -= $dataInfo["upInfo"][0];
        $user->wood -= $dataInfo["upInfo"][1];
        $user->stone -= $dataInfo["upInfo"][2];
        $user->steel -= $dataInfo["upInfo"][3];
        $user->grade += 1;
        $user->updatetime = TIMESTAMP;

        if ($dataInfo["upInfo"]["0"] > 0) {
            $flag = $this->saveOrchardLogs(array("mobile" => $dataInfo["userInfo"]["mobile"], "types" => "deddiamonds", "nums" => -$dataInfo["upInfo"][0], "msg" => "房屋升级至" . $dataInfo["upgrade"] . "级扣除{$this->zuanshiTitle}" . $dataInfo["upInfo"][0] . "颗", "dataInfo" => json_encode($dataInfo)));
            if ($flag == false) {
                $this->db->rollback();
                $this->ajaxResponse("", "会员{$this->zuanshiTitle}日志信息更新失败，房屋升级失败，请重试！", 1);
            }
        }
        if ($dataInfo["upInfo"]["1"] > 0) {
            $flag = $this->saveOrchardLogs(array("mobile" => $dataInfo["userInfo"]["mobile"], "types" => "dedwood", "nums" => -$dataInfo["upInfo"][1], "msg" => "房屋升级至" . $dataInfo["upgrade"] . "级扣除木材" . $dataInfo["upInfo"][1] . "颗", "dataInfo" => json_encode($dataInfo)));
            if ($flag == false) {
                $this->db->rollback();
                $this->ajaxResponse("", "会员木材日志信息更新失败，房屋升级失败，请重试！", 1);
            }
        }
        if ($dataInfo["upInfo"]["2"] > 0) {
            $flag = $this->saveOrchardLogs(array("mobile" => $dataInfo["userInfo"]["mobile"], "types" => "dedstone", "nums" => -$dataInfo["upInfo"][2], "msg" => "房屋升级至" . $dataInfo["upgrade"] . "级扣除石材" . $dataInfo["upInfo"][2] . "颗", "dataInfo" => json_encode($dataInfo)));
            if ($flag == false) {
                $this->db->rollback();
                $this->ajaxResponse("", "会员石材日志信息更新失败，房屋升级失败，请重试！", 1);
            }
        }
        if ($dataInfo["upInfo"]["3"] > 0) {
            $flag = $this->saveOrchardLogs(array("mobile" => $dataInfo["userInfo"]["mobile"], "types" => "dedsteel", "nums" => -$dataInfo["upInfo"][3], "msg" => "房屋升级至" . $dataInfo["upgrade"] . "级扣除钢材" . $dataInfo["upInfo"][3] . "颗", "dataInfo" => json_encode($dataInfo)));
            if ($flag == false) {
                $this->db->rollback();
                $this->ajaxResponse("", "会员钢材日志信息更新失败，房屋升级失败，请重试！", 1);
            }
        }
        if (!empty($dataInfo["upInfo"][$this->kuguazhiId])) {
            $flag = $this->saveOrchardLogs(array("mobile" => $dataInfo["userInfo"]["mobile"], "types" => "dedkuguazhi", "nums" => -$dataInfo["upInfo"][$this->kuguazhiId], "msg" => "房屋升级至" . $dataInfo["upgrade"] . "级扣除苦瓜汁" . $dataInfo["upInfo"][$this->kuguazhiId] . "个", "dataInfo" => json_encode($dataInfo)));
            if ($flag == false) {
                $this->db->rollback();
                $this->ajaxResponse("", "会员苦瓜汁日志信息更新失败，房屋升级失败，请重试！", 1);
            }
            $user->kuguazhi -= $dataInfo["upInfo"][$this->kuguazhiId];
        }
        $flag = $user->update();
        if ($flag == false) {
            $this->db->rollback();
            $this->ajaxResponse("", "会员信息更新失败，房屋升级失败，请重试！", 1);
        }
        $flag = $this->addLand();
        if ($flag == false) {
            $this->db->rollback();
            $this->ajaxResponse("", "会员土地开启失败，请重试！", 1);
        }
        $this->db->commit();
        $this->ajaxResponse("", "恭喜房屋等级成功升级为{$dataInfo['upgrade']}级！", 0);
    }

    //获取房屋信息
    function getHouseInfo()
    {
        $houseInfo = $this->selectUser($this->userid, "houseInfo");
        $this->config[count($this->config) + 1] = array(0 => 0, 1 => 0, 2 => 0, 3 => 0);
        $data = $this->getDui();
        foreach ($data as $key => &$value) {
            $value["price"] = $this->config[$houseInfo["grade"]][$key + 1];
        }
        $data[] = array(
            "cId" => 999,
            "tName" => "{$this->zuanshiTitle}",
            "type" => 999,
            "depict" => "可用来购买商城中的物品，也可兑换背景，升级房屋和土地",
            "price" => $this->config[$houseInfo["grade"]][0],
            "num" => $houseInfo["diamonds"]
        );
        if (USER_TYPE == "yansheng") {
            $houseInfo["kuguazhi"] = $this->selectUser($this->userid, "kuguazhi");
            $goodsInfo = $this->getOneOrchardGoodsInfo($this->kuguazhiId);
            $data[] = array(
                "cId" => $this->kuguazhiId,
                "tName" => "{$goodsInfo['tName']}",
                "type" => 3,
                "depict" => "{$goodsInfo['depict']}",
                "price" => $this->config[$houseInfo["grade"]][$this->kuguazhiId],
                "num" => $houseInfo["kuguazhi"]
            );
        }
        return array(
            "grade" => $houseInfo["grade"],
            "upgrade" => $houseInfo["grade"] > count($this->config) ? "" : $houseInfo["grade"] + 1,
            "upInfo" => $houseInfo["grade"] > count($this->config) ? "暂无更高级别" : $this->config[$houseInfo["grade"]],
            "dataInfo" => $data,
            "userInfo" => $houseInfo
        );
    }

    //土地升级信息
    function landUpInfoAction()
    {
        $data = $this->getLandUpInfo();
        $this->ajaxResponse($data, "土地升级信息返回成功！", 0);
    }

    //土地升级操作
    function saveLandUpAction()
    {
        if ($this->request->isPost()) {
            $this->db->begin();
            $type = $this->request->getPost("type");
            $dataInfo = $this->getLandUpInfo();
            if (empty($type) || empty($dataInfo[$type])) {
                $this->db->rollback();
                $this->ajaxResponse("", "请求失败，暂无法升级土地！", 1);
            }
            if ($dataInfo[$type]["needNum"]["need"] == 1 || $dataInfo[$type]["needNum"]["landId"] < 0) {
                $this->db->rollback();
                $this->ajaxResponse("", "请求失败，暂无土地可升级！", 1);
            }
            $land = new OrchardLand();
            $landInfo = $land->findFirst("uid='{$this->userid}' AND landId='{$dataInfo[$type]["needNum"]["landId"]}'");
            if ($landInfo == false) {
                $this->db->rollback();
                $this->ajaxResponse("", "请求失败，土地获取失败！", 1);
            }
            $landInfo->landLevel = $type;
            $landInfo->updatetime = $landInfo->optime = TIMESTAMP;
            $flag = $landInfo->update();
            if ($landInfo == false) {
                $this->db->rollback();
                $this->ajaxResponse("", "升级失败，土地等级升级失败！", 1);
            }

            //在此使用土地卡
            $cardarry=array(2=>"redcard",3=>"blackcard",4=>"goldcard");
            $cardnum= $this->selectUser($this->userid, $cardarry[$type]);
            if($cardnum<1) {
                //没有土地卡则使用材料升级
                foreach ($dataInfo[$type]["cost"] as $key => $value) {
                    if ($value["price"] > $value["num"]) {
                        $this->db->rollback();
                        $this->ajaxResponse("", "升级失败{$value["tName"]}数量不足！", 1);
                    }
                    if (!empty($value["goodsId"])) {
                        $flag = $this->saveProduct($value["goodsId"], $value["price"], "ded");
                        $flag1 = $this->saveOrchardLogs(array("mobile" => $this->mobile, "landId" => $dataInfo[$type]["needNum"]["landId"], "types" => "dedgoods", "landId" => $value["goodsId"], "nums" => -$value["price"], "msg" => "土地升级扣除" . $value["tName"] . $value["price"] . "颗"));
                    } else {
                        $flag = $this->updateUser($this->userid, "diamonds", $value["price"], "ded");
                        $flag1 = $this->saveOrchardLogs(array("mobile" => $this->mobile, "landId" => $dataInfo[$type]["needNum"]["landId"], "types" => "deddiamonds", "nums" => -$value["price"], "msg" => "土地升级扣除" . $value["tName"] . $value["price"] . "颗"));
                    }
                    if ($value["price"]>0&&($flag == false || $flag1 == false)) {
                        $this->db->rollback();
                        $this->ajaxResponse("", "升级失败，更新{$value["tName"]}数量操作失败！", 1);
                    }
                }
            }
            else{
                //使用土地卡升级
                $flag = $this->updateUser($this->userid, $cardarry[$type],1, "ded");
                $flag1 = $this->saveOrchardLogs(array("mobile" => $this->mobile, "landId" => $dataInfo[$type]["needNum"]["landId"], "types" => "ded".$cardarry[$type], "nums" => -1, "msg" => "土地升级扣除" . $this->onoTitleInfo()[$cardarry[$type]] . "1张"));
                if ($flag == false || $flag1 == false) {
                    $this->db->rollback();
                    $this->ajaxResponse("", "升级失败，更新".$this->onoTitleInfo()[$cardarry[$type]]."数量操作失败！", 1);
                }
            }
            $this->db->commit();
            $data = array(
                "landId" => $dataInfo[$type]["needNum"]["landId"]
            );
            $this->ajaxResponse($data, "升级成功，土地等级越高产生的果子品质越高！", 0);
        }
    }

    //土地升级参数信息获取
    function getLandUpInfo()
    {
        $orchard = new Orchard();
        $landTypeInfo = $orchard->getLandType();
        $landDepictInfo = $orchard->getLandDepict();
        $landUpInfo = $this->getConfig("landUpInfo");
        $houseInfo = $this->getConfig("houseInfo");
        $product = $this->getUserProductInfo("sid");
        if (empty($landUpInfo)) {
            $this->ajaxResponse("", "土地升级信息暂无！", 1);
        }
        $data = array();
        foreach ($landUpInfo as $key => $value) {
            $info = array();
            foreach ($value as $k => $v) {
                $arr = array(
                    "num" => "0",
                    "price" => $v["num"],
                    "type" => 1
//					"unit"=>"颗",
                );
                if (!empty($v["pid"]) && !empty($product[$v['pid']])) {
                    $arr["num"] = $product[$v['pid']]["number"];
                    $arr["goodsId"] = $arr["tId"] = $v["pid"];
                    $arr["tName"] = $product[$v['pid']]["goodsName"];
                    $arr["depict"] = !empty($product[$v['pid']]["depict"]) ? $product[$v['pid']]["depict"] : "";
                }
                if (!empty($v["pid"]) && empty($product[$v['pid']]) && empty($arr["tName"])) {
                    $product = new Product();
                    $product = $product->findFirst("id='{$v['pid']}'")->toArray();
                    $arr["goodsId"] = $arr["tId"] = $v["pid"];
                    $arr["tName"] = $product["title"];
                    $arr["depict"] = !empty($product["depict"]) ? $product["depict"] : "";
                }
                if (empty($v["pid"])) {
                    $arr["num"] = $this->selectUser($this->userid, "diamonds");
                    $arr["tName"] = "{$this->zuanshiTitle}";
                    $arr["depict"] = "可用来购买商城中的物品，也可兑换背景，升级房屋和土地";
                    $arr["tId"] = "999";
                    $arr["type"] = "999";
//					if($arr["userNums"]>10000){
//						$arr["userNums"] = sprintf("%.2f",$arr["userNums"]/1000);
//						$arr["unit"] = "万颗";
//					}
                }
                $info[$k] = $arr;
            }
            $data[$key] = array(
                "name" => $landTypeInfo[$key],
                "type" => 8,
                "depict" => $landDepictInfo[$key],
                "level" => $key,
                "tId" => $key,
                "countLand" => count($houseInfo) + 1,
                "landNum" => $this->selectLandNums($key),
                "needNum" => $this->needLandNums($key),
                "cost" => $info
            );
        }
        return $data;
    }

    //查询该类型土地数量
    function selectLandNums($key)
    {
        if ($key < 1 || $key > 6) {
            return 0;
        }
        $orchard = new OrchardLand();
        $landNums = $orchard->find("uid='{$this->userid}' AND landLevel>={$key}");
        $landNum = $this->object2array($landNums);
        return count($landNum);
    }

    //查询有没有土地可升级
    function needLandNums($key)
    {
        $isOpen = 1;
        if ($key == 4) {
            $isOpen = 0;
            $grade = array(
                "6" => 2,
                "7" => 4,
                "8" => 6,
                "9" => 8,
                "10" => 10,
                "11" => 12,
                "12" => 12
            );
            $userGrade = $this->selectUser($this->userid, "grade");
            if ($userGrade >= 6) {
                $orchard = new OrchardLand();
                $landInfo = $orchard->find("uid='{$this->userid}' AND landLevel>={$key}");
                $landInfo = $this->object2array($landInfo);
                if (count($landInfo) < $grade[$userGrade]) {
                    $isOpen = 1;
                }
            }
        } elseif (@in_array($key, array(5))) {
            $isOpen = 0;
            $userGrade = $this->selectUser($this->userid, "grade");
            if ($userGrade >= 7) {
                $isOpen = 1;
            }
        }
        $orchard = new OrchardLand();
        $landLevel = $key - 1;
        $landNums = $orchard->findFirst("uid='{$this->userid}' AND landLevel={$landLevel} ORDER by landId asc");
        if ($isOpen == 0 || $landNums == false) {
            return array(
                "need" => 1,
                "needInfo" => "暂无可升级的土地",
                "landId" => 0
            );
        } else {
            return array(
                "need" => 0,
                "needInfo" => "有土地可进行升级",
                "landId" => $landNums->landId
            );
        }
    }

    //点击宝箱返回信息
    function chestCheckAction()
    {
        $data = $this->checkChest();
        if ($data == false || $this->is_error($data)) {
            $this->ajaxResponse("", "宝箱返回信息失败！{$data["message"]}", 1);
        }
        unset($data['award']);
        $this->ajaxResponse($data, "宝箱返回信息成功！", 0);
    }

    //宝箱点击开启
    function chestOpenAction()
    {
        $this->db->begin();
        $data = $this->checkChest();
        if ($data == false || $this->is_error($data)) {
            $this->db->rollback();
            $this->ajaxResponse("", "宝箱开启失败！{$data["message"]}", 1);
        }
        $flag = $this->chestOpen($data);
        if ($this->is_error($flag) || $flag == false) {
            $this->db->rollback();
            $this->ajaxResponse("", "抱歉！{$flag["message"]}", 1);
        }
        $this->db->commit();
        $this->ajaxResponse(array("fruit" => $flag["datafruit"], "coin" => $flag["datacoin"]), $flag["message"], 0);
    }

    //宝箱信息
    function checkChest()
    {
        if ($this->request->isPost()) {
            $data = array();
            $mark = $this->request->getPost("mark");
            $tId = $this->request->getPost("tId");
            $marks = [4 => "cchest", 5 => "schest", 6 => "gchest", 7 => "dchest"];
            if (empty($mark) || empty($tId) || $marks[$tId] != $mark) {
                return $this->error(1, "宝箱信息不存在");
            }

            $markNums = $this->selectUser($this->userid, $mark);
            if ($markNums <= 0) {
                return $this->error(1, "宝箱数量不足无法开启");
            }
            $goods = $this->getOneOrchardGoodsInfo($tId);
            if (empty($goods)) {
                return $this->error(1, "宝箱信息异常无法开启");
            }
            $chanceInfo = json_decode($goods["chanceInfo"], true);
            $award = $chanceInfo["winning"];
            $cost = json_decode($goods["cost"], true);
            if (empty($award) || empty($cost)) {
                return $this->error(1, "宝箱尚未设置奖励！");
            }
            $data['desc'] = $chanceInfo['desc'];
            $data["award"] = $award;
            $data["cost"] = $cost;
            foreach ($data["award"] as $key => $val) {
                if (is_numeric($val['goodsId'])) {
                    $goodsInfo = $this->getOneProductInfo($val['goodsId']);
                    if (!empty($goodsInfo["title"]) > 0) {
                        $data["award"][$key]["goodsName"] = $goodsInfo["title"];
                    } else {
                        $data["award"][$key]["goodsName"] = "";
                    }
                } else if ($val['goodsId'] == "coin") {
                    $data["award"][$key]["goodsName"] = "金币";
                }
            }

            foreach ($data["cost"] as $key => $val) {
                if ($val[0] > 0 && $val[1] > 0) {
                    $goodsInfo = $this->getOneProductInfo($val[0]);
                    if (!empty($goodsInfo["title"]) > 0) {
                        $data["cost"][$key]["goodsName"] = $goodsInfo["title"];
                    } else {
                        $data["cost"][$key]["goodsName"] = "";
                    }
                }
            }
            return $data;
        }
        return false;
    }

    //宝箱开启效果
    function chestOpen($data)
    {
        $cost = $data["cost"];
        $award = $data["award"];
        foreach ($cost as $key => $val) {
            if ($val[0] > 0 && $val[1] > 0) {
                $flag = $this->saveProduct($val[0], $val[1], "ded");
                if ($flag == false) {
                    return $this->error(1, "宝箱开启失败！{$val["goodsName"]}数量不足!");
                }
                $flag = $this->saveOrchardLogs(array("mobile" => $this->mobile, "types" => "dedgoods", "landId" => $val[0], "nums" => -$val[1], "msg" => "开启宝箱减少" . $val["goodsName"] . $val[1] . "颗"));
                if ($flag == false) {
                    return $this->error(1, "宝箱开启失败！{$val["goodsName"]}日志记录更新失败!");
                }
            }
        }

        foreach ($award as $key => $val) {
            if ($val['min'] > 0 && $val['max'] > 0 && $val['min'] <= $val['max']) {
                $award[$key]['num'] = rand($val['min'], $val['max']);
            } else {
                unset($award[$key]);
            }
        }
        if (!empty($award)) {
            //道具数量更新
            $user = new OrchardUser();
            $user = $user->findFirst("uid='{$this->userid}'");
            $mark = $this->request->getPost("mark");
            if ($user->$mark <= 0) {
                return $this->error(1, "{$data['title']}数量不足无法开启！");
            }
            $user->$mark -= 1;
            $user->updatetime = TIMESTAMP;
            $flag = $user->update();
            if ($flag == false) {
                return $this->error(1, "{$data['title']}数量更新失败！");
            }
            $mark = $this->request->getPost("mark");
            $markTitle = $this->onoTitleInfo();
            // 更新奖品
            $message = "开启{$markTitle[$mark]},获得";
            $datacoin = 0;
            $datafruit = array();
            foreach ($award as $key => $val) {
                if (is_numeric($val['goodsId'])) {
                    $flag = $this->saveProduct($val['goodsId'], $val['num']);
                    if ($flag == false) {
                        return $this->error(1, "宝箱开启失败，{$val["goodsName"]}更新失败！");
                    }
                    $flag = $this->saveOrchardLogs([
                        "mobile" => $this->mobile,
                        "types" => "addgoods",
                        "nums" => $val["num"],
                        "landId" => $val['goodsId'],
                        "msg" => "开启宝箱获得奖励" . $val["goodsName"] . "数量" . $val['num']
                    ]);
                    if ($flag == false) {
                        return $this->error(1, "宝箱开启失败，{$val["goodsName"]}更新失败！");
                    }
                    $message .= $val['num'] . "个" . $val["goodsName"];
                    $data["message"] = "宝箱开启成功，获得" . "个" . $val["goodsName"] . "，数量：" . $val['num'];
                    $datafruit[] = array($val["goodsId"], $val["num"]);

                } else if ($val['goodsId'] == "coin") {
                    $userModel = new User();
                    $userInfo = $userModel->findFirst("id={$this->userid}");
                    if ($userInfo == false) {
                        return $this->error(1, "用户信息获取失败，请重试！");
                    }
                    $userInfo->coing += $val['num'];
                    $flag = $userInfo->save();
                    if ($flag == false) {
                        return $this->error(1, "用户金币添加失败, 请重试！");
                    }
                    $message .= $val['num'] . "个金币";
                    $datacoin = $val["num"];
                }
            }
        } else {
            return $this->error(1, "宝箱开启失败，没有获得任何奖励！");
        }
        $flag = $this->saveDoubleEffect(array("mark" => $this->request->getPost("mark"), "types" => $this->request->getPost("tId"), "nums" => $val["num"], "msg" => "恭喜[{$user->nickname} 的家园]" . $message));
        if ($flag == false) {
            return $this->error(1, "宝箱开启日志更新失败！");
        }
        return $data = ["message" => "恭喜您" . $message, "datafruit" => $datafruit, "datacoin" => $datacoin];
    }

    //获取会员编号 EMG
    function getUserCodeAction()
    {
        $EMG = new EmgApi();
        $userCode = json_decode($EMG->getUserCode(), true);
        $this->ajaxResponse($userCode["userCode"], "新注册编号返回", 0);
    }

    //内部注册 EMG
    function regAction()
    {
        if ($this->request->isPost()) {
            $EMG = new EmgApi();
            $userCode = $this->request->getPost("userCode");
            if (empty($userCode)) {
                $this->ajaxResponse('', '用户编号获取失败', '1');
            }
            $userInfoCode = $this->selectUserInfo($this->userid, "userCode");
            if (empty($userInfoCode)) {
                $this->ajaxResponse('', '当前用户暂不支持操作', '1');
            }
            $username = $this->request->getPost("username");
            if (strlen($username) != 11) {
                $this->ajaxResponse('', '请输入十一位手机号', '1');
            }
            //真实姓名
            $realname = $this->request->getPost("realname");
            if (empty($realname)) {
                $this->ajaxResponse('', '真实姓名不可为空', '1');
            }
            //用户信息读取
            $user = new User();
            $result1 = $user->findFirst("user = '$username' ORDER BY id desc");
            if ($result1) {
                $this->ajaxResponse('', $username . '该用户已存在!无法注册', '1');
            }
            //身份证号
            $idcard = $this->request->getPost("idCard");
            if (empty($idcard)) {
                $this->ajaxResponse('', '请输入正确的身份证号码', '1');
            }
            // @zl 添加身份证实名认证
            $idCardApi = new IDCardApi($realname, $idcard);
            if (!$idCardApi->check()) {
                $this->ajaxResponse('', '姓名和身份证不匹配，请重新填写！', '1');
            }
            //两次密码
            $password = $this->request->getPost("password");
            $repassword = $this->request->getPost("rePassword");
            if (empty($password) || empty($repassword)) {
                $this->ajaxResponse("", "密码不可为空!", 1);
            }
            if ($password != $repassword) {
                $this->ajaxResponse("", "两次密码输入不一致!", 1);
            }
            $payPassword = $this->request->getPost("payPassword");

            //推荐人
            $spread = $this->request->getPost("spread");
            if ($spread > 0) {
                $spreadUser = $user->findFirst("id = $spread");
                if (empty($spreadUser)) {
                    $this->ajaxResponse("", "推荐人信息不存在或已被禁用!", 1);
                }
                $parentCode = $spreadUser->userCode;
                if (empty($parentCode)) {
                    $this->ajaxResponse('', '推荐人信息获取失败！', '1');
                }
                $user->superior = $spread . "-" . $spreadUser->superior;
            }
            //安置人
            $managerCode = $this->request->getPost("anzhiren");
            if ($managerCode > 0) {
                $managerCodeUser = $user->findFirst("id = $spread");
                if (empty($managerCodeUser)) {
                    $this->ajaxResponse("", "安置人信息不存在或已被禁用!", 1);
                }
            }
            $user->superior = $spread . "-" . $spreadUser->superior;
            $salt = $this->create_salt(6);
            $userpassword = sha1($salt . $password);
            $user->user = $username;
            $user->nickname = $user->realname = $realname;
            $user->idcard = $idcard;
            $user->salt = $salt;
            $user->password = $userpassword;
            $user->createTime = TIMESTAMP;
            $user->lasttime = TIMESTAMP;
            $user->token = TIMESTAMP;
            $user->userCode = $userCode;
            $this->db->begin();
            $result = $user->save();
            if ($result == false) {
                $this->db->rollback();
                $this->ajaxResponse("", "注册失败", 1);
            }
            $data = [
                'userCode' => $userCode,
                'username' => $realname,
                'userPhone' => $username,
                'parentCode' => $userInfoCode,
                "managerCode" => $managerCode,
                "regUserCode" => $userInfoCode,
                "payPassword" => md5($payPassword),
                "idcard" => $idcard,
                'password' => $password,
            ];
            $re = json_decode($EMG->register($data), true);
            if ($re["Code"] != 1) {
                $this->db->rollback();
                $this->ajaxResponse("", "注册会员失败！[{$re['Message']}]", 1);
            }
            $this->db->commit();
            $this->ajaxResponse("", "注册成功！", 0);
        }
    }

    //外部连接 EMG
    function getThirdPartyLoginAction()
    {
        if ($this->request->isPost()) {
            $EMG = new EmgApi();
            $userInfoCode = $this->selectUserInfo($this->userid, "userCode");
            if (empty($userInfoCode)) {
                $this->ajaxResponse('', '当前用户暂不支持操作', '1');
            }
            $url = array(
                1 => "/Member/Home/User",
                2 => "/Member/Home/Account",
                3 => "/Member/Home/RegManager",
                4 => "/Member/Home/OptionManager",
                5 => "/Member/Home/IntegralManager",
                6 => "/Member/Home/MessageManager",
            );
            $url = $EMG->returnUrl(array(
                "userCode" => $userInfoCode,
                "password" => $this->request->getPost("password"),
                "returnUrl" => $url[$this->request->getPost("type")]
            ));
            $this->ajaxResponse($url, '连接请求返回', 0);
        }
    }

    //使用果实开始

    //返回果实使用可获得物品信息
    function fruitCheckAction()
    {
        $data = $this->checkFruit();
        if ($data == false || $this->is_error($data)) {
            $this->ajaxResponse("", "果实信息返回失败!{$data["message"]}", 1);
        }
        $this->ajaxResponse($data, "果实信息返回成功！", 0);
    }

    //果实使用信息
    function checkFruit()
    {
        if ($this->request->isPost()) {
            $goodsInfo = $this->getOneProductInfo($this->request->getPost("tId"));
            $goodsInfo['desc'] = "可随机获得金币，土地升级卡、化肥等道具";
            if(!empty($goodsInfo['chanceinfo']))
            {
               $chanceinfo= json_decode($goodsInfo["chanceinfo"], true);
                if(!empty($chanceinfo["desc"]))
                {
                    $goodsInfo['desc']=$chanceinfo["desc"];
                }
                $goodsInfo['reward']=$chanceinfo;
            }
            return $goodsInfo;
        }
    }

    //返回果实使用结果
    function fruitUseAction()
    {
        $this->db->begin();
        $data = $this->checkFruit();
        if ($data == false || $this->is_error($data)) {
            $this->db->rollback();
            $this->ajaxResponse("", "果实使用失败！{$data["message"]}", 1);
        }
        $flag = $this->useFruit($data);
        if ($this->is_error($flag) || $flag == false) {
            $this->db->rollback();
            $this->ajaxResponse("", "抱歉！{$flag["message"]}", 1);
        }
        $this->db->commit();
        $this->ajaxResponse(array("tool"=>$flag['tool'],"fruit"=>$flag['fruit'],"gotdiamond"=>$flag['gotdiamond'],"diamonds"=>$flag['diamonds']), $flag["message"], 0);
    }

    //使用果实
    function useFruit($data)
    {
        //{"win":[{"tid":"diamonds","percent":50,"min":10,"max":30},
        //{"tid":"1","percent":40,"min":1,"max":1},
        //{"tid":"18","percent":5,"min":1,"max":1},
        //{"tid":"19","percent":3,"min":1,"max":1},
        //{"tid":"20","percent":2,"min":1,"max":1}],
        //"desc":"可获得金币、道具或者使用掉","nullpercent":10}
        if(empty($data['reward'])||$data['reward']=='')
        {
            return $this->error(1, "使用失败，尚未设置奖励！");
        }
        $reward=$data['reward'];
        //修改支持小数百分比
        $mod=1000;
        $np=intval($reward['nullpercent']*$mod);
        $p_total=$np;
        foreach ($reward['win'] as $key=>$value)
        {
            $p_total+=intval($value['percent']*$mod);
        }
        if($p_total<1)
        {
            return $this->error(1, "使用失败，奖励参数设置不正确！");
        }
        $flag =$this->saveProduct($data["id"], 1, "ded");
        if ($flag == false) {
            return $this->error(1, "使用失败！{$data["title"]}数量不足!");
        }
        $flag = $this->saveOrchardLogs(array("mobile" => $this->mobile, "types" => "dedgoods", "landId" => $data["id"], "nums" => -1, "msg" => "使用" . $data["title"] . "1颗"));
        if ($flag == false) {
            return $this->error(1, "使用失败！{$data["title"]}日志记录更新失败!");
        }
        $userModel = new OrchardUser();
        $user = $userModel->findFirst("uid='{$this->userid}'");

        $randNum=0;
        if($np>0)
        {
            $randNum=mt_rand(1, $p_total);
            if($randNum<=$np)
            {
                return $data=["message"=>"运气不好，果实被您家狗偷吃了！","fruit"=>null,"tool"=>null,"gotdiamond"=>null,"diamonds"=>$user->diamonds];
            }
        }
        $last=$np;
        foreach ($reward['win'] as $key=>$value)
        {
            if($value['percent']&&intval($value['percent']*$mod)>0)
            {
                $last+=intval($value['percent']*$mod);
                if($last>=$randNum&&intval($value['min'])>0&&intval($value['min'])<=intval($value['max']))
                {
                    $mark="diamonds";
                    $msg="";
                    $gotdiamond=0;
                    $tool=null;
                    $fruit=null;
                    $num=mt_rand(intval($value['min']),intval($value['max']));
                    if($value['tid']=="diamonds")
                    {
                        $mark="diamonds";
                        $gotdiamond=$num;
                        $msg="获得".$this->onoTitleInfo()[$mark]."+".$num;
                        //更新获得的道具
                        $flag = $this->updateUser($this->userid, $mark,$num, "add");
                        $flag1 = $this->saveOrchardLogs(array("mobile" => $this->mobile, "landId" => $data["id"], "types" => "add".$mark, "nums" => $num, "msg" => "使用".$data['title']."获得" . $this->onoTitleInfo()[$mark] . "+".$num));
                        if ($flag == false || $flag1 == false) {
                            $this->error(1, "使用失败，更新".$this->onoTitleInfo()[$mark]."数量操作失败！");
                        }
                    }
                    else if($value['tid']=="1")
                    {
                        $num=mt_rand(intval($value['min']),intval($value['max']));
                        $tool=array($value['tid'],$num);
                        $msg="获得种子+".$num;
                        $flag = $this->saveProduct($value['tid'], $num, "add");
                        if ($flag == false) {
                            return $this->error(1, "果实使用失败！更新种子数量失败!");
                        }
                        $flag = $this->saveOrchardLogs(array("mobile" => $this->mobile, "types" => "addgoods", "landId" => $data['id'], "nums" => $num, "msg" => "使用".$data['title']."获得种子" . $num . "颗"));
                        if ($flag == false) {
                            return $this->error(1, "果实使用失败！种子日志记录更新失败!");
                        }
                    }
                    else{
                        $prop = $this->getOneOrchardGoodsInfo($value['tid']);//获取道具信息
                        if($prop){
                            $index=$prop['tId'] . $prop['type'];
                            $info=$this->onoInfo();
                            $mark=$info[$index];
                        }
                        else{
                            return $this->error(1, "使用失败，奖励参数设置不正确！");
                        }
                        $tool=array($value['tid'],$num);
                        $msg="获得".$this->onoTitleInfo()[$mark]."+".$num;
                        //更新获得的道具
                        $flag = $this->updateUser($this->userid, $mark,$num, "add");
                        $flag1 = $this->saveOrchardLogs(array("mobile" => $this->mobile, "landId" => $data["id"], "types" => "add".$mark, "nums" => $num, "msg" => "使用".$data['title']."获得" . $this->onoTitleInfo()[$mark] . "+".$num));
                        if ($flag == false || $flag1 == false) {
                            $this->error(1, "使用失败，更新".$this->onoTitleInfo()[$mark]."数量操作失败！");
                        }
                        if(in_array($value['tid'],array(18,19,20))) {
                            $flag = $this->saveDoubleEffect(array("mark" => 0, "types" => $data["id"], "nums" => 1, "msg" => "恭喜[{$user->nickname} 的家园]使用" . $data['title'] . $msg));
                            if ($flag == false) {
                                return $this->error(1, "使用果实日志更新失败！");
                            }
                        }
                    }
                    return $data=["message"=>"恭喜您使用果实成功，".$msg,"tool"=>$tool,"gotdiamond"=>$gotdiamond,"fruit"=>$fruit,"diamonds"=>$user->diamonds];
                    break;
                }
                else if($last>=$randNum){
                    return $this->error(1, "使用失败，奖励参数设置不正确！");
                }
            }
        }
        return $data=["message"=>"运气不好，果实被邻居家的猫叼吃了！","tool"=>null,"fruit"=>null,"gotdiamond"=>null,"diamonds"=>$user->diamonds];
    }

    //使用果实结束


    function fruitSellAction()
    {
        $data = $this->checkFruit();
        if ($data == false || $this->is_error($data)) {
            $this->ajaxResponse('', "出售果实失败！获取果实信息失败", 1);
        }
        $goodsInfo = $this->getOneProductInfo($this->request->getPost("tId"));
        if ($goodsInfo) {
            $this->db->begin();
            $flag=$this->sellFruit($goodsInfo);
            if ($this->is_error($flag) || $flag == false) {
                $this->db->rollback();
                $this->ajaxResponse("", "抱歉！{$flag["message"]}", 1);
            }
            $this->db->commit();
            $this->ajaxResponse(array("diamonds" => $flag["diamonds"]), $flag["message"], 0);
        }
    }

    function sellFruit($data)
    {
        if ($this->request->isPost()) {
            $num=intval($this->request->getPost("num"));
            $flag = $this->saveProduct($data['id'], $num, "ded");
            if ($flag == false) {
                return $this->error(1, "出售失败！{$data["title"]}数量不足!");
            }
            $flag = $this->saveOrchardLogs(array("mobile" => $this->mobile, "types" => "dedgoods", "landId" => $data["id"], "nums" => -$num, "msg" => "出售" . $data["title"] . $num . "颗"));
            if ($flag == false) {
                return $this->error(1, "出售失败！{$data["title"]}日志记录更新失败!");
            }

            $product = $this->getOneProductInfo($data['id']);

            $userModel = new OrchardUser();
            $user = $userModel->findFirst("uid='{$this->userid}'");
            $money=round(floatval($product['startprice'])*$num,0);
            $user->diamonds += $money;
            $user->updatetime = TIMESTAMP;
            $flag = $user->update();
            $flag1 = $this->saveOrchardLogs(array("mobile" => $user->mobile, "landId" => $data["id"], "types" => "adddiamonds", "nums" => $money, "msg" => "出售".$num."个".$data["title"]."获得".$money."枚金币"));
            if ($flag == false||$flag1==false) {
                return $this->error(1, "金币数量更新失败！");
            }
            return ["diamonds"=>$user->diamonds,"message"=>"恭喜您出售".$num."个".$data["title"]."获得".$money."枚金币"];
        } else {
            return $this->error('', "出售果实失败！非法操作", 1);
        }
    }

    //查找转账接收人信息
    function findUserAction()
    {
        if ($this->request->isPost()) {
            $uid = $this->request->getPost("uid");
            if(!$uid){
                $this->ajaxResponse("", "请输入搜索会员编号或者手机号",1);
            }
            $user = new OrchardUser();
            $user = $user->findFirst("uid='{$uid}' or mobile='{$uid}'");
            $user = $this->object2array($user);
            if (empty($user)) {
                $this->ajaxResponse("", "玩家信息搜索失败",1);
            }
            $data = array(
                "uid" => $user["uid"],
                "mobile" => $user["mobile"],
                "userName" => $user["nickname"],
                "diamonds" => $user["diamonds"],
                "level" => $user["grade"],
                "fee"=>$this->getConfig("transferfee")
            );
            if(empty($data)){
                $this->ajaxResponse("", "玩家信息搜索失败",1);
            }
            $this->ajaxResponse($data, "玩家信息返回成功",0);
        }
    }
    function transferAction()
    {
        if ($this->request->isPost()) {
            $uid = $this->request->getPost("uid");
            if(!$uid){
                $this->ajaxResponse("", "请输入搜索会员编号或者手机号",1);
            }
            $num=$this->request->getPost("num");
            if(intval($num)<0)
            {
                $this->ajaxResponse("", "请输入正确的转账数量",1);
            }
            $model = new OrchardUser();
            $fuser = $model->findFirst("uid='".$this->userid."'");
            if(empty($fuser))
            {
                $this->ajaxResponse("", "获取当前用户信息失败",1);
            }

            $user = $model->findFirst("uid='{$uid}'");
            if (empty($user)) {
                $this->ajaxResponse("", "玩家信息搜索失败",1);
            }
            $mark="diamonds";
            $pid=$this->request->getPost('transferid');

            $fee=0;//如果不是转账金币不需要手续费
            if($pid!="diamonds"){
                $prop = $this->getOneOrchardGoodsInfo($pid);
                $index=$prop['tId'] . $prop['type'];
                $info=$this->onoInfo();
                $mark=$info[$index];
            }
            else{
                if((intval($fuser->$mark)-2000000)<intval($num)){
                    $this->ajaxResponse("", "您的".$this->onoTitleInfo()[$mark]."数量不足，账户最少保留2000000金币",1);
                }
                $tf=$this->getConfig("transferfee");
                $fee=floatval($tf)/100.0;
                $fee=round($fee*$num,0);
            }
            if(intval($fuser->$mark)<intval($num))
            {
                $this->ajaxResponse("", "您的".$this->onoTitleInfo()[$mark]."数量不足，请修改转账数量",1);
            }
            $this->db->begin();
            $fuser->$mark -= $num;
            $fuser->updatetime = TIMESTAMP;
            $flag = $fuser->update();
            //$flag = $this->updateUser($this->userid, $mark,$num, "ded");
            $flag1 = $this->saveOrchardLogs(array("mobile" => $fuser->mobile, "landId" => 0, "types" => "ded".$mark, "nums" => $num, "msg" => "转账给".$user->nickname."扣除" . $this->onoTitleInfo()[$mark] . "-".$num));
            if ($flag == false || $flag1 == false) {
                $this->db->rollback();
                $this->ajaxResponse('', "转账失败，更新".$this->onoTitleInfo()[$mark]."数量操作失败！",1);
            }
            $real=$num-$fee;
            $flag = $this->updateUser($uid, $mark,$real, "add");
            $flag1 = $this->saveOrchardLogs(array("uid"=>$uid,"mobile" => $user->mobile, "landId" => 0, "types" => "add".$mark, "nums" => $real, "msg" => $fuser->nickname."转账给我获得" . $this->onoTitleInfo()[$mark] . "+".$real));
            if ($flag == false || $flag1 == false) {
                $this->db->rollback();
                $this->ajaxResponse('', "转账失败，更新".$this->onoTitleInfo()[$mark]."数量操作失败！",1);
            }
            if($fee>0)
            {
                $flag2 = $this->saveOrchardLogs(array("uid"=>$uid,"mobile" => $user->mobile, "landId" => 0, "types" => "ded".$mark, "nums" => $fee, "msg" => "转账手续费扣除" . $this->onoTitleInfo()[$mark] . "-".$fee));
                if ($flag2 == false) {
                    $this->db->rollback();
                    $this->ajaxResponse('', "转账失败，更新".$this->onoTitleInfo()[$mark]."转账手续费数量操作失败！",1);
                }
            }
            $this->db->commit();
            $this->ajaxResponse(array("diamonds" => $fuser->diamonds), '转账成功，已向'.$user->nickname."转账".$num. $this->onoTitleInfo()[$mark], 0);
        }
    }
}

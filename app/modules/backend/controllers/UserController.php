<?php
namespace Dhc\Modules\Backend\Controllers;
use Dhc\Models\DistributionList;
use Dhc\Models\Order;
use Dhc\Models\Recharge;
use Dhc\Models\UserGold;
use Dhc\Models\UserLog;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;
use Dhc\Models\User;

class UserController extends ControllerBase
{
    private $pageSize = '15';
    public function listAction() {
        if (USER_TYPE == 'jindao'){
            $Ktime = (TIMESTAMP - (60*3));
            $oline = UserLog::findFirst(
                [
                    'conditions'=>"logintime >= '{$Ktime}'",
                    'columns'	=>'count(uid) AS numbers'
                ]
            );
            $this->view->setVar('online',max($oline->numbers,0));
        }
        $operateId = $this->session->get('operate');
        $this->operate = $operateId;
        $op = $this->request->get('op', null, 'list');
        $this->view->setVar('op', $op);
        $user = new User();
        if ($op == 'list') {
            // 搜索条件
            $keyword = $this->request->get("keyword");
            $this->view->setVar('keyword', $keyword);
            if(!empty($keyword)){
                $conditions = "id = '{$keyword}' OR user LIKE '%{$keyword}%' OR nickname LIKE '%{$keyword}%'";
            }else{
                $conditions = '';
            }
            $userList = $user->find([
                "conditions" => $conditions,
                "order" => "id DESC"
            ]);
            $currentPage = $this->request->get('page', null, 1);
            $paginator = new PaginatorModel(
                array(
                    "data" => $userList,
                    "limit" => 20,
                    "page" => $currentPage
                )
            );
            $page = $paginator->getPaginate();
            foreach ($page as $key=>$value){
                foreach ($value as $k=>$v){
                    $v->superior = $this->getTeacher($v->id);
                }
            }
            $this->view->setVar('page', $page);
            $all_price = $user::sum(
                ["column" => "coing"]
            );
            $this->view->setVar('all_price', $all_price);
        } elseif ($op == 'edit') {
            $id = $this->request->get('id', 'int', 0);
            if(!empty($id)){
                $user = $user->findFirst("id = $id");
                if(empty($user)){
                    return $this->message("要编辑的用户不存在！", 'referer', 'info');
                }
                $user->salesmanRebate = json_decode($user->salesmanRebate, true);
                $this->view->setVar('item', $user);
            }
            if ($this->request->isPost()) {
                $data = $this->request->getPost();
                $user->user = $data['user'];
                $user->nickname = $data['nickname'];
                $user->authLevel = $data['authLevel'];
                $user->salesmanRebate = json_encode($data['salesmanRebate']);
                $user->channelRebate = $data['channelRebate'];
                $user->usergroup = $data['usergroup'];
                $user->status = $data['status'];
                $user->realname = $data['realname'];
                $user->idcard   = $data['idcard'];
                if($this->userExist($data['user'], $id)){
                    return $this->message("用户账号不能为空，或已经存在", '', 'error');
                }
                if(!empty($data['password'])){
                    $user->salt = $this->random(6);
                    $user->password = sha1($user->salt.$data['password']);
                }
                if(empty($id)){
                    $user->createTime = TIMESTAMP;
                }
                $flag = $user->save();
                if ($flag === false) {
                    return $this->message("操作失败，请重试！<br>{$this->getSqlError($flag, $user)}", 'referer', 'error');
                }else{
                    return $this->message("操作成功！", '?op=list', 'success');
                }
            }
            $this->view->setVar('id', $id);
        } elseif ($op == 'manage') {
            $order = new Order();
            $conditions = " 1=1 ";
            $uid = $this->request->get('user');
            $this->view->setVar('uid', $uid);
            if(!empty($uid)){
                $conditions .= " AND uid = '{$uid}'";
                $this->view->setVar('uid',$uid);
            }

            $status = $this->request->get('status', null, 1);
            $this->view->setVar('status', $status);
            if(isset($status)){
                $conditions .= " AND status = '{$status}'";
                $this->view->setVar('status',$status);
            }

            $sid = $this->request->get('sid');
            if(!empty($sid)){
                $conditions .= " AND sid = '{$sid}'";
                $this->view->setVar('sid',$sid);
            }
            $list = $order->find(
                [
                    'conditions' => $conditions,
                    'order' => 'createtime DESC'
                ]
            );

            $currentPage = $this->request->get('page', null, 1);
            $paginator = new PaginatorModel(
                array(
                    "data" => $list,
                    "limit" => 20,
                    "page" => $currentPage
                )
            );
            $page = $paginator->getPaginate();
            $this->view->setVar('page', $page);
        } elseif ($op == 'recharge') {
            $user = $this->request->getPost('user');
            if ($user) {
                $user = $this->db->query("SELECT * FROM dhc_user WHERE user = $user")->fetch();
                if (empty($user)) {
                    return $this->message("要编辑的用户不存在！", 'referer', 'info');
                } else {
                    $id = $user['id'];
                    $UserModel = new User();
                    $user = $UserModel->findFirst("id = " . $user['id']);
                }

                $this->view->setVar('item', $user);
            }
            if ($this->request->isPost()) {
                $rechargeCoin = $this->request->getPost('rechargecoing');
                $rechargeCoin = sprintf("%.2f", $rechargeCoin);
                $this->db->begin();
                $userGold = new UserGold();
                $userGold->oid = $operateId;
                $userGold->uid = $id;
                $userGold->gold = $rechargeCoin;
                $userGold->createtime = TIMESTAMP;
                $flagA = $userGold->save();
                if ($flagA == false) {
                    $this->db->rollback();
                    return $this->message("操作失败，请重试<br>{$this->getSqlError($flagA, $userGold)}", "referer", "info");
                }

                $user->coing = ($user->coing + $rechargeCoin);
                if ($user->coing < 0) {
                    $this->db->rollback();
                    return $this->message("操作失败，金币扣除量不能大于用户现有金币量！", 'referer', 'info');
                }
                $flagB = $user->update();
                if ($flagB == false) {
                    $this->db->rollback();
                    return $this->message("操作失败，请重试<br>{$this->getSqlError($flagA, $userGold)}", "referer", "info");
                } else {
                    $this->db->commit();
                    $this->saveGold($id,$rechargeCoin);
                    return $this->message("操作成功", "?op=list", "success");

                }
            }
        } elseif($op == 'logs'){
            $uid = $this->request->get('uid');
            if (!empty($uid)) {
                $user = $user->findFirst("id = '{$uid}'");
                if (empty($user)) {
                    return $this->message("要查看的用户不存在！", 'referer', 'info');
                }
            }
            $conditions = "uid = '{$uid}'";
            $list = UserGold::find([
                "conditions" => $conditions,
                "order" => "createtime DESC"
            ]);
            $currentPage = $this->request->get('page', null, 1);
            $paginator = new PaginatorModel(
                array(
                    "data" => $list,
                    "limit" => 20,
                    "page" => $currentPage
                )
            );
            $page = $paginator->getPaginate();
            $this->view->setVar('page', $page);
        } elseif($op == 'channel'){
            // 搜索条件
            $keyword = $this->request->get("keyword");
            $this->view->setVar('keyword', $keyword);
            $conditions = "channelRebate > 0";
            if(!empty($keyword)){
                $conditions .= " AND (id = '{$keyword}' OR user LIKE '%{$keyword}%' OR nickname LIKE '%{$keyword}%')";
            }
            $userList = $user->find([
                "conditions" => $conditions,
                "order" => "id DESC"
            ]);
            $currentPage = $this->request->get('page', null, 1);
            $paginator = new PaginatorModel(
                array(
                    "data" => $userList,
                    "limit" => 20,
                    "page" => $currentPage
                )
            );
            $page = $paginator->getPaginate();
            $this->view->setVar('page', $page);
        }  elseif($op == 'salesman'){
            $currentPage = $this->request->get('page', null, 1);
            // 搜索条件
            $keyword = $this->request->get("keyword");
            $this->view->setVar('keyword', $keyword);
            $conditions = "salesmanRebate REGEXP '\:\"[1-9]+.*\"'";
            if(!empty($keyword)){
                $conditions .= " AND (id = '{$keyword}' OR user LIKE '%{$keyword}%' OR nickname LIKE '%{$keyword}%')";
            }

            $limitStart = ($currentPage - 1) * 20;
            $sql = "SELECT * FROM `dhc_user` WHERE $conditions ORDER BY id DESC LIMIT $limitStart, 20";
            $userList = $this->db->query($sql)->fetchAll();

            $totalPage = $this->db->query("SELECT * FROM dhc_user WHERE $conditions")->numRows() / 20;
            $page = [
                "count"=>count($userList),
                    "items" => $userList,
                    "current" => $currentPage,
                    "before" => max($currentPage-1, 1),
                    "next" => min($currentPage+1, 1),
                    "last" => max(intval($totalPage), 1) ,
                ];
            $this->view->setVar('page', $page);
        } elseif ($op == 'performance'){
            $uid = $this->request->get("uid", 'int', 0);
            $this->view->setVar('uid', $uid);
            if (!empty($uid)) {
                $userItem = $user->findFirst("id = $uid");
                if (empty($userItem)) {
                    return $this->message("要查看的用户不存在！", 'referer', 'info');
                }
                $this->view->setVar('item', $userItem);
            } else {
                return $this->message("要查看的用户不存在！", 'referer', 'info');
            }
            $conditions = "superior REGEXP '^{$uid}-|-{$uid}-'";
            $keyword = $this->request->get("keyword");
            $this->view->setVar('keyword', $keyword);
            $currentPage = $this->request->get('page', null, 1);
            if(!empty($keyword)){
                $conditions .= " AND (id = '{$keyword}' OR user LIKE '%{$keyword}%' OR nickname LIKE '%{$keyword}%')";
            }
            $limitStart = ($currentPage - 1) * 20;
            $sql = "SELECT * FROM dhc_user WHERE $conditions LIMIT $limitStart, 20";
            $userList = $this->db->query($sql)->fetchAll();
            $totalPrice = 0; // 团队总业绩
            foreach ($userList as $key=>&$val){
                $val["type_1"] = 0;
                $val["type_2"] = 0;
                $goldNum = DistributionList::sum([
                    'column' => 'gold',
                    'group' => 'type',
                    'conditions' => "uid = '{$val['id']}'",
                ]);
                foreach ($goldNum as $item){
                    $totalPrice += $item['sumatory'];
                    $val["type_" . $item['type']] = $item['sumatory'];
                }
            }
            //获取用户列表 计算总的佣金数量
            $userLists = $this->db->query("SELECT * FROM dhc_user WHERE $conditions")->fetchAll();
            $totalPrice = 0;
            $money = 0;
            foreach ( $userLists as $key=>&$val){
                $goldNum = DistributionList::sum([
                    'column' => 'gold',
                    'group' => 'type',
                    'conditions' => "uid = '{$val['id']}'",
                ]);
                $amount = DistributionList::sum([
                    'column' => 'amount',
                    'group' => 'type',
                    'conditions' => "uid = '{$val['id']}'",
                ]);
                foreach ($goldNum as $item){
                    $totalPrice += $item['sumatory'];
                }
                foreach ($amount as $items){
                    $money += $items['sumatory'];
                }
            }
            //结束
            $totalPage = ceil(count($this->db->query("SELECT * FROM dhc_user WHERE $conditions")->fetchAll())/20);
            $countPeople = count($this->db->query("SELECT * FROM dhc_user WHERE $conditions")->fetchAll());
            $page = [
                "count"=>$countPeople,
                "items" => $userList,
                "current" => $currentPage,
                "before" => max($currentPage-1, 1),
                "next" => min($currentPage+1, $totalPage),
                "last" => max(intval($totalPage), 1) ,
            ];
            $this->view->setVar('totalPrice',$totalPrice);
            $this->view->setVar('money',$money);
            $this->view->setVar('page', $page);
        }elseif ($op=='channels'){
            $uid = $this->request->get('uid');
            $pagenow= $this->request->get('page');
            if (empty($pagenow)){
                $pagenow = 1;
            }
            $disType = $this->request->get('type');
            if (empty($disType)){
                $disType = 'common';
            }

            $conditions = "1 = 1 AND disType = '{$disType}' ";
            if (!empty($uid)){
                $conditions .= " AND uid = {$uid}";
                $this->view->setVar('uid',$uid);
            }
            if (!empty($this->request->get('time'))) {
                $time = $this->request->get('time');
                $starttime =  strtotime(date($time['start'],time()));
                $endtime =  strtotime(date($time['end'],time()))+86399;
                $conditions .= " AND createTime >= {$starttime} AND createTime <= {$endtime} ";
            }else{
                $starttime = strtotime(date("Y-m-1 00:00:00",time()));
                $endtime = strtotime(date("Y-m-d 23:59:59",time()));
                $conditions .= " AND createTime >= {$starttime} AND createTime <= {$endtime} ";
            }
            $pageoffset = ($pagenow-1)*$this->pageSize;
            $sql = " SELECT * FROM dhc_distribution_list WHERE $conditions ORDER BY createTime DESC LIMIT $pageoffset,$this->pageSize";
            $channelList = $this->db->query($sql)->fetchAll();
            $sql1 = "SELECT COUNT(*)AS total FROM dhc_distribution_list WHERE $conditions";
            $total_num = $this->db->query($sql1)->fetch();
            $lists['total_pages'] = ceil($total_num['total']/$this->pageSize);
            $lists['next'] = min($pagenow+1,$lists['total_pages']);
            $lists['before'] = max($pagenow-1,1);
            $lists['last'] =   max($lists['total_pages'],0);
            $lists['current'] = max(intval($pagenow),1);
            $lists['list'] = $channelList;
            //			$channelList = DistributionList::find(
            //				[
            //					'conditions'=>$conditions,
            //					'order'=>'createTime DESC'
            //				]
            //			);
            $all_price =DistributionList::findFirst(
                [
                    'conditions'=>$conditions,
                    'columns'	=>'SUM(amount) as amount'
                ]
            );
            $all_money =DistributionList::findFirst(
                [
                    'conditions'=>$conditions,
                    'columns'	=>'SUM(gold) as gold'
                ]
            );
            $sql = "SELECT id,realname,user FROM dhc_user";
            $result=$this->db->query($sql)->fetchAll();
            //			$paginator = new PaginatorModel(
            //				array(
            //					"data" => $channelList,
            //					"limit" => 20,
            //					"page" => $pagenow
            //				)
            //			);
            //			$page = $paginator->getPaginate();
            //			$this->view->setVar('pages',$page);
            if (empty($all_money->gold)){$all_money->gold='0';};
            if (empty($all_price->amount)){$all_price->amount='0';};
            $this->view->setVar('realname',$result);
            $this->view->setVar('all_money',$all_money->gold);
            $this->view->setVar('all_price',$all_price->amount);
            $this->view->setVar('channels',$lists);
            $this->view->setVar('type',$disType);
            //			$this->view->setVar('page',$lists);
        }elseif ($op == 'channellist'){
            $data = $this->getSpreadList();
            $keyword = $this->request->get('keyword');
            $uid  =$this->request->get('uid');
            if (!empty($uid)){
                $this->view->setVar('uid',$uid);
            }
            $this->view->setVar('keywords',$keyword);
            if (!empty($data)){
                foreach ($data['items'] as $key=>$value){
                    foreach ($value as $k=>$v){
                        if ($k == 'id'){
                            $info = $this->channelAmounts($value['id']);
                            $data['items'][$key]['yes'] = $info['yes'];
                            $data['items'][$key]['no'] = $info['no'];
                        }
                    }
                }
                $this->view->setVar('channellist',$data);
            }

        }
        $this->view->setVar('starttime',date("Y-m-d",$starttime));
        $this->view->setVar('endtime',date("Y-m-d",$endtime));
        $this->view->setVar('keyword',$keyword);
        return $this->view->pick('user/ulist');
    }

    public function idcardAction(){
        $page = $this->request->get('page','int','1');
        $pageOffset = ($page-1)*$this->pageSize;
        $sql = "SELECT id,realname,idcardFront,idcardback FROM dhc_user WHERE idcardStatus = 2 LIMIT $pageOffset,$this->pageSize";
        $userList = $this->db->query($sql)->fetchAll();
        $sql1 = "SELECT COUNT(*) AS total FROM dhc_user WHERE idcardStatus = 2";
        $total = $this->db->query($sql1)->fetch();
        $list['total_pages'] = ceil($total['total']/$this->pageSize);
        $list['next']		 = min($list['total_pages'],$page+1);
        $list['before']	     = max($page-1,1);
        $list['last']		 = $list['total_pages'];
        $list['current']	 = $page;
        $list['list']		 = $userList;
        $this->view->setVar('userlist',$list);
    }
    public function passIdcardAction(){
        $data = $this->request->getPost();
        foreach ($data as $value){
            foreach ($value as $k=>$v){
                $result = $this->passIdCard($v);
                if ($result == false){
                    echo json_encode(
                        $mes = array(
                            'data'=>$v,
                            'msg'=>'该用户审核失败'.$v,
                            'code'=>'1'
                        )
                    );die;
                }
            }
        }
        echo json_encode(
            $mes = array(
                'data'=>'success',
                'msg'=>'审核成功',
                'code'=>'0'
            )
        );die;
    }

    public function returncardAction(){
        $data = $this->request->getPost();
        foreach ($data as $value){
            foreach ($value as $k=>$v){
                $result = $this->returnCard($v);
                if ($result == false){
                    echo json_encode(
                        $mes = array(
                            'data'=>$v,
                            'msg'=>'该用户操作失败'.$v,
                            'code'=>'1'
                        )
                    );die;
                }
            }
        }
        echo json_encode(
            $mes = array(
                'data'=>'success',
                'msg'=>'操作成功',
                'code'=>'0'
            )
        );die;
    }

    public function payList(){
        $payList = Recharge::find();
        if ($payList){
            $this->view->setVar('paylist',$payList);
        }
        $this->view->pick('user/pay');
    }

    public function passIdCard($id){
        $userInfo = User::findFirst("id = '{$id}'");
        if (!empty($userInfo)){
            if ($userInfo->idcardStatus == 2){
                $userInfo->idcardStatus = 1;
                $result = $userInfo->update();
                if (empty($result)){
                    foreach ($userInfo->getMessages() as $message){
                        echo  $message;
                    }die;
                }else{
                    return true;
                }

            }else{
                return false;
            }
        }
    }
    public function returnCard($id){
        $userInfo = User::findFirst("id = '{$id}'");
        if (!empty($userInfo)){
            if ($userInfo->idcardStatus == 2){
                $userInfo->idcardStatus = 0;
                $result = $userInfo->update();
                if (empty($result)){
                    foreach ($userInfo->getMessages() as $message){
                        echo  $message;
                    }die;
                }else{
                    return true;
                }

            }else{
                return false;
            }
        }
    }

    private function saveGold($uid,$number){
        $orderNumber = $this->createOrderNumber($uid,'HC');
        $userRecharge =  new Recharge();
        $userRecharge->uid  = $this->operate;
        $userRecharge->orderNumber = $orderNumber.'-'.$uid;
        $userRecharge->number  = $number;
        $userRecharge->payType = 'back';
        $userRecharge->type = '2';
        $userRecharge->payStatus = 1;
        $userRecharge->createTime = TIMESTAMP;
        $result =  $userRecharge->save();
        if (empty($result)){
            foreach ($userRecharge->getMessages() as $message){
                echo  $message;
            }die;
        }

    }

    /**
     * 检查用户是否已经存在
     * @param $userAccount
     * @return bool
     */

    private function userExist($userAccount = 0, $uid = 0) {
        $res = User::findFirst([
            'conditions' => "user = '{$userAccount}' AND id <> '{$uid}'"
        ]);
        if (empty($res)) {
            return false;
        } else {
            return true;
        }
    }
    public function getSpreadList(){
        $keyword = $this->request->get('keyword');
        if (empty($keyword)||!empty($uid)){
            $uid = $this->request->get('uid');
            $pagesize = 20;
            $page = $this->request->get('page');
            $flag = $this->checkchannel($uid);
            if (empty($page)){$page =  1;}
            $conditions = "superior REGEXP '^{$uid}-|-{$uid}-'";
            $pagestart = ($page-1)*$pagesize;
            $sql = "SELECT id,createTime,superior,user FROM dhc_user WHERE $conditions ORDER BY createTime DESC  LIMIT $pagestart ,$pagesize";
            $spreadUser = $this->db->query($sql)->fetchAll();
            foreach ($spreadUser as $key=>&$value){
                $superior = explode('-',$value['superior']);
                foreach ($superior as $k=>$v){
                    if ($v == $uid){
                        if ($k>=1){
                            if ($k>=2)
                            {
                                $ids[] = $value['id'];
                            }
                            $value['level'] = $k;
                        }else{
                            $value['level'] = $k;
                        }
                    }
                }
            }
            foreach ($spreadUser as $key=>&$val){
                foreach ($val as $k=>$v){
                    if (is_numeric($k)){
                        unset($val[$k]);
                    }
                }
            }
            if (!$flag){
                foreach ($spreadUser as $key=>&$value){
                    foreach ($ids as $k=>$v){
                        if ($v == $value['id']){
                            unset($spreadUser[$key]);
                        }
                    }
                }
            }
            $sums = $this->db->query("SELECT COUNT(*) as sums FROM dhc_user WHERE $conditions")->fetchAll();
            if (empty($keyword)){
                $number=$this->getdirect($uid);
            }
            $sum = $sums[0]['sums'];
            $totalPage = ceil($sum/$pagesize);
            $data = [
                "uid"	=>$uid,
                "items" => $spreadUser,
                "current" => $page,
                "before" => max($page-1, 1),
                "next" => min($page+1, 1),
                "last" => max(intval($totalPage), 1) ,
                'number'=>$number,
                'sum'	=>$sum ,
                'total_page'=>max($totalPage, 1)
            ];

            return $data;

        }elseif (!empty($keyword)){
            $uid = $this->request->get('uid');
            $conditions = "id = {$keyword} OR user = '{$keyword}'";
            $sql = " SELECT id,createTime,superior,user FROM dhc_user WHERE $conditions";
            $data = $this->db->query($sql)->fetchAll();
            foreach ($data as $key=>&$value){
                $superior = explode('-',$value['superior']);
                foreach ($superior as $k=>$v){
                    if ($v == $uid){
                        if ($k>=1){
                            $value['level'] = $k;
                        }else{
                            $value['level'] = $k;
                        }
                    }
                }
            }
            $data = [
                "uid"	=>$keyword,
                "items" => $data,
            ];
            return $data;
        }
    }
    public function getdirect($uid){
        $conditions = "superior REGEXP '^{$uid}-|-{$uid}-'";
        $sql = "SELECT id,createTime,superior,user FROM dhc_user WHERE $conditions ORDER BY createTime DESC  ";
        $spreadUser = $this->db->query($sql)->fetchAll();
        $number = 0;
        foreach ($spreadUser as $key=>&$value){
            $superior = explode('-',$value['superior']);
            foreach ($superior as $k=>$v){
                if ($v == $uid){
                    if ($k>=1){
                        if ($k>=2)
                        {
                            $ids[] = $value['id'];
                        }
                        $value['level'] = '1';
                    }else{
                        $number ++;
                        $value['level'] = '0';
                    }
                }
            }
        }
        return $number;
    }
    public function commissionAction(){
        $keyword = $this->request->get('keyword');
        $page = $this->request->get('page');
        $op = $this->request->get('op');
        if (empty($op)){
            $op = 'details';
        }
        if (empty($page)){
            $page = 1;
        }
        $conditions =  "1 = 1";
        if (!empty($this->request->get('time'))) {
            $time = $this->request->get('time');
            $starttime = strtotime(date($time['start'], TIMESTAMP));
            $endtime = strtotime(date($time['end'], TIMESTAMP)) + 86399;
            $conditions .= " AND createTime >= {$starttime} AND createTime <= {$endtime} ";
        } else {
            $starttime = strtotime(date("Y-m-1 00:00:00", TIMESTAMP));
            $endtime = strtotime(date("Y-m-d 23:59:59", TIMESTAMP));
            $conditions .= " AND createTime >= {$starttime} AND createTime <= {$endtime} ";
        }
        if (!empty($keyword)){
            $conditions .= " AND uid = '{$keyword}'";
        }
        $pageoffset  = ($page-1)*$this->pageSize;
        if ($op == 'details'){
            //获取记录
            $sql = "SELECT * FROM dhc_distribution_list WHERE $conditions ORDER BY createTime DESC LIMIT $pageoffset,$this->pageSize";
            $list = $this->db->query($sql)->fetchAll();
            //查询符合条件的记录数
            $sql1 = "SELECT COUNT(*) AS total_page FROM dhc_distribution_list WHERE $conditions";
            $total_page = $this->db->query($sql1)->fetch();
            //查询用户的昵称
            $sql2 = "SELECT id,realname,user FROM dhc_user";
            $result=$this->db->query($sql2)->fetchAll();
            //获取用户的返佣统计
            $lists['total_pages'] = ceil($total_page['total_page']/$this->pageSize);
            $lists['next']		 = min($lists['total_pages'],$page+1);
            $lists['before']	 = max($page-1,1);
            $lists['last']		 = $lists['total_pages'];
            $lists['current']	 = $page;
            $lists['list']		 = $list;
            $total_money = $this->getTotalGold($conditions);
            $total_amount = $this->getTotalAmount($conditions);
            $this->view->setVar('realname',$result);
            $this->view->setVar('disList',$lists);
            $this->view->setVar('total_money',$total_money);
            $this->view->setVar('total_amount',$total_amount);
        }elseif ($op == 'display'){
            $sql  ="SELECT uid FROM dhc_distribution_list GROUP BY uid LIMIT $pageoffset,$this->pageSize";
            $userList = $this->db->query($sql)->fetchAll();
            $total_page = count($userList);
            foreach ($userList as $key=>$value){
                $data = $this->channelAmount($value['uid']);
                $userList[$key]['yes'] = $data['yes'];
                $userList[$key]['no'] = $data['no'];
                $userList[$key]['amount']=$this->getAmount($value['uid']);
                $userList[$key]['gold']=$this->getGold($value['uid']);
            }
            $lists['total_pages'] = ceil($total_page['total_pages']/$this->pageSize);
            $lists['next']		 = min($lists['total_pages'],$page+1);
            $lists['before']	 = max($page-1,1);
            $lists['last']		 = $lists['total_pages'];
            $lists['current']	 = $page;
            $lists['list']		 = $userList;
            $this->view->setVar('userList',$lists);
        }
        $this->view->setVar('starttime', date("Y-m-d", $starttime));
        $this->view->setVar('endtime', date("Y-m-d", $endtime));
        $this->view->setVar('show',$op);
        $this->view->setVar('keyword',$keyword);
    }
    //获得某个人的总佣金
    public function getAmount($uid){
        $total = DistributionList::sum(
            [
                'conditions'	=>"uid = '{$uid}'",
                'column'		=>'amount'
            ]
        );
        return $total;
    }
    //获得某个人的总业绩
    public function getGold($uid){
        $total = DistributionList::sum(
            [
                'conditions'	=>"uid = '{$uid}'" ,
                'column'		=>'gold'
            ]
        );
        return $total;
    }
    //获得一定条件的总业绩
    public function getTotalGold($conditions,$uid = ''){
        if (!empty($uid)){
            $conditions .= " AND uid = '{$uid}'";
        }
        $total = DistributionList::findFirst(
            [
                'conditions'=>$conditions,
                'columns'	=>"SUM(gold) as gold"
            ]
        );
        return $total->gold;
    }
    //获得一定条件的总佣金
    public function getTotalAmount($conditions,$uid = ''){
        if (!empty($uid)){
            $conditions .= " AND uid = '{$uid}'";
        }
        $total = DistributionList::findFirst(
            [
                'conditions'=>$conditions,
                'columns'	=>"SUM(amount) as amount"
            ]
        );
        return $total->amount;
    }
    //查询当前可领取业绩
    public function channelAmount($uid){
        //可领取
        $res = DistributionList::findFirst(
            [
                'conditions'=>"uid ='{$uid}'AND status = 0 AND effectTime< ".TIMESTAMP,
                'columns'	=>"SUM(amount) as amount "
            ]
        );
        //不可领取
        $res1 = DistributionList::findFirst(
            [
                'conditions'=>"uid ='{$uid}' AND effectTime> ".TIMESTAMP,
                'columns'	=>"SUM(amount) as amount "
            ]
        );
        $data['yes']= sprintf('%.4f', max(0,$res->amount));
        $data['no'] = sprintf('%.4f', max(0,$res1->amount));
        return $data;
    }

    public function channelAmounts($uid)
    {
        //已领取
        $res = DistributionList::findFirst(
            [
                'conditions' => "uid ='{$uid}'AND status = 1 ",
                'columns' => "SUM(amount) as amount "
            ]
        );
        //未领取
        $res1 = DistributionList::findFirst(
            [
                'conditions' => "uid ='{$uid}' AND status = 0 " ,
                'columns' => "SUM(amount) as amount "
            ]
        );
        $data['yes'] = sprintf('%.4f', max(0, $res->amount));
        $data['no'] = sprintf('%.4f', max(0, $res1->amount));
        return $data;
    }

    public function printAction(){
        $uid  =$this->request->get('uid');
        $data = $this->getSpreadLists($uid);
        if (!empty($uid)){
            $this->view->setVar('uid',$uid);
        }
        if (!empty($data)){
            foreach ($data as $key=>$value){
                foreach ($value as $k=>$v){
                    if ($k == 'id'){
                        $info = $this->channelAmounts($v);
                        $data[$key]['yes'] = $info['yes'];
                        $data[$key]['no'] = $info['no'];
                    }
                }
            }
            $this->view->setVar('channellist',$data);
        }
        foreach ($data as $key=>&$value){
            foreach ($value as $k=>$v){
                if (is_numeric($k)){
                    unset($value[$k]);
                }
            }
        }
        if (!empty($data)){
            $list = [
                'ID','注册时间','推广码','用户帐号','推广级别','可领取','未领取'
            ];
            $this->csv_export($data,$list,'渠道代理推广列表');
        }else{
            exit("<script>alert('暂无');history.go(-1);</script>>");
        }
    }
    function csv_export($data = array(), $headlist = array(), $fileName) {
        header('Content-Type: application/vnd.ms-excel');
        header('Content-Disposition: attachment;filename="'.$fileName.'.csv"');
        header('Cache-Control: max-age=0');

        //打开PHP文件句柄,php://output 表示直接输出到浏览器
        $fp = fopen('php://output', 'a');

        //输出Excel列名信息
        foreach ($headlist as $key => $value) {
            //CSV的Excel支持GBK编码，一定要转换，否则乱码
            $headlist[$key] = iconv('utf-8', 'gbk', $value);
        }
        //将数据通过fputcsv写到文件句柄
        fputcsv($fp, $headlist);

        //计数器
        $num = 0;

        //每隔$limit行，刷新一下输出buffer，不要太大，也不要太小
        $limit = 100000;

        //逐行取出数据，不浪费内存
        $count = count($data);
        for ($i = 0; $i < $count; $i++) {

            $num++;

            //刷新一下输出buffer，防止由于数据过多造成问题
            if ($limit == $num) {
                ob_flush();
                flush();
                $num = 0;
            }
            $row = $data[$i];
            foreach ($row as $key => $value) {
                $row[$key] = iconv('utf-8', 'gbk', $value);
                if ($key == 'createTime'){
                    $row[$key] = date("Y-m-d H:i:s",$row[$key]);
                }
                if ($row[$key] == 'level'){
                    $row[$key] = ($row[$key]+1);
                }
            }
            fputcsv($fp, $row);
        }exit;
    }
    public function getSpreadLists($uid){
        if (!empty($uid)){
            $flag = $this->checkchannel($uid);
            $conditions = "superior REGEXP '^{$uid}-|-{$uid}-'";
            $sql = "SELECT id,createTime,superior,user FROM dhc_user WHERE $conditions ORDER BY createTime DESC  ";
            $spreadUser = $this->db->query($sql)->fetchAll();
            foreach ($spreadUser as $key=>&$value){
                $superior = explode('-',$value['superior']);
                foreach ($superior as $k=>$v){
                    if ($v == $uid){
                        if ($k>=1){
                            if ($k>=2)
                            {
                                $ids[] = $value['id'];
                            }
                            $value['level'] = ($k+1);
                        }else{
                            $value['level'] = ($k+1);
                        }
                    }
                }
            }
            foreach ($spreadUser as $key=>&$val){
                foreach ($val as $k=>$v){
                    if (is_numeric($k)){
                        unset($val[$k]);
                    }
                }
            }
            if (!$flag){
                foreach ($spreadUser as $key=>&$value){
                    foreach ($ids as $k=>$v){
                        if ($v == $value['id']){
                            unset($spreadUser[$key]);
                        }
                    }
                }
            }
            return $spreadUser;

        }
    }

    //在线人数列表
    public function onlineAction(){
        $keyword = $this->request->get('keywords');
        $page = $this->request->get('page');
        if (empty($page)){
            $page = 1;
        }
        $onlineTime = (TIMESTAMP - 180);
        $condition = "logintime > '{$onlineTime}'";
        if (!empty($keyword)){
            $condition .= " AND uid = '{$keyword}' OR user = '{$keyword}'";
        }
        $pageOffset = ($page-1)*$this->pageSize;
        $sql = "SELECT id,uid,user,logintime FROM `dhc_user_log` WHERE $condition LIMIT $pageOffset,$this->pageSize";
        $list =$this->db->query($sql)->fetchAll();
        $sql1 = "SELECT COUNT(id) AS nums FROM `dhc_user_log` WHERE  $condition";
        $total = $this->db->query($sql1)->fetch();
        $lists['total_pages'] = ceil($total['nums']/$this->pageSize);
        $lists['next'] = min($page+1,$lists['total_pages']);
        $lists['before'] = max($page-1,1);
        $lists['last'] =   max($lists['total_pages'],0);
        $lists['current'] = max(intval($page),1);
        $lists['list'] = $list;
        $this->view->setVar('list',$lists);
        $this->view->setVar('keywords',$keyword);
    }
}

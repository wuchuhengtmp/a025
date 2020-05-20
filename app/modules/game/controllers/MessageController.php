<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\Config;
use Dhc\Models\OrchardUser;
use Dhc\Models\OrchardDoubleEffect;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;
/**
 * 发送短信验证
 * @param $data 发送内容
 * @param $to  发送地址
 * return  返回状态
 * Time: 9:36
 */
class MessageController extends ControllerBase{
	public $sendMessage="";

	public function initialize() {
		$this->checkToken();
	}
	/**
	 * 发送post请求
	 * @param string $url 请求地址
	 * @param array $post_data post键值对数据
	 * @return string
	 */
	public function sendAction($mobile,$content){
		if (empty($content)){
			$this->ajaxResponse('error','请求类型错误','1');
		}
		$config = new Config();
		$messageInfo = $config->findFirst("key = 'message'");
		$this->sendMessage = unserialize($messageInfo->value);
		$post_data = array();
		$post_data['userid'] = $this->sendMessage["userid"];
		$post_data['account'] =$this->sendMessage["account"];
		$post_data['password'] = $this->sendMessage["password"];
		$post_data['mobile']	=$mobile;
		$post_data['content']	=$content."【{$this->sendMessage["sign"]}】";
		$url=$this->sendMessage["url"];
		$o='';
		foreach ($post_data as $k=>$v)
		{
			$o.="$k=".urlencode($v).'&';
		}
		$post_data=substr($o,0,-1);
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_HEADER, 0);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_URL,$url);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
		//curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); //Èç¹ûÐèÒª½«½á¹ûÖ±½Ó·µ»Øµ½±äÁ¿Àï£¬ÄÇ¼ÓÉÏÕâ¾ä¡£
		$result = curl_exec($ch);
		$result = $this->xmlToArray($result);
		if ($result['returnstatus'] == "Success") {
			return true;
		} else {
			return $result['message'];
		}
	}
	public function oneAction(){
		$post_data = array();
		$post_data['userid'] = $this->sendMessage["userid"];
		$post_data['account'] = $this->sendMessage["account"];
		$post_data['password'] = $this->sendMessage["password"];
		$url='http://120.24.238.58:8888/sms.aspx?action=overage';
		$o='';
		foreach ($post_data as $k=>$v)
		{
			$o.="$k=".urlencode($v).'&';
		}
		$post_data=substr($o,0,-1);
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_HEADER, 0);
		curl_setopt($ch, CURLOPT_URL,$url);
//		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
//curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); //Èç¹ûÐèÒª½«½á¹ûÖ±½Ó·µ»Øµ½±äÁ¿Àï£¬ÄÇ¼ÓÉÏÕâ¾ä¡£
		$result = curl_exec($ch);

	}
	public function twoAction(){
		$post_data = array();
		$post_data['userid'] = $this->sendMessage["userid"];
		$post_data['account'] = $this->sendMessage["account"];
		$post_data['password'] = $this->sendMessage["password"];
		$url='http://120.24.238.58:8888/sms.aspx?action=overage';
		$o='';
		foreach ($post_data as $k=>$v)
		{
			$o.=urlencode("$k=".$v).'&';
		}
		$post_data=substr($o,0,-1);
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_HEADER, 0);
		curl_setopt($ch, CURLOPT_URL,$url);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
//curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); //Èç¹ûÐèÒª½«½á¹ûÖ±½Ó·µ»Øµ½±äÁ¿Àï£¬ÄÇ¼ÓÉÏÕâ¾ä¡£
		$result = curl_exec($ch);
	}
	private function xmlToArray($xml) {
		//禁止引用外部xml实体
		libxml_disable_entity_loader(true);
		$values = json_decode(json_encode(simplexml_load_string($xml, 'SimpleXMLElement', LIBXML_NOCDATA)), true);
		return $values;
	}

	//消息 通知
	public function getMessageAction(){
		$time1 = time()-10*60;
		$timing = intval($this->request->getPost("timing"));
		if($timing <= 0 || $timing >= time()){
			$timing = 0;
		}
		if(USER_TYPE == "jindao"){
			$this->olineUser($this->userid);
		}
		$time = max($time1,$timing);
		$data = $this->selectDouble($time);
		if(empty($data)){
			$this->ajaxResponse("", "消息空!", 1);
		}
		$this->ajaxResponse($data, "世界消息获取成功!", 0);
	}
	public function getMsgPriceAction(){
        $price=$this->getConfig("msgprice");
        if(!$price){
            $this->ajaxResponse(array("price"=>100), "消息空!", 1);
        }
        $this->ajaxResponse(array("price"=>intval($price)), "世界消息获取成功!", 0);
    }
	public function saveWorldMessageAction()
    {
        if($this->request->isPost()) {
            $model = new OrchardUser();
            $fuser = $model->findFirst("uid='".$this->userid."'");
            $mark="diamonds";
            $this->db->begin();
            $fee=100;
            $price=$this->getConfig("msgprice");
            if($price){
                $fee=intval($price);
            }
            $fuser->diamonds -= $fee;
            $fuser->updatetime = TIMESTAMP;
            $flag = $fuser->update();
            $flag1 = $this->saveOrchardLogs(array("mobile" => $fuser->mobile, "landId" => 0, "types" => "ded".$mark, "nums" => $fee, "msg" => "发送世界消息扣除" . $this->onoTitleInfo()[$mark] . "-".$fee));

            $flag2 = $this->saveDoubleEffect(array("mark" => "0", "types" => 100, "nums" => 0, "msg" => $fuser->nickname.":".$this->request->getPost("msg")));
            if ($flag == false||$flag1 == false||$flag2 == false) {
                $this->db->rollback();
                $this->ajaxResponse("", "发布世界消息失败!", 1);
            }
            $this->db->commit();
            $this->ajaxResponse(array("diamonds" => $fuser->diamonds), '发布世界消息成功！', 0);
        }
    }
    public function listAction()
    {
        $pindex = max(1,$this->request->getPost("page"));
        $doubleEffect = new OrchardDoubleEffect();
        $lists = $doubleEffect->find(array(
            'columns'		=>	'createtime,types,msg',
            'order'			=>	"createtime DESC"
        ));
        $paginator = new PaginatorModel(array("data"	=> $lists,"limit"	=>9,"page" =>$pindex));
        $page = $paginator->getPaginate();
        $list = $this->object2array($page);
        if(!empty($list["items"])){
            foreach ($list["items"] as &$value) {
                $value["time"] = date("Y-m-d H:i:s",$value["createtime"]);
                $t=1;
                if($value["types"]==99)
                {
                    $t=2;
                    $value['msg']="系统：".$value['msg'];
                }
                else if ($value["types"]==100)
                {
                    $t=3;
                }
                $value['type']=$t;
            }
        }
        $data['list'] = $list["items"];
        $data['curPage'] = $list["current"];
        if($list["total_pages"]>0){
            if($list["total_pages"]>100){
                $totalPage = 100;
            }else{
                $totalPage = $list["total_pages"];
            }
        }else{
            $totalPage =1;
        }
        $data['totalPage'] = $totalPage;
        $this->ajaxResponse($data, "世界消息列表",0);
    }
}

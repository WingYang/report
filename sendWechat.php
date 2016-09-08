<?php
	
	header("charset:utf8");

	define('CORPID','wx7d647156f1d39e2b');
	
	define('CORPSECRET','VrvNN6W38TJQgkKgLEsqC6jw3sygak8yoEbVS3ZDNC1LIRzYOGZ4qCEHfWv_MYSN');

	function token($id,$secret){
		$requestUrl = "https://qyapi.weixin.qq.com/cgi-bin/gettoken";
		$parameters = "?corpid={$id}&corpsecret={$secret}";
		$url = $requestUrl.$parameters;
		$ch = curl_init();  
		$timeout = 5;
		curl_setopt ($ch, CURLOPT_URL, $url);  
		curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);  
		curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);  
		$contents = curl_exec($ch);  
		curl_close($ch);
		$result = json_decode($contents,ture);
		return $result["access_token"];
	}

	function json($tagid,$agentid,$title,$description,$url,$picurl){
		$data = array(
			"totag"=>$tagid,
			"agentid"=>$agentid,
			"msgtype"=>"news",
			"news"=>array(
				"articles"=>array(
					array(
						"title"=>$title,
						"description"=>$description,
						"url"=>$url,
						"picurl"=>$picurl
						)
					)
				)
			);
		$news = json_encode($data);
		return $news;
	}

	function sendWechat(){
		$nowdate = date('Y-m-d H:i');
		$token = token(CORPID,CORPSECRET);
		$datas = json("1","4","巡检报告","时间：{$nowdate}","http://www.baidu.com","http://gs.soweredu.com/attachment/topic/578dfc4b220f0.jpg");
		$requestUrl = "https://qyapi.weixin.qq.com/cgi-bin/message/send";
		$parameters = "?access_token={$token}";
		$url = $requestUrl.$parameters;
		$ch = curl_init();  
		$timeout = 5;
		curl_setopt ($ch, CURLOPT_URL, $url);  
		curl_setopt($ch, CURLOPT_POSTFIELDS, $datas);
		curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);  
		curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);  
		$contents = curl_exec($ch);  
		curl_close($ch);
	}

	sendWechat();
?>
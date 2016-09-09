<?php
	
	header("charset:utf8");
	date_default_timezone_set("Asia/Shanghai");
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
		$result = json_decode($contents,true);
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
		$news = json_encode($data,JSON_UNESCAPED_UNICODE);
		return $news;
	}

	function sendWechat(){
		$nowdate = date('Y-m-d H:i');
		$token = token(CORPID,CORPSECRET);
		$datas = json("1","4","巡检报告","时间：{$nowdate}","http://log.soweredu.com?tokenid=DhPwVQJLxc7epKtR","http://log.soweredu.com/images/report.jpg");
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
		echo $contents;die;
	}

	sendWechat();
?>
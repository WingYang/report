<?php
	
	header("charset:utf8");
	date_default_timezone_set("Asia/Shanghai"); 

	function encode($msg){
		$encode = mb_detect_encoding($msg);
		if ($encode=="GB2312"||$encode=="GBK"){
			$message = $msg;
		}
		else{
			$message = iconv("UTF-8", "GB2312//IGNORE", $msg);
		}
		$message = urlencode($message);	
	}

	function sendMsg($msg,$type,$qqnum){
		$ch = curl_init();  
		$timeout = 5;
		$url = "http://api.robot.soweredu.com:8088/?key=INDEXEDU&a=<%26%26>{$type}<%26>{$qqnum}<%26>{$msg}";
		@curl_setopt ($ch, CURLOPT_URL, $url);  
		@curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);  
		@curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);  
		$contents = curl_exec($ch);  
		@curl_close($ch);  
	}

	$nowdate = date("Y-m-d H:i");
	$msg = "巡检报告\n时间：{$nowdate}\n地址：http://test.log.soweredu.com";
	$msg = encode($msg);
	sendMsg($msg,"SendClusterMessage","139965073");
?>
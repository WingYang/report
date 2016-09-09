<?php
	date_default_timezone_set('Asia/Shanghai'); 
	$token = "DhPwVQJLxc7epKtR";
	$value = isset($_GET["token"])?$_GET["token"]:"";
	if($value==$token){
		include("index.html");
	}
	else{
		include("error.html");
	}
?>
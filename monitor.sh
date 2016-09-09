#!/bin/bash
#Author:Wing
#Date:2016,08
#

#定义服务目录
appdir="/data/wwwroot/PHP/report.soweredu.com"
#定义服务器数组
servers=("123.59.142.135" "123.59.142.134" "109.228.17.245" "103.233.250.163" "123.59.72.225" "123.59.77.65" "123.59.72.226" "123.59.72.227" "123.59.71.45" "123.59.77.195" "123.59.149.206" "106.75.8.49" "106.75.193.117" "23.91.98.184" "120.24.15.39" "120.25.95.236" "120.25.243.31" "120.24.4.166")
#定义服务器别名数组
servers_alias=("呼叫中心服务器" "邮件原型服务器" "伦敦服务器" "香港站群服务器" "BI、Offermachine服务器" "BI、Offermachine数据库" "PHP站群服务器" "PPR服务器(Jira、IDE测试)" "通讯中心服务器" "索学网、IDE正式等服务器" "文蓝、美萌网等服务器" "BI通话服务器" "亚太香港服务器(crazyalevel)" "亚太香港服务器(ukweekly.com)" "阿里云PHP服务器01" "阿里云PHP服务器02" "阿里云JAVA服务器01" "阿里云JAVA服务器02")
#定义网站数组
www=("bi.indexedu.com" "www.indexedu.com" "")
#总共的服务器数量
servers_total=${#servers[@]}


#定义检查服务器是否宕机的函数
function run(){
	command="/usr/lib64/nagios/plugins/check_ping -w 100,10% -c 500,80% -H"
	$command $1
}

#定义检查服务器负载函数
function load(){
	command="/usr/lib64/nagios/plugins/check_nrpe -c check_load -H"
	$command $1
}

#定义检查服务器根目录函数
function root(){
	command="/usr/lib64/nagios/plugins/check_nrpe -c check_root -H"
	$command $1
}

#定义检查服务器数据目录函数
function data(){
	command="/usr/lib64/nagios/plugins/check_nrpe -c check_data -H"
	$command $1
}

function www(){
	command="/usr/lib64/nagios/plugins/check_http -H"
	$command $1
}

#定义html页面头部
function header(){
	cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="css/index.css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/index.js"></script>
    <title>巡检报告</title>
</head>
<body>
    <div class="title">
        <h2 align="center">巡检报告</h2>
EOF
    echo  -e "\t<span>时间：<b>`date '+%Y-%m-%d %H:%M'`</b></span>"
    cat <<EOF
    </div>
    <div class="report">
EOF
}

#定义html页面底部
function footer(){
	cat <<EOF
	    </div>
    <div class="bottom">
        <p align="center"><span style="font-family:arial;">Copyright &copy;2016,09 SIETG </span></p>
    </div>
</body>
</html>
EOF
}

#定义检查运行状态函数
function run_state(){
	case `echo $1 | awk '{print $2}'` in
		"OK")
			state="state_o"
			state_msg="OK"
			servers_state="server_o"
			;;
		"WARNING")
			state="state_w"
			state_msg="WARNING"
			servers_state="server_w"
			;;
		"CRITICAL")
			state="state_c"
			state_msg="CRITICAL"
			servers_state="server_c"
			;;
		"UNKNOWN")
			state="state_u"
			state_msg="UNKNOWN"
			servers_state="server_u"
			;;
		*)
			state="state_u"
			state_msg="UNKNOWN"
			servers_state="server_u"
			;;
	esac  
}

#定义检查负载状态函数
function load_state(){
	case `echo $1 | awk '{print $1}'` in
		"OK")
			state="state_o"
			state_msg="OK"
			servers_state="server_o"
			;;
		"WARNING")
			state="state_w"
			state_msg="WARNING"
			servers_state="server_w"
			;;
		"CRITICAL")
			state="state_c"
			state_msg="CRITICAL"
			servers_state="server_c"
			;;
		"UNKNOWN")
			state="state_u"
			state_msg="UNKNOWN"
			servers_state="server_u"
			;;
		*)
			state="state_u"
			state_msg="UNKNOWN"
			servers_state="server_u"
			;;
	esac  
}

#定义检查根分区使用情况函数
function root_state(){
	case `echo $1 | awk '{print $2}'` in
		"OK")
			state="state_o"
			state_msg="OK"
			servers_state="server_o"
			;;
		"WARNING")
			state="state_w"
			state_msg="WARNING"
			servers_state="server_w"
			;;
		"CRITICAL")
			state="state_c"
			state_msg="CRITICAL"
			servers_state="server_c"
			;;
		"UNKNOWN")
			state="state_u"
			state_msg="UNKNOWN"
			servers_state="server_u"
			;;
		*)
			state="state_u"
			state_msg="UNKNOWN"
			servers_state="server_u"
			;;
	esac
}

#定义检查数据分区使用情况函数
function data_state(){
	case `echo $1 | awk '{print $2}'` in
		"OK")
			state="state_o"
			state_msg="OK"
			servers_state="server_o"
			;;
		"WARNING")
			state="state_w"
			state_msg="WARNING"
			servers_state="server_w"
			;;
		"CRITICAL")
			state="state_c"
			state_msg="CRITICAL"
			servers_state="server_c"
			;;
		"UNKNOWN")
			state="state_u"
			state_msg="UNKNOWN"
			servers_state="server_u"
			;;
		*)
			state="state_u"
			state_msg="UNKNOWN"
			servers_state="server_u"
			;;
	esac
}

#定义检查网站是否正常函数
function data_state(){
	case `echo $1 | awk '{print $2}'` in
		"OK")
			state="state_o"
			state_msg="OK"
			servers_state="server_o"
			;;
		"WARNING")
			state="state_w"
			state_msg="WARNING"
			servers_state="server_w"
			;;
		"CRITICAL")
			state="state_c"
			state_msg="CRITICAL"
			servers_state="server_c"
			;;
		"UNKNOWN")
			state="state_u"
			state_msg="UNKNOWN"
			servers_state="server_u"
			;;
		*)
			state="state_u"
			state_msg="UNKNOWN"
			servers_state="server_u"
			;;
	esac
}

#定义html页面服务器运行状态显示函数
function servers_report(){
	cat <<EOF
	<div class="server">
            <p><b>服务器运行状态</b></p>
       		<table>
				<tr>
					<td class="host">Host</td>
                    <td class="alias">Alias</td>
                    <td class="state">Status</td>
                    <td class="detail">Desc</td>
                </tr>
EOF
	for((i=0;i<$servers_total;i++)){
		status=`run ${servers[$i]}`
		run_state "$status"
		echo -e "\t<tr class='server_brief'>
                    <td class='host'>${servers[$i]}</td>
                    <td class='alias'>${servers_alias[$i]}</td>
                    <td class='$state'>$state_msg</td>
                    <td class='detail'><a href='javascript:void(0)''>Click</a></td>
                </tr>
                <tr class='$servers_state'>
                    <td colspan='4'>$status</td>
                </tr>"
	}
	echo -e "\t</table>
        </div>"
}


#定义html页面服务器负载状态显示函数
function load_report(){
	cat <<EOF
	<div class="server">
            <p><b>服务器负载状态</b></p>
       		<table>
				<tr>
					<td class="host">Host</td>
                    <td class="alias">Alias</td>
                    <td class="state">Status</td>
                    <td class="detail">Desc</td>
                </tr>
EOF
	for((i=0;i<$servers_total;i++)){
		status=`load ${servers[$i]}`
		load_state "$status"
		echo -e "\t<tr class='server_brief'>
                    <td class='host'>${servers[$i]}</td>
                    <td class='alias'>${servers_alias[$i]}</td>
                    <td class='$state'>$state_msg</td>
                    <td class='detail'><a href='javascript:void(0)''>Click</a></td>
                </tr>
                <tr class='$servers_state'>
                    <td colspan='4'>$status</td>
                </tr>"
	}
	echo -e "\t</table>
        </div>"
}

#定义html页面服务器根分区使用情况显示函数
function root_report(){
	cat <<EOF
	<div class="server">
            <p><b>服务器根分区使用情况</b></p>
       		<table>
				<tr>
					<td class="host">Host</td>
                    <td class="alias">Alias</td>
                    <td class="state">Status</td>
                    <td class="detail">Desc</td>
                </tr>
EOF
	for((i=0;i<$servers_total;i++)){
		status=`root ${servers[$i]}`
		load_state "$status"
		echo -e "\t<tr class='server_brief'>
                    <td class='host'>${servers[$i]}</td>
                    <td class='alias'>${servers_alias[$i]}</td>
                    <td class='$state'>$state_msg</td>
                    <td class='detail'><a href='javascript:void(0)''>Click</a></td>
                </tr>
                <tr class='$servers_state'>
                    <td colspan='4'>$status</td>
                </tr>"
	}
	echo -e "\t</table>
        </div>"
}

#定义html页面服务器根分区使用情况显示函数
function data_report(){
	cat <<EOF
	<div class="server">
            <p><b>服务器根分区使用情况</b></p>
       		<table>
				<tr>
					<td class="host">Host</td>
                    <td class="alias">Alias</td>
                    <td class="state">Status</td>
                    <td class="detail">Desc</td>
                </tr>
EOF
	for((i=0;i<$servers_total;i++)){
		status=`data ${servers[$i]}`
		load_state "$status"
		echo -e "\t<tr class='server_brief'>
                    <td class='host'>${servers[$i]}</td>
                    <td class='alias'>${servers_alias[$i]}</td>
                    <td class='$state'>$state_msg</td>
                    <td class='detail'><a href='javascript:void(0)''>Click</a></td>
                </tr>
                <tr class='$servers_state'>
                    <td colspan='4'>$status</td>
                </tr>"
	}
	echo -e "\t</table>
        </div>"
}

#定义html页面网站是否正常显示函数
function www_report(){
	cat <<EOF
	<div class="server">
            <p><b>服务器根分区使用情况</b></p>
       		<table>
				<tr>
					<td class="host">Host</td>
                    <td class="alias">Alias</td>
                    <td class="state">Status</td>
                    <td class="detail">Desc</td>
                </tr>
EOF
	for((i=0;i<$servers_total;i++)){
		status=`www ${servers[$i]}`
		www_state "$status"
		echo -e "\t<tr class='server_brief'>
                    <td class='host'>${servers[$i]}</td>
                    <td class='alias'>${servers_alias[$i]}</td>
                    <td class='$state'>$state_msg</td>
                    <td class='detail'><a href='javascript:void(0)''>Click</a></td>
                </tr>
                <tr class='$servers_state'>
                    <td colspan='4'>$status</td>
                </tr>"
	}
	echo -e "\t</table>
        </div>"
}

#发送巡检报告到QQ群
function sendqqmsg(){
	/bin/php ${appdir}/sendQQ.php
}

#发送巡检报告到微信
function sendwechat(){
	/bin/php ${appdir}/sendWechat.php
}
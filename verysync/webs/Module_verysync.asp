<title>软件中心 - VerySync</title>
<content>
<style type="text/css">
input[disabled]:hover{
    cursor:not-allowed;
}
</style>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<script type="text/javascript">
getAppData();
var Apps;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/verysync_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}
if (Apps.verysync_webui == undefined||Apps.verysync_webui == null){
		Apps.verysync_webui = '--';
	}
//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var port =E('_verysync_port').value ;
    if(port < 1024 || port > 65535){
        alert("端口应设置为1024-65535之间");
    }
	return 1;
}
function save(){
	Apps.verysync_enable = E('_verysync_enable').checked ? '1':'0';
	Apps.verysync_wan_enable = E('_verysync_wan_enable').checked ? '1':'0';
	Apps.verysync_port = E('_verysync_port').value;
	//Apps.verysync_sk = E('_verysync_sk').value;
	//left>down>Apps.verysync_up = E('_verysync_up').value;
	//left>down>Apps.verysync_interval = E('_verysync_interval').value;
	//left>down>Apps.verysync_domain = E('_verysync_domain').value;
	//left>down>Apps.verysync_dns = E('_verysync_dns').value;
	//left>down>Apps.verysync_curl = E('_verysync_curl').value;
	//Apps.verysync_ttl = E('_verysync_ttl').value;
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'verysync_config.sh', "params":[], "fields": Apps};
	var success = function(data) {
		//
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 3000);
		//  do someting here.
		//
	};
	var error = function(data) {
		//
		//  do someting here.
		//
	};
	$('#footer-msg').text('保存中……');
	$('#footer-msg').show();
	$('button').addClass('disabled');
	$('button').prop('disabled', true);
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData),
	  success: success,
	  error: error,
	  dataType: "json"
	});
	
	//-------------- post Apps to dbus ---------------
}
</script>
<div class="box">
<div class="heading">VerySync <a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<br><hr>
<div class="content">
<div id="verysync-fields"></div>
<script type="text/javascript">
$('#verysync-fields').forms([
{ title: '开启VerySync', name: 'verysync_enable', type: 'checkbox', value: ((Apps.verysync_enable == '1')? 1:0)},
{ title: '外网访问Web', name: 'verysync_wan_enable', type: 'checkbox', value: ((Apps.verysync_wan_enable == '1')? 1:0)},
//{ title: '运行状态', name: 'verysync_last_act', text: Apps.verysync_last_act ||'--' },
{ title: 'Web访问端口', name: 'verysync_port', type: 'text', maxlen: 5, size: 5, value: Apps.verysync_port || "8886" },
{ title: 'Web控制页面', name: 'verysync_webui', text: '<a style="font-size: 14px;" href="'+Apps.verysync_webui+'" target="_blank">'+Apps.verysync_webui+'</a>' ||'--' },
//{ title: '启动方式', name: 'verysync_up', type: 'select', options:upoption_mode,value:Apps.verysync_up || '2'},
//{ title: '检查周期', name: 'verysync_interval', type: 'text', maxlen: 5, size: 5, value: Apps.verysync_interval || '5',suffix:'分钟(当启动方式为WAN UP时，此选项无效)'},
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
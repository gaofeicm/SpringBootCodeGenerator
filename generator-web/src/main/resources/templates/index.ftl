<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SQL转Java JPA、MYBATIS实现类代码生成平台</title>
    <meta name="keywords" content="sql转实体类,sql转DAO,SQL转service,SQL转JPA实现,SQL转MYBATIS实现">

    <#import "common/common-import.ftl" as netCommon>
    <@netCommon.commonStyle />
    <@netCommon.commonScript />

<script>
    $(function () {
        /**
         * 初始化 table sql 3
         */
        var ddlSqlArea = CodeMirror.fromTextArea(document.getElementById("ddlSqlArea"), {
            lineNumbers: true,
            matchBrackets: true,
            mode: "text/x-sql",
            lineWrapping:false,
            readOnly:false,
            foldGutter: true,
            //keyMap:"sublime",
            gutters:["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
        });
        ddlSqlArea.setSize('auto','auto');
        // controller_ide
        var genCodeArea = CodeMirror.fromTextArea(document.getElementById("genCodeArea"), {
            lineNumbers: true,
            matchBrackets: true,
            mode: "text/x-java",
            lineWrapping:true,
            readOnly:false,
            foldGutter: true,
            //keyMap:"sublime",
            gutters:["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
        });
        genCodeArea.setSize('auto','auto');

        var codeData;

        /**
         * 生成代码
         */
        $('#btnGenCode').click(function ()  {
            var tableSql = ddlSqlArea.getValue();
            $.ajax({
                type: 'POST',
                url: base_url + "/genCode",
                data: {
                    "tableSql": tableSql,
                    "packageName":$("#packageName").val(),
                    "returnUtil":$("#returnUtil").val(),
                    "authorName":$("#authorName").val(),
                    "dataType":$("#dataType").val(),
                    "tinyintTransType":$("#tinyintTransType").val(),
                    "nameCaseType":$("#nameCaseType").val()
                },
                dataType: "json",
                success: function (data) {
                    if (data.code == 200) {
                        codeData = data.data;
                        genCodeArea.setValue(codeData.beetlentity);
                        genCodeArea.setSize('auto', 'auto');
                        $.toast("√ 代码生成成功");
                    } else {
                        $.toast("× 代码生成失败 :"+data.msg);
                    }
                }
            });
        });
        /**
         * 按钮事件组
         */
        $('.generator').bind('click', function () {
            if (!$.isEmptyObject(codeData)) {
                var id = this.id;
                genCodeArea.setValue(codeData[id]);
                genCodeArea.setSize('auto', 'auto');
            }
        });
        /**
         * 捐赠
         */
        function donate(){
            if($("#donate").attr("show")=="no"){
                $("#donate").html('<img src="https://www.gaofeicm.cn/assets/images/donate.png"></img>');
                $("#donate").attr("show","yes");
            }else{
                $("#donate").html('<p>谢谢赞赏！</p>');
                $("#donate").attr("show","no");
            }
        }
        $('#donate1').on('click', function(){
            donate();
        });
        $('#donate2').on('click', function(){
            donate();
        });
        $('#btnCopy').on('click', function(){
            if(!$.isEmptyObject(genCodeArea.getValue())&&!$.isEmptyObject(navigator)&&!$.isEmptyObject(navigator.clipboard)){
                navigator.clipboard.writeText(genCodeArea.getValue());
                $.toast("√ 复制成功");
            }
        });
        $('#ddlSqlArea').next().css("border-radius", "15px");
        $('#genCodeArea').next().css("border-radius", "12px");
        var ddlSql = "CREATE TABLE 'user_info' ( \n" + 
				  "    'user_id' int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',\n" +
				  "    'user_name' varchar(255) NOT NULL COMMENT '用户名',\n" +
				  "    'add_time' datetime NOT NULL COMMENT '创建时间',\n" +
				  "    PRIMARY KEY ('user_id')\n" +
				") ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息'";
        ddlSqlArea.setValue(ddlSql);
    });
</script>
</head>
<body style="background-color: #e9ecef">

    <div class="container">
        <nav class="navbar-dark bg-primary btn-lg" style="text-align: center;margin-top: 5px;">
            <span style="color: white;">Spring Boot Code Generator</span>
        </nav>
    </div>
<!-- Main jumbotron for a primary marketing message or call to action -->
	<div style="padding: 15px 0px 5px 0px;">
	    <div class="container">
	        <div class="input-group mb-3">
	            <div class="input-group-prepend">
	                <span class="input-group-text">作者名称</span>
	            </div>
	            <input type="text" class="form-control" id="authorName" name="authorName" value="gaofeicm">
	            <div class="input-group-prepend">
	                <span class="input-group-text">返回封装</span>
	            </div>
	            <input type="text" class="form-control" id="returnUtil" name="returnUtil" value="Result">
	            <div class="input-group-prepend">
	                <span class="input-group-text">包名路径</span>
	            </div>
	            <input type="text" class="form-control" id="packageName" name="packageName" value="scms.dataSvc">
	        </div>
	        <div class="input-group mb-3">
	            <div class="input-group-prepend">
	                <span class="input-group-text">数据类型</span>
	            </div>
	            <select type="text" class="form-control" id="dataType"
	                    name="dataType">
	                <option value="sql">sql</option>
	                <option value="json">json</option>
	                <option value="sql-regex">sql-regex</option>
	            </select>
	            <div class="input-group-prepend">
	                <span class="input-group-text">tinyint转换类型</span>
	            </div>
	            <select type="text" class="form-control" id="tinyintTransType"
	                    name="tinyintTransType">
	                <option value="Integer">Integer</option>
	                <option value="int">int</option>
	                <option value="boolean">boolean</option>
	                <option value="Boolean">Boolean</option>
	                <option value="String">String</option>
	            </select>
	            <div class="input-group-prepend">
	                <span class="input-group-text">命名转换规则</span>
	            </div>
	            <select type="text" class="form-control" id="nameCaseType"
	                    name="nameCaseType">
	                <option value="CamelCase">驼峰</option>
	                <option value="UnderScoreCase">下划线</option>
	                <#--<option value="UpperUnderScoreCase">大写下划线</option>-->
	            </select>
	        </div>
	        <textarea id="ddlSqlArea" placeholder="请输入表结构信息..." class="form-control btn-lg" style="height: 250px;"></textarea>
	        <br>
	        <p>
	        	<button class="btn btn-primary btn-md" id="btnGenCode" role="button" data-toggle="popover" data-content="">开始生成 »</button>
	        	<button class="btn btn-primary btn-md alert-secondary" id="btnCopy">一键复制</button>
	        </p>
	        <hr>
	        <!-- Example row of columns -->
	        <div class="row" style="margin-top: 10px;">
	            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
	                <div class="input-group">
	                    <div class="input-group-prepend">
	                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">通用实体</div>
	                    </div>
	                </div>
	                <div class="btn-group" role="group" aria-label="First group">
	                    <button type="button" class="btn btn-default generator" id="model">entity(set/get)</button>
	                    <button type="button" class="btn btn-default generator" id="beetlentity">entity(lombok)</button>
	                </div>
	            </div>
	            <div class="btn-toolbar col-md-7" role="toolbar" aria-label="Toolbar with button groups">
	                <div class="input-group">
	                    <div class="input-group-prepend">
	                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">Mybatis</div>
	                    </div>
	                </div>
	                <div class="btn-group" role="group" aria-label="First group">
	                    <button type="button" class="btn btn-default generator" id="mybatis">mybatis</button>
	                    <button type="button" class="btn btn-default generator" id="mapper">mapper</button>
	                    <button type="button" class="btn btn-default generator" id="service">service</button>
	                    <button type="button" class="btn btn-default generator" id="service_impl">service_impl</button>
	                    <button type="button" class="btn btn-default generator" id="controller">controller</button>
	                </div>
	            </div>
	        </div>
	        <!-- Example row of columns -->
	        <div class="row" style="margin-top: 10px;">
	            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
	                <div class="input-group">
	                    <div class="input-group-prepend">
	                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">MybatisPlus</div>
	                    </div>
	                </div>
	                <div class="btn-group" role="group" aria-label="First group">
	                    <button type="button" class="btn btn-default generator" id="plusmapper">mapper</button>
	                    <button type="button" class="btn btn-default generator" id="pluscontroller">controller</button>
	                </div>
	            </div>

	            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
	                <div class="input-group">
	                    <div class="input-group-prepend">
	                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">UI</div>
	                    </div>
	                </div>
	                <div class="btn-group" role="group" aria-label="First group">
	                    <button type="button" class="btn btn-default generator" id="swagger-ui">swagger-ui</button>
	                    <button type="button" class="btn btn-default generator" id="element-ui">element-ui</button>
	                    <button type="button" class="btn btn-default generator" id="bootstrap-ui">bootstrap-ui</button>
	                </div>
	            </div>
	        </div>

	        <div class="row" style="margin-top: 10px;">
	            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
	                <div class="input-group">
	                    <div class="input-group-prepend">
	                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">BeetlSQL</div>
	                    </div>
	                </div>
	                <div class="btn-group" role="group" aria-label="First group">
	                    <button type="button" class="btn btn-default generator" id="beetlmd">beetlmd</button>
	                    <button type="button" class="btn btn-default generator" id="beetlcontroller">beetlcontroller</button>
	                </div>
	            </div>
	            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
	                <div class="input-group">
	                    <div class="input-group-prepend">
	                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">JPA</div>
	                    </div>
	                </div>
	                <div class="btn-group" role="group" aria-label="First group">
	                    <button type="button" class="btn btn-default generator" id="entity">jpa-entity</button>
	                    <button type="button" class="btn btn-default generator" id="repository">repository</button>
	                    <button type="button" class="btn btn-default generator" id="jpacontroller">controller</button>
	                </div>
	            </div>
	        </div>
	        <div class="row" style="margin-top: 10px;">
	            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
	                <div class="input-group">
	                    <div class="input-group-prepend">
	                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">JdbcTemplate</div>
	                    </div>
	                </div>
	                <div class="btn-group" role="group" aria-label="First group">
	                    <button type="button" class="btn btn-default generator" id="jtdaoimpl">daoimpl</button>
	                    <button type="button" class="btn btn-default generator" id="jtdao">dao</button>
	                </div>
	            </div>
	            <div class="btn-toolbar col-md-7" role="toolbar" aria-label="Toolbar with button groups">
	                <div class="input-group">
	                    <div class="input-group-prepend">
	                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">SQL</div>
	                    </div>
	                </div>
	                <div class="btn-group" role="group" aria-label="First group">
	                    <button type="button" class="btn btn-default generator" id="select">select</button>
	                    <button type="button" class="btn btn-default generator" id="insert">insert</button>
	                    <button type="button" class="btn btn-default generator" id="update">update</button>
	                    <button type="button" class="btn btn-default generator" id="delete">delete</button>
	                </div>
	            </div>
	        </div>
	        <div class="row" style="margin-top: 10px;">
	            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
	                <div class="input-group">
	                    <div class="input-group-prepend">
	                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">DTO</div>
	                    </div>
	                </div>
	                <div class="btn-group" role="group" aria-label="First group">
	                    <button type="button" class="btn btn-default generator" id="beetlentitydto">entitydto(lombok+swagger)</button>
	                </div>
	            </div>
	            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
	                <div class="input-group">
	                    <div class="input-group-prepend">
	                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">Util</div>
	                    </div>
	                </div>
	                <div class="btn-group" role="group" aria-label="First group">
	                    <button type="button" class="btn btn-default generator" id="util">bean get set</button>
	                    <button type="button" class="btn btn-default generator" id="json">json</button>
	                    <button type="button" class="btn btn-default generator" id="xml">xml</button>
	                </div>
	            </div>
	        </div>
	        <hr>
	        <textarea id="genCodeArea" class="form-control btn-lg" ></textarea>
	    </div>
	</div>
    <@netCommon.commonFooter />
</body>
</html>

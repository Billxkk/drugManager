<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="beans.Staff" %><%--
  Created by IntelliJ IDEA.
  User: beauw
  Date: 2018/1/8
  Time: 12:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>管理员后台管理</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/master.css">
    <style type="text/css">
        ul.nav li:nth-child(3) a{
            background-color: #a89b9b;
            color: #f8f8f8;
        }
        .loginTitle {
            text-align: center;
            font-weight: bold;
            font-size: 22px;
        }
        .mycontainer {
            padding-top: 0;
            margin-left: -20%;
        }
    </style>
</head>
<body>
<!-- 顶部状态栏 -->
<div class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <a href="" class="navbar-brand">药品后台管理</a>
        </div>

        <p class="navbar-text">当前登录用户</p>
        <p class="navbar-text">
            <%
                Staff staff = (Staff) session.getAttribute("staff");
                out.println(staff.getName());
            %>
        </p>
        <p class="navbar-text navbar-right"></p>
        <a href="managermaster?id=11" type="button" class="btn btn-default navbar-btn navbar-right">退出</a>    </div>
</div>
<!-- 左侧导航 -->
<div class="navbox">
    <ul class="nav">
        <li><a href="managetrim?id=1">管理主页</a></li>
        <li><a href="managetrim?id=2">药品管理</a></li>
        <li><a href="managetrim?id=3">添加药品</a></li>
    </ul>
</div>
<!-- 右侧数据显示区 -->
<div class="mainArea">
    <div class="showArea">
        <div class="container">
            <form action="adddrug" class="col-md-6 col-md-offset-3" method="post">
                <fieldset class="mycontainer">
                    <legend></legend>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <p class="loginTitle">添加药品</p>
                        </div>
                        <div class="panel-body">

                            <div class="form-group">
                                <div class="input-group">
									<span class="input-group-addon">
										药品ID</span>
                                    <input type="text" name="drugid" class="form-control" placeholder="请输入药品ID">
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="input-group">
									<span class="input-group-addon">
										药名
									</span>
                                    <input type="text" name="drugname" class="form-control" placeholder="请输入药名" id="userName" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="input-group">
									<span class="input-group-addon">
										种类ID
									</span>
                                    <input type="text" name="drugtype" class="form-control" placeholder="请输入种类ID" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="input-group">
									<span class="input-group-addon">
										进价
									</span>
                                    <input type="text" name="buyprice" class="form-control" placeholder="请输入进价" required>
                                </div>
                            </div>


                            <div class="form-group">
                                <div class="input-group">
									<span class="input-group-addon">
										售价
									</span>
                                    <input type="text" name="saleprice" class="form-control" placeholder="请输入售价" required>
                                </div>
                            </div>


                            <div class="form-group">
                                <div class="input-group">
									<span class="input-group-addon">
										生产商ID
									</span>
                                    <input type="text" name="producerid" class="form-control"  placeholder="请输入生产商ID" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <input type="submit" name="login" class="btn btn-primary col-xs-2" id="userLogin" value="确定">
                                <input type="reset" name="cancel" class="btn btn-warning col-xs-2 col-xs-push-8" id="userCancel" value="取消">

                            </div>
                        </div>
                    </div>
                </fieldset>
            </form>
        </div>
    </div>
</div>

<script src="bootstrap/js/jquery.min.js" charset="utf-8"></script>
<script src="bootstrap/js/bootstrap.min.js" charset="utf-8"></script>

</body>
</html>

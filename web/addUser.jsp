<%@ page import="beans.Staff" %>
<%@ page import="utils.createStaffId" %>
<%--
  Created by IntelliJ IDEA.
  User: beauw
  Date: 2018/1/6
  Time: 12:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>添加员工页面</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/master.css">
    <style type="text/css">
        ul.nav li:nth-child(2) a{
            background-color: #a89b9b;
            color: #f8f8f8;
        }
        .loginTitle {
            text-align: center;
            font-weight: bold;
            font-size: 22px;
        }
        .mycontainer {
            padding-top: 0%;
            margin-left: -20%;
        }
        #userId {
            display: none;
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
        <li><a href="managermaster?id=1">管理主页</a></li>
        <li><a href="managermaster?id=2">员工管理</a></li>
        <li><a href="managermaster?id=3">查看库存</a></li>
        <li><a href="managermaster?id=4">查看进货</a></li>
        <li><a href="managermaster?id=5">查看售货</a></li>
        <li><a href="managermaster?id=6">查看退厂</a></li>
        <li><a href="managermaster?id=7">查看客户</a></li>
        <li><a href="managermaster?id=8">查看厂商</a></li>
    </ul>
</div>

<div class="mainArea">
    <div class="showArea">
        <div class="container">
            <form action="adduser" class="col-md-6 col-md-offset-3" method="post">
                <fieldset class="mycontainer">
                    <legend></legend>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <p class="loginTitle">添加用户</p>
                        </div>
                        <div class="panel-body">

                            <div class="form-group">
                                <div class="input-group">
									<span class="input-group-addon">
										用户ID</span>
                                    <input type="text" name="userid" class="form-control" value=<%= createStaffId.getStaffId()%> id="userId">
                                    <input type="text" name="userid1" class="form-control" value=<%= createStaffId.getStaffId()%> id="userId1" disabled>
                                </div>
                            </div>



                            <div class="form-group">
                                <div class="input-group">
									<span class="input-group-addon">
										姓名
									</span>
                                    <input type="text" name="username" class="form-control" placeholder="请输入用户名" id="userName" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="input-group">
									<span class="input-group-addon">
										密码
									</span>
                                    <input type="text" name="userpwd" class="form-control" placeholder="请输入密码" id="userPwd" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="input-group">
									<span class="input-group-addon">
										电话
									</span>
                                    <input type="text" name="userphone" class="form-control" placeholder="请输入用户电话" id="userPhone" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <select class="form-control" name="myformcontrol" id="myformcontrol">
                                    <option selected>管理员</option>
                                    <option>药品整理员</option>
                                    <option>售货员</option>
                                    <option>进货员</option>
                                    <option>退货员</option>
                                </select>
                            </div>

                            <%--记得将来将领导ID改成选择框，选择领导名称--%>

                            <div class="form-group">
                                <div class="input-group">
									<span class="input-group-addon">
										领导ID
									</span>
                                    <input type="text" name="userLeaderId" class="form-control"  placeholder="请输入领导ID" id="userLeaderId" required>
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

<%@ page import="beans.Staff" %>
<%@ page import="beans.Customer" %><%--
  Created by IntelliJ IDEA.
  User: DL
  Date: 2018/1/9
  Time: 0:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>修改客户信息</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/master.css">
    <style type="text/css">
        ul.nav li:nth-child(6) a{
            background-color: #a89b9b;
            color: #f8f8f8;
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
        <li><a href="managesale?id=0">销售主页</a></li>
        <li><a href="managesale?id=1">修改资料</a></li>
        <li><a href="managesale?id=2">售货</a></li>
        <li><a href="managesale?id=3">查看客户</a></li>
        <li><a href="managesale?id=4">添加客户</a></li>
        <li><a href="managesale?id=5">修改客户</a></li>
    </ul>
</div>
<!-- 右侧数据显示区 -->
<div class="mainArea">
    <div class="showArea">
        <div class="jumbotron myjumbotron">
            <form class="form-horizontal" action="updateCustomInfo">
                <div class="form-group form-group-lg">
                    <%
                        Customer customer=(Customer) request.getAttribute("Customer");
                        session.setAttribute("ID",customer.getCustomerID());
                    %>
                    <label class="col-sm-4 control-label"><%=customer.getCustomerName()%>资料</label>
                </div>
                <div class="form-group">
                    <label for="inputName" class="col-sm-2 control-label">名称</label>
                    <div class="col-sm-5">
                        <input type="text" class="form-control" id="inputName" name="Name" value=<%=customer.getCustomerName()%>>
                    </div>
                </div>
                <div class="form-group">
                    <label for="inputPhone" class="col-sm-2 control-label">电话</label>
                    <div class="col-sm-5">
                        <input type="text" class="form-control" id="inputPhone" name="Phone" value=<%=customer.getCustomerPhone()%>>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <p>
                            <button type="submit" class="btn btn-primary btn-sm">提交</button>
                            <button type="reset" class="btn btn-default btn-sm">重置</button>
                        </p>
                    </div>
                </div>
            </form>
        </div>

    </div>
</div>
<script src="bootstrap/js/jquery.min.js" charset="utf-8"></script>
<script src="bootstrap/js/bootstrap.min.js" charset="utf-8"></script>
</body>
</html>

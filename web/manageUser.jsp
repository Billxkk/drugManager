<%@ page import="beans.Staff" %>
<%@ page import="java.util.List" %>
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
    <title>员工管理页面</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/master.css">
    <style type="text/css">
        ul.nav li:nth-child(2) a{
            background-color: #a89b9b;
            color: #f8f8f8;
        }
        .yourcontainer{
            padding-bottom: 20px;
        }
    </style>
</head>
<body>
<!-- 顶部状态栏 -->
<div class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <a href="#" class="navbar-brand">药品后台管理</a>
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

        <div class="yourcontainer">
            <a href="managermaster?id=10" class="btn btn-primary">添加员工</a>
        </div>

        <table class="table table-bordered table-striped">
            <tr>
                <th>序号</th>
                <th>员工ID</th>
                <th>姓名</th>
                <th>密码</th>
                <th>电话</th>
                <th>职位</th>
                <th>领导ID</th>
                <th>修改</th>
                <th>删除</th>
            </tr>

            <%
                List<Staff> list = (List<Staff>) session.getAttribute("stafflist");
                int i = 1;
                for (Staff mystaff:list) {
            %>
                <tr>
                    <td><%= i %></td>
                    <td><%= mystaff.getID()%></td>
                    <td><%= mystaff.getName()%></td>
                    <td><%=mystaff.getPsd() %></td>
                    <td><%= mystaff.getPhone()%></td>
                    <td><%= mystaff.getPosition()%></td>
                    <td><%= mystaff.getLeaderID()%></td>
                    <td>
                        <a href="updateuser?staffID=<%=mystaff.getID()%>" type="button" class="btn btn-info btn-xs btn-block">修改</a>
                    </td>
                    <td>
                        <a href="deleteuser?staffID=<%=mystaff.getID()%>" type="button" class="btn btn-danger btn-xs btn-block">删除</a>
                    </td>
                </tr>

            <%
                    i++;
                }
            %>

        </table>

    </div>
</div>



<script src="bootstrap/js/jquery.min.js" charset="utf-8"></script>
<script src="bootstrap/js/bootstrap.min.js" charset="utf-8"></script>

</body>
</html>

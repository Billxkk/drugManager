<%@ page import="beans.Staff" %>
<%@ page import="beans.BuyBillDetail" %>
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
    <title>进货单详细页面</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/master.css">
    <style type="text/css">
        ul.nav li:nth-child(4) a{
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
        <table class="table table-bordered table-striped" id="t_customer">
            <tr>
                <th>序号</th>
                <th>进货单ID</th>
                <th>药品ID</th>
                <th>药品名称</th>
                <th>数量</th>
                <th>进价</th>
                <th>生产日期</th>
            </tr>
            <%
                List<BuyBillDetail> list = (List<BuyBillDetail>) session.getAttribute("bdelist");
                int i = 1;
                for (BuyBillDetail mybdtail:list) {
            %>
            <tr>
                <td><%= i++ %></td>
                <td><%= mybdtail.getBuyBillID() %></td>
                <td><%= mybdtail.getDrugID()%></td>
                <td><%= mybdtail.getBuyBillName()%></td>
                <td><%= mybdtail.getNumber()%></td>
                <td><%=mybdtail.getBuyPrice() %></td>
                <td><%=mybdtail.getDate() %></td>
            </tr>
            <%
                }
            %>
        </table>
    </div>
</div>

<script src="bootstrap/js/jquery.min.js" charset="utf-8"></script>
<script src="bootstrap/js/bootstrap.min.js" charset="utf-8"></script>

</body>
</html>

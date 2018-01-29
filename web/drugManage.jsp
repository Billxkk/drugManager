<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="beans.Staff" %>
<%@ page import="java.util.List" %>
<%@ page import="beans.Drug" %><%--
  Created by IntelliJ IDEA.
  User: beauw
  Date: 2018/1/8
  Time: 12:43
  To change this template use File | Settings | File Templates.

  药品管理员-->药品整理页
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>管理员后台管理</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/master.css">
    <style type="text/css">
        ul.nav li:nth-child(2) a{
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
        <li><a href="managetrim?id=1">管理主页</a></li>
        <li><a href="managetrim?id=2">药品管理</a></li>
        <li><a href="managetrim?id=3">添加药品</a></li>
    </ul>
</div>
<!-- 右侧数据显示区 -->
<div class="mainArea">
    <div class="showArea">

        <form class="form-inline text-center" action="searchdrug">
            <div class="form-group">
                <label for="exampleInputName2">输入查询</label>
                <input type="text" class="form-control" id="exampleInputName2" name="search" placeholder="请在此处输入">
            </div>
            <label class="radio-inline">
                <input type="radio" name="inlineRadioOptions" id="inlineRadio1" value="option1" checked> 根据药名
            </label>
            <label class="radio-inline">
                <input type="radio" name="inlineRadioOptions" id="inlineRadio2" value="option2"> 根据ID
            </label>
            <button type="submit" class="btn btn-primary">搜索</button>
        </form>

        <table class="table table-bordered table-striped">
            <tr>
                <th>序号</th>
                <th>药品ID</th>
                <th>药名</th>
                <th>种类名称</th>
                <th>进价</th>
                <th>售价</th>
                <th>生产商</th>
                <th>删除</th>
            </tr>

            <%
                List<Drug> list = (List<Drug>) session.getAttribute("druglist");
                int i = 1;
                for (Drug mydrug:list) {
            %>
            <tr>
                <td><%= i %></td>
                <td><%= mydrug.getDrugID()%></td>
                <td><%= mydrug.getDrugName()%></td>
                <td><%= mydrug.getTypeName() %></td>
                <td><%= String.format("%.2f", mydrug.getBuyPrice())%></td>
                <td><%= String.format("%.2f", mydrug.getSalePrice())%></td>
                <td><%= mydrug.getProduceName()%></td>
                <td>
                    <a href="deletedrug?drugID=<%=mydrug.getDrugID()%>" type="button" class="btn btn-danger btn-xs btn-block">删除</a>
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

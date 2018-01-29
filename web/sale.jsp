<%@ page import="beans.Staff" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="beans.MedicineTable" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: DL
  Date: 2018/1/6
  Time: 13:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>售货</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/master.css">
    <style type="text/css">
        ul.nav li:nth-child(3) a{
            background-color: #a89b9b;
            color: #f8f8f8;
        }
        #myid {
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
        <p class="navbar-text"><%
            Staff staff = (Staff) session.getAttribute("staff");
            out.println(staff.getName());
        %></p>

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
        <form class="form-horizontal" action="saleAdd">
            <!--<div class="form-group">
                <label for="inputbuyID" class="col-sm-2 control-label">进货单ID</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="inputbuyID" name="buyID" >
                </div>
            </div>-->
            <div class="form-group">
                <label for="inputproduceID" class="col-sm-3 control-label">客户ID</label>
                <div class="col-sm-3">
                    <input readonly type="text" class="form-control" id="inputproduceID" value="<%=request.getAttribute("Cid")%>" name="customID">
                </div>
                <label for="inputbuyerID" class="col-sm-1 control-label">售货员ID</label>
                <div class="col-sm-3">
                    <input readonly type="text" class="form-control" id="inputbuyerID" name="salerID" value="<%=staff.getID()%>">
                </div>
            </div>

            <table class="table table-striped">
                <tr>
                    <th class="text-center">药品ID</th>
                    <th class="text-center">药品名</th>
                    <th class="text-center">库存剩余</th>
                    <th class="text-center">卖出数量</th>
                    <th class="text-center">种类</th>
                </tr>
                <%
                    List<MedicineTable> medicineTables=(List<MedicineTable>) request.getAttribute("AllMedicine");
                    int i=0;
                    for (MedicineTable medicineTable :medicineTables) {
                %>
                <tr>
                    <td><input readonly type="text" class="form-control" name="drugID<%=++i%>" value="<%=medicineTable.getYpid()%>"></td>
                    <td><input readonly type="text" class="form-control" name="drugName<%=i%>" value="<%=medicineTable.getYpmz()%>"></td>
                    <td><input readonly type="text" class="form-control" name="kcsy<%=i%>" value="<%=medicineTable.getKcsy()%>"></td>
                    <td><input type="text" class="form-control" name="num<%=i%>" value=""></td>
                    <td><input readonly type="text" class="form-control" name="type<%=i%>" value="<%=medicineTable.getType()%>"></td>
                </tr>
                <%
                    }
                %>
                <input type="text" name="i"  id="myid" value=<%=i%> >
            </table>

            <div class="form-group text-center">
                <div class="col-sm-3">
                </div>
                <div class="col-sm-2">
                    <button type="submit" class="btn btn-primary btn-block">提交</button>
                </div>
                <div class="col-sm-1">
                </div>
                <div class="col-sm-2">
                    <button type="reset" class="btn btn-warning btn-block">重置</button>
                </div>
            </div>
        </form>
    </div>
</div>







<script src="bootstrap/js/jquery.min.js" charset="utf-8"></script>
<script src="bootstrap/js/bootstrap.min.js" charset="utf-8"></script>
</body>
</html>

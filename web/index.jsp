<%--
  Created by IntelliJ IDEA.
  User: bill xu
  Date: 2017/12/23
  Time: 下午 4:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
  <head>
    <title>登录页面</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/login.css">
  </head>
  <body>
  <div class="container">
    <form action="login" class="col-md-6 col-md-offset-3" method="post">
      <fieldset class="mycontainer">
        <legend></legend>
        <div class="panel panel-default">
          <div class="panel-heading">
            <p class="loginTitle">欢迎登录药品管理系统</p>
          </div>
          <div class="panel-body">

            <div class="form-group">
              <div class="input-group">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-user"></span></span>
                <input type="text" name="userid" class="form-control" placeholder="请输入用户ID" id="userId" required>
              </div>
            </div>


            <div class="form-group">
              <div class="input-group">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-lock"></span>
									</span>
                <input type="password" name="userpwd" class="form-control" placeholder="请输入密码" id="userPwd" required>
              </div>
            </div>



            <div class="form-group">
              <select class="form-control" id="myformcontrol" name="userpos">
                <option selected>管理员</option>
                <option>药品整理员</option>
                <option>进货员</option>
                <option>售货员</option>
                <option>退货员</option>
              </select>
            </div>

            <div class="form-group" id="alertTitle">
            </div>

            <div class="form-group">
              <input type="submit" name="login" class="btn btn-primary col-xs-2" id="userLogin" value="登录">
              <input type="reset" name="cancel" class="btn btn-warning col-xs-2 col-xs-push-8" id="userCancel">

            </div>
          </div>
        </div>
      </fieldset>
    </form>
  </div>
  <script src="bootstrap/js/jquery.min.js" charset="utf-8"></script>
  <script src="bootstrap/js/bootstrap.min.js" charset="utf-8"></script>
  <script>

      <%
         String lose = (String) session.getAttribute("lose");
         out.println(lose);
      %>
    $(function () {
      if(<%= lose%>){
            $("#alertTitle").prepend('<div id="myAlert" class="alert alert-warning"><a href="#" class="close" data-dismiss="alert">&times;</a><strong>警告！</strong>您的用户名或密码或职位输入错误。</div>');
            $("#myAlert").alert();
            $(".close").click(function(){
                $("#myAlert").alert('close');
            });
        }
    });
  </script>
  </body>
</html>

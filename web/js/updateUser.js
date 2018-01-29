$(function () {
    var str = $("#myformcontrol").val();
    if (str == "管理员"){
        var String =
            "<option>药品整理员</option>\n" +
            "<option>售货员</option>\n" +
            "<option>进货员</option>\n" +
            "<option>退货员</option>";
        $("#myformcontrol").append(String);
    }
    else if (str == "药品整理员") {
        var String =
            "<option>管理员</option>\n" +
            "<option>售货员</option>\n" +
            "<option>进货员</option>\n" +
            "<option>退货员</option>";
        $("#myformcontrol").append(String);
    }
    else if (str == "售货员") {
        var String =
            "<option>管理员</option>\n" +
            "<option>药品整理员</option>\n" +
            "<option>进货员</option>\n" +
            "<option>退货员</option>";
        $("#myformcontrol").append(String);
    }
    else if (str == "进货员") {
        var String =
            "<option>管理员</option>\n" +
            "<option>售货员</option>\n" +
            "<option>药品整理员</option>\n" +
            "<option>退货员</option>";
        $("#myformcontrol").append(String);
    }
    else if (str == "退货员") {
        var String =
            "<option>管理员</option>\n" +
            "<option>售货员</option>\n" +
            "<option>进货员</option>\n" +
            "<option>药品整理员</option>";
        $("#myformcontrol").append(String);
    }

})
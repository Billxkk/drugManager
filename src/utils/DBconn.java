package utils;

import java.sql.Connection;
import java.sql.DriverManager;

import static utils.Constant.*;

/**
 * Created by bill xu on 2018/1/5.
 * 数据库连接类
 */
public class DBconn {
    private static Connection conn = null;

    //单例模式
    private static class LazyHolder {
        private static final Connection INSTANCE =  Connection("shujuku","123456");
    }
    private static class LazyHolderDrugManager {
        private static final Connection INSTANCE =  Connection("drugmanager","drugmanager");
    }
    private static class LazyHolderSaler {
        private static final Connection INSTANCE =  Connection("saler","saler");
    }
    private static class LazyHolderBuyer {
        private static final Connection INSTANCE =  Connection("buyer","buyer");
    }
    private static class LazyHolderReturnGooder {
        private static final Connection INSTANCE =  Connection("returngooder","returngooder");
    }
    /**
     * 返回 数据库连接 Connection 管理员权限
     * @return sql连接
     */
    public static  Connection getConnInstance() {
        return LazyHolder.INSTANCE;
    }
    /**
     * 根据输入权限返回相应的 connection
     * @param power 权限的String
     * @return sql连接
     */
    public static Connection getConnInstance(String power){
        switch (power) {
            case Administrator:
                return LazyHolder.INSTANCE;
            case drugManager:
                return LazyHolderDrugManager.INSTANCE;
            case saler:
                return LazyHolderSaler.INSTANCE;
            case buyer:
                return LazyHolderBuyer.INSTANCE;
            case returnGooder:
                return LazyHolderReturnGooder.INSTANCE;
            default:
                return null;
        }
    }

    private static Connection Connection(String user,String Psd){
        // Create a variable for the connection string.
        String DataBaseName = "drugmanager";

//        String user = "shujuku";  //数据库用户名
//        String Psd = "123456";    //数据库密码

        String url = "jdbc:sqlserver://127.0.0.1:1433;databaseName="+DataBaseName+
                ";user="+user+";password="+Psd;//sa身份连接
        // TODO: 2018/1/5 数据库登录名为管理员权限 ，可考虑添加不同登录名对应不同的用户权限
        // Declare the JDBC objects.
        try {
            // Establish the connection.
            System.out.println("begin.");
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(url);
            System.out.println("数据库连接成功！！！");
            System.out.println("end.");

            return conn;

//            Statement stmt = null;
//            ResultSet rs = null;
//
//            // Create and execute an SQL statement that returns some data.
//            String SQL = "SELECT  * FROM 员工";
//            stmt = conn.createStatement();
//            rs = stmt.executeQuery(SQL);
//
//            // Iterate through the data in the result set and display it.
//            while (rs.next()) {
//                System.out.println(rs.getString(1) + " " + rs.getString(2));
//            }

        }
        // Handle any errors that may have occurred.
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}

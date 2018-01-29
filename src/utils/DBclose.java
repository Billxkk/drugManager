package utils;

import java.sql.*;

public class DBclose {
    /**
     * 关闭流
     * @param resultSet
     * @param statement
     * @param connection
     * @param preparedStatement
     */
    public static void close(ResultSet resultSet, Statement statement, Connection connection,PreparedStatement preparedStatement) {
        try {
            if(resultSet!=null) {
                resultSet.close();
            }
            if(statement!=null) {
                statement.close();
            }
            if(connection!=null) {
                connection.close();
            }
            if(preparedStatement!=null){
                preparedStatement.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void close(Connection connection) {
        close(null, null,connection,null);
    }

    public static void close(Statement statement) {
        close(null, statement,null,null);
    }

    public static void close(PreparedStatement preparedStatement){
        close(null,null,null,preparedStatement);
    }

    public static void close(ResultSet resultSet, Statement statement) {
        close(resultSet, statement,null,null);
    }

    public static void close(ResultSet resultSet, PreparedStatement preparedStatement) {
        close(resultSet, null,null,preparedStatement);
    }
}

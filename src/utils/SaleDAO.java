package utils;

import beans.Customer;
import beans.MedicineTable;
import beans.Producer;
import beans.Staff;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SaleDAO {
    /**
     * 获取客户信息
     * @return
     */
    public List<Customer> getAllCustomer(){
        List<Customer> customers=new ArrayList<>();
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet resultSet=null;
        try {
            connection=utils.DBconn.getConnInstance();
            String sql="select * from 客户";
            preparedStatement=connection.prepareStatement(sql);
            resultSet=preparedStatement.executeQuery();
            while (resultSet.next()){
                Customer customer=new Customer();
                customer.setCustomerID(resultSet.getString(1));
                customer.setCustomerName(resultSet.getString(2));
                customer.setCustomerPhone(resultSet.getString(3));
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            utils.DBclose.close(resultSet,preparedStatement);
        }
        return  customers;
    }

    /**
     * 根据名字或客户ID查询获取
     * @param search
     * @param type
     * @return
     */
    public List<Customer> serchCutr(String search,String type){
        List<Customer> customers=new ArrayList<>();
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet resultSet=null;
        try {
            connection=utils.DBconn.getConnInstance(Constant.saler);
            String sql="";
            if(type.equals("option1")){
                sql="select * from 客户 where 姓名 like '%"+search+"%'";
            }else if(type.equals("option2")){
                sql="SELECT * FROM 客户 WHERE 客户ID='"+search+"'";
            }else {
                System.out.println("类型不对");
            }
            preparedStatement=connection.prepareStatement(sql);
            resultSet=preparedStatement.executeQuery();
            while (resultSet.next()){
                Customer customer=new Customer();
                customer.setCustomerID(resultSet.getString(1));
                customer.setCustomerName(resultSet.getString(2));
                customer.setCustomerPhone(resultSet.getString(3));
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            utils.DBclose.close(resultSet,preparedStatement);
        }
        return customers;
    }

    /**
     * 根据客户id删除
     * @param id
     * @return
     */
    public boolean deleteCusByID(String id){
        boolean flag=false;
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        try {
            connection=DBconn.getConnInstance(Constant.saler);
            String sql="DELETE FROM 客户 WHERE 客户ID=?";
            preparedStatement=connection.prepareStatement(sql);
            preparedStatement.setString(1,id);
            int row=preparedStatement.executeUpdate();
            if(row>0){
                flag=true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flag;
    }

    /**
     * 根据客户ID获取信息
     * @param id
     * @return
     */
    public Customer createCusByID(String id){
        Customer customer=new Customer();
        customer.setCustomerID(id);
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet resultSet=null;
        try {
            connection=DBconn.getConnInstance(Constant.saler);
            String sql="SELECT * FROM 客户 WHERE 客户ID=?";
            preparedStatement=connection.prepareStatement(sql);
            preparedStatement.setString(1,id);
            resultSet=preparedStatement.executeQuery();
            while (resultSet.next()){
                customer.setCustomerName(resultSet.getString(2));
                customer.setCustomerPhone(resultSet.getString(3));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    /**
     * 添加客户
     * @param customer
     * @return
     */
    public  boolean addCustomer(Customer customer){
        boolean flag=false;
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        try {
            connection=DBconn.getConnInstance(Constant.saler);
            String sql="INSERT  INTO 客户 VALUES (?,?,?)";
            preparedStatement=connection.prepareStatement(sql);
            preparedStatement.setString(1,customer.getCustomerID());
            preparedStatement.setString(2,customer.getCustomerName());
            preparedStatement.setString(3,customer.getCustomerPhone());
            int row=preparedStatement.executeUpdate();
            if(row>0){
                flag=true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBclose.close(preparedStatement);
        }
        return flag;
    }

    /**
     * 修改客户信息
     * @param customer
     * @return
     */
    public boolean updateCustom(Customer customer){
        boolean flag=false;
        Connection connection=null;
        Statement statement=null;
        try{
            connection=DBconn.getConnInstance(Constant.saler);
            statement=connection.createStatement();
            String sql="update 客户 set 姓名='"+customer.getCustomerName()+"',电话='"+customer.getCustomerPhone()+
                    "'where 客户ID='"+customer.getCustomerID()+"'";
            int row=statement.executeUpdate(sql);
            if(row>0){
                flag=true;
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBclose.close(statement);
        }
        return flag;
    }

    /**
     * 售货
     * @param customID
     * @param salerID
     * @param medicineTables
     * @return
     */
    public boolean shouhuo(String customID, String salerID, List<MedicineTable> medicineTables){
        boolean flag=false;
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet resultSet=null;
        try{
            connection=DBconn.getConnInstance(Constant.saler);
            String ypid="";
            String sl="";
            int sID=0;
            for (MedicineTable med :
                    medicineTables) {
                ypid+=med.getYpid()+",";
                sl+=med.getSl()+",";
            }
            ypid=ypid.substring(0,ypid.length()-1);
            sl=sl.substring(0,sl.length()-1);
            String sql1="select dbo.get_SaleNO()";
            preparedStatement=connection.prepareStatement(sql1);
            resultSet=preparedStatement.executeQuery();
            if(resultSet.next()){
                sID=resultSet.getInt(1);
            }
            String saleID=String.format("%011d",sID);
            connection=DBconn.getConnInstance(Constant.saler);
            String sql2="{call dbo.insert_sale_data (?,?,?,?,?)}";
            preparedStatement=connection.prepareStatement(sql2);
            preparedStatement.setString(1,saleID);
            preparedStatement.setString(2,customID);
            preparedStatement.setString(3,salerID);
            preparedStatement.setString(4,ypid);
            preparedStatement.setString(5,sl);
            int row=preparedStatement.executeUpdate();
            if(row>0){
                flag=true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBclose.close(resultSet,preparedStatement);
        }
        return flag;
    }

    /**
     * 获取库存中药品信息
     * @return
     */
    public List<MedicineTable> getAllMedicine(){
        List<MedicineTable> medicineTables=new ArrayList<>();
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet resultSet=null;
        try{
            connection=DBconn.getConnInstance(Constant.Administrator);
            String sql="select 药品ID,药名,库存总量,种类名称 FROM view_admin_药品总表";
            preparedStatement=connection.prepareStatement(sql);
            resultSet=preparedStatement.executeQuery();
            while (resultSet.next()){
                MedicineTable medicineTable=new MedicineTable();
                medicineTable.setYpid(resultSet.getString(1));
                medicineTable.setYpmz(resultSet.getString(2));
                medicineTable.setKcsy(resultSet.getString(3));
                medicineTable.setType(resultSet.getString(4));
                medicineTables.add(medicineTable);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return medicineTables;
    }
}

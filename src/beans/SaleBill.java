package beans;

/**
 * Created by bill xu on 2018/1/5.
 * 售货单信息实体类
 */
public class SaleBill {
    /**
     * 售货单ID
     */
    private String SaleBillID;
    /**
     * 日期
     */
    private String Date;
    /**
     * 时间
     */
    private String Time;
    /**
     * 客户ID
     */
    private String customerID;

    /*
    * 客户姓名
     */
    private String customerName;

    /*
    * 售货员姓名
     */

    private String salerName;
    /**
     * 售货员ID
     */
    private String salerID;

    public SaleBill() {
    }

    public String getSaleBillID() {
        return SaleBillID;
    }

    public void setSaleBillID(String saleBillID) {
        SaleBillID = saleBillID;
    }

    public String getDate() {
        return Date;
    }

    public void setDate(String date) {
        Date = date;
    }

    public String getTime() {
        return Time;
    }

    public void setTime(String time) {
        Time = time;
    }

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public String getSalerID() {
        return salerID;
    }

    public void setSalerID(String salerID) {
        this.salerID = salerID;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getSalerName() {
        return salerName;
    }

    public void setSalerName(String salerName) {
        this.salerName = salerName;
    }
}

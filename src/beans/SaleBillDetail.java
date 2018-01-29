package beans;

/**
 * Created by bill xu on 2018/1/5.
 * 售货单详细信息实体类
 */
public class SaleBillDetail {
    /**
     * 售货单ID
     */
    private String SaleBillID;

    /**
     * 药品ID
     */
    private String SaleBillName;
    /*
    * 对，不要怀疑，这是药品名称
     */

    private String drugID;
    /**
     * 售货数量
     */
    private int number;
    /**
     * 售价
     */
    private double salePrice;
    /*
     * 日期
     */
    private String date;

    public String getSaleBillID() {
        return SaleBillID;
    }

    public void setSaleBillID(String saleBillID) {
        SaleBillID = saleBillID;
    }

    public String getDrugID() {
        return drugID;
    }

    public void setDrugID(String drugID) {
        this.drugID = drugID;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public double getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(double salePrice) {
        this.salePrice = salePrice;
    }

    public String getSaleBillName() {
        return SaleBillName;
    }

    public void setSaleBillName(String saleBillName) {
        SaleBillName = saleBillName;
    }
    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}

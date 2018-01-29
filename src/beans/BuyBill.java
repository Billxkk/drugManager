package beans;

/**
 * Created by bill xu on 2018/1/5.
 * 进货单信息实体类
 */
public class BuyBill {
    /**
     * 进货单ID
     */
    private String BuyBillID;
    /**
     * 日期
     */
    private String Date;
    /**
     * 时间
     */
    private String Time;
    /**
     * 厂家ID
     */
    private String producerID;
    /**
     * 进货员ID
     */
    private String buyerID;

    private String producerName;

    private String buyerName;

    public String getBuyBillID() {
        return BuyBillID;
    }

    public void setBuyBillID(String buyBillID) {
        BuyBillID = buyBillID;
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

    public String getProducerID() {
        return producerID;
    }

    public void setProducerID(String producerID) {
        this.producerID = producerID;
    }

    public String getBuyerID() {
        return buyerID;
    }

    public void setBuyerID(String buyerID) {
        this.buyerID = buyerID;
    }

    public String getProducerName() {
        return producerName;
    }

    public void setProducerName(String producerName) {
        this.producerName = producerName;
    }

    public String getBuyerName() {
        return buyerName;
    }

    public void setBuyerName(String buyerName) {
        this.buyerName = buyerName;
    }
}

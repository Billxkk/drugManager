package beans;

/**
 * Created by bill xu on 2018/1/5.
 * 厂家信息实体类
 */
public class Producer {
    /**
     * 厂商ID
     */
    private String producerID;
    /**
     * 厂名
     */
    private String producerName;
    /**
     * 地址
     */
    private String producerAddress;
    /**
     * 电话
     */
    private String producerPhone;

    public String getProducerID() {
        return producerID;
    }

    public void setProducerID(String producerID) {
        this.producerID = producerID;
    }

    public String getProducerName() {
        return producerName;
    }

    public void setProducerName(String producerName) {
        this.producerName = producerName;
    }

    public String getProducerAddress() {
        return producerAddress;
    }

    public void setProducerAddress(String producerAddress) {
        this.producerAddress = producerAddress;
    }

    public String getProducerPhone() {
        return producerPhone;
    }

    public void setProducerPhone(String producerPhone) {
        this.producerPhone = producerPhone;
    }
}

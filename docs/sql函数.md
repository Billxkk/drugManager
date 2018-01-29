#数据库使用

####存储过程
* dbo.insert_buy_data

    功能：插入进货单数据
    
    参数：
    
      @buyID 进货单ID,
      @produceID 厂家ID,
      @buyerID 进货员ID,
      @drugID 药品ID,
      @num 数量,   
      @produceDate 生产日期,
      @vaildDate 有效期至
      (后四个参数有多行数据时用','将每个数据间隔起来,具体见样例)

    调用样例：
    
        exec dbo.insert_buy_data '00000000004','1','000004',
        	'200002,200001,200006','11,12,13','2017-2-1,2017-2-1,2017-1-3',
        	'2018-1-1,2018-1-1,2018-1-3'

* dbo.insert_sale_data

    功能：插入售货单数据
    
    参数：
    
      @saleID 售货单ID,
      @customerID 客户ID,
      @salerID 售货员ID,
      @drugID 药品ID,
      @num 数量
      (后两个参数有多行数据时用','将每个数据间隔起来,具体见样例)

    调用样例：
    
        exec dbo.insert_sale_data '00000000005','1','000003',
        	'200002,200001,200006','22,45,61'

* dbo.check_invaildDrug

    功能：检查库存内的药品是否过期的存储过程，有的话就移动到退厂表中
    
    无参数
    
    调用样例：
    
        exec dbo.check_invaildDrug



####函数

* dbo.get_BuyNO

    功能：
        
        获取要创建的进货单ID（即获取当前数据库中的最大ID加1后返回）
        
     调用样例：
     
        select dbo.get_BuyNO()
        
* dbo.get_SaleNO

    功能：
        
        获取要创建的售货单ID（即获取当前数据库中的最大ID加1后返回）
        
     调用样例：
     
        select dbo.get_SaleNO()

            
* dbo.get_员工NO

    功能：
        
        获取要创建的员工ID（即获取当前数据库中的最大ID加1后返回）
        
     调用样例：
     
        select dbo.get_员工NO()
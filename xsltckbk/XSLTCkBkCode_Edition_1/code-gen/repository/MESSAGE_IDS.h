#ifndef MESSAGE_IDS_h
#define MESSAGE_IDS_h



  /*
  * Purpose:      
  * Data Format: AddStockOrderData
  * From:        StockClient
  * To:          StockServer
  */
  const int ADD_STOCK_ORDER_ID = 1;

  /*
  * Purpose:      
  * Data Format: AddStockOrderAckData
  * From:        StockServer
  * To:          StockClient
  */
  const int ADD_STOCK_ORDER_ACK_ID = 2;

  /*
  * Purpose:      
  * Data Format: AddStockOrderNackData
  * From:        StockServer
  * To:          StockClient
  */
  const int ADD_STOCK_ORDER_NACK_ID = 3;

  /*
  * Purpose:      
  * Data Format: CancelStockOrderData
  * From:        StockClient
  * To:          StockServer
  */
  const int CANCEL_STOCK_ORDER_ID = 4;

  /*
  * Purpose:      
  * Data Format: CancelStockOrderAckData
  * From:        StockServer
  * To:          StockClient
  */
  const int CANCEL_STOCK_ORDER_ACK_ID = 5;

  /*
  * Purpose:      
  * Data Format: CancelStockOrderNackData
  * From:        StockServer
  * To:          StockClient
  */
  const int CANCEL_STOCK_ORDER_NACK_ID = 6;



#endif /* MESSAGE_IDS_h */

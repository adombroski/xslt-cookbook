#include <messages/ADD_STOCK_ORDER.h>
#include <messages/ADD_STOCK_ORDER_ACK.h>
#include <messages/ADD_STOCK_ORDER_NACK.h>
#include <messages/CANCEL_STOCK_ORDER.h>
#include <messages/CANCEL_STOCK_ORDER_ACK.h>
#include <messages/CANCEL_STOCK_ORDER_NACK.h>
#include <messages/TEST.h>

#include <transport/Message.h>
#include <transport/MESSAGE_IDS.h>



void parseMessage(MessageHandler& handler, const Message& msg)
{
  switch (msg.getId())
  {
  
    case ADD_STOCK_ORDER_ID:
         parse(handler, *static_cast<const AddStockOrderData*>(msg.getData())) ;
         break;
    case ADD_STOCK_ORDER_ACK_ID:
         parse(handler, *static_cast<const AddStockOrderAckData*>(msg.getData())) ;
         break;
    case ADD_STOCK_ORDER_NACK_ID:
         parse(handler, *static_cast<const AddStockOrderNackData*>(msg.getData())) ;
         break;
    case CANCEL_STOCK_ORDER_ID:
         parse(handler, *static_cast<const CancelStockOrderData*>(msg.getData())) ;
         break;
    case CANCEL_STOCK_ORDER_ACK_ID:
         parse(handler, *static_cast<const CancelStockOrderAckData*>(msg.getData())) ;
         break;
    case CANCEL_STOCK_ORDER_NACK_ID:
         parse(handler, *static_cast<const CancelStockOrderNackData*>(msg.getData())) ;
         break;
    case TEST_ID:
         parse(handler, *static_cast<const TestData*>(msg.getData())) ;
         break;
    return false ;
  }
}
  void parse(MessageHandler & handler, const TestData& data)
{
    handler.beginStruct("TestData") ;
    parse(handler, data.get_order());
    parse(handler, data.get_cancel());
    handler.endStruct("TestData") ;
}

void parse(MessageHandler & handler, const AddStockOrderData& data)
{
    handler.beginStruct("AddStockOrderData") ;
    handler.field("symbol","StkSymbol",data.get_symbol());
    handler.field("quantity","Shares",data.get_quantity());
    handler.field("side","BuyOrSell",data.get_side());
    handler.field("type","OrderType",data.get_type());
    handler.field("price","Real",data.get_price());
    handler.endStruct("AddStockOrderData") ;
}

void parse(MessageHandler & handler, const AddStockOrderAckData& data)
{
    handler.beginStruct("AddStockOrderAckData") ;
    handler.field("orderId","Integer",data.get_orderId());
    handler.endStruct("AddStockOrderAckData") ;
}

void parse(MessageHandler & handler, const AddStockOrderNackData& data)
{
    handler.beginStruct("AddStockOrderNackData") ;
    handler.field("reason","Message",data.get_reason());
    handler.endStruct("AddStockOrderNackData") ;
}

void parse(MessageHandler & handler, const CancelStockOrderData& data)
{
    handler.beginStruct("CancelStockOrderData") ;
    handler.field("orderId","Integer",data.get_orderId());
    handler.field("quantity","Shares",data.get_quantity());
    handler.endStruct("CancelStockOrderData") ;
}

void parse(MessageHandler & handler, const CancelStockOrderAckData& data)
{
    handler.beginStruct("CancelStockOrderAckData") ;
    handler.field("orderId","Integer",data.get_orderId());
    handler.field("quantityRemaining","Shares",data.get_quantityRemaining());
    handler.endStruct("CancelStockOrderAckData") ;
}

void parse(MessageHandler & handler, const CancelStockOrderNackData& data)
{
    handler.beginStruct("CancelStockOrderNackData") ;
    handler.field("orderId","Integer",data.get_orderId());
    handler.field("reason","Message",data.get_reason());
    handler.endStruct("CancelStockOrderNackData") ;
}


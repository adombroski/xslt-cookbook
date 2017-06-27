#include <messages/ADD_STOCK_ORDER.h>
#include <messages/ADD_STOCK_ORDER_ACK.h>
#include <messages/ADD_STOCK_ORDER_NACK.h>
#include <messages/CANCEL_STOCK_ORDER.h>
#include <messages/CANCEL_STOCK_ORDER_ACK.h>
#include <messages/CANCEL_STOCK_ORDER_NACK.h>
#include <messages/TEST.h>

#include <transport/Message.h>
#include <transport/MESSAGE_IDS.h>



void prettyPrintMessage(ostream& stream, const Message& msg)
{
  switch (msg.getId())
  {
  
    case ADD_STOCK_ORDER_ID:
         prettyPrint(stream, *static_cast<const AddStockOrderData*>(msg.getData())) ;
         break;
    case ADD_STOCK_ORDER_ACK_ID:
         prettyPrint(stream, *static_cast<const AddStockOrderAckData*>(msg.getData())) ;
         break;
    case ADD_STOCK_ORDER_NACK_ID:
         prettyPrint(stream, *static_cast<const AddStockOrderNackData*>(msg.getData())) ;
         break;
    case CANCEL_STOCK_ORDER_ID:
         prettyPrint(stream, *static_cast<const CancelStockOrderData*>(msg.getData())) ;
         break;
    case CANCEL_STOCK_ORDER_ACK_ID:
         prettyPrint(stream, *static_cast<const CancelStockOrderAckData*>(msg.getData())) ;
         break;
    case CANCEL_STOCK_ORDER_NACK_ID:
         prettyPrint(stream, *static_cast<const CancelStockOrderNackData*>(msg.getData())) ;
         break;
    case TEST_ID:
         prettyPrint(stream, *static_cast<const TestData*>(msg.getData())) ;
         break;
    return false ;
  }
}
  ostream prettyPrint(ostream & stream, const TestData& data)
{
    stream 
        << "TestData" <<  endl  << "{"  << endl 
        << "order: " << prettyPrint(stream, data.get_order())
        << "cancel: " << prettyPrint(stream, data.get_cancel())
        << "}"  << endl ; 
    return stream ;
}

ostream prettyPrint(ostream & stream, const AddStockOrderData& data)
{
    stream 
        << "AddStockOrderData" <<  endl  << "{"  << endl 
        << "symbol: " << data.get_symbol() << endl
        << "quantity: " << data.get_quantity() << endl
        << "side: " << data.get_side() << endl
        << "type: " << data.get_type() << endl
        << "price: " << data.get_price() << endl
        << "}"  << endl ; 
    return stream ;
}

ostream prettyPrint(ostream & stream, const AddStockOrderAckData& data)
{
    stream 
        << "AddStockOrderAckData" <<  endl  << "{"  << endl 
        << "orderId: " << data.get_orderId() << endl
        << "}"  << endl ; 
    return stream ;
}

ostream prettyPrint(ostream & stream, const AddStockOrderNackData& data)
{
    stream 
        << "AddStockOrderNackData" <<  endl  << "{"  << endl 
        << "reason: " << data.get_reason() << endl
        << "}"  << endl ; 
    return stream ;
}

ostream prettyPrint(ostream & stream, const CancelStockOrderData& data)
{
    stream 
        << "CancelStockOrderData" <<  endl  << "{"  << endl 
        << "orderId: " << data.get_orderId() << endl
        << "quantity: " << data.get_quantity() << endl
        << "}"  << endl ; 
    return stream ;
}

ostream prettyPrint(ostream & stream, const CancelStockOrderAckData& data)
{
    stream 
        << "CancelStockOrderAckData" <<  endl  << "{"  << endl 
        << "orderId: " << data.get_orderId() << endl
        << "quantityRemaining: " << data.get_quantityRemaining() << endl
        << "}"  << endl ; 
    return stream ;
}

ostream prettyPrint(ostream & stream, const CancelStockOrderNackData& data)
{
    stream 
        << "CancelStockOrderNackData" <<  endl  << "{"  << endl 
        << "orderId: " << data.get_orderId() << endl
        << "reason: " << data.get_reason() << endl
        << "}"  << endl ; 
    return stream ;
}


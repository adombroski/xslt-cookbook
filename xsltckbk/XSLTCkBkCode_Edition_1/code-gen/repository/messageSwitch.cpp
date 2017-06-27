#include "stdafx.h"
#include "ADD_STOCK_ORDER_ACK.h"
#include "ADD_STOCK_ORDER_NACK.h"
#include "CANCEL_STOCK_ORDER_ACK.h"
#include "CANCEL_STOCK_ORDER_NACK.h"


class Message
{
public:

	int getId() const ;
	const void * getData() const ;
} ;

#include "MESSAGE_IDS.h"



bool processMessage(const Message& msg)
{
  switch (msg.getId())
  {
  
    case ADD_STOCK_ORDER_ACK_ID:
      return ADD_STOCK_ORDER_ACK(*static_cast<const AddStockOrderAckData*>(msg.getData())).process() ;
  
    case ADD_STOCK_ORDER_NACK_ID:
      return ADD_STOCK_ORDER_NACK(*static_cast<const AddStockOrderNackData*>(msg.getData())).process() ;
  
    case CANCEL_STOCK_ORDER_ACK_ID:
      return CANCEL_STOCK_ORDER_ACK(*static_cast<const CancelStockOrderAckData*>(msg.getData())).process() ;
  
    case CANCEL_STOCK_ORDER_NACK_ID:
      return CANCEL_STOCK_ORDER_NACK(*static_cast<const CancelStockOrderNackData*>(msg.getData())).process() ;
  
    return false ;
  }
}
  
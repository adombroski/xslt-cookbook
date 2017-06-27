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
  
    case ADD_STOCK_ORDER_ACK:
      ADD_STOCK_ORDER_ACK(*static_cast<AddStockOrderAckData*>(msg.getData())).process() ;
      break;
  
    case ADD_STOCK_ORDER_NACK:
      ADD_STOCK_ORDER_NACK(*static_cast<AddStockOrderNackData*>(msg.getData())).process() ;
      break;
  
    case CANCEL_STOCK_ORDER_ACK:
      CANCEL_STOCK_ORDER_ACK(*static_cast<CancelStockOrderAckData*>(msg.getData())).process() ;
      break;
  
    case CANCEL_STOCK_ORDER_NACK:
      CANCEL_STOCK_ORDER_NACK(*static_cast<CancelStockOrderNackData*>(msg.getData())).process() ;
      break;
  
  }
}
  
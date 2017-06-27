
#ifndef CANCEL_STOCK_ORDER_ACK_h
#define CANCEL_STOCK_ORDER_ACK_h

#include "MessageHandler.h"

//Forward Declarations
class CancelStockOrderAckData ;
/*!TODO:  Insert addition forward declarations here.*/   

class CANCEL_STOCK_ORDER_ACK : public MessageHandler
{
public:
    CANCEL_STOCK_ORDER_ACK(const CancelStockOrderAckData& data) ;
    bool process() ;
private:

    const CancelStockOrderAckData& m_Data ;
} ;

#endif
  
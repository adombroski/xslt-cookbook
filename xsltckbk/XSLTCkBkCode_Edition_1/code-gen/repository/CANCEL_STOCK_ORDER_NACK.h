
#ifndef CANCEL_STOCK_ORDER_NACK_h
#define CANCEL_STOCK_ORDER_NACK_h

#include "MessageHandler.h"

//Forward Declarations
class CancelStockOrderNackData ;
/*!TODO:  Insert addition forward declarations here.*/   

class CANCEL_STOCK_ORDER_NACK : public MessageHandler
{
public:
    CANCEL_STOCK_ORDER_NACK(const CancelStockOrderNackData& data) ;
    bool process() ;
private:

    const CancelStockOrderNackData& m_Data ;
} ;

#endif
  

#ifndef ADD_STOCK_ORDER_NACK_h
#define ADD_STOCK_ORDER_NACK_h

#include "MessageHandler.h"

//Forward Declarations
class AddStockOrderNackData ;
/*!TODO:  Insert addition forward declarations here.*/   

class ADD_STOCK_ORDER_NACK : public MessageHandler
{
public:
    ADD_STOCK_ORDER_NACK(const AddStockOrderNackData& data) ;
    bool process() ;
private:

    const AddStockOrderNackData& m_Data ;
} ;

#endif
  

#ifndef ADD_STOCK_ORDER_ACK_h
#define ADD_STOCK_ORDER_ACK_h

#include "MessageHandler.h"

//Forward Declarations
class AddStockOrderAckData ;
/*!TODO:  Insert addition forward declarations here.*/   

class ADD_STOCK_ORDER_ACK : public MessageHandler
{
public:
    ADD_STOCK_ORDER_ACK(const AddStockOrderAckData& data) ;
    bool process() ;
private:

    const AddStockOrderAckData& m_Data ;
} ;

#endif
  
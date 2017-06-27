
#include "stdafx.h"
#include "ADD_STOCK_ORDER_NACK.h"

/*!TODO:  Insert addition includes here.*/   

ADD_STOCK_ORDER_NACK::ADD_STOCK_ORDER_NACK(const AddStockOrderNackData& data)
  : m_Data(data)
{
}

bool ADD_STOCK_ORDER_NACK::process()
{
  /*!TODO:  Insert message handler code here. */
  return true ;
}
  
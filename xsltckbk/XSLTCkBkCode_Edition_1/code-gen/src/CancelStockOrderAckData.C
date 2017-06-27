
#include "CancelStockOrderAckData.h"

int  CancelStockOrderAckData::get_orderId() const
{
    return m_orderId;
}

Shares  CancelStockOrderAckData::get_quantityRemaining() const
{
    return m_quantityRemaining;
}


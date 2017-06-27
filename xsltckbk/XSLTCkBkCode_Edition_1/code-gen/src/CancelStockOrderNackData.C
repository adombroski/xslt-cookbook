
#include "CancelStockOrderNackData.h"

int  CancelStockOrderNackData::get_orderId() const
{
    return m_orderId;
}

Message  CancelStockOrderNackData::get_reason() const
{
    return m_reason;
}


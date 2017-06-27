
#include "CancelStockOrderData.h"

int  CancelStockOrderData::get_orderId() const
{
    return m_orderId;
}

Shares  CancelStockOrderData::get_quantity() const
{
    return m_quantity;
}


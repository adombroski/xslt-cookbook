
#include "AddStockOrderData.h"

StkSymbol  AddStockOrderData::get_symbol() const
{
    return m_symbol;
}

Shares  AddStockOrderData::get_quantity() const
{
    return m_quantity;
}

BuyOrSell  AddStockOrderData::get_side() const
{
    return m_side;
}

OrderType  AddStockOrderData::get_type() const
{
    return m_type;
}

double  AddStockOrderData::get_price() const
{
    return m_price;
}


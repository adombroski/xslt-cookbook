
#include <primitives/primitives.h>

class AddStockOrderData
{
public:

    StkSymbol get_symbol() const ;
    Shares get_quantity() const ;
    BuyOrSell get_side() const ;
    OrderType get_type() const ;
    double get_price() const ;


private:

    StkSymbol  m_symbol ;
    Shares  m_quantity ;
    BuyOrSell  m_side ;
    OrderType  m_type ;
    double  m_price ;

} ;

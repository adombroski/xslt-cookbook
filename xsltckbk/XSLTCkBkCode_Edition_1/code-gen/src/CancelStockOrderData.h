
#include <primitives/primitives.h>

class CancelStockOrderData
{
public:

    int get_orderId() const ;
    Shares get_quantity() const ;


private:

    int  m_orderId ;
    Shares  m_quantity ;

} ;

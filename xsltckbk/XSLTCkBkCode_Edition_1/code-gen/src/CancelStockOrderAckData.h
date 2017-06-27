
#include <primitives/primitives.h>

class CancelStockOrderAckData
{
public:

    int get_orderId() const ;
    Shares get_quantityRemaining() const ;


private:

    int  m_orderId ;
    Shares  m_quantityRemaining ;

} ;

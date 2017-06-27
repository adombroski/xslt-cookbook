
#include <primitives/primitives.h>

class CancelStockOrderNackData
{
public:

    int get_orderId() const ;
    Message get_reason() const ;


private:

    int  m_orderId ;
    Message  m_reason ;

} ;

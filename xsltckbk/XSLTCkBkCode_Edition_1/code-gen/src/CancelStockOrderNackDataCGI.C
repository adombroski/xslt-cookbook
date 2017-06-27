
#include <stdio.h>
#include "cgi.h"
#include "msg_ids.h"
#include "CancelStockOrderNackData.h"

void cgi_main(cgi_info *cgi)
{
    CancelStockOrderNackData data ;
    form_entry* form_data = get_form_entries(cgi) ;   
    const char * orderId = parmval(form_data, "CANCEL_STOCK_ORDER_NACK_orderId");
    const char * reason = parmval(form_data, "CANCEL_STOCK_ORDER_NACK_reason");
    data.orderId = Integer(orderId);
    data.reason = Message(reason);

    //Enque data to the process being tested 
    enqueData(CANCEL_STOCK_ORDER_NACK,data) ;

}
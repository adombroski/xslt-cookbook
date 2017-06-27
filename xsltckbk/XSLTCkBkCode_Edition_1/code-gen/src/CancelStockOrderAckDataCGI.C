
#include <stdio.h>
#include "cgi.h"
#include "msg_ids.h"
#include "CancelStockOrderAckData.h"

void cgi_main(cgi_info *cgi)
{
    CancelStockOrderAckData data ;
    form_entry* form_data = get_form_entries(cgi) ;   
    const char * orderId = parmval(form_data, "CANCEL_STOCK_ORDER_ACK_orderId");
    const char * quantityRemaining = parmval(form_data, "CANCEL_STOCK_ORDER_ACK_quantityRemaining");
    data.orderId = Integer(orderId);
    data.quantityRemaining = Shares(quantityRemaining);

    //Enque data to the process being tested 
    enqueData(CANCEL_STOCK_ORDER_ACK,data) ;

}
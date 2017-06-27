
#include <stdio.h>
#include "cgi.h"
#include "msg_ids.h"
#include "CancelStockOrderData.h"

void cgi_main(cgi_info *cgi)
{
    CancelStockOrderData data ;
    form_entry* form_data = get_form_entries(cgi) ;   
    const char * orderId = parmval(form_data, "CANCEL_STOCK_ORDER_orderId");
    const char * quantity = parmval(form_data, "CANCEL_STOCK_ORDER_quantity");
    data.orderId = Integer(orderId);
    data.quantity = Shares(quantity);

    //Enque data to the process being tested 
    enqueData(CANCEL_STOCK_ORDER,data) ;

}
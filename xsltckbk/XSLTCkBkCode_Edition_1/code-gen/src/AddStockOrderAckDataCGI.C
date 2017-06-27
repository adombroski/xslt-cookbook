
#include <stdio.h>
#include "cgi.h"
#include "msg_ids.h"
#include "AddStockOrderAckData.h"

void cgi_main(cgi_info *cgi)
{
    AddStockOrderAckData data ;
    form_entry* form_data = get_form_entries(cgi) ;   
    const char * orderId = parmval(form_data, "ADD_STOCK_ORDER_ACK_orderId");
    data.orderId = Integer(orderId);

    //Enque data to the process being tested 
    enqueData(ADD_STOCK_ORDER_ACK,data) ;

}
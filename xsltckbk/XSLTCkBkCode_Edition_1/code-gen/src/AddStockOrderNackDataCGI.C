
#include <stdio.h>
#include "cgi.h"
#include "msg_ids.h"
#include "AddStockOrderNackData.h"

void cgi_main(cgi_info *cgi)
{
    AddStockOrderNackData data ;
    form_entry* form_data = get_form_entries(cgi) ;   
    const char * reason = parmval(form_data, "ADD_STOCK_ORDER_NACK_reason");
    data.reason = Message(reason);

    //Enque data to the process being tested 
    enqueData(ADD_STOCK_ORDER_NACK,data) ;

}
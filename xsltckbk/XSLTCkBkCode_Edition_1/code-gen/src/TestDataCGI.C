
#include <stdio.h>
#include "cgi.h"
#include "msg_ids.h"
#include "TestData.h"

void cgi_main(cgi_info *cgi)
{
    TestData data ;
    form_entry* form_data = get_form_entries(cgi) ;   
    const char * order = parmval(form_data, "TEST_order_symbol");
    const char * order = parmval(form_data, "TEST_order_quantity");
    const char * order = parmval(form_data, "TEST_order_side");
    const char * order = parmval(form_data, "TEST_order_type");
    const char * order = parmval(form_data, "TEST_order_price");
    const char * cancel = parmval(form_data, "TEST_cancel_orderId");
    const char * cancel = parmval(form_data, "TEST_cancel_quantity");
    data.order.symbol = StkSymbol(data.order_symbol);
    data.order.quantity = Shares(data.order_quantity);
    data.order.side = EnumBuyOrSellNameToVal(data.order_side);
    data.order.type = EnumOrderTypeNameToVal(data.order_type);
    data.order.price = Real(data.order_price);
    data.cancel.orderId = Integer(data.cancel_orderId);
    data.cancel.quantity = Shares(data.cancel_quantity);

    //Enque data to the process being tested 
    enqueData(TEST,data) ;

}
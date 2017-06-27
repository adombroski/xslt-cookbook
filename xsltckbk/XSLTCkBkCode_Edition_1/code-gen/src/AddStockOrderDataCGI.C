
#include <stdio.h>
#include "cgi.h"
#include "msg_ids.h"
#include "AddStockOrderData.h"

void cgi_main(cgi_info *cgi)
{
    AddStockOrderData data ;
    form_entry* form_data = get_form_entries(cgi) ;   
    const char * symbol = parmval(form_data, "ADD_STOCK_ORDER_symbol");
    const char * quantity = parmval(form_data, "ADD_STOCK_ORDER_quantity");
    const char * side = parmval(form_data, "ADD_STOCK_ORDER_side");
    const char * type = parmval(form_data, "ADD_STOCK_ORDER_type");
    const char * price = parmval(form_data, "ADD_STOCK_ORDER_price");
    data.symbol = StkSymbol(symbol);
    data.quantity = Shares(quantity);
    data.side = EnumBuyOrSellNameToVal(side);
    data.type = EnumOrderTypeNameToVal(type);
    data.price = Real(price);

    //Enque data to the process being tested 
    enqueData(ADD_STOCK_ORDER,data) ;

}
<!DOCTYPE HTML>

<html>

<head>
    <title id="title">Hi, Im Kevin</title>
    <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
</head>

<body>
<style>
/*-------------------separate functions-------------  */
.everything{
    position:relative;
    width:720px;
    font-size:70%;
    left:5px;
}

.footDiv{
    position:relative;
    page-break-after:always;
    page-break-inside: avoid;
}

.image {
    background-repeat:no-repeat;
    background-size:auto 80px;
    background-position: 0px 10px;
}
/*------------------table part ------------------*/
table{
    table-layout: fixed;
    border-collapse:collapse;
}
td{
    word-wrap:break-word;
}
/*------------------text-align part ----------------- */
.right{
    text-align:right;
}
.center{
    text-align:center;
}
.left{
    text-align:left;
}
</style>

<script>
window.onload = function main (){

    var printModel = ${data.data};
    var order = printModel.info;
    var items = printModel.items;
    var listHeight = 0;
    var totalHeight = 0;
    var pagePixel = 924.3;
    var breakPixel = 920.3;
    var currentPage = 0;
    var totalPage = 0;
    var needHeader = false;
    headerForm();
    listForm();

    function headerForm(){

        var headerInfo = getHeaderInfo();
        var billToShipToTable = getBillToShipToInfoTable();
        var termTable = getTermInfoTable();
        var contact = getContact()
        display(headerInfo + billToShipToTable + contact + termTable);
        needPageBreak(0,"header","",false);
    }

    function getHeaderInfo(){

        var listType = order.listType||"";

        switch(listType){
            case "packing":
                title = "Packing List";
                break;
            case "order":
                title = "Order Confirmation";
                break;
            default:
                alert("No type selected!");
        }
        document.getElementById("title").innerHTML = title;



        var output = "<div class='header' id='header'>";
        var logo = "<img src='http://192.6.2.108:8080/clivia/resources/images/DD LOGO.jpg' alt='logo' style='height:auto;width:180px;'></img>";
        var innerTable = "<table class='left'>"
                        + "<tr><th>STITCHES CREATION INC.</th></tr>"
                        + "<tr><td>3889 Keith Street, Unit D</td></tr>"
                        + "<tr><td width = '220px'>Burnaby," + ("&nbsp;").repeat(2)
                        + "BC," + ("&nbsp;").repeat(2)
                        +  "V5J 5K4" + ("&nbsp;").repeat(3) + "Canada</td></tr>"
                        + "<tr><td>Tel: (604)873-8901" + ("&nbsp;").repeat(3)
                        + "Fax: (604)873-8901</td></tr>"
                        + "<tr><td>info@stitchescreation.com</td></tr>"
                        + "<tr><td>www.ScDeco.com</td></tr></table>";
        var invoiceTable = "<table align='right' width = 260px>"
                        +"<tr><td height=40px style ='font-weight:bold;font-size:2.2em' align = right>" + title + "</td></tr>"                  + "<tr><td align='right'>"
                        + "<table border = 1 width = '240px' height='50px'>"
                        + "<tr>"
                        + "<th>P.O.#</th>"
                        + "<th>Date</th>"
                        + "<th>Order#</th>"
                        +"</tr>"
                        + "<tr>"
                        + "<td class='center'>"+ (order.poNo||"") + "</td>"
                        + "<td class='center'>"+ (order.orderDate||"") + "</td>"
                        + "<td class='center'>" + (order.orderNo||"") + "</td></tr></table>";

        output += "<table width = 720px height=100px>"
                     +"<tr><td width = 200px>" + logo + "</td>"
                     +"<td>" + innerTable + "</td>"
                     +"<td valign='bottom'>" + invoiceTable + "</td></tr></table></table>"
        return output;
    }

    function getBillToShipToInfoTable(){
        var output = " ";
        var billToShipToTable = "<table width = 720px class='left'>"
                                +"<tr style='background-color:silver; border-top-style:hidden;border-left-style:hidden;border-right-style:hidden;'>"
                                + "<th style ='border-right-style:hidden'>Bill To:</th>"
                                + "<th>" + ("&nbsp;").repeat(14) + "Ship To:</th><tr>"
                                + "<tr><td align='right' valign='top'><br>" + getbillTable("bill") + "</td>"
                                + "<td align='right' valign='top'><br>" + getbillTable("ship") + "</td>"
                                +"</tr></table><div class='5pxHeight' style = 'height:5px'></div>"
        output += billToShipToTable;
        return output;
    }

    function getbillTable(type){
        var adjustOrder = "";
        switch (type){

            case "bill":
                var adjustOrder = order.billTo;
                break;
            case "ship":
                var adjustOrder = order.shipTo;
                break;
            default:
                alert("Bill? Ship?");
        }
        var info="";
        if (!!adjustOrder.city)
            info += ",&nbsp;" + adjustOrder.city;
        if(!!adjustOrder.province)
            info += ",&nbsp;" + adjustOrder.province;
        if(!!adjustOrder.postalCode)
            info += "&nbsp;&nbsp;" + adjustOrder.postalCode;
        if(info)
            info = info.substring(7);

        var output = "<div style='height:25px'></div><table width = '280px'>"
                    +"<tr><td>" + (adjustOrder.receiver||"") + "</td></tr>"
                    +"<tr><td>" + (adjustOrder.addr1||"") + "</td></tr>"
                    +"<tr><td>" + (adjustOrder.addr2||"") + "</td></tr>"
                    +"<tr><td>" + (info||"") + "</td></tr>"
                    +"<tr><td>" + (adjustOrder.country||"") + "</td>"
                    +"</tr>";
        if (!!adjustOrder.attn)
            output += "<tr><td>Attn: " + adjustOrder.attn + "</td>";
        else
            output += "<td></td>";

        output += "</tr>";
        output +="</table><br>";
        return output;
    }

    function getContact(){
        var info = order.contact
        var contactInfo="";
        if (!!info.name)
            contactInfo += ",&nbsp;" + info.name;
        if(!!info.phone)
            contactInfo += ",&nbsp;" + info.phone;
        if(!!info.email)
            contactInfo += ",&nbsp;" +info.email;
        if(contactInfo)
            contactInfo = contactInfo.substring(7);

        var contact =  "<table width='720px' class='contact'>"
                    + "<tr>"
                    + "<th width='50px' align=left>Contact:</th>"
                    + "<td align=left>" + contactInfo + "</td>"
                    + "</tr>"
                    + "</table>";
        return contact;
    }

    function getTermInfoTable(){
        var output = "<table border = 1 width = 720px>"
                    +"<tr><th>Sales REP.</th>"
                    + "<th>Terms</th>"
                    + "<th>Ship Date</th>"
                    + "<th>CancelDate</th></tr>"
                    + "<tr><td align=center>" + (order.rep||"") + "</td>"
                    + "<td align=center>" + (order.terms||"") + "</td>"
                    +"<td align=center>" + (order.shipDate||"") + "</td>"
                    +"<td align=center>" + (order.cancelDate||"") + "</td></tr>"
                    +"</table>";
        output += "<br></div>";
        return output;
    }

    function listForm() {

        var listType = (order.listType||"");
        var listHeader = getHeader(listType);
        display(listHeader);
        var height = $("#listHeader").outerHeight();
        totalHeight += height;
        for (i = 0; i < items.length; i++){
            var listFooter = getFooter(i,items,listType);
            var listDetail = getListDetail(i,items,listType);
            display(listDetail + listFooter);
            if (i == items.length - 1) var end = true;
            needPageBreak(i,"item","modifySpace",end);
        }
    }

    function getHeader(listType){

        var output = "";
        var hideDiscount = order.hideDiscount;
        var style = "style='border-bottom:1pt solid black;'"
        switch (listType){
            case "packing":
                output = "<table class='tableHeader' width='720px'>"
                    +"<tr class='left'>"
                    +"<th width='70px'" + style + ">Style</th>"
                    +"<th width='580px'" + style + ">Description</th>"
                    +"<th width='50px' align='right'" + style + ">Quantity</th>"
                    +"</tr>"
                    +"</table>";
                break;

            case "order":
                if(hideDiscount == true){
                    output = "<table class='tableHeader' width='720px' style ='background-color:silver'>"
                        +"<tr align='left'>"
                        +"<th width='70px'" + style + ">Style</th>"
                        +"<th width='300px'" + style + ">Description</th>"
                        +"<th width='130px' align='right' " + style + ">Quantity</th>"
                        +"<th width='100px' align='right' " + style + ">Price</th>"
                        +"<th width='100px' align='right' " + style + ">Amount</th>"
                        +"</tr>"
                        +"</table>";
                }
                else{
                    output = "<table class='tableHeader' width='720px'>"
                        +"<tr class='left'>"
                        +"<th width='70px'" + style + ">Style</th>"
                        +"<th width='300px'" + style + ">Description</th>"
                        +"<th width='65px' align='right' " + style + ">Quantity</th>"
                        +"<th width='60px' align='right'" + style + ">Price</th>"
                        +"<th width='65px' align='right' " + style + ">% Off</th>"
                        +"<th width='60px' align='right'" + style + ">Net</th>"
                        +"<th width='65px' align='right'" + style + ">Amount</th>"
                        +"</tr>"
                        +"</table>";
                }
                break;
        }
        return output;
    }


    function getListDetail(i,items,listType){

        var output = "";
        var item = items[i];
        var hideDiscount = order.hideDiscount;
        output = "<div class = 'item' id = 'item" + i +"'>";
        var modify = 0;
        if (i == 0) var indent = "";
        else indent = "<br>";
        output += indent + "<div class='modifySpace' id='modifySpace" + 2*i +"'></div>";
        output  += "<table width='720px'>";
        switch (listType){
             case "order":
                    if(hideDiscount == true){
                        output  += "<tr>"
                                +"<td width='71px' align='left'>" + item.itemNo+ "</td>"
                                +"<td width='302px' align='left'>" + item.desc + "</td>"
                                +"<td width='134px' align='right' id='bold'>" + item.qty+ "</td>"
                                +"<td width='103px' align='right' id='bold'>" + item.price + "</td>"
                                +"<td width='100px' align='right' id='bold'>" + item.amt + "</td>"
                                +"</tr>";
                    }else{
                        output  += "<tr>"
                                +"<td width='70px' class='left'>" + item.itemNo+ "</td>"
                                +"<td width='300px' class='left'>" + item.desc + "</td>"
                                +"<td width='65px' align='right' id='bold'>" + item.qty+ "</td>"
                                +"<td width='60px' align='right'>" + item.listPrice + "</td>"
                                +"<td width='65px' align='right'>" + item.discount+ "</td>"
                                +"<td width='60px' align='right' id='bold'>" + item.price + "</td>"
                                +"<td width='65px' align='right' id='bold'>" + item.amt + "</td>"
                                +"</tr>";
                    }
                    break;

                case "packing":
                    output  += "<tr>"
                        +"<td width='70px' class='left'>" + (item.itemNo?item.itemNo:"")+ "</td>"
                        +"<td width='580px' colspan = '4' class='left'>" + (item.desc?item.desc:"") + "</td>"
                        +"<td width='65px' align='right' id='bold'>" + item.qty+ "</td>"
                        +"</tr>";
                    break;
        }
            var subItemRows = item.data;
            var listLength = items.length - 1;
            if(subItemRows){
                //image part
                var url = "http://192.6.2.108:8080/clivia/lib/image/getimage?thumbnail=true&id=";
                var imageUrl =item.imageId? url+item.imageId:"";
                if (!!imageUrl) height = "height='100px'";
                else height = "";
                output += "<tr>"
                        + "<td width ='50px'" + height +  "class='image' style='background-image:url(&quot;"
                        + imageUrl
                        +"&quot;)'></td>";
                //item Table part
                var item_table = "";
                var subItemRows = item.data;
                for (var j = 0; j < subItemRows.length; j++) {
                    if (listType == "packing"){
                        var widthCol = "width = '250px'";
                    }
                    else{
                        if(hideDiscount == true) var widthCol = "width = '250px'";
                        else var widthCol = "width = '195px'"
                    }
                    var tOpen = "<tr><td align='left'" + widthCol + ">";
                    var tClose = "</td>";
                    var subItemCols = subItemRows[j];

                    for (var k = 0; k < subItemCols.length; k++) {
                        if(k == 0) item_table += tOpen + (subItemCols[k] ? subItemCols[k] : "") + tClose;
                        else if(k < subItemCols.length - 1 && k < 7)
                            item_table += "<td class = 'right' width = 25px>"
                                       + (subItemCols[k] ? subItemCols[k] : "")
                                       + tClose;
                        else if(k < subItemCols.length - 1 && k >= 7)
                            item_table += "<td class = 'right' width = 30px>"
                                       + (subItemCols[k] ? subItemCols[k] : "")
                                    + tClose;

                        else item_table += "<td class='right' width = '50px'>"
                                    + (subItemCols[k] ? subItemCols[k] : "")
                                    + tClose;
                    }
                    item_table += "</tr></td>";
                }
                switch(listType){
                case "packing":
                	var colspan = "colspan = '3'";
                	var tdColspan = "colspan = '2'";
             		break;
                case "order":
                	var colspan = "colspan = '2'";
                	var tdColspan = "colspan = '4'";
                	break;
            	}
               output += "<td " + colspan + "id='itemTable' align='right'>"
                      + "<table align='left'>" + item_table
                      + "</table></td>"
                      +"<td"+ tdColspan + "></td></tr></table>"
              		  + "<div class='modifySpace' id='modifySpace" + (2*i+1) +"'></div>";
            }
        return output;
    }

    function getFooter(i,items,listType) {
        var listLength = items.length - 1;
        var output = "";
        if( i == listLength){
            output += "<br><table width = '720px'>"
                +"<tr>"
                +"<td style='width:65px;vertical-align:text-top;'></td>"
                +"<td width='320px' style=';text-align:left;vertical-align:text-top'>" + "Total Garment Supply Quantity: " + (order.totalQty||"") + " pcs"+"</td>";
            if(listType == "order")    
                output += "<th style='width:290px;text-align:right;vertical-align: text-top'>" + "Total Amount: " + (order.totalAmt||"") + "</th>";
            else output += "<td width = '290px'></td>";    
           	output +="</tr>"
            	    +"<tr>"
                	+ "<td colspan = 3 height = '3px';></td>"
                	+"</tr>"
                	+"<tr>"+"<th style='width:35px; vertical-align:text-top;'>Remark:</th>"
                	+"<td id='remark' colspan = 2  class='left' style='word-spacing:none; width:200px'>" + (order.remark?order.remark:"") + "</td>"
                	+"</tr>"
                	+"</table></div>";
        }
        return output;
    }


    function needPageBreak(i,lists,modify,end){

        if (lists == "item"){
            var listSpace = lists + i;
            var listHeight = $("#" + listSpace).outerHeight();
            console.log( listSpace +": " + listHeight);
        }
        else{
            var listSpace = lists;
            var listHeight = $("#" + lists).height();
            console.log( listSpace +": " + listHeight);
        }
        totalHeight += listHeight;
         console.log("total: " + totalHeight);

        if(totalHeight > breakPixel){
            var thisListHeight = listHeight;
            totalHeight = totalHeight - thisListHeight;
            totalPage = currentPage + 1;
            var continuePage = "footDiv";
            var footer = getPageFooter(continuePage,lists,listHeight);
            totalHeight = 0;
            if(modify == "modifyTotal"){
                var modifyS = modify + i;
                totalHeight += thisListHeight;
            }
            else{
                var modifyS = modify + (i + i - 1);
            }

            $("#" + modifyS).html(footer);

            if (needHeader == true){
               var modifyH = modify + (i + i);
               var output ="";
               var listType = order.listType||"";
               $("#" + (modifyH)).html(getHeader(listType));
               var height = $("#listHeader").outerHeight();
               totalHeight += height;
               totalHeight += thisListHeight;
            }
        }
        if (end == true){
            var continuePage = "end";
            var footer = getPageFooter(continuePage,lists,end);
            display(footer);
        }
    }

    function getPageFooter(page,position,end){

        currentPage++;
        var errorPixel = 5;
        if(end == true) totalPage = currentPage;
        else    totalPage = currentPage + 1;
        if(currentPage != 1){
            errorPixel = 15;
            var margin = pagePixel - totalHeight + errorPixel;
        }
        else{
            var margin = pagePixel - totalHeight + errorPixel;
        }
        var output = "<div class='" + page + "' id='footer' style='margin-top:" + margin + "px'><table width='720px'>"
                    + "<tr>"
                    + "<td width='60px'></td>"
                    + "<td width='510px'></td>"
                    + "<td align='left' id = 'footerPage" + currentPage + "'> Page " + currentPage + " of " + totalPage + "</td>"
                    + "<td align=right width = '80px'> #" + order.orderNo + "</td>"
                    + "</tr>"
                    + "</table>"

        if(position == "item"){
          needHeader = true;
        }
        else{
           needHeader = false;
        }
        if (end == true){
                for (var i = 1; i < totalPage; i ++){
                    if (i < totalPage){
                        var	newFooter = "Page" + ("&nbsp;").repeat(1) + i + " of " + totalPage;
                        $("#footerPage" + i).html(newFooter);
                    }
                }
            }
        return output;
    }

    function display(output){
        document.getElementById("everything").innerHTML += output;
    }
}
</script>
<div id="everything" class="everything"></div>

</body>

</html>
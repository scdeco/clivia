 <!DOCTYPE html>

<html>

<header>
    <title>Embroidery Order</title>
    <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
</header>

<body>


<style>
html,body{
    font-family: "Times New Roman";
    font-weight:normal;
    height:100%;
    margin:0px;
    padding:0px;
}

table td, table td * {
    vertical-align: top;
}

.footDiv{
    position:relative;
    page-break-after:always;
    page-break-inside: avoid;
}

.end{
    left:5px;
    font-size:70%;
}
.image {
    background-repeat:no-repeat;
    background-size:auto 80px;
    background-position: 0px 10px;
}
/*-----------------------create two table----------------------------*/
.topDiv{
    position:relative;
    left:5px;
    top:5px;

}

.topTable{
    position:relative;
    width:700px;
    text-align:left;
    height:50px;

}
.bottomDiv{
    position:relative;
    width:700px;
    left:5px;
    top:25px;
}
.bottomTable{
    position:relative;
    width:700px;
}

.rightDiv{
    position:relative;
    top:7px;
}
.rightTable{
    position:relative;
    left:496px;
    width:200px;
    height:40px;
    margin-top:-60px;
    text-align:center;
}
/*----------------------End of create two table---------------------*/


/*----------------------list part css start here---------------------*/
.everything{
    position:relative;
    width:695px;
    font-size:70%;
    left:5px;
}
.regularIns{
    position:relative;
    left:-3px;
    width:695px;
    margin-top:30px;
    white-space: pre-wrap;
}
.garment{
    position:relative;
    width:695px;
}
.service{
    position:relative;
    width:695px;
}
.terms{
     position:absolute;
    font-size:2em;
    font-weight:bold;
    height:20px;
    margin-top:-32px;
    margin-left:200px;
}
.detail{
    position:relative;
    width:695px;
}
.specialIns{
    position:relative;
    width:699px;
    white-space: pre-wrap;
}

/*----------------------end of list part css---------------------*/


/*----------------------text align part---------------------*/
.right{
    text-align:right;
}
.center{
    text-align:center;
}
.left{
    text-align:left;
}
.centerUnderLine{
    text-align:center;
    border-top-style:hidden;
    border-right-style:hidden;
    border-bottom-style:solid;
    border-width:2px;
    border-color:gray;
}
.rightUnderLine{
    text-align:right;
    border-top-style:hidden;
    border-right-style:hidden;
    border-bottom-style:solid;
    border-width:2px;
    border-color:gray;
}
.leftUnderLine{
    text-align:left;
    border-top-style:hidden;
    border-right-style:hidden;
    border-bottom-style:solid;
    border-width:2px;
    border-color:gray;
}
/*-------------------------table setting---------------------*/
table{
    table-layout: fixed;
    border-collapse:collapse;
}
td{
    word-wrap:break-word;
}
</style>


<script>

window.onload = function (){

    var printModel = ${data.data};
    var order = printModel;
    //use to count the size of the height
    var countPixel = 0;
    //whole page pixel
    var pagePixel = 924.3;//924.3
    //decide which page is printing
    var breakPixel = 915;//need page break
    var currentPage = 0;
    //use to count the page number
    var totalPage = 0;
    //if it is the end of the page
    var endOrder = false;
    //check if the first page break
    var firstPage = false;
    var decoEmbTotal = 0;
    var decoAreEmb = false;
    var decoSpTotal = 0;
    var decoAreSp = false;
    var decoHpTotal = 0;
    var decoAreHp = false;
    var garmentsTotalQty = 0;
    var servicesTotalAmt = 0;
    var nextPage = 0;
    //-------------------all functions here--------------------------

    headerForm();
    listForm();

    function headerForm(){
        //job no & title
        headerPart();
        //regular instructions
        regularIns();
    }

    function listForm(){

        //garment part
        garment();
        //service part
        service();
        packing();
       //deco list part
        decoList();
        specialInstruction();
        //ilustration of placements
        ilustration();
        //productInfo
        productionInfo();
        //display the type of the form and the total count
        modifyTitle()
    }
//------------------end call functions-------------------------------


    function headerPart(){
        var jobNo = order.jobNo;
        var type = order.type;
        var modifyedType = "";
        if(!!type){
            modifyedType = "(" + type + "something else here)";
        }

        var headerPart=	"<div id='startForm' class='startForm'>"
                            +"<div style = 'width:700px;' id='headerPart'>"
                            +"<table width = 700px height= 20px;'>"
                            + "<tr>"
                            + "<td width=45px; style='font-weight:bold;font-size:1.2em;vertical-align:middle'>JobNo:</td>"
                            + "<td width = '90px'style='text-decoration: underline;font-weight:bold;font-size:1.2em;vertical-align:middle'>"
                            + (jobNo?jobNo:"") + "</td>"
                            + "<td id = 'modifyType' width = '250px' style = 'vertical-align:middle; font-weight:bold;'>" + modifyedType + "</td>"
                            +"<td width= 100px;></td>"
                            + "<td style='font-size:2.0em;font-weight:bold;text-align:right'>Order</td>"
                            + "</tr></table>"
                            + "</div>";
        //table 1 (customer,jobName,address,buyer,p.o,terms)
        //table 2 (email phone fax issued)
        //table 3 (job No. P.O#, date)
        topThreeTable(headerPart);
}
    //table 1 (customer,jobName,address,buyer,p.o,terms)
    //table 2 (email phone fax issued)
    //table 3 (job No. P.O#, date)
    function topThreeTable(merginThreeTable){

        var table_1 = "<div class = 'topDiv'>"
                    + "<table class='topTable'>"
                    + "<tr>"
                    + "<th width=60px>Customer:</th>"
                    + "<td width=280px>" + (order.customer?order.customer:"") +"</td>"
                    + "<th width=40px>Buyer:</th>"
                    + "<td width=100px>" + (order.buyer?order.buyer:"") + "</td>"
                    +"<td width = 132px></td>"
                    + "</tr>"
                    + "<tr>"
                    + "<th>Job Name:</th>"
                    + "<td>" + (order.jobName?order.jobName:"") + "</td>"
                    + "<th>P.O#:</th>"
                    + "<td>"+ (order.poNo?order.poNo:"") +"</td><td></td>"
                    + "</tr>"
                    + "<tr>"
                    + "<th  class='left'>Shipment:</th>"
                    + "<td  class='left'>" + (order.shipment?order.shipment:"")  + "</td>"
                    + "<th>Terms:</th>"
                    + "<td width ='100px'>" + (order.terms?order.terms:"") + "</td>"
                    + "<th width=90 class='right'>Require By:</th>"
                    + "<td width= 76px; class='left'>" + (order.require?order.require:"")  + "</td>"
                    + "</tr>"
                    + "</table>"
                    + "</div>"

        var table_2 = "<div class ='bottomDiv'>"
                    + "<table class='bottomTable'>"
                    + "<tr>"
                    + "<th width= 20px class='left'>Phone:</th>"
                    + "<td width= 188px class='left'>" + (order.phone?order.phone:"") + "</td>"
                    + "<th width= 15px class='left'>Fax:</th>"
                    + "<td width= 130px class='left'>" + (order.fax?order.fax:"") + "</td>"
                    + "<th width= 20px class='left'>Issued:</th>"
                    + "<td width= 45px; class='left'>" + (order.issued?order.issued:"")  + "</td>"
                    + "</tr>"
                    + "</table>"
                    + "</div>"

        var table_3 = "<div class='rightDiv'>"
                    +"<table class='rightTable' border='1'>"
                    +"<tr>"
                    +"<th width=60%>Job No.</th>"
                    +"<th>Date</th>"
                    +"</tr>"
                    +"<tr>"
                    +"<td style = 'vertical-align:middle;'>" + (order.jobNo?order.jobNo:"")  + "</td>"
                    +"<td style = 'vertical-align:middle;'>" + (order.date?order.date:"")  + "</td>"
                    +"</tr>"
                    +"</table>"
                    +"</div>";

        merginThreeTable += table_1 + table_3 + table_2 + "</div>";
        display(merginThreeTable);
        var startFormHeight = $("#startForm").outerHeight()
        countPixel += startFormHeight;

    }

    //----------------------regular instructions part--------------------
    function regularIns(){

        var instructions = (order.instructions?order.instructions:"");
        //every list is in this div, this div holds the position for all tables, close before </html>.
        var regularIns = "";

        regularIns += "<div class='regularIns' id='regularIns' style='border-style: groove;'>"
                        + "Regular Instructions:";
        regularIns +="<table width = 700px>"
                    + "<tr><td>" + ("&nbsp").repeat(12)+ (order.instructions?order.instructions:"") + "</td></tr></table><br>"
        regularIns += "</div>"
        display(regularIns);
        var regularInsHeight = $("#regularIns").outerHeight();
        countPixel += regularInsHeight;

    }
    //-----------------End of regular instructions part------------------

    //--------------------------garment part-----------------------------
    function garment(){

        var garments = (order.lineItems?order.lineItems:"");
        var lineGarments = (order.ddLineItems?order.ddLineItems:"");
        var  garmentOutput = "";
        //------------------read from the list----------------
        if (garments == "" && lineGarments == ""){
            var garmentHeader ="<div class = 'garment' id ='garment'>"
                                                        + "<div id='modifySpaceG0'></div><br>"
                                                        + "Garment:"
                                                        + "<hr><br></div>"
            display(garmentHeader);
            needPageBreak(0,"garment","modifySpaceG");
        }
        else if(!!garments){
            for( var i = 0; i < garments.length; i ++){
                var garmentHeader = getSimilarHeader(i,garmentOutput,"garment");    
                var garmentList = getSimilarList(i,garments,garmentOutput,"garment");
                var garmentFooter = getSimilarFooter(i, garments,garmentOutput , "garment");
                display(garmentHeader + garmentList + garmentFooter);
                needPageBreak(i,"garment","modifySpaceG");
            }
        }
        else if(!!lineGarments){
            for (var i = 0; i < lineGarments.length; i++){
                var garmentHeader = getSimilarHeader(i,garmentOutput,"lineGarment");
                var garmentList = getSimilarList(i,lineGarments,garmentOutput,"lineGarment");
                var garmentFooter = getSimilarFooter(i, lineGarments,garmentOutput , "lineGarment");
                display(garmentHeader + garmentList + garmentFooter);
                needPageBreak(i,"garment","modifySpaceG");
            }
        }
    }
    //-----------------------End of garment part-------------------------


    //--------------------------service part-----------------------------
    function service(){

        var services = (order.services?order.services:" ");
        var serviceOutput = "";
        if (services == " "){
            var serviceHeader = "<div class = 'service' id ='service'>"
                                                        + "<div id='modifySpaceS0'></div><br>"
                                                        + "Service:"
                                                        + "<hr><br></div>"
            display(serviceHeader);
            needPageBreak(0,"service","modifySpaceS");
        }
        else
        for (var i = 0; i < services.length; i++){

            var serviceHeader = getSimilarHeader(i,serviceOutput,"service");    
            var serviceList = getSimilarList(i,services,serviceOutput,"service");
            var serviceFooter = getSimilarFooter(i,services,serviceOutput,"service");
            display(serviceHeader + serviceList + serviceFooter);
            needPageBreak(i,"service","modifySpaceS");
        }
    }

    function packing(){

        var packagingOutput = "";
        var terms = "";
        var packages = (order.packages?order.packages:" ");
        var total = (order.total?order.total:" ");
        if(packages == " " && total == " "){
            packagingOutput = "<div class = 'packing' id ='packing'>"
                                                        + "<div id='modifySpaceP0'></div>"
                                                        + "Packaging:"
                                                        + "<hr><br></div>"
        }
        else{
            if (order.terms == "C.O.D.") terms = "C.O.D.";
            packagingOutput = "<div class = 'packing' id ='packing'>"
                            + "<div id='modifySpaceP0'></div>"
                            + "<table width = 700px>"
                            + "<tr style='border-bottom:solid 1px;'><th class='left'>Packaging:</th>"
                            + ("<td></td>").repeat(3)
                            + "</tr>"
                            + "<tr>"
                            + "<td colspan = 3>" + packages + "<br><br>" + "</td>"
                            + "<td rowspan = 2 style='border-bottom:solid 1px;font-size:2.2em;font-weight:bold;padding-left:40px;vertical-align:middle;'>"
                            + terms + "</td>"
                            + "</tr>"
                            + "<tr style='border-bottom:solid 1px;'>"
                            + "<th class='center'>Total: " + total + "</th>"
                            + ("<td></td>").repeat(2)
                            + "</tr>"
                            +"</table>"
                            + "<div id='modifySpaceP1'></div><br><br></div>";
        }
        display(packagingOutput);
        needPageBreak(0,"packing","modifySpaceP");
    }
    //-----------------------End of service part-------------------------


    //-----------------------Generate Similar list-----------------------
    function getSimilarHeader(i,output,type){

        switch (type){
            case "garment":
                if (i == 0)
                    output = "<div class='garment' id='garment" + i  +"'>"
                                + "<div id='modifySpaceG" + i + "'></div>"
                                +"<br>Garment: <table width=700px;  class = 'garmentTable'>"
                                + "<tr style='background-color:silver; border-bottom:solid 1px;'>"
                                + "<th width=25px> Type </th>"
                                + "<th width=102px> Style </th>"
                                + "<th width=102px>colour</th>"
                                + "<th width=30px>Xs</th>"
                                + "<th width=30px>S</th>"
                                + "<th width=30px>M</th>"
                                + "<th width=30px>L</th>"
                                + "<th width=30px>XL</th>"
                                + "<th width=30px>2XL</th>"
                                + "<th width=30px>3XL</th>"
                                + "<th width=30px class='right'>Other</th>"
                                + "<th width=30px class='right'>Total</th>"
                                + "<th width=25px>Type</th>"
                                + "<th width=69px>Position</th>"
                                + "<th width=69px>Design#</th>"
                                + "<tr>";
                else
                    output = "<div class='garment' id='garment" + i  +"'><table width=700px;  class ='garmentTable'>"
                            + "<div id='modifySpaceG" + (2*i) + "'></div>";
                return output;
                break;

            case "lineGarment":
                if(i == 0)
                    output = "<div class = 'garment' id = 'garment" + i + "'>"
                            + "<div id='modifySpaceG" + i + "'></div>"
                            + "<br>Garment: <table width = 700px; class ='garmentTable'>"
                            + "<tr style = 'background-color:silver;border-bottom:solid 1px;'>"
                            + "<th width = 60px class = 'left'>Style</th>"
                            + "<th width = 300px class = 'left'>Description</th>"
                            + "<th width = 60px class='right'>Quantity</th>"
                            + "<th width = 50px>Type</th>"
                            + "<th width = 70px>Position</th>"
                            + "<th width = 70px>Design#</th>"
                            + "</tr>"
                else
                    output = "<div class = 'garment' id = 'garment" + i + "'><table width = 700px; class = 'garmentTable'>"
                    + "<div id = 'modifySpaceG" + (2*i) + "'></div>";
                return output;
                break;
            case "service":
                if (i == 0){
                    output = "<div class='service' id='service" + i +"'>"
                                    + "<div id='modifySpaceS" + i + "'></div>"
                                    +"<br>Service:"
                                    + "<table width='700px' class = 'left'>"
                                    + "<tr style='background-color:silver;border-bottom:solid 1px;'>"
                                    + "<th width=120px> Service </th>"
                                    + "<th width= 200px> Description </th>"
                                    + "<th width=30px class='right'>Qty</th>"
                                    + "<th width=30px class='right'>Unit</th>"
                                    + "<th width=40px class='right'>Price</th>"
                                    + "<th width=40px class='right'>Amt</th>"
                                    + "<th width=50px class = 'right'></th>"
                                    + "<th>Remark</th>"
                                    + "<tr>";
                }
                else
                    output = "<div class='service' id='service" + i  +"'><table width=700px;  class = 'serviceTable'>"
                            + "<div id='modifySpaceS" + (2*i) + "'></div>";
                return output
                break;
            default :
                alert("type error!");
        }
    }

    function getSimilarFooter(i,lists,output,type){

        switch (type){

            case "garment":
                if (i == lists.length - 1){
                    output += "<table width=700px;  class = 'garmentTotal'><tr style='border-bottom:solid 1px;'>"
                                + "<th width='488px' class='right'>" + "Total Qty: "+ "</th>"
                                + "<th class='right' width='40px'>" + garmentsTotalQty + "</th>"
                                + ("<td></td>").repeat(2)
                                + "</tr></table></div>";
                }
                return output;
                break;

            case "lineGarment":
                if (i == lists.length - 1){
                    output += "<table width=700px; class = 'garmentTotal'><tr style='border-bottom:solid 1px;'>"
                                +"<th class='right' width = 440px'>" + "Total Qty:" + "</th>"
                                + "<th class='right' width='35px'>" + garmentsTotalQty + "</th>"
                                + ("<td></td>").repeat(2)
                                + "</tr></table></div>";
                }
                return output;
                break;

            case "service":
                if (i == lists.length - 1){
                    output += "<table width=700px;  class = 'serviceTable' >"
                                    + "<tr>"
                                    + "<td width = 331px colspan = 3></td>"
                                    + "<th width = 60px>Total Amt:</th>"
                                    + "<th class='right' width = '75px'>" + order.currency + " " + passToDecimal(servicesTotalAmt) + "</th>"
                                    + ("<td></td>").repeat(2)
                                    +"</tr></table><br></div>";
                }
                return output;
                break;

            default:
                alert("type error!");

        }
    }

    function getSimilarList(i,lists,output,type){

        switch (type){
            case ("garment"):
                var garment = lists[i];
                output += "<tr style='border-bottom:solid 1px;'>"
                        + "<td class='center' width=25px>" + (garment.type?garment.type:"") + "</td>"
                        + "<td class='center' width=101px>" + (garment.style?garment.style:"") + "</td>"
                        + "<td class='center' width=102px>" + (garment.colour?garment.colour:"") + "</td>";
                //-------------read size value--------------------
                for (var j = 0; j < garment.size.length; j++){
                    var garment_size = garment.size[j];
                    for(var k = 0; k < garment_size.length; k++)
                        output += "<td class='right' width=30px>" + (garment_size[k]?garment_size[k]:"") + "</td>";
                }

                output += "<td class='right' width=31px class='right'>" + (garment.other?garment.other:"") + "</td>"
                        +"<td class='right' width=31px class='right'>" + (garment.total?garment.total:"") + "</td>";
        
                garmentsTotalQty += parseInt((garment.total||0));
                output += "<td class='left' width= 165px colspan = 3>";
                var services = (garment.services?garment.services:"");
                var positionList = getPositionList(services,type);
                output += positionList;
                output += "</table></td>"
                output += "<div id='modifySpaceG" + ((2*i)+1) + "'></div>";
                return output;
                break;

            case ("lineGarment"):

                var garment = lists[i];
                var url = "http://192.6.2.108:8080/clivia/lib/image/getimage?thumbnail=true&id=";
                var imageUrl =(garment.imageId? url+garment.imageId:"");
                var height = "";
                if (!!imageUrl) height = "height=100px";
                var services = (garment.services?garment.services:"");
                var positionList = getPositionList(services,type);
                output += "<tr>"
                        + "<td class = 'left' width = 69px>" + (garment.itemNo||"") + "</td>"
                        + "<td class= 'left' width = 346px>" + (garment.desc||"") + "</td>"
                                              + "<td class = 'right' width = 60px>" + (garment.qty||"")+ "</td>"
                        + "<td rowspan = 2 colspan = 3 style='border-bottom:solid 1px;'>"
                        + positionList + "</table>"
                        + "</td></tr>";
                garmentsTotalQty += parseInt((garment.qty||0));
                console.log(garmentsTotalQty);
                output += "<tr style='border-bottom:solid 1px;'>"
                        + "<td width ='50px'" + height + "class='image'style='background-image:url(&quot;"
                        + imageUrl
                        +"&quot;)'></td>"
                var item_table = "";
                var subItemRows = garment.data;
                for (var j = 0; j < subItemRows.length; j++) {

                    var tOpen = "<tr><td align='left' width = 200px>";
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

                output += "<td colspan='2' id='itemTable' align='right'><table class='left'><tr height='5px'>"
                        + "</tr>" + item_table + "</table></td>"

                output += "</div>"; //--------------------------- Closes with listSpace

                return output;
                break;

            case ("service"):
                var service = lists[i];
            	var servicePrice = passToDecimal(service.price||0);
          		var serviceAmt = passToDecimal(service.amt||0);
                output += "<tr>"
                            +"<td class='left' width=120px>"+ (service.service?service.service:"") + "</td>"
                            +"<td class='left' width= 200px>"+ (service.description?service.description:"") + "</td>"
                            +"<td class='right' width=30px>"+ (service.qty?service.qty:"") + "</td>"
                            +"<td class='right' width=30px>"+ (service.unit?service.unit:"") + "</td>"
                            +"<td class='right' width=40px >"+ servicePrice + "</td>"
                            +"<td class='right' width=40px  >"+ serviceAmt + "</td>"
                            +"<td width=50px class = 'center'>" + (service.disCount?service.disCount:"") + "</td>"
                            +"<td class='left'>"+ (service.remark?service.remark:"") + "</td>"
                            +"</tr>"
                            + "<tr style='border-bottom:solid 1px;'>" + ("<td></td>").repeat(8) + "<tr>";
                            
                servicesTotalAmt += parseInt((service.amt||0));
                output +="</table>"
                output += "<div id='modifySpaceS" + ((2*i)+1) + "'></div>";
                return output;
                break;

            default:
                alert("type error!");
        }
    }
    
    function passToDecimal(string){
    	var num = parseInt(string);
    	var decimalOutput = num.toFixed(2);
    	return decimalOutput;
    }

    function getPositionList(lists,type){
        var type_pos_des_table = "<table>";
        switch (type){
            case ("garment"):
                for (var t = 0; t < lists.length; t++){
                            var list = lists[t];
                            type_pos_des_table += "<tr>"
                                        + "<td width='25px' class='center'>" + (list.deco?list.deco:"") + "</td>"
                                        + "<td width='69px' class='center'>" + (list.position?list.position:"") + "</td>"
                                        + "<td width='70px' class='center'>" + (list.designNo?list.designNo:"")  + "</td>"
                                        + "</tr>"
                }
                break;

            case ("lineGarment"):
                for (var t = 0; t < lists.length; t++){
                            var list = lists[t];
                            type_pos_des_table += "<tr>"
                                        + "<td width='55px' class='center'>" + (list.deco?list.deco:"") + "</td>"
                                        + "<td width='80px' class='center'>" + (list.position?list.position:"") + "</td>"
                                        + "<td width='75px' class='center'>" + (list.designNo?list.designNo:"")  + "</td>"
                                        + "</tr>"
                        }
                break;
            default:
                alert("type,position,design# error!");
        }
        return type_pos_des_table;
    }
    //-----------------------End of similar part-------------------------


    //--------------------------design part------------------------------
   function decoList(){

        var decoEmbs = (order.decoEmbs?order.decoEmbs:"");
        var decoSps = (order.decoSps?order.decoSps:"");
        if(!!decoEmbs && decoEmbs.length > 0){
            decoAreEmb = true;
            for(var i = 0; i < decoEmbs.length; i++){
                var decoEmbOutput = "";
                var decoEmbList = getDecoList(i,decoEmbs[i],decoEmbOutput,"decoEmb");
                display(decoEmbList);
                needPageBreak(i,"decoEmb","modifySpacedecoEmb");
            }
        }
       if(!!decoSps && decoSps.length > 0){
            decoAreSp = true;
            for(var i = 0; i < decoSps.length; i++){
                var decoSpOutput = "";
                var decoSpList = getDecoList(i,decoSps[i],decoSpOutput,"decoSp");
                display(decoSpList);
                needPageBreak(i,"decoSp","modifySpacedecoSp");
            }
         }
    }

    function getDecoList(id,deco,decoOutput,type){

        var modifyId = "modifySpace" + type;

        decoOutput += "<div class='" + type +"' id = '" + type + id + "'>"
                    + "<div id='"+ modifyId + (2*id) + "'></div>"
                    +"<table style='width:700px;border-style:solid; border-width:2px;'>";

        switch(type){

            case "decoEmb":
                var decoEmbDetail = getListDetail(id,deco,decoOutput,type,modifyId);
                return decoEmbDetail;
                break;
            case "decoSp":
                var decoSpDetail = getListDetail(id,deco,decoOutput,type,modifyId);
                return decoSpDetail;
                break;
        }
    }

    function getListDetail(id,deco,decoOutput,type,modifyId){

        if(type == "decoEmb"){
            decoOutput+= "<tr><th class='centerUnderLine' style = 'border-left-style:hidden; font-size:1.5em;text-align:left'>"
                        + (deco.designNo?deco.designNo:"") + "</th>"
                        + "<td class='centerUnderLine'>" + (deco.description?deco.description:"")+"</td>"
                        + "<td class='centerUnderLine'>"
                        + "Stitches :" + (deco.stitches?deco.stitches:"") + "</td>"
                        + "<td class='centerUnderLine' width = '190px' >"
                        + "Steps: " + (deco.steps?deco.steps:"") + "</td>"
                        + "<td class='rightUnderLine' width = '70px' >"
                        + "Subtotal: " + (deco.totalQty?deco.totalQty:"") + "</td>"
                        + "</tr>";
            decoEmbTotal += (deco.totalQty?deco.totalQty:"");
        }

        else if (type == "decoSp"){
            decoOutput+= "<tr><th class='centerUnderLine' style = 'border-left-style:hidden;font-size:1.5em;' width=145px;>"
                        + (deco.designNo?deco.designNo:"") + "</th>"
                        + "<td class='centerUnderLine'width=140px;>"
                        + (deco.description?deco.description:"")+"</td>"
                        + "<td class='centerUnderLine' width=145px;></td>"
                        + "<td class='leftUnderLine'>"
                        + "colours: "
                        + (deco.totalcolour?deco.totalcolour:"") + "</td>"
                        + "<td class='rightUnderLine' width = '70px' >"
                        + "Subtotal: "
                        + (deco.totalQty?deco.totalQty:"") + "</td>"
                        + "</tr>";
             decoSpTotal += (deco.totalQty?deco.totalQty:"");
        }

        var colourways = deco.colourways;
        //get data from the list, but first check if there is a colour index array

        for (var j = 0; j < colourways.length; j++){
            var colourway = colourways[j];
                 // colour index exist
                var bottomBorder = "";

                if (!!colourway.threads){
                    var thread = "";
                    var threadOutput = getThreadsOrColours(colourway,thread,type);
                    decoOutput += threadOutput;
                }
               else if(!!colourway.colours){
                    var colour = "";
                    var colourOutput = getThreadsOrColours(colourway,colour,type);
                    decoOutput += colourOutput;
                }

               if (!!colourway.garments){
                    var garment = "";
                    var garmentOutput = getGarments(colourway,garment);
                    decoOutput += garmentOutput;
                }
            }

            if (j == colourways.length)
                decoOutput += "</table><br><div id = '"+ modifyId + ((2*id)+1) +"'></div></div>";

            return decoOutput;
    }

    function getThreadsOrColours(colourway,output,type){

        if (type == "decoEmb"){
            output += "<tr><td colspan = 3 style='border-top-style:solid;border-width:1px;'><br><table>";
            var elements = colourway.threads;
        }
        else if (type == "decoSp"){
            output += "<tr><td colspan = 5 style='border-top-style:solid;border-width:1px;'><br><table>";
            var elements = colourway.colours;
        }

        var cLineCount = 0;
        var cLineText = "";
        //read from the colour index array

     for(var i = 0; i < elements.length; i++){

            var element = elements[i];

            switch(type){

                case "decoEmb":
                    if ( i > 7 && cLineCount > 7){
                         cLineText = "<tr>";
                         cLineCount = 0 ;
                     }
                    output += cLineText + "<td style = 'height:50px;width:5px;text-align:right;'>" + (i+1)
                            + "<td width=40px><div style = 'height:25px; border-style:solid; border-width:1px' class='center'>"
                            + (element.code?element.code:"") + "<br>"
                            + (element.colour?element.colour:"") + "<br>"
                            +"</div>"
                            + "<div style ='height:5px; border-style:solid; border-width:1px;"
                            + "background-color:" + (element.hexColour?element.hexColour:"") + "'>"
                            +"</div></td></td>";
                    break;

                case "decoSp":

                    output += cLineText + "<td style = 'height:50px; width:5px; text-align:right;'>" + (i+1)
                            + "<td width= 41px> <div style = 'height:35px; width:42px; border-style:solid; border-width:1px' class='left'>"
                            + (element.colour?element.colour:"") + "<br>"
                            +"</div></td></td>";
                    break;
            }
            cLineCount ++;
            cLineText = "";
        }

        output += "</tr></table>";

        if (type == "decoEmb"){
            output += "<td class='left' colspan = 1 >" + ("&nbsp").repeat(5)
                    + "Running Step:" + "<br><br>"
                    +"<div style='font-weight:bold;font-size:1.2em'>" + ("&nbsp").repeat(10)
                    + (colourway.runningStep?colourway.runningStep:"") + "</div></td>"
                    +"</td>"
                    +"<td class = 'right' style = 'vertical-align:bottom;'>Subtotal: "
                    +(colourway.totalQty?colourway.totalQty:"") + "</td>"
                    +"</tr>"
        }
        return output;
    }


    function getGarments(colourway,garmentOutput){

        var garments = colourway.garments;
        var bottomBorder = "border-bottom-style:solid; border-width:1px;";

        for( i = 0; i < garments.length; i++){
            var garment = garments[i];
            garmentOutput += "<tr>"
                    +"<td style='"+ bottomBorder + "'>" + (garment.style?garment.style:"") + "</td>"
                    +"<td style='"+ bottomBorder + "'>" +(garment.colour?garment.colour:"") +"</td>"
                    + "<th width='120px' class='left' style='"+ bottomBorder + ";font-size:1.1em;'>" + (garment.position?garment.position:"") + "</th>"
                    + "<td class='left' style='"+ bottomBorder + "'>" + (garment.sizes?garment.sizes:"") + "</td>"
                    + "<td class='right' style='"+ bottomBorder + "'>" + (garment.totalQty?garment.totalQty:"") + "</td>"
                    +"</tr>";
        }

        return garmentOutput;
    }
    //------------------------End of design part-------------------------


    //-----------------------special Instructions------------------------
    function specialInstruction(){

            var special = (order.special?order.special:"");

            var sInsOutput = "<div id='specialIns' class='specialIns'>"
                            +"<div id='modifySpaceI0'></div>"
                            +"<div width=700px; style='border-style: groove;'>"
                            + "Special Instructions:";
            sInsOutput += "<table width = 700px>"
                        + "<tr><td>" +("&nbsp").repeat(4) + special + "</td></tr></table>";
            sInsOutput += "<div id='modifySpaceI1'></div></div><br></div>"
            display(sInsOutput);
            needPageBreak(0,"specialIns","modifySpaceI");
        }
        //-------------------End of special Instructions---------------------

    //--------------------------ilustration------------------------------
    function ilustration(){

        var images = (order.image?order.image:"");

                    var row = 2;// use to adjust <div id number> if i=3 ilustration2 (1 difference)if i = 5 ilustration3 (2 difference) .....
                    //there should be a for loop here

                    for (var i = 0; i < images.length; i++){

                        var image = images[i];


                        if (i == 0 && (images.length - 1) != 0){

                            var ilusOutput = "<div class='ilustration' id='ilustration" + i + "' >"
                                    +"<div id='modifySpaceL" + i +"'></div>"
                            ilusOutput += "Ilustration of Placements:<br><br>";
                            ilusOutput += "<table width = 700px>"
                                    + "<tr>"
                                    + "<td style = 'width:150px; height:150px;'class='center'>"
                                    +"<img src = '" + (image.link?image.link:"") + "' style=' height:auto;width: auto;     max-width: 150px; max-height: 150px;'></img></td>"
                                    + "<td>" + (image.remark?image.remark:"") + "</td>"
                        }
                        else if ( i % 2 == 1){
                            ilusOutput 	+= "<td style = 'width:150px; height:150px;' class='center'>"
                                        + "<img src = '" + (image.link?image.link:"") + "' style=' height:auto;width: auto; max-width: 150px; max-height: 150px;'></img>"
                                        +"</td>"
                                        + "<td>" + (image.remark?image.remark:"") + "</td>"
                                        + "</tr>"
                                        + "</table>"
                                        + "<div id='modifySpaceL" + i + "'></div>"
                            ilusOutput += "</div>"
                            display(ilusOutput);
                            if(i == 1)
                                needPageBreak((i - 1),"ilustration","modifySpaceL");
                            if(i > 1){
                                needPageBreak((i - row),"ilustration","modifySpaceL");
                                row++;
                            }
                        }
                        else if (i % 2 == 0 && i != 0 && i != images.length - 1){
                            if(i == 2) var number = i - 1;
                            else if ( i > 2) var number = i / 2;
                            var ilusOutput = "<div class='ilustration' id='ilustration" + number + "' >"
                                    +"<div id='modifySpaceL" + i +"'></div>"
                            ilusOutput += "<table width = 700px>"
                                    + "<tr>"
                                    + "<td style = 'width:150px; height:150px;'class='center'>"
                                    +"<img src = '" + (image.link?image.link:"") + "' style=' height:auto;width: auto;     max-width: 150px; max-height: 150px;'></img></td>"
                                    + "<td>" + (image.remark?image.remark:"") + "</td>"
                        }

                        else if (i % 2 == 0 && i == images.length - 1 && images.length != 1){
                            if(i ==2) var number = i - 1;
                            else var number = i / 2;
                            var ilusOutput = "<div class='ilustration' id='ilustration" + number + "' >"
                                    +"<div id='modifySpaceL" + i +"'></div>"
                            ilusOutput += "<table width = 350px>"
                                    + "<tr>"
                                    + "<td style = 'width:150px; height:150px;'class='center'>"
                                    +"<img src = '" + (image.link?image.link:"") + "' style=' height:auto;width: auto;     max-width: 150px; max-height: 150px;'></img></td>"
                                    + "<td>" + (image.remark?image.remark:"") + "</td>"
                                    + "</tr>"
                                    + "</table>"
                                    + "<div id='modifySpaceL" + i + "'></div>"
                            ilusOutput += "</div>"
                            display(ilusOutput);
                            needPageBreak((i - row + 1),"ilustration","modifySpaceL");
                        }
                        else if (images.length == 1){

                            var ilusOutput = "<div class='ilustration' id='ilustration" + i + "' >"
                                    +"<div id='modifySpaceL" + i +"'></div>"
                            ilusOutput += "Ilustration of Placements:<br><br>";
                            ilusOutput += "<table width = 350px>"
                                    + "<tr>"
                                    + "<td style = 'width:150px; height:150px;'class='center'>"
                                    +"<img src = '" + (image.link?image.link:"") + "' style=' height:auto;width: auto;     max-width: 150px; max-height: 150px;'></img></td>"
                                    + "<td>" + (image.remark?image.remark:"") + "</td>"
                                    + "</tr>"
                                    + "</table>"
                                    + "<div id='modifySpaceL" + (i+1) + "'></div>"
                            ilusOutput += "</div>"
                            display(ilusOutput);
                            needPageBreak(i,"ilustration","modifySpaceL");
                        }
                    }
    }
    //-------------------End of ilustration Instructions-----------------

    //------------------------Production info----------------------------
    function productionInfo(){

        endOrder = true;

        var productInfo="<div id='productInfo' id='productInfo'>"
                    + "<div id='modifySpacePr0'></div>"
                    +"<br><br>Production Check List:<br>"
                    + "<table width=700px><tr><td width=50%>Emb.Operator:</td><td>Q.C.:</td></tr></table><br>"
                    + "<table width=700px><tr style='height:15px;text-align:left;'>"
                    + "<td width=12px><div style='border-style:solid; border-width:1px;width:10px;height:10px'></div></td><th width=40px>Gar.Styl</th>"
                    + "<td width=12px'><div style='border-style:solid; border-width:1px;width:10px;height:10px'></div></td><th width=35px>Colour</th>"
                    + "<td width=12px><div style='border-style:solid; border-width:1px;width:10px;height:10px'></div></td><th width=25px>Logo</th>"
                    + "<td width=12px><div style='border-style:solid; border-width:1px;width:10px;height:10px'></div></td><th width=60px>Colour Way</th>"
                    + "<td width='12px'><div style='border-style:solid; border-width:1px;width:10px;height:10px'></div></td><th width=50px>Placement</th>"
                    + "<td width='12px'><div style='border-style:solid; border-width:1px;width:10px;height:10px'></div></td><th width=65px>Backing</th>"
                    + "<td width='15px'><div style='border-style:solid; border-width:1px;width:10px;height:10px'></div></td><th width =55px>Logo</th>"
                    + "<td width='15px'><div style='border-style:solid; border-width:1px;width:10px;height:10px'></div></td><th width=80px>Placement</th>"
                    + "<td width='15px'><div style='border-style:solid; border-width:1px;width:10px;height:10px'></div></td><th>Hoop Mark</th>"
                    + "</tr></table>";

        productInfo += "<br>Production Information:<br>"
                    + "<table width=695px>"
                    + "<tr style='border-top-style:solid;border-bottom-style:solid;border-width:1px;'>"
                    + "<td width='12%'>Name</td>"
                    + "<td width='12%'>Design#</td>"
                    + "<td width='12%'>Service</td>"
                    + "<td>Quantity</td>"
                    + "<td>Date</td>"
                    + "<td width=12%>Name</td>"
                    + "<td width='12%'>Design#</td>"
                    + "<td width='12%'>Service</td>"
                    + "<td>Quantity</td>"
                    + "<td>Date</td>"
                    + "</tr>"
                    + "<tr style='height:30px;border-bottom: 1px dashed #000;'>"+ ("<td>").repeat(4) + "<td style='border-right: 1px dashed #000;'></td>" + ("<td>").repeat(5)+ "</tr>"
                    + "<tr style='height:30px;border-bottom: 1px dashed #000;'>"+ ("<td>").repeat(4) + "<td style='border-right: 1px dashed #000;'></td>" + ("<td>").repeat(5)+ "</tr>"
                    +"</table>"
                    + "<div id='modifySpacePr1'></div>"
                    +"</div>"

        display(productInfo);
        needPageBreak(0,"productInfo","modifySpacePr");

    }
    //----------------------End of Production info-----------------------


    //-----------------------page break check ---------------------------
    function needPageBreak(i,lists,modify){

        if (lists == "garment" || lists == "service" || lists == "decoEmb" || lists == "ilustration" || lists == "decoSp"){
            var listSpace = lists + i;
            if(lists == "ilustration")
                var listHeight = $("#" + listSpace).outerHeight() + 2;
            else
                var listHeight = $("#" + listSpace).outerHeight();
        }
        else{
            var listSpace = lists;
            var listHeight = $("#" + lists).height();
        }
        countPixel += listHeight;

        if(countPixel > breakPixel){

            var thisListHeight = listHeight;
            countPixel = countPixel - thisListHeight;
            totalPage = currentPage + 1;

            var continuePage = "footDiv";
            var footer = getFooter(continuePage,lists,listHeight);

            if (i == 0)
                var modify = modify + i ;
            else{
                var modify = modify + (2 * i);
            }
            $("#" + modify).html(footer);
        }

        if (endOrder == true){
            var footer = getFooter(continuePage,lists);
            display(footer)
        }
    }
    //-----------------------End of page break check---------------------


    //--------------------------page break  -----------------------------
    function getFooter(page,position,listHeight){
        currentPage++;

        if (endOrder == true)
            totalPage = currentPage;

        else totalPage = currentPage + 1;

        var errorPixel = 5;
        var errorPixel2 = 10;

        if (currentPage == 1)
            var margin = (pagePixel - countPixel) + errorPixel;

        if (currentPage != 1)
            var margin = (pagePixel - countPixel) - errorPixel2;

        if (listHeight == 0){
            var footer = "<div class='" + page + "'></div>"
        }


        else{

            if(listHeight >= pagePixel){
                nextPage = currentPage + 1;
            }

            var footer = "<div class='" + page + "' style = 'margin-top:" + margin +"px' id='footer" + currentPage + "'>"
                    +"<table width=700px; style='border-top-style:solid;border-width:1px'>"
                    +"<tr>"
                    +"<td width='130px'>Invoice#</td>"
                    +"<td width='100px'>By:</td>"
                    +"<td width='160px'>Date: </td>"
                    + "<td width='130px'>" + Date().substring(25,Date() - 1)+ "</td>"
                    +"<td id = 'total" + currentPage+ "' class='right'> Page" + ("&nbsp;").repeat(2) + currentPage + " of " + totalPage + "</td>"
                    +"<td class='right'>#" + (order.jobNo?order.jobNo:"") + "</td>"
                    +"</tr>"
                    +"</table>"
                    +"</div>"
            if (position == "garment"){
                footer += getSimilarHeader(0,"","garment");
                var errorPixel = 5;
                countPixel = 0;
                countPixel += (listHeight - errorPixel); // this listHeight include header height
            }
            else if (position == "lineGarment"){
                footer += getSimilarHeader(0,"","lineGarment");
                var errorPixel = 5;
                countPixel = 0;
                countPixel += (listHeight - errorPixel); // this listHeight include header height
            }
            else if (position == "service"){
                footer += getSimilarHeader(0,"","service");
                var errorPixel = 5;
                countPixel = 0;
                countPixel += (listHeight - errorPixel); // this listHeight include header height
            }
            else {
                var errorPixel = 45;
                countPixel = 0;
                countPixel += (listHeight - errorPixel);
            }

            if (endOrder == true){
                for (var i = 1; i < totalPage; i ++){
                    if (i < totalPage){
                        if (i == nextPage){
                            $("#footer" + i).html("<table></table>");
                            $("#footer" + i).css("margin-top",margin);
                        }
                        var	newFooter = "Page" + ("&nbsp;").repeat(2) + i + " of " + totalPage;
                        $("#total" + i).html(newFooter);
                    }
                }
            }
        }
        return footer;
    }
    //----------------------End of page break  --------------------------


    //-----------------------display function----------------------------
    function display(output){
        document.getElementById("everything").innerHTML += output;
    }

    function modifyTitle(){
        var typeOutput = " ";

        if (decoAreEmb == true) typeOutput += "(Embroidery " + "Total: " + decoEmbTotal + ") ";
        if (decoAreSp == true) typeOutput += "(Screen Printing " + "Total: " + decoSpTotal + ") ";
        if (decoAreHp == true) typeOutput += "(Heat Printing " + "Total: " + decoSpTotal + ") ";
        $("#modifyType").html(typeOutput);
    }

    //----------------------End of display function----------------------


    //-----------------------End of display all part---------------------
}
</script>

<div id="everything" class="everything">
</div>
</body>
</html>
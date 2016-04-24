<!DOCTYPE html>

<html>

<style>

body{
	font-family: "Times New Roman";
	font-weight:normal;
}
img {
	position:absolute;
//	height:90px;
	width:180px;
	top:30px;
}
#bold{font-weight:bold;}
#w-1{font-weight:100;}
#ship{position:absolute;left:350px;}
#left{text-align:left;}
#right{vertical-align:left;}

.info {
	position:absolute;
	top: 8px;
	left:220px;
	font-size:60%;
}
.order{
	position:absolute;
	table-layout:fixed;
	left:-110px;
	top: -10px;
}
table{
	border-collapse:collapse;	
}
.toLeft{
	position:absolute;
	text-align:left;
}
h2{
	position:absolute;
	top: -20px;
	left:500px;
}
.invoiceInfo{
	position:absolute;
	left:560px;
	top:45px;
	font-size:70%;
}

.billShip{
	position:absolute;
	width:700px;
	top:70px;
	font-size:70%;
}
.contact{
	position:absolute;
	width:700px;
	top:235px;
	font-size:70%;
}

.formTable{
	position:absolute;
	width:700px;
	top:250px;
	font-size:70%;
}

.listTable{
	position:absolute;
	width:700px;
	top:295px;
	font-size:70%;
}
.testInfo{
	position:absolute;
	bottom:-400px;
	font-size:70%;
}
.totalTable{
	position:absolute;
	bottom:400px;
/* 	font-size:70%; */
	font-weight: bold;
}

tr.mainrow{
/* 	font-weight: bold; */
}

td.bold{
	font-weight: bold;
	font-size:110%;
}

td{
	text-align:center;
}
.left{
	text-align:left;
}
.right{
	text-align:right;
}
.center{
	text-align:center;
}
.customer{
	position:absolute;
	top:16px;
	left:60px;
}
.totalQty{
	position:relative;
	width:700px;
	left:0px;
	text-align:left;
}

.header{
	position:absolute;
	white-space: nowrap;
}
.left_bottom{
	text-align:left;
	vertical-align:bottom;
}
.image {
    background-repeat:no-repeat;
    background-size:auto 80px;
    background-position: 0px 10px; 
}

</style>

<script>
"use strict";



window.onload = function() {

        var printModel = ${data.data};
        
        var printAddress=function(isBilling,address){
        	var line=isBilling?"bill":"ship",lineNo=0;
        	
    		document.getElementById(line+lineNo++).innerHTML = "<br><br>" +(address.receiver?address.receiver:"");

    		if(!!address.addr1)
    			document.getElementById(line+lineNo++).innerHTML = address.addr1;
    		
    		if(!!address.addr2)
    			document.getElementById(line+lineNo++).innerHTML = address.addr2;
    			
    		//city,po,pro	
    		var t="";
    		if (!!address.city)
    			t += ",&nbsp;" + address.city;
    		if(!!address.province)
    			t += ",&nbsp;" + address.province;
    		if(!!info.billTo.postalCode)
    			t += ",&nbsp;" +address.postalCode;
    			
    		if(t)
    			t = t.substring(7);
    		
            document.getElementById(line+lineNo++).innerHTML = t;
    		
    		if(!!address.country)
    			document.getElementById(line+lineNo++).innerHTML = address.country;
    			
    		document.getElementById(line+lineNo++).innerHTML = (address.attn?"attn:"+ address.attn:"")  + "<br><br>";
        }
	   

	
        var info = printModel.info;
        //Order table
        document.getElementById("orderDate").innerHTML = "&nbsp;&nbsp;" + info.orderDate + "&nbsp;&nbsp;";
        document.getElementById("orderNo").innerHTML = "&nbsp;&nbsp;" + info.orderNo + "&nbsp;&nbsp;";
        document.getElementById("poNo").innerHTML = "&nbsp;&nbsp;"+(info.poNo?info.poNo:'')+"&nbsp;&nbsp;";
		
        printAddress(true,info.billTo);
        printAddress(false,info.shipTo);
			
        //----------------customer& part-------------------
		var contactInfo="";
		if (!!info.contact.name)
			contactInfo += ",&nbsp;" + info.contact.name;
		if(!!info.contact.phone)
			contactInfo += ",&nbsp;" + info.contact.phone;
		if(!!info.contact.email)
			contactInfo += ",&nbsp;" +info.contact.email;
		if(contactInfo)
			contactInfo = contactInfo.substring(7);
			
		document.getElementById("contact").innerHTML = contactInfo;
		document.getElementById("terms").innerHTML = info.terms;
		document.getElementById("shipDate").innerHTML = info.shipDate;
		document.getElementById("rep").innerHTML = info.rep;
		document.getElementById("cancelDate").innerHTML = info.cancelDate;
		
		//------------------------list part-------------------------
		//list header part
		var wholeTable ="";
		wholeTable += "<table width='700px'  class='myTable'>"
						+ "<tr id='left'>"
						+"<th width='60px' style='border-bottom:1pt solid black;'>Style</th>"
						+"<th width='300px' style='border-bottom:1pt solid black;'>Description</th>"
						+"<th align='right' style='border-bottom:1pt solid black;'>Quantity</th>"
						+"<th align='right' style='border-bottom:1pt solid black;'>Price</th>"
						+"<th align='right' style='border-bottom:1pt solid black;'>% Off</th>"
						+"<th align='right' style='border-bottom:1pt solid black;'>Net</th>"
						+"<th align='right' style='border-bottom:1pt solid black;'>Amount</th>"
						+"</tr>"
						
		//out table part
        var items = printModel.items;
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
			wholeTable += "<tr class='mainrow'><td class='left'>" + item.itemNo 
						+ "</td><td class='left'>" + item.desc 
						+ "</td><td class='right bold'>" + item.qty 
						+ "</td><td class='right'>" + item.listPrice 
						+ "</td><td class='right'>" + item.discount
						+ "</td><td class='right bold'>" + item.price 
						+ "</td><td class='right bold'>" + item.amt 
						+ "</td></tr>" 

            var subItemRows = item.data;
			
			if(subItemRows){
				//image part			
				var url = "http://192.6.2.108:8080/clivia/lib/image/getimage?thumbnail=true&id=";
				var imageUrl =item.imageId? url+item.imageId:"";
				wholeTable += "<tr><td width = '50px' class='image'style='background-image:url(&quot;" 
							+ imageUrl 
							+"&quot;)'></td>" 
							
				//item Table part
				var item_table = "";
	            var subItemRows = item.data;
	            for (var j = 0; j < subItemRows.length; j++) {
	            	
	                item_table += "<td><tr width='30px'>";
	                
	                var tOpen = "<td class='left'>";
	                var tClose = "</td>";
	                var subItemCols = subItemRows[j];
	                
	                for (var k = 0; k < subItemCols.length; k++) {
						if(k == 0) item_table += tOpen + (subItemCols[k] ? subItemCols[k] : "") + tClose;
						else {if(k < subItemCols.length - 1)  item_table += "<td class='right' width='30px'>" + (subItemCols[k] ? subItemCols[k] : "") + tClose;
						else item_table += "<td class='right' width='50px'>" 
									+ (subItemCols[k] ? subItemCols[k] : "") 
									+ tClose;}
	                }
	                item_table += "</td></tr>";
	            }
				wholeTable += "<td colspan='2' id='itemTable'><table width ='400px' class='left'><tr height='5px'><td></td></tr>" + item_table + "</table><br><br><td colspan='4' id='quote'></td>";
			}
        }
		
		//total count part
		
		var qtyList="<table class='totalQty'>"
					+"<hr>"
					+"<tr>"
					+"<th style='width:35px; vertical-align:text-top;'>"+(info.remark?"Remark:":"")+"</th>"
					+"<td id='remark' colspan='2' class='left' style='word-spacing:none; width:100px'>" + (info.remark?info.remark:"") + "</td>"
					+"<th style='width:10px; vertical-align: text-top;'>Total:</th>"
					+"<td id='totalQty' colspan='2' style='text-align:left;vertical-align: text-top'>" + info.totalQty+ "</td>"
					+"<td id='totalAmt' colspan='2' style='text-align:right;vertical-align: text-top'>" + info.totalAmt+ "</td>"
					+"</tr>"
					+"</table><br><br>";
		wholeTable += qtyList;
	  
		document.getElementById("wholeTable").innerHTML = wholeTable;

    } 
    
</script>

<body>
<!--Order Confirmation start here-->
<img src="..\resources\images\DD LOGO.jpg" alt="logo">
<div class="info">
<!-- <h4 class="compHeader">SITICHES CREATION INC.</h4> -->
<p style="white-space: nowrap;" ;>
<b>SITICHES CREATION INC.</b><br>
3889 Keith Street, Unit D<br>
Burnaby, BC, V5J 5K4  Canada<br>
Tel: (604)873-8901   Fax:(604)873-8902<br>
info@scdeco.com&nbsp;&nbsp;&nbsp;www.ScDeco.com<br>
</p>
</div>
<h2 class="header">Order Confirmation</h2>
<div class="invoiceInfo">
<table class="order" border="1" top = "0px" height="50px" width="250px" >
<tr>
<th width="110px">P.O.#</th>
<th width="70px">Date</th>
<th width="70px" style="white-space: nowrap;">&nbsp;Our Order#&nbsp;</th>
<tr>
<td style="width:10em; word-wrap: break-word;"id="poNo"></td>
<td width="70px" style="white-space: nowrap;" id="orderDate"></td>
<td width="70px" style="white-space: nowrap;" id="orderNo"></td>
</tr>
</table>
</div>

<!--billTo ShipTo Table part-->
<div class="billShip">
<br>
<tr>
<br><br>
<table width="700px">
<tr bgcolor="#C0C0C0">
<th class="left">Bill To:</th>
<th id="ship">Ship To:</th>
</tr>
<table>
<table width="350px" align="center" style="position:absolute; left:0px;">
<tr><td width="100px"></td><td class="left" id="bill0"></td></tr>
<tr><td width="100px"></td><td class="left" id="bill1"></td></tr>
<tr><td width="100px"></td><td class="left" id="bill2"></td></tr>
<tr><td width="100px"></td><td class="left" id="bill3"></td></tr>
<tr><td width="100px"></td><td class="left" id="bill4"></td></tr>
<tr><td width="100px"></td><td class="left" id="bill5"><br><br></td></tr>
</table>
<table width="350px" align="center" style="position:absolute; left:350px;">
<tr><td width="100px"></td><td class="left" id="ship0"></td></tr>
<tr><td width="100px"></td><td class="left" id="ship1"></td></tr>
<tr><td width="100px"></td><td class="left" id="ship2"></td></tr>
<tr><td width="100px"></td><td class="left" id="ship3"></td></tr>
<tr><td width="100px"></td><td class="left" id="ship4"></td></tr>
<tr><td width="100px"></td><td class="left" id="ship5"><br><br></td></tr>
</table>
</div>


<!--contact part-->
<div class="contact">
<table width="700px">
<tr>
<th width="10px" align="left">Contact:</th>
<td class="left" id="contact"></td>
</tr>
</table>
</div>


<div class='formTable'>
<table width="700px" border = "1">
<tr>
<th width="175px">Sales REP.</th>
<th width="175px">Terms</th>
<th width="175px">Ship Date</th>
<th width="175px">Cancel Date</th>
</tr>
<tr>
<td id="rep"></td>
<td id="terms"></td>
<td id="shipDate"></td>
<td id="cancelDate"></td>
</tr>
</table>
</div>

<div class="listTable" id="wholeTable">
</div>
</body>
</html>
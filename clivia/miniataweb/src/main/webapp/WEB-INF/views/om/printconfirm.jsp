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
	left:-50px;
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
	top: -10px;
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
	top:230px;
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
	left:413px;
	text-align:left;
	font-weight: bold;
}

.totalAmt{
	position:relative;
	top:-40px;
	left:600px;
	font-weight: bold;
}

.remark{
	position:relative;
 	top:-52px; 
	/* left:10px; */
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

       // var printModel = ${data.data};
	   
	var printModel = ${data.data};
        var info = printModel.info;
        //Order table
        document.getElementById("orderDate").innerHTML = info.orderDate;
        document.getElementById("orderNo").innerHTML = info.orderNo;
        document.getElementById("poNo").innerHTML = info.poNo;
        //bill to address partw
        document.getElementById("billAddr1").innerHTML = "<br><br>" +info.company+ "<br><br>" + info.billTo.addr1;
        document.getElementById("billAddr2").innerHTML = info.billTo.addr2;
        document.getElementById("billAddr3").innerHTML = info.billTo.city + ",&nbsp" + info.billTo.province + ",&nbsp" + info.billTo.postalCode;
        document.getElementById("billCountry").innerHTML = info.billTo.country;
        if (info.billTo.attn == null)
            document.getElementById("billAttn").innerHTML = (info.billTo.attn ? info.billTo.attn : "") + "<br><br>";
        else
            document.getElementById("billAttn").innerHTML = "attn:" + info.billTo.attn + "<br><br>";
        //ship to address part
        document.getElementById("shipAddr1").innerHTML = "<br><br>" + info.shipTo.addr1;
        document.getElementById("shipAddr2").innerHTML = info.shipTo.addr2;
        document.getElementById("shipAddr3").innerHTML = info.shipTo.city + "," + info.shipTo.province + "," + info.shipTo.postalCode;
        document.getElementById("shipCountry").innerHTML = info.shipTo.country;
        if (info.shipTo.attn == null)
            document.getElementById("shipAttn").innerHTML = (info.shipTo.attn ? info.shipTo.attn : "") + "<br><br>";
        else
            document.getElementById("shipAttn").innerHTML = "attn: " + info.shipTo.attn + "<br><br>";
			
        //customer& part
        if (printModel.info.contact.phone == null)
            document.getElementById("contact").innerHTML = info.contact.name + ",&nbsp" + info.contact.email;
        else 
			document.getElementById("contact").innerHTML = info.contact.name + ",&nbsp" + info.contact.phone + ",&nbsp" + info.contact.email;
		document.getElementById("terms").innerHTML = info.terms;
		document.getElementById("shipDate").innerHTML = info.shipDate;
		document.getElementById("rep").innerHTML = info.rep;
		document.getElementById("cancelDate").innerHTML = info.cancelDate;
		
		//list part
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

		var totalQty="<table class='totalQty'>"
					+"<hr>"
					+"<tr>"
					+"<th>Total:</th>"
					+"<td id='totalQty'>" + info.totalQty + "</td>"
					+"</tr>"
					+"</table><br><br>";
					
		var totalAmt="<table class='totalAmt'>"
					+"<tr>"
					+"<th width='50px' id='left'></th>"
					+"<td>"+ info.totalAmt +"</td>"
					+"</tr>"
					
		var remark="<table class='remark'>"
					+"<tr>"
					+"<td><b>Remark:</b></td>"
					+"<td>" + info.remark + "</td>"
					+"</tr>"
					+"</table>";
		
					
		wholeTable += totalQty + totalAmt;
	    if(info.remark)
	    	wholeTable +=remark;
		
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
<table class="order" border="1" top = "0px" width = "200px">
<tr>
<th>P.O.#</th>
<th>Date</th>
<th>Our Order#</th>
<tr>
<td id="poNo"></td>
<td id="orderDate"></td>
<td id="orderNo"></td>
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
<table width="700px" align="center">
<tr><td width="100px"></td><td class="left" id="billAddr1"></td><td width="100px"></td><td class="left_bottom" id="shipAddr1"><br><br></td></tr>
<tr><td width="100px"></td><td class="left" id="billAddr2"></td><td width="100px"><td class="left" id="shipAddr2"></td></tr>
<tr><td width="100px"></td><td class="left" id="billAddr3"></td><td width="100px"><td class="left" id="shipAddr3"></td></tr>
<tr><td width="100px"></td><td class="left" id="billCountry"></td><td width="100px"><td class="left" id="shipCountry"></td></tr>
<tr><td width="100px"></td><td class="left" id="billAttn"><br><br></td><td width="100px"><td class="left" id="shipAttn"><br><br></td></tr>
</table>
<table>
</table><br>
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
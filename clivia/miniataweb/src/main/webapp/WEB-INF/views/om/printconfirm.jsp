<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html>

<style>

body{
	font-family: "Times New Roman";
	font-weight:normal;
}
img {
	position:absolute;
	height:90px;
	width:150px;
	top:14px;
}
#bold{font-weight:bold;}
#w-1{font-weight:100;}
#ship{position:absolute;left:350px;}
#left{text-align:left;}
#right{vertical-align:left;}
.info {
	position:absolute;
	top: 0px;
	left:170px;
	font-size:70%;
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
	width:400px;
	top:150px;
	font-size:70%;
}
.testInfo{
	position:absolute;
	bottom:-400px;
	font-size:70%;
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
.totalFee{
	position:relative;
	top:-40px;
	left:600px;
}
.customer{
	position:absolute;
	top:16px;
	left:60px;
}
.totalQuant{
	position:relative;
	left:450px;
	text-align:left;
}
.header{
	position:absolute;
	white-space: nowrap;
}
</style>

<script>
"use strict";

window.onload = function() {

        var printModel = ${data.data};

        var info = printModel.info;
        //Order table
        document.getElementById("orderDate").innerHTML = info.orderDate;
        document.getElementById("orderNo").innerHTML = info.orderNo;
        document.getElementById("poNo").innerHTML = info.poNo;
        //bill to address partw
        document.getElementById("billAddr1").innerHTML = "<br><br>" + info.billTo.addr1;
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
        document.getElementById("shipAddr3").innerHTML = info.shipTo.city + "," + info.billTo.province + "," + info.billTo.postalCode;
        document.getElementById("shipCountry").innerHTML = info.shipTo.country;
        if (info.shipTo.attn == null)
            document.getElementById("shipAttn").innerHTML = (info.shipTo.attn ? info.shipTo.attn : "") + "<br><br>";
        else
            document.getElementById("shipAttn").innerHTML = "attn: " + info.shipTo.attn + "<br><br>";
        //customer& part
        document.getElementById("company").innerHTML = info.company;
        if (printModel.info.contact.phone == null)
            document.getElementById("contact").innerHTML = info.contact.name + ",&nbsp" + info.contact.email;
        else 
			document.getElementById("contact").innerHTML = info.contact.name + ",&nbsp" + info.contact.phone + ",&nbsp" + info.contact.email;
        document.getElementById("terms").innerHTML = info.terms;
        document.getElementById("shipDate").innerHTML = info.shipDate;
		document.getElementById("rep").innerHTML = info.rep;
		document.getElementById("cancelDate").innerHTML = info.cancelDate;
        
		//list part
        var items = printModel.items;
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            var output = "";
            var subItemRows = item.data;
            for (var j = 0; j < subItemRows.length; j++) {
                output += "<tr width='30px'>";
                var tOpen = j === 0 ? "<th class='left'>" : "<td class='left'>";
                var tClose = j === 0 ? "</th>" : "</td>";
                var subItemCols = subItemRows[j];
                for (var k = 0; k < subItemCols.length; k++) {
					if(k == 0) output += tOpen + (subItemCols[k] ? subItemCols[k] : "") + tClose;
					else {if(k < subItemCols.length - 1)  output += "<td class='right' width='30px'>" + (subItemCols[k] ? subItemCols[k] : "") + tClose;
					else output += "<td class='right' width='50px'>" + (subItemCols[k] ? subItemCols[k] : "") + tClose;}
					//else if (k > 0 && k < subItemCols.length - 1) output += "<th class='right' width='10px'>" + (subItemCols[k] ? subItemCols[k] : "") + tClose;
                   // else output += tOpen + (subItemCols[k] ? subItemCols[k] : "") + tClose;
                }
                output += "</tr>"
            }
            document.getElementById("output").innerHTML += "<tr><td class='left'>" + item.itemNo + "</td><td class='left'>" + item.desc + "</td><td class='right'>" + item.qty + "</td><td class='right'>" + item.price + "</td><td class='right'>" + item.amt + "</td></tr> <tr><td  width = '100px'></td><td id='itemTable'><table width ='400px' class='left'><tr height='5px'><td></td></tr>" + output + "</table><br><br>";
        }
        //total count part
        document.getElementById("totalAmt").innerHTML = info.totalAmt;
        document.getElementById("totalQty").innerHTML = info.totalQty;
    } 
</script>

<body>
<!-- Invoice start here-->
<img src="..\resources\images\DD LOGO.png" alt="logo">
<div class="info">
<h4 class="compHeader">SITICHES CREATION INC.</h4>
<p style="white-space: nowrap; top:50px" ;>
3889 Keith Street, Unit D<br>
Burnaby, BC, V5J 5K4  Canada<br>
Tel: (604)873-8901   Fax:(604)873-8902<br>
info@stichescreation.com<br>
www.ScDeco.com<br>
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

<!--customer space modify here-->
<div class="billShip">
<br>
<tr>
<table width="700px">
<tr>
<th align="left" width="10px">CUSTOMER:</th>
<td class="left" id="company"></td>
</tr>
<tr>
<th width="10px" align="left">CONTACT:</th>
<td class="left" id="contact"></td>
</tr>
</table>

<br><br>

<table width="700px">
<tr bgcolor="#C0C0C0">
<th class="left">Bill To:</th>
<th id="ship">Ship To:</th>
</tr>
<table>
<table width="700px" align="center" >			<!-- frame="box" -->
<tr><td width="100px"></td><td class="left" id="billAddr1"><br><br></td><td width="100px"></td><td class="left" id="shipAddr1"><br><br></td></tr>
<tr><td width="100px"></td><td class="left" id="billAddr2"></td><td width="100px"><td class="left" id="shipAddr2"></td></tr>
<tr><td width="100px"></td><td class="left" id="billAddr3"></td><td width="100px"><td class="left" id="shipAddr3"></td></tr>
<tr><td width="100px"></td><td class="left" id="billCountry"></td><td width="100px"><td class="left" id="shipCountry"></td></tr>
<tr><td width="100px"></td><td class="left" id="billAttn"><br><br></td><td width="100px"><td class="left" id="shipAttn"><br><br></td></tr>
</table>
<table>
</table><br>

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

<br>
<br>
<table width="700px"  id="output" class="myTable">
<tr id="left">
<th width="60px" align="left" style="border-bottom:1pt solid black;">Style</th>
<th align="left" width="300px" style="border-bottom:1pt solid black;">Description</th>
<th align="right" style="border-bottom:1pt solid black;">Quantity</th>
<th align="right" style="border-bottom:1pt solid black;">Unit Price</th>
<th align="right" style="border-bottom:1pt solid black;">Amount</th>
</tr>
</table>
<hr width="700px">

<table class="totalQuant">
<tr>
<th>Total:</th>
<td id="totalQty"></td>
</tr>
</table>
<br><br>
<table class="totalFee">
<tr>
<th width="50px" id="left"></th>
<td id="totalAmt"></td>
</tr>
<tr>
<th width="50px" id="left" style="display:none">Freight:</th>
<td id="freight" style="display:none"></td>
</tr>
<tr>
<th width="50px" id="left" style="display:none">GST:</th>
<td id="GST" style="display:none">0.00</td>
</tr>
<tr>
<th width="50px" id="left" style="display:none">PST</th>
<td id="PST" style="display:none">0.00</td>
</tr>
</table>
</div>
</html>
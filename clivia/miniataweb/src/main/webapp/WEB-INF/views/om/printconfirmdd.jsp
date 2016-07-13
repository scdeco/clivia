<!DOCTYPE html>

<html>
<title>Order confirm</title>
<header>
<style>
body{
	font-family: "Times New Roman";
}

img{
	position:relative;
	width:180px;
	top:25px;
	font-size:70%;
}
#bold{font-weight:bold;}

.info {
	position:absolute;
	margin-top:-40px;
	left:220px;
	font-size:70%;
}

.order{
	position:relative;
	table-layout:fixed;
	left:445px;
	top:-80px;
	font-size:70%;
}
table{
	border-collapse:collapse;	
}

h2{
	position:relative;
	top:-60px;
	margin-left:485px;
}
.billShip{
	position:relative;
	top:-100px;
	font-size:70%;
}

.billTable{
	position:absolute; 
	left:8px; 
	top:131px;
	font-size:70%;
}
.shipTable{
	position:static;
	margin-left:349px;
	margin-top:-100px;
	font-size:70%;
}

.contact{
	position:static;
	width:700px;
	margin-top:-5px;
	font-size:70%;
}
.formTable{
	text-align:center;
	font-size:70%;
}
.content{
	font-size:70%;
}
.listSpace{
	font-size:70%;
}
.footer{
	page-break-after:always;
	page-break-inside: avoid;
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
.image {
    background-repeat:no-repeat;
    background-size:auto 80px;
    background-position: 0px 10px; 
}
.endFooter{
	position:static;
	margin-top:150px;
	font-size:70%;
}
.totalQty{
	position:relative;
	width:700px;
	left:0px;
	text-align:left; 
	font-size:70%;
}

</style>
<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script>

	
window.onload = function() {
	
	var printModel = ${data.data};

	var info = printModel.info;
	var hideDiscount=info.hideDiscount;
	var items = printModel.items;
	var headerPart = "";
	var currentPage = 0;
	var totalPage = 0;
	var breakPixel = 880.3;	//910.3;
	var countPixel = 0;
	var pagePixel = 890.3;		//924.3;
	var endList = false;
	var qtyDisplay = false;
	var errorPixel = 20.813;
	
	logoAndTitle();
	billAndShip();
	contact();
	infoTable();
	orderList();
	listDetail();
	
	
	
	function logoAndTitle(){
		
		var logoAndTitle = ""
				+ "<div class='firstPage' id='firstPage'>"
				+ "<div class='headerPart' id='headerPart'>"
				+ "<img src='../resources/images/DD LOGO.jpg' alt='logo'>"
				+ "<div class='info' id='info'><p style='white-space: nowrap;'>"
				+ "<b>STITCHES CREATION INC.</b><br>"
				+ "3889 Keith Street, Unit D<br>"
				+ "Burnaby, BC, V5J 5K4  Canada<br>"
				+ "Toll Free: 1-800-639-8034<br>"
				+ "Tel: (604)873-8901"
				+ "Fax:(604)873-8902<br>"
				+ "info@scdeco.com&nbsp;&nbsp;&nbsp;www.ScDeco.com<br>"
				+ "</p>"
				+ "</div>"
				+"<h2 class='header'>Order Confirmation</h2>"
		
		logoAndTitle +="<table class='order' border='1' top = '0px' height='50px' width='250px' >"
				+ "<tr>"
				+ "<th width='110px'>P.O.#</th>"
				+ "<th width='70px'>Date</th>"
				+ "<th width='70px' style='white-space: nowrap;'>&nbsp;Order#&nbsp;</th>"
				+ "<tr>"
				+ "<td style='width:10em; word-wrap: break-word;text-align:center'>" +(info.poNo?info.poNo:"") + "</td>"
				+ "<td width='70px' style='white-space: nowrap;text-align:center'>"  + (info.orderDate?info.orderDate:"") + "</td>"
				+ "<td width='70px' style='white-space: nowrap;text-align:center'>"  + (info.orderNo?info.orderNo :"") + "</td>"
				+ "</tr>"
				+ "</table>"
		headerPart += logoAndTitle;
	}
	
	function billAndShip(){
	
		var billInfo="";
		if (!!info.billTo.city)
			billInfo += ",&nbsp;" + info.billTo.city;
		if(!!info.billTo.province)
			billInfo += ",&nbsp;" + info.billTo.province;
		if(!!info.billTo.postalCode)
			billInfo += ",&nbsp;" +info.billTo.postalCode;
		if(billInfo)
			billInfo = billInfo.substring(7);
	
		var shipInfo="";
		if (!!info.shipTo.city)
			shipInfo += ",&nbsp;" + info.shipTo.city;
		if(!!info.shipTo.province)
			shipInfo += ",&nbsp;" + info.shipTo.province;
		if(!!info.shipTo.postalCode)
			shipInfo += ",&nbsp;" +info.shipTo.postalCode;
		if(shipInfo)
			shipInfo = shipInfo.substring(7);
	
	
		var billAndShip= "";
		billAndShip += "<br>"
					+ "<tr>"
					+ "<br><br>"
					+ "<table width='500px' class='billShip'>"
					+ "<tr style='background-color:#C0C0C0'>"
					+ "<th class='left'>Bill To:</th>"
					+ "<th id='ship'>Ship To:</th>"
					+ "</tr>"
					+ "<table>"
					+ "<table width='350px' align='center' class='billTable'>"
					+ "<tr><td width='100px'></td><td>" + "<br><br>" + info.billTo.receiver + "</td></tr>"
					+ "<tr><td width='100px'></td><td class='left'>" + (info.billTo.addr1?info.billTo.addr1:"") +"</td></tr>"
					+ "<tr><td width='100px'></td><td class='left'>" + (info.billTo.addr2?info.billTo.addr2:"") + "</td></tr>"
					+ "<tr><td width='100px'></td><td class='left'>" + billInfo + "</td></tr>"
					+ "<tr><td width='100px'></td><td class='left'>" + (info.billTo.country?info.billTo.country:"") + "</td></tr>"
					+ "<tr><td width='100px'></td><td class='left' id='billAttn'>" + (info.billTo.attn?info.billTo.attn:"") + "<br><br></td></tr>"
					+ "</table>"
					+ "<table width='350px' align='center' class='shipTable'>"
					+ "<tr><td width='100px'></td><td class='left'><br><br>" + info.shipTo.receiver + "</td></tr>"
					+ "<tr><td width='100px'></td><td class='left'>" + (info.shipTo.addr1?info.shipTo.addr1:"") +"</td></tr>"
					+ "<tr><td width='100px'></td><td class='left'>" + (info.shipTo.addr2?info.shipTo.addr2:"") +"</td></tr>"
					+ "<tr><td width='100px'></td><td class='left'>" + shipInfo + "</td></tr>"
					+ "<tr><td width='100px'></td><td class='left'>" + (info.shipTo.country?info.shipTo.country:"") + "</td></tr>"
					+ "<tr><td width='100px'></td><td class='left'>" + (info.shipTo.attn?info.shipTo.attn:"") + "<br><br></td></tr>"
					+ "</table>"
				
		headerPart += billAndShip;
	}
	
	function contact(){
	
		var contactInfo="";
		if (!!info.contact.name)
			contactInfo += ",&nbsp;" + info.contact.name;
		if(!!info.contact.phone)
			contactInfo += ",&nbsp;" + info.contact.phone;
		if(!!info.contact.email)
			contactInfo += ",&nbsp;" +info.contact.email;
		if(contactInfo)
			contactInfo = contactInfo.substring(7);
			
		var contact =  "<table width='700px' class='contact'>"
					+ "<tr>"
					+ "<th width='10px' align='left'>Contact:</th>"
					+ "<td class='left'>" + contactInfo + "</td>"
					+ "</tr>"
					+ "</table>"
	
		headerPart += contact;
	}
	
	function infoTable(){
		var info = printModel.info;
		var infoDisplay = "<table width='700px' border = '1' class='formTable'>"
				+"<tr>"
				+"<th width='175px'>Sales REP.</th>"
				+"<th width='175px'>Terms</th>"
				+"<th width='175px'>Ship Date</th>"
				+"<th width='175px'>Cancel Date</th>"
				+"</tr>"
				
				+"<tr>"
				+"<td>" + (info.rep?info.rep:"") + "</td>"
				+"<td>" +(info.terms?info.terms:"") + "</td>"
				+"<td>" + (info.shipDate?info.shipDate:"") +"</td>"
				+"<td>" + (info.cancelDate?info.cancelDate:"") + "</td>"
				+"</tr>"
				
				+"</table>"
				
				+"<br></div>"
		
		headerPart += infoDisplay;
		display(headerPart);
		countPixel +=  ($("#headerPart").height() + errorPixel);
	}
	
	function orderList(){
		var tableHeader ="";
		tableHeader += "<div class='content' id='content'>"
					+"<table width='700px'>"
					+"<tr class='left'>"
					+"<th width='60px' style='border-bottom:1pt solid black;'>Style</th>"
					+"<th width='310px' style='border-bottom:1pt solid black;'>Description</th>"
					+"<th align='right' style='border-bottom:1pt solid black;'>Quantity</th>"
					+"<th align='right' style='border-bottom:1pt solid black;'>Price</th>"
					+"<th align='right' style='border-bottom:1pt solid black;'>% Off</th>"
					+"<th align='right' style='border-bottom:1pt solid black;'>Net</th>"
					+"<th align='right' style='border-bottom:1pt solid black;'>Amount</th>"
					+"</tr>"
					+"</table>"
		display(tableHeader);
	}
	
	function listDetail(){
		   var listLength = items.length - 1;
		   var listTable = "";
		  for (var i = 0; i < items.length; i++) {
            var item = items[i];
			listTable += "<div id='listSpace" + i +"' class='listSpace'>"
			listTable  += "<table width='700px' class='listTable'>";
			listTable  += "<tr class='mainrow'><td class='left'>" + item.itemNo 
						+ "</td><td width='370px' class='left'>" + item.desc 
						+ "</td><td class='right' id='bold'>" + item.qty 
						+ "</td><td class='right'>" + item.listPrice 
						+ "</td><td class='right'>" + item.discount
						+ "</td><td class='right' id='bold'>" + item.price 
						+ "</td><td class='right' id='bold'>" + item.amt 
						+ "</td></tr>" 
			var subItemRows = item.data;
			if(subItemRows){
				//image part			
				var url = "http://192.6.2.108:8080/clivia/lib/image/getimage?thumbnail=true&id=";
				var imageUrl =item.imageId? url+item.imageId:"";
				listTable += "<tr><td width = '60px' class='image'style='background-image:url(&quot;" 
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
	                item_table += "</tr></td>";
	            }
				listTable += "<td colspan='2' id='itemTable'><table width ='400px' class='left'><tr height='5px'></tr>" + item_table + "</table><br><br><td colspan='4' id='quote'></td></table>"
							+"<div class ='modifySpace' id = 'modifySpace" + i +"'></div>"
							+"</div>";
				if(i == listLength){
					listTable += "</div>";
				}
					
				display(listTable);
				listTable="";
				var listSpace = "#listSpace" + i;
				countPixel += $(listSpace).height();
				console.log(countPixel);
				
				if (countPixel > breakPixel && i != listLength){
					var thisList = "#listSpace" + i;
					var thisListHeight = $(thisList).height();
					countPixel = countPixel - thisListHeight;
					var footerText = needPageBreak(i,listLength);
					var modify = "#modifySpace" + (i-1);
					var headerPixel = 20;
					$(modify).html(footerText); 
					countPixel = thisListHeight + headerPixel
				}
				else if (i == listLength){
					endList = true;
					display(totalQty() + needPageBreak(listLength,listLength));	
					var qtyDivHeight = $('#totalQty').height();
					countPixel += qtyDivHeight;
				}
				
			}
		}
		
		
	}
	
	function totalQty(){
		qtyDisplay = true;
		var qtyList="";
		qtyList +="<table class='totalQty' id='totalQty'>"
				+"<tr style='border-top-style:solid; border-width:1px;'>"
				+"<th style='width:35px; vertical-align:text-top;'>Remark:</th>"
				+"<td id='remark' colspan='2' class='left' style='word-spacing:none; width:100px'>" + (info.remark?info.remark:"") + "</td>"
				+"<th style='width:10px; vertical-align: text-top;'>Total:</th>"
				+"<td id='totalQty' colspan='2' style='text-align:left;vertical-align: text-top'>" + info.totalQty+ "</td>"
				+"<td id='totalAmt' colspan='2' style='text-align:right;vertical-align: text-top'>" + info.totalAmt+ "</td>"
				+"</tr>"
				+"</table><br><br>";
		return qtyList;
	}
	
	function needPageBreak(itemNo,listLength){
	
		currentPage++;
		var newPageEnd = "";
		if(endList == true){
			totalPage = currentPage;
			var className = "endFooter";
			var needMorePage = "</div>";
		}
		else{
			totalPage = currentPage + 1;
			var className = "footer";
			var needMorePage = "</div></div>";
		}

		if(currentPage != 1 && qtyDisplay==false ){
			countPixel = countPixel - (errorPixel + 10);
		}
		
		else if (qtyDisplay==true){
			countPixel = countPixel + (errorPixel + 10);
		}
	
		var marginPixel = pagePixel - countPixel;
		
	
		var footer = "<div class='" + className +"' >"//style='margin-top:" + marginPixel +"px'>"
					/*+"<table width='700px'>"
					+"<tr style='border-top-style: solid; border-width:1px;'>"
					+"<td width = 400px></td>"
					+"<td class='right'>" 
					+ "Page " + currentPage + " of " + totalPage 
					+("&nbsp;").repeat(4) + (info.poNo?info.poNo:"")
					+"</td>"
					+"</tr>"
					+"</table>"*/
					+ needMorePage;
					
		var listHeader = "<div class='newPage' id='newPage'>"
					+"<table width='700px'>"
					+ "<tr class='left'>"
					+"<th width='60px' style='border-bottom:1pt solid black;'>Style</th>"
					+"<th width='310px' style='border-bottom:1pt solid black;'>Description</th>"
					+"<th align='right' style='border-bottom:1pt solid black;'>Quantity</th>"
					+"<th align='right' style='border-bottom:1pt solid black;'>Price</th>"
					+"<th align='right' style='border-bottom:1pt solid black;'>% Off</th>"
					+"<th align='right' style='border-bottom:1pt solid black;'>Net</th>"
					+"<th align='right' style='border-bottom:1pt solid black;'>Amount</th>"
					+"</tr>"
					+"</table>"	
					
			return footer+(itemNo!= listLength? listHeader:"");
		
	}

	//-----------------------display function----------------------------
		function display(output){	
			document.getElementById("everything").innerHTML += output;
			
		}
		
	

//tmr job, use I to count all the id for the new page so that jquery can read the div height 
//now it's covered by the previse div height


}
</script>
</header>
<body>


<div class="everything" id="everything">

</div>

</body>



</html>
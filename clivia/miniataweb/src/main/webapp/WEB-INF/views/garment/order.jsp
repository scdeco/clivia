<!DOCTYPE html>
<html>
<head>
	<title>Garment Order</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
	<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
	<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<shared:header/>
</head>
<div>

</div>
<div>
<form action="" method="get">
<table>
  <tr>
    <td class="header-field-label"><label for="customer">Customer:</label></td>
    <td class="header-field-value"><input type="text" id="customer" /></td>
   	<td class="header-field-label"><label for="buyer">Buyer:</label></td>
    <td class="header-field-value"><input type="text" id="buyer" /></td>
  </tr>
  <tr>
    <td class="header-field-label"><label for="jobName">Job Name:</label></td>
    <td class="header-field-value"><input type="text" id="jobName" /></td>
   	<td class="header-field-label"><label for="poNumber">P.O.#:</label></td>
    <td class="header-field-value"><input type="text" id="poNumber" /></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  </table>
</form>  
</div>

<div>
	<kendo:splitter name="mainSplitter" orientation="horizontal">
		<kendo:splitter-panes >
		
			<kendo:splitter-pane id="firstpane" collapsible="true">
				<kendo:splitter-pane-content>
				  	<div id="garmentmain" class=grid>
				  		<h4>Product:</h4>
					    <div class="editor-field">
					        <label for="styleNumber">Style#:</label> <input
					            class="input k-popup k-list-container k-group k-reset" type="text"
					            name="styleNumber" />
					    </div>
					
					    <div class="editor-field">
					        <label for="styleName">Style Name:</label> <input
					            class="input k-popup k-list-container k-group k-reset" type="text"
					            name="styleName" />
					    </div>
					
					    <div class="editor-field">
					        <label for="description">Description</label><input
					            class="input k-popup k-list-container k-group k-reset" type="text"
					            name="styleName" />
					    </div>
					    
				        <input class="k-button" type="submit" name="save" value="Save">
				  	</div>
				  	 
				</kendo:splitter-pane-content>
			</kendo:splitter-pane>
			
			<kendo:splitter-pane id="second-pane" collapsible="true">
				<kendo:splitter-pane-content>
				  	<div id="garmentupc" class=grid><h4>UPC:</h4></div>
				</kendo:splitter-pane-content>
			</kendo:splitter-pane>
			
		</kendo:splitter-panes>
	</kendo:splitter>
</div>

<style>
	#mainSplitter{
		width: 100%;
		height:800px;
		}
		
	table {
		width:100%;
		border:0px;
		
	}

	.header-field-label{
		width:90px;
		text-align: right;
	}
	
	.header-field-value{
		width:auto;
	}
	
	table tr td input{
		width:100%;
	}
	

	
</style>


<shared:footer/>
	 
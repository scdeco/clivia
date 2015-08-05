
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<shared:header/>
<div>

</div>

<div>
<form:form commandName="editForm" method="post">
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
</form:form>
</div>

<style>
	#mainSplitter{
		width: 100%;
		height:800px;
		}
</style>



<shared:footer/>
	 
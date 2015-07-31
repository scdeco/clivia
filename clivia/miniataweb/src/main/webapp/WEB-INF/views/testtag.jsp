

<%@taglib prefix="ex" uri="/WEB-INF/miniataweb-tags.tld"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<shared:header/>


<script>
			
	$(document).ready(function() {
			
		var infogridCurrentRowId=-1;		
		
		<ex:clivia-grid gridno="901" name="infogrid" editable="true" inscript="true" />
		<ex:clivia-grid gridno="902" name="columngrid" editable="true" filter="gridId,eq,-1" inscript="true" hidelineno="true" />
		
		
		infogridKendoGrid.bind("change", function(e){
			//Getting selected item
			
			var selectedItem=this.dataItem(this.select());
			if(selectedItem.id!==infogridCurrentRowId){
				infogridCurrentRowId=selectedItem.id;
				columngridFilter[0].value=infogridCurrentRowId;
			    columngridDataSource.filter(columngridFilter);
			}
		});
		
		columngridKendoGrid.bind("edit", function(e) {
		    if (e.model.isNew()&&!e.model.dirty) {
		            e.model.set("gridId", infogridCurrentRowId); 
	        }
		 });	
		
	});
	
</script> 

<ex:clivia-grid gridno="281" name="garmentsizegrid" editable="true"/>

<ex:clivia-grid gridno="280" name="garmentcolourgrid" editable="true"/>
 
<ex:clivia-grid gridno="282" name="garmentcategorygrid" editable="true"/>


<kendo:tabStrip name="tabStrip" animation="false">
	<kendo:tabStrip-items>
	    <kendo:tabStrip-item text="Grid" selected="true">
			<kendo:tabStrip-item-content>
				<div class="tabPage">
					<kendo:splitter name="vertical" orientation="vertical" style="height:100%;">
						<kendo:splitter-panes >
							<kendo:splitter-pane id="top-pane" collapsible="true">
								<kendo:splitter-pane-content>
								  	<div id="infogrid" class=grid></div>
								</kendo:splitter-pane-content>
							</kendo:splitter-pane>
							<kendo:splitter-pane id="bottom-pane" collapsible="true">
								<kendo:splitter-pane-content>
								  	<div id="columngrid" class=grid></div>
								</kendo:splitter-pane-content>
							</kendo:splitter-pane>
						</kendo:splitter-panes>
					</kendo:splitter>
				</div>
		    </kendo:tabStrip-item-content>
	    </kendo:tabStrip-item>
        <kendo:tabStrip-item text="Size">
            <kendo:tabStrip-item-content>
				<div class="tabPage">
	                <div id="garmentsizegrid" class=grid></div>
	            </div>
            </kendo:tabStrip-item-content>    
        </kendo:tabStrip-item>
        <kendo:tabStrip-item text="Colour">
            <kendo:tabStrip-item-content>
				<div class="tabPage">
	                <div id="garmentcolourgrid" class=grid></div>
	            </div>
            </kendo:tabStrip-item-content>    
        </kendo:tabStrip-item>
        <kendo:tabStrip-item text="Category">
            <kendo:tabStrip-item-content>
				<div class="tabPage">
	                <div id="garmentcategorygrid" class=grid></div>
	            </div>
            </kendo:tabStrip-item-content>    
        </kendo:tabStrip-item>

     </kendo:tabStrip-items>
 
</kendo:tabStrip>
	 
   
    
<style>
	#tabStrip{
		width: 100%;
		height:860px;
		margin-left:auto;
		margin-right:auto;
		border:0;
	}
	
	.k-splitter .k-scrollable{
		overflow:hidden;	
	}
	
	.tabPage{
		height:800px;
	}
	
	.k-grid {height:100%; }
 	
 	.k-grid td{ white-space: nowrap;} 

 	

	
</style>    

<shared:footer/>
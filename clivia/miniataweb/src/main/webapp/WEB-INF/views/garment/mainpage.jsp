

<%@taglib prefix="ex" uri="/WEB-INF/miniataweb-tags.tld"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<shared:header/>


<script>
			
	$(document).ready(function() {
			
		var garmentgridCurrentRowId=-1;		
		
		<ex:clivia-grid gridno="201" name="garmentgrid" editable="true" inscript="true" />
		<ex:clivia-grid gridno="202" name="garmentupcgrid" editable="true" inscript="true" filter="garmentId,eq,-1" />
		
		
		garmentgridKendoGrid.bind("change", function(e){
			//Getting selected item
			
			var selectedItem=this.dataItem(this.select());
			if(selectedItem.id!==garmentgridCurrentRowId){
				garmentgridCurrentRowId=selectedItem.id;
				garmentupcgridFilter[0].value=garmentgridCurrentRowId;
				garmentupcgridDataSource.filter(garmentupcgridFilter);
			}
		});
		
		garmentupcgridKendoGrid.bind("edit", function(e) {
		    if (e.model.isNew()&&!e.model.dirty) {
		            e.model.set("garmentId", garmentgridCurrentRowId); 
	        }
		 });	
		
	});
	
</script> 

<%-- <ex:clivia-grid gridno="280" name="garmentcolourgrid" editable="true" /> --%>


<kendo:tabStrip name="tabStrip" animation="false">
	<kendo:tabStrip-items>
	    <kendo:tabStrip-item text="Grid" selected="true">
			<kendo:tabStrip-item-content>
				<div class="tabPage">
					<kendo:splitter name="vertical" orientation="vertical" style="height:100%;">
						<kendo:splitter-panes >
							<kendo:splitter-pane id="top-pane" collapsible="true">
								<kendo:splitter-pane-content>
								  	<div id="garmentgrid" class=grid></div>
								</kendo:splitter-pane-content>
							</kendo:splitter-pane>
							<kendo:splitter-pane id="bottom-pane" collapsible="true">
								<kendo:splitter-pane-content>
								  	<div id="garmentupcgrid" class=grid></div>
								</kendo:splitter-pane-content>
							</kendo:splitter-pane>
						</kendo:splitter-panes>
					</kendo:splitter>
				</div>
		    </kendo:tabStrip-item-content>
	    </kendo:tabStrip-item>
        <kendo:tabStrip-item text="Garment Colour">
            <kendo:tabStrip-item-content>
				<div class="tabPage">
	                <div id="garmentcolourgrid" class=grid></div>
	            </div>
            </kendo:tabStrip-item-content>    
        </kendo:tabStrip-item>

	    <kendo:tabStrip-item text="Garment Size" >
			<kendo:tabStrip-item-content>
				<div class="tabPage">
	                <div id="garmentsizegrid" class=grid></div>
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
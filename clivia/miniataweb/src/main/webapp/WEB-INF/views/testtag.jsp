

<%@taglib prefix="ex" uri="/WEB-INF/miniataweb-tags.tld"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<shared:header/>



<script>
	$(document).ready(function() {
		
		<ex:clivia-grid gridno="901" name="infogrid" />
		<ex:clivia-grid gridno="902" name="columngrid" filter="gridId,eq,-1" />
		<ex:clivia-grid gridno="101" name="employeegrid" />
	
		var infogridCurrentRowId=-1;
		$("#infogrid").data("kendoGrid").bind("change", function(e){
			//Getting selected item
			
			var selectedItem=this.dataItem(this.select());
			if(selectedItem.id!==infogridCurrentRowId){
				infogridCurrentRowId=selectedItem.id;
				columngridFilter[0].value=infogridCurrentRowId;
			    columngridDataSource.filter(columngridFilter);
			}
		});
		
	});
</script> 




<kendo:tabStrip name="tabStrip" animation="false">
	<kendo:tabStrip-items>
	    <kendo:tabStrip-item text="Grid" selected="true">
			<kendo:tabStrip-item-content>
				<div class="test">
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
        <kendo:tabStrip-item text="Employee">
            <kendo:tabStrip-item-content>
				<div class="test">
	                <div id="employeegrid" class=grid></div>
	            </div>
            </kendo:tabStrip-item-content>    
        </kendo:tabStrip-item>
        
     </kendo:tabStrip-items>
 
</kendo:tabStrip>
	 
    
    
<style>
	#tabStrip{
		width: 80%;
		height:900px;
		margin-left:auto;
		margin-right:auto;
	}
	#vertical{
		overflow:hidden;	
		}
	.test{
	height:700px;
	}
	
	.grid{
		height: 100%; 	
	}
</style>
    

<shared:footer/>
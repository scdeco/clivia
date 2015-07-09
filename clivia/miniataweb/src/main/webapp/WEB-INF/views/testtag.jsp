<%@ taglib prefix="ex" uri="/WEB-INF/miniataweb-tags.tld"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>

<shared:header/>

<ex:clivia-grid gridno="901" divid="grid"/>
<ex:clivia-grid gridno="902" divid="myGrid" filter="gridId,eq,1"/>
<ex:clivia-grid gridno="101" divid="employeeGrid"/>




<kendo:tabStrip name="tabStrip" animation="false">
	<kendo:tabStrip-items>
	    <kendo:tabStrip-item text="Grid" selected="true">
			<kendo:tabStrip-item-content>
				<div class="test">
					<kendo:splitter name="vertical" orientation="vertical" style="height:100%;">
						<kendo:splitter-panes >
							<kendo:splitter-pane id="top-pane" collapsible="true">
								<kendo:splitter-pane-content>
								  	<div id="grid" class=grid></div>
								</kendo:splitter-pane-content>
							</kendo:splitter-pane>
							<kendo:splitter-pane id="bottom-pane" collapsible="true">
								<kendo:splitter-pane-content>
								  	<div id="myGrid" class=grid></div>
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
	                <div id="employeeGrid" class=grid></div>
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
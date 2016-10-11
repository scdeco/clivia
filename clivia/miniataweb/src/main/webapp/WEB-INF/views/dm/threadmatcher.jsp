<div style="height:800px;">     	

    <div kendo-tab-strip k-animation="false" style="height:100%;">
		<ul>
			<li>Info</li>
			<li class="k-state-active">Colourway</li>
			<li>Background</li>
		</ul>

		<div>		<!-- tabpage of info -->
			<table>
				<tr>
					<td colspan='4'>{{embCanvas.embDesign.info.designNumber}}</td>
				</tr>
				<tr>
					<td colspan='4' >{{embCanvas.embDesign.info.companyName}}</td>
				</tr>
				<tr>
					<td>Stitches:</td>
					<td>{{embCanvas.embDesign.stitchCount}}</td>
					<td>Steps:</td>
					<td>{{embCanvas.embDesign.stepCount}}</td>
				</tr>
				<tr>
					<td>Width:</td>
					<td>{{embCanvas.embDesign.info.width+' ('+(embCanvas.embDesign.info.widthInch|number:1)+')'}}</td>
					<td>Height:</td>
					<td>{{embCanvas.embDesign.info.height+' ('+(embCanvas.embDesign.info.heightInch|number:1)+')'}}</td>
				</tr>
			</table>
		</div>
    	<div>	
 	      	<div kendo-splitter ="colourwaySplitter"
	      		 k-orientation="'vertical'" 
				 k-panes="[{ collapsible: true, resizable: true, size: '250px'},
	                  	   { collapsible: true, resizable: true }]"
	             style="height:600px;"> 
			       <div>
			       		<span style="vertical-align:-3px;">Threads:&nbsp;</span> <kendo-button ng-hide="true" ng-disabled="!embCanvas.threadCodes" style="height:20px;margin-top:2px;" k-options="parseThreadsButtonOptions"></kendo-button>
	
				       	<textarea ng-model="embCanvas.threadCodes" 
				       				  ng-trim="true"
				       				  change-on-blur="parseThreads()"
				       				  class="k-textbox" 
				       				  style="width:100%;resize: vertical;"></textarea>
				       				  
			    		<div kendo-sortable="embThreadGridSortable"	k-options="gwThread.getSortableOptions()">
							<div  kendo-grid="embThreadGrid" k-options="threadGridOptions" ></div>
						</div>
			       </div>
			       
			       <div>
			       		<span style="vertical-align:-3px;">Running Steps:&nbsp;</span> <kendo-button ng-hide="true" ng-disabled="!embCanvas.runningSteps" style="height:20px;margin-top:2px;" k-options="parseStepsButtonOptions"></kendo-button>
			       		
			       		<textarea ng-model="embCanvas.runningSteps" 
			       				  ng-trim="true"
			       				  class="k-textbox" 
			       				  change-on-blur="parseSteps()"
			       				  style="width:100%;resize: vertical;"></textarea>
			       				  
			    		<div kendo-sortable="embStepGridSortable"	k-options="gwStep.getSortableOptions()">
							<div  kendo-grid="embStepGrid"  k-options="stepGridOptions"></div>
						</div>
			       </div>
	        </div> 
	    </div>
    	<div>
     			<div kendo-flat-color-picker
	   				 ng-model="backgroundColour"
	   				 k-preview="false">
     			</div>
     			<h4></h4>
     			<div kendo-color-palette
	   				 ng-model="backgroundColour"
      				 k-orientation="'vertical'"
      				 k-columns="8"
      				 k-titleSize="{'width':12}"
      				 k-options="backgroundColourPaletteOptions">
     			</div>
     	</div>

	</div>
</div>
		       
		       

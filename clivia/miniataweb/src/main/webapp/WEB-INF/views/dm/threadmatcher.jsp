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
					<td colspan='4'>{{embMatcher.embCanvas.embDesign.info.designNumber}}</td>
				</tr>
				<tr>
					<td colspan='4' >{{embMatcher.embCanvas.embDesign.info.companyName}}</td>
				</tr>
				<tr>
					<td>Stitches:</td>
					<td>{{embMatcher.embCanvas.embDesign.stitchCount}}</td>
					<td>Steps:</td>
					<td>{{embMatcher.embCanvas.embDesign.stepCount}}</td>
				</tr>
				<tr>
					<td>Width:</td>
					<td>{{embMatcher.embCanvas.embDesign.info.width+' ('+(embMatcher.embCanvas.embDesign.info.widthInch|number:1)+')'}}</td>
					<td>Height:</td>
					<td>{{embMatcher.embCanvas.embDesign.info.height+' ('+(embMatcher.embCanvas.embDesign.info.heightInch|number:1)+')'}}</td>
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
			       		<span style="vertical-align:-3px;">Threads:&nbsp;</span> <kendo-button ng-hide="true" ng-disabled="!embMatcher.embCanvas.threadCodes" style="height:20px;margin-top:2px;" k-options="parseThreadsButtonOptions"></kendo-button>
	
				       	<textarea ng-model="embMatcher.embCanvas.threadCodes" 
				       				  ng-trim="true"
				       				  change-on-blur="parseThreads()"
				       				  class="k-textbox" 
				       				  style="width:100%;resize: vertical;"></textarea>
				       				  
			    		<div kendo-sortable="embThreadGridSortable"	k-options="embMatcher.gwThread.getSortableOptions()">
							<div  kendo-grid="embThreadGrid" k-options="threadGridOptions" ></div>
						</div>
			       </div>
			       
			       <div>
			       		<span style="vertical-align:-3px;">Running Steps:&nbsp;</span> <kendo-button ng-hide="true" ng-disabled="!embMatcher.embCanvas.runningSteps" style="height:20px;margin-top:2px;" k-options="parseStepsButtonOptions"></kendo-button>
			       		
			       		<textarea ng-model="embMatcher.embCanvas.runningSteps" 
			       				  ng-trim="true"
			       				  class="k-textbox" 
			       				  change-on-blur="parseSteps()"
			       				  style="width:100%;resize: vertical;"></textarea>
			       				  
			    		<div kendo-sortable="embStepGridSortable"	k-options="embMatcher.gwStep.getSortableOptions()">
							<div  kendo-grid="embStepGrid"  k-options="stepGridOptions"></div>
						</div>
			       </div>
	        </div> 
	    </div>
    	<div>
     			<div kendo-flat-color-picker
	   				 ng-model="embMatcher.backgroundColour"
	   				 k-preview="false">
     			</div>
     			<h4></h4>
     			<div kendo-color-palette
	   				 ng-model="embMatcher.backgroundColour"
      				 k-orientation="'vertical'"
      				 k-columns="8"
      				 k-titleSize="{'width':12}"
      				 k-options="embMatcher.getBackgroundColourPaletteOptions()">
     			</div>
     	</div>

	</div>
</div>
		       
		       

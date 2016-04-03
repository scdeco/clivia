	 <div style="height:800px;">     	
	      	<div kendo-splitter="embInfoSplitter"  
	      		 k-orientation="'vertical'" 
				 k-panes="[{ collapsible: true, resizable: true, size: '120px'},
	                	   { collapsible: true, resizable: true, size:'250px'},
	                  	   { collapsible: true, resizable: true }]"
	             style="height:100%;">
	             
		       <div id="emb-info-pane">
		       		<div kendo-tab-strip 
		       			 k-animation="false">
		       			<ul>
		       				<li class="k-state-active">Info</li>
		       				<li>palette</li>
		       				<li>picker</li>
		       				<li>Fabric</li>
		       				<li>Thread</li>
		       			</ul>
		      			<div>
			      			<div id="info">		<!-- tabpage of info -->
			      				<table>
			      					<tr>
			      						<td>{{embMatcher.embCanvas.embDesign.designNumber}}</td>
			      					</tr>
			      					<tr>
			      						<td>Stitches:</td>
			      						<td>{{embMatcher.embCanvas.embDesign.stitchCount}}</td>
			      						<td>Steps:</td>
			      						<td>{{embMatcher.embCanvas.embDesign.stepCount}}</td>
			      					</tr>
			      					<tr>
			      						<td>Width:</td>
			      						<td>{{embMatcher.embCanvas.embDesign.width}}</td>
			      						<td>Height:</td>
			      						<td>{{embMatcher.embCanvas.embDesign.height}}</td>
			      					</tr>
			      				</table>
			      			</div>
		      			</div>
		      			
		      			
		      			<div kendo-color-palette
		 	   				 ng-model="backgroundColor"
		       				 k-orientation="'vertical'"
		       				 k-columns="8"
		       				 k-titleSize="{'width':12}"
		       				 k-options="embMatcher.getBackgroundColorPaletteOptions()">
		      			</div>
		      			
		      			<div kendo-flat-color-picker
		 	   				 ng-model="backgroundColor"
		 	   				 k-preview="false">
		      			</div>

		      			<div>
		      				Fabric
		      			</div>
		      			
		      			<div>
		      				Thread
		      			</div>
		       		</div>
		       </div>
		       
		       <div id="emb-thread-pane">
		       		Threads:
			       		<textarea ng-model="embMatcher.embCanvas.threadCodes" 
			       				  ng-trim="true"
			       				  class="k-textbox" 
			       				  style="width:100%;resize: vertical;"></textarea>
			       				  
			    		<div kendo-sortable="embThreadGridSortable"	k-options="embMatcher.gwThread.getSortableOptions()">
							<div  kendo-grid="embThreadGrid" k-options="threadGridOptions" ></div>
						</div>
		       </div>
		       
		       <div id="emb-step-pane">
		       		Running Steps:
		       		<textarea ng-model="embMatcher.embCanvas.runningSteps" 
		       				  ng-trim="true"
		       				  class="k-textbox" 
		       				  style="width:100%;resize: vertical;"></textarea>
		    		<div kendo-sortable="embStepGridSortable"	k-options="embMatcher.gwStep.getSortableOptions()">
						<div  kendo-grid="embStepGrid"  k-options="stepGridOptions"></div>
					</div>
		       </div>
		       
	       </div>
	</div>
		       

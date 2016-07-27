
    <div class="k-header wide" style="height:800px;">
      	<div 	kendo-splitter="DstSplitter"  
      			k-orientation="'horizontal'" 
				k-panes="[{ collapsible:true,resizable: true,size:'250px'},
						  { collapsible: false},
                  		  { collapsible: true, resizable: true,size:'250px'}]"

		    	style="height:100%;">      	
      	
  		<!-- 		ng-model="dstPaint.backgroundColor"  -->
      		<div id="dst-first-pane">
      			 <div clivia-grid="colorwayGrid" 
	      			   	c-grid-wrapper-name="'ColorwayGridWrapper'"
	  					c-call-from="'paint'"
	  					c-editable="false" 
	  					c-data-source="colorwayGridDataSource" 
	  					c-pageable="false" 
	  					c-new-item-function="newItemFunction"
	  					c-register-deleted-item-function="registerDeletedItemFunction">
  				</div>
      			 
      		</div>
      		<div id="dst- second-pane">
   				<div id="stagecontainer" ng-style="{'background-color':threadMatcher.backgroundColor}" 
   					 				ng-click="onClick()">
				</div>
			</div>	<!-- first-pane-->
      		<div id="dst- third-pane">
      			<div thread-matcher="threadMatcher" c-emb-canvas="embCanvas"></div>
			</div>	<!--  second-pane-->
		</div>
		
		<div kendo-window="printOptions" k-title="'Print Options'"
		           k-width="600" k-height="500" k-visible="false" k-options="printWindowOptions">
		           
		           
		</div>			
			
	</div>


	


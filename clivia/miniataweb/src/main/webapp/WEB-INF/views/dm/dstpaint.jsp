
    <div class="k-header wide" style="height:800px;">
      	<div 	kendo-splitter="DstSplitter"  
      			k-orientation="'horizontal'" 
				k-panes="[ { collapsible: false},
                  		  { collapsible: true, resizable: true,size:'250px'}]"

		    	style="height:100%;">      	
      	
      		<div>
   				<div id="stagecontainer" ng-style="{'background-color':threadMatcher.backgroundColour}" 
   					 				ng-click="onClick()">
				</div>
			</div>	<!-- first-pane-->
			
      		<div>
      			<div thread-matcher="threadMatcher" c-emb-canvas="embCanvas"></div>
			</div>	<!--  second-pane-->
			
		</div>
		
		<div kendo-window="printOptions" k-title="'Print Options'"
		           k-width="600" k-height="500" k-visible="false" k-options="printWindowOptions">
		           
		           
		</div>			
			
	</div>


	


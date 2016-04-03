
    <div class="k-header wide" style="height:800px;">
    
 
    	
      	<div 	kendo-splitter="DstSplitter"  
      			k-orientation="'horizontal'" 
				k-panes="[{ collapsible: false},
                  		  { collapsible: true, resizable: true,size:'250px'}]"

		    	style="height:100%;">      	
      	
  		<!-- 		ng-model="dstPaint.backgroundColor"  -->
      		<div id="dst-first-pane">
   				<div id="container" ng-style="{'background-color':dstPaint.backgroundColor}">
				</div>
			</div>	<!-- first-pane-->
			
      		<div id="dst- second-pane">
      			<div thread-matcher="threadMatcher" c-emb-canvas="embCanvas"></div>
			</div>	<!--  second-pane-->
		</div>
			
	</div>

		

	


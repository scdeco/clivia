
<form name="searchForm" ng-submit="getOrder()" novalidate >
<div kendo-toolbar id="ordertoolbar" k-options="orderToolbarOptions"></div>
</form>			

<div kendo-splitter="outterSplitter"
		k-orientation="'vertical'"
		k-panes="[{ collapsible: false, resizable: false, size: '30px',collapsed: false },
                  { collapsible: false,size:'500px'},
                  { collapsible: false, resizable: true}]"
		 style="height:900px;">
		 
	<div id="top-pane">
	</div>	<!-- top pane of outter splitter -->
	
	<div id="middle-pane">
	
		<div kendo-splitter="mainSplitter"
				k-orientation="'horizontal'"
				k-panes="[{ collapsible: true, resizable:true,size:'230px'},
                    	  { collapsible: false}]"
				style="height: 100%; width: 100%;">
				
			<div id="left-pane">
				<div ui-view="orderinfo"></div>
			</div> <!-- left pane -->
			
			<div id="right-pane">
				<div ui-view="orderitem"></div>
			</div>
			
		</div>
		
	</div> <!-- middle pane of outter splitter -->
	
	<div id="bottom-pane" style="height:300px;">
				<pre>
					model:{{order|json}}
					dict:{{dict|json}}
	
				</pre>
	</div> <!-- bottom pane of outter splitter -->
	
</div>
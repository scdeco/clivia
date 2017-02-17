			<div class="demo-section k-content">
				<h3> <img src="../resources/images/i-copydeco.ico" ng-click="duplicateDeco()" ng-show="lineItemDi.lineNo">Decorations/Services on line item {{' #'+lineItemDi.lineNo}}: </h3> 
			
				
			</div>
			 <div kendo-tab-strip ng-show="lineItemDi.id>0">
			          <ul>
			            <li class="k-state-active">Embroidery</li>
			            <li>Screen Printing</li>
			            <li>Heat Transfer</li>
			            <li>Ditigizing</li>
			          </ul>
			      
			          <div style="padding: 1em">
			          
			          	   	<div clivia-grid="serviceEmbGrid"
			   					c-grid-wrapper-name="'ServiceEmbGridWrapper'"
			   					c-editable="true" 
			   					c-pageable="false" 
			   					c-new-item-function="serviceEmbNewItemFunction"
			   					c-register-deleted-item-function="registerDeletedServiceEmbFunction">
			    			</div> 
			          </div>
			      
			          <div style="padding: 1em">
			          	   	<div clivia-grid="serviceSpGrid"
			   					c-grid-wrapper-name="'ServiceSpGridWrapper'"
			   					c-editable="true" 
			   					c-pageable="false" 
			   					c-new-item-function="serviceSpNewItemFunction"
			   					c-register-deleted-item-function="registerDeletedServiceSpFunction">
			    			</div> 
			          </div>
			          <div style="padding: 1em">
			            This is the third......... tab
			          </div>
			          <div style="padding: 1em">
			            This is the forth......... tab
			          </div>
			</div> 			
			<div kendo-window="decoDuplicateWindow"    
					k-width="1200"
				 	k-height="410"
				 	k-position="{top: 50, left: 100 }"	
				 	k-resizable="true"
					k-draggable="true"
				 	k-title="'Duplicate Decoration'"
				 	k-visible="false" 
				 	k-actions="['Close','Minimize','Maximize']"
				 	k-modal="true">
				 	
				 	<div kendo-splitter  
      						k-orientation="'vertical'" 
							k-panes="[{ collapsible:false,resizable: false,size:'50px'}
									,{ collapsible: true, resizable: true,size:'120px'}
						 			,{ collapsible: true,resizable: true}]"
	   	 					style="height:100%;">
	   	 			<div>
	   	 				Selected Line Items:{{selectedLineItemQuantity}}
	   	 				<br>
	   	 				<button ng-click="duplicateSelectedDecoToLineItem()">Append</button> 
	   	 				<button ng-click="">Overwrite</button>
	   	 			</div>
			   		<div>
				   		<div kendo-grid="duplicateDecoGrid" k-options="duplicateDecoGridOptions"></div>
				   	</div>
				   		
				   	<div>
				   		<div kendo-grid="duplicateLineItemGrid" k-options="duplicateLineItemGridOptions"></div>
				   	</div>
	   	 		
	   	 	</div>	

	 
			</div>
			

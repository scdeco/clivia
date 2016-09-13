			<div class="demo-section k-content">
				<h3> <img src="../resources/images/i-copydeco.ico" ng-click="duplicateDeco()" ng-show="lineItemDi.lineNo">Deco on line item {{' #'+lineItemDi.lineNo}}: </h3> 
			
				
			</div>
			 <div kendo-tab-strip ng-show="lineItemDi.id>0">
			          <ul>
			            <li class="k-state-active">Embroidery</li>
			            <li>Screen Printing</li>
			            <li>Heat Transfer</li>
			            <li>Laser Etching</li>
			          </ul>
			      
			          <div style="padding: 1em">
			          
			          	   	<div clivia-grid="serviceEmbGrid"
			   					c-grid-wrapper-name="'serviceEmbGridWrapper'"
			   					c-editable="true" 
			   					c-pageable="false" 
			   					c-new-item-function="serviceEmbNewItemFunction"
			   					c-register-deleted-item-function="registerDeletedServiceEmbFunction">
			    			</div> 
			          </div>
			      
			          <div style="padding: 1em">
			          	   	<div clivia-grid="serviceSpGrid"
			   					c-grid-wrapper-name="'serviceSpGridWrapper'"
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
			

<div class="demo-section k-content">
	<!-- Service on lineitem  {{'#'+lineItemDi.lineNo}} -->

	<h5>order item id:{{lineItemDi.orderItemId}}  line item id:{{lineItemDi.id}}</h5>
</div>


          
 <div kendo-tab-strip>
          <ul>
            <li class="k-state-active">Embroidery</li>
            <li>Screen Printing</li>
            <li>Heat Transfer</li>
            <li>Laser Etching</li>
          </ul>
      
          <div style="padding: 1em">
          
          	   	<div clivia-grid="embServiceGrid"
   					c-grid-wrapper-name="'EmbServiceGridWrapper'"
   					c-editable="true" 
   					c-data-source="embServiceGridDataSource" 
   					c-pageable="false" 
   					c-new-item-function="embServiceNewItemFunction"
   					c-register-deleted-item-function="registerDeletedEmbServiceFunction">
    			</div> 
          </div>
      
          <div style="padding: 1em">
            This is the second......... tab
          </div>
          <div style="padding: 1em">
            This is the third......... tab
          </div>
          <div style="padding: 1em">
            This is the forth......... tab
          </div>
</div> 
<script>
	orderApp.constant("consts",{
		
		baseUrl:"/miniataweb/",
		
		registeredItemTypes:[{
				name:"lineItem",
				hasDetail:true
			},{
				name:"imageItem",	
				hasDetail:false
			},{
				name:"designItem",	
				hasDetail:false
			},{
				name:"pricingItem",	
				hasDetail:false
			},{
				name:"fileItem",
				hasDetail:false
			},{
				name:"emailItem",	
				hasDetail:false
			}],
			
		registeredOrderItems:[{ 
			   	 text: "Line Item", 
				 icon: "insert-n",
				 id: "lineitem",
				 spec: "Generic",
				 itemType: "lineItem"		//datatable
			},{
				 text: "DD Line Item", 
				 icon: "insert-n",
				 id:"lineitemdd",
				 spec:"DD",
				 itemType:"lineItem"
			},{
				type: "separator" 
			},{
				 text: "Pricing Item", 
				 icon: "insert-n",
				 id:"pricingitem",
				 spec:"",
				 itemType: "pricingItem"
			},{
				text: "Design", 
				icon: "insert-m",
			   	id:"designitem",
				spec:"",
				itemType: "designItem"
			},{ 
				text: "Image", 
				icon: "insert-m",
			   	id:"imageitem",
				 spec:"",
				 itemType: "imageItem"
			},{ 
				text: "File", 
				icon: "insert-s",
			   	id:"fileitem",
				spec:"",
				itemType: "fileItem"
			},{ 
				text: "Email", 
				icon: "insert-s",
			   	id:"emailitem",
				spec:"",
				itemType: "emailItem"
			},{ 
				text: "Send&Receive",
				icon: "insert-s",
			   	id:"shipping",
				spec:"",
				itemType: "shippingItem"
			}],
	});
</script>
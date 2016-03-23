<!DOCTYPE html>
<html ng-app="orderApp">
<head>

	<title>Order</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

	<shared:header/> 

	<%@include file="../common/factories.jsp"%>
	<%@include file="../common/directives.jsp"%>
	
	<%@include file="order-script.jsp"%>
	<%@include file="aconsts.jsp"%>
	<%@include file="aconfig.jsp"%>
 	<%@include file="ordermain-script.jsp"%>
	<%-- <%@include file="orderinfo-script.jsp"%> --%>
	<%@include file="orderitem-script.jsp"%>

 	<%@include file="billitem-script.jsp"%> 
	<%@include file="lineitem-script.jsp"%> 
	<%@include file="lineitemdetail-script.jsp"%> 
	<%@include file="imageitem-script.jsp"%> 
	<%@include file="contactitem-script.jsp"%> 
	<%@include file="addressitem-script.jsp"%> 
	<%@include file="designitem-script.jsp"%> 
	<%@include file="fileitem-script.jsp"%>  
	<%@include file="emailitem-script.jsp"%>  
	
</head>

<body  ng-controller="orderCtrl" spellcheck="false">
  <div ui-view="main"></div>
</body>

<style>

	.k-dirty {
  		border-width:0;
	}
	
	.k-splitter {
		border-width: 0;
	}
	
	.k-listview {
		border-width: 0;
	}
	
 	.k-toolbar{
		border-width: 0;
		padding: 0;
		margin: 0;
		height:36px;	//default 36px
		}
		
	.k-grid{
        margin: 0;
        padding: 0;
        border-width: 0;
        height: 100%; /* DO NOT USE !important for setting the Grid height! */
      	}

	/* 	do not show background color of grid editing cell */
	.k-grid .k-edit-cell { 
		background: transparent; 
		}
		
	/*highlight line number of editing row, might not be the first column 	td:first-child  */
	.k-grid .k-grid-edit-row td.gridLineNumber{
		color:blue;
		font-weight: bold;
		
	}

	/* show horizontal grid line		 */
	.k-grid-content tr:not(:last-child) td{
 	   border-bottom: 1px dotted gray;
		}		
/*  	.k-grid-content tr:last-child td{
 	   border-bottom: 1px solid gray;
		}  */
				
	/* 	grid coloumn header */
 	.k-grid-header tr:last-child th{ 
	   font-weight: bold; 
  	   text-align: center;
		}
		
	.k-grid .gridLineNumber{
		text-align: right;
	}		 
	
	/* 	the grid in garmentInput Window	 */
	#styleGrid .k-grid-content tr td:not(:last-child){
 	   text-align: right;
	  }		
	#styleGrid .k-grid-content tr td:first-child{
 	   font-weight: bold;
	  }		
				
	
	/* no wrap */	
	.k-grid td{
   		white-space: nowrap;
	}
		
	#top-pane label{
        display: block;
        padding: .3em;
        font-weight: bold;
        }
		
	
/* 	orderinfo */
     #fieldlist {
        margin: 10px;
        padding: 0;
     }
      
     #fieldlist li {
         list-style: none;
         padding-top: .7em;
         text-align: left;
     }
     
     #fieldlist label {
          display: block;
      }
      
     
      textarea { 
      	resize: vertical; 
      }
      
	
/* 	image item styles */
	#imageItemToolbar, #lineItemToolbar{
		background-color: white;
		}
	
	#imageItemlistView {
        padding: 10px 5px;
        margin-bottom: -1px;
        min-height: 510px;
        border-width: 0;
        background-color:red;
	    }
	    
    .imageItem {
            float: left;
            position: relative;
            width: 111px;
            height: 170px;
            margin: 3 5px;
            padding: 0;
        }
	.imageItem img {
            max-width: 110px;
            max-height: 110px;
            width: auto;
            height: auto;
            }
    .imageItem h3 {
            margin: 0;
            padding: 3px 5px 0 0;
            max-width: 96px;
            overflow: hidden;
            line-height: 1.1em;
            font-size: .9em;
            font-weight: normal;
            text-transform: uppercase;
            color: #999;
        }
        .imageItem p {
            visibility: hidden;
        }
        .imageItem:hover p {
            visibility: visible;
            position: absolute;
            width: 110px;
            height: 110px;
            top: 0;
            margin: 0;
            padding: 0;
            line-height: 110px;
            vertical-align: middle;
            text-align: center;
            color: #fff;
            background-color: rgba(0,0,0,0.75);
            transition: background .2s linear, color .2s linear;
            -moz-transition: background .2s linear, color .2s linear;
            -webkit-transition: background .2s linear, color .2s linear;
            -o-transition: background .2s linear, color .2s linear;
        }
        .k-listview:after {
            content: ".";
            display: block;
            height: 0;
            clear: both;
            visibility: hidden;
        }	

</style>


</html>
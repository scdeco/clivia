<%@ taglib prefix="ex" uri="/WEB-INF/miniataweb-tags.tld"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
<shared:header/>

  	<div id="grid"></div>
  	<div id="myGrid"></div>
    <ex:clivia-grid gridno="901" divid="grid"/>
    <ex:clivia-grid gridno="902" divid="myGrid" filter="gridId,eq,1"/>
    
<style>  
	#grid {
		height: 200px; 	
	}
	#myGrid {
		height: 400px; 	
	}
</style>
    
    

<shared:footer/>
package com.scdeco.miniataweb.tag;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.scdeco.miniataweb.dao.GridColumnDao;
import com.scdeco.miniataweb.dao.GridInfoDao;
import com.scdeco.miniataweb.model.GridColumn;
import com.scdeco.miniataweb.model.GridInfo;

public class CliviaGridTag extends SimpleTagSupport {

	GridInfoDao gridInfoDao;
	
	GridColumnDao gridColumnDao;
	
	private String gridno;
	public void setGridno(String gridno) {
		this.gridno = gridno;
	}
	
	private String divid;
	public void setDivid(String divid) {
		this.divid = divid;
	}
	
	private String filter;
	public void setFilter(String filter){
		this.filter=filter;
	}
 
	@Override
	  public void doTag() throws JspException, IOException {
		String prefix;
		PageContext pageContext = (PageContext) this.getJspContext(); 
		ServletContext servletContext = pageContext.getServletContext(); 
		WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext); 
	
		gridInfoDao=(GridInfoDao)wac.getBean("gridInfoDao");
		gridColumnDao=(GridColumnDao)wac.getBean("gridColumnDao");
		
	    JspWriter out = getJspContext().getOut();
	    StringBuilder sb=new StringBuilder();
	    
	    if(divid==null) divid="grid";
	    if(gridno!=null){

	    	GridInfo gridInfo=gridInfoDao.findByGridNo(gridno);
			List<GridColumn> gridColumnList=gridColumnDao.findColumnListByGridId(gridInfo.getId());
			
sb.append( "<script> $(document).ready(function() {");
sb.append("var crudServiceBaseUrl=\"http://192.6.2.108:8080/miniataweb/cliviagrid/"+gridInfo.getGridDaoName()+"/\",");

sb.append("dataSource=new kendo.data.DataSource({");

sb.append("transport:{");
sb.append("read:{url:crudServiceBaseUrl+\"read\",type:\"post\",dataType: \"json\",contentType:\"application/json\"},");  //+crudServiceBaseUrl+\"read\"+daoName
sb.append("update:{url:crudServiceBaseUrl+\"update\",type:\"post\",dataType: \"json\",contentType:\"application/json\"},");		
sb.append("create:{url:crudServiceBaseUrl+\"create\",type:\"post\",dataType: \"json\",contentType:\"application/json\"},");
sb.append("destroy:{url:crudServiceBaseUrl+\"destroy\",type:\"post\",dataType: \"json\",contentType:\"application/json\"},");
sb.append("parameterMap: function(options, operation) {"
				+"if (operation === \"read\"){"
				+ 	"return JSON.stringify(options);"
				+ 	"} else {"
				+ 	"return JSON.stringify(options.models);}}"
			+"},");
sb.append("error: function (e) {alert(\"Status:\" + e.status + \"; Error message: \" + e.errorThrown);},");

if(filter!=null){
	String[] filterItems=filter.split(";");
	if(filterItems.length>1){
		sb.append("filter: { logic: \"and\", filters:[");
		prefix="";
		for(String filterItem:filterItems){
			String[] items=filterItem.split(",");
			sb.append(prefix+"{ field:\""+items[0]+"\", operator:\""+items[1]+"\",value:\""+items[2]+"\"}");
			prefix=",";
		}
		sb.append("]}");
	}else{
		String[] items=filterItems[0].split(",");
		sb.append("filter:{ field:\""+items[0]+"\", operator:\""+items[1]+"\",value:\""+items[2]+"\"},");
		
	}
		
}
/* filter format
filter: {
    // leave data items which are "Food" or "Tea"
    logic: "and",
    filters: [
      { field: "category", operator: "eq", value: "Food" },
      { field: "name", operator: "eq", value: "Tea" }
    ]
  }
  */


sb.append("batch:true,");
sb.append("pageSize:"+gridInfo.getGridPageSize()+",");
sb.append("serverPaging: true,");
sb.append("serverFiltering: true,");
sb.append("serverSorting: true,");
sb.append("schema:{ data:\"data\", total:\"total\",model:{id:\"id\",fields:{");	
prefix="";
for(GridColumn gridColumn:gridColumnList){
	sb.append(prefix+gridColumn.getColumnName()+": { ");
	sb.append("type:\""+gridColumn.getColumnDataType()+"\",");
	sb.append("editable:"+gridColumn.isColumnEditable()+"}");
	prefix=",";
}
sb.append("}}}});");

//end of dataSource


sb.append("$(\"#"+divid+"\").kendoGrid({");
sb.append("dataSource:dataSource,");
sb.append("navigatable: true,");
sb.append("pageable: true,");
sb.append("toolbar: [\"create\", \"save\", \"cancel\"],");
sb.append("columns:[");

for(GridColumn gridColumn:gridColumnList){
	sb.append("{");
	sb.append("field:\""+gridColumn.getColumnName()+"\",");
	sb.append("title:\""+gridColumn.getTitle()+"\",");
	sb.append("width:"+gridColumn.getWidth());
	sb.append("},");
}

sb.append("{ command:\"destroy\", title:\"&nbsp;\",width:120}]," );
sb.append("editable:true");
sb.append("});");
sb.append("});");
sb.append("</script>");

sb.append("<style>");
sb.append(".k-grid td{	padding: 0.2em 0.2 em;	white-space: nowrap;}");
sb.append(".k-grid-header th.k-header {	padding: 0.2em 0.2em;}");
sb.append(".k-grid-header-wrap th {font-size: 12px;}");  
sb.append("</style>");

System.out.println(sb.toString());
	    out.println(sb.toString());
	  }
	}

} 
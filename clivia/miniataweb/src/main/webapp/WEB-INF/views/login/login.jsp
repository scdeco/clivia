<%@ page language="java" contentType="text/html; charset=ISO-8859-1"  pageEncoding="ISO-8859-1"%>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

<shared:header></shared:header>
<div id="version"><h2>Version:${version}</h2></div>
<div id="login">
	<form name="form1" action="login" method="post">
		<table >
		    <tr>
			        <td colspan="2">Please login</td>
		    </tr>
		    <tr>
		            <td>Username:</td>
		            <td>
		            	<input type="text" name="username" value="${username}" size="20">
		            </td>		            

		    </tr>
		    <tr>
		            <td>Password:</td>
		            <td><input type="text" name="password" value="${password}" size="20"></td>
		    </tr>
		    <tr>
		    	    <td colspan="2"><input type="submit" name="submit" value="Login"> </td>
		    </tr>
		    <tr>
		            <td>Date:</td>
		            <td><input id="datepicker"/> 
		                <script>
				            $(function() {
		        	    	    $("#datepicker").kendoDatePicker();
		            		});
		        		</script>    
		            </td>
		    </tr>
		    <tr>
		    	    <td colspan="2"><kendo:editor name="editor">${text}</kendo:editor>
		    	    </td>
		    </tr>
		</table>
	</form>
</div>
	
<shared:footer></shared:footer>
	
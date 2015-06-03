<%@ page language="java" contentType="text/html; charset=ISO-8859-1"  pageEncoding="ISO-8859-1"%>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

<shared:header></shared:header>
	<form name="form1" action="login" method="post">
		<table width="300" border="0">
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
		            <td><input type="password" name="password" value="${password}" size="20"></td>
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
	
<shared:footer></shared:footer>
	
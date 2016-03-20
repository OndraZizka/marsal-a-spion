<%@ page
	import="java.sql.Connection"
	import="java.sql.DriverManager"
	import="java.sql.SQLException"
	import="java.sql.Statement"
	import="java.sql.ResultSet"
%>
<%-- import="com.mysql.jdbc.*" 
	import="java.sql.*"
--%>

<title>JDBC JSP test raw</title>

<%
try {
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3350/test?user=root&password=viewsonic");
	Statement stmt = conn.createStatement();
	stmt = conn.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rs = stmt.executeQuery("SELECT 2 + 10 + 200");
	while(rs.next()){
		response.getWriter().write( rs.getObject(1).toString() );
	}
	/**/
	conn.close();
} catch (SQLException ex) {
	response.getWriter().write("<br>SQLException: " + ex.getMessage());
	response.getWriter().write("<br>SQLState: "     + ex.getSQLState());
	response.getWriter().write("<br>VendorError: "  + ex.getErrorCode());
}
%>

<br>Ahoj lidi
<%= 2 %>
${21 + 23}
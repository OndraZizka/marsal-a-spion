<%@page pageEncoding="windows-1250" contentType="text/html;charset=windows-1250"
	import="java.sql.Connection"
	import="java.sql.DriverManager"
	import="java.sql.SQLException"
	import="java.sql.Statement"
	import="java.sql.ResultSet"
%>
<%-- import="com.mysql.jdbc.*" 
	import="java.sql.*"
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"><html><head>
	<meta http-equiv="Content-Type" content="text/html; charset=windows-1250"/>
	<meta name="Author" content="Ondra ?i?ka, ondra at dynawest.cz; Design by Petr Záveský, petr.zavesky@seznam.cz"/>
	<meta name="Keywords" content=""/>
	<meta name="Description" content=""/>
	<link rel="stylesheet" type="text/css" href="dw_styles.css"/>
	<link rel="stylesheet" type="text/css" href="styl.css"/>
	<script type="text/javascript" charset="windows-1250" src="fce.js"></script>
<style type="text/css">
  body {
    background-color: #ffffff; color: black;
    font-family: "Arial CE", "Helvetica CE", "Verdana CE", Arial, Helvetica, Verdana, sans-serif;
  }
  table.playground { border-collapse: collapse; }
  table.playground td {
    border: 1px solid black;
  }
</style>
<script type="text/javascript">
</script>
<title>JDBC JSP test raw</title>
</head>
<body>

<h1>Maršál a špión</h1>

<table class="playground"><tbody>
  <% for(int i = 0; i < 10; i++){ %>
  <tr> <% for(int j = 0; j < 10; j++){ %> <td><%=i+" "+j%></td><%}%> </tr>
  <%}%>
</tbody></table>


<%
try {
  Class.forName("com.mysql.jdbc.Driver").newInstance();
  Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3350/marsal?user=root&password=viewsonic");
  Statement stmt = conn.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
  ResultSet rs;
  
  rs = stmt.executeQuery("SELECT 3 + 10 + 200");
  while(rs.next()){
    out.write( rs.getObject(1).toString() );
  }rs.close();
  /* TABLE marsal.ms_bitvy_figurky:  id id_bitva id_hrac id_typ policko x y */
  String sSQL = "SELECT id, id_typ, x, y FROM ms_bitvy_figurky AS bf WHERE bf.id_bitva = 1";
  rs = stmt.executeQuery(sSQL);
  while(rs.next()){
    out.write( rs.getObject(1).toString() );
  }rs.close();
  
  conn.close();
} catch (SQLException ex) {
  out.write("<br>SQLException: " + ex.getMessage());
  out.write("<br>SQLState: "     + ex.getSQLState());
  out.write("<br>VendorError: "  + ex.getErrorCode());
}
%>

<br>Ahoj lidi
<%= 2 %>
${21 + 23}


</body></html>
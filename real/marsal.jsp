<%@page pageEncoding="windows-1250" contentType="text/html;charset=windows-1250"
	import="java.sql.Connection"
	import="java.sql.DriverManager"
	import="java.sql.SQLException"
	import="java.sql.Statement"
	import="java.sql.ResultSet"
	import="java.util.Date"
	import="java.util.Calendar"
	import="java.text.DateFormat"
	import="cz.dynawest.marsal.*"
%>
<%@taglib uri="taglib_marsal" prefix="dw" %><%----%>
<%--@taglib prefix="c" uri="http://java.sun.com/jstl/ea/core" --%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
<dw:App>
	<dw:Connection host="localhost:3350" database="marsal" user="marsal" pass="marsal"/>
</dw:App> --%>
<%@ page import="java.util.Vector" %>
<h3>Iterating over a range</h3>
<c:forEach var="item" begin="1" end="10">
    ${item}
</c:forEach>

<jsp:useBean id="app" class="cz.dynawest.marsal.App" scope="application"></jsp:useBean>
<jsp:useBean id="db" class="cz.dynawest.marsal.DbAccess" scope="application">
	<jsp:setProperty name="db" property="host" value="localhost:3350"/>
	<jsp:setProperty name="db" property="db" value="marsal"/>
	<jsp:setProperty name="db" property="user" value="marsal"/>
	<jsp:setProperty name="db" property="pass" value="marsal"/>
	<jsp:setProperty name="db" property="connect" value="now"/>
</jsp:useBean>
<%--= db.sReport.replaceAll("\n", "<br>") --%>

<%
// --- Game --- //
Integer oiGameID = (Integer)session.getAttribute("game_id");
Game.GetInstanceByID(oiGameID);

//--- Players --- //
Integer oiPlayerID = (Integer)session.getAttribute("player_id");
Player.GetInstanceByID(oiPlayerID);

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<% String sNow = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM).format(new Date()); %>
<html><head>
	<meta http-equiv="Content-Type" content="text/html; charset=windows-1250"/>
	<meta name="Author" content="Ondra Žižka, ondra at dynawest.cz"/>
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
<title>JDBC JSP test raw <%=sNow%></title>
</head>
<body>

<h1>Maršál a špión <%=sNow%></h1>

<table class="playground"><tbody>
  <%for(int i = 0; i < 10; i++){%>
  <tr> <% for(int j = 0; j < 10; j++){ %> <td><%=i+" "+j%></td><%}%> </tr>
  <%}%>
</tbody></table>


<%
try {
  /*Class.forName("com.mysql.jdbc.Driver").newInstance();
  Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3350/marsal?user=root&password=viewsonic");
  Statement stmt = conn.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
  */
  Statement stmt = db.getStatement();
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
  
}catch (SQLException ex) {
  out.write("<br>SQLException: " + ex.getMessage());
  out.write("<br>SQLState: "     + ex.getSQLState());
  out.write("<br>VendorError: "  + ex.getErrorCode());
}catch (Exception e){ e.printStackTrace(); }
%>

<br>Ahoj lidi
<%= 2 %>
${21 + 23}


</body></html>
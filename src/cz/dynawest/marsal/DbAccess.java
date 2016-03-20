package cz.dynawest.marsal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
//import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.util.Date;

import javax.servlet.jsp.tagext.TagSupport;

public class DbAccess {
		  
  private Connection conn = null;
  private Statement stmt;
  public Statement getStatement() { return this.stmt; }
  
  private String sHost, sDB, sUser, sPass;
 	public void setHost(String host) { this.sHost = host; sReport += "setHost()\n"; }
	public void setDb(String db) { this.sDB = db; sReport += "setDb()\n"; }
	public void setPass(String pass) { this.sPass = pass; sReport += "setPass()\n"; }
	public void setUser(String user) { this.sUser = user; sReport += "setUser()\n"; }
	public void setConnect(String s) {
		sReport += "setConnect() "
			+ DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM).format(new Date())+"\n";
		this.CreateConnection();
	}
	
	public String sReport = ""; 
  
  public DbAccess() {
  	sReport += "DbAccess()\n";
  }
  
  public void CreateConnection() {
  	sReport += "CreateConnection()\n";
  	/*throws ClassNotFoundException, InstantiationException,
		IllegalAccessException, SQLException */		    
  	try {
	  	Class.forName("com.mysql.jdbc.Driver").newInstance();
	  	String sConnString = "jdbc:mysql://"+this.sHost+"/"+this.sDB
	  	  + "?user="+this.sUser+"&password="+this.sPass;
	    this.conn = DriverManager.getConnection(sConnString);
	    this.stmt = conn.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
  	}
  	catch (ClassNotFoundException e) { e.printStackTrace(); }
  	catch (Exception e) { e.printStackTrace(); }
  }
  
  
  
}
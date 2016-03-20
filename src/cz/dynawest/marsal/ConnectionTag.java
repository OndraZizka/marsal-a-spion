package cz.dynawest.marsal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
//import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.jsp.tagext.TagSupport;

public class ConnectionTag extends TagSupport {
		  
  private Connection conn = null;
  private Statement stmt;
  public Statement getStatement() { return this.stmt; }
  
  private String sHost, sDB, sUser, sPass;
	public void setHost(String host) { this.sHost = host; }
	public void setDatabase(String db) { this.sDB = db; }
	public void setPass(String pass) { this.sPass = pass; }
	public void setUser(String user) { this.sUser = user; }
  
  public ConnectionTag() {}
  
  public void CreateConnection() {
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
  
  public int doStartTag() {
  	this.CreateConnection();
 		javax.servlet.jsp.tagext.Tag tagParent = this.getParent();
		if( !(tagParent instanceof App) ) {
			((App)tagParent).setDbAccessTag(this);
		}
   	return TagSupport.SKIP_BODY;
	}// doStartTag()
  
}
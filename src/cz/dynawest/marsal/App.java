/*
 * App.java
 * Created on 2. èervenec 2006, 14:48
 */
package cz.dynawest.marsal;

import java.io.Serializable;

import javax.servlet.jsp.tagext.*;


/**  */
@SuppressWarnings("serial")
public class App extends BodyTagSupport {
	
	private ConnectionTag dbAccessTag;// K nicemu
	private DbAccess dbAccess;
	private int iID;
	
	public App(){
  }
	
	public void setDbAccess(DbAccess dbAccess){ this.dbAccess = dbAccess; }
	public DbAccess getDbAccess(){ return this.dbAccess; }
	
	public void setDbAccessTag(ConnectionTag dbAccessTag){ this.dbAccessTag = dbAccessTag; }
	public ConnectionTag getDbAccessTag(){ return this.dbAccessTag; }

	public int  getID() { return this.iID; }
	public void setID(int iID) { this.iID = iID; }
	
}

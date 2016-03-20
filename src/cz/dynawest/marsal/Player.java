/*
 * Player.java
 * Created on 2. èervenec 2006, 14:53
 */

package cz.dynawest.marsal;

import java.io.InvalidObjectException;
import java.io.Serializable;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;


/**  */
public class Player implements Serializable {

  /* id, nick, pass, posledni_tah */
	private boolean bSynced = false;
  private int iID;
  private String sNick, sPass;
  
  private static Map<Integer, Player> mapInstancePool = new HashMap<Integer, Player>();
  
  
  /**  Creates an instance, generates unique name,
   * creates a record in DB and returns the instance. 
   * */
  public static Player CreateInstance(Connection conn) {
  	Player player = new Player();
  	try {
  		String sNick;
  		Statement st = conn.createStatement(
  				ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
  		String sSQL = "SELECT MAX(id) FROM ms_hraci";
  		ResultSet rs = st.executeQuery(sSQL);
  		int iTryID = rs.getInt(1) + 1;
  		do {
  			rs.close();
  			sNick = "Host_"+iTryID;
  			rs = st.executeQuery("SELECT COUNT(*) FROM ms_hraci WHERE nick = '"+(sNick)+"'");
  		}while(rs.getInt(1) > 0);
  		rs.close();
  		
  		player = new Player();
  		player.sNick = sNick;
  		player.sPass = "";
  		st.executeUpdate(
          "INSERT INTO ms_players (id, nick, pass, posledni_tah) "
          +" VALUES (NULL, "+App.asq(sNick)+", '', NULL)",
          Statement.RETURN_GENERATED_KEYS);

  		player.iID = -1;
      rs = st.getGeneratedKeys();
      if( rs.next() ){
      	player.iID = rs.getInt(1);
      }else (new Exception("")).printStackTrace();
      rs.close();
      player.bSynced = true;
  	}catch (Exception e) { e.printStackTrace(); }
  	
  	return player;
  }
  
  public static Player GetInstanceByID(Connection conn, Integer oiID)
  			throws InvalidObjectException, NullPointerException {
  	if(null == oiID)
  		return Player.CreateInstance(conn);
  	else
  		return Player.GetInstanceByID(conn, oiID.intValue());
  }
  
  public static Player GetInstanceByID(Connection conn, int iID)
  			throws InvalidObjectException, NullPointerException {
  	Player player = mapInstancePool.get(Integer.valueOf(iID));
  	if(null != player)
  		return player;
  	return LoadInstanceByID(conn, iID);
  }
  
  public static Player LoadInstanceByID(Connection conn, int iID)
  			throws NullPointerException, InvalidObjectException {
  	try{
	  	if( conn.isClosed() )
	  		throw new NullPointerException("DB connection is closed.");
  	}catch (SQLException e) { throw new NullPointerException(e.getMessage()); }
  	
  	Player player = null;
  	try {
  		
  		Statement st = conn.createStatement(
  				ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
  		String sSQL = "SELECT nick FROM ms_hraci WHERE id = "+iID;
  		ResultSet rs = st.executeQuery(sSQL);
  		if(!rs.isAfterLast() && !rs.isBeforeFirst())
  			throw new InvalidObjectException("Bad player ID.");
  		
  		player = new Player();
  		player.sNick = rs.getString(1);
  		player.iID = iID;
  		
  	}catch (Exception e) { e.printStackTrace(); }
  	
  	return player;
  }
	
	public String serialize() {
		return String.valueOf(this.iID);
	}

}

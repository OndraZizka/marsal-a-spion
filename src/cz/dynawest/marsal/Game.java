package cz.dynawest.marsal;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class Game implements Serializable {
	
	private boolean bSynced;
	private Player player1 = null;
	private Player player2 = null;
	private int      iID;
  private String   sName;
  private int      iSetID, iRulesID, iRound;
  private boolean  bTurnPlayer2;
  private Date     dtLastRound, dtBegin;
  
  private static HashMap<String, String> aAttributes = new HashMap<String, String>();
  static {
  	aAttributes.put("id", "iID");
  	aAttributes.put("nazev", "sName");
  	aAttributes.put("id_sada", "iSetID");
  	aAttributes.put("id_pravidla", "iRulesID");
  }
  private static Map<Integer, Game> mapInstancePool = new HashMap<Integer, Game>();
  

  
  /**  Creates an instance, generates unique name,
   * creates a record in DB and returns the instance. 
   * */
  public static Game CreateInstance(Connection conn) {
  	Game game = new Game();
  	try {
  		String sName;
  		Statement st = conn.createStatement(
  				ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
  		String sSQL = "SELECT MAX(id) FROM ms_bitvy";
  		ResultSet rs = st.executeQuery(sSQL);
  		int iTryID = rs.getInt(1) + 1;
  		do {
  			rs.close();
  			sName = "Host_"+iTryID;
  			rs = st.executeQuery("SELECT COUNT(*) FROM ms_bitvy WHERE nazev = '"+(sName)+"'");
  		}while(rs.getInt(1) > 0);
  		rs.close();
  		
  		game = new Game();
  		game.sName = sName;
  		
  		st.executeUpdate(
        "INSERT INTO ms_bitvy (id, hrac1, hrac2, nazev, id_sada, id_pravidla," +
  			" kolo, zacatek, posledni_kolo, na_tahu_hrac2) " +
  			" VALUES (NULL, NULL, NULL, "+App.asq(game.sName)+", NULL, NULL, 0, NULL, NULL, false)",
  			Statement.RETURN_GENERATED_KEYS);

  		game.iID = -1;
      rs = st.getGeneratedKeys();
      if( rs.next() ){
      	game.iID = rs.getInt(1);
      }else (new Exception("")).printStackTrace();
      rs.close();
      game.bSynced = true;
  	}catch (Exception e) { e.printStackTrace(); }
  	
  	return game;
  }
  
  
  public static Game GetInstanceByID(Connection conn, int iID) {
  	Game game = mapInstancePool.get(Integer.valueOf(iID));
  	if(null != game)
  		return game;
  	return LoadInstanceByID(conn, iID);
  }
  
  public static Game LoadInstanceByID(Connection conn, int iID) {
  	return LoadInstanceByWhere(conn, "id = "+iID);
  }
  public static Game LoadInstanceByPlayerID(Connection conn, int iID) {
  	return LoadInstanceByWhere(conn, "hrac1 = "+iID+" OR hrac2 = "+iID);
  }
  /*public static Game LoadInstance(Connection conn, int iID) {
  	return LoadInstanceByWhere(" = "+iID);
  }*/
	
	public static Game LoadInstanceByWhere(Connection conn, String sWhere)
				throws NullPointerException {
		try{
	  	if( conn.isClosed() )
	  		throw new NullPointerException("DB connection is closed.");
  	}catch (SQLException e) { throw new NullPointerException(e.getMessage()); }
  	
		Game game = new Game();
		try {
  		
  		Statement st = conn.createStatement(
  				ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
  		/* id hrac1 hrac2 nazev id_sada id_pravidla kolo zacatek posledni_kolo na_tahu_hrac2 */
  		String sSQL = "SELECT id, hrac1, hrac2, nazev, id_sada, id_pravidla," +
  				"kolo, zacatek, posledni_kolo, na_tahu_hrac2 " +
  				"FROM ms_bitvy WHERE "+sWhere;
  		ResultSet rs = st.executeQuery(sSQL);
  		  		
  		game.iID = rs.getInt(1);
  		game.sName = rs.getString(4);
  		
  	}catch (Exception e) { e.printStackTrace(); }
  	
  	return game; 
	}
		
	public String serialize() {
		return String.valueOf(this.iID);
	}
}

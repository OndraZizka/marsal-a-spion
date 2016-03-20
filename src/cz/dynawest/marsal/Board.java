/*
 * Board.java
 */

package cz.dynawest.marsal;

// import java.sql.DriverManager;
// import java.sql.SQLException;
import java.sql.*;
import java.util.LinkedList;





public class Board {
  
  private int iID;
  private int iCols, iRows;
  private LinkedList<Pawn> aoPawns;
  
  public String toString(){
    return String.format("Board %ix%i, %i pawns", this.iCols, this.iRows, this.aoPawns.size());
  }
  
  /* Dimensions... */
  public int  getCols()         { return this.iCols; }
  public void setCols(int iCols){ this.iCols = iCols; }
  public int  getRows()         { return this.iRows; }
  public void setRows(int iRows){ this.iRows = iRows; }
  
  /* Pawns */
  public void AddPawn(Pawn oPawn){ this.aoPawns.add(oPawn); }
  public void RemPawn(Pawn oPawn){ this.aoPawns.remove(oPawn); }
  public void DoMove(Pawn oPawn, int iX, int iY) throws ArrayIndexOutOfBoundsException {
    if( 0 > iX || iX > this.iCols-1  ||  0 > iY || iY > this.iRows-1 )
      throw new ArrayIndexOutOfBoundsException("Position out of board - X,Y: ["+iX+","+iY+"] vs. ["+this.iCols+","+iRows+"]");
  }
  
  /** Creates a new instance of Board */
  public Board(int iID) {
    aoPawns = new LinkedList<Pawn>();
  }
  
}

<?if(!$myemail)include "inc.php3"; $cver="0.0.1";?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"><HTML><HEAD>
	<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1250">
�	<META name="Keywords" content="Mar��l a �pi�n">
	<META name="Description" content="">
<title> <?echo $cver;?> </title></head><body><basefont face="Arial">
<center>
<img src="imgs/title.gif" border="0" alt="">
<!-- NOVA HRA -->
<table width="600"><tr><td><table><form action="newgame.php3">
	<input type="hidden" name="xnewgame" value="1">
	<tr><td colspan="2"><font size="+2"><b>Za��t novou hru</b></font></td></tr>
	<tr><td><input type="text" name="xkdo" value=""></td>		<td>Kdo</td></tr>
	<tr><td><input type="text" name="xskym" value=""></td>		<td>S k�m</td></tr>
	<tr><td><input type="text" name="xgamename" value=""></td>		<td>N�zev hry</td></tr>
	<tr><td align="center" colspan="2"><input style="width:100%" type="submit" value="Za��t"></td></tr>
</form></table></td></tr></table>

<!-- NAHRAT HRU -->
<table width="600"><tr><td><table><form action="loadgame.php3">
	<input type="hidden" name="xload" value="">
	<tr><td colspan="2"><font size="+2"><b>Nahr�t ulo�enou hru</b></font></td></tr>
	<tr><td><input type="text" name="xgamename" value=""></td>		<td>ID ulo�en� hry</td></tr>
	<tr><td><input type="text" name="xsavepass" value=""></td>		<td>heslo</td></tr>
	<tr><td align="center" colspan="2"><input style="width:100%" type="submit" value="   Nahr�t   "></td></tr>
</form></table></td></tr></table>

<!-- PRIPOJIT SE -->
<table width="600"><form action="marsal.php3"><tr><td>
	<table width="50%"><tr><td colspan="4"><font size="+2"><b>Zapojit se do hry</b></font></td></tr>
	<tr><td><b>Kdo</b></td> <td><b>S&nbsp;k�m</b></td> <td><b>ID hry</b></td> <td>&nbsp;</td> </tr>
	
<?do{
	if(!$spoj = @mysql_Pconnect("localhost")){echo "Nejde se spojit s db."; break;}
	if(!mysql_select_db("marsal")){echo "Sorry - nejde se dostat do databaze."; break;}
	
	$sql = "SELECT battles.kdo, battles.skym, saves.save FROM battles, saves WHERE battles.id = saves.game";
	if(!$rs = @mysql_query($sql)) {echo "Ne rs!"; echo mysql_error(); break;}
	
	while($a = mysql_fetch_array($rs, MYSQL_ASSOC)):
	?><tr>
	<td width="50%"><?echo $a["kdo"];?></td>
	<td><?echo $a["skym"];?></td>
	<td width="50%"><?echo $a["save"];?></td>
	<td width="50%"><a href="load.php3?xgamename=<?echo $a["save"];?>">Otev��t</a></td>
	</tr><?
	endwhile;
}while(false);
?></table>
	
</form></td></tr></table>

</center>

<center><font size="3">&copy; <a href="mailto:opi@volny.cz">O</a>ndra <a href="http://opi.kgb.cz">�</a>i�ka, 2000</font></center>
</body></html>

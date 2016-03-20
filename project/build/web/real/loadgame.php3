<?if(!$myemail)include "inc.php3"; $cver="0.0.1";?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"><HTML><HEAD>
	<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1250">
	<META NAME="Author" CONTENT="Opi; opi@volny.cz">
	<META name="Reply-to" content="opi@volny.cz">
	<META NAME="GENERATOR" CONTENT="Homesite 4.5.1">
	<META name="Keywords" content="opi, php">
	<META name="Description" content="">
<title> <?echo $cver;?> </title></head><body><basefont face="Arial">
<center>
<img src="imgs/title.gif" border="0" alt="">

<?$adr="loadgame.php3";
	while($xgamename){
	if(!$spoj = @mysql_Pconnect("localhost")) {$mess = "Nejde se spojit s db."; break;}
	if(!@mysql_select_db("marsal")){$mess = "Sorry - nejde se dostat do databaze."; break;}
	$rs = @mysql_query("SELECT * FROM saves, battles WHERE save LIKE '$xgamename'",$spoj);
	if(!$a = mysql_fetch_array($rs)) {$mess = "Uložená hra s názvem $xgamename tu nejni'voe."; break;}
	if($xsavepass != $a["heslo"]) {$mess = "Špatné heslo."; break;}
	//if($xok) echo '<META http-equiv="Refresh" content="0; marsal">';
	$ok=1; $adr="marsal.php3";	break;
}?>
<!-- NAHRAT HRU -->
<table width="600"><tr><td><table><form method="post" action="<?echo $adr;?>">
	<input type="hidden" name="xloadgame" value="1">
	<?if($mess):?>
	<tr><td align="center" colspan="2"><font color="Red"><i><?echo $mess;?></i></font></td></tr>
	<?endif;?>
	<tr><td colspan="2"><font size="+2"><b>Nahrát uloženou hru</b></font></td></tr>
	<tr><td><input type="text" name="xgamename" value="<?echo $xgamename;?>"></td>		<td>ID uložené hry</td></tr>
	<tr><td><input type="text" name="xsavepass" value="<?echo $xsavepass;?>"></td>		<td>heslo</td></tr>
	<?if($ok):?><tr><td>Hraješ jako</td>
	<td><select name="xuser1"><option value="1"><?echo $a["kdo"];?><option value="1"><?echo $a["skym"];?></select></td>  </tr>
	<input type="hidden" name="xok" value="1">
	<?endif;?>
	<tr><td align="center" colspan="2"><input style="width:100%" type="submit" value="   Nahrát   "></td></tr>
</form></table></td></tr></table>

</center>

<center><font size="3">&copy; <a href="mailto:opi@volny.cz">O</a>ndra <a href="http://opi.kgb.cz">Ž</a>ižka, 2000</font></center>
</body></html>

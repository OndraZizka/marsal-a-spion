<?if(!$myemail)include "inc.php3"; $cver="0.0.1";?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"><HTML><HEAD>
	<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1250">
	<META NAME="Author" CONTENT="Opi; opi@volny.cz">
	<META name="Reply-to" content="opi@volny.cz">
	<META NAME="GENERATOR" CONTENT="Homesite 4.5.1">
	<META name="Keywords" content="opi, php">
	<META name="Description" content="">
<title> Maršál a špión <?echo $cver;?> </title></head><body>

<? include "marsal.inc.php3";
if(!$spoj = @mysql_Pconnect("localhost")){die("Nejde se spojit s db.");}
if(!mysql_select_db("marsal")){die("Sorry - nejde se dostat do databaze.");}


if(1){
	$battle = Array();  // battle [y, x, 0] - typ jednotky      // battle [y, x, 1] - user1==vlastnik
	for($y=1; $y<=4; $y++) for($x=1; $x<=10; $x++) {$battle[$y][$x][0]=rand(1,11); $battle[$y][$x][1]=0;}
	for($y=8; $y<=11; $y++) for($x=1; $x<=10; $x++) {$battle[$y][$x][0]=50; $battle[$y][$x][1]=1;}
}
?>

<script>
var dragco, gogo=0;
var celkem = new Array(  // popis, pocet, pocet ve hre
0, //0
new Array("minové pole",8), //1
new Array("maršál",1), //2
new Array("generál",1),
new Array("kapitán",2), //4
new Array("kadet",3),
new Array("kaprál",4), //6
new Array("průzkumník",8),
new Array("střelec",5), //8
new Array("minér",6),
new Array("špión",1), //10
new Array("prapor",1)
);
celkem[50]=new Array("Nic", 0);

function clickit(co){
	if(!dragco){
		dragco=Array(co.unit, co);
		co.border = 3;
	}else if(co.border > 0){co.border = 0; dragco=0;}
	else if(co.border == 0){dragco[1].border=0; dragco=Array(co.unit, co); co.border = 3;}
}

function clickbf(co){
	if(!dragco) return;
	if(co.className=="green"){
		celkem[co.unit][1]++;
		celkem[dragco[0]][1]--;
		drow=(dragco[0]==50?0:dragco[0]);
		crow=(co.unit==50?0:co.unit);
		document.all.mt.rows[drow].cells[1].all[0].innerText = celkem[dragco[0]][1];
		document.all.mt.rows[crow].cells[1].all[0].innerText = celkem[co.unit][1];
		co.all[0].src="units/unit"+dragco[0]+".gif";
		co.unit = dragco[0];
	}
}

function moveover(co){
	var ok = 0; 	if(!dragco) return;
	status = celkem[dragco[0]][0]+",  Zbývá:  "+celkem[dragco[0]][1];
	if(co.unit>0 && co.own>0 && celkem[dragco[0]][1]>0) ok=1;
	
	co.className=(ok?"green":"red");
	if(ok==2){co.className="attack";}
}
function mouseout(co){	if(co.className!="active")	co.className = "";}

function go(){
	with(document.all.bf){
		for(y=0; y<11;y++)
			for(x=0; x<10;x++)
				document.forms[0].xbf.value+= rows[y].cells[x].unit + "|";
	}
	alert(document.forms[0].xbf.value);
}

//--></script>
<style>
.active{background-color:#fcdfab; border:10px}
.dragged{background-color:#ff6666}
.draggedover{background-color:#ff6666}
.dropped{background-color:#0000ff}
.green{background-color:#00aa00}
.red{background-color:#ff6666}
.attack{background-color:#663366}
</style>
<!-- zacatek celkove -->
<table><tr><td>

<table bgcolor="Red" cellspacing="3" cellpadding="0" border="2" id="bf" name="bf"><tbody>
<?
for($y=1; $y<=11; $y++){	?><tr><?
	for($x=1; $x<=10; $x++){
		// mezera
		if($y==5 && ($x==4 || $x==7)):?><td valign="middle" rowspan="3" bgcolor="White" width="60" height="180" bordercolor="White"
		unit="100"><img width="60" height="120" src="imgs/prapor<?echo++$praporindex;?>.gif" border="0" alt=""></td><?
		// neni to jedna z mezer
		elseif(!(($y==6 || $y==7) && ($x==4 || $x==7))):
		$cunit = $battle[$y][$x][0]; $own = $battle[$y][$x][1];
		?>	<td bgcolor="#ffc959" width="60" height="60" bordercolor="White" xpos="<?echo $x;?>" ypos="<?echo $y;?>" unit="50" own="<?echo $own;?>"
	onclick="clickbf(this);" onmousemove="moveover(this);" onmouseout="mouseout(this);"><?
			if($cunit){
				$cimg = (($battle[$y][$x][1]) ? "unit$cunit.gif" : "enemy2.gif");
			?><img src="units/<?echo$cimg;?>" width="60" height="60" border="0" alt="" id="img<?echo $y*10+$x;?>" style="position:relative;"><?
			}
			else {?><img src="" border="0" alt="" style="visibility:hidden"><?};
			echo "</td>";
		// mezera + nic
		else: ?><td style="display : none;" unit="100"></td><?
		endif; echo "\n";
	}	?></tr><? echo "\n";
}
?>
</tbody></table>

<!-- menu tabulka -->
</td><td>

<table cellpadding="0" cellspacing="0" id="mt" name="mt"><tbody>
<tr><td><img unit="50" src="units/unit50.gif" border="0" alt="" onclick="clickit(this);"></td><td><font size="+4">0</font></td></tr>
<?for($i=1; $i<=11; $i++):?><tr><td><img unit="<?echo $i;?>" src="units/unit<?echo $i;?>.gif" border="0" alt="" onclick="clickit(this);"></td>
<td><font size="+4"><script>document.write(celkem[<?echo $i;?>][1]);</script></font></td> </tr><?endfor;?>
</tr></tbody></table>

<!-- info tabulka -->
</td><td valign="top">

<table>
	<tr><td align="center"><font size="+3"><b>Maršál a špión</b></font></td></tr>
	<tr><td align="center"><font size="+2"><?echo "$xkdo vs. $xskym";?></font></td></tr>
	<tr height="60%"><td>Rozestav si armádu a zahaj hru. Tipy:
		Prapor obestav minami. Do druhého minového hnízda	dej vysokou hodnost, která zabije minéra.
		Nedávej všechny průzkumníky dopředu. Minéry dej přibližně doprostřed. A na další triky si přiď sám.
	</td></tr>
	<form action="marsal.php3?newgame=1" method="post">
	<tr><td><input type="image" src="imgs/zahaj.gif" alt="Zahájit hru" onclick="go()"></td></tr>
	<input type="hidden" name="xbf" value="">
	</form>
	
</table>

<!-- konec celkove -->
</td></tr></table>

<form action="marsal.php3" method="get" style="display:none;">
<input type="hidden" name="xgameid" value="<?echo $xgameid;?>">
<input type="hidden" name="xx" value="">
<input type="hidden" name="xy" value="">
</form>

<center><font size="3">&copy; <a href="mailto:opi@volny.cz">O</a>ndra <a href="http://opi.kgb.cz">Ž</a>ižka, 2000</font></center>
</body></html>

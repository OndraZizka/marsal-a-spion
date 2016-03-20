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

$battle = Array();  // battle [y, x, 0] - typ jednotky      // battle [y, x, 1] - user1==vlastnik

if($xloadgame){	$sql="SELECT game FROM saves WHERE save='$xgamename'"; $xgameid = mysql_result(@mysql_query($sql),0,0); }

// nova hra, prave spustena
if($xnewgame && $xbf){
	// user1
	$a = explode("|", $xbf);
	for($y=8; $y<=11; $y++) for($x=1; $x<=10; $x++) {
		//echo (($y-8)*10+$x-1)." -> ".$a[($y-8)*10+$x-1].";  ";
		$battle[$y][$x][0]=$a[($y-8)*10+$x-1]; $battle[$y][$x][1]=1;	}
	// user2
	for($y=1; $y<=4; $y++) for($x=1; $x<=10; $x++) {$battle[$y][$x][0]=7; $battle[$y][$x][1]=0;}
	
	$blob = serialize($battle);
	$sql="INSERT INTO battles VALUES (NULL, '$xkdo', '$xskym', NULL, '$blob')"; @mysql_query($sql);
	$xgameid = mysql_insert_id();
	$sql="INSERT INTO saves VALUES ($xgameid, '$gamename', '')"; @mysql_query($sql);
}
// pokracovani hry, popr. prave nahrano
elseif($xgameid){
	$sql="SELECT blob FROM battles WHERE id=$gameid"; $rs=@mysql_query($sql);
	$a = mysql_fetch_array($rs);
	$battle = unserialize($a["blob"]);
}

// zadny vstup - vygenerovat nahodnou stranku
if(!$newgame && !$gameid){ // popripade dat gamename, kdyby podvadeli
	srand ((double) microtime() * 1000000);
	for($y=1; $y<=4; $y++) for($x=1; $x<=10; $x++) {$battle[$y][$x][0]=rand(1,11); $battle[$y][$x][1]=0;}
	for($y=8; $y<=11; $y++) for($x=1; $x<=10; $x++) {
		do{$unit = rand2unit(rand(1,40));	$units[$unit][2]++;}  while($units[$unit][2] > $units[$unit][1]);
		$battle[$y][$x][0]=$unit; $battle[$y][$x][1]=1;
	}
	$blob = serialize($battle);
	//@mysql_query($sql); echo mysql_error();
}

if($xloadgame){
	$sql = "SELECT * FROM saves WHERE save LIKE '$x'";
}
?>

<script>
var dragco, gogo=0;

function clickit(co){
	if(!dragco){
		if(co.unit==1 || co.unit==11 || co.own==0) return;
		dragco=Array(co.ypos, co.xpos, co.unit, co);
		if(co.unit==7) dragco[4]=firststone(); // prvni konecne pole pro kone
		co.className = (co.className=="active"? "":"active");
	}	else if(co.className=="green" || co.className=="attack"){
		moveimg(dragco, co, 0,0);
		co.className = "";
		with(document.froms[0]){
			xx.value=dragco[1]; xy.value=dragco[1];
			xxnew.value=co.xpos; xynew.value=co.ypos;
			xaction.value = (co.className=="green"?1:2);
			submit();
		}
	}	else if(co.className=="red"){
		co.className = "";
		dragco[3].className="";
		dragco=0;
	}
}

function moveimg(dragco, co, yoff, yoff){
	imgtomove = dragco[3].all[0];
	/*yoff = co.ypos - dragco[0];
	xoff = co.xpos - dragco[1];
	imgtomove.style.top += yoff*64; 
	imgtomove.style.left += xoff*64;
	//setTimeout("", 100);
	//if(!(yoff==0 && xoff==0)) return;*/
			
	co.all[0].src="units/unit"+dragco[2]+".gif";
	co.all[0].style.visibility = "visible";
	co.unit = dragco[2];
	co.own = 1;
	co.className="";
	imgtomove.src="";
	imgtomove.style.visibility = "hidden";
	dragco[3].className="";
	dragco[3].unit=0;
	dragco[3].own=0;
	window.dragco=0;
}

function moveover(co){
	var ok = 0; 	if(!dragco) return;
	window.status = dragco+' '+co.ypos+', '+co.xpos;
	if((dragco[0]==co.ypos) && (dragco[1]==co.xpos)) return;  // stejna figura
	window.status = dragco+' '+co.ypos+', '+co.xpos+', '+co.unit+'  ...  OWN:   '+ (co.own);
	// kůň //
	if(dragco[2]==7){	window.status += "  Kůň";
		o = dragco[4]; // omezeni pohybu jinymi kameny
		if(co.ypos < o[0] || co.ypos > o[1] || co.xpos < o[2] || co.xpos > o[3]);
		else if(co.unit<1){
			if(   (dragco[1]-co.xpos)==0 	) ok = 1;
			if(   (dragco[0]-co.ypos)==0 	) ok = 1;
			if(   Math.abs(dragco[1]-co.xpos)==1 && Math.abs(dragco[0]-co.ypos)==1 ) ok = 1;
		}else{
			if(co.own==0)
				if( ( (dragco[1]-co.xpos)==0 ) ||
				   (Math.abs(dragco[1]-co.xpos)==1 && (dragco[0]-co.ypos)==0) ||
				   (Math.abs(dragco[0]-co.ypos)==1 && (dragco[1]-co.xpos)==0)	 ) ok = 2;
		}
	// jina jednotka nez kun
	}	else {
		if(co.unit<1){
			if(   Math.abs(dragco[1]-co.xpos)<=1 && Math.abs(dragco[0]-co.ypos)<=1 ) ok = 1;
		}else if(co.own==0){
			if(  (Math.abs(dragco[1]-co.xpos)==1 && (dragco[0]-co.ypos)==0) ||
			     (Math.abs(dragco[0]-co.ypos)==1 && (dragco[1]-co.xpos)==0)	 ) ok = 2;
		}
	}
	co.className=(ok?"green":"red");
	if(ok==2){co.className="attack";}
}
function mouseout(co){	if(co.className!="active")	co.className = "";}
	//81
function firststone(){
	ret = new Array(0,12,0,11); xc = dragco[1]-1; yc = dragco[0]-1;
	with(document.all.bf){
		for(i=1*dragco[0]-1; i>0; i--){if(rows[i-1].cells[xc].unit>0){ret[0] = i; break;}} // nahoru
		for(i=1*dragco[0]+1; i<12; i++){if(rows[i-1].cells[xc].unit>0){ret[1] = i; break;}} // dolu
		for(i=1*dragco[1]-1; i<11 && i>0;  i--){if(rows[yc].cells[i-1].unit>0){ret[2] = i; break;}} //vlevo
		for(i=1*dragco[1]+1; i<11 && i>0; i++){if(rows[yc].cells[i-1].unit>0){ret[3] = i; break;}} //vpravo
	}
	return ret;
}

//--></script>
<style>
.active{background-color:#fcdfab}
.dragged{background-color:#ff6666}
.draggedover{background-color:#ff6666}
.dropped{background-color:#0000ff}
.green{background-color:#00aa00}
.red{background-color:#ff6666}
.attack{background-color:#663366}
</style>
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
		?>	<td bgcolor="#ffc959" width="60" height="60" bordercolor="White" xpos="<?echo $x;?>" ypos="<?echo $y;?>" unit="<?echo (int)$cunit;?>" own="<?echo (int)$own;?>"
	onclick="clickit(this);" onmousemove="moveover(this);" onmouseout="mouseout(this);"><?//ondragstart="drag(this)"
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

<form action="marsal.php3" method="post" style="display:none;">
<input type="hidden" name="xgameid" value="<?echo $xgameid;?>">
<input type="hidden" name="xx" value="">
<input type="hidden" name="xy" value="">
<input type="hidden" name="xxnew" value="">
<input type="hidden" name="xynew" value="">
<input type="hidden" name="xaction" value="">
</form>

<center><font size="3">&copy; <a href="mailto:opi@volny.cz">O</a>ndra <a href="http://opi.kgb.cz">Ž</a>ižka, 2000</font></center>
</body></html>

<?
$units = Array(1=>  // popis, pocet, pocet ve hre
Array("minové pole",8), //1
Array("maršál",1), //2
Array("generál",1),
Array("kapitán",2), //4
Array("kadet",3),
Array("kaprál",4), //6
Array("prùzkumník",8),
Array("støelec",5), //8
Array("minér",6),
Array("špión",1), //10
Array("prapor",1)
);
function rand2unit($x){ global $units; // 1,2,3,5,8,12, 20, 25, 31,32,40
for($i=1; $i<=11; $i++) { if($x<=($ofs+=$units[$i][1])) return $i; }
// zvysene sance - dodelat
}

/*function explo($str){
$ret = Array();
$tok = strtok($str, "|");
while($tok){$ret[$i++]=$tok."fuck"; $tok=strtok("|");}
return $ret;
}*/

function explo($str){	$ret = Array();
while($pos = strpos(" ".$str, "|")){
	$ret[$i++]= substr($str, 0,$pos-1);
	$str = substr($str, $pos);	
}return $ret;}
?>
/* generated javascript */var skin = 'myskin';
var stylepath = '/skins';/* MediaWiki:Myskin */
function transformPage() {
  /* Remove the top "tabs" from the .portlet side column (why were they ever put there?) and put them at the top of the content area, where they belong! (This allows me to use simple  relative positioning to get a proper layout. I don't have to mess around with absolute  positioning. */
 
  var bodycontent = document.getElementById('bodyContent');
  var tabs = document.getElementById('p-cactions');
  bodycontent.parentNode.insertBefore(tabs,bodycontent);

/* move #personal down the column */
  var personal = document.getElementById('p-personal');
  var tb = document.getElementById('p-tb');
 
  personal.parentNode.insertBefore(personal,tb);
}

function reformatMyPage() {
  var mpTitle = "Hlavní strana - DeskoveHry";
  var isMainPage = (document.title.substr(0, mpTitle.length) == mpTitle)
  
  if (isMainPage) { 
    var bodycontent = document.getElementById('bodyContent');
    var fakehead = document.getElementById('fakehead');
    var fh = bodycontent.parentNode.getElementsByTagName("h1");
    var gw = document.getElementById('globalWrapper');
    
    gw.className = "mainPage";

    bodycontent.parentNode.insertBefore(fakehead,bodycontent);
    fh[0].parentNode.removeChild(fh[0]);
  }
  
  transformPage(); 
}   
 
if (window.addEventListener) window.addEventListener("load",reformatMyPage,false);
else if (window.attachEvent) window.attachEvent("onload",reformatMyPage);
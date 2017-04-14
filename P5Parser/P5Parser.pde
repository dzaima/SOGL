import java.util.Collections; //<>// //<>//
String ALLCHARS = "⁰¹²³⁴⁵⁶⁷⁸\t\n⁹±∑«»æÆø‽§°¦‚‛⁄¡¤№℮½ !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~←↑↓≠≤≥∞√═║─│≡∙∫○׀′¬⁽⁾⅟‰÷╤╥ƨƧαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσΤτΥυΦφΧχΨψΩωāčēģīķļņōŗšūž¼¾⅓⅔⅛⅜⅝⅞↔↕∆≈┌┐└┘╬┼╔╗╚╝░▒▓█▲►▼◄■□…‼⌠⌡͏→“”‘’";
//numbers         │x xxxx    |  x xx  x    x       x x|xx     xxxxx xxxxxxxxxxx xxxx       xxxxxxxxxx    x /x xxx|xx  xxxxx    xx   xxxx xx xx xx x    xxx    x   x  /     x x       xxx           xx              xxx          x            xx                                   x x x│
//strings         │x  xxx    |  x xx  x            x x|xx     xxx x xxxxxxxxxxx  x x       x  xxxxxxx    x /x xx |x   xxxxx    xx   xxxx xx  x x  x    x               x     x       xx      xxx                x               xx       x                                        x x x│
//arrays          │x  x      |        x            x /|xx     / x x xxxxxxxxxxx                 xxxxx       x xx |x x xxxxx        xxxx  x   x x  x              /                                                              x/       /  D                 /                        │
//^^ are the currently supported functions
String printableAscii =  " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
boolean prcon = true;
String ASCII = "";
//0,28,30,31,30,28,33, 29,26'25, 24
final int NONE = 0;
final int STRING = 2;
final int BIGDECIMAL = 3;
final int ARRAY = 4;
final int INS = 5;//input string
final int INN = 6;//input number
boolean debug;
boolean debugConsole = true;
boolean decompressInfo = false; 
import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;
import java.math.MathContext;
StringList log = new StringList();
StringList expl = new StringList();
//import java.math.BigInteger;
//P5ParserV0_6 SK = this;
void setup () {
  for (int i=0; i<256; i++)ASCII+=char(i)+"";
  String lines[] = loadStrings("p.sogl");
  JSONObject options = loadJSONObject("options.json");
  debug = options.getBoolean("debug");
  String program = lines[0].replace("¶", "\n");
  String[] inputs = new String[lines.length-1];
  for (int i = 1; i < lines.length; i++) {
    inputs[i-1]=lines[i];
  }
  //z’¤{«╥q;}x[p     { =4b*I*:O =Ob\"   =”*o        ]I³r3w;3\\+
  new Executable(program, inputs).execute();
  if (options.getBoolean("log")) {
    String j =log.join("");
    if (j.charAt(0)=='\n') j=j.substring(1);
    //if (j.charAt(j.length()-1)=='\n') j=j.substring(0,j.length()-2);
    String[]o={j};
    saveStrings("output.txt", o);
  }
  if (debug) {
    String[]o2={expl.join("")};
    saveStrings("log.txt", o2);
  }
}
//small fix so this would work properly on APDE
int afix;
void draw() {
  afix++;
  if (afix>10) exit();
}



BigDecimal B (float a) {
  try {
    return new BigDecimal(a);
  }
  catch (Exception e) { 
    println("B-floatE: \""+a+"\" - "+e.toString());
    oprintln(e);
    return B(0);
  }
}
BigDecimal B (String a) {
  try {
    return new BigDecimal(a);
  }
  catch (Exception e) { 
    println("B-string error from \""+a+"\": "+e.toString());
    return B(0);
  }
}
boolean truthy (poppable p) {
  if (p.type==BIGDECIMAL) 
    return !p.bd.equals(B(0));
  else if (p.type==STRING)
    return p.s!="";
  else if (p.type==NONE)
    return false;
  return p.a.size()!=0;
}
boolean falsy (poppable p) {
  if (p.type==BIGDECIMAL) 
    return p.bd.equals(B(0));
  else if (p.type==STRING)
    return p.s.equals("");
  else if (p.type==NONE)
    return true;
  return p.a.size()==0;
}



void oprint (String o) {
  if (prcon) print(o);
  log.append(o);
}
void eprintln (String o) {
  if (prcon) println(o);
  expl.append(o+"\n");
}
void eprint (String o) {
  if (prcon) print(o);
  expl.append(o);
}
void oprintln (String o) {
  if (prcon) println(o);
  log.append(o+"\n");
}
void oprint (BigDecimal o) {
  if (prcon) print(o);
  log.append(o.toString());
}
void oprintln (BigDecimal o) {
  if (prcon) println(o);
  log.append(o.toString()+"\n");
}
void oprint (JSONArray o) {
  if (prcon) print(o);
  log.append(o.toString());
}
void oprintln (JSONArray o) {
  if (prcon) println(o);
  log.append(o.toString()+"\n");
}
void oprintln () {
  if (prcon) println();
  log.append("\n");
}
void oprintln (Exception o) {
  if (prcon) println(o);
  expl.append(o.toString()+"\n");
}
String up0 (int num, int a) {
  String res = str(num);
  while (res.length()<a) {
    res = "0"+res;
  }
  return res;
}
poppable array (String[] arr) {
  ArrayList<poppable> o = new ArrayList<poppable>();
  for (String s : arr)
    o.add(tp(s));
  return new poppable(o);
}
ArrayList<poppable> array (poppable[] arr) {
  ArrayList<poppable> o = new ArrayList<poppable>();
  for (poppable s : arr)
    o.add(s);
  return o;
}
poppable[] array (ArrayList<poppable> arr) {
  poppable[] o = new poppable[arr.size()];
  for (int i = 0; i < o.length; i++)
    o[i] = (arr.get(i));
  return o;
}
/*string[] stringArr(JSONArray j) {
  String[] s = new String[j.size()];
  for (int i = 0; i < s.length; i++) {
    s[i] = j.getString(i);
  }
  return s;
}*/
ArrayList<poppable> ea() {
  return new ArrayList<poppable>();
}
poppable tp(String s) {//to poppable
  return new poppable(s);
}
poppable tp(BigDecimal bd) {
  return new poppable(bd);
}
poppable tp(ArrayList<poppable> bd) {
  return new poppable(bd);
}
String spaceup (String s, int l) {
  while (s.length()<l)
    s+=" ";
  return s;
}
ArrayList<poppable> spacesquared(ArrayList<poppable> arr) {
  ArrayList<poppable> res = new ArrayList<poppable>();
  int l = 0;
  for (poppable b : arr) {
    if (b.s.length() > l)
      l = b.s.length();
  }
  int i = 0;
  for (poppable b : arr) {
    res.add(tp(spaceup(b.s, l)));
    i++;
  }
  return res;
}
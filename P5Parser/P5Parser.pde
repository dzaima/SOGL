import java.util.Collections; //<>//
String ALLCHARS = "⁰¹²³⁴⁵⁶⁷⁸\t\n⁹±∑«»æÆø‽§°¦‚‛⁄¡¤№℮½← !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~↑↓≠≤≥∞√═║─│≡∙∫○׀′¬⁽⁾⅟‰÷╤╥ƨƧαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσΤτΥυΦφΧχΨψΩωāčēģīķļņōŗšūž¼¾⅓⅔⅛⅜⅝⅞↔↕∆≈┌┐└┘╬┼╔╗╚╝░▒▓█▲►▼◄■□…‼⌠⌡¶→“”‘’";
//numbers         │x xxxx   | |x xxxxxxx   x   x   x  x|xx     xxxxx xxxxxxxxxxx xxxx       xxxxxxxxxx    x /x xxx|xx  xxxxx    xx   xxxx xx xx xx x   xxx    x   x  /     x x       xxx           xx              xxx          x            xx                    x  x             x x│
//strings         │x  xxx   | |x xxxxxxx      xx   x  x|xx     xxx x xxxxxxxxxxx  x x       x  xxxxxxx    x /x xx |x   xxxxx    xx   xxxx xx  x x  x   x               x     x      Dxx      xxx                x               xx       x                         x  x             x x│
//arrays          │x  x     | |x     xxx       x   x  /|xx     / x x xxxxxxxxxxx                 xxxxx       x xx |x x xxxxx        xxxx  x   x x  x             /                                                              x/       /  D                 /    x  x                │

//^^ are the currently supported functions
String printableAscii =  " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
String ASCII = "";
//0,28,30,31,30,28,33, 29,26'25, 24
final int NONE = 0;
final int STRING = 2;
final int BIGDECIMAL = 3;
final int ARRAY = 4;
final int INS = 5;//input string
final int INN = 6;//input number
boolean saveDebugToFile;
boolean saveOutputToFile;
boolean logDecompressInfo;
boolean oldInputSystem;
boolean getDebugInfo;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;
import java.math.MathContext;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
StringList savedOut = new StringList();
StringList log = new StringList();
Executable currentPrinter = null;
//import java.math.BigInteger;
//P5ParserV0_6 SK = this;
void setup () {
  try {
    //System.out.println("hallo");
    if (args == null)
      args = new String[]{"p.sogl"};
    JSONObject options = loadJSONObject("options.json");
    saveDebugToFile = options.getBoolean("saveDebugToFile");
    saveOutputToFile = options.getBoolean("saveOutputToFile");
    logDecompressInfo = options.getBoolean("logDecompressInfo");
    oldInputSystem = options.getBoolean("oldInputSystem");
    getDebugInfo = options.getBoolean("getDebugInfo");
    //println(args.getClass());
    for (int i=0; i<256; i++)ASCII+=char(i)+"";
    String lines[];
    if (oldInputSystem) {
      lines = loadStrings("p.sogl");
    } else {
      lines = args;
      lines[0] = readFile(dataPath(args[0]), StandardCharsets.UTF_8);
    }
    String program = lines[0];
    String[] inputs = new String[lines.length-1];
    for (int i = 1; i < lines.length; i++) {
      inputs[i-1]=lines[i];
    }
    //z’¤{«╥q;}x[p     { =4b*I*:O =Ob\"   =”*o        ]I³r3w;3\\+
    Executable main = new Executable(program, inputs);
    currentPrinter = main;
    main.execute();
    
    if (saveOutputToFile) {
      String j =savedOut.join("");
      if (j.charAt(0)=='\n') j=j.substring(1);
      if (j.length() > 0 && j.charAt(j.length()-1)=='\n') j=j.substring(0, j.length()-1);
      String[]o={j};
      saveStrings("output.txt", o);
    }
    if (saveDebugToFile) {
      String[]o2={log.join("")};
      saveStrings("log.txt", o2);
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
  System.exit(0);
}
//small fix so this would work properly on APDE
/*int afix;
void draw() {
  afix++;
  if (afix>10) exit();
}*/



BigDecimal B (float a) {
  try {
    return new BigDecimal(a);
  }
  catch (Exception e) { 
    println("B-floatE: \""+a+"\" - "+e.toString());
    return B(0);
  }
}
BigDecimal B (String a) {
  try {
    return new BigDecimal(a);
  }
  catch (Exception e) { 
    println("*-*B-string error from \""+a+"\": "+e.toString()+"*-*");
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




String readFile(String path, Charset encoding) {
  try {
    byte[] encoded = Files.readAllBytes(Paths.get(path));
    return new String(encoded, encoding);
  } catch (IOException e) {
    e.printStackTrace();
    return null;
  }
}
void clearOutput() throws Exception { 
  //I don't know how to clear stdout, nor does the internet give anything that works
  savedOut = new StringList(); 
}
String ALLCHARS = "⁰¹²³⁴⁵⁶⁷⁸\t\n⁹±∑«»æÆø‽§°¦‚‛⁄¡¤№℮½← !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~↑↓≠≤≥∞√═║─│≡∙∫○׀′¬⁽⁾⅟‰÷╤╥ƨƧαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσΤτΥυΦφΧχΨψΩωāčēģīķļņōŗšūž¼¾⅓⅔⅛⅜⅝⅞↔↕∆≈┌┐└┘╬┼╔╗╚╝░▒▓█▲►▼◄■□…‼⌠⌡¶→“”‘’"; //<>//
//numbers         │xxxxxxx  | |x xxxxxxxx  x   x   xxxx|xxxx x  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx x xx /x xx|xxx  xxxxx    xxx  xxxx xx xx xx x   xxx x  x   x        x xxx     xx  xx    /x xxx  xx  x   x  xxxx     xx  x   xxxxx    xx      x             x  x         x  xxxx│
//strings         │xxxxxxx  | |x xxxxxxxx     xx   xxxx|xxx  x  xxxxxxxxxxxxxxxxxx x xxxxxxxxx xxxxxxxx x xx /x xx| x   xxxxx    xxx xxxxx xx  x x  x   x          x    xx    xxx   Dxx   xx xxx x          x    x          //  xx  xxxxxx           x             x  x         x   xxx│
//arrays          │x  xxxx  | |x     xxxx      x     x/|xxx      xxxxxxxxxxxxxxxx     xxxxxxxx   xxxxxx   x   x xx| x x xxxxx      x  xxx  x   x x  x           x /x           xx         x      x                              x/  xxxxx/  /        x        /    x  x             x x│
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
final int JSONOBJ = 7;
final int JSONARR = 8;
final BigDecimal ZERO = BigDecimal.ZERO;
boolean saveDebugToFile;
boolean saveOutputToFile;
boolean logDecompressInfo;
boolean oldInputSystem;
boolean getDebugInfo;
boolean printDebugInfo;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;
import java.math.MathContext;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
StringList savedOut = new StringList();
StringList log = new StringList();
Executable currentPrinter = null;
int precision = 500;
Poppable PZERO = new Poppable(ZERO);
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
    printDebugInfo = options.getBoolean("printDebugInfo");
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
    //currentPrinter = new Executable("", null);
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
      String[]o2={log.join("")};
      saveStrings("log.txt", o2);
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
    currentPrinter.eprintln("error on B-float: \""+a+"\" - "+e.toString());
    return B(0);
  }
}
BigDecimal B (double a) {
  try {
    return new BigDecimal(a);
  }
  catch (Exception e) { 
    currentPrinter.eprintln("error on B-double: \""+a+"\" - "+e.toString());
    return B(0);
  }
}
BigDecimal B (String a) {
  try {
    return new BigDecimal(a);
  }
  catch (Exception e) { 
    currentPrinter.eprintln("*-*B-string error from \""+a+"\": "+e.toString()+"*-*");
    return B(0);
  }
}
boolean truthy (Poppable p) {
  if (p.type==BIGDECIMAL) 
    return !p.bd.equals(B(0));
  else if (p.type==STRING)
    return p.s!="";
  else if (p.type==NONE)
    return false;
  return p.a.size()!=0;
}
boolean falsy (Poppable p) {
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
Poppable array (String[] arr) {
  ArrayList<Poppable> o = new ArrayList<Poppable>();
  for (String s : arr)
    o.add(tp(s));
  return new Poppable(o);
}
Poppable array (String[][] arr) {
  ArrayList<Poppable> o = new ArrayList<Poppable>();
  for (String[] a1 : arr) {
    o.add(tp(new ArrayList<Poppable>()));
    for (String a2 : a1) {
      o.get(o.size()-1).a.add(tp(a2));
    }
  }
  return new Poppable(o);
}
ArrayList<Poppable> array (Poppable[] arr) {
  ArrayList<Poppable> o = new ArrayList<Poppable>();
  for (Poppable s : arr)
    o.add(s);
  return o;
}
Poppable[] array (ArrayList<Poppable> arr) {
  Poppable[] o = new Poppable[arr.size()];
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
ArrayList<Poppable> ea() {
  return new ArrayList<Poppable>();
}
Poppable tp(String s) {//to poppable
  return new Poppable(s);
}
Poppable tp(BigDecimal bd) {
  return new Poppable(bd);
}
Poppable tp(ArrayList<Poppable> bd) {
  return new Poppable(bd);
}

BigDecimal roundForDisplay(BigDecimal bd) {
  return bd.setScale(precision-5, BigDecimal.ROUND_HALF_UP);
}
BigDecimal StrToBD(String s, BigDecimal fail) {
  try {
    return new BigDecimal(s);
  } catch (Exception e) {
    return fail;
  }
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
ArrayList<Poppable> chop (Poppable p) {
  ArrayList<Poppable> o = new ArrayList<Poppable>();
  for (char c : p.s.toCharArray())
    o.add(new Poppable(c+""));
  return o;
}
int getLongestXFrom (ArrayList<Poppable> b) {
  return getLongestXFrom (new Poppable(b));
}
int getLongestXFrom (Poppable in) {
  int hlen = 0;
  for (Poppable p : in.a) {
    if (p.type == STRING) if (p.s.length() > hlen) hlen = p.s.length();
    if (p.type == ARRAY) if (p.a.size() > hlen) hlen = p.a.size();
  }
  return hlen;
}
ArrayList<Poppable> item0 (Poppable p) {
  ArrayList<Poppable> out = new ArrayList<Poppable>();
  out.add(p);
  return out;
}
Poppable toArray (Poppable p) {
  if (p.type==STRING || p.type==BIGDECIMAL) {
    return array(p.s.split("\n"));
  }
  return p;
}
ArrayList<Poppable> to2DMLSA (ArrayList<Poppable> in) {//to 2D multiline string array
  if (in.get(0).type==ARRAY) return in;
  else {
    ArrayList<Poppable> out = new ArrayList<Poppable>();
    for (Poppable p : in) {
      out.add(tp(item0(p)));
    }
    return out;
  }
}
ArrayList<Poppable> to1DMLSA (ArrayList<Poppable> in) {//to 1D multiline string array
  if (in.size() > 0 && in.get(0).type==ARRAY) {
    ArrayList<Poppable> out = new ArrayList<Poppable>();
    for (Poppable p : in) {
      String current = "";
      for (Poppable p2 : p.a) {
        current+= p2.s;
      }
      out.add(tp(current));
    }
    return out;
  } else return in;
}
String[] emptySA(int xs, int ys) {
  String[] out = new String[ys];
  for (int y = 0; y < ys; y++) {
    out[y] = "";
    for (int x = 0; x < xs; x++) {
      out[y]+= " ";
    }
  }
  return out;
}
String[] write(String[] a, int xp, int yp, ArrayList<Poppable> b) {
  //println("wrs");
  for (int x = 0; x < getLongestXFrom(b); x++) {
    for (int y = 0; y < b.size(); y++) {
      //println("\"" +a[y+yp-1]+ "\"", x+xp, y+yp-1);
      a[y+yp-1] = a[y+yp-1].substring(0, x+xp-1) + b.get(y).s.charAt(x) + a[y+yp-1].substring(x+xp);
      //println("\"" +a[y+yp-1]+ "\"");
    }
  }
  //println("wre");
  return a;
}

void clearOutput() throws Exception { 
  //I don't know how to clear stdout, nor does the internet give anything that works
  savedOut = new StringList(); 
}
int divCeil (int a, int b) {
  return (a+b-1)/b;
}
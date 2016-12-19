String ALLCHARS = "⁰¹²³⁴⁵⁶⁷⁸\t¶⁹±∑«»æÆø‽§°¦‚‛⁄¡¤№℮½ !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~←↑↓≠≤≥∞√═║─│≡∙∫○׀′¬⁽⁾⅟‰÷╤╥ƨΑαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσΤτΥυΦφΧχΨψΩωāčēģīķļņōŗšūž¼¾⅓⅔⅛⅜⅝⅞↔↕∆≈┌┐└┘╬┼╔╗╚╝░▒▓█▲►▼◄■□…‼⌠⌡͏→“”‘’"; //<>//
//numbers         │x xxxx    |  x xx  x      D     x  xx      xxxxx xxxxxxxxxxx xxxx       xxxxxxxxxx    x /x xxx|xx  xxxxx    xx   xxxx xx xx xx x     xx                 x x                                                                                                   x x x│
//strings         │x  xxx    |  x xx  x            x  xx      xxx x xxxxxxxxxxx  x x       x  xxxxxxx    x /x xx |x   xxxxx    xx   xxxx xx  x x  x                          x                                                          x                                        x x x│
//arrays          │x  x      |        x            x  xx      / x x xxxxxxxxxxx                 xxxxx       x xx |x x xxxxx        xxxx  x   x x  x              /                                                              D       \                                             │
//^^ are the currently supported functions
ArrayList<poppable> stack = new ArrayList<poppable>();
boolean prcon = true;
String ASCII = "";
int NONE = 0;
int STRING = 2;
int BIGDECIMAL = 3;
int ARRAY = 4;
int INS = 5;//input string
int INN = 6;//input number
int ptr = 0;
int inpCtr = -1;
String[] inputs;
boolean debug;
boolean decompressInfo = false; 
import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;
import java.math.MathContext;
int[] sdata;
int[] ldata;
int[] qdata;
int[] lef; 
JSONObject[] data;
poppable[] vars;
StringList log = new StringList();
StringList expl = new StringList();
//import java.math.BigInteger;
void setup () {
  for (int i=0; i<256; i++)ASCII+=char(i)+"";
  String lines[] = loadStrings("p.soml");
  JSONObject options = loadJSONObject("options.json");
  debug = options.getBoolean("debug");
  String program = lines[0];//.replace("¶", "\n");
  inputs = new String[lines.length-1];
  for (int i = 1; i < lines.length; i++) {
    inputs[i-1]=lines[i];
  }
  //z’¤{«╥q;}x[p     { =4b*I*:O =Ob\"   =”*o        ]I³r3w;3\\+
  EXECUTE(program);
  if (options.getBoolean("log")) {
    String j =log.join("");
    if (j.charAt(0)=='\n') j=j.substring(1);
    //if (j.charAt(j.length()-1)=='\n') j=j.substring(0,j.length()-2);
    String[]o={j};
    saveStrings("log.txt", o);
  }
  if (debug) {
    String[]o2={expl.join("")};
    saveStrings("loge.txt", o2);
  }
  exit();
}


void push (String s) {
  stack.add(new poppable(s));
}
void push (long l) {
  stack.add(new poppable(new BigDecimal(l)));
}
void push (JSONArray a) {
  stack.add(new poppable(a));
}
void push (String[] a) {
  stack.add(new poppable(array(a)));
}
void push (boolean b) {
  stack.add(new poppable(B(b?"1":"0")));
}
void push (BigDecimal d) {
  stack.add(new poppable(d));
}
void push (poppable p) {
  stack.add(new poppable(p));
}

poppable pop (int implicitType) {
  if (stack.size()>0) {
    return pop();
  }
  if (implicitType == BIGDECIMAL) return nI();
  else if (implicitType == STRING) return sI();
  else return new poppable(B("0"));
}

poppable pop () {
  poppable r = gl();
  stack.remove(stack.size()-1);
  return r;
}

poppable npop (int implicitType) {
  if (stack.size()>0) {
    return gl();
  }
  if (implicitType == BIGDECIMAL)
    return nI();
  else if (implicitType == STRING)
    return sI();
  else return new poppable();
}
poppable gl () {//get last
  if (stack.size()==0) {
    return new poppable (B(0));
  }
  poppable g = stack.get(stack.size()-1);
  return g;
}

poppable sI () {
  inpCtr++;
  try {
    return new poppable (inputs[inpCtr], true);
  } 
  catch (Exception e) {
    oprintln(e);
    return new poppable ("", false);
  }
}

poppable nI () {
  //return new poppable (nI(), true);
  inpCtr++;
  try {
    return new poppable (B(inputs[inpCtr]), true);
  } 
  catch (Exception e) {
    oprintln(e);
    return new poppable (B(0), false);
  }
}
BigDecimal B (float a) {
  try {
    return new BigDecimal(a);
  }
  catch (Exception e) { 
    oprintln(e);
    return B(0);
  }
}
BigDecimal B (String a) {
  try {
    return new BigDecimal(a);
  }
  catch (Exception e) { 
    oprintln(e);
    return B(0);
  }
}
BigInteger BI (String a) {
  try {
    return new BigInteger(a);
  }
  catch (Exception e) { 
    //oprintln(e);
    return BI("0");
  }
}
BigInteger BI (byte a) {
  try {
    return BigInteger.valueOf(a&0xFF);
  }
  catch (Exception e) { 
    //oprintln(e);
    return BI("0");
  }
}
BigInteger BI (long a) {
  try {
    return BigInteger.valueOf(a);
  }
  catch (Exception e) { 
    //oprintln(e);
    return BI("0");
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
    return p.s=="";
  else if (p.type==NONE)
    return true;
  return p.a.size()==0;
}

void setvar (int v, poppable p) {
  vars[v]=p;
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
  JSONArray j = new JSONArray();
  for (String s : arr)
    j.append(s);
  return new poppable(j);
}
String[] stringArr(JSONArray j) {
  String[] s = new String[j.size()];
  for (int i = 0; i < s.length; i++) {
    s[i] = j.getString(i);
  }
  return s;
}
import java.util.Comparator;
import java.util.Collections;
import java.math.BigInteger;
boolean decompressInfo = true;
String compressChars = "⁰¹²³⁴⁵⁶⁷⁸\t⁹±∑«»æÆø‽§°¦‚‛⁄¡¤№℮½ !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~←↑↓≠≤≥∞√═║─│≡∙∫○׀′¬⁽⁾⅟‰÷╤╥ƨƧαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσΤτΥυΦφΧχΨψΩωāčēģīķļņōŗšūž¼¾⅓⅔⅛⅜⅝⅞↔↕∆≈┌┐└┘╬┼╔╗╚╝░▒▓█▲►▼◄■□¶‼⌠⌡→";
String compressedChars = "\nŗ !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
int[] presetNums = {0,1,2,3,4,5,6,7,8,9,10,11,12,14,16,18,20,25,36,50,64,75,99,100,101,128,196,200,255,256,257};
String[] presets = {"0","1","2","3","4","5","6","7","8","9","L","LI","6«","7«","8«","9«","L«","M¼","6²","M»","N¼","M¾","MH","M","MI","N»","N¾","M«","NH","N","NI"};
String[] dict;
void setup() {
  if (parts.length == 0) {
    StringList a = new StringList();
    String number = "86137542";
    a.append(compressNum(BI(number)));
    println(decompressNum(compressNum(BI(number))));
    /*for (int i = 0; i < 600; i++) {
      a.append(compressNum(BI(i))+" "+decompressNum(compressNum(BI(i))));
    }*/
    saveStrings("compressed", a.array());
    System.exit(0);
  }
  //println(toNum1(compress1("niooaaoasoioaiaaaoiineeaei", 0)));
  //println(toCmd1(toNum1(compress1("niooaaoasoioaiaaaoiineeaei", 0))).length());
  //System.exit(0);
  //83042064962495462445816376887696
  //619796102596331877059595140240
  ArrayList<int[]> bits = new ArrayList<int[]>();
  String raw = "";
  for (String s : parts) {
    for (int[] i : compress(s)) {
      int[] temp = new int[2];
      temp[0] = i[0];
      temp[1] = i[1];
      bits.add(temp);
    }
    raw+=s;
  }//5167382191520587902730082766180203
   //
  //int[][] sb = {{8,0}, {32, 2}, {97,2}, {94, 67}, {27, 0}, {26, 2}, {23, 3}, {19, 2}, {16, 2}, {13, 4}, {7, 6}};//{97, 71}, {26, 2}, {23, 3}, {19, 18}, {3, 1}, {3, 0}, {3, 2}, {3, 2}, {3, 0}, {3, 0}};
  /*for (int s[] : sb) {
    bits.add(s);
  }*/
  //DEBUGGING
  println("\n||----------------------------------------------------------------------||");
  for (int[] bit : bits)
    println(bit[0]+" "+bit[1]);
  println("\n||----------------------------------------------------------------------||");
  String comp = toCmd(bits);
  
  /*for (int i = 0; i < comp.length()-1; i++) {
    if (compressChars.indexOf(comp.charAt(i))>compressChars.indexOf(comp.charAt(i+1))) {
      println("fail");
    }
  }*/
  println("program: " + comp);
  println("total: \""+decompress(comp)+"\"");
  //println(decompress(toCmd("00100000101011101")[0]));
  println("||----------------------------------------------------------------------||");
  println(comp.length() + " bytes, original was "+raw.length()+" bytes. "+ round(comp.length()*1000f/raw.length())/10 + "% of original length");
  println("More precisely, " + Math.log(toNum(bits).doubleValue())/log(compressChars.length()) + " bytes");//.multiply(new BigDecimal(2/log(256))));
  println(toNum(bits));
  println(toNum(bits).toString().length());
  exit();
}
BigInteger fromBase (int base, byte[] num) {
  BigInteger o = BigInteger.valueOf(0);
  for (byte b : num) {
    o = o.multiply(BI(base)).add(BI(b&0xFF));
  }
  return o;
}
BigInteger fromBase (int base, String num) {
  BigInteger o = BigInteger.valueOf(0);
  for (int i = 0; i < num.length(); i++) {
    o = o.multiply(BI(base)).add(BI(num.charAt(i)+""));
  }
  return o;
}
BigInteger decompressable;
byte[] read (int base, int count) {
  byte[] o = new byte[count];
  for (int i = 0; i < count; i++) {
    BigInteger[] temp = decompressable.divideAndRemainder(BI(base));
    o[i] = temp[1].byteValue();
    decompressable = temp[0];
  }
  return o;
}
byte read (int base) {
  byte o;
  BigInteger[] temp = decompressable.divideAndRemainder(BI(base));
  o = temp[1].byteValue();
  decompressable = temp[0];
  return o;
}
int readInt (int base) {
  int o;
  BigInteger[] temp = decompressable.divideAndRemainder(BI(base));
  o = temp[1].intValue();
  decompressable = temp[0];
  return o;
}
String getb (int base, int count) {
  String o = "";
  for (int i = 0; i < count; i++) {
    BigInteger[] temp = decompressable.divideAndRemainder(BI(base));
    o+= temp[1].intValue();
    decompressable = temp[0];
  }
  return o;
}
byte[] toBase (int base, BigInteger b) {
  ArrayList<Byte> o = new ArrayList<Byte>();
  while (!b.equals(BigInteger.ZERO)) {
    BigInteger[] t = b.divideAndRemainder(BI(base));
    o.add(t[1].byteValue());
    b = t[0];
  }
  byte[] O = new byte[o.size()];
  for (int i = 0; i<o.size(); i++) {
    O[i]=o.get(o.size()-i-1);
  }
  return O;
}
byte[] toArray (String s) {
  byte[] o = new byte[s.length()];
  for (int i=0; i<s.length(); i++)o[i]=(byte)int(s.charAt(i)+"");
  return o;
}
byte[] toArray (String s, int group) {
  byte[] o = new byte[s.length()/group];
  for (int i=0; i<s.length(); i+=group)o[i/group]=(byte)int(s.substring(i, i+group));
  return o;
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
String toString(byte[] b) {
  String o = "";
  for (byte c : b) o+=c;
  return o;
}
String pre (String s, int amo, String p) {
  while (s.length()<amo) s=p+s;
  return s;
}
String post (String s, int amo, String p) {
  while (s.length()<amo) s+=p;
  return s;
}
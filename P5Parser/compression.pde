import java.math.BigInteger;
String compressChars = "⁰¹²³⁴⁵⁶⁷⁸\t⁹±∑«»æÆø‽§°¦‚‛⁄¡¤№℮½ !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~←↑↓≠≤≥∞√═║─│≡∙∫○׀′¬⁽⁾⅟‰÷╤╥ƨƧαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσΤτΥυΦφΧχΨψΩωāčēģīķļņōŗšūž¼¾⅓⅔⅛⅜⅝⅞↔↕∆≈┌┐└┘╬┼╔╗╚╝░▒▓█▲►▼◄■□¶‼⌠⌡→";
String compressedChars = "\nŗ !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
//note: here anywhere where byte is used it's most probably supposed to be a bit (base is an exception)
String[] dict;
int[] presetNums = {0,1,2,3,4,5,6,7,8,9,10,11,12,14,16,18,20,25,36,50,64,75,99,100,101,128,196,200,255,256,257};
String[] presets = {"0","1","2","3","4","5","6","7","8","9","L","LI","6«","7«","8«","9«","L«","M¼","6²","M»","N¼","M¾","MH","M","MI","N»","N¾","M«","NH","N","NI"};
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
BigDecimal[] toBase (BigDecimal base, BigDecimal b) {
  ArrayList<BigDecimal> o = new ArrayList<BigDecimal>();
  while (!b.equals(BigDecimal.ZERO)) {
    BigDecimal[] t = b.divideAndRemainder(base);
    o.add(t[1]);
    b = t[0];
  }
  BigDecimal[] O = new BigDecimal[o.size()];
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
String BAtoString(byte[] b) {
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
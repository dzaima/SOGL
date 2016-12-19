String decompb(String s) {
  return decompb(toArray(s));
}
String decompress(String s) {
  byte[] bits = new byte[s.length()];
  for (int i = 0; i < s.length(); i++) {
    bits[i] = (byte)ALLCHARS.indexOf(s.charAt(i));
  }
  //println(bits);
  //println("todecomp:",new StringBuilder(toString(toBase(2, fromBase(250, bits)))).reverse().toString());
  return decompb(new StringBuilder(toString(toBase(2, fromBase(250, bits)))).reverse().toString()+"");
}
String decompressable;
int pos;
String decompb(byte[] in) {
  pos = 0;
  decompressable = toString(in);
  String out = "";
  String last = "";
  int lastD = 0;
  while(pos<in.length) {
    String eq = getb(3);
    if (eq.equals("000") | eq.equals("111")) {
      int charAm = fromBase(2, toArray(getb(3))).intValue()+2;
      int length = fromBase(2, toArray(getb(eq.equals("000")?5:6))).intValue()+charAm+(eq.equals("000")?3:35);
      lastD = length;
      if(decompressInfo) print ("custom dictionary "+(eq.equals("111")?"long ":"")+"string with", charAm, "characters: \"");
      byte[] chars = toBase(97, fromBase(2,getb(ceil(charAm*log(97)/log(2)))));
      String[] CU = new String[chars.length]; //chars used
      int i = 0;
      for (byte c : chars) {
        CU[i] = compChars.charAt(c)+"";
        if(decompressInfo) print(compChars.charAt(c)+(i==chars.length-1?"\", and length "+length+": \"":"\", \""));
        i++;
      }
      String bin = getb(ceil(log(charAm)*length/log(2)));
      byte[] based = toBase(CU.length,fromBase(2,bin));
      String tout = "";//this out
      for (byte b : based) {
        tout += CU[b];
      }
      while (tout.length()<length) tout = CU[0]+tout;
      if(decompressInfo) println(tout+"\"");
      out+=tout;
    }
    if (eq.equals("010")) {
      if (dict == null) dict = loadStrings("words2.0_wiktionary.org-Frequency_lists.txt");
      if (last.equals("010") && lastD==4) out+=" ";
      int length = fromBase(2, getb(2)).intValue()+1;
      lastD = length;
      if(decompressInfo) print (length, "english words: \"");
      String tout = "";
      for (int i = 0; i < length; i++) {
        if (getb(1).equals("0")) tout+=dict[fromBase(2,getb(9)).intValue()];
        else {
          tout+=dict[fromBase(2,getb(16)).intValue()+512];
        }
        if (i<length-1) tout+=" ";
      }
      if(decompressInfo) println(tout+"\".");
      out+=tout;
    }
    if (eq.equals("101") | eq.equals("100")) {
      if(decompressInfo) print("boxstring with ");
      byte[] mode = toArray(getb(6));
      StringList CU = new StringList(); //chars used
      int i = 0;
      for (byte cmode : mode) {
        if (cmode==1) CU.append(" /|_-\n".charAt(i)+"");
        if (i==1 & cmode==1) CU.append("\\");
        i++;
      }
      int length = fromBase(2, getb(5+(eq.equals("101")?1:0))).intValue()+(eq.equals("101")?34:2)+CU.size();
      if(decompressInfo) for (String s : CU) print ("\""+(s.equals("\n")?"\\n":s)+"\""+(s==CU.get(CU.size()-1)?", and "+length+" chars \"":", "));
      lastD = length;
      String bin = getb(ceil(log(CU.size())*length/log(2)));
      //println(bin);
      byte[] based = toBase(CU.size(),fromBase(2,bin));
      String tout = "";//this out
      for (byte b : based) {
        tout += CU.get(b);
      }
      tout = pre(tout, length, CU.get(0));
      if(decompressInfo) println(tout+"\"");
      out+=tout;
    }
    if (eq.equals("001")) {
      String tout = compChars.charAt(fromBase(2, getb(7)).intValue())+"";
      if(decompressInfo) println ("character \""+tout+"\"");
      lastD = 1;
      out+= tout;
    }
    if (eq.equals("011")) {
      int length = fromBase(2, toArray(getb(4))).intValue()+3;
      lastD = length;
      String bin = getb(ceil(log(95)/log(2)*length));
      byte[] base97 = toBase(97, fromBase(2, bin));
      String tout = "";
      for (byte b : base97) {
        tout+=compChars.charAt(b);
      }
      if(decompressInfo) println (length,"characters: \""+tout+"\"");
      out+= tout;
    }
    last = eq;
  }
  return out;
}
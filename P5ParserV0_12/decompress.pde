String decompress(String s) {
  byte[] bits = new byte[s.length()];
  for (int i = 0; i < s.length(); i++) {
    bits[s.length()-i-1] = (byte)compressChars.indexOf(s.charAt(i));
  }
  return decompb(fromBase(compressChars.length(), bits));
}
int pos;
String decompb(BigInteger in) {
  //println(in);
  pos = 0;
  decompressable = in;
  String out = "";
  byte last = -1;
  int lastD = -1;
  while(!decompressable.equals(BigInteger.ZERO)) {
    byte eq = read(8);
    if (eq==0 || eq==7) {
      int length = read(eq==0?32:128)+(eq==0?4:36);
      lastD = length;
      if(logDecompressInfo) print ("custom dictionary "+(eq==7?"long ":"")+"string with characters [");
      
      ArrayList<Character> CU = new ArrayList<Character>(); //chars used
      int cc = read(compressableChars.length());
      CU.add(compressableChars.charAt(cc));
      if (logDecompressInfo) print("\""+(compressableChars.charAt(cc)+"").replace("\n", "\\n")+"\"");
      int base = 97-cc;
      while (base > 1) {
        cc = read(base);
        if (cc==base-1) break;
        CU.add(compressableChars.charAt(97-base+cc+1));
        if (logDecompressInfo) print(", \""+compressableChars.charAt(97-base+cc+1)+"\"");
        base-= cc+1;
      }
      length+=CU.size();
      if (logDecompressInfo) print("] and length "+length+": \"");
      //String bin = getb(ceil(log(charAm)*length/log(2)));
      int[] based = read(CU.size(),length);//toBase(CU.length,fromBase(2,bin));
      String tout = "";//this out
      for (int b : based) {
        tout += CU.get(CU.size()-b-1);
      }
      //while (tout.length()<length) tout = CU.get(0)+tout;
      if (logDecompressInfo) println(tout+"\"");
      out+=tout;
    }
    if (eq==2) {
      if (dict == null) dict = loadStrings("words3.0_wiktionary.org-Frequency_lists.txt");
      if (last==2 && lastD==4) out+=" ";
      int length = read(4)+1;
      lastD = length;
      if(logDecompressInfo) print (length + " english words: \"");
      String tout = "";
      for (int i = 0; i < length; i++) {
        if (read(2)==0) 
          tout+=dict[readInt(512)];
        else {
          tout+=dict[readInt(65536)+512];
        }
        if (i<length-1) tout+=" ";
      }
      if(logDecompressInfo) println(tout+"\".");
      out+=tout;
    }
    if (eq==5 | eq==4) {
      if(logDecompressInfo) print("boxstring with ");
      int[] mode = read(2,6);
      StringList CU = new StringList(); //chars used
      int i = 0;
      for (int cmode : mode) {
        if (cmode==1) CU.append(" /|_-\n".charAt(i)+"");
        if (i==1 & cmode==1) CU.append("\\");
        i++;
      }
      int length = read(eq==5?64:32)+(eq==5?34:2)+CU.size();
      if(logDecompressInfo) for (String s : CU) print ("\""+(s.equals("\n")?"\\n":s)+"\""+(s==CU.get(CU.size()-1)?", and "+length+" chars \"":", "));
      lastD = length;
      //println(bin);
      int[] based = read(CU.size(),length);//toBase(CU.size(),fromBase(2,getb(ceil(log(CU.size())*length/log(2)))));
      String tout = "";//this out
      for (int b : based) {
        tout += CU.get(b);
      }
      tout = pre(tout, length, CU.get(0));
      if(logDecompressInfo) println(tout+"\"");
      out+=tout;
    }
    if (eq==1) {
      String tout = compressableChars.charAt(read(97))+"";
      if(logDecompressInfo) println ("character \""+tout+"\"");
      lastD = 1;
      out+= tout;
    }
    if (eq==3) {
      int length = read(16)+3;
      lastD = length;
      int[] base97 = read(97, length);
      String tout = "";
      for (int b : base97) {
        tout+=compressableChars.charAt(b);
      }
      if(logDecompressInfo) println (length + " characters: \""+tout+"\"");
      out+= tout;
    }
    last = eq;
  }
  return out;
}


BigInteger decompressNum(String s) {
  BigInteger res = BI(0);
  try {
    if (s.startsWith("'")) {
      int counter = 0;
      int i = 0;
      while (compressChars.indexOf(s.charAt(1)) != i-counter-1) {
        i++;
        for (int j = 0; j < presetNums.length; j++) {
          if (i == presetNums[j]) {
            counter++;
            break;
          }
        }
      }
      return BI(i);
    }
    s = s.substring(1, s.length()-1);
    for (int i = 0; i < s.length(); i++) {
      res = res.multiply(BI(compressChars.length())).add(BI((i==0?1:0)+compressChars.indexOf(s.charAt(i))));
    }
    res = res.add(BI(compressChars.length()+presets.length));
  } catch (Exception e) {}
  return res;
}
String decompress(String s) {
  byte[] bits = new byte[s.length()];
  for (int i = 0; i < s.length(); i++) {
    bits[s.length()-i-1] = (byte)compressChars.indexOf(s.charAt(i));
  }
  return decompb(fromBase(compressChars.length(), bits));
}
int pos;
String decompb(BigInteger inpbi) {
  //println(in);
  pos = 0;
  decompressable = inpbi;
  String out = "";
  int last = -1;
  int lastD = -1;
  boolean nextIncludeAlphabet = false;
  while(!decompressable.equals(BI(0))) {
    int eq = -1;
    if (!nextIncludeAlphabet) eq = read(8);
    if (nextIncludeAlphabet || eq==0 || eq==7) {
      if (nextIncludeAlphabet) {
        eq = 7;
      }
      int length = read(nextIncludeAlphabet? 512 : (eq==0?32:128))+(eq==0?4:36);
      
      lastD = length;
      if(logDecompressInfo) System.err.print("custom dictionary "+(nextIncludeAlphabet? "alphabet " : (eq==7?"long ":""))+"string with characters [");
      
      ArrayList<Character> CU = new ArrayList<Character>(); //chars used
      int cc = read(compressableChars.length());
      CU.add(compressableChars.charAt(cc));
      if (logDecompressInfo) System.err.print("\""+(compressableChars.charAt(cc)+"").replace("\n", "\\n")+"\"");
      int base = compressableChars.length()-cc;
      while (base > 1) {
        cc = read(base);
        if (cc==base-1) break;
        CU.add(compressableChars.charAt(compressableChars.length()-base+cc+1));
        if (logDecompressInfo) System.err.print(", \""+compressableChars.charAt(compressableChars.length()-base+cc+1)+"\"");
        base-= cc+1;
      }
      if (nextIncludeAlphabet) {
        for (Character c : alphabet) if (CU.contains(c)) CU.remove(c); else CU.add(c);
        ArrayList<Character> CU2 = new ArrayList<Character>();
        for (int i = 0; i < compressableChars.length(); i++) {
          Character c = compressableChars.charAt(i);
          if (CU.contains(c))
            CU2.add(c);
        }
        CU = CU2;
      }
      //println(CU);
      length+=CU.size();
      if (logDecompressInfo) System.err.print("] and length "+length+": \"");
      //String bin = getb(ceil(log(charAm)*length/log(2)));
      int[] based = readArr(CU.size(),length);//toBase(CU.length,fromBase(2,bin));
      String tout = "";//this out
      for (int b : based) {
        tout += CU.get(CU.size()-b-1);
      }
      //while (tout.length()<length) tout = CU.get(0)+tout;
      if (logDecompressInfo) System.err.println(tout+"\"");
      out+=tout;
      nextIncludeAlphabet = false;
    }
    if (eq==2) {
      if (dict == null) dict = loadStrings("words3.0_wiktionary.org-Frequency_lists.txt");
      if (last==2 && lastD==4) out+=" ";
      int length = read(4)+1;
      lastD = length;
      if(logDecompressInfo) System.err.print(length + " english words: \"");
      String tout = "";
      for (int i = 0; i < length; i++) {
        if (read(2)==0) 
          tout+=dict[readInt(512)];
        else {
          tout+=dict[readInt(65536)+512];
        }
        if (i<length-1) tout+=" ";
      }
      if(logDecompressInfo) System.err.println(tout+"\".");
      out+=tout;
    }
    if (eq==5 | eq==4) {
      if(logDecompressInfo) System.err.print("boxstring with ");
      int[] mode = readArr(2,6);
      StringList CU = new StringList(); //chars used
      int i = 0;
      for (int cmode : mode) {
        if (cmode==1) CU.append(" /|_-\n".charAt(i)+"");
        if (i==1 & cmode==1) CU.append("\\");
        i++;
      }
      int length = read(eq==5?64:32)+(eq==5?34:2)+CU.size();
      if(logDecompressInfo) for (String s : CU) System.err.print ("\""+(s.equals("\n")?"\\n":s)+"\""+(s==CU.get(CU.size()-1)?", and "+length+" chars \"":", "));
      lastD = length;
      //println(bin);
      int[] based = readArr(CU.size(),length);//toBase(CU.size(),fromBase(2,getb(ceil(log(CU.size())*length/log(2)))));
      String tout = "";//this out
      for (int b : based) {
        tout += CU.get(b);
      }
      tout = pre(tout, length, CU.get(0));
      if(logDecompressInfo) System.err.println(tout+"\"");
      out+=tout;
    }
    if (eq==1) {
      String tout = compressableChars.charAt(read(97))+"";
      if(logDecompressInfo) System.err.println("character \""+tout+"\"");
      lastD = 1;
      out+= tout;
    }
    if (eq==3) {
      int length = read(16)+3;
      lastD = length;
      int[] base97 = readArr(97, length);
      String tout = "";
      for (int b : base97) {
        tout+=compressableChars.charAt(b);
      }
      if(logDecompressInfo) System.err.println (length + " characters: \""+tout+"\"");
      out+= tout;
    }
    if (eq==6) {
      int bp = read(8);
      if(bp == 1) {
        nextIncludeAlphabet = true;
      }
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
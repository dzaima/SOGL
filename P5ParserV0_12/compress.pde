ArrayList<int[]> compress (String s, boolean clear, int method) {
  /*
  method:
   0 - custom string
   1 - printable ASCII chars
   2 - english
   3 - box
   */
  if (clear) toCompress = new ArrayList<int[]>();
  //println("###STARTING "+method);

  if (method == 0) {
    ArrayList<Character> used = new ArrayList<Character>();
    for (int i = 0; i < s.length(); i++) {
      char c = s.charAt(i);
      if (!used.contains(c)) {
        used.add(c);
      }
    }
    if (s.length()<36+used.size()) {
      add(8, 0);
      add(32, s.length()-4-used.size());
    } else {
      add(8, 7);
      add(128, s.length()-4-used.size()-32);
    }
    ArrayList<Character> usedS = new ArrayList<Character>();
    for (int i = 0; i < compressableChars.length(); i++) {
      Character c = compressableChars.charAt(i);
      if (used.contains(c))
        usedS.add(c);
    }
    add(compressableChars.length(), compressableChars.indexOf(usedS.get(0)));
    int base = compressableChars.length()-compressableChars.indexOf(usedS.get(0));
    for (int i = 1; i < usedS.size(); i++) {
      int cc = compressableChars.indexOf(usedS.get(i))-compressableChars.indexOf(usedS.get(i-1));
      add(base, cc-1);
      base -= cc;
    }
    if (base != 1)
      add(base, base-1);
    for (int i = 0; i < s.length(); i++) 
      add(usedS.size(), usedS.size()-usedS.indexOf(s.charAt(i))-1);
  }


  if (method == 1) {
    while (s.length()>0) {
      int length = min(s.length(), 18);
      if (logDecompressInfo) println(length);
      if (length==1) {
        add(8,1);
        add(97,compressableChars.indexOf(s.charAt(0)));
        s="";
      } else if (length==2) {
        add(8,1);
        add(97,compressableChars.indexOf(s.charAt(0)));
        add(8,1);
        add(97,compressableChars.indexOf(s.charAt(1)));
        s="";
      } else {
        add(8, 3);
        add(16, length-3);
        for (int i = 0; i < length; i++) {
          add(97, compressableChars.indexOf(s.charAt(i)));
        }
        s = s.substring(length);
      }
    }
  }


  if (method == 2) {
    if (dict == null) dict = loadStrings("words3.0_wiktionary.org-Frequency_lists.txt");
    String[] words = s.split(" ");
    for (int j = 0; j < words.length/4+(words.length%4>0?1:0); j++) {
      add(8, 2);
      add(4, min(words.length-j*4, 4)-1);
      for (int i = 0; i < min(words.length-j*4, 4); i++) {
        String word = words[i+j*4];
        int id = 0;
        for (String c : dict) {
          if (c.equals(word)) break;
          id++;
        }
        if (id == dict.length-1) return null;
        if (id < 512) {
          add (2, 0);
          add (512, id);
          //o+=(pre(toString(toBase(2, BI(id))), 10, "0"));
        }
        else {
          add (2, 1);
          add (65536, id-512);
        }//o+=("1"+pre(toString(toBase(2, BI(id-512))), 16, "0"));
      }
    }
  }


  if (method == 3) {
    byte[] used = new byte[6];
    String useds = "";
    int uci = 0;//^
    for (int i = 0; i < 6; i++) 
      if (s.contains(" /|_-\n".charAt(i)+"") | (i==1 && s.contains("\\"))) {
        used[i] = 1; 
        useds += " /|_-\n".charAt(i);
        uci++;
        if (i==1) {
          uci++;
          useds+="\\";
        }
      } else {
        used[i] = 0;
      }
    if (s.length()<34+uci) {
      add(8, 4);
      add(2, used);
      add(32, s.length()-2-uci);
    } else {
      add(8, 5);
      add(2, used);
      add(64, s.length()-34-uci);
    }
    for (int i = 0; i < s.length(); i++) 
      add(uci, useds.indexOf(s.charAt(i)));
  }

  /*o = "";
  BigInteger bi = BigInteger.ZERO;
  for (int i = toCompress.size()-1; i >= 0; i--) {
    bi = bi.multiply(BI(toCompress.get(i)[0])).add(BI(toCompress.get(i)[1]));
  }*/
  return toCompress;
}
BigInteger toNum (ArrayList<int[]> baseData) {
  BigInteger bi = BigInteger.ZERO;
  for (int i = baseData.size()-1; i >= 0; i--) {
    bi = bi.multiply(BI(baseData.get(i)[0])).add(BI(baseData.get(i)[1]));
  }
  return bi;
}
String toCmd (ArrayList<int[]> data) {
  /*try {
    while (bits.charAt(bits.length()-1)=='0') bits = bits.substring(0, bits.length()-1);
  } catch(Exception e) {}//it's ok, this means it's just empty :p*/
  String o = "";
  BigInteger bits = toNum(data);
  while (!bits.equals(BI(0))) {
    BigInteger[] temp = bits.divideAndRemainder(BI(compressChars.length()));
    bits = temp[0];
    byte c = temp[1].byteValue();
    o+=compressChars.charAt(c&0xFF);
    //println(c&0xFF, compressChars.charAt(c&0xFF));
  }
  String[] O = {"\""+o+"‘"};
  saveStrings ("compressed", O);
  return o;
}
ArrayList<int[]> compress(String s) {
  ArrayList<int[]> bc = new ArrayList<int[]>();//best = 0123, bc = because = code
  try {
    ArrayList<int[]> c = compress(s, true, 1);
    if (s.equals(decompb(toNum(c)))) {
      bc = c;
    }
  }catch(Exception e){}
  //if (box)
  try {
    ArrayList<int[]> c = compress(s, true, 3);
    if (s.equals(decompb(toNum(c))) && (toNum(c).compareTo(toNum(bc))==-1||bc.equals(""))) {
      bc = c;
    }
  }catch(Exception e){}
  try {
    ArrayList<int[]> c = compress(s, true, 0);
    if (s.equals(decompb(toNum(c))) && (toNum(c).compareTo(toNum(bc))==-1||bc.equals(""))) {
      bc = c;
    }
  }catch(Exception e){}
  try {
    ArrayList<int[]> c = compress(s, true, 2);
    if (s.equals(decompb(toNum(c))) && (toNum(c).compareTo(toNum(bc))==-1||bc.equals(""))) {
      bc = c;
    }
  }catch(Exception e){}
  return bc;
}
ArrayList<int[]> toCompress;
void add (int base, byte[] what) {
  for (int i = 0; i < what.length; i++) {
    int[] temp = new int[2];
    temp[0] = base;
    temp[1] = what[i];
    toCompress.add(temp);
  }
}
void add (int base, int what) {
  //if (decompressInfo) println("ADDING "+what+"/"+base);
  int[] temp = new int[2];
  temp[0] = base;
  temp[1] = what;
  toCompress.add(temp);
}

String compressNum(BigInteger in) {
  String res = "";
  for (int i = 0; i < presetNums.length; i++) {
    if (in.compareTo(BI(presetNums[i])) == 0) {
      return presets[i];
    }
  }
  int counter = 0;
  ml:
  for (int i = 0; i < 280; i++) {
    for (int j = 0; j < presetNums.length; j++) {
      if (i == presetNums[j]) {
        continue ml;
      }
    }
    if (in.compareTo(BI(i)) == 0) {
      return "'"+compressChars.charAt(counter);
    }
    counter++;
  }
  in = in.subtract(BI(compressChars.length()+presets.length));
  while (in.compareTo(BI(compressChars.length()-1)) > 0) {
    BigInteger[] temp = in.divideAndRemainder(BI(compressChars.length()));
    res = compressChars.charAt(temp[1].intValue()) + res;
    in = temp[0];
  }
  if (in.compareTo(BI(0)) > 0)
    res = compressChars.charAt(in.intValue()-1) + res;
  res = "\""+res+"“";
  return res;
}






//BigInteger toNum1 (ArrayList<int[]> baseData) {
//  BigInteger bi = BigInteger.ZERO;
//  for (int i = 0; i < baseData.size(); i++) {
//    bi = bi.multiply(BI(baseData.get(i)[0])).add(BI(baseData.get(i)[1]));
//  }
//  return bi;
//}

//BigInteger compress1(String s) {
//  BigInteger bc = BI(0);
//  try {
//    BigInteger c = toNum1(compress1(s, 1));
//    if (s.equals(decompb(c))) {
//      bc = c;
//    }
//  }catch(Exception e){println("1f");}
//  try {
//    BigInteger c = toNum1(compress1(s, 0));
//    if (s.equals(decompb1(c)) && (c.compareTo(bc)==-1||bc.equals(""))) {
//      bc = c;
//    }
//  }catch(Exception e){println("0f");}
//  try {
//    BigInteger c = toNum1(compress1(s, 2));
//    if (s.equals(decompb1(c)) && (c.compareTo(bc)==-1||bc.equals(""))) {
//      bc = c;
//    }
//  }catch(Exception e){println("2f");}
//  return bc;
//}
//ArrayList<int[]> compress1(String s, int method) {
//  /*
//  method:
//   0 - custom string
//   1 - printable ASCII chars
//   2 - box
//  */
//  if (method > 2) return null;
//  toCompress = new ArrayList<int[]>();
//  add(3, method);
//  if (method == 0) {
//    ArrayList<Character> used = new ArrayList<Character>();
//    for (int i = 0; i < s.length(); i++) {
//      if (!used.contains(s.charAt(i))) {
//        used.add(s.charAt(i));
//      }
//    }
//    Collections.sort(used);
//    add(97, compressedChars.indexOf(used.get(0)));
//    int base = 97-compressedChars.indexOf(used.get(0))-1;
//    for (int i = 1; i < used.size(); i++) {
//      int diff = compressedChars.indexOf(used.get(i))-compressedChars.indexOf(used.get(i-1))-1;
//      add(base, diff);
//      base-=diff;
//      if (i>1) base--;
//    }
//    add(base, base-1);
//    for (int i = 0; i < s.length(); i++) 
//      add(used.size(), used.indexOf(s.charAt(i)));
//  }


//  if (method == 1) {
//    for (int i = 0; i < s.length(); i++) {
//      add(97, compressedChars.indexOf(s.charAt(i)));
//    }
//  }

//  if (method == 2) {
//    byte[] used = new byte[6];
//    String useds = "";
//    int uci = 0;//^
//    for (int i = 0; i < 6; i++) 
//      if (s.contains(" /|_-\n".charAt(i)+"") | (i==1 && s.contains("\\"))) {
//        used[i] = 1; 
//        useds += " /|_-\n".charAt(i);
//        uci++;
//        if (i==1) {
//          uci++;
//          useds+="\\";
//        }
//      } else {
//        used[i] = 0;
//      }
//    for (int i = 0; i < s.length(); i++) 
//      add(uci, useds.indexOf(s.charAt(i)));
//  }

//  /*o = "";
//  BigInteger bi = BigInteger.ZERO;
//  for (int i = toCompress.size()-1; i >= 0; i--) {
//    bi = bi.multiply(BI(toCompress.get(i)[0])).add(BI(toCompress.get(i)[1]));
//  }*/
//  return toCompress;
//}
//String toCmd1 (BigInteger bits) {
//  String o = "";
//  byte[] chars = toBase(compressChars.length(), bits);
//  for (byte b : chars) {
//    o+= compressChars.charAt(b&0xFF);
//  }
//  String[] O = {"\""+o+"‘"};
//  saveStrings ("compressed", O);
//  return o;
//}
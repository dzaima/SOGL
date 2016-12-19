String compress (String s, int method) {
  /*
  method:
   0 - custom string
   1 - printable ASCII chars
   2 - english
   3 - box
   */
  String o = "";


  if (method == 0) {
    ArrayList<Character> used = new ArrayList<Character>();
    for (int i = 0; i < s.length(); i++) {
      if (!used.contains(s.charAt(i))) {
        used.add(s.charAt(i));
      }
    }
    byte[] chars = new byte[used.size()];
    int i = 0;
    for (Character cc : used) {
      chars[i] = (byte)compChars.indexOf(cc);
      i++;
    }
    String usedS = pre(toString(toBase(2, BI(used.size()-2))), 3, "0");
    if (s.length()<35+chars.length) 
      o+="000"+usedS+pre(toString(toBase(2, BI(s.length()-3-chars.length))), 5, "0")+pre(toString(toBase(2, fromBase(97, chars))), ceil(chars.length*log(97)/log(2)), "0");
    else
      o+="111"+usedS+pre(toString(toBase(2, BI(s.length()-35-chars.length))), 6, "0")+pre(toString(toBase(2, fromBase(97, chars))), ceil(chars.length*log(97)/log(2)), "0");
    byte[] basenum = new byte[s.length()];
    for (i = 0; i < s.length(); i++) 
      basenum[i] = (byte) used.indexOf(s.charAt(i));
    o+=pre(toString(toBase(2, fromBase (used.size(), basenum))), ceil(s.length()*log(used.size())/log(2)), "0");
  }


  if (method == 1) {
    while (s.length()>0) {
      int length = min(s.length(), 18);
      if (length==1) {
        o += "001"+pre(toString(toBase(2, BI(compChars.indexOf(s.charAt(0))))), 7, "0");
        s="";
      } else if (length==2) {
        o += "001"+pre(toString(toBase(2, BI(compChars.indexOf(s.charAt(0))))), 7, "0")+"001"+pre(toString(toBase(2, BI(compChars.indexOf(s.charAt(1))))), 7, "0");
        s="";
      } else {
        o += "011" + pre(toString(toBase(2, BI(length-3))), 4, "0");
        byte[] basenum = new byte[length];
        for (int i = 0; i < length; i++) {
          basenum[i] = (byte) compChars.indexOf(s.charAt(i));
        }s = s.substring(length);
        o+= pre(toString(toBase(2, fromBase(97, basenum))), ceil(log(97)/log(2)*length), "0");
      }
    }
  }


  if (method == 2) {
    if (dict == null) dict = loadStrings("words2.0_wiktionary.org-Frequency_lists.txt");
    String[] words = s.split(" ");
    o = "010" + pre(toString(toBase(2, BI(words.length-1))), 2, "0");
    for (String word : words) {
      int id = 0;
      for (String c : dict) {
        if (c.equals(word)) break;
        id++;
      }
      if (id == dict.length-1) return null;
      if (id < 512) o+=(pre(toString(toBase(2, BI(id))), 10, "0"));
      else o+=("1"+pre(toString(toBase(2, BI(id-512))), 16, "0"));
    }
  }


  if (method == 3) {
    String used = "";
    String useds = "";
    int uci = 0;//^
    for (int i = 0; i < 6; i++) 
      if (s.contains(" /|_-\n".charAt(i)+"") | (i==1 && s.contains("\\"))) {
        used += 1; 
        useds += " /|_-\n".charAt(i);
        uci++;
        if (i==1) {
          uci++;
          useds+="\\";
        }
      } else {
        used += 0;
      }
    if (s.length()<34+uci) 
      o+="100"+used+pre(toString(toBase(2, BI(s.length()-2-uci))), 5, "0");
    else
      o+="101"+used+pre(toString(toBase(2, BI(s.length()-34-uci))), 6, "0");
    byte[] basenum = new byte[s.length()];
    for (int i = 0; i < s.length(); i++) 
      basenum[i] = (byte) useds.indexOf(s.charAt(i));
    o+=pre(toString(toBase(2, fromBase (uci, basenum))), ceil(s.length()*log(uci)/log(2)), "0");
  }


  return o;
}
String[] toCmd (String bits) {
  /*try {
    while (bits.charAt(bits.length()-1)=='0') bits = bits.substring(0, bits.length()-1);
  } catch(Exception e) {}//it's ok, this means it's just empty :p*/
  String o = "";
  bits = new StringBuilder(bits).reverse().toString();
  for (byte c : toBase(250, fromBase(2, bits))) {
    o+=ALLCHARS.charAt(c&0xFF);
    println(c&0xFF, ALLCHARS.charAt(c&0xFF));
  }
  String o2 = "";
  for (byte c : toBase(256, fromBase(2, bits))) {
    o2+=ALLCHARS.charAt(c&0xFF);
  }
  String[] O = {o, o2};
  saveStrings ("compressed", O);
  return O;
}
String compress(String s) {//(not so) smart compressor
  String bc="";//best = 0123, bc = because = code
  //boolean box = true;
  //for (char c : "\t!\"#$%&'()*+,-.0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^`abcdefghijklmnopqrstuvwxyz{}~".toCharArray()) 
    //if (s.contains(c+"")) box=false;
  try {
    String c = compress(s, 1);
    if (s.equals(decompb(c))) {
      bc = c;
    }
  }catch(Exception e){}
  //if (box)
  try {
    String c = compress(s, 3);
    if (s.equals(decompb(c)) && (c.length()<bc.length()||bc.equals(""))) {
      bc = c;
    }
  }catch(Exception e){}
  try {
    String c = compress(s, 0);
    if (s.equals(decompb(c)) && (c.length()<bc.length()||bc.equals(""))) {
      bc = c;
    }
  }catch(Exception e){}
  try {
    String c = compress(s, 2);
    if (s.equals(decompb(c)) && (c.length()<bc.length()||bc.equals(""))) {
      bc = c;
    }
  }catch(Exception e){}
  return bc;
}
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
      int length = read(eq==0?32:64)+(eq==0?2:34);
                      //eq/7*32+32
      lastD = length;
      if(logDecompressInfo) currentPrinter.eprint ("custom dictionary "+(eq==7?"long ":"")+"string with characters ");
      
      ArrayList<String> CU = new ArrayList<String>(); //chars used
      int base = 0;
      int closable = 0;
      int l = 0;//*/
      while (base<97 && l < 20) {
        l++;
        byte t = read(97-base+closable);
        base+=t+1;
        //println("test");
        if (base>96) break;
        String cc = compressedChars.charAt(base-1)+"";
        CU.add(cc);
        if(logDecompressInfo) currentPrinter.eprint("\""+cc+"\", ");
        if (CU.size()>=2) closable = 1;
      }
      length+=CU.size();
      if(logDecompressInfo) currentPrinter.eprint("and length "+length+": \"");
      //String bin = getb(ceil(log(charAm)*length/log(2)));
      byte[] based = read(CU.size(),length);//toBase(CU.length,fromBase(2,bin));
      String tout = "";//this out
      for (byte b : based) {
        tout += CU.get(b);
      }
      //while (tout.length()<length) tout = CU.get(0)+tout;
      if(logDecompressInfo) currentPrinter.eprintln(tout+"\"");
      out+=tout;
    }
    if (eq==2) {
      if (dict == null) dict = loadStrings("words2.0_wiktionary.org-Frequency_lists.txt");
      if (last==2 && lastD==4) out+=" ";
      int length = read(4)+1;
      lastD = length;
      if(logDecompressInfo) currentPrinter.eprint(length + " english words: \"");
      String tout = "";
      for (int i = 0; i < length; i++) {
        if (read(2)==0) 
          tout+=dict[readInt(512)];
        else {
          tout+=dict[readInt(65536)+512];
        }
        if (i<length-1) tout+=" ";
      }
      if(logDecompressInfo) currentPrinter.eprintln(tout+"\".");
      out+=tout;
    }
    if (eq==5 | eq==4) {
      if(logDecompressInfo) currentPrinter.eprint("boxstring with ");
      byte[] mode = read(2,6);
      StringList CU = new StringList(); //chars used
      int i = 0;
      for (byte cmode : mode) {
        if (cmode==1) CU.append(" /|_-\n".charAt(i)+"");
        if (i==1 & cmode==1) CU.append("\\");
        i++;
      }
      int length = read(eq==5?64:32)+(eq==5?34:2)+CU.size();
      if(logDecompressInfo) for (String s : CU) currentPrinter.eprint ("\""+(s.equals("\n")?"\\n":s)+"\""+(s==CU.get(CU.size()-1)?", and "+length+" chars \"":", "));
      lastD = length;
      //println(bin);
      byte[] based = read(CU.size(),length);//toBase(CU.size(),fromBase(2,getb(ceil(log(CU.size())*length/log(2)))));
      String tout = "";//this out
      for (byte b : based) {
        tout += CU.get(b);
      }
      tout = pre(tout, length, CU.get(0));
      if(logDecompressInfo) currentPrinter.eprintln(tout+"\"");
      out+=tout;
    }
    if (eq==1) {
      String tout = compressedChars.charAt(read(97))+"";
      if(logDecompressInfo) currentPrinter.eprintln ("character \""+tout+"\"");
      lastD = 1;
      out+= tout;
    }
    if (eq==3) {
      int length = read(16)+3;
      lastD = length;
      byte[] base97 = read(97, length);
      String tout = "";
      for (byte b : base97) {
        tout+=compressedChars.charAt(b);
      }
      if(logDecompressInfo) currentPrinter.eprintln (length + " characters: \""+tout+"\"");
      out+= tout;
    }
    last = eq;
  }
  return out;
}
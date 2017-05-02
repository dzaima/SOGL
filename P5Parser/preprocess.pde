String quirkLetters = " 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
String[] quirks = {"0*0/","1*1/","2*2/","3*3/","4*4/","5*5/","6*6/","7*7/","8*8/","9*9/","0/0*","1/1*","2/2*","3/3*","4/4*","5/5*","6/6*","7/7*","8/8*","9/9*","UU","uu","SU","Su","US","uS","!?","²²","!!","2÷","╥╥","╥╤","ΓΓ"};
class Preprocessable {
  ArrayList<poppable> stack = new ArrayList<poppable>();
  ArrayList<poppable> usedInputs = new ArrayList<poppable>();
  int ptr = 0;
  int inpCtr = -1;
  String[] inputs;
  int[] sdata;
  int[] ldata;
  int[] qdata;
  int[] lef; 
  JSONObject[] data;
  poppable[] dataA;
  poppable[] vars;
  String p;
  Executable parent = null;
  Preprocessable (String prog, String[] inputs) {
    if (getDebugInfo)
      eprintln("###");
    preprocess(prog, inputs);
  }
  Preprocessable preprocess(String prog, String[] inputs) {
    this.inputs = inputs;
    p = prog;
    sdata = new int[p.length()];
    ldata = new int[p.length()];
    qdata = new int[p.length()];
    data = new JSONObject[p.length()];
    dataA = new poppable[p.length()];
    for (int i = 0; i < sdata.length; i++) {
      sdata[i]=0;
      ldata[i]=0;
      qdata[i]=-1;
    }
    //variable defaults
    vars = new poppable[5];
    vars[0] = new poppable (B(0));
    vars[1] = new poppable (INN);
    vars[2] = new poppable (ea());
    vars[3] = new poppable (INS);
    vars[4] = new poppable (INN);
    char[] skippingChars = {' ', 'Ζ', 'ƨ', 'Ƨ'};
    int[] skippingCharsL = { 1,   2,   2,   2 };
    /*
    SDATA: (string data)
     1 - string ender
     2 - string starter
     3 - string
     4 - compressed ender
     LDATA: (loop/if data)
     "{", "?", "F", "[", "]" - ending pointer
     "}" - starting pointer (for loops)
     */
    //for (int i = 0; i < p.length(); i++) if (p.charAt(i)=='→') CT = true;
      if (p.contains("\n")) {
        //println (p.contains("→"));
        int i = 0;
        String res = "";
        while (p.charAt(i)!='\n') {
          //println(p.charAt(i)+" → "+(p.charAt(i)!='→'));
          res+=p.charAt(i);
          i++;
        }
      eprintln("preprocessor: "+p.replace("\n", "…"));
      //5{t}→Y \Y /Y
      //println(res+"\n"+i+"\n"+p);
      return preprocess(p.substring(i+1).replace(p.charAt(i-1)+"", res.substring(0, res.length()-1)), inputs);
    }
    for (int i = 0; i < p.length(); i++) {
      boolean skip = false;
        for (int j = 0; j < skippingChars.length; j++)
          if (skippingChars[j]==p.charAt(i)) {
          skip = true;
          i+=skippingCharsL[j];
        }
      if (skip) {
        continue;
      }
      if (p.charAt(i)=='”' || p.charAt(i)=='‘' || p.charAt(i)=='’' || p.charAt(i)=='“') {
        sdata[i]=1;
        int j=i-1;
        while (true) {
          if (j == -1) break;
          sdata[j]=3;
          j--;
          if (j == -1) break;
          if (p.charAt(j)=='"') {
            sdata[j]=2;
            break;
          }
          if (sdata[j]<3&sdata[j]>0) break;
        }
      } else if (p.charAt(i)=='"') {
        sdata[i]=2;
        i++;
        while (true) {
          if (i == p.length()) break;
          sdata[i]=3;
          if (p.charAt(i)=='”' || p.charAt(i)=='‘' || p.charAt(i)=='’' || p.charAt(i)=='“') {
            sdata[i]=1;
            break;
          }
          i++;
          if (i == p.length()) break;
          if (sdata[i]<3&sdata[i]>0) break;
        }
      } else for (int j = 0; j < quirks.length; j++)
        if (p.substring(i).startsWith(quirks[j]))
          for (int k = 0; k < quirks[j].length(); k++)
            qdata[k+i] = j;
    }
    IntList loopStack = new IntList();
    for (int i = 0; i < p.length(); i++) {
      if (p.charAt(i)==' ') {
        i++;
        continue;
      }
      if (p.charAt(i)=='Ƨ') {
        i+=2;
        continue;
      }
      while (i<sdata.length && sdata[i]!=0) i++;
      if (i>sdata.length-1) break;
      if ("{?[]F∫‽⌠".contains(p.charAt(i)+"")) {
        loopStack.append(i);
      }
      if (p.charAt(i)=='}'|p.charAt(i)=='←') {
        if (loopStack.size()>0) {
          ldata[i]=loopStack.get(loopStack.size()-1);
          int temp = loopStack.get(loopStack.size()-1);
          loopStack.remove(loopStack.size()-1);
          ldata[temp] = i;
        } else {
          ldata[i]=0;
        }
      }
    }
    /*if (p.contains("⌡")) {
        //println (p.contains("→"));
        int i = 0;
        String res = "";
        while (i < p.length()) {
          if (p.charAt(i)!='⌡' && sdata[i] == 0) {
            eprintln("preprocessor: "+p.replace("\n", "¶"));
            return preprocess(p.substring(0, i)+p.charAt(i+1)+p.substring(i+2, p.length()-1), inputs);
          }
          res+=p.charAt(i);
          i++;
        }
      
    }*/
    if (loopStack.size()>0) {
      for (int i = 0; i < loopStack.size(); i++) p+='}';
      eprintln("preprocessor: "+p.replace("\n", "…"));
      return preprocess(p, inputs);
    }
    p = p.replace("¶", "\n");
    if (!getDebugInfo) return this;
    eprintln("program: "+p.replace("\n", "¶"));
    eprint("|");
    for (int i=0; i<sdata.length; i++)eprint((p.charAt(i)+(i==sdata.length-1?"|":" ")).replace("\n", "¶"));
    eprint(" chars\n|");
    for (int i=0; i<sdata.length; i++)eprint(sdata[i]+"|");
    eprint(" strings\n|");
    for (int i=0; i<sdata.length; i++)eprint(quirkLetters.charAt(qdata[i]+1)+"|");
    eprint(" quirks\n|");
    for (int i=0; i<sdata.length; i++)eprint((ldata[i]+"").length()==1?ldata[i]+"|":ldata[i]+"");
    eprint(" loops\n|");
    for (int i=0; i<sdata.length; i++)eprint(i%10+"|");
    eprint(" 1s\n|");
    for (int i=0; i<sdata.length; i++)eprint(i/10%10+"|");
    eprintln(" 10s");
    eprintln("###\n");
    return this;
  }
  poppable sI () {
    try {
      inpCtr++;
      if (inpCtr>=inputs.length)
        inpCtr = 0;
      usedInputs.add(new poppable(inputs[inpCtr], true));
      return new poppable (inputs[inpCtr], true);
    } 
    catch (Exception e) {
      eprintln("*-*String input error at inpCtr "+inpCtr+": "+e+"*-*");
      return new poppable ("", false);
    }
  }

  poppable nI () {
    try {
      inpCtr++;
      if (inpCtr>=inputs.length)
        inpCtr = 0;
      usedInputs.add(new poppable(B(inputs[inpCtr]), true));
      return new poppable (B(inputs[inpCtr]), true);
    } 
    catch (Exception e) {
      eprintln("*-*nI error: "+e+"*-*");
      return new poppable (B(0), true);
    }
  }
  void setvar (int v, poppable p) {
    vars[v]=p;
    }
  void push (String s) {
    stack.add(new poppable(s));
  }
  void push (long l) {
    stack.add(new poppable(new BigDecimal(l)));
  }
  void push (float l) {
    stack.add(new poppable(new BigDecimal(l)));
  }
  void push (ArrayList<poppable> a) {
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
    try {
      poppable r = gl();
      stack.remove(stack.size()-1);
      return r;
    } catch (Exception e) {
      println("poppingE: "+e.toString());
      String ns = sI().s;
      boolean isString = false;
      for (char c : ns.toCharArray())
        if (c<'0' || c>'9') {
          isString = true;
          break;
        }
      if (isString) {
        return tp(ns);
      } else {
        return tp(B(ns));
      }
    }
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
  String getStart(boolean self) {
    String beggining = "";
    if (parent != null)
      beggining = parent.getStart(true);
    if (self)
      beggining += "`" + p.charAt(ptr) + "`@" + up0(ptr, str(p.length()).length()) + ": ";
    return beggining;
  }
  void oprint (String o) {
    if (getDebugInfo) {
      System.out.print(o);
      savedOut.append(o);
    }
  }
  void oprintln (String o) {
    System.out.println(o);
    if (saveOutputToFile)
      savedOut.append(o+"\n");
  }
  void oprint (BigDecimal o) {
    System.out.print(o);
    if (saveOutputToFile)
      savedOut.append(o.toString());
  }
  void oprintln (BigDecimal o) {
    System.out.println(o);
    if (saveOutputToFile)
      savedOut.append(o.toString()+"\n");
  }
  void oprint (JSONArray o) {
    System.out.print(o);
    if (saveOutputToFile)
      savedOut.append(o.toString());
  }
  void oprintln (JSONArray o) {
    System.out.println(o);
    if (saveOutputToFile)
      savedOut.append(o.toString()+"\n");
  }
  void oprintln () {
    System.out.println();
    if (saveOutputToFile)
      savedOut.append("\n");
  }
  
  void eprintln (String o) {
    if (getDebugInfo) {
      System.err.println(o);
      if (saveDebugToFile)
        log.append(o+"\n");
    }
  }
  void eprint (String o) {
    if (getDebugInfo) {
      System.err.print(o);
      if (saveDebugToFile)
        log.append(o);
    }
  }
}
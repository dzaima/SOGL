String quirkLetters = " 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
String[] quirks = {"0*0/","1*1/","2*2/","3*3/","4*4/","5*5/","6*6/","7*7/","8*8/","9*9/","0/0*","1/1*","2/2*","3/3*","4/4*","5/5*","6/6*","7/7*","8/8*","9/9*","UU","uu","SU","Su","US","uS","!?","²²","!!","2÷"};
String preprocessor (String p) {
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
  if (p.contains("→")) {
    //println (p.contains("→"));
    int i = 0;
    String res = "";
    while (p.charAt(i)!='→') {
      //println(p.charAt(i)+" → "+(p.charAt(i)!='→'));
      res+=p.charAt(i);
      i++;
    }
    eprintln("preprocessor: "+p.replace("\n", "¶"));
    //5{t}→Y \Y /Y
    //}:1:}?}{t} \}{t} /}{t}
    //println(res+"\n"+i+"\n"+p);
    return preprocessor(p.substring(i+2).replace(p.charAt(i+1)+"", res));
  }
  for (int i = 0; i < p.length(); i++) {
    if (p.charAt(i)==' ') {
      i++;
      continue;
    }
    if (p.charAt(i)=='Ƨ') {
      i+=2;
      continue;
    }
    if (p.charAt(i)=='”'||p.charAt(i)=='‘') {
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
        if (p.charAt(i)=='”'||p.charAt(i)=='‘') {
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
    while (sdata[i]!=0) i++;
    if ("{?[]F∫".contains(p.charAt(i)+"")) {
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
  if (loopStack.size()>0) {
    for (int i = 0; i < loopStack.size(); i++) p+='}';

    return preprocessor(p);
  }
  if (!debug) return p;
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
  eprint(" 10s\n\n");
  return p;
}
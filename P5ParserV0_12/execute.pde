class Executable extends Preprocessable {
  int jumpBackTo = 0,
      jumpBackTimes = 0;
  char lastO = ' ';
  char cc;
  boolean ao;
  Poppable jumpObj;
  Executable (String prog, String[] inputs) {
    super(prog, inputs);
  }
  Executable setParent(Executable p) {
    parent = p;
    return this;
  }
  void execute() {
    Poppable a = new Poppable (p);
    Poppable b = new Poppable (B("0123456789"));
    ptr = -1;
    ao = true;
    int ctr = 0;
    while (true) {//ctr < 30) {//
      ctr++;
      try {
        if (jumpObj != null) {
          if (jumpObj.type == BIGDECIMAL) {
            if (jumpObj.bd.intValue() > jumpBackTimes) {
              jumpBackTimes++;
              ptr = jumpBackTo;
            } else
              jumpObj = null;
          } else
          if (jumpObj.type == STRING) {
            if (jumpObj.s.length() > jumpBackTimes) {
              ptr = jumpBackTo;
              push(jumpObj.s.charAt(jumpBackTimes)+"");
              jumpBackTimes++;
            } else
              jumpObj = null;
          } else
          if (jumpObj.type == ARRAY) {
            if (jumpObj.a.size() > jumpBackTimes) {
              ptr = jumpBackTo;
              push(jumpObj.a.get(jumpBackTimes).s+"");
              jumpBackTimes++;
            } else
              jumpObj = null;
          }
        }
        ptr++;
        int sptr = ptr;
        if (ptr >= p.length()) break;
        cc = p.charAt(ptr);
        //--------------------------------------loop start--------------------------------------
        if (sdata[ptr] != 0) {
          //////////
          String readString = "";
          try {
            while (ptr<p.length() && sdata[ptr]!=3) ptr++;  
            while (ptr<p.length() && sdata[ptr]==3) {
              readString += p.charAt(ptr);
              ptr++;
            }
            if (lastStringUsed) {
              continue;
            }
            Poppable pushable = tp("Unsupported quote ender");
            switch(ptr<p.length()?p.charAt(ptr):'”') {
              case '‘':
                pushable = tp(decompress(readString));
              break;
              case '”':
                pushable = tp(readString.replace("¶", "\n"));
              break;
              case '“':
                pushable = tp(new BigDecimal(decompressNum("\""+readString+"“")));
              break;
              case '’':
                pushable = tp(ea());
                for (int i = 0; i < readString.length(); i++) {
                  pushable.a.add(tp(B(ALLCHARS.indexOf(readString.charAt(i)))));
                }
              break;
            }
            if (pushable.type==STRING) {
              String push = pushable.s;
              if (pushable.s.contains("ŗ")) {
                a = pop();
                if (a.type==STRING)
                  push = pushable.s.replace("ŗ",a.s);
                else if (a.type==BIGDECIMAL)
                  push = pushable.s.replace("ŗ",a.bd.toString());
                else if (a.type==ARRAY) {
                  int index = 0;
                  push = "";
                  for (int i = 0; i < pushable.s.length(); i++) {
                    if (pushable.s.charAt(i) == 'ŗ') {
                      push+= a.a.get(index%a.a.size()).s;
                      index++;
                    } else {
                      push+= pushable.s.charAt(i);
                    }
                  }
                }
              }
              push(push);
            } else {
              push(pushable);
            }
          }catch(Exception e){}
          //////////
          //ptr++;
        } else if (qdata[ptr] != -1) {
          //quirk handling
          if (qdata[ptr]==0) {
            push("codegolf");
          }
          if (qdata[ptr]==1) {
            push("stackexchange");
          }
          if (qdata[ptr]==2) {
            push("qwertyuiop");
            push("asdfghjkl");
            push("zxcvbnm");
          }
          if (qdata[ptr]==3) {
            push(p);
          }
          if (qdata[ptr]==5) {
            String[] exs = { ".com", ".net", ".co.uk", ".gov" };
            push(exs);
          }
          if (qdata[ptr]==6) {
            push("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
          }
          if (qdata[ptr]==12) {
            String[] qwerty = {"qwertyuiop", "asdfghjkl", "zxcvbnm"};
            push(qwerty);
          }
          if (qdata[ptr]==20) {
            delay(int(pop(BIGDECIMAL).bd.floatValue()*1000));
          }
          if (qdata[ptr]==21) {
            push("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
          }
          if (qdata[ptr]==22) {
            push("1234567890");
          }
          if (qdata[ptr]==26) {
            push("bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ");
          }
          if (qdata[ptr]==28) {
            Executable subExec = new Executable(pop(STRING).s, new String[] {}).setParent(this);
            subExec.stack = stack;
            subExec.inpCtr = inpCtr;
            currentPrinter = subExec;
            subExec.execute();
            inpCtr = subExec.inpCtr;
            currentPrinter = this;
          }
          if (qdata[ptr]==30) {
            
          }
          if (qdata[ptr]==31) {
            
          }
          if (qdata[ptr]==32) {
            
          }
          ptr+= quirks[qdata[ptr]].length()-1;
        } else {
          //char parsing
          if (cc=='¹') {
            a = pop();
            b = a;
            ArrayList<Poppable> ot = ea();
            while (true) {
              if (stack.size()==0) {
                if (a.type==b.type)
                  ot.add(a);
                else
                  push(a);
                break;
              } 
              if (a.type!=b.type) {
                push(a);
                break;
              }
              ot.add(a);
              //println(ot.get(ot.size()-1).a.get(0).s);
              a = pop();
            }
            ArrayList<Poppable> o = ea();
            //tp(ot).println();
            for (int i = 0; i < ot.size(); i++) {
              o.add(ot.get(ot.size()-i-1));
            }
            push(o);
          }
          
          if (cc=='²') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL)
              push (a.bd.multiply(a.bd));
            if (a.type==STRING)
              push(a.s+a.s);
          }
  
          if (cc=='³') {
            a = pop(BIGDECIMAL);
            push(a);
            push(a);
            push(a);
          }
  
          if (cc=='⁴') {
            b = pop(NONE);
            a = pop(NONE);
            push (a);
            push (b);
            push (a);
          }
  
          if (cc=='⁵') {
            Poppable c = pop(NONE);
            b = pop(NONE);
            a = pop(NONE);
            push (a);
            push (b);
            push (c);
            push (a);
            /*
          123
             cba
             1231
             cbac
             */
          }
          
          if (cc=='⁶') {
            a = pop(BIGDECIMAL);
            b = pop(BIGDECIMAL);
            Poppable c = pop(BIGDECIMAL);
            push(a);
            push(c);
            push(b);
          }
          
          if (cc=='⁷') {
            Poppable d = pop(STRING);
            Poppable c = pop(STRING);
            b = pop(STRING);
            a = pop(STRING);
            push(b);
            push(c);
            push(d);
            push(a);
          }
          
          if (cc=='±') {
            a = pop(STRING);
            if (a.type==STRING) {
              String res = "";
              for (int i = a.s.length()-1; i > -1; i--) {
                res += a.s.charAt(i);
              }
              push(res);
            } else if (a.type==BIGDECIMAL) {
              push (BigDecimal.ZERO.subtract(a.bd));
            } else if (a.type==ARRAY) {
              ArrayList<Poppable> o = ea();
              for (int j = 0; j < a.a.size(); j++) {
                b = a.a.get(j);
                if (b.type==STRING) {
                  String res = "";
                  for (int i = b.s.length()-1; i > -1; i--) {
                    res += b.s.charAt(i);
                  }
                  push(res);
                } else if (a.type==BIGDECIMAL) {
                  push (BigDecimal.ZERO.subtract(a.bd));
                }
                o.add(b);
              }
              push(o);
            }
          }
          
          if (cc=='∑') {
            a = pop(ARRAY);
            b = tp("");
            boolean useStrings = false;
            if (a.type==STRING) {
              Poppable t = a;
              a = pop(ARRAY);
              b = t;
              useStrings = true;
            }
            for (Poppable c : a.a) {
              if (c.type!=BIGDECIMAL) {
                useStrings = true;
                break;
              }
            }
            if (useStrings) {
              String o = "";
              for (Poppable c : a.a) {
                if (c.type!=ARRAY)
                  o+=c.s;
                else
                  o+=c.sline(false);
                if (c != a.a.get(a.a.size()-1)) o+= b.s;
              }
              push(o);
            } else {
              BigDecimal o = ZERO;
              for (Poppable c : a.a) {
                o = o.add(c.bd);
              }
              push(o);
            }
          }
          
          if (cc=='«') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) push (a.bd.multiply(B(2)));
            if (a.type==STRING) push (a.s.substring(1)+a.s.charAt(0));
          }
          
          if (cc=='»') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) push (a.bd.divideAndRemainder(B(2))[0]);
            if (a.type==STRING) push (a.s.charAt(a.s.length()-1)+a.s.substring(0, a.s.length()-1));
          }
          
          if (cc=='æ') {
            push("aeiou");
          }
          
          if (cc=='Æ') {
            push("aeiouAEIOU");
          }
          
          if (cc=='ø') {
            push("");
          }
          
          if (cc=='‽') {
            if (truthy(pop(BIGDECIMAL))) ptr=ldata[ptr];
          }
          
          if (cc=='¦') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) {
              push(a);
              push(a.bd.signum());
            }
          }
          
          if (cc=='⁄') {
            a = pop(STRING);
            if (a.type==STRING) {
              push (a.s.length());
            }
            if (a.type==BIGDECIMAL) {
              push (a.bd.toString().length());
            }
            if (a.type==ARRAY) {
              push (a.a.size());
            }
          }
          
          if (cc=='¡') {
            if (stack.size() > 0)
              push(truthy(pop()));
            else {
              a = pop(BIGDECIMAL);
              push(a);
              push(truthy(a));
            }
          }
          
          if (cc==' ') {
            ptr++;
            push(p.charAt(ptr)+"");
          }
          
          if (cc=='½') {
            if (stack.size() == 0) {
              a = pop(BIGDECIMAL);
              push(a);
              push(a.bd.divide(B(2)));
            } else {
              a = pop(BIGDECIMAL);
              if (a.type==BIGDECIMAL)
                push(a.bd.divide(B(2)));
              else if (a.type==STRING)
                push(a.s.substring(0, a.s.length()/2));
            }
          }
          
          if (cc=='←') {
            break;
          }
          
          if (cc=='!') {
            if (stack.size() > 0)
              push(falsy(pop()));
            else {
              a = pop(BIGDECIMAL);
              push(a);
              push(falsy(a));
            }
          }
          
          /*if (cc=='\"') {
            //////////
            String res = "";
            ptr++;
            while (sdata[ptr]==3) {
              res += p.charAt(ptr);
              ptr++;
            }
            if (p.charAt(ptr)=='‘')
              push(decompress(res));
            else
              push(res);
            //////////
          }*/
  
          if (cc=='#') push ("\"");
          
          if (cc=='$') push ("”");
          
          if (cc=='%') {
            b = pop(BIGDECIMAL);
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL && b.type==BIGDECIMAL) {
              push (a.bd.remainder(b.bd));
            }
          }
          
          if (cc=='\'') {
            ptr++;
            push(new BigDecimal(decompressNum("'"+p.charAt(ptr))));
          }
          
          if (cc=='*') {
            if (stack.size()==0) {
              b=pop(BIGDECIMAL);
              a=pop(BIGDECIMAL);
              push(a);
              push(b);
              push(a.bd.multiply(a.bd));
            } else {
              a = pop();
              if (stack.size()==0) {
                b = pop(BIGDECIMAL);
                Poppable t = a;
                a=b;
                b=t;
              } else
                b = pop();
              if (((a.type==BIGDECIMAL)&&(b.type==STRING))||((a.type==ARRAY)&&(b.type==BIGDECIMAL))) {
                Poppable t = a;
                a = b;
                b = t;
              }
              if (a.type==BIGDECIMAL&&b.type==BIGDECIMAL) push(a.bd.multiply(b.bd)); 
              if ((a.type==STRING)&&(b.type==BIGDECIMAL)) {
                String res = "";
                for (long i = 0; i < b.bd.longValue(); i++) {
                  res+=a.s;
                }
                push(res);
              }
              if ((a.type==BIGDECIMAL)&&(b.type==ARRAY)) {
                ArrayList<Poppable> arr = ea(); 
                for (int i = 0; i < b.a.size(); i++) {
                  String so = b.a.get(i).s;
                  arr.add(new Poppable(""));
                  for (int j = 0; j < a.bd.intValue(); j++) {
                    arr.get(i).s+=so;
                  }
                }
                push(arr);
              }
            }
          }
  
          if (cc=='+') {
            if (stack.size()==0) {
              b=pop(BIGDECIMAL);
              a=pop(BIGDECIMAL);
              push(a);
              push(b);
              push(a.bd.add(b.bd));
            } else {
              a = pop();
              if (stack.size()==0) {
                if (a.type==BIGDECIMAL)
                  b = pop(BIGDECIMAL);
                else
                  b = pop(STRING);
                Poppable t = a;
                a=b;
                b=t;
              } else
                b = pop();
              if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(a.bd.add(b.bd)); 
              else if ((a.type==BIGDECIMAL|a.type==STRING)&(b.type==BIGDECIMAL|b.type==STRING)) push(b.s+a.s);
              else if (a.type!=ARRAY && b.type==ARRAY) {
                b.a.add(a);
                push(b);
              } else if (a.type==ARRAY && b.type!=ARRAY) {
                ArrayList<Poppable> o = ea();
                o.add(b);
                for (int i = 0; i < a.a.size(); i++)
                  o.add(a.a.get(i));
                push(o);
              } else if (a.type==ARRAY && b.type==ARRAY) {
                b.a.add(a.copy());
                push(b.copy().a);
              }
            }
          }
          if (cc==',') push(sI());
          if (cc=='-') {
            a = pop(BIGDECIMAL);
            if (a.type==ARRAY) {
              ArrayList<Poppable> out = new ArrayList<Poppable>();
              Poppable last = null;
              for (Poppable p : a.a) {
                if (last != null) {
                  out.add(tp(p.bd().subtract(last.bd())));
                }
                last = p;
              }
              push(out);
            } else {
              b = pop(a.type);
              if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(b.bd.subtract(a.bd));
            }
          }
          
          if (cc=='.') push(nI());
          
          if (cc=='/') {
            b = pop(BIGDECIMAL);
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL&b.type==BIGDECIMAL) {
              try {
                push(a.bd.divide(b.bd));
              } catch (Exception e) {
                push(a.bd.divide(b.bd, precision, RoundingMode.FLOOR));
              }
            }
          }
          
          if (cc>='0' & cc <='9') push(int(cc+""));
  
          if (cc==':') {
            a = pop(BIGDECIMAL);
            push(a);
            if (a.type==ARRAY)
              push(a.copy());
            else
              push(a);
          }
          if (cc=='<') {
            b=pop(BIGDECIMAL);
            a=pop(BIGDECIMAL);
            a.roundForDisplay();
            b.roundForDisplay();
            if (a.type==BIGDECIMAL && b.type==BIGDECIMAL)
              push (a.bd.compareTo(b.bd)<0);
            else
              push (a.s.compareTo(b.s)<0);
          }
          if (cc=='=') {
            a=pop(STRING);
            b=pop(STRING);
            
            if (a.type==BIGDECIMAL) {
              a.s = roundForDisplay(a.bd).toString();
            }
            if (b.type==BIGDECIMAL) {
              b.s = roundForDisplay(b.bd).toString();
            }
            if (a.s.equals(b.s))
              push (true);
            else
              push (false);
          }
  
          if (cc=='>') {
            b=pop(BIGDECIMAL);
            a=pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL && b.type==BIGDECIMAL)
              push (a.bd.compareTo(b.bd)>0);
          }
  
          if (cc=='?') {
            if (falsy(pop(BIGDECIMAL))) ptr=ldata[ptr];
          }
          
          if (cc=='@') push(" ");
  
          if (cc==';') {
            if (stack.size() == 0)
              push(nI());
            if (stack.size() == 1) 
              push(nI());
            a = pop();
            b = pop();
            push(a);
            push(b);
          }
  
          if (cc>='A' & cc <='E') {
            int cv = cc-'A';
            setvar(cv, pop(STRING));
          }
          if (cc=='F') {
            
          }
          if (cc=='G') {
            a = pop(BIGDECIMAL);
            b = pop(BIGDECIMAL);
            Poppable c = pop(BIGDECIMAL);
            push (b);
            push (a);
            push (c);
            //123
            //cba
            //bac
            //231
          }
  
          if (cc=='H') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) {
              push (a.bd.subtract(B(1)));
            }
            if (a.type==STRING) {
              ArrayList tmp = new ArrayList<Poppable>();
              tmp.add(new Poppable(chop(a)));
              a = new Poppable (tmp);
            }
            if (a.type==ARRAY) {
              int hlen = 0;
              for (Poppable p : a.a) {
                if (p.a.size() > hlen) {
                  hlen = p.a.size();
                }
              }
              ArrayList<Poppable> out = new ArrayList<Poppable>();
              for (int i = 0; i < hlen; i++) {
                out.add(new Poppable(new ArrayList<Poppable>()));
              }
              for (Poppable p : a.a) {
                int j = 0;
                for (Poppable p2 : p.a) {
                  out.get(out.size()-j-1).a.add(p2);
                  j++;
                }
              }
              push(out);
            }
          }
  
          if (cc=='I') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) {
              push (a.bd.add(B(1)));
            }
            if (a.type==STRING) {
              ArrayList tmp = new ArrayList<Poppable>();
              tmp.add(new Poppable(chop(a)));
              a = new Poppable (tmp);
            }
            if (a.type==ARRAY) {
              int hlen = 0;
              for (Poppable p : a.a) {
                if (p.a.size() > hlen) {
                  hlen = p.a.size();
                }
              }
              ArrayList<Poppable> out = new ArrayList<Poppable>();
              for (int i = 0; i < hlen; i++) {
                out.add(new Poppable(new ArrayList<Poppable>()));
              }
              for (Poppable p : a.a) {
                int j = 0;
                for (Poppable p2 : p.a) {
                  out.get(j).a.add(0, p2);
                  j++;
                }
              }
              push(out);
            }
          }
  
          if (cc=='J') {
            a = pop(STRING);
            if (a.type==STRING) {
              String c = a.s.charAt(a.s.length()-1)+"";
              push (a.s.substring(0, a.s.length()-1));
              push(c);
            } else if (a.type==BIGDECIMAL) {
              push (B(sin(a.bd.floatValue())));
            } else {
              Poppable l = a.a.get(a.a.size()-1);
              a.a.remove(a.a.size()-1);
              push(a);
              push(l);
            }
          }
  
          if (cc=='K') {
            a = pop(STRING);
            if (a.type==STRING) {
              String c = a.s.charAt(0)+"";
              push(a.s.substring(1));
              push(c);
            }
            if (a.type==BIGDECIMAL) {
              push(B(cos(a.bd.floatValue())));
            }
            if (a.type==ARRAY) {
              Poppable tmp = a.a.get(0);
              a.a.remove(0);
              push(a.a);
              push(tmp);
            }
          }
  
          if (cc=='L') push(B(10));
          if (cc=='M') push(B(100));
          if (cc=='N') push(B(256));
  
          if (cc=='O') {
            output(true, true, true);
          }
          if (cc=='P') {
            output(true, true, true);
          }
          if (cc=='Q') {
            output(false, true, false);
          }
          
          if (cc=='R') {
            a = pop();
            if (a.type==BIGDECIMAL) push (char(a.bd.intValue())+"");
            ArrayList<Poppable> res = ea();
            if (a.type==STRING) {
              for (int i = 0; i < a.s.length(); i++)
                res.add(tp(B(a.s.charAt(i)+0)));
              push(res);
            }
          }
          
          if (cc=='T') {
            output(false, true, true);
          }
          
          if (cc=='U') {
            a = pop(STRING);
            if (a.type==STRING)
              push (a.s.toUpperCase());
            else if (a.type==BIGDECIMAL)
              push (a.bd.setScale(0, BigDecimal.ROUND_CEILING));
          }
          
          if (cc=='X') pop(NONE);
          
          if (cc=='W') {
            if (stack.size()==0) {
              a = pop(STRING);
              push("ABCDEFGHIJKLMNOPQRSTUVWXYZ".indexOf(a.s)+1);
            } else {
              a = pop();
              if (a.type==STRING)
                b = pop(BIGDECIMAL);
              if (a.type==BIGDECIMAL)
                b = pop(STRING);
              if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(a.bd.add(b.bd)); 
              if ((a.type==BIGDECIMAL)&(b.type==STRING)) {
                Poppable t = a;
                a = b;
                b = t;
              }
              if ((b.type==BIGDECIMAL)&(a.type==STRING)) {
                int c = (b.bd.intValue()-1)%a.s.length();
                if (c<0)
                  c=c+a.s.length();
                push(a.s.charAt(c)+"");
              }
              if (a.type==STRING&b.type==STRING) {
                push(b.s.indexOf(a.s)+1);
              }
              if (a.type==STRING && b.type==ARRAY) {
                Poppable t = a;
                a = b;
                b = t;
              }
              if (a.type==ARRAY && b.type==STRING) {
                push(a);
                boolean notfound = true;
                for (int i = 0; i < a.a.size(); i++) {
                  if (a.a.get(i).s.equals(b.s)) {
                    notfound = false;
                    push (i+1);
                    break;
                  }
                }
                if (notfound)
                  push(0);
              }
            }
            
          }
          
          if (cc=='Z')
            push("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
  
          if (cc=="\\?".charAt(0)) {//Processing being weird again
            if (stack.size()==0) {
              a=pop(BIGDECIMAL);
              push(a.bd);
              push(a.bd.divideAndRemainder(B(10))[1].equals(B(0)));
            } else {
              a = pop();
              if (stack.size()==0) {
                b = pop(BIGDECIMAL);
              } else
                b = pop();
              if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(b.bd.divideAndRemainder(a.bd)[1].equals(B(0))); 
              //else if ((a.type==BIGDECIMAL|a.type==STRING)&(b.type==BIGDECIMAL|b.type==STRING)) push(b.s+a.s);
            }
          }
  
          if (cc=='[') {
            if (falsy(npop(NONE))) {
              ptr = ldata[ptr];
            }
          }
  
          if (cc=='^') {
            if (stack.size()==0) {
              a=pop(BIGDECIMAL);
              push(a.bd.multiply(B(0)));
            } else {
              a = pop();
              if (stack.size()==0) {
                if (a.type==STRING)
                  b = pop(STRING);
                else
                  b = pop(BIGDECIMAL);
                Poppable t = a;
                a=b;
                b=t;
              } else
                b = pop();
              if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(b.bd.pow(a.bd.intValue())); 
              //else if ((a.type==BIGDECIMAL|a.type==STRING)&(b.type==BIGDECIMAL|b.type==STRING)) push(b.s+a.s);
            }
          }
          
          if (cc=='_') {
            a = pop();
            if (a.type==ARRAY) {
              for (int i = 0; i < a.a.size(); i++) {
                push(a.a.get(i));
              }
            }
          }
          
          if (cc>='a' & cc <='e') {
            int cv = cc-'a';
            push(new Poppable (vars[cv], cv, this));
          }
          
          if (cc=='h') {
            a = pop(STRING);
            b = pop();
            Poppable c = pop();
            push(b);
            push(c);
            push(a);
          }
          
          if (cc=='j') {
            a = pop(STRING);
            if (a.type==STRING) {
              if (a.s.length()==0) 
                push(""); 
              else
                push (a.s.substring(0, a.s.length()-1));
            }
            if (a.type==BIGDECIMAL) {
              push (B(sin(a.bd.floatValue()*PI/180)));
            } else {
              a.a.remove(a.a.size()-1);
              push(a);
            }
          }
          
          if (cc=='i') {
            push(lIT);
          }
          
          if (cc=='k') {
            a = pop(STRING);
            if (a.type==STRING) {
              push (a.s.substring(1));
            }
            if (a.type==BIGDECIMAL) {
              push (B(cos(a.bd.floatValue()*PI/180)));
            }
            if (a.type==ARRAY) {
              a.a.remove(0);
              push(a.a);
            }
          }
          
          if (cc=='l') {
            a=npop(STRING);
            if (a.type==STRING) {
              push (a.s.length());
            }
            if (a.type==BIGDECIMAL) {
              push (a.bd.toString().length());
            }
            if (a.type==ARRAY) {
              push (a.a.size());
            }
          }
          
          if (cc=='m') {
            b = pop(BIGDECIMAL);
            a = pop(STRING);
            if (b.type==STRING && a.type==BIGDECIMAL) {
              Poppable t = a;
              a = b;
              b = t;
            }
            String out = "";
            for (int i = 0; i < b.bd().intValue(); i++) {
              out+= a.s.charAt(i%a.s.length());
            }
            push(out);
          }
          
          if (cc=='n') {
            b=pop(BIGDECIMAL);
            a=pop(STRING);
            if (b.type==STRING && a.type==BIGDECIMAL) {
              Poppable t = a;
              a = b;
              b = t;
            }
            String[] splat = new String[ceil(a.s.length()/b.bd.floatValue())];
            int plen = b.bd.intValue();
            if (a.type==STRING) {
              String part = a.s;
              for (int i = 0; i < floor(a.s.length()/b.bd.floatValue()); i++) {
                splat[i] = part.substring(0, b.bd.intValue());
                part = part.substring(plen);
                //println(part);
              }
              //println(part+"h");
              if (part.length()>0)
                splat[splat.length-1] = part + a.s.substring(0, b.bd.intValue()-part.length());
              push (array(splat));
            }
            if (a.type==ARRAY) {
              ArrayList<Poppable> out = new ArrayList<Poppable>();
              for (int i = 0; i < divCeil(a.a.size(),plen)*plen; i++) {
                if (i%plen == 0) out.add(tp(ea()));
                out.get(out.size()-1).a.add(a.a.get(i%a.a.size()));
              }
              push(out);
            }
          }
          
          if (cc=='o') {
            output(true, false, false);
          }
          
          if (cc=='p') {
            output(true, false, true);
          }
          
          if (cc=='q') {
            output(false, false, false);
          }
          
          if (cc=='r') {
            a=pop();
            if (a.type==STRING) push(B(a.s));
            if (a.type==BIGDECIMAL) push(a.bd.toString());
          }
  
          if (cc=='t') {
            output(false, false, true);
          }
          
          if (cc=='u') {
            a = pop(STRING);
            if (a.type==STRING)
              push (a.s.toLowerCase());
            else if (a.type==BIGDECIMAL)
              push (a.bd.setScale(0, BigDecimal.ROUND_FLOOR));
          }
          
          if (cc=='w') {
            if (stack.size()==0) {
              a=pop(STRING);
              push(ASCII.indexOf(a.s));
            } else {
              a = pop();
              if (stack.size()==0) {
                if (a.type==STRING)
                  b = pop(BIGDECIMAL);
                else
                  b = pop(STRING);
                Poppable t = a;
                a=b;
                b=t;
              } else
                b = pop();
  
              if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(a.bd.add(b.bd)); 
              if ((a.type==BIGDECIMAL)&(b.type==STRING)) push(b.s.indexOf(a.bd.toString())+1);
              if ((b.type==BIGDECIMAL)&(a.type==STRING)) push(a.s.indexOf(b.bd.toString())+1);
              
              if (a.type==BIGDECIMAL && b.type==ARRAY) {
                Poppable t = a;
                a = b;
                b = t;
              }
              
              if (a.type==ARRAY && b.type==BIGDECIMAL) {
                push(a);
                int ptr = b.bd.intValue()-1;
                ptr=ptr%a.a.size();
                if (ptr<0)
                  ptr+=a.a.size();
                push(a.a.get(ptr));
              }
            }
          }
  
          if (cc=='x') {
            pop();
            pop();
          }
  
          if (cc=='z')
            push("abcdefghijklmnopqrstuvwxyz");
  
  
          if (cc=='{') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) {
              if (a.bd.equals(B(0))) {
                ptr = ldata[ptr];
              }
              data[ptr] = parseJSONObject("{\"N\":\""+a.s+"\",\"T\":3,\"L\":\"0\"}");//3-number, 2-string
              //eprintln(data[ptr].toString());
            } else
            if (a.type==STRING) {
              if (a.s.length()>0) {
                data[ptr] = parseJSONObject("{\"S\":\""+(a.s.substring(1))+"\",\"T\":2,\"L\":\"0\"}");//3-number, 2-string
                push(a.s.charAt(0)+"");
              } else
                ptr = ldata[ptr];
            } else
            if (a.type==ARRAY) {
              if (a.a.size()>0) {
                push(a.a.get(0));
                a.a.remove(0);
                data[ptr] = parseJSONObject("{\"T\":4,\"L\":\"0\"}");//3-number, 2-string, 4-array
                dataA[ptr] = a;
                //println("%%%",data[ptr],"%%%");
              } else  
                ptr = ldata[ptr];
            }
          }
          if (cc=='∫') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) {
              data[ptr] = parseJSONObject("{\"N\":\""+a.s+"\",\"T\":3,\"L\":\"0\"}");//3-number, 2-string
              if (B(data[ptr].getString("N")).intValue()>=1) push(B(1));
            }
          }
          if (cc=='}') {
            //eprintln("==="+data[ldata[ptr]]+"`==="+data[ldata[ptr]].getString("N")+"==="+ldata[ptr]+"===");
            if (p.charAt(ldata[ptr])=='[') {
              if (truthy(npop(NONE))) {
                ptr = ldata[ptr];
              }
            } else if (p.charAt(ldata[ptr])==']') {
              if (truthy(pop(BIGDECIMAL))) {
                ptr = ldata[ptr];
              }
            } else if (p.charAt(ldata[ptr])=='{') {
              if (data[ldata[ptr]].getInt("T")==BIGDECIMAL) {
                if (!(B(data[ldata[ptr]].getString("N")).intValue()<=1)) {
                  ptr = ldata[ptr];
                  data[ptr] = parseJSONObject("{\"N\":\""+B(data[ptr].getString("N")).subtract(B(1)).toString()+"\",\"T\":3,\"L\":\""+B(data[ptr].getString("L")).add(B(1))+"\"}");
                  //eprintln(data[ptr].getString("N"));
                }
              } else
              if (data[ldata[ptr]].getInt("T")==STRING) {
                if (data[ldata[ptr]].getString("S").length()>0) {
                  ptr = ldata[ptr];
                  String s = data[ptr].getString("S");
                  data[ptr] = parseJSONObject("{\"S\":\""+(s.substring(1))+"\",\"T\":2,\"L\":\""+B(data[ptr].getString("L")).add(B(1))+"\"}");
                  push(s.charAt(0)+"");
                }
              } else if (data[ldata[ptr]].getInt("T")==ARRAY) {
                if (dataA[ldata[ptr]].a.size()>0) {
                  ptr = ldata[ptr];
                  Poppable A = dataA[ptr];
                  push(A.a.get(0));
                  A.a.remove(0);
                  data[ptr] = parseJSONObject("{\"T\":4,\"L\":\""+B(data[ptr].getString("L")).add(B(1))+"\"}");
                  dataA[ptr] = A;
                }
              }
            } else if (p.charAt(ldata[ptr])=='∫') {
              if (data[ldata[ptr]].getInt("T")==BIGDECIMAL) {
                if (B(data[ldata[ptr]].getString("N")).intValue()>1) {
                  ptr = ldata[ptr];
                  data[ptr] = parseJSONObject("{\"N\":\""+B(data[ptr].getString("N")).subtract(B(1))+"\",\"T\":3,\"L\":\""+B(data[ptr].getString("L")).add(B(1))+"\"}");
                  push(int(data[ptr].getString("L"))+1);
                  //oprintln(data[ptr].getString("N"));
                }
              }
            }
          }
          
          if (cc=='~') {
            a = pop(BIGDECIMAL);
            b = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL && b.type==BIGDECIMAL) {
              push(a.bd.subtract(b.bd));
            }
          }
          
          if (cc=='≠') {
            a = pop(STRING);
            b = pop(a.type);
            if (!a.s.equals(b.s))
              push (1);
            else
              push (0);
          }
          
          if (cc=='≤') {
            a = stack.get(0);
            stack.remove(0);
            push(a);
          }
          
          if (cc=='≥') {
            stack.add(0, pop());
          }
          
          if (cc=='√') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) {
              BigDecimal base = B(0);//B(Math.sqrt(a.bd.doubleValue()));
              BigDecimal currentModifier = a.bd.divide(B(2));
              while (base.multiply(base).subtract(a.bd).abs().subtract(B(1).movePointLeft(precision)).toString().charAt(0) != '-') {
                if (base.multiply(base).subtract(a.bd).toString().charAt(0) == '-') {
                  base = base.add(currentModifier);
                } else {
                  base = base.subtract(currentModifier);
                }
                currentModifier = currentModifier.divide(B(2));
                //println(base, currentModifier);
              }
              push(base);
            }
          }
          
          if (cc=='║') {
            a = pop(ARRAY);
            if (a.type==ARRAY) {
              ArrayList<Poppable> o = new ArrayList<Poppable>();
              for (Poppable p : a.a) {
                boolean found = false;
                for (Poppable pa : o) {
                  if (pa.s.equals(p.s)) {
                    found = true;
                    break;
                  }
                }
                if (!found) o.add(p);
              }
              push(o);
            }
          }
          
          if (cc=='─') {
            b = pop(BIGDECIMAL);
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL && b.type==BIGDECIMAL) {
              if (b.bd.intValue()==2 && !b.inp)
                push(BAtoString(toBase(2, a.bd.toBigInteger())));
              else {
                ArrayList<Poppable> out = ea();
                for (BigDecimal cb : toBase(b.bd, a.bd))
                  out.add(new Poppable(cb));
                push(out);
              }
            }
          }
          
          if (cc=='│') {
            b = pop(BIGDECIMAL);
            a = pop(ARRAY);
            BigDecimal res = B(0);
            for (Poppable c : a.a) {
              res = res.multiply(b.bd()).add(c.bd());
            }
            push(res);
          }
          
          if (cc=='∙') {
            a = pop();
            b = pop();
            if (((a.type==BIGDECIMAL)&&(b.type==STRING))||((a.type==ARRAY)&&(b.type==BIGDECIMAL))) {
              Poppable t = a;
              a = b;
              b = t;
            }
            if ((a.type==BIGDECIMAL)&&(b.type==ARRAY)) {
              ArrayList<Poppable> out = new ArrayList<Poppable>();
              for (int i = 0; i < b.a.size()*a.bd.longValue(); i++) {
                out.set(i,a.a.get(i%a.a.size()));
              }
              push(out);
            }
            if ((a.type==STRING)&&(b.type==BIGDECIMAL)) {
              ArrayList<Poppable> out = ea();
              for (int i = 0; i < b.bd.intValue(); i++) {
                out.add(a);
              }
              push(out);
            }
          }
          
          if (cc=='ʹ') {
            a=pop();
            push (a.bd.toBigInteger().isProbablePrime(1000));
          }
          
          if (cc=='⁽') {
            a = pop();
            push((a.s.charAt(0)+"").toUpperCase()+a.s.substring(1));
          }
          
          if (cc=='⁾') {
            a = pop();
            if (a.type==STRING) {
              String s = a.s;
              boolean nextUppercase = true;
              for (int i = 0; i < s.length(); i++) {
                if (".?!".indexOf(s.charAt(i)) >= 0) {
                  nextUppercase = true;
                }
                if ((s.charAt(i)+"").matches("\\w") && nextUppercase) {
                  nextUppercase = false;
                  s = s.substring(0, i)+(s.charAt(i)+"").toUpperCase()+s.substring(i+1);
                }
              }
              push(s);
            }
            if (a.type==ARRAY) {
              ArrayList<Poppable> out = new ArrayList<Poppable>();
              for (int j = 0; j < a.a.size(); j++) {
                if (a.a.get(j).type==STRING) {
                  String s = a.a.get(j).s;
                  boolean nextUppercase = true;
                  for (int i = 0; i < s.length(); i++) {
                    if (".?!".indexOf(s.charAt(i)) >= 0) {
                      nextUppercase = true;
                    }
                    if ((s.charAt(i)+"").matches("\\w") && nextUppercase) {
                      nextUppercase = false;
                      s = s.substring(0, i)+(s.charAt(i)+"").toUpperCase()+s.substring(i+1);
                    }
                  }
                  out.add(tp(s));
                } else {
                  out.add(a.a.get(j));
                }
              }
              push(out);
            }
          }
          
          if (cc=='÷') {
            a = pop(BIGDECIMAL);//5
            b = pop(BIGDECIMAL);//10 = 2
            if (a.type==BIGDECIMAL & b.type==BIGDECIMAL) push (b.bd.divideAndRemainder(a.bd)[0]);
          }
  
          
          if (cc=='╥') {
            a = npop(STRING);
            if (a.type==BIGDECIMAL)a=new Poppable(a.toString());
            String s = a.s;
            for (int i = s.length()-2; i > -1; i--) {
              s+=s.charAt(i);
            }
            push(s);
          }
          
          if (cc=='╤') {
          }
          
          if (cc=='ƨ') {
            ptr++;
            push(p.charAt(ptr)+""+p.charAt(ptr));
          }
          
          if (cc=='Ƨ') {
            ptr+= 2;
            push(p.charAt(ptr-1)+""+p.charAt(ptr));
          }
          
          if (cc=='Γ') {
            a = pop(STRING);
            if (a.type == STRING) {
              String[] split = a.s.split("\n");
              split = spacesquared(split);
              for (int i = 0; i < split.length; i++) {
                split[i] = split[i] + reverseChars(split[i], true).substring(1);
              }
              push (join(split,"\n"));
            }
          }
          
          if (cc=='Δ') {
            a = pop();
            if (a.type==STRING) {
              //should be expanded
              String o = printableAscii.substring(0, printableAscii.indexOf(a.s)+1);
              push(o);
            }
            if (a.type==BIGDECIMAL) {
              ArrayList<Poppable> out = new ArrayList<Poppable>();
              for (int i = 0; i < a.bd.intValue(); i++) {
                out.add(tp(B(i+1)));
              }
              push(out);
            }
          }
          if (cc=='δ') {
            a = pop();
            if (a.type==STRING) {
              String o = printableAscii.substring(0, printableAscii.indexOf(a.s));
              push(o);
            }
            if (a.type==BIGDECIMAL) {
              ArrayList<Poppable> out = new ArrayList<Poppable>();
              for (int i = 0; i < a.bd.intValue(); i++) {
                out.add(tp(B(i)));
              }
              push(out);
            }
          }
          
          if (cc=='Ζ') {
            push(p.charAt(ptr+1)+"");
            push(p.charAt(ptr+2)+"");
            ptr+= 2;
          }
          
          if (cc=='ζ') {
            a = pop();
            if (a.type==STRING) {
              push(a.s.length() > 0? a.s.charAt(0) : 0);
            }
            if (a.type==BIGDECIMAL) {
              push((char)a.bd.intValue()+"");
            }
            if (a.type==ARRAY) {
              //todo
            }
          }
          
          if (cc=='Θ') {
            b = pop(STRING);
            a = pop(STRING);
            String curr = "";
            ArrayList<Poppable> out = ea();
            int count = a.s.length();
            for (int i = 0; i < count; i++) {
              if (i < count - b.s.length() && a.s.substring(0,b.s.length()).equals(b.s)) {
                out.add(new Poppable(curr));
                a.s = a.s.substring(b.s.length());
                i+=b.s.length()-1;
                curr = "";
              } else {
                curr+=a.s.charAt(0);
                a.s = a.s.substring(1);
              }
            }
            //if (!curr.equals(""))
              out.add(new Poppable(curr));
            push(out);
          }
          if (cc=='θ') {
            a = pop(STRING);
            String curr = "";
            ArrayList<Poppable> out = ea();
            int count = a.s.length();
            for (int i = 0; i < count; i++) {
              if (a.s.charAt(0)==' ') {
                out.add(new Poppable(curr));
                curr = "";
              } else {
                curr+=a.s.charAt(0);
              }
              a.s = a.s.substring(1);
            }
            if (!curr.equals(""))
              out.add(new Poppable(curr));
            push(out);
          }
          
          if (cc=='Ι') {
            lastStringUsed = true;
            push(lastString);
          }
          
          if (cc=='ι') {
            b = pop();
            a = pop();
            push (b);
          }
          
          if (cc=='Κ') {
            b = pop(STRING);
            a = pop(STRING);
            if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(a.bd.add(b.bd)); 
            else if ((a.type==BIGDECIMAL|a.type==STRING)&(b.type==BIGDECIMAL|b.type==STRING)) push(b.s+a.s);
            else if (a.type==STRING && b.type==ARRAY) {
              b.a.add(a);
              push(b);
            } else if (a.type==ARRAY && b.type==STRING) {
              ArrayList<Poppable> o = ea();
              o.add(tp(b.s));
              for (int i = 0; i < a.a.size(); i++)
                o.add(a.a.get(i));
              push(o);
            } else if (a.type==ARRAY && b.type==BIGDECIMAL) {
              ArrayList<Poppable> o = ea();
              o.add(b);
              for (int i = 0; i < a.a.size(); i++)
                o.add(a.a.get(i));
              push(o);
            } else if (a.type==BIGDECIMAL && b.type==ARRAY) {
              push(b.a.add(a));
            } else if (a.type==ARRAY && b.type==ARRAY) {
              b.copy().a.add(a.copy());
              push(b.a);
            }
          }
          
          if (cc=='κ') {
            b = pop(BIGDECIMAL);
            a = pop(a.type);
            if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)
              push(b.bd.subtract(a.bd));
          }
          
          if (cc=='Λ') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) {
              ArrayList<Poppable> out = ea();
              for (BigDecimal i = B(1); i.compareTo(a.bd)!=1; i = i.add(B(1))) //<>// //<>// //<>//
                if (a.bd.divideAndRemainder(i)[1].equals(B(0)))
                  out.add(new Poppable(i));
              push(out);
            }
          }
          
          if (cc=='λ') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) {
              ArrayList<Poppable> out = ea();
              for (BigDecimal i = B(1); i.compareTo(a.bd)!=0; i = i.add(B(1)))
                if (a.bd.divideAndRemainder(i)[1].equals(B(0)))
                  out.add(new Poppable(i));
              push(out);
            }
          }
          
          if (cc=='Ν') {
            b = pop(BIGDECIMAL);
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL && b.type == BIGDECIMAL) {
              ArrayList<Poppable> out = new ArrayList<Poppable>();
              for (BigDecimal i = a.bd; i.compareTo(b.bd)<=0; i = i.add(B(1))) {
                out.add(tp(i));
              }
              push(out);
            }
          }
          
          if (cc=='ν') {
            b = pop(BIGDECIMAL);
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL && b.type == BIGDECIMAL) {
              ArrayList<Poppable> out = new ArrayList<Poppable>();
              for (BigDecimal i = a.bd; i.compareTo(b.bd)<0; i = i.add(B(1))) {
                out.add(tp(i));
              }
              push(out);
            }
          }
          
          if (cc=='Ο') {
            Poppable c = pop();
            b = pop(c.type);
            a = pop(BIGDECIMAL);
            BigDecimal res = a.bd;
            if (a.type==BIGDECIMAL&&b.type==BIGDECIMAL&&c.type==BIGDECIMAL) {
              if (a.bd.compareTo(b.bd)==-1)
                res=b.bd;
              if (a.bd.compareTo(c.bd)==1)
                res=c.bd;
              push(res);
            }
            if (a.type==STRING&&b.type==STRING&&c.type==BIGDECIMAL) {
              Poppable t = c;//the number
              c = a;
              a = b;
              b = t;
            }
            if (a.type==BIGDECIMAL&&b.type==STRING&&c.type==STRING) {
              String o = "";
              for (int i = 0; i < a.bd.intValue()-1; i++) {
                o+=b.s+c.s;
              }
              push (o+b.s);
            }
            if (a.type==STRING&&b.type==BIGDECIMAL&&c.type==STRING) {
              String o = "";
              for (int i = 0; i < b.bd.intValue(); i++) {
                o+=a.s+c.s;
              }
              push (o+a.s);
            }
          }
          
          if (cc=='Ρ') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL)
              push(a.bd.divide(B(1),0,RoundingMode.HALF_UP));
          }
          
          if (cc=='ρ') {
            a = pop();
            push(new StringBuilder(a.s).reverse().toString().equals(a.s));
          }
          
          if (cc=='Τ') {
            a = pop();
            if (a.type==BIGDECIMAL)
              push(log(a.bd.floatValue()));
          }
          
          if (cc=='τ') {
            a = pop();
            if (a.type==BIGDECIMAL)
              push(log(a.bd.floatValue())/log(2));
          }
          
          if (cc=='Υ') {
            b = pop();
            a = pop();
            if (a.type==BIGDECIMAL && b.type==BIGDECIMAL)
              push(log(a.bd.floatValue())/log(b.bd.floatValue()));
          }
          
          if (cc=='Χ') {
            a = pop(BIGDECIMAL);
            if (a.type==ARRAY) {
              BigDecimal greatest = a.a.get(0).bd();
              for (Poppable p : a.a) {
                if (p.type==STRING) p = tp(B(p.s));
                if (p.bd().compareTo(greatest)>0)
                  greatest = p.bd();
              }
              push(greatest);
            }
            if (a.type==BIGDECIMAL) {
              b = pop(BIGDECIMAL);
              push (a.bd.compareTo(b.bd())>0? a : b);
            }
          }
          
          if (cc=='χ') {
            a = pop(BIGDECIMAL);
            if (a.type==ARRAY) {
              BigDecimal smallest = a.a.get(0).bd();
              for (Poppable p : a.a) {
                if (p.type==STRING) p = tp(B(p.s));
                if (p.bd().compareTo(smallest)<0)
                  smallest = p.bd();
              }
              push(smallest);
            }
            if (a.type==BIGDECIMAL) {
              b = pop(BIGDECIMAL);
              push (a.bd.compareTo(b.bd())<0? a : b);
            }
          }
          
          if (cc=='Ψ') {
            a = npop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) {
              push (floor(random(a.bd.intValue()))+1);
            }
            if (a.type==STRING) {
              push(printableAscii.charAt(floor(random(a.s.charAt(0)))));
            }
          }
          
          if (cc=='ψ') {
            a = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL) {
              push (floor(random(a.bd.intValue()+1)));
            }
            if (a.type==STRING) {
              push(a.s.charAt(floor(random(a.s.length())))+"");
            }
          }
          
          if (cc=='ā') push(ea());
          
          if (cc=='č') {
            a = pop(STRING);
            if (a.type == STRING) {
              push(chop(a));
            } else if (a.type == BIGDECIMAL) {
              String[] s = new String[a.s.length()];
              for (int i = 0; i < a.s.length(); i++)
                s[i] = a.s.charAt(i)+"";
              push(s);
            } else if (a.type == ARRAY) {
              String o = "";
              for (Poppable c : a.a) {
                if (c.type!=ARRAY)
                  o+=c.s+"\n";
                else
                  o+=c.sline(false)+"\n";
              }
              push(o.endsWith("\n")? o.substring(0, o.length()-1) : o);
            }
          }
          
          if (cc=='ē') {
            a = new Poppable (vars[4], 4, this);
            if (a.type==BIGDECIMAL) {
              push(a);
              setvar(4, tp(a.bd.add(BigDecimal.ONE)));
            } else if (a.type==STRING) {
              push(a.s.charAt(a.s.length()-1)+"");
              setvar(4, tp(a.s.substring(0, a.s.length()-1)));
            } else if (a.type==ARRAY) {
              push(a.a.get(a.a.size()-1));
              setvar(4, a.a.remove(a.a.size()-1));
            }
            
          }
          
          if (cc=='ī') {
            push(B("0.1"));
          }
          
          if (cc=='ķ') {
            ptr++;
            push(p.charAt(ptr)+"");
            output(true, true, false);
          }
          
          if (cc=='ļ') {
            ptr++;
            push(p.charAt(ptr)+"");
            output(true, false, false);
          }
          
          if (cc=='ņ') {
            ptr+= 2;
            push(p.charAt(ptr-1) +""+ p.charAt(ptr));
            output(true, true, false);
          }
          
          if (cc=='ō') {
            ptr+= 2;
            push(p.charAt(ptr-1) +""+ p.charAt(ptr));
            output(true, false, false);
          }
          
          if (cc=='ŗ') {
            Poppable c = pop(STRING);
            b = pop(STRING);
            a = pop(STRING);
            String[] todo;
            boolean endArray;
            if (a.type==ARRAY) {
              todo = new String[a.a.size()];
              int i = 0;
              for (Poppable p : a.a) {
                todo[i] = p.s;
                i++;
              }
              endArray = true;
            } else {
              todo = new String[]{a.s};
              endArray = false;
            }
            String[] whatToReplace;
            if (b.type==ARRAY) {
              int i = 0;
              whatToReplace = new String[b.a.size()];
              for (Poppable p : b.a) {
                whatToReplace[i] = p.s;
                i++;
              }
            } else {
              whatToReplace = new String[] {b.s};
            }
            String[] replaceTo;
            if (c.type==ARRAY) {
              int i = 0;
              replaceTo = new String[c.a.size()];
              for (Poppable p : c.a) {
                replaceTo[i] = p.s;
                i++;
              }
            } else {
              replaceTo = new String[] {c.s};
            }
            ArrayList<Poppable> out = new ArrayList<Poppable>();
            int item = 0;
            for (String currentS : todo) {
              String o = "";
              while (currentS.length() > 0) {
                boolean replaced = false;
                for (String cRT : whatToReplace) {
                  if (currentS.startsWith(cRT)) {
                    o+=replaceTo[item%replaceTo.length];
                    currentS = currentS.substring(min(cRT.length(), currentS.length()));
                    item++;
                    replaced = true;
                    break;
                  }
                }
                if (!replaced) {
                  o+=currentS.charAt(0);
                  currentS = currentS.substring(1);
                }
              }
              out.add(tp(o));
            }
            if (endArray) {
              push(out);
            } else {
              push(out.get(0).s);
            }
            //poppable t;
            //int ac = (a.type==ARRAY?1:0)+(b.type==ARRAY?1:0)+(c.type==ARRAY?1:0);//array count
            /*if (ac == 0) {
              push(a.s.replace(b.s,c.s));
            } else if (ac>1) {
              ArrayList
              if (a.type==ARRAY) {
                ArrayList<poppable> o = new ArrayList<poppable>();
                for (int i = 0; i < a.a.size(); i++)
                  o.add(tp(a.a.get(i).s.replace(b.s,c.s)));
                push(o);
              }
              if (b.type==ARRAY) {
                String o = a.s;
                for (poppable p : b.a)
                  o = o.replace(p.s, c.s);
                push (o);
              } else {
                String o = "";
                int item = 0;
                int length = a.s.length();
                for (int i = 0; i < length; i++) {
                  if (a.s.startsWith(b.s)) {
                    o+=c.a.get(item%a.a.size()).s;
                    item++;
                  } else {
                    o+=a.s.charAt(0);
                  }
                  a.s = a.s.substring(1);
                }
                push(o);
              }
            }*/
          }
          
          if (cc=='ž') {
            Poppable d = pop(ARRAY);
            Poppable c = pop(BIGDECIMAL);
            b = pop(BIGDECIMAL);
            a = pop(ARRAY);
            if (a.type != ARRAY) {
              a = toArray(a);
            }
            if (d.type != ARRAY) {
              d = toArray(d);
            }
            int axs = getLongestXFrom(a);
            int ays = a.a.size();
            int dxs = getLongestXFrom(d);
            int dys = d.a.size();
            int x = b.bd.intValue();
            int y = c.bd.intValue();
            String[] res = emptySA(max(axs, dxs+x-1), max(ays, dys+y-1));
            res = write(res, 1, 1, spacesquared(to1DMLSA(a.a)));
            res = write(res, x, y, spacesquared(to1DMLSA(d.a)));
            push(res);
          }
          
          if (cc=='¼') {
            a = pop();
            if (a.type==BIGDECIMAL)
              push (a.bd.multiply(B(1)).divide(B(4)));
          }
          
          if (cc=='¾') {
            a = pop();
            if (a.type==BIGDECIMAL)
              push (a.bd.multiply(B(3)).divide(B(4)));
          }
          
          if (cc=='↔') {
            push(-1);
          }
          
          if (cc=='┌') {
            push("-");
          }
          
          if (cc=='┐') {
            push("|");
          }
          
          if (cc=='┼') {
            b = pop();
            a = pop();
            if (a.type==ARRAY) {
              if (b.type==STRING) {
                int maxlen = 0;
                for (Poppable c : a.a) 
                  if (c.s.length()>maxlen) 
                    maxlen = c.s.length();
                for (Poppable c : a.a) 
                  while (c.s.length()<maxlen)
                    c.s+=" ";
                for (int i = 0; i < b.s.length(); i++) {
                  a.a.set(i%a.a.size(),tp(a.a.get(i%a.a.size()).s+b.s.charAt(i)));
                }
                push(spacesquared(a.a));
              }
              if (b.type==ARRAY) {
                while (a.a.size()<b.a.size())
                  a.a.add(new Poppable(""));
                while (b.a.size()<a.a.size())
                  b.a.add(new Poppable(""));
                ArrayList<Poppable> s = spacesquared(a.a);
                ArrayList<Poppable> e = spacesquared(b.a);
                ArrayList<Poppable> res = new ArrayList<Poppable>();
                for (int i = 0; i < s.size(); i++) {
                  res.add(tp(s.get(i).s+e.get(i).s));
                }
                push(spacesquared(res));
              }
            }
            if (a.type==STRING) {
              if (b.type==ARRAY) {
                int maxlen = 0; //<>// //<>// //<>//
                for (Poppable c : b.a) 
                  if (c.s.length()>maxlen) 
                    maxlen = c.s.length();
                for (Poppable c : b.a) 
                  while (c.s.length()<maxlen)
                    c.s+=" ";
                for (int i = 0; i < a.s.length(); i++) {
                  b.a.set(i%b.a.size(),tp(a.s.charAt(i)+b.a.get(i%b.a.size()).s));
                }
                for (int i = a.s.length();i%b.a.size()!=0;i++) {
                  b.a.set(i%b.a.size(),tp(" "+b.a.get(i%b.a.size()).s));
                }
                push(spacesquared(b.a));
              }
            }
          }
          if (cc=='░') {
            clearOutput();
          }
          if (cc=='█') {
            push (ALLCHARS);
          }
          
          if (cc=='►') {
            a = pop(ARRAY);
            Poppable l = a.a.get(0);//last
            BigDecimal count = B(0);
            ArrayList<Poppable> out = new ArrayList<Poppable>();
            for (Poppable c : a.a) {
              if (c.equals(l) || c == a.a.get(0)) {
                count = count.add(B(1));
              } else {
                out.add(l);
                out.add(tp(count));
                l = c;
                count = B(1);
              }
            }
            out.add(l);
            out.add(tp(count));
            push(out);
          }
          
          if (cc=='▼') {
            a = pop(STRING);
            if (a.type==STRING) {
              String[] ss = split(a.s, '\n');
              String out = "";
              for (int i = 0; i < ss.length; i++) {
                out+= (i==0? "" : "\n") + ss[ss.length-i-1];
              }
              push(out);
            }
            if (a.type==ARRAY) {
              ArrayList<Poppable> out = new ArrayList<Poppable>();
              for (int i = 0; i < a.a.size(); i++) {
                out.add(a.a.get(a.a.size()-i-1));
              }
              push(out);
            }
          }
          
          if (cc=='◄') {
            a = pop(ARRAY);
            ArrayList<Poppable> out = new ArrayList<Poppable>();
            for (int i = 0; i < a.a.size()-1; i+= 2) {
              for (int j = 0; j < a.a.get(i+1).bd().intValue(); j++) {
                out.add(a.a.get(i));
              }
            }
            push(out);
          }
          
          if (cc=='⌠') {
            a = nI();
            if (a.type==BIGDECIMAL) {
              data[ptr] = parseJSONObject("{\"N\":\""+a.s+"\",\"T\":3,\"L\":\"0\"}");//3-number, 2-string
              if (B(data[ptr].getString("N")).intValue()>1) push(B(0));
            }
          }
          
          if (cc=='⌡') {
            jumpBackTo = ptr;
            a = pop(BIGDECIMAL);
            if (falsy(a) || (a.type == BIGDECIMAL && a.bd.intValue() < 0))
              ptr++;
            else {
              jumpObj = a;
              jumpBackTimes = 0;
              //if (a.type == STRING) push(a.s.charAt(0)+"");
            }
          }
          
          if (cc=='¶') {
            push("\n");
          }
          
          if (cc=='”') {
            push("");
          }
        }
        //while (millis()<CTR*20);
        if (getDebugInfo) {
          //eprintln("`"+cc+"`@"+((sptr+"").length()==1?"0"+sptr:sptr)+": "+stack.toString().replace("\n  ", "").replace("\n", ""));
          eprint("\n"+getStart(false)+"`"+cc+"`@"+up0(sptr, str(p.length()).length())+": [");
          
          int EPC=0;
          for (Poppable EP : stack) {
            EPC++;
            eprint(EP.sline(true));
            if (EPC<stack.size()) eprint(", ");
          }
          eprint("]");
        }
        //--------------------------------------loop end--------------------------------------
      } 
      catch (Exception e) {
        eprintln("*-*Error trough the execution: "+e.toString()+"*-*");
        e.printStackTrace();
      }
    }
    if (ao) {
      oprintln();
      pop(STRING).print();
    }
  }
  void output(boolean pop, boolean newline, boolean dao) {
    if (newline) {
      oprintln();
    } 
    /*else {
      if ("OQPT".contains(lastO+"")) oprintln();
    }*/
    Poppable popped;
    if (pop) popped = pop(STRING);
    else     popped = npop(STRING);
    popped.print();
    if (dao) ao = false;
    lastO=cc;
  }
}
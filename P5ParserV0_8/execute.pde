void EXECUTE(String p) {
  poppable a = new poppable (B(0));
  poppable b = new poppable (B(0));
  p = preprocessor(p);
  ptr = -1;
  boolean ao = true;
  while (true) {//for (int TTTT = 0; TTTT < 10; TTTT++) {//
    ptr++;
    try {
      int sptr = ptr;
      if (ptr >= p.length()) break;
      char cc = p.charAt(ptr);
      char lastO = ' ';
      //--------------------------------------loop start--------------------------------------
      if (sdata[ptr]==3) {
        String res = "";
        try {
          while (sdata[ptr]==3) {
            res += p.charAt(ptr);
            ptr++;
          }
        }catch(Exception e){}
        if (p.charAt(ptr)=='‘')
        push(decompress(res));
        else
        push(res);
        //ptr++;
      } else if (qdata[ptr] != -1) {
        if (qdata[ptr]==12) {
          String[] qwerty = {"qwertyuiop", "asdfghjkl", "zxcvbnm"};
          push(qwerty);
          ptr+=3;
        }
        if (qdata[ptr]==0) {
          push("codegolf");
          ptr+=1;
        }
        if (qdata[ptr]==1) {
          push("stackexchange");
          ptr+=1;
        }
        if (qdata[ptr]==2) {
          push("qwertyuiop");
          push("asdfghjkl");
          push("zxcvbnm");
          ptr+=1;
        }
        if (qdata[ptr]==3) {
          push(program);
          ptr+=1;
        }
        if (qdata[ptr]==4) {
          EXECUTE(pop(STRING).s);
          ptr+=1;
        }
        if (qdata[ptr]==5) {
          String[] exs = { ".com", ".net", ".co.uk", ".gov" };
          push(exs);
          ptr++;
        }
        if (qdata[ptr]==6) {
          push("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
          ptr++;
        }
        if (qdata[ptr]==22) {
          push("1234567890");
          ptr+=1;
        }
      } else {
        
        if (cc=='¹') {
          a = pop();
          b = a;
          ArrayList<poppable> ot = ea();
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
          ArrayList<poppable> o = ea();
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
        }

        if (cc=='³') {
          a = pop(BIGDECIMAL);
          push(a);
          push(a);
          push(a);
        }

        if (cc=='⁴') {
          a = pop(NONE);
          b = pop(NONE);
          push (b);
          push (a);
          push (b);
          //eprintln(":"+a.s+":::"+b.s+":");
          /*
        123
           cba
           1231
           cbac
           */
        }

        if (cc=='⁵') {
          a = pop(NONE);
          b = pop(NONE);
          poppable c = pop(NONE);
          push (c);
          push (b);
          push (a);
          push (c);
          /*
        123
           cba
           1231
           cbac
           */
        }
        
        if (cc=='⁶') {
          a = pop();
          b = pop();
          poppable c = pop();
          push(a);
          push(c);
          push(b);
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
            ArrayList<poppable> o = ea();
            for (int i = 0; i < a.a.size(); i++) {
                o.add(a.a.get(a.a.size()-i-1));
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
        
        if (cc=='ø') {
          push("");
        }
        
        if (cc=='⁄') {
          a = pop(STRING);
          if (a.type==STRING|a.type==BIGDECIMAL) {
            push (a.s.length());
          }
        }
       
        if (cc==' ') {
          ptr++;
          push(p.charAt(ptr)+"");
        }
        if (cc=='←') {
          break;
        }
        if (cc=='\"') {
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
        }

        if (cc=='#') push ("\"");
        
        if (cc=='$') push ("”");
        
        if (cc=='*') {
          if (stack.size()==0) {
            a=pop(BIGDECIMAL);
            push(a.bd.multiply(a.bd));
          } else {
            a = pop();
            if (stack.size()==0) {
              b = pop(BIGDECIMAL);
              poppable t = a;
              a=b;
              b=t;
            } else
              b = pop();
            if (((a.type==BIGDECIMAL)&&(b.type==STRING))||((a.type==ARRAY)&&(b.type==BIGDECIMAL))) {
              poppable t = a;
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
              ArrayList<poppable> arr = ea(); 
              for (int i = 0; i < arr.size(); i++) {
                String so = arr.get(i).s;
                arr.set(i, new poppable(""));
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
            a=pop(BIGDECIMAL);
            push(a.bd.multiply(B(0)));
          } else {
            a = pop();
            if (stack.size()==0) {
              if (a.type==BIGDECIMAL)
                b = pop(BIGDECIMAL);
              else
                b = pop(STRING);
              poppable t = a;
              a=b;
              b=t;
            } else
              b = pop();
            if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(a.bd.add(b.bd)); 
            else if ((a.type==BIGDECIMAL|a.type==STRING)&(b.type==BIGDECIMAL|b.type==STRING)) push(b.s+a.s);
            else if (a.type==STRING && b.type==ARRAY) {
              b.a.add(a);
              push(b);
            } else if (a.type==ARRAY && b.type==STRING) {
              ArrayList<poppable> o = ea();
              o.add(tp(b.s));
              for (int i = 0; i < a.a.size(); i++)
                o.add(a.a.get(i));
              push(o);
            } else if (a.type==ARRAY && b.type==BIGDECIMAL) {
              ArrayList<poppable> o = ea();
              o.add(b);
              for (int i = 0; i < a.a.size(); i++)
                o.add(a.a.get(i));
              push(o);
            } else if (a.type==BIGDECIMAL && b.type==ARRAY) {
              push(b.a.add(a));
            }
          }
        }
        if (cc==',') push(sI());
        if (cc=='-') {
          if (stack.size()==0) {
            a=pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL)
              push(B(0).subtract(a.bd));
          } else {
            a = pop(BIGDECIMAL);
            if (a.type==STRING)
              b = pop(STRING);
            else
              b = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(b.bd.subtract(a.bd));

            /*if (a.type==STRING&b.type==INT)push(a.s+b.i);//int+string, float+string
             if (a.type==INT&b.type==STRING)push(a.i+b.s);
             if (a.type==FLOAT&b.type==STRING)push(a.f+b.s);
             if (a.type==STRING&b.type==FLOAT)push(a.s+b.f);
             if (a.type==STRING&b.type==STRING)push(a.s+b.s);//string+string*/
          }
        }
        if (cc=='.') push(nI());
        if (cc=='/') {
          if (stack.size()==0) {
            a=pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL)
              push(B(0).divide(a.bd));
          } else {
            a = pop(BIGDECIMAL);
            if (a.type==STRING)
              b = pop(STRING);
            else
              b = pop(BIGDECIMAL);
            if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(b.bd.divide(a.bd));

            /*if (a.type==STRING&b.type==INT)push(a.s+b.i);//int+string, float+string
             if (a.type==INT&b.type==STRING)push(a.i+b.s);
             if (a.type==FLOAT&b.type==STRING)push(a.f+b.s);
             if (a.type==STRING&b.type==FLOAT)push(a.s+b.f);
             if (a.type==STRING&b.type==STRING)push(a.s+b.s);//string+string*/
          }
        }
        if (cc>='0' & cc <='9') push(int(cc+""));

        if (cc==':') {
          a = pop(BIGDECIMAL);
          push(a);
          push(a);
        }
        if (cc=='<') {
          a=pop();//5
          b=pop();//3
          if (a.bd.subtract(b.bd).toString().charAt(0)=='-')
            push (false);
          else
            push (true);
        }
        if (cc=='=') {
          a=pop();
          b=pop();
          if (a.s.equals(b.s))
            push (true);
          else
            push (false);
        }

        if (cc=='>') {
          a=pop();//5
          b=pop();//3
          if (a.bd.subtract(b.bd).toString().charAt(0)=='-')
            push (true);
          else
            push (false);
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
          a = pop(NONE);
          b = pop(NONE);
          poppable c = pop(NONE);
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
        }

        if (cc=='I') {
          a = pop(BIGDECIMAL);
          if (a.type==BIGDECIMAL) {
            push (a.bd.add(B(1)));
          }
        }

        if (cc=='J') {
          a = pop(BIGDECIMAL);
          if (a.type==STRING) {
            String c = a.s.charAt(a.s.length()-1)+"";
            push (a.s.substring(0, a.s.length()-1));
            push(c);
          }
          if (a.type==BIGDECIMAL) {
            push (B(sin(a.bd.floatValue())));
          }
        }

        if (cc=='K') {
          a = pop(BIGDECIMAL);
          if (a.type==STRING) {
            String c = a.s.charAt(0)+"";
            push (a.s.substring(1));
            push(c);
          }
          if (a.type==BIGDECIMAL) {
            push (B(cos(a.bd.floatValue())));
          }
        }

        if (cc=='L') push(B(10));
        if (cc=='M') push(B(100));
        if (cc=='N') push(B(256));

        if (cc=='O') {
          oprintln();
          pop(NONE).print();
          lastO=cc;
        }
        if (cc=='P') {
          if ("Oqpt".contains(lastO+""))oprintln();
          pop(NONE).print();
          ao = false;
          lastO=cc;
        }
        if (cc=='R') {
          //a = pop();
          //if (a.type==BIGDECIMAL) push (a.bd.toString());
          //if (a.type==STRING) push (B(a.s));
        }
        
        if (cc=='U') {
          a = pop(STRING);
          if (a.type==STRING) push (a.s.toUpperCase());
          else if (a.type==BIGDECIMAL) push (a.bd.round(new MathContext(1,RoundingMode.CEILING)));
        }
        
        if (cc=='X') pop(NONE);
        
        if (cc=='W') {
          if (stack.size()==0) {
            a = pop(STRING);
            push("ABCDEFGHIJKLMNOPQRSTUVWXYZ".indexOf(a.s)+1);
          } else {
            a = pop();
            if (stack.size() == 0) {
              if (a.type==BIGDECIMAL) push(1+pop(STRING).s.charAt(a.bd.intValue()));
              //if (a.type==STRING) push();
            } else {
              b = pop();
              if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(a.bd.add(b.bd)); 
              if ((a.type==BIGDECIMAL)&(b.type==STRING)) push(b.s.charAt(a.bd.intValue()-1)+"");
              if ((b.type==BIGDECIMAL)&(a.type==STRING)) push(a.s.charAt(b.bd.intValue()-1)+"");
              if (a.type==STRING&b.type==STRING) {
                push(b.s.indexOf(a.s)+1);
              }
            }
          }
          
        }
        
        if (cc=='Z')
          push("ABCDEFGHIJKLMNOPQRSTUVWXYZ");

        if (cc=='\\') {
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
              poppable t = a;
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
          push(new poppable (vars[cv], cv));
        }
        
        if (cc=='h') {
          a = pop();
          b = pop();
          poppable c = pop();
          push(b);
          push(c);
          push(a);
        }
        
        if (cc=='j') {
          a = pop(BIGDECIMAL);
          if (a.type==STRING) {
            if (a.s.length()==0) 
              push(""); 
            else
              push (a.s.substring(0, a.s.length()-1));
          }
          if (a.type==BIGDECIMAL) {
            push (B(sin(a.bd.floatValue()*PI/180)));
          }
        }
        
        if (cc=='k') {
          a = pop(BIGDECIMAL);
          if (a.type==STRING) {
            push (a.s.substring(1));
          }
          if (a.type==BIGDECIMAL) {
            push (B(cos(a.bd.floatValue()*PI/180)));
          }
        }
        
        if (cc=='l') {
          a=npop(STRING);
          if (a.type==STRING|a.type==BIGDECIMAL) {
            //push (a);
            push (a.s.length());
          }
        }
        
        if (cc=='n') {
          a=pop();
          b=pop();
          String[] splat = new String[ceil(b.s.length()/a.bd.floatValue())];
          String part = b.s;
          for (int i = 0; i < floor(b.s.length()/a.bd.floatValue()); i++) {
            splat[i] = part.substring(0, a.bd.intValue());
            part = part.substring(a.bd.intValue());
            //println(part);
          }
          //println(part+"h");
          if (part.length()>0)
            splat[splat.length-1] = part + b.s.substring(0, a.bd.intValue()-part.length());
          push (array(splat));
        }
        
        if (cc=='o') {
          if ("Oqpt".contains(lastO+""))oprintln();
          pop(NONE).print(true);
          lastO=cc;
        }
        
        if (cc=='p') {
          oprintln();
          pop(NONE).print();
          ao = false;
          lastO=cc;
        }
        
        if (cc=='q') {
          oprintln();
          npop(NONE).print();
          lastO=cc;
        }
        
        if (cc=='r') {
          a=pop();
          if (a.type==STRING) push(B(a.s));
          if (a.type==BIGDECIMAL) push(a.bd.toString());
        }

        if (cc=='t') {
          oprintln();
          npop(NONE).print();
          ao = false;
          lastO=cc;
        }
        
        if (cc=='u') {
          a = pop(STRING);
          if (a.type==STRING) push (a.s.toLowerCase());
          else if (a.type==BIGDECIMAL) push (a.bd.round(new MathContext(1,RoundingMode.FLOOR)));
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
              poppable t = a;
              a=b;
              b=t;
            } else
              b = pop();

            if (a.type==BIGDECIMAL&b.type==BIGDECIMAL)push(a.bd.add(b.bd)); 
            if ((a.type==BIGDECIMAL)&(b.type==STRING)) push(b.s.indexOf(a.bd.toString())+1);
            if ((b.type==BIGDECIMAL)&(a.type==STRING)) push(a.s.indexOf(b.bd.toString())+1);
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
            data[ptr] = parseJSONObject("{\"N\":\""+a.s+"\",\"T\":3,\"L\":\"0\"}");//3-number, 2-string
            //eprintln(data[ptr].toString());
          } else
          if (a.type==STRING) {
            if (a.s.length()>0) {
              data[ptr] = parseJSONObject("{\"S\":\""+(a.s.substring(1))+"\",\"T\":2,\"L\":\"0\"}");//3-number, 2-string
              push(a.s.charAt(0)+"");
            }
          } else
          if (a.type==ARRAY) {
            if (a.a.size()>0) {
              push(a.a.get(0));
              a.a.remove(0);
              data[ptr] = parseJSONObject("{\"T\":4,\"L\":\"0\"}");//3-number, 2-string, 4-array
              dataA[ptr] = a;
              //println("%%%",data[ptr],"%%%");
            }
          }
        }
        if (cc=='∫') {
          a = pop(BIGDECIMAL);
          if (a.type==BIGDECIMAL) {
            data[ptr] = parseJSONObject("{\"N\":\""+a.s+"\",\"T\":3,\"L\":\"0\"}");//3-number, 2-string
            if (B(data[ptr].getString("N")).intValue()>1) push(B(0));
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
                poppable A = dataA[ptr];
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
                push(int(data[ptr].getString("L")));
                //oprintln(data[ptr].getString("N"));
              }
            }
          }
        }
        if (cc=='≤') {
          a = stack.get(0);
          stack.remove(0);
          push(a);
        }
        
        if (cc=='≥') {
          stack.add(0, pop());
        }
        
        if (cc=='∙') {
          a = pop();
          b = pop();
          if (((a.type==BIGDECIMAL)&&(b.type==STRING))||((a.type==STRING)&&(b.type==BIGDECIMAL))||((a.type==ARRAY)&&(b.type==BIGDECIMAL))) {
            poppable t = a;
            a = b;
            b = t;
          }
          if ((a.type==BIGDECIMAL)&&(b.type==ARRAY)) {
            ArrayList<poppable> out = new ArrayList<poppable>();
            for (int i = 0; i < b.a.size()*a.bd.longValue(); i++) {
              out.set(i,a.a.get(i%a.a.size()));
            }
            push(out);
          }
        }
        
        if (cc=='⁽') {
          a = pop();
          push((a.s.charAt(0)+"").toUpperCase()+a.s.substring(1));
        }
        
        if (cc=='÷') {
          a = pop(BIGDECIMAL);//5
          b = pop(BIGDECIMAL);//10 = 2
          if (a.type==BIGDECIMAL & b.type==BIGDECIMAL) push (b.bd.divideAndRemainder(a.bd)[0]);
        }

        
        if (cc=='╥') {
          a = npop(STRING);
          if (a.type==BIGDECIMAL)a=new poppable(a.toString());
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
          ptr+=2;
          push(p.charAt(ptr-1)+""+p.charAt(ptr));
        }
        
        if (cc=='δ') {
          a = pop();
          if (a.type==STRING) {
            String o = printableAscii.substring(0, printableAscii.indexOf(a.s));
            push(o);
          }
          if (a.type==BIGDECIMAL) {
            String o = "0123456789".substring(0, a.bd.intValue());
            push(o);
          }
        }
        
        if (cc=='Δ') {
          a = pop();
          if (a.type==STRING) {
            String o = printableAscii.substring(0, printableAscii.indexOf(a.s)+1);
            push(o);
          }
          if (a.type==BIGDECIMAL) {
            String o = "0123456789".substring(0, a.bd.intValue()+1);
            push(o);
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
            String[] s = new String[a.s.length()];
            for (int i = 0; i < a.s.length(); i++)
              s[i] = a.s.charAt(i)+"";
            push(s);
          } else if (a.type == ARRAY) {
            boolean string = false;
              for (poppable c : a.a)
                if (c.type==STRING||c.type==ARRAY)
                  string = true;
            if (string) {
              String out = "";
              for (poppable s : a.a)
                out+=s.s;
              push(out);
            } else {
              BigDecimal out = BigDecimal.ZERO;
              for (poppable bd : a.a)
                out=out.add(bd.bd);
              push(out);
            }
          }
        }
        
        if (cc=='ŗ') {
          a = pop();//last (to what to replace) 1st array
          b = pop();//middle (what to replace) 2nd arrat
          poppable c = pop();//first (from what to replace) 3rd array
          //poppable t;
          int ac = (a.type==ARRAY?1:0)+(b.type==ARRAY?1:0)+(c.type==ARRAY?1:0);
          /*if (b.type==ARRAY && a.type!=ARRAY) {
            t = a;
            a = b;
            b = t;
          }
          if (c.type==ARRAY && b.type!=ARRAY) {
            t = b;
            b = c;
            c = t;
          }
          if (b.type==ARRAY && a.type!=ARRAY) {
            t = a;
            a = b;
            b = t;
          }*/
          if (ac == 0) {
            push(c.s.replace(b.s,a.s));
          } else if (ac==1) {
            if (c.type==ARRAY) {
              ArrayList<poppable> o = new ArrayList<poppable>();
              for (int i = 0; i < a.a.size(); i++)
                o.add(tp(a.a.get(i).s.replace(b.s,a.s)));
              push(o);
            } else if (b.type==ARRAY) {
              
            } else {
              String o = "";
              int item = 0;
              int length = c.s.length();
              for (int i = 0; i < length; i++) {
                if (c.s.startsWith(b.s)) {
                  o+=a.a.get(item%a.a.size());
                  item++;
                } else {
                  o+=c.s.charAt(0);
                }
                c.s = c.s.substring(1);
              }
              push(o);
            }
          }
        }
        
        if (cc=='┼') {
          b = pop();
          a = pop();
          if (a.type==ARRAY) {
            if (b.type==STRING) {
              int maxlen = 0;
              for (poppable c : a.a) 
                if (c.s.length()>maxlen) 
                  maxlen = c.s.length();
              for (poppable c : a.a) 
                while (c.s.length()<maxlen)
                  c.s+=" ";
              for (int i = 0; i < b.s.length(); i++) {
                a.a.set(i%a.a.size(),tp(a.a.get(i%a.a.size()).s+b.s.charAt(i)));
              }
              push(a);
            }
          }
        }
        
        if (cc=='’') {
          ptr++;
          push(ALLCHARS.indexOf(p.charAt(ptr)));
        }
        
        if (cc=='”') {
          push("");
        }
      }
      //while (millis()<CTR*20);
      if (debug) {
        //eprintln("`"+cc+"`@"+((sptr+"").length()==1?"0"+sptr:sptr)+": "+stack.toString().replace("\n  ", "").replace("\n", ""));
        eprint("`"+cc+"`@"+up0(sptr, str(p.length()).length())+": [");
        long EPC=0;
        for (poppable EP : stack) {
          EPC++;
          eprint(EP.sline());
          if (EPC<stack.size()) eprint(", ");
        }
        eprintln("]");
      }
      //--------------------------------------loop end--------------------------------------
    } 
    catch (Exception e) {
        eprintln(e.toString());
        e.printStackTrace();
    }
  }
  if (ao) {
    oprintln();
    pop(STRING).print();
  }
}
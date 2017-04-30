class poppable {
  BigDecimal bd = new BigDecimal("0");
  String s = "";
  ArrayList<poppable> a = new ArrayList<poppable>();
  int type = 0;
  boolean inp = false;
  poppable (String ii) {
    type = STRING;
    s = ii;
  }
  poppable (BigDecimal ii) {
    type = BIGDECIMAL;
    bd = ii;
    s = ii.toString();
  }
  poppable (int ii) {
    type = ii;
    //bd = B(ii);
  }
  poppable (ArrayList<poppable> ii) {
    type = ARRAY;
    a = ii;
  }
  poppable () {
  }
  poppable (poppable tc) {
    type = tc.type;
    s = tc.s;
    a = tc.a;
    bd = tc.bd;
    inp = tc.inp;
  }
  poppable (poppable o, int varsave, Executable ex) {
    type = o.type;
    if (o.type==INS) {
      type = STRING;
      s = ex.sI().s;
      inp = true;
      ex.setvar(varsave, this);
    }
    if (o.type==INN) {
      type = BIGDECIMAL;
      bd = ex.nI().bd;
      s = bd.toString();
      inp = true;
      ex.setvar(varsave, this);
    }
    if (o.type==BIGDECIMAL) {
      bd = o.bd;
      s = bd.toString();
    }
    if (o.type==STRING) {
      s = o.s;
    }
  }
  poppable (BigDecimal ii, boolean imp) {
    type = BIGDECIMAL;
    bd = ii;
    s = ii.toString();
    inp = imp;
  }
  poppable (String ii, boolean imp) {
    type = STRING;
    s = ii;
    inp = imp;
  }
  poppable (ArrayList<poppable> ii, boolean imp) {
    type = ARRAY;
    a = ii;
    inp = imp;
  }
  void print () {
    if (type==STRING) currentPrinter.oprint(s);
    if (type==BIGDECIMAL) currentPrinter.oprint(bd);
    if (type==ARRAY) printArr();
  }
  void print (boolean normArr) {
    if (type==STRING) currentPrinter.oprint(s);
    if (type==BIGDECIMAL) currentPrinter.oprint(bd);
    if (type==ARRAY)
      if (normArr)
        currentPrinter.oprint(a.toArray().toString());
      else
        printArr();
  }
  void println () {
    if (type==STRING) currentPrinter.oprintln(s);
    if (type==BIGDECIMAL) currentPrinter.oprintln(bd);
    if (type==ARRAY) printArr();
  }
  void println (boolean normArr) {
    if (type==STRING) currentPrinter.oprintln(s);
    if (type==BIGDECIMAL) currentPrinter.oprintln(bd);
    if (type==ARRAY) {
      if (normArr) {
        currentPrinter.eprintln ("[\n");
        for (int i = 0; i < a.size()-1; i++) {
          a.get(i).println(true);
          currentPrinter.eprintln(",");
        }
        currentPrinter.eprintln("]");
      } else {
        printArr();
        println();
      }
    }
  }
  void printArr() {
    for (int i = 0; i < a.size()-1; i++) {
      a.get(i).println();
    }
    if (a.size()>0) a.get(a.size()-1).print();
  }
  String sline(boolean escape) {
    String toEscape = s;
    if (escape) {
      toEscape = toEscape.replace("\\", "\\\\");
      toEscape = toEscape.replace("\n", "\\n");
      toEscape = toEscape.replace("\"", "\\\"");
    }
    if (type==STRING) return "\""+toEscape+"\"";
    if (type==BIGDECIMAL) return bd.toString();
    if (type==ARRAY) {
      String o = "[";
      for (int i = 0; i < a.size(); i++) 
        o+=a.get(i).sline(escape)+(i+1==a.size()?"]":", ");
      return o;
    }
    return "*-*sline reached the unreachable!*-*";
  }
  poppable copy() {
    if (type==BIGDECIMAL) {
      return tp(bd);
    }
    if (type==BIGDECIMAL) {
      return tp(s);
    }
    ArrayList<poppable> out = ea();
    for (poppable cc : a) {
      out.add(cc.copy());
    }
    return tp(out);
  }
}
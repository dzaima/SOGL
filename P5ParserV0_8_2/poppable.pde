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
  poppable (poppable o, int varsave) {
    type = o.type;
    if (o.type==INS) {
      type = STRING;
      s = sI().s;
      inp = true;
      setvar(varsave, this);
    }
    if (o.type==INN) {
      type = BIGDECIMAL;
      bd = nI().bd;
      s = bd.toString();
      inp = true;
      setvar(varsave, this);
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
    if (type==STRING) oprint(s);
    if (type==BIGDECIMAL) oprint(bd);
    if (type==ARRAY) printArr();
  }
  void print (boolean normArr) {
    if (type==STRING) oprint(s);
    if (type==BIGDECIMAL) oprint(bd);
    if (type==ARRAY)
      if (normArr)
        oprint(a.toArray().toString());
      else
        printArr();
  }
  void println () {
    if (type==STRING) oprintln(s);
    if (type==BIGDECIMAL) oprintln(bd);
    if (type==ARRAY) printArr();
  }
  void println (boolean normArr) {
    if (type==STRING) oprintln(s);
    if (type==BIGDECIMAL) oprintln(bd);
    if (type==ARRAY) {
      if (normArr) {
        eprintln ("[\n");
        for (int i = 0; i < a.size()-1; i++) {
          a.get(i).println(true);
          eprintln(",");
        }
        eprintln("]");
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
  String sline () {
    if (type==STRING) return "\""+s+"\"";
    if (type==BIGDECIMAL) return bd.toString();
    if (type==ARRAY) {
      String o = "[";
      for (int i = 0; i < a.size(); i++) 
        o+=a.get(i).sline()+(i+1==a.size()?"]":", ");
      return o;
    }
    return "ERROR";
  }
}
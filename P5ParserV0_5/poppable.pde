class poppable {
  BigDecimal bd = new BigDecimal("0");
  String s = "";
  JSONArray a = new JSONArray();
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
  }
  poppable (JSONArray ii) {
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
  poppable (JSONArray ii, boolean imp) {
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
        oprint(a);
      else
        printArr();
  }
  void println () {
    if (type==STRING) oprintln(s);
    if (type==BIGDECIMAL) oprintln(bd);
    if (type==ARRAY) printArr();
      
  }
  void println (boolean lines) {
    if (type==STRING) oprintln(s);
    if (type==BIGDECIMAL) oprintln(bd);
    if (type==ARRAY)
      if (lines)
        oprintln(a);
      else printArr();
  }
  void printArr() {
    for (int i = 0; i < a.size(); i++) {
        try {
          oprintln(a.getString(i));
        } catch (Exception e) {
          try {
            oprintln(str(a.getInt(i)));
          } catch (Exception e2) {
            try {
              oprintln(a.getJSONArray(i));
            } catch (Exception e3) {
              
            }
          }
        }
      }
  }
}
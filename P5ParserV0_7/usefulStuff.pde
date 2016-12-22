UU U = new UU();
class UU {
  JSONArray toJSON (float[][] arrIn) {
    JSONArray out = new JSONArray();
    int i1 = 0;
    for (float[] e1 : arrIn) {
      JSONArray O2 = new JSONArray();
      for (float e2 : e1) {
        O2.append(e2);
      }
      out.setJSONArray(i1, O2);
      i1++;
    }
    return out;
  }
  JSONArray toJSON (int[][] arrIn) {
    JSONArray out = new JSONArray();
    int i1 = 0;
    for (int[] e1 : arrIn) {
      JSONArray O2 = new JSONArray();
      for (int e2 : e1) {
        O2.append(e2);
      }
      out.setJSONArray(i1, O2);
      i1++;
    }
    return out;
  }
  JSONArray toJSON (float[] arrIn) {
    JSONArray out = new JSONArray();
    for (float e2 : arrIn) {
      out.append(e2);
    }
    return out;
  }
  JSONArray toJSON (int[] arrIn) {
    JSONArray out = new JSONArray();
    for (int e2 : arrIn) {
      out.append(e2);
    }
    return out;
  }
  int[] toArray (JSONArray JSONIn) {
    //println(JSONIn.size());
    //println(JSONIn.getJSONArray(0).size());
    int[] out = new int[JSONIn.size()];
    for (int i1 = 0; i1 < JSONIn.size(); i1++) {
      out[i1] = JSONIn.getInt(i1);
    }
    return out;
  }
  int[][] toArray2 (JSONArray JSONIn) {
    //println(JSONIn.size());
    //println(JSONIn.getJSONArray(0).size());
    int[][] out = new int[JSONIn.size()][0];
    for (int i1 = 0; i1 < JSONIn.size(); i1++) {
      int[] out2 = new int[JSONIn.getJSONArray(i1).size()];
      for (int i2 = 0; i2 < JSONIn.getJSONArray(i1).size(); i2++) {
        out2[i2] = JSONIn.getJSONArray(i1).getInt(i2);
      } 
      out[i1] = out2;
    }
    return out;
  }
  PVector ucopy (PVector IN) {
    return (new PVector (IN.x, IN.y));
  }
  int[] ucopy (int[] IN) {
    int[] rez = new int[IN.length];
    for (int i = 0; i < IN.length; i++) {
      rez[i] = IN[i];
    }
    return rez;
  }
  int[][] ucopy (int[][] IN) {
    int[][] rez = new int[IN.length][0];
    for (int i = 0; i < IN.length; i++) {
      rez[i] = ucopy(IN[i]);
    }
    return rez;
  }
  String[][] ucopy (String[][] IN) {
    String[][] rez = new String[IN.length][0];
    for (int i = 0; i < IN.length; i++) {
      rez[i] = ucopy(IN[i]);
    }
    return rez;
  }
  String[] ucopy (String[] IN) {
    String[] rez = new String[IN.length];
    for (int i = 0; i < IN.length; i++) {
      rez[i] = IN[i];
    }
    return rez;
  }
  JSONObject uloadJSONObject (String path) {
    String[] strings = loadStrings(path);
    String joined = "";
    for (int x = 0; x<strings.length; x++) {
      joined = joined+strings[x];
    }
    return JSONObject.parse(joined);
  }
  void usaveJSONObject (JSONObject tosave, String path) {
    String[] strout = new String[1];
    strout[0] = tosave.toString();
    saveStrings(path, strout);
  } 
  JSONArray uloadJSONArray (String path) {

    String[] strings = loadStrings(path);
    String joined = "";
    for (int x = 0; x<strings.length; x++) {
      joined = joined+strings[x];
    }
    return JSONArray.parse(joined);
  }
  void usaveJSONArray (JSONArray tosave, String path) {
    String[] strout = new String[1];
    strout[0] = tosave.toString();
    saveStrings(path, strout);
  } 
  String uselectInput (String title, String callback) {
    return "";
  }
  String uselectOutput (String title, String callback) {
    return"";
  }
  boolean distChk(PVector p1, PVector p2, float comp) {
    if (U.distSq(p1, p2) < comp*comp) return true;
    return false;
  }
  //if dist between 1234 is less than 5 then true else false
  boolean distChk(float p1x, float p1y, float p2x, float p2y, float comp) {
    if ((p1x-p2x)*(p1x-p2x)+(p1y-p2y)*(p1y-p2y) < comp*comp) return true;
    return false;
  }
  float distSq (PVector p1, PVector p2) {
    return (p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y) ;
  } 
  float distSq (float p1x, float p1y, float p2x, float p2y) {
    return (p1x-p2x)*(p1x-p2x)+(p1y-p2y)*(p1y-p2y) ;
  } 
  float distSq (float p1x, float p1y, float p1z, float p2x, float p2y, float p2z) {
    return (p1x-p2x)*(p1x-p2x)+(p1y-p2y)*(p1y-p2y)+(p1z-p2z)*(p1z-p2z) ;
  }
  boolean isOn (float x, float y, float sx, float sy, float ex, float ey) {
    return (x > sx & y > sy & x < ex & y < ey);
  }
}
JSONArray loadJSONArray(String path) {
  return U.uloadJSONArray(path);
}
JSONObject loadJSONObject(String path) {
  return U.uloadJSONObject(path);
}
JSONArray parseJSONArray(String s) {
  return JSONArray.parse(s);
}
JSONObject parseJSONObject(String s) {
  return JSONObject.parse(s);
}
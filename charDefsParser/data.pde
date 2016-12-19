/**
 *this
 *is
 *<H1>DOCCSSSSS</H1>
 *
 */
class Data {
  int inputc;
  byte[][] types; //1 - number, 2 - string, 3 - array, 4 - number array, 5 - string array
  String[][] examples;
  String[] data;
  String[] ndata; //no input data
  Data (int inp, String[] din) {
    inputc = inp;
    ArrayList<byte[]> t = new ArrayList<byte[]>();
    StringList dt = new StringList();
    ArrayList<String[]> exs = new ArrayList<String[]>();//examples
    //ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList<ArrayList>>>>>>>>>>>>>>>> h;
    int ln = -1;
    for (String s : din) {
      ln++;
      //if (!s.contains(":")) continue;
      if (s.charAt(2)=='\t') continue;
      int i = 0;
      String start="", end="";
      while (s.charAt(i)!=':') {
        start+=s.charAt(i);
        i++;
        if (i == s.length()) break;
      }
      while (i<s.length()) {
        end+=s.charAt(i);
        i++;
      }
      StringList ext = new StringList();//example temp
      i = ln+1;
      if (i<din.length)
        while (din[i].charAt(2)=='\t') {
          ext.append(din[i].substring(3));
          i++;
          if (i == din.length) break;
        }
      String[] ex = ext.array();//examples
      //String[][] lds = new String[s.split(",").length][inp];//line definers
      //types = new int[s.split(",").length][inp];
      i=0;
      for (String p : start.split(",")) {
        int j = 0;
        byte[] temp = new byte[inp];
        for (String m : p.split("&")) {
          //lds[i][j] = m;
          temp[j] = 0;
          if (m.contains("number")) temp[j]+=1;
          if (m.contains("string")) temp[j]+=2;
          if (m.contains("array")) temp[j]+=3;
          if (m.contains("numbers")|m.contains("strings")|m.contains("arrays")) {
            j++; 
            temp[j] = temp[j-1];
          }
          j++;
        }
        t.add(temp);
        dt.append(end);
        exs.add(ex);
        i++;
      }
    }
    types = new byte[t.size()][inp];
    data = new String[t.size()];
    examples = new String[t.size()][];
    for (int i = 0; i < t.size(); i++) {
      for (int j = 0; j < t.get(i).length; j++) {
        types[i][j] = t.get(i)[j];
      }
      examples[i] = new String[exs.get(i).length];
      for (int j = 0; j < exs.get(i).length; j++) {
        examples[i][j] = exs.get(i)[j];
      }
      data[i] = dt.get(i);
    }
  }
  Data (String[] s) {
    inputc = 0;
    ndata = s;
  }
}
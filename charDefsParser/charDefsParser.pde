import java.util.Comparator;
import java.util.TreeMap;
import java.util.Map;
String[] data;//       0      1         2         3            4              5
String[] typeNames = {"any", "number", "string", "array", "number array", "string array", "error", "error"};
String[] search;// = {"variable", "\"a\""};
void setup() {
  String fullSearch = "hello world";
  search = fullSearch.split(" ");
  data = loadStrings("charDefs.txt");
  size(200, 200);
  surface.setResizable(true);
  String foundS = "";
  ArrayList<Data> foundD = new ArrayList<Data>();
  ArrayList<Float> foundCs = new ArrayList<Float>();
  for (int i = 98; i < data.length;i++) {
    String s = data[i];
    int foundc = 0;//found countd
    for (String cse : search)
      if (s.toLowerCase().contains(cse.toLowerCase()))
        foundc++;
      if (foundc>0) {
        int j = i;
        while (data[j].charAt(0)=='\t') j--;
        if (foundS.contains(data[j].charAt(0)+"")) {
          for(int k = 0; k < foundD.size(); k++) {
            if (foundD.get(k).Char.equals(data[j].charAt(0)+"")) {
              foundCs.set(k, foundCs.get(k)+foundc);
            }
          }
        } else {
          foundS += data[j].charAt(0);
          foundD.add(getInfo(data[j].charAt(0)+""));
          foundCs.add(foundc+i/10000f);
        }
      }
  }
  Map<Float, Data> found = new TreeMap<Float, Data>(/*new Comparator<Float>() 
    {
       public int compare(Float o1, Float o2) {                
         return o2.compareTo(o1);
       }
    }*/);
  for (int i = 0; i < foundD.size(); i++) {
    found.put(foundCs.get(i),foundD.get(i));
  }
  for(Map.Entry<Float, Data> sorted : found.entrySet()) {
    print(sorted.getKey()+": ");
    printInfo(sorted.getValue());
  }
  exit();
}
void printInfo (Data d) {
  println(d.Char+":");
  if (d.inputc>0) {
    for (int i = 0; i < d.types.length; i++) {
      print(" ");
      for (int j = 0; j < d.types[i].length; j++) {
        print(typeNames[d.types[i][j]]+((j+1==d.types[i].length)?"":" & "));
      }
      println (d.data[i]);
      for (int j = 0; j < d.examples[i].length; j++) {
        println("   ", d.examples[i][j]);
      }
    }
    for (String s : d.ndata) {
      println("  "+s);
    }
  }
  else {
    for (String s : d.ndata) {
      println("  "+s);
    }
  }
}
Data getInfo (String c) {
  //println(c);
  try{
  int i = 0;
  while (!data[i].startsWith(c+"\t")) i++;
  int is = i;
  StringList d = new StringList();
  if (data[i].length()>2 && (data[i].charAt(2)>='0' && data[i].charAt(2)<='9')) {
    while (data[i+1].charAt(0)=='\t') {
      d.append(data[i+1]);
      i++;
    }
    return new Data(int(data[is].charAt(2)+""), d.array(),c);
  } else {
    if (data[i].length()>2)
      d.append(data[i].substring(2));
    while (data[i+1].charAt(0)=='\t') {
      d.append(data[i+1].substring(2));
      i++;
    } 
    return new Data(d.array(),c);
  }
  }catch(Exception e){}//e.printStackTrace();}
  String[]a={"ERROR"};return new Data(a," ");
}
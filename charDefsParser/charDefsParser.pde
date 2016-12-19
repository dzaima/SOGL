String[] data;//       0      1         2         3            4              5
String[] typeNames = {"any", "number", "string", "array", "number array", "string array", "?", "?"};
String search = "uppercase";
int[] types = {1, 1};
void setup() {
  data = loadStrings("charDefs.txt");
  size(200, 200);
  surface.setResizable(true);
  int i = -1;
  String found = ""; 
  for (String s : data) {
    i++;
    if (s.contains(search)) {
      int j = i;
      while (data[j].charAt(0)=='\t') j--;
      if (!found.contains(data[j].charAt(0)+"")) {
      found += data[j].charAt(0);
      printInfo(data[j].charAt(0));}
    }
  }
  exit();
}
void printInfo (char c) {
  println(c+":");
  Data d = getInfo(c);
  if (d.inputc>0)
    for (int i = 0; i < d.types.length; i++) {
      for (int j = 0; j < d.types[i].length; j++) {
        print(" ", typeNames[d.types[i][j]]+((j+1==d.types[i].length)?"":" & "));
      }
      println (d.data[i]);
      for (int j = 0; j < d.examples[i].length; j++) {
        println("   ", d.examples[i][j]);
      }
    } 
  else {
    int i = 0;
    for (String s : d.ndata) {
      i++;
      if (i>0) print("  ");
      println(s);
    }
  }
}
Data getInfo (char c) {
  int i = 0;
  while (!data[i].startsWith(c+"\t")) i++;
  int is = i;
  StringList d = new StringList();
  if (data[i].charAt(2)>=0 && data[i].charAt(2)<=9)
    while (data[i+1].charAt(0)=='\t') {
      d.append(data[i+1]);
      i++;
    } else {
    d.append(data[i].substring(2));
    while (data[i+1].charAt(0)=='\t') {
      d.append(data[i+1].substring(2));
      i++;
    } 
    return new Data(d.array());
  }
  return new Data(int(data[is].charAt(2)+""), d.array());
}
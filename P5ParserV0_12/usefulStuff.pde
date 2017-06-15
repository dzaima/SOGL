String spaceup (String s, int l) {
  while (s.length()<l)
    s+=" ";
  return s;
}
ArrayList<Poppable> spacesquared(ArrayList<Poppable> arr) {
  ArrayList<Poppable> res = new ArrayList<Poppable>();
  int l = 0;
  for (Poppable b : arr) {
    if (b.s.length() > l)
      l = b.s.length();
  }
  for (Poppable b : arr) {
    res.add(tp(spaceup(b.s, l)));
  }
  return res;
}
String[] spacesquared(String[] arr) {
  String[] res = new String[arr.length];
  int l = 0;
  for (String b : arr) {
    if (b.length() > l)
      l = b.length();
  }
  int i = 0;
  for (String b : arr) {
    res[i] = spaceup(b, l);
    i++;
  }
  return res;
}
String reverseChars(String s, boolean reverse) {
  String res = "";
  int j = 0;
  if (reverse)
    j = s.length()-1;
  String swapChars = "/\\[](){}<>";
  for (int i = 0; i < s.length(); i++) {
    int index = swapChars.indexOf(s.charAt(j));
    if (index == -1)
      res += s.charAt(j);
    else
      res += swapChars.charAt(index ^ 1);
    j+= reverse? -1 : 1;
  }
  return res;
}
Poppable swapChars (Poppable p, char a, char b) {
  if (p.type==STRING) {
    String o = "";
    for (char s : p.s.toCharArray()) {
      if (s==a) o+= b; else
      if (s==b) o+= a; else
      o+=s;
    }
    return tp(o);
  }
  ArrayList<Poppable> out = ea();
  for (Poppable c : p.a) {
    out.add(swapChars(c, a, b));
  }
  return tp(out);
}
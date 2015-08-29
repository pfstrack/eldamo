package eldarin.parser;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class IndexParser {
    static final String SOURCE = "SMI/";
    static List<Ref> refs = new LinkedList<Ref>();
    static Set<String> written = new HashSet<String>();
    static Ref last;

    public static void main(String[] args) throws Exception {
        String entry = null;

        BufferedReader br = openReader("/Users/pfstrack/Dropbox/quenya-web/web/data/SMI.csv");
        String line = br.readLine();
        String text = "";
        while (line != null) {
            text += line + "\n";
            line = br.readLine();
        }
        text += "\n";
        List<List<String>> data = parseData(text, true);

        for (List<String> row : data) {
            boolean isEntry = true;
            boolean firstCell = true;
            for (String item : row) {
                if (item.startsWith("  ")) {
                    isEntry = false;
                }
                item = item.trim();
                if (item.length() == 0) {
                    continue;
                }
                Ref ref = parseRef(item, isEntry);
                if (isEntry) {
                    entry = ref.v;
                    int slash = entry.indexOf('/');
                    if (slash > 0) {
                        entry = entry.substring(0, slash);
                    }
                }
                ref.entry = entry;
                refs.add(ref);
                if (firstCell) {
                    last = ref;
                    firstCell = false;
                }
                isEntry = false;
            }
            line = br.readLine();
        }
        br.close();
        Collections.sort(refs);
        PrintWriter pw = openWriter("/Users/pfstrack/Dropbox/quenya-web/web/data/merge.xml");
        pw.print("<merge>\n");
        for (Ref ref : refs) {
            if (!"-".equals(ref.pos) && !written.contains(ref.getSource())) {
                pw.print(ref);
                written.add(ref.getSource());
            }
        }
        pw.print("</merge>\n");
        pw.close();
    }

    private static class Ref implements Comparable<Ref> {
        String v;
        String pos;
        String gloss;
        String entry;
        Map<String, Ref> relations = new HashMap<String, Ref>();

        public String toString() {
            String result = "";
            String word = getWord();
            result += "<word l=\"?\" v=\"" + word + "\" speech=\"proper-name\">\n";
            result += "   <ref" + getSource();
            if (gloss != null) {
                result += " gloss=\"" + gloss + "\"";
            }
            // if (isChanged()) {
            // result += " mark=\"-\"";
            // }
            if (relations.isEmpty()) {
                result += " />\n";
            } else {
                result += ">\n";
                for (String rel : relations.keySet()) {
                    if (">>".equals(rel)) {
                        result += "      <change"
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("<<".equals(rel)) {
                        result += "      <change"
                                + relations.get(rel).getSource() + " />\n";
                    } else if (">".equals(rel)) {
                        result += "      <deriv"
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("<".equals(rel)) {
                        result += "      <deriv"
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("cog.".equals(rel)) {
                        result += "      <cognate"
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("rcog.".equals(rel)) {
                        result += "      <cognate"
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("el.".equals(rel)) {
                        result += "      <element"
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("elof.".equals(rel)) {
                        result += "      <element"
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("pl.".equals(rel)) {
                        result += "      <inflect form=\"plural\""
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("plof.".equals(rel)) {
                        result += "      <inflect form=\"plural\""
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("clpl.".equals(rel)) {
                        result += "      <inflect form=\"class-plural\""
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("clplof.".equals(rel)) {
                        result += "      <inflect form=\"class-plural\""
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("sm.".equals(rel)) {
                        result += "      <inflect form=\"soft-mutation\""
                                + relations.get(rel).getSource() + " />\n";
                    } else if ("alt.".equals(rel)) {
                        result += "";
                    } else if ("altof.".equals(rel)) {
                        result += "";
                    } else {
                        result += "      <unknown rel=\"" + rel + "\" />\n";
                    }
                }
                result += "   </ref>\n";
            }
            result += "</word>\n";
            return result;
        }

        private String getWord() {
            String word = v;
            Ref wordRel = getWordRelation();
            if (wordRel != null) {
                word = wordRel.v;
            }
            int slash = word.indexOf('/');
            if (slash > 0) {
                word = word.substring(0, slash);
            }
            return word;
        }

        private String getSource() {
            if ("-".equals(pos)) {
                return "";
            }
            return " v=\"" + v + "\" source=\"" + SOURCE + entry + "." + pos
                    + "\"";
        }

        private Ref getWordRelation() {
            for (String key : relations.keySet()) {
                if (wordRels.contains(key)) {
                    return relations.get(key);
                }
            }
            return null;
        }

//        private boolean isChanged() {
//            return getChangeRelation() != null;
//        }
//
//        private Ref getChangeRelation() {
//            for (String key : relations.keySet()) {
//                if (changeRels.contains(key)) {
//                    return relations.get(key);
//                }
//            }
//            return null;
//        }

        @Override
        public int compareTo(Ref ref) {
            return this.getWord().compareTo(ref.getWord());
        }
    }

    private static Ref parseRef(String item, boolean isEntry) {
        String cell = item;
        Ref ref = new Ref();
        ref.pos = "001";
        if (!isEntry) {
            ref.pos = extract(cell, '(', ')');
            if (ref.pos == null) {
                throw new IllegalStateException("No pos: " + item);
            }
            cell = remove(cell, '(' + ref.pos + ')');
        }
        ref.gloss = extract(cell, '"', '"');
        if (ref.gloss != null) {
            cell = remove(cell, '"' + ref.gloss + '"');
        }
        String rel = deriveRelation(cell);
        if (rel != null) {
            cell = remove(cell, rel);
            if (reversed.contains(rel)) {
                ref.relations.put(rel, last);
            } else {
                last.relations.put(rel, ref);
            }
        }
        ref.v = cell;
        return ref;
    }

    static String[] relations = { "alt.", "altof.", "<<", ">>", "<", ">",
            "cog.", "rcog.", "el.", "elof.", "pl.", "plof.", "clpl.",
            "clplof.", "sm." };
    static String[] reversedArray = new String[] { "alt.", "<<", ">", "cog.",
            "pl.", "clpl.", "elof." };
    static Set<String> reversed = new HashSet<String>(
            Arrays.asList(reversedArray));
    static String[] wordRelArray = new String[] { "alt.", "altof.", "<<", ">>",
            "<", ">", "pl.", "plof.", "clpl.", "clplof.", "sm." };
    static Set<String> wordRels = new HashSet<String>(
            Arrays.asList(wordRelArray));
    static String[] changeRelArray = new String[] { "<<", ">>" };
    static Set<String> changeRels = new HashSet<String>(
            Arrays.asList(changeRelArray));

    private static String deriveRelation(String cell) {
        for (String rel : relations) {
            if (cell.startsWith(rel)) {
                return rel;
            }
        }
        return null;
    }

    private static String remove(String cell, String string) {
        return cell.replace(string, "").trim();
    }

    private static String extract(String item, char c, char d) {
        int start = item.indexOf(c);
        int end = item.indexOf(d, start + 1);
        if (start > 0 && end > start) {
            return item.substring(start + 1, end);
        } else {
            return null;
        }
    }

    private static BufferedReader openReader(String path)
            throws FileNotFoundException, UnsupportedEncodingException {
        FileInputStream fis = new FileInputStream(path);
        InputStreamReader isr = new InputStreamReader(fis, "UTF-8");
        return new BufferedReader(isr);
    }

    private static PrintWriter openWriter(String path)
            throws FileNotFoundException, UnsupportedEncodingException {
        FileOutputStream fos = new FileOutputStream(path);
        OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF-8");
        return new PrintWriter(osw);
    }

    private static List<List<String>> parseData(String data, boolean quoting) {
        char[] chars = data.toCharArray();
        boolean inQuotes = false;
        List<List<String>> result = new LinkedList<List<String>>();
        List<String> row = new LinkedList<String>();
        result.add(row);
        StringBuffer field = new StringBuffer();
        for (int i = 0; i < chars.length; i++) {
            char c = chars[i];
            if (inQuotes) {
                if (c == '"' && quoting) {
                    if ((i + 1 < chars.length) && chars[i + 1] == '"') {
                        field.append('"');
                        i++;
                        continue;
                    } else {
                        inQuotes = false;
                    }
                } else {
                    field.append(c);
                }
            } else {
                if (c == '"' && quoting) {
                    inQuotes = true;
                } else if (c == ';') {
                    row.add(field.toString());
                    field.setLength(0);
                } else if (c == '\n') {
                    row.add(field.toString());
                    field.setLength(0);
                    row = new LinkedList<String>();
                    result.add(row);
                } else {
                    field.append(c);
                }
            }
        }
        if (row.size() == 0) {
            result.remove(result.size() - 1);
        }
        return result;
    }
}

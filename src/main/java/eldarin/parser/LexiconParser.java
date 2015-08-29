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
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class LexiconParser {
    static final String SOURCE = "PE14/010.";
    static final String BASE_LANG = "eq";
    static final String COG_LANG = "g";
    static final String ROOT_LANG = "ep";
    static final String SUB_LANG = null;

    static List<Ref> refs = new LinkedList<Ref>();
    static Set<String> written = new HashSet<String>();
    static List<Ref> last = new LinkedList<Ref>();

    public static void main(String[] args) throws Exception {
        BufferedReader br = openReader("/Users/pfstrack/Dropbox/quenya-web/web/data/QL.csv");
        String line = br.readLine();
        String text = "";
        while (line != null) {
            text += line + "\n";
            line = br.readLine();
        }
        br.close();
        text += "\n";
        List<List<String>> data = parseData(text, true);

        for (List<String> row : data) {
            System.err.println(row);
            if (row.size() <= 1 || row.get(0).trim().length() == 0) {
                continue; // Skip
            }
            int lineNum = Integer.parseInt(row.get(0).trim());
            boolean isEntry = true;
            for (int i = 1; i < row.size(); i++) {
                String item = row.get(i);
                if (item.length() == 0) {
                    continue;
                }
                if (isEntry) {
                    clearLast(item);
                }
                Ref ref = parseRef(item.trim(), lineNum, isEntry);
                if (isEntry) {
                    addLast(ref, item);
                }
                refs.add(ref);
                isEntry = false;
            }
        }
        // Collections.sort(refs);
        PrintWriter pw = openWriter("/Users/pfstrack/Dropbox/quenya-web/web/data/merge.xml");
        pw.print("<merge>\n");
        for (Ref ref : refs) {
            try {
                if (!"-".equals(ref.pos) && !written.contains(ref.getSource())) {
                    System.out.println(ref);
                    pw.print(ref);
                    written.add(ref.getSource());
                }
            } catch (Exception ex) {
                throw ex;
            }
        }
        pw.print("</merge>\n");
        pw.close();
    }

    private static void clearLast(String item) {
        int depth = derivDepth(item);
        while (last.size() > depth) {
            last.remove(depth);
        }
    }

    private static int derivDepth(String item) {
        int pos = 0;
        if (item.startsWith("            ")) {
            pos = 3;
        } else if (item.startsWith("        ")) {
            pos = 2;
        } else if (item.startsWith("    ")) {
            pos = 1;
        }
        return pos;
    }

    private static void addLast(Ref ref, String item) {
        int depth = derivDepth(item);
        last.add(depth, ref);
    }

    private static class Ref implements Comparable<Ref> {
        String v;
        String pos;
        String gloss;
        String notes;
        Map<String, List<Ref>> relations = new HashMap<String, List<Ref>>();
        public String speech;
        private String lang;

        public String toString() {
            String result = "";
            Ref word = getWord();
            result += "<word l=\"" + lang + "\" v=\"" + word.getValue() + "\" speech=\"" + speech + "\"";
            String wordMark = word.getMark();
            if (wordMark != null) {
                result += " mark=\"" + wordMark + "\"";
            }
            result += ">\n";
            result += "   <ref";
            if (SUB_LANG != null && BASE_LANG.equals(lang)) {
                result += " l=\"" + SUB_LANG + "\"";
            }
            result += getSource();
            if (gloss != null) {
                result += " gloss=\"" + gloss + "\"";
            }
            String mark = getMark();
            if (mark != null) {
                result += " mark=\"" + mark + "\"";
            }
            if (relations.isEmpty() && notes == null) {
                result += " />\n";
            } else {
                result += ">\n";
                for (String rel : relations.keySet()) {
                    List<Ref> refs = relations.get(rel);
                    for (Ref ref : refs) {
                        if (ref == null) {
                            continue;
                        }
                        if (">>".equals(rel)) {
                            result += "      <change" + ref.getSource() + " />\n";
                        } else if ("<<".equals(rel)) {
                            result += "      <change" + ref.getSource() + " />\n";
                        } else if (">".equals(rel)) {
                            result += "      <deriv" + ref.getSource() + " />\n";
                        } else if ("<".equals(rel)) {
                            result += "      <deriv" + ref.getSource() + " />\n";
                        } else if ("cog".equals(rel)) {
                            result += "      <cognate" + ref.getSource() + " />\n";
                        } else if ("rcog".equals(rel)) {
                            result += "      <cognate" + ref.getSource() + " />\n";
                        } else if ("el".equals(rel)) {
                            result += "      <element" + ref.getSource() + " />\n";
                        } else if ("ex".equals(rel)) {
                            result += "      <example" + ref.getSource() + " />\n";
                        } else if ("elof".equals(rel)) {
                            result += "      <element" + ref.getSource() + " />\n";
                        } else if ("exof".equals(rel)) {
                            result += "      <example" + ref.getSource() + " />\n";
                        } else if ("dual".equals(rel)) {
                            result += "      <inflect form=\"dual\"" + ref.getSource() + " />\n";
                        } else if ("acc".equals(rel)) {
                            result += "      <inflect form=\"accusative\"" + ref.getSource() + " />\n";
                        } else if ("pl".equals(rel)) {
                            result += "      <inflect form=\"plural\"" + ref.getSource() + " />\n";
                        } else if ("plof".equals(rel)) {
                            result += "      <inflect form=\"plural\"" + ref.getSource() + " />\n";
                        } else if ("1st-sg-of".equals(rel)) {
                            result += "      <inflect form=\"present 1st-sg\"" + ref.getSource() + " />\n";
                        } else if ("3rd-sg-of".equals(rel)) {
                            result += "      <inflect form=\"present 3rd-sg\"" + ref.getSource() + " />\n";
                        } else if ("clpl".equals(rel)) {
                            result += "      <inflect form=\"class-plural\"" + ref.getSource() + " />\n";
                        } else if ("clplof".equals(rel)) {
                            result += "      <inflect form=\"class-plural\"" + ref.getSource() + " />\n";
                        } else if ("sm".equals(rel)) {
                            result += "      <inflect form=\"soft-mutation\"" + ref.getSource() + " />\n";
                        } else if ("stem".equals(rel)) {
                            result += "      <inflect form=\"stem\"" + ref.getSource() + " />\n";
                        } else if ("present 1st-sg".equals(rel)) {
                            result += "      <inflect form=\"present 1st-sg\"" + ref.getSource() + " />\n";
                        } else if ("imperative".equals(rel)) {
                            result += "      <inflect form=\"imperative\"" + ref.getSource() + " />\n";
                        } else if ("past".equals(rel)) {
                            result += "      <inflect form=\"past\"" + ref.getSource() + " />\n";
                        } else if ("alt".equals(rel)) {
                            result += "";
                        } else if ("altof".equals(rel)) {
                            result += "";
                        } else {
                            result += "      <unknown rel=\"" + rel + "\" />\n";
                        }
                    }
                }
                if (notes != null) {
                    result += "      <notes><![CDATA[" + notes + "]]></notes>\n";
                }
                result += "   </ref>\n";
            }
            result += "</word>\n";
            return result;
        }

        private Ref getWord() {
            List<Ref> wordRel = getWordRelation();
            if (wordRel != null) {
                return wordRel.get(0);
            } else {
                return this;
            }
        }

        private String getSource() {
            if ("-".equals(pos)) {
                return "";
            }
            String source = " v=\"" + getValue() + "\" source=\"" + SOURCE + pos + "\"";
            return source;
        }

        private String getValue() {
            if (getMark() != null) {
                return v.substring(1);
            } else {
                return v;
            }
        }

        private String getMark() {
            String mark = null;
            if (v.startsWith("{")) {
                mark = "-";
            } else if (v.startsWith("#")) {
                mark = "#";
            } else if (v.startsWith("*")) {
                mark = "*";
            } else if (v.startsWith("†")) {
                mark = "†";
            } else if (v.startsWith("‽")) {
                mark = "‽";
            }
            return mark;
        }

        private List<Ref> getWordRelation() {
            for (String key : relations.keySet()) {
                if (wordRels.contains(key)) {
                    return relations.get(key);
                }
            }
            return null;
        }

        void addRelation(String type, Ref ref) {
            List<Ref> list = relations.get(type);
            if (list == null) {
                list = new LinkedList<Ref>();
                relations.put(type, list);
            }
            list.add(ref);
        }

        @Override
        public int compareTo(Ref ref) {
            return this.getWord().compareTo(ref.getWord());
        }
    }

    private static Ref parseRef(String item, int lineNum, boolean isEntry) {
        String cell = item;
        Ref ref = new Ref();
        ref.pos = extract(cell, '[', ']');
        if (ref.pos == null) {
            if (isEntry) {
                ref.pos = "01";
            } else {
                throw new IllegalStateException("No pos: " + item);
            }
        } else {
            cell = remove(cell, "\\[" + ref.pos + "\\]");
        }
        if (!isEntry) {
        }
        if (ref.pos.length() < 4) {
            ref.pos = ("-".equals(ref.pos) ? "" : lineNum) + ref.pos;
        }
        if (ref.pos.length() < 4 && !"-".equals(ref.pos)) {
            ref.pos = "0" + ref.pos;
        }
        ref.gloss = extract(cell, '"', '"');
        if (ref.gloss != null) {
            cell = remove(cell, '"' + ref.gloss + '"');
        }
        String rel = deriveRelation(cell);
        if (rel != null) {
            cell = remove(cell, rel + " ");
            if (reversed.contains(rel)) {
                ref.addRelation(rel, getLast());
            } else {
                getLast().addRelation(rel, ref);
            }
        }
        ref.speech = deriveSpeech(cell);
        if (ref.speech == null) {
            ref.speech = "?";
        } else {
            cell = remove(cell, ref.speech + " ");
        }
        if (cell.contains(":")) {
            String[] split = cell.split(":");
            ref.notes = split[1].trim();
            cell = split[0].trim();
        }
        ref.v = cell;
        ref.lang = BASE_LANG;
        if (ref.v.toUpperCase().equals(ref.v)) {
            ref.lang = ROOT_LANG;
        } else if ("cog".equals(rel)) {
            ref.lang = COG_LANG;
        }
        return ref;
    }

    private static Ref getLast() {
        if (last.isEmpty()) {
            return null;
        }
        return last.get(last.size() - 1);
    }

    static String[] speech = { "root", "n", "vb", "adj", "adv", "prep", "pref", "suf", "conj", "interj", "phrase",
        "masc-name", "fem-name", "place-name", "proper-name", "collective-name", "pron", "cardinal", "ordinal" };
    static String[] relations = { "alt", "altof", "<<", ">>", "<", ">", "cog", "rcog", "el", "ex", "elof", "exof", "dual",
        "acc", "pl", "plof", "1st-sg-of", "3rd-sg-of", "clpl", "clplof", "sm", "stem", "past", "imperative", "present 1st-sg" };
    static String[] reversedArray = new String[] { "alt", "<<", ">", "cog", "dual", "acc", "pl", "clpl", "elof", "exof",
        "stem", "past", "imperative", "present 1st-sg" };
    static Set<String> reversed = new HashSet<String>(Arrays.asList(reversedArray));
    static String[] wordRelArray = new String[] { "alt", "altof", "<<", ">>", "dual", "acc", "pl", "plof", "1st-sg-of", "3rd-sg-of", "clpl",
        "clplof", "sm", "stem", "past", "imperative", "present 1st-sg" };
    static Set<String> wordRels = new HashSet<String>(Arrays.asList(wordRelArray));
    static String[] changeRelArray = new String[] { "<<", ">>" };
    static Set<String> changeRels = new HashSet<String>(Arrays.asList(changeRelArray));

    private static String deriveRelation(String cell) {
        for (String rel : relations) {
            if (cell.startsWith(rel + " ")) {
                return rel;
            }
        }
        return null;
    }

    private static String deriveSpeech(String cell) {
        for (String type : speech) {
            if (cell.startsWith(type + " ")) {
                return type;
            }
        }
        return null;
    }

    private static String remove(String cell, String string) {
        string = string.replace("(", "\\(");
        string = string.replace(")", "\\)");
        return cell.replaceFirst(string, "").trim();
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

    private static BufferedReader openReader(String path) throws FileNotFoundException,
        UnsupportedEncodingException {
        FileInputStream fis = new FileInputStream(path);
        InputStreamReader isr = new InputStreamReader(fis, "UTF-8");
        return new BufferedReader(isr);
    }

    private static PrintWriter openWriter(String path) throws FileNotFoundException,
        UnsupportedEncodingException {
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

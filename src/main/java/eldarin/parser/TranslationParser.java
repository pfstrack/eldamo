package eldarin.parser;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranslationParser {

    public static void main(String[] args) throws Exception {
        // The older export with partial translations
        List<List<String>> baseList = readFile("/Users/pfstrack/Desktop/base-polish.txt");
        Map<String, List<String>> baseMap = new HashMap<String, List<String>>();
        for (List<String> row : baseList) {
            baseMap.put(row.get(0), row);
        }
        // The new export from Eldamo
        List<List<String>> export = readFile("/Users/pfstrack/Desktop/export-polish.txt");
        for (List<String> row : export) {
            List<String> baseRow = baseMap.get(row.get(0));
            if (baseRow != null) {
                row.add(baseRow.get(5));
                if (!row.get(4).equals(baseRow.get(4))) {
                    row.add("English Updated");
                }
            }
        }
        PrintWriter writer = openWriter("/Users/pfstrack/Desktop/output.txt");
        for (List<String> row : export) {
            StringBuilder text = new StringBuilder();
            for (String cell : row) {
                text.append(cell).append('\t'); 
            }
            writer.println(text.toString());
        }
        writer.close();
    }

    private static List<List<String>> readFile(String file)
            throws FileNotFoundException, UnsupportedEncodingException,
            IOException {
        BufferedReader br = openReader(file);
        List<List<String>> data = new ArrayList<List<String>>();
        String line = br.readLine();
        while (line != null) {
            List<String> cells = Arrays.asList(line.split("\t"));
            List<String> row = new ArrayList<String>();
            row.addAll(cells);
            data.add(row);
            line = br.readLine();
        }
        return data;
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
}

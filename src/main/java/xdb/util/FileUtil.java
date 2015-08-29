package xdb.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.zip.GZIPOutputStream;

/**
 * File utility class.
 */
public final class FileUtil {
    public static final String[] IGNORED_EXTENSIONS = { ".svn" };
    private static final int BUFFER_SIZE = 1024;
    private static final File[] EMPTY_FILE_ARRAY = new File[0];

    private FileUtil() {
    }

    /**
     * Utility method to list files but return an empty array instead of null for no results.
     * 
     * @param dir
     *            The directory.
     * @return The array of files.
     */
    public static File[] listFiles(File dir) {
        File[] files = dir.listFiles();
        if (files == null) {
            files = EMPTY_FILE_ARRAY;
        }
        return files;
    }

    /**
     * Delete a file or directory.
     * 
     * @param file
     *            The file or directory.
     * @throws IOException
     *             For IO Errors.
     */
    public static void delete(File file) throws IOException {
        if (file.isDirectory()) {
            deleteDir(file);
        } else {
            deleteFile(file);
        }
    }

    /**
     * Delete a directory and all of its contents.
     * 
     * @param dir
     *            The directory.
     * @throws IOException
     *             If something cannot be deleted.
     */
    public static void deleteDir(File dir) throws IOException {
        if (!dir.exists()) {
            return;
        }
        File[] files = listFiles(dir);
        for (int i = 0; i < files.length; i++) {
            File file = files[i];
            if (file.isDirectory()) {
                deleteDir(file);
            } else {
                deleteFile(file);
            }
        }
        dir.delete();
    }

    /**
     * Delete file.
     * 
     * @param file
     *            The file.
     * @throws IOException
     *             If the file was not deleted.
     */
    private static void deleteFile(File file) throws IOException {
        boolean success = file.delete();
        if (!success) {
            throw new IOException("Could not delete " + file);
        }
    }

    /**
     * List files in a directory, including subdirectories. Subdirectories are not included. If
     * there are no files, an empty array is returned. Files and directories ending with one of the
     * IGNORED_EXTENSIONS are excluded.
     * 
     * @param dir
     *            The directory.
     * @return The array of files.
     */
    public static File[] listFilesIncludingSubdirectories(File dir) {
        List<File> list = new LinkedList<File>();
        addFilesToList(list, dir);
        File[] array = new File[list.size()];
        list.toArray(array);
        return array;
    }

    /** Add files in directory to list, including subdirectories. */
    private static void addFilesToList(List<File> fileList, File dir) {
        File[] array = FileUtil.listFiles(dir);
        for (int i = 0; i < array.length; i++) {
            File file = array[i];
            for (String extension : IGNORED_EXTENSIONS) {
                if (file.getName().endsWith(extension)) {
                    continue; // Skip file
                }
            }
            if (file.isFile()) {
                fileList.add(file);
            } else if (file.isDirectory()) {
                addFilesToList(fileList, file);
            }
        }
    }

    /**
     * Open UTF-8 output stream to target file.
     * 
     * @param file
     *            The file.
     * @return The stream.
     * @throws IOException
     *             For errors.
     */
    public static PrintWriter open(File file) throws IOException {
        file.getParentFile().mkdirs();
        FileOutputStream fos = new FileOutputStream(file);
        OutputStreamWriter osw = new OutputStreamWriter(fos, "utf-8");
        BufferedWriter bw = new BufferedWriter(osw);
        return new PrintWriter(bw);
    }

    /**
     * Open UTF-8 output stream to target file.
     * 
     * @param path
     *            The file path.
     * @return The stream.
     * @throws IOException
     *             For errors.
     */
    public static PrintWriter open(String path) throws IOException {
        return open(new File(path));
    }

    /**
     * Open UTF-8 gzip output stream to target file.
     * 
     * @param file
     *            The file.
     * @return The stream.
     * @throws IOException
     *             For errors.
     */
    public static PrintWriter openGzip(File file) throws IOException {
        file.getParentFile().mkdirs();
        FileOutputStream fos = new FileOutputStream(file);
        GZIPOutputStream gos = new GZIPOutputStream(fos, BUFFER_SIZE);
        OutputStreamWriter osw = new OutputStreamWriter(gos, "utf-8");
        return new PrintWriter(osw);
    }

    /**
     * Open UTF-8 gzip output stream to target file.
     * 
     * @param path
     *            The file path.
     * @return The stream.
     * @throws IOException
     *             For errors.
     */
    public static PrintWriter openGzip(String path) throws IOException {
        return openGzip(new File(path));
    }

    /**
     * Move a temporary file to its correct location.
     * 
     * @param temp
     *            The temporary file path.
     * @param target
     *            It's target location path.
     * @throws IOException
     *             For failures.
     */
    public static void moveTempFile(String temp, String target) throws IOException {
        moveTempFile(new File(temp), new File(target));
    }

    /**
     * Move a temporary file to its correct location.
     * 
     * @param temp
     *            The temporary file.
     * @param target
     *            It's target location.
     * @throws IOException
     *             For failures.
     */
    public static void moveTempFile(File temp, File target) throws IOException {
        if (target.exists()) {
            target.delete();
        }
        boolean success = temp.renameTo(target);
        if (!success) {
            String msg = "Could not move '" + temp + "' to '" + target + "'";
            throw new IOException(msg);
        }
    }

    /**
     * Open UTF-8 input stream to target file.
     * 
     * @param file
     *            The file.
     * @return The stream.
     * @throws IOException
     *             For errors.
     */
    public static BufferedReader read(File file) throws IOException {
        FileInputStream fis = new FileInputStream(file);
        InputStreamReader isr = new InputStreamReader(fis, "utf-8");
        return new BufferedReader(isr);
    }

    /**
     * Load a text file as a single string. The contents of the file are normalized, in that line
     * breaks are always a single newline character ('\n'), regardless of the operating system.
     * 
     * @param file
     *            The file.
     * @return The text as a string.
     * @throws IOException
     *             For errors.
     */
    public static String loadText(File file) throws IOException {
        StringBuffer sb = new StringBuffer();
        BufferedReader br = read(file);
        try {
            String line = br.readLine();
            while (line != null) {
                sb.append(line);
                line = br.readLine();
                if (line != null) {
                    sb.append('\n');
                }
            }
        } finally {
            br.close();
        }
        return sb.toString();
    }

    /**
     * Write a marker file (with current date).
     * 
     * @param path
     *            The file path.
     * @throws IOException
     *             For errors.
     */
    public static void writeMarkerFile(String path) throws IOException {
        writeToFile(path, new Date().toString());
    }

    /**
     * Write text to a file.
     * 
     * @param path
     *            The file path.
     * @param text
     *            The text.
     * @throws IOException
     *             For errors.
     */
    public static void writeToFile(String path, String text) throws IOException {
        PrintWriter out = open(path);
        try {
            out.print(text);
        } finally {
            out.close();
        }
    }

    /**
     * Determine a directory's real path from the classpath.
     * 
     * @param cls The class.
     * @param file A file inside that directory/.
     * @return The directory path.
     */
    public static String findDirectoryFromClasspath(Class<?> cls, String file) {
        URL rootMarker = cls.getResource(file);
        String markerPath = rootMarker.getPath();
        File markerFile = new File(markerPath);
        return markerFile.getParentFile().getAbsolutePath() + "/";
    }

    /**
     * Pull data from a URL and write it as a file.
     *
     * @param url The URL.
     * @param path The output file path.
     * @throws IOException For errors.
     */
    public static void pullFileFromUrl(String url, String path)
            throws IOException {
        URL urlObject = new URL(url);
        URLConnection con = urlObject.openConnection();
        con.setConnectTimeout(5000); // 5 seconds
        con.setReadTimeout(10 * (int) 600000); // 10 minutes
        InputStream in = con.getInputStream();
        int i = 0;
        byte[] bytesIn = new byte[1024];
        try {
            File file = new File(path);
            File parentFile = file.getParentFile();
            parentFile.mkdirs();
            FileOutputStream out = new FileOutputStream(file);
            try {
                while ((i = in.read(bytesIn)) >= 0) {
                    out.write(bytesIn, 0, i);
                }
            } finally {
                out.close();
            }
        } finally {
            in.close();
        }
    }

    /**
     * Copy a file. Generates errors if the source or target files are 0-byte.
     *
     * @param in
     *            The input file.
     * @param out
     *            The output file.
     * @throws IOException
     */
    public static void copyFile(String in, String out) throws IOException {
        copyFile(new File(in), new File(out));
    }

    /**
     * Copy a file. Generates errors if the source or target files are 0-byte.
     *
     * @param in
     *            The input file.
     * @param out
     *            The output file.
     * @throws IOException
     */
    public static void copyFile(File in, File out) throws IOException {
        if (!in.exists()) {
            throw new IOException("Input file " + in + " does not exist.");
        }
        if (in.length() == 0) {
            String msg = "Input file '" + in + "' is 0-byte. File not copied.";
            throw new IOException(msg);
        }
        out.getParentFile().mkdirs();
        File tmp = new File(out.getAbsolutePath() + ".tmpcopy");
        FileInputStream fis = new FileInputStream(in);
        BufferedInputStream bis = new BufferedInputStream(fis);
        FileOutputStream fos = new FileOutputStream(tmp);
        BufferedOutputStream bos = new BufferedOutputStream(fos);
        try {
            int b = bis.read();
            while (b >= 0) {
                bos.write(b);
                b = bis.read();
            }
        } finally {
            bis.close();
            bos.close();
        }
        moveTempFile(tmp, out);
    }
}

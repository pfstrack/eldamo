# Eldamo

An Elvish Data Model in XML.

Most consumers of this project are probably interested in the finished product, the generate Elvish lexicon. This can be
found at http://eldamo.org and project releases are zip files of this site.

This document provides information for those interested in how the Eldamo site is generated. To fully understand this
process, you need to know:

* Java web application development
* XML editing and parsing, include XSL and XQuery

## Requirements

1. Git
2. Java 1.6+
3. Gradle 2.0+ (which will download other dependencies)
4. A good text editor (I use TextWrangler on OS X).
5. For generating the site, a web crawler (I use SiteSucker on OS X)

## Command-line Execution

1) Clone the project from github:

```
git clone https://github.com/pfstrack/eldamo.git
```

2) Copy the data directory inside the web application directory:

```
cp -R src/data src/main/webapp
```

Or simply manually copy the directory.

3) Use gradle to launch the Jetty web application server (tomcat probably also works).

```
gradle :jettyRun
```

4) Browse the site:

```
http://localhost:8080/eldamo/
```

5) Edit the data file (src/main/webapp/eldamo-data.xml) and refresh the pages to see changes.

## Building in Eclipse

If you want to use an Java development tool, here is how to set the project up in Eclipse:

1) Use gradle generate an Eclipse project:

```
gradle :eclipse
```

2) Import the project into Eclipse: File > Import : General > Existing Project Into Workspace

3) In the project properties, set the file encoding to UTF-8:

* Project > Properties
* Resource > Text File Encoding
* Select Other: UTF-8

4) Install the Jetty plug-in for Eclipse.

5) Select the project and Run > Run As > Run Jetty

6) Browse the site as above:

```
http://localhost:8080/eldamo/
```

## Building the Eldamo Site

1) Switch to the "pub" (publish) version of the site:

```
http://localhost:8080/eldamo/pub/index.html
```

2) Use your web crawler of choice to crawl and download the site contents.
import std.xml, std.stdio, std.string, std.conv, std.file;
import Compiler.Globals, Compiler.Tools, dxml.parser, dxml.util, dxml.dom;

struct ConfigValue {
	string Id, Name, Data, Bool;
	}

struct ConfigMetaValue {
	string Author, Version, ReleaseDate;
}

class Config { 
	private	static bool initialized;
	public static ConfigValue[string] settings;
	public static ConfigMetaValue[string] meta;
	private string XmlData;
	private Document doc;
	private DocumentParser xml;
	
	/* Initialize all configuration values once upon initialization of class */
	this() {
		if ( this.initialized != true ) {
			if ( !std.file.exists("./config.xml") ) {
				throw new JException("Configuration file does not exist.", 0);
				}
			XmlData = cast(string) std.file.read("./config.xml");			
			check(XmlData);
			doc = new Document(XmlData);
			xml = new DocumentParser(XmlData);				

			/* Generate standard Value datasets */
			xml.onStartTag["Value"] = (ElementParser xml)
			{
				ConfigValue set1;
				
				set1.Id 	= xml.tag.attr["id"];
				set1.Name 	= xml.tag.attr["name"];
				
				xml.onEndTag["Data"]       = (in Element e) { set1.Data      = e.text(); };
				xml.onEndTag["Bool"]       = (in Element e) { set1.Bool      = e.text(); };
				
				xml.parse();
				this.settings[set1.Name] = set1;
			};
			xml.parse();
			
			this.XmlParseArray("Meta", [], [ "Author", "ReleaseDate", "Version" ]);
			
			/* Set to true */
			this.initialized = true;
		}
	}
	
	private string[string] XmlParseArray(string tag, string[] attributes, string[] tags) {
		string[string] data1;
		string mix;
		
		xml.onStartTag[tag] = (ElementParser xml)
		{
			//xml.onEndTag[tags[0]]       	= (in Element e) { data1[tags[0]]      = e.text(); };			
			//xml.onEndTag[tags[1]]       	= (in Element e) { data1[tags[2]]      = e.text(); };			
			xml.parse();
		};
		
		xml.parse();
		writeln(data1);
		return data1;
	}
}
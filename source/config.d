import std.xml, std.stdio, std.string, std.conv, std.file;
import Compiler.Globals, Compiler.Tools, dxml.parser, dxml.util, dxml.dom;

struct ConfigValue {
	string Id, Name, Data, Bool;
	}

struct ConfigMetaValue {
	string Author, Version, ReleaseDate;
}

struct ConfigArray {
	string[string] attributes, tags;
	}

class Config { 
	private	static bool initialized;
	public static ConfigValue[string] settings;
	public static ConfigMetaValue[string] meta;
	
	/* Initialize all configuration values once upon initialization of class */
	this() {
		if ( this.initialized != true ) {
			string XmlData;
			
			if ( !std.file.exists("./config.xml") ) {
				throw new JException("Configuration file does not exist.", 0);
				} else { 
				XmlData = cast(string) std.file.read("./config.xml");			
				check(XmlData);
				}
				
			ConfigArray[string] k = this.XmlParseArray(XmlData, "Value", 0, [ "id", "name" ], [ "Data", "Bool" ], false);
			ConfigArray[string] y = this.XmlParseArray(XmlData, "Meta", 0, [], [ "Author", "ReleaseDate", "Version" ], true);
			
			writeln(k);
			writeln(y);
			
			/* Set to true */
			this.initialized = true;
		}
	}
	
	/** Never, ever write an XML parser like this. Please. **/
	private ConfigArray[string] XmlParseArray(string XmlData, string tag, int id, string[] attributes, string[] tags, bool useTagForID = false) {
		ConfigArray[string] all;
		
		auto doc = new Document(XmlData);
		auto xml = new DocumentParser(XmlData);	
		
		/* Maximum of 4 attributes and 16 tags due to poor implementation */
		if ( attributes.length <= 4 && tags.length <= 16 ) {
			xml.onStartTag[tag] = (ElementParser xml)
			{
				ConfigArray data1;
				/* Since we don't know the # of attrs/tags, just grab as many as possible and let error RangeViolation die silently */
				try { 
					data1.attributes[attributes[0]] = xml.tag.attr[attributes[0]];
					data1.attributes[attributes[1]] = xml.tag.attr[attributes[1]];
					data1.attributes[attributes[2]] = xml.tag.attr[attributes[2]];
					data1.attributes[attributes[3]] = xml.tag.attr[attributes[3]];
					} catch ( Error err) {}
					
				try { 
					xml.onEndTag[tags[0]]	= (in Element e) { data1.tags[tags[0]]	= e.text(); };			
					xml.onEndTag[tags[1]]   = (in Element e) { data1.tags[tags[1]]   = e.text(); };	
					xml.onEndTag[tags[2]]   = (in Element e) { data1.tags[tags[2]]   = e.text(); };					
					xml.onEndTag[tags[3]]   = (in Element e) { data1.tags[tags[3]]   = e.text(); };			
					xml.onEndTag[tags[4]]   = (in Element e) { data1.tags[tags[4]]   = e.text(); };			
					xml.onEndTag[tags[5]]   = (in Element e) { data1.tags[tags[5]]   = e.text(); };			
					xml.onEndTag[tags[6]]   = (in Element e) { data1.tags[tags[6]]   = e.text(); };			
					xml.onEndTag[tags[7]]   = (in Element e) { data1.tags[tags[7]]   = e.text(); };			
					xml.onEndTag[tags[8]]   = (in Element e) { data1.tags[tags[8]]   = e.text(); };			
					xml.onEndTag[tags[9]]   = (in Element e) { data1.tags[tags[9]]   = e.text(); };			
					xml.onEndTag[tags[10]]   = (in Element e) { data1.tags[tags[10]]   = e.text(); };			
					xml.onEndTag[tags[11]]   = (in Element e) { data1.tags[tags[11]]   = e.text(); };			
					xml.onEndTag[tags[12]]   = (in Element e) { data1.tags[tags[12]]   = e.text(); };			
					xml.onEndTag[tags[13]]   = (in Element e) { data1.tags[tags[13]]   = e.text(); };			
					xml.onEndTag[tags[14]]   = (in Element e) { data1.tags[tags[14]]   = e.text(); };			
					xml.onEndTag[tags[15]]   = (in Element e) { data1.tags[tags[15]]   = e.text(); };
				} catch ( Error err ) {}
				
				xml.parse();
				
				/* Use tagID or attributeID. Default is attribute id */
				if ( useTagForID ) { 
					all[data1.tags[tags[id]]] = data1;
				} else { 
					all[data1.attributes[attributes[id]]] = data1;
				}
			};
			
			xml.parse();
		}
				
		return all;
	}
}
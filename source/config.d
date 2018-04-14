module Main.Configuration;

import std.xml, std.stdio, std.string, std.conv, std.file;
import Compiler.Tools;

struct ConfigArray {
	string[string] attributes, tags;
	}

class Config { 
	public static bool initialized;
	public static ConfigArray[string] meta;
	public static ConfigArray[string] settings;
	
	/** 
	 * Initialize all configuration values once upon initialization of class 
	 **/
	this() {
		string XmlData;
		if ( this.initialized != true ) {
			
			/* Ensure that the file exists before proceeding */
			if ( !std.file.exists("./config.xml") ) {
				this.initialized = false;
				writeln("Configuration file does not exist. Try running with -buildconfig.");
			} else { 
				XmlData = cast(string) std.file.read("./config.xml");			
				check(XmlData);
				this.settings	= this.XmlParseArray(XmlData, "Value", 1, [ "id", "name" ], [ "Data", "Bool" ], false);
				this.meta 		= this.XmlParseArray(XmlData, "Meta", 0, [], [ "Name", "Author", "ReleaseDate", "Version" ], true);

				/* Set to true */
				this.initialized = true;
			}
		}
	}
	
	/** 
	 * Never, ever write an XML parser like this. Please. 
	 **/
	private ConfigArray[string] XmlParseArray(string XmlData, string tag, int id, string[] attributes, string[] tags, bool useTagForID = false) {
		ConfigArray[string] all;
		bool higherTag;
		
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
	
	/** 
	 * Write a sample config to config.xml for the program to read from. 
	 **/
	public static void buildConfig() {
		string sampleConfigData = "<!-- sample JASL config file -->
<JASL>
	<!-- Meta: do not change -->
	<Meta>
		<Name>JASL</Name>
		<Version>0</Version>
		<Author>AJ</Author>
		<ReleaseDate>0</ReleaseDate>
	</Meta>
	
	<!-- Settings: feel free to change -->
	<Settings> 
		<Value id=\"0\" name=\"useStrict\">
			<Data>0</Data>
			<Bool>0</Bool>
		</Value>
		<Value id=\"1\" name=\"useMandate\">
			<Data>1</Data>
			<Bool>1</Bool>
		</Value>
	</Settings>
</JASL>";
		try {
			std.file.write("./config.xml", sampleConfigData);
			writeln("New config written to config.xml");
		} catch ( Exception e ) {
			writeln("Config write failed. Please do this manually using data from: github.com/jbolt256/jasl/tree/master/meta/config.default.xml");
		}
	}
}
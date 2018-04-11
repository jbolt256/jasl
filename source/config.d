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
	
	/* Initialize all configuration values once upon initialization of class */
	this() {
		if ( this.initialized != true ) {
			
			if ( !std.file.exists("./config.xml") ) {
				throw new JException("Configuration file does not exist.", 0);
				}
				
			string XmlData = cast(string) std.file.read("./config.xml");
			auto dom = parseDOM(XmlData);
			writeln(dom.children[0]);
			writeln(dom.children[1].children[0]);
			
			/*
			check(s);
				auto doc = new Document(s);
				auto xml = new DocumentParser(s);
				//} catch ( Exception e ) {
				//throw new JException("Unable to load configuration file.", 0);
				//}
			
			/* Generate standard Value datasets 
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
			
			xml.onStartTag["Meta"] = (ElementParser xml)
			{
				ConfigMetaValue meta1;				
				xml.onEndTag["Author"]       	= (in Element e) { meta1.Author      = e.text(); };
				xml.onEndTag["ReleaseDate"]   	= (in Element e) { meta1.ReleaseDate      = e.text(); };				
				xml.onEndTag["Version"]       	= (in Element e) { meta1.Version      = e.text(); };
				
				xml.parse();
				this.meta["all"] = meta1;
			};
			
			xml.parse();
			*/
			
			/* Set to true */
			this.initialized = true;
		}
	}
}
import std.xml, std.stdio, std.string, std.conv, std.file;
import Compiler.Globals, Compiler.Tools;

struct ConfigValue {
	string Id, Name, Data, Bool;
	}
	
class Config { 
	private	static bool initialized;
	public static ConfigValue[string] settings;
	
	/* Initialize all configuration values once upon initialization of class */
	this() {
		if ( this.initialized != true ) {
			
			if ( !std.file.exists("./config.xml") ) {
				throw new JException("Configuration file does not exist.", 0);
				}
				
			//try { 
				string s = cast(string) std.file.read("./config.xml");
				check(s);
				auto doc = new Document(s);
				auto xml = new DocumentParser(s);
				//} catch ( Exception e ) {
				//throw new JException("Unable to load configuration file.", 0);
				//}
			
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
			
			/* Set to true */
			this.initialized = true;
			
			writeln(this.settings["useStrict"].Data);
		}
	}
}
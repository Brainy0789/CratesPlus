package backend;

import backend.Paths;

#if (desktop)
import Sys;
#end

#if (html5)
import js.Browser;
#end

class Web {
    static public function openWebPage(page:String)
    {
        #if (mac)
        Sys.command("open", [Paths.PAGES + page]);
        #end
        #if (linux)
        Sys.command("xdg-open", [Paths.PAGES + page]);
        #end
        #if (windows)
        Sys.command("cmd", ["/c", "start", "", Paths.PAGES + page]);
        #end
        #if (html5)
        Browser.window.open(Paths.PAGES + page, "_blank");
        #end

    }
}
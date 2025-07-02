package states;

import Sys;
import flixel.FlxState;
import haxe.io.Path;
import webview.WebView;



class WebViewState extends FlxState {
    
    var webview:WebView;
    var htmlPath:String;

    override public function new(page:String):Void {
        super();
        this.webview = new WebView();
        this.htmlPath = Path.normalize(Sys.getCwd() + "/assets/data/pages/" + page);
    }

    override public function create():Void {
        this.webview.navigate("file://" + this.htmlPath);
        this.webview.setTitle("Crates Classic");
        this.webview.setSize(1280, 720, WebViewSizeHint.NONE);
        this.webview.run(); // This will block forever (until window closes)
        Sys.exit(0); // Optional cleanup after WebView closes
    }
}
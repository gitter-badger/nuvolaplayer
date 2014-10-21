/*
 * Copyright 2014 Jiří Janoušek <janousek.jiri@gmail.com>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer. 
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution. 
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

namespace Nuvola
{

const string FLASH_DETECT_HTML = """<!DOCTYPE html
<html>
<head>
<meta charset="utf-8" />
<script src="./flash_detect.js"></script>
<style type="text/css">
body, html {margin: 0px; padding: 0px;}
p {margin: 0px; padding: 10px;}
</style>
</head>
<body>
<script type="text/javascript">
document.write("<p>" + (FlashDetect.installed
? (FlashDetect.raw + " is the active Flash plugin.")
: "<p>No Flash plugin has been loaded.</p>"
)+ "</p>");
</script>
</body>
</html>
""";

public class FormatSupportDialog: Gtk.Dialog
{
	public FormatSupport format_support {get; construct;}
	public Diorite.Storage storage {get; construct;}
	
	public FormatSupportDialog(FormatSupport format_support, Diorite.Storage storage, Gtk.Window? parent)
	{
		GLib.Object(title: "Format Support", transient_for: parent, format_support: format_support, storage: storage);
		add_button("_Close", Gtk.ResponseType.CLOSE);
		set_default_size(700, 450);
		
		var notebook = new Gtk.Notebook();
		notebook.margin = 10;
		var plugins_view = new Gtk.Grid();
		plugins_view.orientation = Gtk.Orientation.VERTICAL;
		var scrolled_window = new Gtk.ScrolledWindow(null, null);
		scrolled_window.add(plugins_view);
		scrolled_window.expand = true;
		scrolled_window.margin = 10;
		scrolled_window.show();
		
		var frame = new Gtk.Frame ("<b>Flash plugins</b>");
		(frame.label_widget as Gtk.Label).use_markup = true;
		frame.margin = 10;
		var flash_plugins_grid = new Gtk.Grid();
		flash_plugins_grid.orientation = Gtk.Orientation.VERTICAL;
		flash_plugins_grid.margin = 10;
		frame.add(flash_plugins_grid);
		plugins_view.add(frame);
		frame.show();
		
		var flash_detect = storage.get_data_file("js/flash_detect.js");
		if (flash_detect != null)
		{
			frame = new Gtk.Frame ("<b>Active Flash plugin</b>");
			(frame.label_widget as Gtk.Label).use_markup = true;
			frame.margin = 10;
			var web_view = new WebKit.WebView();
			frame.add(web_view);
			web_view.set_size_request(-1, 50);
			web_view.show();
			web_view.load_html(FLASH_DETECT_HTML, flash_detect.get_uri() + ".html"); 
			plugins_view.add(frame);
			frame.show();
		}
		
		frame = new Gtk.Frame ("<b>Other plugins</b>");
		(frame.label_widget as Gtk.Label).use_markup = true;
		frame.margin = 10;
		var other_plugins_grid = new Gtk.Grid();
		other_plugins_grid.orientation = Gtk.Orientation.VERTICAL;
		other_plugins_grid.margin = 10;
		frame.add(other_plugins_grid);
		plugins_view.add(frame);
		frame.show();
		
		Gtk.Label label = null;
		unowned List<WebPlugin?> plugins = format_support.list_web_plugins();
		foreach (unowned WebPlugin plugin in plugins)
		{
			unowned Gtk.Grid grid = plugin.is_flash ? flash_plugins_grid : other_plugins_grid;
			if (grid.get_child_at(0, 0) != null)
				grid.add(new Gtk.Separator(Gtk.Orientation.HORIZONTAL));
			
			label = new Gtk.Label(Markup.printf_escaped(
				"<b>%s</b> (%s)", plugin.name, plugin.enabled ? "enabled" : "disabled"));
			label.use_markup = true;
			label.set_line_wrap(true);
			label.margin_top = 5;
			label.hexpand = true;
			grid.add(label);
			label = new Gtk.Label(plugin.path);
			label.set_line_wrap(true);
			label.hexpand = true;
			grid.add(label);
			label = new Gtk.Label(plugin.description);
			label.set_line_wrap(true);
			label.hexpand = true;
			label.justify = Gtk.Justification.FILL;
			label.margin_bottom = 5;
			grid.add(label);
			grid.show_all();
		}
		
		if (format_support.n_flash_plugins != 1)
		{
			var info_bar = new Gtk.InfoBar();
			info_bar.get_content_area().add(new Gtk.Label(format_support.n_flash_plugins == 0
			? "No Flash plugins have been found."
			: "Too many Flash plugins have been found, wrong version may have been used."));
			info_bar.margin = 10;
			info_bar.show_all();
			plugins_view.attach_next_to(info_bar, flash_plugins_grid.get_parent(), Gtk.PositionType.TOP, 1, 1);
		}
		
		if (flash_plugins_grid.get_children() == null)
			flash_plugins_grid.get_parent().hide();
		if (other_plugins_grid.get_children() == null)
			other_plugins_grid.get_parent().hide();
		
		plugins_view.show();
		notebook.append_page(scrolled_window, new Gtk.Label("Web Plugins"));
		notebook.show();
		get_content_area().add(notebook);
	}
}

} // namespace Nuvola

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

public class WebAppWindow : Diorite.ApplicationWindow
{
	public Gtk.Grid grid {get; private set;}
	public Gtk.Overlay overlay {get; private set;}
	public Sidebar sidebar {get; private set;}
	
	public int sidebar_position
	{
		get
		{
			return paned.position;
		}
		
		set
		{
			if (value == -1)
			{
				if (sidebar.visible)
				{
					Gtk.Allocation allocation;
					int width = 0;
					paned.get_allocation(out allocation);
					sidebar.get_preferred_width(out width, null);
					paned.position = allocation.width - width;
				}
			}
			else if (paned.position != value)
			{
				paned.position = value;
			}
		}
	}
	
	public bool maximized {get; private set; default = false;}
	private Gtk.Paned paned;
	
	private uint sidebar_position_cb_id = 0;
	
	private AppRunnerController app;
	
	public WebAppWindow(AppRunnerController app)
	{
		base(app, true);
		window_state_event.connect(on_window_state_event);
		title = app.app_name;
		try
		{
			icon = Gtk.IconTheme.get_default().load_icon(app.icon, 48, 0);
		}
		catch (Error e)
		{
			warning("Unable to load application icon.");
		}
		set_default_size(500, 500);
		
		delete_event.connect(on_delete_event);
		
		this.app = app;
		
		grid = new Gtk.Grid();
		grid.orientation = Gtk.Orientation.VERTICAL;
		overlay = new Gtk.Overlay();
		overlay.add(grid);
		overlay.show_all();
		sidebar = new Sidebar();
		paned = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);
		paned.pack1(overlay, true, false);
		paned.pack2(sidebar, false, false);
		paned.notify["position"].connect_after(on_sidebar_position_changed);
		paned.show();
		
		top_grid.add(paned);
	}
	
	public signal void can_destroy(ref bool result);
	
	public void show_overlay_alert(string text)
	{
		var loop = new MainLoop();
		var title = new Gtk.Label(Markup.printf_escaped("<b>%s</b>", "Web App Alert"));
		title.use_markup = true;
		var body = new Gtk.Label(text);
		body.halign = Gtk.Align.START;
		body.yalign = body.xalign = 0.0f;
		body.set_line_wrap(true);
		var close_button = new Gtk.Button.with_label("Close");
		close_button.hexpand = false;
		close_button.clicked.connect(() => loop.quit());
		var grid = new Gtk.Grid();
		grid.margin = grid.row_spacing = 12;
		grid.orientation = Gtk.Orientation.VERTICAL;
		grid.valign = grid.halign = Gtk.Align.CENTER;
		grid.add(title);
		grid.add(body);
		grid.add(close_button);
		
		var outer_box = new Gtk.EventBox();
		outer_box.vexpand = outer_box.hexpand = true;
		outer_box.valign = outer_box.halign = Gtk.Align.FILL;
		outer_box.override_background_color(Gtk.StateFlags.NORMAL, {0.0, 0.0, 0.0, 0.5});
		
		var inner_box = new Gtk.EventBox();
		inner_box.valign = inner_box.halign = Gtk.Align.CENTER;
		var color = get_style_context().get_background_color(Gtk.StateFlags.NORMAL);
		inner_box.override_background_color(Gtk.StateFlags.NORMAL, color);
		
		outer_box.add(inner_box);
		inner_box.add(grid);
		outer_box.show_all();
		overlay.add_overlay(outer_box);
		loop.run();
		overlay.remove(outer_box);
	}
	
	public bool on_delete_event(Gdk.EventAny event)
	{
		hide();
		bool result = true;
		can_destroy(ref result);
		return !result;
	}
	
	private bool on_window_state_event(Gdk.EventWindowState event)
	{
		maximized = (event.new_window_state & Gdk.WindowState.MAXIMIZED) != 0;
		return false;
	}
	
	private void on_sidebar_position_changed(GLib.Object o, ParamSpec p)
	{
		if (sidebar_position_cb_id != 0)
			Source.remove(sidebar_position_cb_id);
		sidebar_position_cb_id = Timeout.add(250, sidebar_position_cb);
	}
	
	private bool sidebar_position_cb()
	{
		debug("Sidebar position: %d", paned.position);
		sidebar_position_cb_id = 0;
		sidebar_position = paned.position;
		return false;
	}
}

} // namespace Nuvola

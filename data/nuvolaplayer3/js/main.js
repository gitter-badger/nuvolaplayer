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

(function(Nuvola)
{

Nuvola.makeSignaling = function(obj_proto)
{
	obj_proto.registerSignals = function(signals)
	{
		if (this.signals === undefined)
			this.signals = {};
		
		var size = signals.length;
		for (var i = 0; i < size; i++)
		{
			this.signals[signals[i]] = [];
		}
	}
	
	obj_proto.connect = function(name, object, handlerName)
	{
		var handlers = this.signals[name];
		if (handlers === undefined)
			throw new Error("Unknown signal '" + name + "'.");
		handlers.push([object, handlerName]);
	}
	
	obj_proto.disconnect = function(name, object, handlerName)
	{
		var handlers = this.signals[name];
		if (handlers === undefined)
			throw new Error("Unknown signal '" + name + "'.");
		var size = handlers.length;
		for (var i = 0; i < size; i++)
		{
			var handler = handlers[i];
			if (handler[0] === object && handler[1] === handlerName)
			{
				handlers.splice(i, 1);
				break;
			}
		}
	}
	
	obj_proto.emit = function(name)
	{
		var handlers = this.signals[name];
		if (handlers === undefined)
			throw new Error("Unknown signal '" + name + "'.");
		var size = handlers.length;
		var args = [this];
		for (var i = 1; i < arguments.length; i++)
			args.push(arguments[i]);
		
		for (var i = 0; i < size; i++)
		{
			var handler = handlers[i];
			var object = handler[0];
			object[handler[1]].apply(object, args);
		}
	}
}

Nuvola.makeSignaling(Nuvola);
Nuvola.registerSignals(["home-page"]);

Nuvola.Notification =
{
	update: function(title, text, iconName, iconURL)
	{
		Nuvola.sendMessage("Nuvola.Notification.update", title, text, iconName || "", iconURL || "");
	},
	
	show: function()
	{
		Nuvola.sendMessage("Nuvola.Notification.show");
	},
}

Nuvola.TrayIcon =
{
	setTooltip: function(tooltip)
	{
		Nuvola.sendMessage("Nuvola.TrayIcon.setTooltip", tooltip || "");
	},
	
	setActions: function(actions)
	{
		Nuvola.sendMessage("Nuvola.TrayIcon.setActions", actions);
	},
}

Nuvola.Actions =
{
	addAction: function(group, scope, name, label, mnemo_label, icon, keybinding)
	{
		Nuvola.sendMessage("Nuvola.Actions.addAction", group, scope, name, label || "", mnemo_label || "", icon || "", keybinding || "");
	},
	
	debug: function(arg1, arg2)
	{
		console.log(arg1 + ", " + arg2);
	}
}

Nuvola.makeSignaling(Nuvola.Actions);
Nuvola.Actions.registerSignals(["action-activated"]);
Nuvola.Actions.connect("action-activated", Nuvola.Actions, "debug");


})(this);  // function(Nuvola)

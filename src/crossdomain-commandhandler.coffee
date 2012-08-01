# Base class to enable a JS-object to have event listeners and dispatch events
class EventObject
	listeners = {}

	addEventListener: (eventName, callback) ->
		if not listeners[eventName]?
			listeners[eventName] = []

		listeners[eventName].push(callback)		

	removeEventListener: (eventName, callback) ->
		callbacks = listeners[eventName]
		
		if callbacks? and -1 < callbacks.indexOf(callback)
			callbacks.splice callbacks.indexOf(callback), 1

	dispatchEvent: (eventName, args) ->
		
		if not args? 
			args = []
		else if args not instanceof Array # Callback apply only accept arrays as an argument.
			args = [args]

		while args[0] instanceof Array and args.length is 1 # not totally sure about this one, I liked it though, if arrays are nested and only contains 1 array, it keeps unwrapping until it finds the innermost array.
			args = args[0]

		if listeners[eventName]?
			for callback in listeners[eventName]
				try				
					callback.apply null, args 
				catch error
			  		throw "EventObject error: Failed to call apply on callback, check your listeners. \n\n callback function: #{ callback } \n\n error: #{ error }"

# Class to simplify postMessage communcation.
class window.CrossDomainCommandHandler extends EventObject	
	isJson = (obj) ->
		try
		  	JSON.parse(obj);
		  	yes
		catch error
			no

	constructor: (target) ->
		@target = target			
		
		window.addEventListener "message", @handleIncomingCommand.bind(this), false

	handleIncomingCommand: (event) ->
		if (!isJson(event.data))		
			return		

		commandJSON = JSON.parse event.data

		returnData = @dispatchEvent commandJSON.commandName, commandJSON.args
		
		if commandJSON.callbackCommandName?						
			@postCommand commandJSON.callbackCommandName, null, returnData

	postCommand: (commandName, callbackCommandName, args) ->
		if args not instanceof Array
			args = [args]
		
		command = {
			commandName: commandName
			callbackCommandName: callbackCommandName
			args: args
		}

		message = JSON.stringify command
		@target.postMessage message, "*"
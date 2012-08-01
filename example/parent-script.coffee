window.onload = ->
	targetWindow = window.frames["client-frame"]		
	commandHandler = new CrossDomainCommandHandler targetWindow
	commandHandler.addEventListener "testCall", recieveMessage		

recieveMessage = (message) -> 
	messageElement = document.getElementById "message-output"
	messageElement.innerHTML = message	

	["This is the server answer, I recieved message: #{message}", "second argument"] # The return value will be sent back to the client
window.onload = ->
	targetWindow = window.parent
	commandHandler = new CrossDomainCommandHandler targetWindow
	commandHandler.addEventListener "testCallback", handleCallbackFromServer
	commandHandler.postCommand "testCall", "testCallback", "Message from client"

handleCallbackFromServer = (message, secondArgument) -> 
	messageElement = document.getElementById "message-output"
	messageElement.innerHTML = message	
	
	console.log secondArgument
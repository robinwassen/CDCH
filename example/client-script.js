// Generated by CoffeeScript 1.3.3
(function() {
  var handleCallbackFromServer;

  window.onload = function() {
    var commandHandler, targetWindow;
    targetWindow = window.parent;
    commandHandler = new CrossDomainCommandHandler(targetWindow);
    commandHandler.addEventListener("testCallback", handleCallbackFromServer);
    return commandHandler.postCommand("testCall", "testCallback", "Message from client");
  };

  handleCallbackFromServer = function(message, secondArgument) {
    var messageElement;
    messageElement = document.getElementById("message-output");
    messageElement.innerHTML = message;
    return console.log(secondArgument);
  };

}).call(this);

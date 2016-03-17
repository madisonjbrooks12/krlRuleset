ruleset echo {
  meta {
    name "Echo"
    description <<
A ruleset for part 1 of Reactive Programming lab
>>
    author "Madison Brooks"
    logging on
    sharing on
    
  }
  global {
    
  }
  rule hello {
    select when echo hello
    send_directive("say") with
      something = "Hello World";
  }
  rule message {
    select when echo message
    pre {
      input = event:attr("input").klog("our passed-in input: ");
    }
    {
      send_directive("say") with
        something = "#{input}";
    }
    always {
      log ("LOG says " + input);
    }
  }
}

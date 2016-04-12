ruleset manage_fleet {
  meta {
    name "Manage Fleet"
    description <<
Manages a fleet of child pico vehicles
>>
    author "Madison Brooks"
    logging on
    sharing on
    use module b507199x5 alias wrangler_api
    provides vehicles
  }
  global {
    vehicles = function() {
      results = wrangler_api:subscriptions();
      subscriptions = results{"subscriptions"};
      subscriptions
    };
  }
  rule create_vehicle {
    select when car new_vehicle
    pre {
      child_name = "Vehicle" + event:attr("name");
      child_attributes = {}
        .put(["Prototype_rids"],"b507732x2.prod")
        .put(["name"],child_name)
        .put(["parent_eci"],"EDA10298-00FC-11E6-AA08-EA9BE71C24E1");
    }
    {
      noop();
    }
    always {
      raise wrangler event "child_creation"
      attributes child_attributes.klog("attributes: ");
      log("create child for " + child_name);
    }
  }
  rule vehicleToFleet {
    select when wrangler init_events
    pre {
      attrs = {}
        .put(["name"],"vehicle_sub")
        .put(["name_space"], "Vehicle_Subscriptions")
        .put(["my_role"], "vehicle")
        .put(["your_role"], "fleet")
        .put(["target_eci"], "EDA10298-00FC-11E6-AA08-EA9BE71C24E1".klog("target ECI: "))
        .put(["channel_type"], "Parent_Pico")
        .put(["attrs"], "success");
    }
    {
      noop();
    }
    always {
      raise wrangler event "subscription"
      attributes attrs;
    }
  }
  rule autoAccept {
    select when wrangler inbound_pending_subscription_added
    pre {
      attributes = event:attrs().klog("subscription: ");
    }
    {
      noop();
    }
    always {
      raise wrangler event "pending_subscription_approval"
      attributes attributes;
      log("auto accepted subscription.");
    }
  }
  rule delete_vehicle {
    select when car unneeded
    pre {
      channel_name = event:attr("channel_name").klog("channel_name: ");
    }
    {
      noop();
    }
    always {
      raise wrangler event "subscription_cancellation"
      attributes event:attrs();
      log("child subscription deleted");
    }
  }
}

ruleset track_trips {
  meta {
    name "Track Trips"
    description <<
Second ruleset for part 1 of Reactive Programming lab
>>
    author "Madison Brooks"
    logging on
    sharing on
  }
  global {
    long_trip = 200;
  }
  rule process_trip {
    select when car new_trip
    pre {
      mileage = event:attr("mileage").klog("our passed in mileage: ");
    }
    {
      send_directive("trip") with
        trip_length = mileage;
    }
    always {
      raise explicit event 'trip_processed'
        attributes event:attrs();
      log ("LOG says " + mileage);
    }
  }
  rule find_long_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").klog("find_long_trips mileage: ");
      mileage_num = mileage.as("num");
    }
    if (mileage_num > long_trip) then {
      send_directive("say") with
        something = "Mileage large enough to be long trip";
    }
    fired {
      log ("LOG raising event found_long_trip");
      raise explicit event 'found_long_trip';
    }
    else {
      log ("LOG says mileage not long enough for a long trip");
    }
  }
}

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
        attributes mileage;
      log ("LOG says " + mileage);
    }
  }
  rule find_long_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").klog("find_long_trips mileage: ");
    }
    if (mileage > long_trip) then {
      log ("LOG raising explicit event found_long_trip");
    }
    fired {
      raise explicit event 'found_long_trip';
    }
    else {
      log ("LOG mileage not long enough for a long trip");
    }
  }
}

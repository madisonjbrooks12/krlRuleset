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
      log ("LOG says " + mileage);
    }
  }
}

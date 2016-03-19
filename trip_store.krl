ruleset trip_store {
  meta {
    name "Trip Store"
    description <<
A rulset which stores trip information
>>
    author "Madison Brooks"
    logging on
    sharing on
    provides all_trips
    provides long_trips
  }
  global {
    all_trips = function() {
      all_trips = ent:trips;
      all_trips
    };
    long_trips = function() {
      long = ent:long;
      long
    };
  }
  rule collect_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").klog("our passed in mileage from collect_trips: ");
      timestamp = time:now();
      timestamp_str = timestamp.as("str");
      init = {"_0": {
                    "mileage" : "0"
                    }
              };
      new_trip = {
                  "mileage" : mileage
                  };
    }
    {
      send_directive("collect") with
      passed_mileage = mileage and
      time_now = timestamp_str;
    }
    always {
      set ent:trips init if not ent:trips{["_0"]};
      set ent:trips{[timestamp_str]} new_trip;
    }
  }
  rule collect_long_trips {
    select when explicit found_long_trip
    pre {
      mileage = event:attr("mileage").klog("our passed in mileage from collect_long_trips: ");
      timestamp = time:now();
      timestamp_str = timestamp.as("str");
      init = {"_0": {
                    "mileage" : "0"
                    }
              };
      new_trip = {
                  "mileage" : mileage
                  };
    }
    {
      send_directive("collect_long") with
      passed_mileage = mileage and
      time_now = timestamp_str;
    }
    always {
      set ent:long init if not ent:long{["_0"]};
      set ent:long{[timestamp_str]} new_trip;
    }
  }
}

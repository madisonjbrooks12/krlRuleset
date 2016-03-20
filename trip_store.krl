ruleset trip_store {
  meta {
    name "Trip Store"
    description <<
A rulset which stores trip information
>>
    author "Madison Brooks"
    logging on
    sharing on
    provides trips
    provides long_trips
    provides short_trips
  }
  global {
    trips = function() {
      trips = ent:trips;
      trips
    };
    long_trips = function() {
      long = ent:long;
      long
    };
    short_trips = function() {
      all = ent:trips;
      long = ent:long;
      short = all.difference(long);
      short
    };
  }
  rule collect_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").klog("our passed in mileage from collect_trips: ");
      timestamp = time:now();
      timestamp_str = timestamp.as("str");
      init = {"_0" : {
                    "mileage" : "0"
                    }
              };
      new_trip = [{
                  "timestamp" : timestamp_str,
                  "mileage" : mileage
                  }];
      trips = trips();
    }
    {
      send_directive("collect") with
      passed_mileage = mileage and
      time_now = timestamp_str;
    }
    always {
      set ent:trips trips.append(new_trip);
    }
  }
  rule collect_long_trips {
    select when explicit found_long_trip
    pre {
      mileage = event:attr("mileage").klog("our passed in mileage from collect_long_trips: ");
      timestamp = time:now();
      timestamp_str = timestamp.as("str");
      init = {"_0" : {
                    "mileage" : "0"
                    }
              };
      new_trip = [{
                  "timestamp" : timestamp_str,
                  "mileage" : mileage
                  }];
      long = long_trips();
    }
    {
      send_directive("collect_long") with
      passed_mileage = mileage and
      time_now = timestamp_str;
    }
    always {
      set ent:long long.append(new_trip);
    }
  }
  rule clear_trips {
    select when car trip_reset
    pre {
      init = {"_0" : {
                    "mileage" : "0"
                    }
              };
    }
    always {
      set ent:trips [];
      set ent:long [];
    }
  }
}

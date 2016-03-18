ruleset trip_store {
  meta {
    name "Trip Store"
    description <<
A rulset which stores trip information
>>
    author "Madison Brooks"
    logging on
    sharing on
  }
  global {
  }
  rule collect_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").klog("our passed in mileage from collect_trips: ");
      timestamp = time:now();
      init = {"_0": {
                    "mileage":"0",
                    "timestamp":"0"}
              }
    }
    {
      send_directive("collect_trips") with
      passed_mileage = mileage and
      time_now = timestamp;
    }
    always {
      set ent:trips init if not ent:trips{

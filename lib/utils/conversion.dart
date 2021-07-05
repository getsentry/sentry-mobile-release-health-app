DateTime? dateTimeFromString(String dateString) => DateTime.parse(dateString);
String? dateTimeToString(DateTime? dateTime) => dateTime
    ?.toIso8601String(); // probably won't be used, but if it ever is do check if this is the right format.

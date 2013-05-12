component 
{
	public function GetEpochTime( datetime ) {
	    return int(DateDiff("s", "January 1 1970 00:00", datetime));
	}
		
	public function GetTimeFromEpoch( epoch ) {
	    return dateAdd("s", epoch, "january 1 1970 00:00:00");
	}
}
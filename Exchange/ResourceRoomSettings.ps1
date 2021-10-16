$CalendarArgs = @{
    Identity = "ChasHealthGroupVideoVisitRoomB"
    DeleteAttachments = $false
    DeleteComments = $false
    DeleteSubject = $false
    DeleteNonCalendarItems = $false
    ProcessExternalMeetingMessages = $True
    BookingWindowInDays = "365"
}

Set-CalendarProcessing  $CalendarArgs


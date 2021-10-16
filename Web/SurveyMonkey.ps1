$url = "https://www.surveymonkey.com/r/28W8SGX"
$ie = New-Object -com "InternetExplorer.Application"

$ie.navigate("$url")
$ie.Visible = $true
sleep 2

$doc = $ie.document

$radio = $doc.GetElementbyID("449134819_2975893285_label")
$firstName = $doc.getElementbyID("449140633")
$lastName = $doc.getElementbyID("449173633")
$location = $doc.getElementbyID("451288606")
$enter= $doc.getElementsByTagName("button")


$radio.ariaChecked = $True
$radio.ClassName = "answer-label radio-button-label no-touch touch-sensitive clearfix checked"


$firstName.Value = "Tyler"
$lastName.Value = "Hemingsen"
$location.value = 2989487200





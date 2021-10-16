#Disables the Laptop Integrated Camera - the Monitor Camera is also named Integrated Webcam but is under the class of Image so this shouldn't affect it
#Need to test on more TH carts.
Get-PnPDevice -class Camera | Where-Object FriendlyName -notlike "DELL*"| Disable-PnPDevice -Confirm:$False
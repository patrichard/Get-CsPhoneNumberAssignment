One of the problems that can be truly maddening when troubleshooting issues is a 485 ‘ambiguous’ error in Snooper. This is when Skype for Business doesn’t know what to do with an inbound call because the number being called is configured in more than one place. Skype for Business will complain if you try to configure a number more that once in SOME areas, such as several users, but not in all areas. So you’re left with hunting around for a while to figure out where else the number is defined. Meanwhile, users are complaining that calls aren’t working. So I came up with a quick function that will look through all of the areas that a number can be defined, and will list all matches.

Yes, I know that others have done similar things, notably Tom Arbuthnot’s Get-LyncNumberAssignment :Find #Lync Users/Objects by Phone Number/LineURI #PowerShell and Amanda Debler’s Is that Skype for Business (Lync) Number Free?, as well as other phone number management solutions such as those by Stale Hansen and Lasse Nordvik Wedø. I’ve had a previous version of my script in my profile for a long time and decided to clean it up and make it available.

Is that Skype for Business (Lync) Number Free?

This PowerShell function will look for a full or partial number to see where it is allocated. It looks at the following:

    User LineUri
    User PrivateLine
    Meeting Room LineUri
    Meeting Room PrivateLine
    Analog Devices
    Common Area Phones
    Unified Messaging (UM) Contacts
    Dial-In Conferencing Access Numbers
    Trusted Application Numbers
    Response Group Numbers
    Hybrid Application numbers

The function accepts input via the named LineUri parameter, or via pipeline. It returns a typical PowerShell object. Here is an example of specifying a full e.164 number.

Get-CsPhoneNumberAssignment -LineUri 12145551212

Specifying a partial number will likely show more matches.

Get-CsPhoneNumberAssignment -LineUri 1214

Note that since it must look at all of the related objects in order to build the object, it can take a minute or so to complete.

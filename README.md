# Autonomy


## Introduction (Why?)

This project contains simple bash scripts and subnet lists used to implement blocks against specific organizations.

By default these are included:

- Google (Includes Youtube,blogspot,doubleclick and any other google service under their AS)
- Facebook (Includes Instagram,whatsapp and other facebook companies)
- Twitter
- Linkedin
- Cloudflare

A powershell script is also included which uses the RIPE Stat API (much better) as opposed to route servers and places windows firewall rule blocks for the subnets in question. 


## Instructions

1. clone this repository or download and extract the zip file for it. 

2. Run 'cd autonomy' 

3. Run 'chmod a+x ./block.sh'

4. Run './block.sh' and follow the instructions. 

P.S.: These instructions are meant for those who are new to *nix or are not comfortable with the command line yet. 

### ASN2IP.sh
 This is just a script that logs into route-server.ip.att.net and fetches all subnets associated with the selected Autonomous System Number.
 
 Without arguments it will echo (list) all the subnets.
 if -b is specified it will implement an iptables block for each subnet found.
 
 Optionally you can specify the ASN and it will operate on it accordingly. 
 
 Examples:

> 	#blocks google by default 
> 	./asn2ip.sh 	
>      #NTT
>        ./asn2ip 1294 
> 	#Microsoft 	
>        ./asn2ip -b 8068

### asnblock.ps1 Usage
You'll probably need to set the right execution policy and run 'Unblock-Script .\asnblock.ps1' to allow a remotely fetched script to run.

Example commands:

- `.\asnblackhole.ps1 -ASN 15169 -V4 -V6 -Type Both`
- `.\asnblackhole.ps1 -ASN 15169 -V4 -V6 -Type Both -Unblock`
- `.\asnblackhole.ps1 -ASN 15169 -V4  -Type Originating`	

### Fine tuning Firefox
 1. Type 'about:config' in the navigation bar (accept if it wars you that your warranty will be 'void')
 2. Search for 'network.http.connection-timeout' and 'network.http.response.timeout' set both to 5 (this is in seconds, adjust as needed,don't set it under 3

 

### Fine tuning Google Chrome
 I haven't tasted these instructions,not so surprisingly google refuses to implement the same adjustable options firefox has.
 
 However someone here claims InternetExplorer settings affect chrome as well: https://superuser.com/questions/633648/how-can-i-change-the-default-website-connection-timeout-in-chrome
 
 I have pasted their instructions below(again,untested):
 
1. Click Start, click Run, type regedit, and then click OK.

2. Locate and then click the following key in the registry: HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\InternetSettings

3. On the Edit menu, point to New, and then click DWORD Value.

4. Type "KeepAliveTimeout", and then press ENTER.

5. On the Edit menu, click Modify.

6. Type the appropriate time-out value (in milliseconds), and then click OK. For example, to set the time-out value to two minutes, type 120000.

7. Type "ServerInfoTimeout" and set too.

8. Restart machine.

# Contact

Pop in ##hackers on freenode , I will see any questions or comments when I'm around and respond(no dedicated channel for this project yet)

Feel free to open a github issue or Pull request as well. 

If you feel like more organizations or AS' should be added,please let me know. 


# Propaganda

The widespread and hard to avoid nature of the sites and services these organizations offer
poses a privacy concern for some individuals. 

This project is a small attempt to prevent network connections to IP addresses controlled by these organizations.

Sites controlled by these organizations obviously won't work when their respective blocks are in place. In addition to that, many other unrelated poorly designed and developed websites will break or not work at all when these services are blocked. 

Autonomy is the most foundational principle of the internet. 
Lack of it means the internet is no longer a decentralized network;
it's functionality (as seen on the world wide web today) becomes crippled when one or very few Autonomous systems are removed from the picture. 

As you may already know, all of these organizations are in the same country and most if not all of them are based around the same state and general geographic area. This is not to say they don't have
geographical redundancy by design, but should their state,nation or the organizations themselves decide to censor any individual,organization or nation that individual,organization or nation will not be able to access a large portion of the internet,even if the resource they are attempting to access has no direct relation 
with the organizations listed above. 

As a secondary concern, these organizations actively engage in tracking users across websites and browsing sessions.
Often without direct consent(even when consent is available,declining means their refusal to offer services to the user),
Most users have little to null knowledge about data-mining and the dramatic effect it can have, not just on them but on their society and communities. Historically, those who have power keep and use it for themselves,the powerful nature of mass surveillance and unrestrained documentation of people is a serious risk to the people against whom such information can be used.

Many fears alluded to paranoia (with respect to corporate and government surveillance) have left even the most creative conspiracy theorists surprised when revealed to be true. Therefore concern over these few corporations using the data they collect against their users to a harmful end is not paranoia but a legitimate concern everyone depending on the internet should have. 


> "We learn from history that we do not learn from history."
> 
> - George Wilhelm Friedrich Hegel

Privacy is a basic and fundamental human liberty. We don't put on cloth because we have something bad to hide.
We don't use the restroom behind closed doors because we're hiding something harmful to others. Humans have always engaged in private activities with the implicit expectation those moments are hidden from others. 

This is a matter of basic dignity. 

Should everything be a secret? obviously not. 
What should be public and what should be private then? I don't know,depends on your political views(which I don't care to address here)
But there is one thing all humans should(and hopefully would) agree on, ***everything*** shouldn't be public. To revoke the privacy of all is the same as to relieve them of their dignity and liberty as an individual. 

If you're reading this, you probably agree on most of what I have said so far. All in all, the goal here is not to punish these companies
or some how cause them harm(or accuse them of malicious intentions).

 The goal is to somewhat improve privacy for users and hopefully when people see how dependent the internet is on these few organizations, they will start rethinking how they are developing their websites and services. Maybe things will change, I hope they do. 


----------

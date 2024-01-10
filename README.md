# LuaTools
[![Manage your Lua scripts on the go!](https://readme-typing-svg.demolab.com?font=&pause=1000&color=FFF&center=true&vCenter=true&random=true&lines=Manage+your+Lua+scripts+on+the+go!;Comparable+Lua+script+encryptor!;Deobfuscate+Lua+scripts+on+the+go!;It's+Free+%26+Open+source!;Compile+Lua+scripts+with+Lua+itself!+(no+luac);Made+by+ABJ4403;This+has+good+script+container!+(sandbox))](https://git.io/typing-svg)

## Why did i make this?
Just to make my life (maybe yours too) easier. and not having to install other proprietary APKs, executable, or even proprietary decryptor/encryptor that can only do one thing and its worst at the same time (eg: PG Encrypt, but no way to decrypt it in the same place, and vice versa. And also there's lots of proprietary gg Lua script out there. maybe you want to clean its garbage code so it can run faster? or run in in secure isolated environment so you can have a peace of mind knowing the files on your phone wont get removed by malicious `os.remove` API call, or overwriting your files using `io.open/write/read` API call, or executing malicious commands using `os.execute` API, or you don't want your data to get stolen using `gg.makeRequest` API? Maybe you also wanted to encrypt the script in the correct way because you wanted to share a script, but also realized that your script is too much risky to share to public because you don't want bad cheater (aka. the abuser) uses too much out of your script to hurt other online players? Or you need that little extra tiny SPEED by precompiling the source script and removing its hidden garbage code too.

## Features:
+ Simple, no bloat (no blingy nonsense, no fake loading).
+ Free & Open-Source, Licensed under GPL v3.
+ Modable (TODO: better wording??)
+ Basic (De?)Compile, and (Dis)Assemble available (think of it like "pocket" (semi-un)luac).
+ Encryption:
	+ Obfuscation modules (no one has EVER seen this concept):
		+ Script signature & self-promote (optional).
		+ Restrict GameGuardian version, package name, and target application package name.
		+ Expiry date.
		+ Detect Decrypt-related packages.
		+ Detect external modification.
		+ No Rename.
		+ Anti SSTool (a normal function but breaks SSTool).
		+ Obfuscations.
		+ Hook detection.
		+ Password (with optional save hashed password).
		+ Welcome (runs after putting correct password).
		+ AntiLoad (calls load API with bogus function).
		+ NoPeek (Prevent peeking at search values).
		+ Spam Log.
		+ BigLASM (Make disassembled script size extremely big).
		+ "Human verification", useless but who knows someone wants it for "maximum security".
	+ Interchangeable encryption methods (if you know how to code Lua).
	+ Every obfuscation code is containerized, which is great for performance, security, and reduces global variable pollution.
	+ Encrypted API query.
	+ Blazing fast (No fake loading, no arbitrary slowdown, great optimization, local variables).
	. (TODO) Optional Hard-Password requirement (with XOR encryption, we can use the password itself as a decryption key)
	+ Respects both the author & the end user.
+ Decryption:
	+ Deobfuscation patches (again no one has ever seen this):
		+ Remove LASM Block (basically reducing artificially inflated maximum stack size for a function).
		+ Remove Garbage (self-explanatory).
		+ Remove _Code Hider_ (unstable).
		+ Remove blocker (unstable-ish?).
	+ Run script in isolated environment.
		+ Powered by VirtGG.
		+ Protect your device from unwanted script modification (os.execute,os.remove,gg.makeRequest,etc).
		. Grab a password from basic pwall script (untested).
		. Run script with different version/package name.
	+ Remove BigLASM (untested, because i got no real example to test against).
+ Inject custom code into compiled lua code (legit no one has this EVER, not even Open-Sourced ones!)

## Credits:
- ABJ4403 - Original creator of LuaTools and VirtGG.
- Veyron, HBXVPN - Obfuscation codes.
- Enyby - For some portion of Script Compiler 3.7 source codes (specifically the dump input field).
- SwinXTools - for Remove LASM Block deobfuscation codes.
- Daddyaaaaaaa - for Remove blocker 1 deobfuscation codes.
- LuaGGEG, Angela, MafiaWar - for Remove BigLASM code.

I created this under 24 hour (on a phone btw!) as a challenge :D So it would be really appreciated if you can contribute to LuaTools GitHub repository or give a star to my project on GitHub. or simply credit my work (by not removing mentions about me and others in this script :) Thank you :D
PS: This is not compatible with Lua interpreter, this script is designed with GameGuardian APIs and Android directory hierarchy in mind.

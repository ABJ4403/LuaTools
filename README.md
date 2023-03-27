Lua Toolbox
Manage your Lua scripts on the go!

Why did i make this?
Just to make my life (maybe yours too) easier. and not having to install other proprietary APKs, executables, or even proprietary decryptor/encryptor that can only do one thing and its worst at the same time (eg: PG Encrypt, but no way to decrypt it in the same place, and vice versa. And also there's lots of proprietary gg Lua script out there. maybe you want to clean its garbage code so it can run faster? or run in in secure isolated environment so you can have a peace of mind knowing the files on your phone wont get removed by mallicious `os.remove` API call, or overwriting your files using `io.open/write/read` API call, or executing mallicious commands using `os.execute` API, or you dont want your data to get stolen using `gg.makeRequest` API? Maybe you also wanted to encrypt the script in the correct way because you wanted to share a script, but also realized that your script is too much risky to share to public because you dont want bad cheater (aka. the abuser) uses too much out of your script to hurt other online players? Or you need that little extra tiny SPEED by precompiling the source script and removing its hidden garbage code too.

I created this under 24 hour (on a phone btw!) as a challenge :D So it would be really appreciated if you can contribute to LuaTools GitHub repository (once the script has been open-sourced: https://github.com/ABJ4403/LuaTools) or give a star to my project on GitHub. or simply credit my work (by not removing mentions about me and others in this script :) Thank you :D

Features:
+ Simple, no bloat (no blingy nonsense, no fake loading).
+ Always FOSS (Free and Open-source), Licensed under GPL v3 (not yet)
+ Easy to understand.
+ Basic (De?)Compile, and (Dis)Assemble available (think of it like "pocket" luac semi-unluac).
+ Encryption:
+ Obfuscation modules (no one has EVER seen this concept):
	+ Encryptor signature, and promote yourself.
	+ Restrict GG (minimal) version and package name.
	+ Restrict target application package.
	+ Expiry date.
	+ Detect Decrypt-related packages.
	+ Detect external modification.
	+ No Rename.
	+ Anti SSTool (a normal function but breaks SSTool).
	+ HBX VPN Simple Obfuscation.
	+ Hook detection.
	+ Password (with optional save hashed password).
	+ Welcome (runs after putting correct password).
	+ AntiLoad (calls load API with bogus function).
	+ NoPeek (Prevent peeking at search values).
	+ Spam Log.
	+ BigLASM (makes it less convenient to disassemble the script).
	+ "Human verification", useless but who knows someone wants it for "maximum security".
+ Interchangable encryption methods (if you know how to code Lua, and if this script is FOSS or not...).
+ Every obfuscation code is containerized, which is great for performance, security, and reduces global variable pollution.
+ Encrypted API query.
+ High performance (No fake loading, great optimization, automagic local variable use).
. (TODO) Optional Hard-Password requirement (with XOR encryption, we can use the password itself as a decryption key)
+ Not only "Free as in price", but also "Free as in Freedom". built-in hard-coded configuration allows you to tinker which encryption/obfuscation module suits your needs :D (not for now...)
+ Respects the user, both the author and the end user (not yet, because the code isnt FOSS yet).
+ Decryption:
+ Deobfuscation patches (again no one has ever seen this):
	+ Remove LASM Block.
	+ Remove Garbage.
	+ Remove Hide Codes (unstable).
	+ Remove blocker.
	+ Remove nonsenses (experiment).
+ Run script in isolated environment.
	+ Powered by VirtGG and some Script Compiler 3.7.
	+ Protect your device from unwanted script modification (os.execute,os.remove,gg.makeRequest,etc).
	. Grab a password from basic pwall script (untested).
	. Run script with different version/package name.
+ Remove BigLASM (untested, because i got no real example to test against).

License:
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.	If not, see https://gnu.org/licenses

Credits:
• ABJ4403 - Original creator.
• Veyron, HBXVPN - Obfuscation codes.
• Enyby - For some portion of Script Compiler 3.7 source codes (specifically the dump input field).
• SwinXTools - for Remove LASM Block deobfuscation codes.
• Daddyaaaaaaa - for Remove blocker 1 deobfuscation codes.
• LuaGGEG, Angela, MafiaWar - for Remove BigLASM code.
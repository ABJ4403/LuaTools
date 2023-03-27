--[[

	ABJ4403's Lua Tools v1.8
	Copyright (C) 2022 ABJ4403
	Features:
	+ Simple, no bloat (Unlike others with nonsense blingy shiit, and arbitrary sleep to slow down).
	+ Always FOSS (Free and Open-source), Licensed under GPL v3
	+ Easy to understand.
	+ Basic (De?)Compile, and (Dis)Assemble available (think of it like "pocket" luac semi-unluac).
	+ Encryption:
		+ Obfuscation modules (no one has ever seen this kind of concept):
			+ Encryptor signature.
			+ Promote yourself.
			+ Restrict GG minimal version.
			+ Restrict GG package.
			+ Restrict target application package
			+ Expiry date.
			+ No Decrypt-related packages.
			+ No Rename.
			+ Password.
			+ Welcome (separate module that will run after entering correct password).
			+ Anti SSTool Decrypt (a normal function but looks corrupt to SSTool).
			+ Veyron's Simple Obfuscation
			+ AntiLoad
			+ NoPeek (Prevent peeking at search values)
			+ SpamLog (Spams the log)
			+ BigLASM (Makes .lasm logging useless, but can enlarge the encrypted Lua significantly!)
			+ Hook detection.
		+ API call encryption.
		+ High performance (No arbitrary slowdown, great optimization, automagic local variable use).
		+ optional Hard-Password requirement (with XOR encryption, we can use the password itself as a decryption key :) TODO...
		+ Not only "Free as in price", but also "Free as in Freedom". built-in hard-coded configuration allows you to tinker which encryption/obfuscation module suits your needs :D
		+ Respects the user, both the author and the end user.
	+ Decryption:
		+ Deobfuscation patches (again no one has ever seen this):
			+ Remove LASM Block (by SwinX Tools).
			+ Remove Garbage.
			+ Remove Hide Codes.
			+ Remove blocker (By Daddyaaaaaaa)
		+ Run script in isolated environment.
			+ Powered by VirtGG (by @ABJ4403) and Script Compiler 3.7 (by ???).
			+ Protect your device from unwanted script modification (os.execute,os.remove,gg.makeRequest,etc).
			+ Grab a password from basic pwall script (untested).
			+ Run script with different version/package name.
		+ Remove BigLASM (Beta).

	I created this under 24 hour as a challenge :D
	So it would be appreciated if you credit me (by not removing mentions about me in this file :)

	WARNING: Sharing this encryptor script in any encrypted form (either by self-encrypt, or encrypted by other tools) is violating GPL v3 license,
	and restricts users freedom of changing the hard-coded configuration.
	Any violation will be reported and taken to court order.

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see https://www.gnu.org/licenses

]]
--— Predefining stuff ————————————--
local gg,io,os = gg,io,os -- precache the usual call function (faster function call)
gg.getFile = gg.getFile():gsub('.lua$','') -- strip the .lua for .conf and stuff
local tmp,CH,DATA,out,encryptionKey = {} -- blank stuff for who knows...
local function randstr(len)
	local len=len or 8
	local e=""
--- ANTI UNLUCK 69 CHUNK ---
	for i=1,len do
		e=e..string.char(math.random(128,255))
	end
	return e
end
--XOR encryption
local dec_XOR2 = function(iv,key)local i,iv_,key_=0,{string.byte(iv,0,-1)},{string.byte(key,0,-1)} r=iv:gsub(".",function()i=i+1 return string.char(iv_[i]~key_[i])end)return r end
local dec_XOR = (function(key)return'(iv)local n,iv,key=1,{string.byte(iv,0,-1)},{string.byte([==['..key..']==],0,-1)}for i=1,#iv do iv[i]=string.char(iv[i]~key[n])n=(i%#key)+1 end return table.concat(iv)'end)
local enc_XOR = function(key)
	local key,_key,n,str = key
	dec_XOR = dec_XOR(key)
	key = {string.byte(key,0,-1)}
	return function(str)
		if str == '' and type(str) == 'string' then return [[""]] end -- dont encrypt if nothing gets passed
		n,str = 1,{string.byte(str,0,-1)}
		for i=1,#str do
			str[i] = string.char(str[i] ~ key[n])
			n = (i % #key) + 1
		end
		return 'decode([==['..table.concat(str)..']==])'
	end
end
io.readFile = function(path,openMode,readMode)
	local openMode = openMode or 'r'
	local readMode = readMode or '*a'
	local file = io.open(path,openMode)
	local content = file:read(readMode)
	file:close()
	return content
end
io.writeFile = function(path,buffer,writeMode)
	local writeMode = writeMode or 'w'
	io.open(path,writeMode):write(buffer):close()
end
local function pairs_sorted(t) -- A hacky way to loop tables in sorted order
  local i = {} -- make a blank table
  for k in next,t do table.insert(i,k)end -- Deepclone to new blank table
  table.sort(i) -- Sort out stuff
  return function() -- this will be used for loopingy stuff
    local k = table.remove(i)
    if k then
      return k,t[k]
    end
  end
end
f=string.format
local sleep,toast,alert = gg.sleep,gg.toast,gg.alert
--————————————————————————————————--



--— Hard-coded Configuration —————--
-- Allow user freedom of changing whatever they want
-- Please DO NOT encrypt this script, because we (more of 'i') like to use hard-coded configuration like below
-- if you encrypt this script, then you can't customize stuff here.
-- you will need a code editor (preferably the one that has color-coding & code-folding, like Acode), and Lua knowledge for customizing these stuff below...
local cfg = {
	VERSION = "1.8", -- you can ignore this, its just for defining encryptor version :)
	enc = enc_XOR,
	xdenc = dec_XOR2, -- this means XOR Enc.. Dec..
	dec_wrap = dec_XOR,
	obfModSettings = {
		minGGVer = gg.VERSION, -- minimal GG version required
		ggPkg = "com.catch.me.if.you.can.gg", -- what only gg package script will run
		appPkg = "com.android.calculator", -- what only target package script will run
		fileChoice = '/sdcard/Notes/test',
		scriptExpiry = "20301111", -- YYYYMMDD order
		scriptPW = "__P@$$w0rd123__",
		text = {
			failAppPkgInvalid = "[PkgScanner] This cheat is only allowed to run on \"..GGAppPkg..\", and the target app package name is \"..gg.getTargetPackage()",
			failDatePassed    = "[GGRestrict] This script is expired at \"..GGPacDtm..\".",
			failDeniedPkgs    = "[PkgScanner] Denied packages detected: ",
			failGGPkgInvalid  = "[PkgScanner] This cheat is only allowed to run on \"..GGPkgNm..\", and your GG package name is \"..gg.PACKAGE..\". If you don\'t have GG with specific package name, you can use apktool.",
			failGGVerBelow    = "[PkgScanner] This cheat is only allowed to run on version \"..GGPacVer..\", and you\'re running on version \"..gg.VERSION..\". If you don\'t have GG with specific version, you can use apktool.",
			failHookDetected  = "[VariableTracer] Usage of Function Hook detected! Please run the script in a normal environment.",
			failIllegalMod    = "[TamperingChecker] Illegal external modification detected! Please run the script in a normal environment.",
			failLogDetected   = "[DumpDetector] Usage of Logging detected! this may be caused by slow device, if you didn't expect this, please contact the script author.",
			failInvalidPW     = "[Auth] Invalid Password!",
			failRenamed       = "[FileWatcher] Renaming detected! sorry but you need to rename the script back to: ",
			promoteYourself   = "  Follow me!\n  GitHub: https://github.com/ABJ4403\n  YouTube: https://youtube.com/@AyamGGoreng",
			inputPass         = "[Auth] Input Password:",
			warnPeeking       = "[NoPeek] Caught peeking values",
		}
	}
}
cfg.enc = enc_XOR(randstr()) -- prevent possible bug
-- Put your obfuscation module here (name can be anything but begins with A-Z_, but the value is in string. I recommend putting lightweight to heaviest order, like quick-check on top, log-spam on bottom)
local obfMod = {
	A_EncryptorSignature = "local _=[[\n\n——————————————————————————————————————————————————\n|\n|  🛡 Encrypted by ABJ4403's Lua encryptor v"..cfg.VERSION.." (https://github.com/ABJ4403/LuaToolbox)\n|  Features:\n|  + Simple, no bloat (Unlike others with nonsense blingy shiit, and arbitrary waiting).\n|  + Always FOSS (Free and Open-source), Licensed under GPL v3\n|  + Easy to understand.\n|  + API call encryption.\n|  + High performance (No arbitrary slowdown, great optimization, automagic local variable use, isolated obfuscator modules to make sure global variables not polluted).\n|  + optional Hard-Password requirement (with XOR encryption, we can use the password itself as a decryption key :) TODO...\n|  + Not only \"Free as in Price\", but also \"Free as in Freedom\". built-in hard-coded configuration allows you to tinker which encryption/obfuscation module suits your needs :D\n|  + Respects the user, both the author and the end user.\n|\n|  If you trying to open this encrypted file,\n|  well uhh... GL to even decrypt this XD (if you do)\n|  Otherwise if you think the encryptor is not safe, Don't worry, the encryptor is open-source :D\n|  Go to https://github.com/ABJ4403/lua_gg_stuff/lua_encryptor for the encryptor source-code :D\n|\n——————————————————————————————————————————————————\n\n\n]]",
	B_PromoteYourself    = "local _=[[\n\n"..cfg.obfModSettings.text.promoteYourself.."\n\n]]",
	C_RestrictGGVer      = 'local GGPacVer='..cfg.enc(cfg.obfModSettings.minGGVer)..' if gg.VERSION ~= GGPacVer then os.exit(print("'..cfg.obfModSettings.text.failGGVerBelow..'"))end GGPacVer=nil',
--D_RestrictGGPkg      = 'local GGPkgNm="'..cfg.enc(cfg.obfModSettings.ggPkg)..'" if gg.PACKAGE ~= GGPkgNm then os.exit(print("'..cfg.obfModSettings.text.failGGPkgInvalid..'"))end GGPkgNm=nil',
--E_RestrictAppPkg     = 'local GGAppPkg="'..cfg.enc(cfg.obfModSettings.appPkg)..'" if gg.getTargetPackage() ~= GGAppPkg then print("'..cfg.obfModSettings.text.failAppPkgInvalid..'")return end GGAppPkg=nil',
	F_RestrictExpire     = 'local GGPacDtm='..cfg.enc(cfg.obfModSettings.scriptExpiry)..' if os.date"%Y%m%d" >= GGPacDtm then return os.exit(print("'..cfg.obfModSettings.text.failDatePassed..'"))end GGPacDtm=nil',
	G_RestrictPkgs       = 'for _,v in ipairs{"sstool.only.com.sstool","com.hckeam.mjgql"} do if gg.isPackageInstalled(v)or gg.PACKAGE == v then os.exit(print("'..cfg.obfModSettings.text.failDeniedPkgs..'"..v))end end',
	H_NoIllegalMod       = 'if string.rep("a",2)~="aa" then os.exit(print("'..cfg.obfModSettings.text.failIllegalMod..'"))end',
	I_NoRename           = 'local fileName="${FILE_NAME}" if gg.getFile():gsub("^/.+/","") ~= fileName then print("'..cfg.obfModSettings.text.failRenamed..'"..fileName)os.exit()end',
	J_Password           = 'local CH=gg.prompt({"'..cfg.obfModSettings.text.inputPass..'"},nil,{"text"})if not CH or decode(CH[1]) ~= "${HASHED_PW}" then return print("'..cfg.obfModSettings.text.failInvalidPW..'")end CH=nil', -- TODO: add some sort of way to save the password to config file in external cache so it wont ask password continously everytime you run the script
	K_Welcome            = [[gg.toast("🛡 Encrypted by ABJ4403's Lua encryptor v]]..cfg.VERSION..[[. Please wait...")]],
	L_AntiSSTool				 = [[while nil do local i={}if(i.i)then;i.i=(i.i(i))end end]],
	M_HBXVpnObf          = [[while nil do local srE6h={nil,-nil % -nil,nil,-nil,nil,nil % -nil,-nil % nil,-nil}if #srE6h<0 then break end if srE6h[#srE6h]<0 then break end if srE6h[-nil] ~= #srE6h & ~srE6h then srE6h[#srE6h]=srE6h[-nil]()end if #srE6h<nil then srE6h[#srE6h]=srE6h[-nil%nil]()end goto X1 if nil or 0 then return end::X0::Rias()::X1::function Rias()goto X2 if nil or 0 then return end::X3::Rias()::X2::function Issei()end goto X3 end goto X0 for i=1,0 do TQUILA353="TQUILA1"end for i=1,0 do if nil then TQUILA334="TQUILAV1"end end if nil then if true then else goto S4dFl end if nil then else goto S4dFl end if nil then else goto S4dFl end::S4dFl::end end]],
	N_AntiLoad           = 'local load,str=load,function()local _=nil end for i=1,1e3 do load(str)end',
	O_HookDetect         = 'if debug.getinfo(1).istailcall then os.exit(print("'..cfg.obfModSettings.text.failHookDetected..'"))end for _,t in ipairs({gg,io,os,string,math,table,bit32,utf8})do if type(t) == "table" then for _,f in pairs(t)do if type(f) == "function" then tmp = debug.getinfo(f)if tmp.short_src ~= "[Java]" or tmp.source ~= "=[Java]" or tmp.what ~= "Java" or tmp.namewhat ~= "" or tmp.linedefined ~= -1 or tmp.lastlinedefined ~= -1 or tmp.currentline ~= -1 or tostring(f):match("function: @(.-):")then os.exit(print("'..cfg.obfModSettings.text.failHookDetected..'"))end end end end end',
	P_NoPeek             = 'gg.searchNumber=(function()local ggSearchNumber=gg.searchNumber return function(...)if gg.isVisible()then gg.setVisible(false)gg.clearList()print("'..cfg.obfModSettings.text.warnPeeking..'")end ggSearchNumber(...)if gg.isVisible()then gg.setVisible(false)gg.clearList()print("'..cfg.obfModSettings.text.warnPeeking..'")end end end)()',
	Q_SpamLog            = 'local osTime,debugTraceback,LOG,Time1,Time2=os.time,debug.traceback,string.char(0,4,8,255):rep(1000)Time1=osTime()for i=1,2000 do debugTraceback(1,nil,LOG)end Time2=osTime()if Time2-Time1>1 then os.exit(print("'..cfg.obfModSettings.text.failHookDetected..'"))end osTime,debugTraceback,Time1,Time2,LOG=nil,nil,nil,nil,nil',
	R_BigLASM            = "local "..('x="<<===---- Chunk Obfuscator ----===>>" '):rep(100000)..('goto x '):rep(20000)..("if nil then(function()end)()end "):rep(20000)..'::x::'.."x=nil", -- Makes assembly file really big. Chunk obfuscator?
--x_cHeaphumanVerify   = [[local tmp=math.random(1000,9999)local CH=gg.prompt({"cHeapuman verification\n"..tmp},nil,{"text"})if not CH or CH[1] ~= tmp then return print("'..cfg.obfModSettings.text.failInvalidPW..'")end CH=nil]],
}
-- Put your deobfuscation patches here (name can be whatever. when you modify below, you might want to modify `wrapper_patches()` if you add/remove entries in here)
-- Important: lua doesnt use RegEx. More info: https://www.lua.org/manual/5.1/manual.html#5.4.1
-- Also, ^$()%.[]*+-? is magic char, escape those using % instead of \
local deobfPatch = {
	selfDecrypt = {
 -- For self-decrypt
	},
	RemoveLasmBlock = {
 -- Original by SwinX Tools. slightly modified to work though...
		{
			'%.linedefined (%d+)\n%.lastlinedefined (%d+)\n%.numparams (%d+)\n%.is_vararg (%d+)\n%.maxstacksize (%d+)\n',
			function(a,b,c,d,e)return'.linedefined '..math.min(21,tonumber(a))..'\n.lastlinedefined '..math.min(21,tonumber(b))..'\n.numparams '..math.min(21,tonumber(c))..'\n.is_vararg '..math.min(21,tonumber(d))..'\n.maxstacksize '..math.min(21,tonumber(e))..'\n'end
		},
	},
	RemoveGarbage = {
	--All this was original by @ABJ4403
		{'[^\n]*; garbage\n',''},
	--{'[^\n]*; unused\n',''}, -- disabled cuz marking RETURN after TAILCALL, and this f'ed unluac
		{'[^\n]*; variable v%d+ out of stack %(%.maxstacksize = %d+ for this func%)\n',''},
		{'JMP :goto_%d+; %+0 [↑↓]',''},
		{'OP%[%d%d%] 0x[0-9a-f]+\n',''},
		{'FORLOOP v%d+ GOTO%[%-%d+%]  ; %-%d+ ↑\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)"',''},
		{'FORLOOP v%d+ GOTO%[%d+%]  ; %+%d+ ↓\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)"',''},
	--remove null for-loop
		{'LOADK v%d+ %d+\nLOADK v%d+ %d+\nLOADK v%d+ %d+\n; %.local v%d+ "%(for index%)"\n; %.local v%d+ "%(for limit%)"\n; %.local v%d+ "%(for step%)"\n; %.local v%d+ "%(for iterator%)"\nFORPREP v%d+ :goto_%d+  ; %+0 ↓\n:goto_%d+\nFORLOOP v%d+ :goto_%d+  ; %-1 ↑\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)"',''},
	--anti-unluac (BOR,BNOT,BAND is OP41,OP42,OP43, which makes unluac confused)
		{'[^\n]*BAND v%d+ v%d+ nil\n',''},
		{'[^\n]*BAND v%d+ v%d+ v%d+\n',''},
		{'[^\n]*BOR v%d+ v%d+ nil\n',''},
		{'[^\n]*BOR v%d+ v%d+ v%d+\n',''},
		{'[^\n]*BNOT v%d+ v%d+\n',''},
	},
	RemoveHideCodes = {
		{'SET_TOP',''}, -- caused failure when some function is called (CALL v0..vXXX SET_TOP)
		{'SETTABLE v%d+ "[^\n]*" v%d+',''}, -- looks like this removes important code dont use this
	},
	RemoveBlocker1 = {
 -- Kudos to Daddyaaaaaaa for this
		{'[^\n]*CALL v%d+..v%d+\n',''},
		{'[^\n]*CALL v%d+..v%d+ v%d+..v%d+\n',''},
		{'[^\n]*EQ 1 v%d+ v%d+\n',''},
		{'[^\n]*EQ 1 v%d+ nil\n',''},
		{'[^\n]*GETTABLE v%d+ v%d+ nil\n',''},
		{'[^\n]*GETTABLE v%d+ v%d+ "d"\n',''},
		{'[^\n]*GETTABLE v%d+ v%d+ "clearResults"\n',''},
		{'[^\n]*GETTABLE v%d+ v%d+ "data"\n',''},
		{'[^\n]*GETTABLE v%d+ v%d+ "xxx"\n',''},
		{'[^\n]*GETTABLE v%d+ v%d+ "X"\n',''},
		{'[^\n]*GETTABUP v%d+ u[^\n]* "ipairs"\n',''},
		{'[^\n]*GETTABUP v%d+ u[^\n]* "ya"\n',''},
		{'[^\n]*GETTABUP v%d+ u[^\n]* "i"\n',''},
		{'[^\n]*GETTABUP v%d+ u[^\n]* "B"\n',''},
	--{'[^\n]*LOADBOOL v%d+ 0\n',''},
		{'[^\n]*LOADNIL v%d+..v%d+\n',''},
		{'[^\n]*MOVE v%d+ v%d+\n',''},
		{'[^\n]*NEWTABLE v%d+ 0 0\n',''},
		{'[^\n]*SELF v%d+ v%d+ "Z"\n',''},
		{'[^\n]*SELF v%d+ v%d+ "_"\n',''},
	--{'[^\n]*SETTABLE v%d+ "[^\n]*" v%d+\n',''}
		{'[^\n]*SETTABLE v%d+ "d" v%d+\n',''},
		{'[^\n]*SETTABLE v%d+ "X" v%d+\n',''},
		{'[^\n]*SETTABLE v%d+ "sel" v%d+',''},
		{'[^\n]*SETTABLE v%d+ v%d+ nil\n',''},
		{'[^\n]*SETTABLE v%d+ "XXX" v%d+\n',''},
		{'[^\n]*SETTABUP u%d+ "cuk" v%d+\n',''},
		{'[^\n]*SUB v%d+ v%d+ true\n',''},
		{'[^\n]*SUB v%d+ nil nil\n',''},
		{'[^\n]*TEST v%d+ [01]\n',''},
		{'[^\n]*UNM v%d+ v%d+\n',''},
		{'[^\n]*CLOSURE v%d+ F%d+\nSETTABUP u%d+ "fxs" v%d+\n',''},
		{'[^\n]*CLOSURE v%d+ F%d+\nSETTABUP u%d+ "SearchWrite" v%d+\n',''},
		{'[^\n]*CLOSURE v%d+ F%d+\nSETTABUP u%d+ "setvalue" v%d+\n',''},
		{'[^\n]*GETTABUP v%d+ u%d+ "tonumber"\nLOADK v%d+.-%d$\nCALL v%d+..v%d+ v%d+..v%d+\nGETTABUP v%d+ u%d+ "tonumber"\nLOADK v%d+.-%d$\nCALL v%d+..v%d+ v%d+..v%d+\nLT 0 v%d+ v%d+\nJMP :goto_%d+  ; %+0 ↓\n',''},
		{'[^\n]*GETTABUP v%d+ u0 "_____"\nLOADK v%d+ 37\n',''},
		{'[^\n]*GETTABUP v%d+ u0 "_____"\nGETTABLE v%d+ v%d+ 37\n',''},
		{'[^\n]*LOADK v%d+ "fxs"\nCLOSURE v%d+ F%d+\nSETTABUP u%d+ v%d+ v%d+\n',''},
		{'[^\n]*LOADK v%d+ "SearchWrite"\nCLOSURE v%d+ F%d+\nSETTABUP u%d+ v%d+ v%d+\n',''},
		{'[^\n]*LOADK v%d+ "setvalue"\nCLOSURE v%d+ F%d+\nSETTABUP u%d+ v%d+ v%d+\n',''},
		{'[^\n]*LOADK v%d+ 1\nLOADK v%d+ 0\nLOADK v%d+ 1\n; %.local v%d+ "%(for index%)"\n; %.local v%d+ "%(for limit%)"\n; %.local v%d+ "%(for step%)"\n; %.local v%d+ "%(for iterator%)"\nFORPREP v%d+ :goto_%d+  ; %+%d+ ↓\n',''},

		{"[^\n]*NEWTABLE v%d+ %d 0\n","GETTABUP v0 u0 \"GARBAGE\""},
		{'[^\n]*TFORCALL v%d+..v%d+\n',''},
		{"[^\n]*TFORLOOP v%d+ :goto_%d+* ; -%d+ ↑\n",""}
			},
	RemoveSWATChunkProtector = {
	--TODO: fix formatting, yuno... "magic character"
		{'LOADK v%d+ (50|80)\nLOADK v%d+ (100|200)\nLOADK v%d+ 1\n; %.local v%d+ "%(for index%)"\n; %.local v%d+ "%(for limit%)"\n; %.local v%d+ "%(for step%)"\n; %.local v%d+ "%(for iterator%)"\nFORPREP v%d+ :goto_%d+  ; %+1 ↓\n:goto_%d+\nSETTABUP u0 "se" "🇨 🇭 🇺 🇳 🇰"\n:goto_%d+\nFORLOOP v%d+ :goto_%d+  ; %-2 ↑\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)"',''}
	},
	EssentialMinify = {
 -- Some regex fails, this can help by trimming spaces and blank lines...
		{'.source "[^\n]*"','.source ""'}, -- potentially fix issues with .source prop
		{'^%s*(.-)%s*$','%1'}, -- only works for single-line
		{'\n%s*(.-)%s*\n','\n%1\n'}, -- using \n can kindof fix the issue little bit
		{'\n\n','\n'}, --reduce dupe newline
		{'%s*\n%s*','\n'}, -- 2nd patch to slap more tabs off (hack)
		{'[^\n]*\t+',''}, --remove tabs (hack)
	},
	RemoveNonsenses = {
	--This is for removing Infinity and nil stuff
		{'LOADK v%d+ %-?Infinity%.0',"LOADK v%d+ 0"},
		{':goto_%d+\n:goto_%d+',''},
		{'[^\n]*.func [^\n]* ; 1 upvalues, 0 locals, 3 constants, 0 funcs[^\n]*.source [^\n]*.linedefined [^\n]*.lastlinedefined [^\n]*.numparams [^\n]*.is_vararg [^\n]*.maxstacksize [^\n]*.upval u0 nil ; u0[^\n]*GETTABUP v0 u0 "math"[^\n]*GETTABLE v0 v0 "random"[^\n]*LOADK v1 0[^\n]*LOADK v2 0[^\n]*CALL v0..v2[^\n]*RETURN[^\n]*.end ; [^\n]*',''},
	--blank function
		{'%.func F[^\n]* ; 0 upvalues, 0 locals, 0 constants, 0 funcs\n%.source "[^\n]*"\n%.linedefined %d+\n%.lastlinedefined %d+\n%.numparams %d+\n%.is_vararg %d+\n%.maxstacksize %d+\n%.end ; F[^\n]*',''},
	},
}
--————————————————————————————————--




--— Core functions ———————————————--
function MENU()
	local CH = gg.choice({
		"1. Encrypt Lua",
		"2. (De)compile Lua",
		"3. (Dis)assemble Lua",
		"4. Fix corrupted Lua header",
		"5. Patches to decrypt files",
		"6. Run script in isolated environment (uses VirtGG & Script Compiler 3.7)",
	},nil,"ABJ4403's Lua toolbox "..cfg.VERSION)
	if CH == 1 then wrapper_encryptLua()
	elseif CH == 2 then wrapper_compileLua()
	elseif CH == 3 then wrapper_luacAssembly()
	elseif CH == 4 then wrapper_fixLuacHeader()
	elseif CH == 5 then wrapper_patches()
	elseif CH == 6 then wrapper_secureRun() end
	CH = nil
end

function wrapper_encryptLua()
	-- Ask user for file...
	CH = gg.prompt({'📂️ Input File (make sure the extension is .lua):'},{gg.getFile},{'file'});
	if not CH or not CH[1] then
		print("[!] Cancelled by user.")
	else
		toast("Encrypting, Please wait... this will take maximum of couple seconds")
		CH = CH[1]
		cfg.obfModSettings.fileChoice = CH:gsub(".lua$",'')
		encryptLua()
		print("[✔] Finished encrypting "..CH.."!\n[+] Input File: "..CH..".eua\n[+] Output File: "..CH..".enc.lua")
		toast("[✔] Encryption complete.")
	end
end
function wrapper_compileLua()
	-- Ask user for file...
	CH = gg.prompt({
		'📂️ Input File (make sure the extension is .lua):',
		'Strip debugging symbol (not recommended)',
		'Decompile (TODO-LoPrio,Waiting)'
	},{gg.getFile},{'file','checkbox','checkbox'});
	if not CH or not CH[1] then
		print("[!] Cancelled by user.")
	else
		toast("Compiling, Please wait... this will take maximum of couple seconds")
		CH[1] = CH[1]:gsub(".lua$",'')
		cfg.obfModSettings.fileChoice = CH[1]
		compileLua(".luac",CH[2])
		print("[✔] Finished Compiling "..CH[1].."!\n[+] Input File: "..CH[1]..".lua\n[+] Output File: "..CH[1]..".luac")
		toast("Compiling complete.")
	end
end
function wrapper_luacAssembly()
	-- Ask user for file...
	CH = gg.prompt({
		'📂️ Input File (make sure the extension is either .luac/.lasm):',
		'Assemble'
	},{gg.getFile,false},{'file','checkbox'});
	if not CH or not CH[1] then
		print("[!] Cancelled by user.")
	else
		CH[1] = CH[1]:gsub(".luac$",''):gsub(".lasm$",'')
		if CH[2] == true then
			toast("Assembling, please wait... this may take couple seconds")
			cfg.obfModSettings.fileChoice = CH[1]
			assembleLua(false)
			print("[✔] Finished Assembling "..CH[1].."!\n[+] Input File: "..CH[1]..".lasm\n[+] Output File: "..CH[1]..".luac")
			toast("Assembling complete.")
		else
			toast("Disassembling, please wait... this may take couple seconds")
			cfg.obfModSettings.fileChoice = CH[1]
			disassembleLua('.luac',false)
			print("[✔] Disassembled "..CH[1].."!\n[+] Input File: "..CH[1]..".luac\n[+] Output File: "..CH[1]..".lasm")
			toast("Disassembling complete.")
		end
	end
end
function wrapper_fixLuacHeader()
	-- Ask user for file...
	CH = gg.prompt({'📂️ Input File (make sure the extension is .enc.lua, BTW i recommend reassemble the script instead of fixing the header):'},{gg.getFile},{'file'});
	if not CH or not CH[1] then
		print("[!] Cancelled by user.")
	else
		toast("Fixing Lua header, Please wait...\nWarning: still in experimentation phase")
		cfg.obfModSettings.fileChoice = CH[1]:gsub(".enc.lua$",'')
		modFileHeader('LuaFixHeader')
		toast("Lua header fixed.")
	end
end
function wrapper_patches()
	-- Ask user for file...
	CH = gg.prompt({
		'📂️ Input File (make sure the extension is .enc.lua/.lasm, and make sure to backup your script because this may overwrite the script you chosen):', -- 1
		'Remove BigLASM (only for luacompiled file)', -- 2
		'Remove Garbage (recommended)', -- 3
		'Remove "hide code" (TODO:poor translation)', -- 4
		'Remove Lasm Block', -- 5
		'Unblock 1 (by Daddyaaaaaaa)', -- 6
		'Remove bunch of nonsense (by ABJ4403 and others)', -- 7
		'Remove ABJ4403\'s encryption to some extent', -- 8
		'Remove SWAT obfuscator chunk', -- 9
	},{
		gg.getFile,
		false,true,false,
		false,false,false,
		false,false
	},{
		'file',
		'checkbox','checkbox','checkbox',
		'checkbox','checkbox','checkbox',
		'checkbox','checkbox'
	});
	if not CH or not CH[1] then
		print("[!] Cancelled by user.")
--- ANTI UNLUCK 69 CHUNK ---
	else
		isAsmFile = CH[1]:match('.lasm$')
		if isAsmFile then
			CH[1] = CH[1]:gsub(".lasm$",'')
		else
			CH[1] = CH[1]:gsub(".enc.lua$",'')
		end


		toast("Running selected operations... 1/10")
		cfg.obfModSettings.fileChoice = CH[1]
		if CH[2] and not isAsmFile then removeBigLasm() print("[✔] BigLASM Removed!")end

 -- Assembly Patching (dissasemble if luac,read assembly,patch for each,write changes to assembly,assemble back)
		toast("Running selected operations... 1.3/10")
		if isAsmFile then
			print('[i] Lua Assembly file format detected, patching assembly files without recompiling...')
			DATA = io.readFile(cfg.obfModSettings.fileChoice..".lasm")
		else
			DATA = disassembleLua('.enc.lua',true)
		end
		toast("Running selected operations... 1.75/10") patchAssembly("EssentialMinify")

	--Make sure the 2nd argument of `patchAssembly(file,patchName)` is also on `deobfMod[patchName]` or crashed.
		io.writeFile(cfg.obfModSettings.fileChoice..".dbg.lasm",DATA) -- debug lol
		if CH[8] then toast("Running selected operations... 2/10") patchAssembly("selfDecrypt") print("[✔] Self decrypted! (some)")end
		if CH[3] then toast("Running selected operations... 3/10") patchAssembly("RemoveGarbage") print("[✔] Garbages removed!")end
		if CH[4] then toast("Running selected operations... 4/10") patchAssembly("RemoveHideCodes") print("[✔] Hide codes removed!")end
		if CH[5] then toast("Running selected operations... 5/10") patchAssembly("RemoveLasmBlock") print("[✔] LasmBlock Removed!")end
		if CH[6] then toast("Running selected operations... 6/10") patchAssembly("RemoveBlocker1") print("[✔] Blockers patched!")end
		if CH[7] then toast("Running selected operations... 7/10") patchAssembly("RemoveNonsenses") print("[✔] Removed nonsenses!")end
	--8
		if CH[9] then toast("Running selected operations... 8/10") patchAssembly("RemoveSWATChunkProtector") print("[✔] Removed SWAT chunk!")end

		toast("Running selected operations... 9.25/10")
		io.writeFile(cfg.obfModSettings.fileChoice..".lasm",DATA)
		toast("Running selected operations... 9.5/10")
		if isAsmFile then print('[i] Lua Assembly file format detected, patching assembly files without recompiling...') else assembleLua(true) end
		toast("Running selected operations... 9.75/10")

 -- Completed
		print("\n[+] Input File: "..cfg.obfModSettings.fileChoice..".enc.lua\n[+] Output File: "..cfg.obfModSettings.fileChoice..".luac")
		toast("Operation completed!")
	end
end
function wrapper_secureRun()
	local CH = gg.prompt({
		"📂️ Script:", -- 1
		"📂️ Wrapper script (commonly used for other modifications):", -- 2
		"❌️ Disable mallicious functions", -- 3
		"🛡️ Run security tests (if 3rd option enabled)", -- 4
		"⚠️ Exit if security tests fail (if 3rd + 4th option enabled)", -- 5
		"📜️ Dump function calls", -- 6
		"📜️ Dump load calls", -- 7
		"📜️ Dump input strings (commonly used to extract password, leave blank to disable)", -- 8
		"🖊️ GG Version", -- 9
		"🖊️ GG Build", -- 10
		"🖊️ GG Package", -- 11
		"📜️ Minimum size for log call `load()`:", -- 12
	},{
		gg.getFile, -- 1
		nil, -- 2
		true, -- 3
		true, -- 4
		true, -- 5
		false, -- 6
		false, -- 7
		false, -- 8
		gg.VERSION, -- 9
		gg.BUILD, -- 10
		gg.PACKAGE, -- 11
		400 -- 12
	},{
		"file", -- 1
		"file", -- 2
		"checkbox", -- 3
		"checkbox", -- 4
		"checkbox", -- 5
		"checkbox", -- 6
		"checkbox", -- 7
		"checkbox", -- 8
		"text", -- 9
		"number", -- 10
		"text", -- 11
		"number", -- 12
	})
	if not CH or not CH[1] then
		print("[!] Cancelled by user.")
	else
		cfg.obfModSettings.fileChoice = CH[1]:gsub(".lua$",'')
		local ScriptResult,err = loadfile(CH[1])
		if not ScriptResult or err then -- Error detection
			gg.toast("[!] Failed to load the script, see print log for more details.")
			return print("[!] Failed to load the script, more details:\n\n",err)
		end
		if CH[2] ~= '' then
			local ScriptWrapper,err = loadfile(CH[2])
			if not ScriptWrapper or err then -- Error detection
				toast("[!] Failed to load the wrapper script, see print log for more details.")
				print("[!] Failed to load the wrapper script, more details:\n\n",err)
			end
		end
		toast('[i] This script is still WIP, (for now) the script will be executed with basic modification')
		if not alert("[!] The script will be executed, if you sure to continue, press OK") then return end
		do -- Prepare isolated container
			toast("[i] Preparing isolated container...")
			print("[i] Preparing isolated container...")
		--Prepare fricked variables
			local err
			local Repl = {
				["print"]=print,
				["io"]=table.copy(io),
				["os"]=table.copy(os),
				["debug"]=table.copy(debug),
				["string"]=table.copy(string),
				["math"]=table.copy(math),
				["table"]=table.copy(table),
				["env"]=_ENV,
				["loadfile"]=loadfile,
				["loadstring"]=loadstring,
				["load"]=load,
				["tostring"]=tostring,
				["utf8"]=table.copy(utf8),
				["select"]=select,
				["type"]=type,
				["pairs"]=pairs,
				["ipairs"]=ipairs,
				["next"]=next,
			}
			Repl.gg = table.copy(gg)
			local ContainmentFiles = {}
			ContainmentFiles.pwd = gg.getFile or "/sdcard/ggVirtual_cache_log_temp"
			ContainmentFiles.containmentdir = ContainmentFiles.pwd.."/ContainmentDir"
			ContainmentFiles.luascript = ContainmentFiles.containmentdir.."/ContainedLua.lua"
			ContainmentFiles.txtfile = ContainmentFiles.containmentdir.."/ContainedText.txt"
			ContainmentFiles.dumplogfile = ContainmentFiles.pwd.."/ScriptLog_"..os.date('%d.%m.%Y_%H.%M.%S')..".log"
			gg.getFile = (function()local _=CH[1]return function()return _ end end)() -- fix bug
			gg.VERSION = CH[9]
			gg.BUILD = CH[10]
			gg.PACKAGE = CH[11]
			if CH[3] then -- Disable mallicious functions
				local function void(name)
					return function(...)
						Repl.print("[Warn] Intercepted: " .. name)
						return nil
					end
				end
				gg.makeRequest=function(uri,header,data)
					uri = uri or "http://127.0.0.1"
					header = header or {
						["Accept"] = "application/xml;q=0.9",
						["Accept-Encoding"] = "gzip, deflate, br",
						["Accept-Language"] = "en;q=0.5",
						["Connection"] = "keep-alive",
						["Cookie"] = "",
						["DNT"] = "1",
						["Host"] = uri,
						["Sec-Fetch-Dest"] = "document",
						["Sec-Fetch-Mode"] = "navigate",
						["Sec-Fetch-Site"] = "none",
						["Sec-Fetch-User"] = "?1",
						["Sec-GPC"] = "1",
						["Upgrade-Insecure-Requests"] = "1",
						["User-Agent"] = "Mozilla/5.0 (Android 10) Gecko/20100101"
					}
					data = data or {}
					if CH[6] then Repl.print("[Dump] gg.makeRequest("..uri..","..Repl.table.tostring(header)..","..Repl.table.tostring(data)..")") end
					return {
						url=uri,
						requestMethod=nil,
						code=300,
						message="Success",
						headers={
							["cache-control"] = "max-age=1",
							["content-encoding"] = "br",
							["content-type"] = "text/html; charset=UTF-8",
							["date"] = "Mon, 01 Jan 2020 00:00:00 GMT",
							["expect-ct"] = "max-age=0",
							["expires"] = "Mon, 01 Jan 2020 00:00:00 GMT",
							["permissions-policy"] = "interest-cohort=()",
							["referrer-policy"] = "origin",
							["server"] = "lighttpd",
							["server-timing"] = "total;dur=1",
							["strict-transport-security"] = "max-age=1",
							["vary"] = "Accept-Encoding",
							["x-frame-options"] = "SAMEORIGIN",
							["x-xss-protection"] = "1;mode=block"
						},
						error=false,
						content=data
					}
				end
				os.execute = void("os.execute")
				os.remove  = void("os.remove")
				io.open    = function(file,opmodes) -- only log because orig io.open returns file/type userdata
					if not file then return nil end
					Repl.print('[Malicious] something tries to open "'..file..'" with opmode '..tostring(opmodes))
				--return Repl.io.open(ContainmentFiles.txtfile,"r") cant do this because stuckk on loop
					return Repl.io.open(file,opmodes)
				end
				io.close   = void("io.close")
				io.input   = void("io.input")
				io.output  = void("io.output")
				io.read    = void("io.read")
				io.write   = void("io.write")
				_ENV._VERSION = "Lua 5.0"
				_ENV.loadfile = void("_ENV.loadfile")
				_ENV.loadstring = void("_ENV.loadstring")
				_ENV.io = io
				_ENV.debug = debug
				_ENV.print = print
				_ENV.os = os
				tostring = function(a,...) -- prevent anti-hook, especially with function
					if type(a) == "function" then
						return "function: 0x"..string.format("%x",math.random(0x100000000fff,0xffffffffffff))
					elseif type(a) == "table" then
						return "table: 0x"..string.format("%x",math.random(0x100000000fff,0xffffffffffff))
					end
					return Repl.tostring(a,...)
				end
				debug.gethook = function(f,a,b) -- prevent anti-hook
					return nil, 0
				end
				debug.getinfo = function(f,a,b) -- prevent anti-hook
					return {
						short_src = "[Java]",
						source = "=[Java]",
						what = "Java",
						namewhat = "",
						linedefined = -1,
						lastlinedefined = -1,
						currentline = -1,
						func = f,
						istailcall = false,
						isvararg = true,
						nups = 0,
						nparams = 0,
					}
				end
				debug.getlocal = function(a,b) -- prevent another anti-hook
					local name,value = debug.getlocal(2,i)
					name = name or string.char(({math.random(65,90),math.random(97,122)})[math.random(1,2)]):rep(math.random(1,10))
					value = value or string.char(({math.random(65,90),math.random(97,122)})[math.random(1,2)]):rep(math.random(1,10))
					return name,value
				end
				debug.traceback = function(m,a,b) -- prevent log spam
					if m then m = m.."\n" else m = "" end
					return m.."stack traceback:\n	"..ContainmentFiles.luascript..": in main chunk\n	[Java]: in ?"
				end
			end
			if CH[4] then -- Run security tests
				if os.execute("echo CRITICAL_INTERRUPT_THE_SCRIPT_NOW") == "CRITICAL_INTERRUPT_THE_SCRIPT_NOW" then end
				os.remove(gg.getFile()..".sampleremove")
				io.open()
				io.close()
				io.input()
				io.output()
				io.read()
				io.write()
				if _ENV._VERSION ~= "Lua 5.3" then end
				if (_ENV.loadfile == void and not _ENV.loadfile()) then end
				if (_ENV.loadstring == void and not _ENV.loadstring()) then end
				if _ENV.io == io then end
				if _ENV.debug == debug then end
				_ENV.print('If you see [Script] at the beginning of the this text, that means it works!')
				if (_ENV.print == print) then end
				if _ENV.os == os then end
				gg.getFile()
				gg.getResults(123)
				gg.makeRequest("http://127.0.0.1")
			end
			if CH[6] then -- Dump function calls

			end
			if CH[7] and CH[12] ~= '' then -- Dump load calls

			end
			if CH[8] then -- Dump input strings
				local pass = math.random(1000,9999)
				local f = io.open(ContainmentFiles.dumplogfile,'w')
				Repl.gg.alert('You chose dump input string option. Displays possible passwords. Works only if the plain password is in the code. On the offer to put password, type '..pass)
				local cache = {}
				cache[pass] = true
				debug.sethook(function()
					local stack = {}
					for j = 1,250 do
						local _,v = Repl.debug.getlocal(1,j)
						if v ~= nil then
							local t = Repl.type(v)
							if t == 'string' or t == 'number' then stack[v] = true
							elseif t == 'table' then
								for _,vv in Repl.pairs(v) do
									t = Repl.type(vv)
									if t == 'string' or t == 'number' then stack[vv] = true end
								end
							end
						end
					end
					if stack[pass] then
						local buffer = ''
						for i,_ in Repl.pairs(stack) do
							if not cache[i] then
								cache[i] = true
								buffer = buffer..i.."\n"
							end
						end
						if buffer ~= '' then
							Repl.print(buffer)
							f:write(buffer)
						end
					end
				end,'',1)
			end
			toast("[i] Running script In isolated container...")
			print("[i] Running "..cfg.obfModSettings.fileChoice.." In isolated container...")
			collectgarbage"collect"
			do -- Isolated environment (prevents leaked outside/inside variables)
				if CH[2]and ScriptWrapper then ScriptWrapper()end
				ScriptResult,err = ScriptResult()
			end
		--Cleanup some fricked variables
			debug.sethook(nil,'',1)
			for i,v in pairs(Repl) do
				_G[i] = v
			end
		end
		print("--")
		print(ScriptResult,err)
		return os.exit(print("Clean exit --"))
	end
end
function encryptLua()
	-- log the startup
	print("[+] Encryption initialized ("..cfg.dec_wrap..").")

	-- Wrap the decryptor script
	print("[i] Wrapping decryptor...")
	cfg.dec_wrap = "local function decode"..cfg.dec_wrap.." end\n"
	cfg.enc = enc_XOR(cfg.obfModSettings.scriptPW) -- add key

	-- Put the input file content to buffer
	print("[i] Reading file contents to buffer...")
	collectgarbage"collect"
	DATA = io.readFile(cfg.obfModSettings.fileChoice..'.lua')

	print("[i] Encrypting strings...")
	collectgarbage"collect"
	DATA = DATA:gsub('os%.exit%(%)','os.exit()print("[AntiExitDetect] Anti os.exit() detected, forcing script to crash")return(nil)(nil)') -- force exit
	DATA = DATA:gsub('%(decode%((.-)%)%)',function(i)return'('..cfg.enc(i)..')'end)
--DATA = DATA:gsub('%[([%[=]*)(.-)([%]=]*)%]',function(i)return'('..cfg.enc(i)..')'end) buggy

	-- below can be buggy.
	-- replace any `function bla.bla()` > `bla.bla = function()` to prevent such bug from occuring
	print("[i] Encrypting table functions...")
	collectgarbage"collect"
	for _,v in ipairs({"gg","io","os","string","math","table","debug","bit32","utf8"}) do
		print(" |  "..v)
		DATA = DATA:gsub(v.."%.(%a+)%(",function(s)return v..'['..cfg.enc(s)..']('end)
	end

	print("[i] Wrapping main function to mainPayload()...")
	collectgarbage"collect"
	DATA = "local function mainPayload()local gg,os,io=gg,os,io "..DATA.."\nend mainPayload()"

	-- Some obfuscation needs configuration (eg. no rename)
	print("[i] Configuring Obfuscations...")
	collectgarbage"collect"
	obfMod.I_NoRename = obfMod.I_NoRename:gsub('${FILE_NAME}',cfg.obfModSettings.fileChoice:gsub('^/.+/','')..'.enc.lua')
	obfMod.J_Password = obfMod.J_Password:gsub('${HASHED_PW}',cfg.xdenc(cfg.obfModSettings.scriptPW))

	-- Append obfuscation module before script starts, and put decryptor at very beginning (applied in reverse order)
	print("[i] Applying Obfuscations... (sorted Z-A/bottom-top)")
	collectgarbage"collect"
	for i,v in pairs_sorted(obfMod) do
		print(" |  "..(i):gsub('^[A-Z]_',''))
		DATA = 'do '..v..' end\n'..DATA
	end
	print('———')
	DATA = cfg.dec_wrap..DATA

	-- Encryption done, "Compile" the file (in a hacky way lol)
	cfg.enc = enc_XOR -- Restore original function
	print("[i] Compiling...")
	collectgarbage"collect"
	io.writeFile(cfg.obfModSettings.fileChoice..".debug.lua",DATA) -- debugging lol
	compileLua(".enc.lua",true)

	-- Post-compile. Corrupt the Lua file header to prevent unluac from decompiling
	modFileHeader('LuaBreakHeader')
end
function decryptLua()
	DATA = io.readFile(cfg.obfModSettings.fileChoice..'.enc.lua')

	local dec_XOR_RandomKey=function(iv,key)local i,iv_,key_=0,{string.byte(iv,0,-1)},{string.byte(key,0,-1)} r=iv:gsub(".",function()i=i+1 return string.char(iv_[i]~key_[i])end)return r end

	DATA = DATA:gsub('%(decode%(%[==%[(.-)%]==%],"(.-)"%)%)',function(i)return'"'..cfg.enc(i)..'"'end)
	DATA = DATA:gsub([['gg%[decode%(%[==%[(.-)%]==%],"(.-)"%)%]%(']],function(i)return'gg.'..dec_XOR_RandomKey(i)..'('end)

	io.writeFile(cfg.obfModSettings.fileChoice..".dec.lua",DATA)
end
function compileLua(fileExt,stripDebugSymbols)
	print("[i] Compiling "..cfg.obfModSettings.fileChoice.."...")
	DATA,tmp = load(DATA or io.readFile(cfg.obfModSettings.fileChoice..'.lua'))
	stripDebugSymbols = stripDebugSymbols or false
	if tmp or not DATA then
		gg.setVisible(true)
		toast("[!] Error occured!")
		print("[!] Error occured. There's something wrong with your script or this tool configuration.\n[!] try to check and run "..cfg.obfModSettings.fileChoice..".debug.lua to find out why")
		if tmp then print("[!] "..tmp.."\n==========\n")end
	end
	io.writeFile(cfg.obfModSettings.fileChoice..fileExt,string.dump(DATA,stripDebugSymbols)) -- 3rd arg of strDump: use_names: A boolean value that specifies whether or not to include local variable names in the dumped function. If true, the resulting string will include local variable names. If false (default), the resulting string will not include local variable names.
end
function decompileLua(fileExt,stripDebugSymbols)
	print("[i] Decompiling "..cfg.obfModSettings.fileChoice.."...")
	DATA = DATA or io.readFile(cfg.obfModSettings.fileChoice..'.lua')
	if tmp or not DATA then print("[!] Error occured. There's something wrong with your script or this tool configuration.\n[!] "..tmp.."\n==========\n") end
end
function assembleLua(stripDebugSymbols)
	print("[i] Assembling "..cfg.obfModSettings.fileChoice.."...")
	local fileBuffer,err = loadfile(cfg.obfModSettings.fileChoice..".lasm")
	if err or not fileBuffer then
		print("[!] Failed to load lua assembly, more information:\n\n",err)
	end
	io.writeFile(cfg.obfModSettings.fileChoice..".luac",string.dump(fileBuffer,stripDebugSymbols))
end
function disassembleLua(fileExt,stripDebugSymbols)
	print("[i] Disassembling "..cfg.obfModSettings.fileChoice.."...")
	fileExt = fileExt or ".luac"
	stripDebugSymbols = stripDebugSymbols or false

	local fileBuffer,err = loadfile(cfg.obfModSettings.fileChoice..fileExt)
	if err or not fileBuffer then
		print("[!] Failed to load lua script, more information:\n\n",err)
	end
--Strip the file debug symbols (with string.dump's 2nd argument)
--then do the disassemble
--gg.internal9("OutFile","","Hello") ??
	gg.internal2(load(string.dump(fileBuffer,stripDebugSymbols)),cfg.obfModSettings.fileChoice..".lasm")
	return io.readFile(cfg.obfModSettings.fileChoice..".lasm")
end
function modFileHeader(headerTypes)
	local DATA = io.open(cfg.obfModSettings.fileChoice..".enc.lua",'r+')
	DATA:seek('set')
--Grab the first 4 bytes and check if the header is a valid Lua header
	local sigCur = DATA:read(4)
	local sigFix
	if sigCur ~= '\x1BLua' then
		print('[!] The input file is not a Lua binary script (file header starts with "1B 4C 75 61")')
	else
		if headerTypes == 'LuaBreakHeader' then
			print("[i] Corrupting the file header...")
			sigFix = '\x5a\x01\x01\x00\x00\x00\x00\x00'
		elseif  headerTypes == 'LuaFixHeader' then
			sigCur = DATA:read(8)
			if sigCur:sub(3,3) == '\x00' then
				sigFix = '\x52\x00\x00\x04\x04\x04\x08\x00'
			else
				sigFix = '\x52\x00\x01\x04\x04\x04\x08\x00'
			end
			if sigCur == sigFix then
				print('[+] This Lua script doesn\'t need any header fix')
				DATA:close()
				DATA = nil
				return
			else
				DATA:seek('set') io.writeFile(cfg.obfModSettings.fileChoice..'.bak.lua',DATA:read('*a'))
				print("[✔] Fixed Lua header!\n[+] Modified File: "..cfg.obfModSettings.fileChoice..".enc.lua\n[+] Backup File: "..cfg.obfModSettings.fileChoice..".bak.lua")
			end
		end
	end
	DATA:seek('set',4)
	DATA:write(sigFix)
	DATA:close()
	DATA = nil
end
function removeBigLasm()
-- Read file, remove the BigLASM, load() it, dump() it, and write to output
-- Write code:@LuaGGEG. By Angela, MafiaWar, others.
	io.writeFile(cfg.obfModSettings.fileChoice..".enc.lua",string.dump(
		load(
			io.readFile(cfg.obfModSettings.fileChoice..'.enc.lua'):gsub(
				string.char(4,17,39,0,0)..string.char(0,99,53,131,82,116,66,115,67,53):rep(1e3),
				string.char(4,1,0,0,0)
			):gsub(
				string.char(4,17,39,0,0)..string.char(0,99,53,66,82,116,66,115,67,53):rep(1e3),
				string.char(4,1,0,0,0)
			):gsub(
				string.char(4,17,39,0,0)..string.rep('\0',1e4),
				string.char(4,1,0,0,0)
			):gsub(
				string.char(4,17,39,0,0)..string.rep(".",1e4),
				string.char(4,9,0,0,0)
			)
		),
		true
	))
end
function patchAssembly(patchName) -- make sure DATA is loaded first before running the patcher
	collectgarbage"collect"
	local r
	for j=1,#deobfPatch[patchName] do
		toast("Applying "..patchName.." patch... ("..j.."/"..#deobfPatch[patchName]..")")
--[[ ANTI UNLUCK CHUNK ]]--
		DATA,r = DATA:gsub(deobfPatch[patchName][j][1],deobfPatch[patchName][j][2])
		print(patchName.." "..j.." Applied! replaced: "..r)
	end
end
--————————————————————————————————--

--— Dependency ———————————————————--
table.tostring = function(t,depthparam)
	local depth = 1
	local function tab(i)
		str = ""
		for i=1,i+(depthparam or 0) do str = str.."\t" end
		return str
	end
	if type(t) == 'table' then
		local r = '{\n'
		for k,v in pairs(t) do
			r = r..tab(depth)
			if type(k) == 'string' then
			--r = r..'["'..k..'"]='
				r = r..k..' = '
			end
			if type(v) == 'table' then
				r = r..table.tostring(v,(depthparam or 0)+1)
			elseif type(v) == 'boolean' or type(v) == 'number' then
				r = r..tostring(v)
			else
				r = r..'"'..v..'"'
			end
			r = r..',\n'
		end
		if r ~= '' then r = r:sub(1,r:len()-2) end
		return r..'\n'..tab(depth-1)..'}'
	else return t end
end
table.tostring_beautify = function(t)
	if type(t) == 'table' then
		local r = '{'
		for k,v in pairs(t) do
			if type(k) == 'string' then
				r = r..'["'..k..'"]='
			end
			if type(v) == 'table' then
				r = r..table.tostring(v)
			elseif (type(v) == 'boolean' or type(v) == 'number') then
				r = r..tostring(v)
			else
				r = r..'"'..v..'"'
			end
			r = r..','
		end
		if r ~= '' then
				r = r:sub(1,r:len()-1)
		end
		return r..'}'
	else return t end
end
table.copy = function(t1)
	local t2 = {}
	for k,v in pairs(t1) do
		t2[k] = v
	end
	return t2
end
table.merge = function(...)
	--[[
		merge 2 tables, just like Object.assign on JS
		first table will be replaced by new table...
		recommended only on object-like tables, but not on array-like tables
	]]
	local r = {}
	for _,t in ipairs{...} do
		for k,v in pairs(t) do
			r[k] = v
		end
	end
	return r
end
os.sleep = function(ms)
--no true way to imitate this, this recreation below is inaccurate, its a bit faster
	local clck = os.clock
	local start = clck()
	ms = (ms/5000)
	while clck() - start < ms do end
	start,ms,clck = nil,nil,nil
end
--————————————————————————————————--



--— Initialization ———————————————--
print("[+] ABJ4403's Lua tools v"..cfg.VERSION..".")
if gg.BUILD < 15386 then
	print('[!] You are using an old version of GameGuardian. Some functions may not work as expected.\nDetected build version:',gg.BUILD)
end
if gg.isRunnningOnVirtGG then
	print('[i] This script was running on VirtGG.')
	if gg.isRunnningOnLuaInterpreter then
		print('[i] This script was running on Lua Interpreter. Some functions may not work as expected')
	end
end
gg.setVisible(false)
MENU()

--[[
print("[i] Debugging mode.")
DATA = io.readFile("/n.lasm")
patchAssembly("EssentialMinify")
io.writeFile("/n2.lasm",DATA)
]]


gg.setVisible(true)
os.exit(print("[+] Script quit safely."))
--————————————————————————————————--

--[[

	ABJ4403's Lua Tools v2.1
	Copyright (C) 2022-2023 ABJ4403

	WARNING: Sharing this script in any encrypted form (either by self-encrypt, or encrypted by other tools) is violating GPL v3 license,
	and restricts users freedom of changing the hard-coded configuration.
	Any violation will be reported and taken to court order.

]]
--— Predefining stuff ————————————--
local gg,io,os = gg,io,os -- precache the usual call function (faster function call)
local tmp,CH,DATA,out,encryptionKey = {} -- blank stuff for who knows...
local randstr = function(len)
	local len=len or 8
	local e=""
	for i=1,len do
		e=e..string.char(math.random(128,255))
	end
	return e
end
--XOR encryption
local xdenc_XOR = function(iv,key)local i,iv_,key_=0,{string.byte(iv,0,-1)},{string.byte(key,0,-1)} r=iv:gsub(".",function()i=i+1 return string.char(iv_[i]~key_[(i%#key_)+1])end)return r end
local dec_wrap_XOR = (function(key)return'(iv)local iv,key={string.byte(iv,0,-1)},{string.byte([==['..key..']==],0,-1)}for i=1,#iv do iv[i]=string.char(iv[i]~key[(i%#key)+1]) end return table.concat(iv)'end)
local enc_wrap_XOR = function(key)
	local key,_key,n,str = key
	dec_wrap_XOR = dec_wrap_XOR(key)
	key = {string.byte(key,0,-1)}
	return function(str)
		if str == '' and type(str) == 'string' then return [[""]] end -- dont encrypt if nothing gets passed
		str = {string.byte(str,0,-1)}
		for i=1,#str do
			str[i] = string.char(str[i] ~ key[(i % #key) + 1])
		end
		return 'decode([==['..table.concat(str)..']==])'
	end
end
--————————————————————————————————--



--— Hard-coded Configuration —————--
-- Allow user freedom of changing whatever they want
-- Please DO NOT encrypt this script, because we (more of 'i') like to use hard-coded configuration like below
-- if you encrypt this script, then you can't customize stuff here.
-- you will need a code editor (preferably the one that has color-coding & code-folding, like Acode), and Lua knowledge for customizing these stuff below...
local cfg = {
	VERSION = "2.1", -- you can ignore this, its just for defining script version :)
	enc = enc_wrap_XOR, -- useless anyway lol, handled on the bottom
	xdenc = xdenc_XOR, -- this means XOR Enc.. Dec..
	dec_wrap = dec_wrap_XOR,
	scriptPath = gg.getFile():gsub('.lua$',''), -- strip the .lua for .conf and stuff,
	fileChoice = '/sdcard/Notes/test', -- dummy, replaced whenever any file is selected within the GUI
	obfModSettings = {
		minGGVer = gg.VERSION, -- GG version required
		minGGBuildVer = gg.BUILD, -- minimal GG build version required
		allowNewGGBuildVer = true, -- whether to allow newer GG version or not (uses gg.BUILD variable only)
		ggPkg = "com.catch.me.if.you.can.gg", -- what only gg package script will run
		appPkg = "com.android.calculator", -- what only target package script will run
		scriptExpiry = "20301111", -- YYYYMMDD order
		scriptPW = "__P@$$w0rd123__", -- script password
		savePW = true, -- when enabled, the hashed password (not the actual pw) will be exported to a file with '.lt.cfg' extension
		encryptStrings = true,
		encryptTables = true,
		text = {
			failAppPkgInvalid = "[PkgScanner] This cheat is only allowed to run on \"..GGAppPkg..\", and the target app package name is \"..gg.getTargetPackage()",
			failDatePassed    = "[GGRestrict] This script is expired at \"..GGPacDtm..\".",
			failDeniedPkgs    = "[PkgScanner] Denied packages detected: ",
			failGGPkgInvalid  = "[PkgScanner] This cheat is only allowed to run on \"..GGPkgNm..\", and your GG package name is \"..gg.PACKAGE..\". If you don\'t have GG with specific package name, you can use apktool.",
			failGGVerBelow    = "[PkgScanner] This cheat is only allowed to run on \"..verTxt..\" \"..GGPacVer..\" (build \"..GGPacBuildVer..\"), and you\'re running on version \"..gg.VERSION..\" (build \"..gg.BUILD..\"). If you don\'t have GG with specific version, you can use apktool.",
			failHookDetected  = "[VariableTracer] Usage of Function Hook detected! Please run the script in a normal environment.",
			failIllegalMod    = "[TamperingChecker] Illegal external modification detected! Please run the script in a normal environment.",
			failLogDetected   = "[DumpDetector] Usage of Logging detected! this may be caused by slow device, if you didn't expect this, please contact the script author.",
			failInvalidPW     = "[Auth] Invalid Password!",
			failInvalidPWFile = "[Auth] Invalid Password hash stored in LuaTools configuration!",
			failRenamed       = "[FileWatcher] Renaming detected! sorry but you need to rename the script back to: ",
			promoteYourself   = "  Follow me!\n  GitHub: https://github.com/ABJ4403\n  YouTube: https://youtube.com/@AyamGGoreng",
			inputPass         = "[Auth] Input Password:",
			warnPeeking       = "[NoPeek] Caught peeking values",
		}
	}
}
-- Put your obfuscation module here (name can be anything but begins with A-Z_, but the value is in function that returns string. I recommend putting lightweight to heaviest order, like quick-check on top, log-spam on bottom)
local obfMod = {
	A_EncryptorSignature = function()return "local _=[[\n\n——————————————————————————————————————————————————\n|\n|  🛡 Encrypted by ABJ4403's Lua encryptor v"..cfg.VERSION.." (https://github.com/ABJ4403/LuaToolbox)\n|  Features:\n|  + Simple, no bloat (Unlike others with nonsense blingy shiit, and arbitrary waiting).\n|  + Always FOSS (Free and Open-source), Licensed under GPL v3\n|  + Easy to understand.\n|  + API call encryption.\n|  + High performance (No arbitrary slowdown, great optimization, automagic local variable use, isolated obfuscator modules to make sure global variables not polluted).\n|  + optional Hard-Password requirement (with XOR encryption, we can use the password itself as a decryption key :) TODO...\n|  + Not only \"Free as in Price\", but also \"Free as in Freedom\". built-in hard-coded configuration allows you to tinker which encryption/obfuscation module suits your needs :D\n|  + Respects the user, both the author and the end user.\n|\n|  If you trying to open this encrypted file,\n|  well uhh... GL to even decrypt this XD (if you do)\n|  Otherwise if you think the encryptor is not safe, Don't worry, the encryptor is open-source :D\n|  Go to https://github.com/ABJ4403/lua_gg_stuff/lua_encryptor for the encryptor source-code :D\n|\n——————————————————————————————————————————————————\n\n\n]]"end,
	B_PromoteYourself    = function()return "local _=[[\n\n"..cfg.obfModSettings.text.promoteYourself.."\n\n]]"end,
	C_RestrictGGVer      = function()
		local matcher,verTxt = 'gg.BUILD < GGPacBuildVer'
		if not cfg.obfModSettings.allowNewGGBuildVer then
			verTxt = 'version'
			matcher = matcher..' or gg.VERSION ~= GGPacVer'
		else
			verTxt = 'minimum version'
		end
		if cfg.obfModSettings.minGGVer ~= '' then
			return 'local GGPacVer,GGPacBuildVer,verTxt='..cfg.enc(cfg.obfModSettings.minGGVer)..',tonumber('..cfg.enc(cfg.obfModSettings.minGGBuildVer)..'),"'..verTxt..'" if '..matcher..' then os.exit(print("'..cfg.obfModSettings.text.failGGVerBelow..'"))end GGPacVer,GGPacBuildVer,verTxt=nil,nil,nil'
		end
	end,
--D_RestrictGGPkg      = function()
	--if cfg.obfModSettings.ggPkg ~= '' then
		--return 'local GGPkgNm="'..cfg.enc(cfg.obfModSettings.ggPkg)..'" if gg.PACKAGE ~= GGPkgNm then os.exit(print("'..cfg.obfModSettings.text.failGGPkgInvalid..'"))end GGPkgNm=nil'
	--end
--end,
--E_RestrictAppPkg     = function()
	--if cfg.obfModSettings.appPkg ~= '' then
		--return 'local GGAppPkg="'..cfg.enc(cfg.obfModSettings.appPkg)..'" if gg.getTargetPackage() ~= GGAppPkg then print("'..cfg.obfModSettings.text.failAppPkgInvalid..'")return end GGAppPkg=nil'
	--end
--end,
	F_RestrictExpire     = function()
		if cfg.obfModSettings.scriptExpiry ~= '' then
			return 'local GGPacDtm='..cfg.enc(cfg.obfModSettings.scriptExpiry)..'if tonumber(os.date"%Y%m%d") > tonumber(GGPacDtm) then os.exit(print("'..cfg.obfModSettings.text.failDatePassed..'"))end GGPacDtm=nil'
		end
	end,
	G_RestrictPkgs       = function()return 'for _,v in ipairs{"sstool.only.com.sstool","com.hckeam.mjgql"} do if gg.isPackageInstalled(v)or gg.PACKAGE == v then os.exit(print("'..cfg.obfModSettings.text.failDeniedPkgs..'"..v))end end'end,
	H_NoIllegalMod       = function()return 'if string.rep("a",2)~="aa" then os.exit(print("'..cfg.obfModSettings.text.failIllegalMod..'"))end'end,
	I_NoRename           = function()return 'local fileName="'..cfg.fileChoice:gsub('^/.+/','')..'.enc.lua"if gg.getFile():gsub("^/.+/","") ~= fileName then print("'..cfg.obfModSettings.text.failRenamed..'"..fileName)os.exit()end'end,
	J_AntiSSTool				 = function()return [[while nil do local i={}if(i.i)then;i.i=(i.i(i))end end]]end,
	K_HBXVpnObf					 = function()return [[while nil do local srE6h={nil,-nil % -nil,nil,-nil,nil,nil % -nil,-nil % nil,-nil}if #srE6h<0 then break end if srE6h[#srE6h]<0 then break end if srE6h[-nil] ~= #srE6h & ~srE6h then srE6h[#srE6h]=srE6h[-nil]()end if #srE6h<nil then srE6h[#srE6h]=srE6h[-nil%nil]()end goto X1 if nil or 0 then return end::X0::Rias()::X1::function Rias()goto X2 if nil or 0 then return end::X3::Rias()::X2::function Issei()end goto X3 end goto X0 for i=1,0 do TQUILA353="TQUILA1"end for i=1,0 do if nil then TQUILA334="TQUILAV1"end end if nil then if true then else goto S4dFl end if nil then else goto S4dFl end if nil then else goto S4dFl end::S4dFl::end end]]end,
	L_HookDetect				 = function()return 'local tmp if debug.getinfo(1).istailcall then os.exit(print("'..cfg.obfModSettings.text.failHookDetected..'"))end for _,t in ipairs{gg,io,os,string,math,table,bit32,utf8}do if type(t) == "table" then for _,f in pairs(t)do if type(f) == "function" then tmp = debug.getinfo(f)if tmp.short_src ~= "[Java]" or tmp.source ~= "=[Java]" or tmp.what ~= "Java" or tmp.namewhat ~= "" or tmp.linedefined ~= -1 or tmp.lastlinedefined ~= -1 or tmp.currentline ~= -1 or tostring(f):match("function: @(.-):")then os.exit(print("'..cfg.obfModSettings.text.failHookDetected..'"))end end end end end tmp=nil'end,
	M_Password           = function()
		if cfg.obfModSettings.scriptPW ~= '' then
		--base code only have askPw function
			local pwCode = 'askPw=function()CH=gg.prompt({"'..cfg.obfModSettings.text.inputPass..'"},nil,{"text"})if not CH or decode(CH[1])~=pwHash then os.exit(print("'..cfg.obfModSettings.text.failInvalidPW..'"))end '
			if cfg.obfModSettings.savePW then
			--add pw file handler
				pwCode = 'local ltFile,ltOutput=gg.getFile():gsub("%.enc%.lua$",".lua"):gsub("%.lua$",".lt.cfg")'..pwCode..' io.open(ltFile,"w"):write([====[-- ABJ4403 LuaTools Encryptor configuration\n-- Please do not edit this file just in case there is an encoding error while doing it\nIf you really want to edit this file, use a good code editor that respects the encoding of a file\nreturn {\n--Password hash (to avoid typing the same password again)\n	password_hash = "]====]..pwHash..[====["\n}]====]):close()end ltOutput=loadfile(ltFile)if ltOutput then ltOutput=ltOutput()if type(ltOutput)~="table"or ltOutput.password_hash~=pwHash then print("'..cfg.obfModSettings.text.failInvalidPWFile..'")askPw()end else askPw()end'
			else
			--just ask pw
				pwCode = pwCode..'end askPw()'
			end
			pwCode = 'local pwHash,askPw,CH="'..cfg.xdenc(cfg.obfModSettings.scriptPW,cfg.obfModSettings.pwHash)..'" '..pwCode..' CH,askPw,pwHash=nil,nil,nil' -- code to clear everything
			return pwCode
		end
	end,
	N_Welcome            = function()return [[gg.toast("🛡 Encrypted by ABJ4403's Lua encryptor v]]..cfg.VERSION..[[. Please wait...")]]end,
	O_AntiLoad           = function()return 'local load,str=load,function()local _=nil end for i=1,1e3 do load(str)end'end,
	P_NoPeek             = function()return 'gg.searchNumber=(function()local ggSearchNumber=gg.searchNumber return function(...)if gg.isVisible()then gg.setVisible(false)gg.clearList()print("'..cfg.obfModSettings.text.warnPeeking..'")end ggSearchNumber(...)if gg.isVisible()then gg.setVisible(false)gg.clearList()print("'..cfg.obfModSettings.text.warnPeeking..'")end end end)()'end,
	Q_SpamLog            = function()return 'local osTime,debugTraceback,LOG,Time1,Time2=os.time,debug.traceback,string.char(0,4,8,255):rep(1000)Time1=osTime()for i=1,2000 do debugTraceback(1,nil,LOG)end Time2=osTime()if Time2-Time1>1 then os.exit(print("'..cfg.obfModSettings.text.failHookDetected..'"))end osTime,debugTraceback,Time1,Time2,LOG=nil,nil,nil,nil,nil'end,
	R_BigLASM            = function()return "local "..('_="<<===---- Chunk Obfuscator ----===>>" '):rep(30000)..('goto _ '):rep(30000)..("(function()end)() "):rep(30000)..'::_:: _=nil'end, -- Makes assembly file really big. Chunk obfuscator?
--x_cHeaphumanVerify   = function()return [[local tmp=math.random(1000,9999)local CH=gg.prompt({"cHeapuman verification\n"..tmp},nil,{"text"})if not CH or CH[1] ~= tmp then return print("'..cfg.obfModSettings.text.failInvalidPW..'")end CH=nil]]end,
}
-- Put your deobfuscation patches here (name can be whatever. when you modify below, you might want to modify `wrapper_patches()` if you add/remove entries in here)
-- Important: lua doesnt use RegEx. More info: https://www.lua.org/manual/5.1/manual.html#5.4.1
-- Also, ^$()%.[]*+-? is magic char, escape those using % instead of \
local deobfPatch = {
	selfDecrypt = {
 -- For self-decrypt

 -- Anti hook (outdated)
		{'GETTABUP v%d+ u0 "tostring"\nGETTABUP v%d+ u0 "gg"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSELF v%d+ v%d+ "match"\nLOADK v%d+ "function: @%(%.%-%):"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nTEST v%d+ 1\nJMP :goto_%d+  ; %+16 ↓\nGETTABUP v%d+ u0 "tostring"\nGETTABUP v%d+ u0 "os"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSELF v%d+ v%d+ "match"\nLOADK v%d+ "function: @%(%.%-%):"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nTEST v%d+ 1\nJMP :goto_%d+  ; %+8 ↓\nGETTABUP v%d+ u0 "tostring"\nGETTABUP v%d+ u0 "io"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSELF v%d+ v%d+ "match"\nLOADK v%d+ "function: @%(%.%-%):"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nTEST v%d+ 0\nJMP :goto_%d+  ; %+6 ↓\n:goto_%d+\nGETTABUP v%d+ u0 "print"\nLOADK v%d+ "[^\n]*"\nCALL v%d+%.%.v%d+\nGETTABUP v%d+ u0 "os"\nGETTABLE v%d+ v%d+ "exit"\nCALL v%d+%.%.v%d+\n:goto_%d+',''},
 -- Remove Password (outdated)
		{'GETTABUP v%d+ u0 "gg"\nGETTABLE v%d+ v%d+ "prompt"\nNEWTABLE v%d+ 1 0\nLOADK v%d+ "[^\n]*"\nSETLIST v%d+%.%.v%d+ 1\nLOADNIL v%d+%.%.v%d+\nNEWTABLE v%d+ 1 0\nLOADK v%d+ "text"\nSETLIST v%d+%.%.v%d+ 1\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nTEST v%d+ 0\nJMP :goto_%d+  ; %+6 ↓\nGETTABLE v%d+ v%d+ 1\nMOVE v%d+ v%d+\nLOADK v%d+ "[^\n]*"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nEQ 1 v%d+ v%d+\nJMP :goto_%d+  ; %+4 ↓\n:goto_%d+\nGETTABUP v%d+ u0 "print"\nLOADK v%d+ "[^\n]*"\nTAILCALL v%d+%.%.v%d+\nRETURN v%d+ ; unused\n:goto_%d+',''},
 -- No rename (outdated)
		{'LOADK v%d+ "[^\n]*"\nGETTABUP v%d+ u0 "gg"\nGETTABLE v%d+ v%d+ "getFile"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSELF v%d+ v%d+ "gsub"\nLOADK v%d+ "%^/%.%+/"\nLOADK v%d+ ""\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nEQ 1 v%d+ v%d+\nJMP :goto_%d+  ; %+8 ↓\nGETTABUP v%d+ u0 "print"\nLOADK v%d+ "[^\n]*"\nMOVE v%d+ v%d+\nCONCAT v%d+ v%d+%.%.v%d+\nCALL v%d+%.%.v%d+\nGETTABUP v%d+ u0 "os"\nGETTABLE v%d+ v%d+ "exit"\nCALL v%d+%.%.v%d+\n:goto_%d+',''},
 -- Spam log (outdated)
		{'GETTABUP v%d+ u0 "gg"\nGETTABLE v%d+ v%d+ "clearResults"\nCALL v%d+%.%.v%d+\nNEWTABLE v%d+ 0 0\nGETTABUP v%d+ u0 "string"\nGETTABLE v%d+ v%d+ "char"\nLOADK v%d+ 0\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSELF v%d+ v%d+ "rep"\nLOADK v%d+ 1000000\nCALL v%d+%.%.v%d+ SET_TOP\nSETLIST v%d+ 1\nLOADK v%d+ 1\nLOADK v%d+ 100\nLOADK v%d+ 1\n; %.local v%d+ "%(for index%)"\n; %.local v%d+ "%(for limit%)"\n; %.local v%d+ "%(for step%)"\n; %.local v%d+ "%(for iterator%)"\nFORPREP v%d+ :goto_%d+  ; %+4 ↓\n:goto_%d+\nGETTABUP v%d+ u0 "gg"\nGETTABLE v%d+ v%d+ "refineNumber"\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+\n:goto_%d+\nFORLOOP v%d+ :goto_%d+  ; %-5 ↑\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)"',''},
 -- HackerBoyXVPN Obfuscation (outdated)
		{':goto_%d+\nLOADBOOL v%d+ 0\nTEST v%d+ 0\nJMP :goto_%d+  ; %+86 ↓\nNEWTABLE v%d+ 8 0\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nMOD v%d+ v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nMOD v%d+ nil v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nMOD v%d+ v%d+ nil\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nSETLIST v%d+%.%.v%d+ 1\nLEN v%d+ v%d+\nLT 1 v%d+ 0\nJMP :goto_%d+  ; %+66 ↓\nLEN v%d+ v%d+\nGETTABLE v%d+ v%d+ v%d+\nLT 1 v%d+ 0\nJMP :goto_%d+  ; %+62 ↓\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nGETTABLE v%d+ v%d+ v%d+\nLEN v%d+ v%d+\nBNOT v%d+ v%d+\nBAND v%d+ v%d+ v%d+\nEQ 1 v%d+ v%d+\nJMP :goto_%d+  ; %+6 ↓\nLEN v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nGETTABLE v%d+ v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSETTABLE v%d+ v%d+ v%d+\n:goto_%d+\nLEN v%d+ v%d+\nLT 0 v%d+ nil\nJMP :goto_%d+  ; %+11 ↓\nLEN v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nMOD v%d+ v%d+ nil\nGETTABLE v%d+ v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSETTABLE v%d+ v%d+ v%d+\nJMP :goto_%d+  ; %+3 ↓\nRETURN  ; garbage\n:goto_%d+\nGETTABUP v%d+ u0 "Rias"\nCALL v%d+%.%.v%d+\n:goto_%d+\nCLOSURE v%d+ F2\nSETTABUP u0 "Rias" v%d+\nJMP :goto_%d+  ; %-5 ↑\nLOADK v%d+ 1 ; garbage\nLOADK v%d+ 0 ; garbage\nLOADK v%d+ 1 ; garbage\n; %.local v%d+ "%(for index%)"\n; %.local v%d+ "%(for limit%)"\n; %.local v%d+ "%(for step%)"\n; %.local v%d+ "%(for iterator%)"\nFORPREP v%d+ :goto_%d+  ; %+1 ↓ ; garbage\n:goto_%d+\nSETTABUP u0 "TQUILA353" "TQUILA1" ; garbage\n:goto_%d+\nFORLOOP v%d+ :goto_%d+  ; %-2 ↑\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)" ; garbage\nLOADK v%d+ 1 ; garbage\nLOADK v%d+ 0 ; garbage\nLOADK v%d+ 1 ; garbage\n; %.local v%d+ "%(for index%)"\n; %.local v%d+ "%(for limit%)"\n; %.local v%d+ "%(for step%)"\n; %.local v%d+ "%(for iterator%)"\nFORPREP v%d+ :goto_%d+  ; %+4 ↓ ; garbage\n:goto_%d+\nLOADNIL v%d+%.%.v%d+ ; garbage\nTEST v%d+ 0 ; garbage\nJMP :goto_%d+  ; %+1 ↓ ; garbage\nSETTABUP u0 "TQUILA334" "TQUILAV1" ; garbage\n:goto_%d+\nFORLOOP v%d+ :goto_%d+  ; %-5 ↑\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)" ; garbage\nLOADNIL v%d+%.%.v%d+ ; garbage\nTEST v%d+ 0 ; garbage\nJMP :goto_%d+  ; %-76 ↑ ; garbage\nJMP :goto_%d+  ; %+1 ↓ ; garbage\nJMP :goto_%d+  ; %-78 ↑ ; garbage\n:goto_%d+\nLOADNIL v%d+%.%.v%d+ ; garbage\nTEST v%d+ 0 ; garbage\nJMP :goto_%d+  ; %-81 ↑ ; garbage\nJMP :goto_%d+  ; %+1 ↓ ; garbage\nJMP :goto_%d+  ; %-83 ↑ ; garbage\n:goto_%d+\nLOADNIL v%d+%.%.v%d+ ; garbage\nTEST v%d+ 0 ; garbage\nJMP :goto_%d+  ; %-86 ↑ ; garbage\nJMP :goto_%d+  ; %-87 ↑ ; garbage\nJMP :goto_%d+  ; %-88 ↑ ; garbage\nJMP :goto_%d+  ; %-89 ↑ ; garbage\n:goto_%d+',''},
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
		{'[^\n]*JMP :goto_%d+  ; %+0 ↑\n',''},
		{'[^\n]*JMP :goto_%d+  ; %+0 ↓\n',''},
		{'OP%[%d%d%] 0x[0-9a-f]+\n',''},
	--remove null for-loop
		{'FORLOOP v%d+ GOTO%[%-%d+%]  ; %-%d+ ↑\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)"',''},
		{'FORLOOP v%d+ GOTO%[%d+%]  ; %+%d+ ↓\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)"',''},
		{'LOADK v%d+ %d+\nLOADK v%d+ %d+\nLOADK v%d+ %d+\n; %.local v%d+ "%(for index%)"\n; %.local v%d+ "%(for limit%)"\n; %.local v%d+ "%(for step%)"\n; %.local v%d+ "%(for iterator%)"\nFORPREP v%d+ :goto_%d+  ; %+0 ↓\n:goto_%d+\nFORLOOP v%d+ :goto_%d+  ; %-1 ↑\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)"',''},
	--anti-unluac (BOR,BNOT,BAND,BXOR is OP41,OP42,OP43,OP44 which makes unluac confused)
		{'[^\n]*BAND v%d+ v%d+ v%d+\n',''},
	--{'[^\n]*BOR v(%d+) v(%d+) v(%d+)\n','ADD v%1 v%2 v%3\n'},
		{'[^\n]*BNOT v%d+ v%d+\n',''},
	--{'[^\n]*BXOR v%d+ v%d+ v%d+\n',''},
	--anti-unluac but also corrupted math that is when executed, crashed the script
		{'[^\n]*BAND v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'BAND v'..a..' '..b..' '..c..'\n'end}, -- a & b
		{'[^\n]*BXOR v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'BXOR v'..a..' '..b..' '..c..'\n'end}, -- a ~ b
		{'[^\n]*BOR v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'BOR v'..a..' '..b..' '..c..'\n'end}, -- a | b
		{'[^\n]*ADD v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'ADD v'..a..' '..b..' '..c..'\n'end}, -- a + b
		{'[^\n]*SUB v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'SUB v'..a..' '..b..' '..c..'\n'end}, -- a - b
		{'[^\n]*MUL v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'MUL v'..a..' '..b..' '..c..'\n'end}, -- a * b
		{'[^\n]*DIV v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'DIV v'..a..' '..b..' '..c..'\n'end}, -- a / b
		{'[^\n]*IDIV v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'IDIV v'..a..' '..b..' '..c..'\n'end}, -- a // b
		{'[^\n]*MOD v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'MOD v'..a..' '..b..' '..c..'\n'end}, -- a % b
		{'[^\n]*POW v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'POW v'..a..' '..b..' '..c..'\n'end}, -- a ^ b
		{'[^\n]*SHR v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'SHR v'..a..' '..b..' '..c..'\n'end}, -- a >> b
		{'[^\n]*SHL v(%d+) (.-) (.-)\n',function(a,b,c)if b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false' then return'LOADNIL v'..a..'..v'..a..'\n'end return'SHL v'..a..' '..b..' '..c..'\n'end}, -- a << b
	--another possible anti-unluac
	--{'[^\n]*%.upval ([uv]%d+) nil ; u(%d+)\n',function(a,b)return'.upval '..a..' "_ENV" ; u'..b..'\n'end},
	--[[
TODO: how about this one?
either one of these two
LOADNIL v1..1 -- set variable in ranges as nil
LOADBOOL v%d+ 0 -- set variable as true/false

and either one of these two
UNM v1 v1  -a
BNOT v1 v1 ~a
	]]
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
		{'[^\n]*EQ 1 v%d+ nil\n',''}, -- EQ0 = `v1 ~= nil`,EQ1 = `v1 == nil`,
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
		{"[^\n]*TFORLOOP v%d+ :goto_%d+* ; -%d+ ↑\n",""},
	},
	RemoveSWATChunkProtector = {
	--TODO: fix formatting, yuno... "magic character"
		{'LOADK v%d+ (50|80)\nLOADK v%d+ (100|200)\nLOADK v%d+ 1\n; %.local v%d+ "%(for index%)"\n; %.local v%d+ "%(for limit%)"\n; %.local v%d+ "%(for step%)"\n; %.local v%d+ "%(for iterator%)"\nFORPREP v%d+ :goto_%d+  ; %+1 ↓\n:goto_%d+\nSETTABUP u0 "se" "🇨 🇭 🇺 🇳 🇰"\n:goto_%d+\nFORLOOP v%d+ :goto_%d+  ; %-2 ↑\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)"',''}
	},
	EssentialMinify = {
 -- Some regex fails, this can help by trimming spaces and blank lines...
		{'^%s*(.-)%s*$','%1'}, -- only works for single-line
		{'\n%s*(.-)%s*\n','\n%1\n'}, -- using \n can kindof fix the issue little bit
		{'\n\n','\n'}, --reduce dupe newline
		{'%s*\n%s*','\n'}, -- 2nd patch to slap more tabs off (hack)
		{'[^\n]*\t+',''}, --remove tabs (hack)
 -- Anti reassemble
		{'[^\n]*%.source "[^\n]*"','.source ""'},
		{'[^\n]*%.lastlinedefined %-?%d+\n','.lastlinedefined 0\n'},
		{'[^\n]*%.linedefined %-?%d+\n','.linedefined 0\n'},
		{'[^\n]*%.numparams %-?%d+\n','.numparams 0\n'},
	--blank function with no RETURN (crashes lua assembler with no inst.. error)
		{'%.func (F%d+) ; 0 upvalues, 0 locals, 0 constants, 0 funcs\n%.source ""\n%.linedefined 0\n%.lastlinedefined 0\n%.numparams 0\n%.is_vararg ([01])\n%.maxstacksize %d+\n%.end ; F%d+',function(name,isVarArg)return'.func '..name..'\n.source ""\n.linedefined 0\n.lastlinedefined 0\n.numparams 0\n.is_vararg '..isVarArg..'\n.maxstacksize 0\nRETURN\n.end'end},
	},
	RemoveNonsenses = {
	--This is for removing Infinity and nil stuff
		{'%-?Infinity%.0','0'},
		{'%-?NaN%.0','0'},
	--{'[^\n]*LT 1 0 0\n',''},
	--{'[^\n]*LE 1 0 0\n',''},
	--{'[^\n]*EQ 1 0 0\n',''},
	--{'[^\n]*LOADK v%d+ 0\n',''},
		{':goto_%d+\n:goto_%d+',''},
		{'[^\n]*.func [^\n]* ; 1 upvalues, 0 locals, 3 constants, 0 funcs[^\n]*.source [^\n]*.linedefined [^\n]*.lastlinedefined [^\n]*.numparams [^\n]*.is_vararg [^\n]*.maxstacksize [^\n]*.upval u0 nil ; u0[^\n]*GETTABUP v0 u0 "math"[^\n]*GETTABLE v0 v0 "random"[^\n]*LOADK v1 0[^\n]*LOADK v2 0[^\n]*CALL v0..v2[^\n]*RETURN[^\n]*.end ; [^\n]*',''},
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
		"6. Run script in isolated container (uses VirtGG)",
		"__about__",
		"__exit__",
	},nil,"ABJ4403's Lua toolbox "..cfg.VERSION)
	if CH == 1 then wrapper_encryptLua()
	elseif CH == 2 then wrapper_compileLua()
	elseif CH == 3 then wrapper_luacAssembly()
	elseif CH == 4 then wrapper_fixLuacHeader()
	elseif CH == 5 then wrapper_patches()
	elseif CH == 6 then wrapper_secureRun()
	elseif CH == 7 then MENU_about()
	elseif CH == 8 then
		gg.setVisible(true)
		os.exit(print("[+] Script quit safely."))
	end
	CH = nil
end
function MENU_about()
	local CH = gg.choice({
		"__about__",
		"Features",
		"License",
		"Credits",
		"__back__"
	},nil,"ABJ4403's Lua toolbox "..cfg.VERSION)
	if CH == 1 then
		gg.alert("ABJ4403's Lua Toolbox v"..cfg.VERSION..[[ © 2022-2023
Manage your Lua scripts on the go!

Why did i make this?
Just to make my life (maybe yours too) easier. and not having to install other proprietary APKs, executables, or even proprietary decryptor/encryptor that can only do one thing and its worst at the same time (eg: PG Encrypt, but no way to decrypt it in the same place, and vice versa. And also there's lots of proprietary gg Lua script out there. maybe you want to clean its garbage code so it can run faster? or run in in secure isolated environment so you can have a peace of mind knowing the files on your phone wont get removed by mallicious `os.remove` API call, or overwriting your files using `io.open/write/read` API call, or executing mallicious commands using `os.execute` API, or you dont want your data to get stolen using `gg.makeRequest` API? Maybe you also wanted to encrypt the script in the correct way because you wanted to share a script, but also realized that your script is too much risky to share to public because you dont want bad cheater (aka. the abuser) uses too much out of your script to hurt other online players? Or you need that little extra tiny SPEED by precompiling the source script and removing its hidden garbage code too.

I created this under 24 hour (on a phone btw!) as a challenge :D So it would be really appreciated if you can contribute to LuaTools GitHub repository (once the script has been open-sourced: https://github.com/ABJ4403/LuaTools) or give a star to my project on GitHub. or simply credit my work (by not removing mentions about me and others in this script :) Thank you :D
]]) MENU_about()
	elseif CH == 2 then gg.alert([[Features:
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
+ Remove BigLASM (untested, because i got no real example to test against).]]) MENU_about()
	elseif CH == 3 then gg.alert("License (doesn't apply for an early development version for abuse reason):".."\nThis program is free software: you can redistribute it and/or modify\nit under the terms of the GNU General Public License as published by\nthe Free Software Foundation, either version 3 of the License, or\n(at your option) any later version.\n\nThis program is distributed in the hope that it will be useful,\nbut WITHOUT ANY WARRANTY; without even the implied warranty of\nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the\nGNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License\nalong with this program.	If not, see https://gnu.org/licenses"..[[VirtGG License (proprietary for an early development version for abuse reason):
VirtGG © 2022-2023 ABJ4403, End User License Agreement.
You are allowed to:
- Use it in a respectful manner and good intentions.
You are NOT ALLOWED TO:
- Redistribute the code.
- Reverse-engineer the code.
- Include it in your project.
- Using the name "VirtGG".
All rights reserved.]]) MENU_about()
	elseif CH == 4 then gg.alert("Credits:\n• ABJ4403 - Original creator.\n• Veyron, HBXVPN - Obfuscation codes.\n• ??? - For some Script Compiler 3.7 code.\n• SwinXTools - for Remove LASM Block deobfuscation codes.\n• Daddyaaaaaaa - for Remove blocker 1 deobfuscation codes.\n• LuaGGEG, Angela, MafiaWar - for Remove BigLASM code.") MENU_about()
	elseif CH == 5 then CH = nil MENU() end
end

function wrapper_encryptLua()
	local CH = gg.prompt(
	{
		'📂️ Input File (make sure the extension is .lua):',
		'🔀️ Encrypt strings (Quirky)',
		'🔀️ Encrypt table queries (rarely quirky)',
		'🔐 ️Password:',
		'🔐️ Only ask password for once',
		'🗓️ Script Expiry Date (in YYYYMMDD format)',
		'⚙️ GG package name',
		'⚙️ GG target package name',
		'⚙️ GG version requirement',
		'⚙️ Minimum GG build version requirement',
		'⚙️ Allow newer versions (only works with build number)',
		'===== ADVANCED OPTIONS: =====\n\n\n\n\n💬️️ Promotional text (eg. Follow, Sub to YT channel), shown in Lua binary',
		'💬️️ Ask password:',
		'💬️️ Wrong password:',
		'💬️️ Target Package Invalid:',
		'💬️️ Expired message:',
		'💬️️ Denied packages:',
		'💬️️ Wrong GG Version:',
		'💬️️ GG Version below:',
		'💬️️ Hook Detected:',
		'💬️️ Illegal Modification:',
		'💬️️ Log Detected:',
		'💬️️ Renamed:',
		'💬️️ Warn Value Peeking:',
	},
	{
		cfg.fileChoice,
		cfg.obfModSettings.encryptStrings,
		cfg.obfModSettings.encryptTables,
		cfg.obfModSettings.scriptPW,
		cfg.obfModSettings.savePW,
		cfg.obfModSettings.scriptExpiry,
		cfg.obfModSettings.ggPkg,
		cfg.obfModSettings.appPkg,
		cfg.obfModSettings.minGGVer,
		cfg.obfModSettings.minGGBuildVer,
		cfg.obfModSettings.allowNewGGBuildVer,
		--
		cfg.obfModSettings.text.promoteYourself,
		cfg.obfModSettings.text.inputPass,
		cfg.obfModSettings.text.failInvalidPW,
		cfg.obfModSettings.text.failAppPkgInvalid,
		cfg.obfModSettings.text.failDatePassed,
		cfg.obfModSettings.text.failDeniedPkgs,
		cfg.obfModSettings.text.failGGPkgInvalid,
		cfg.obfModSettings.text.failGGVerBelow,
		cfg.obfModSettings.text.failHookDetected,
		cfg.obfModSettings.text.failIllegalMod,
		cfg.obfModSettings.text.failLogDetected,
		cfg.obfModSettings.text.failRenamed,
		cfg.obfModSettings.text.warnPeeking,
	},
	{
		'file',
		'checkbox',
		'checkbox',
		'text',
		'checkbox',
		'text',
		'text',
		'text',
		'text',
		'text',
		'checkbox',
		--
		'text',
		'text',
		'text',
		'text',
		'text',
		'text',
		'text',
		'text',
		'text',
		'text',
		'text',
		'text',
		'text',
	}
	);
	if CH and CH[1] then
		gg.toast("Encrypting, Please wait... this will take maximum of couple seconds")
		cfg.fileChoice = CH[1]:gsub(".lua$",'')
		cfg.obfModSettings.encryptStrings = CH[2]
		cfg.obfModSettings.encryptTables = CH[3]
		cfg.obfModSettings.scriptPW = CH[4]
		cfg.obfModSettings.savePW = CH[5]
		cfg.obfModSettings.scriptExpiry = CH[6]
		cfg.obfModSettings.ggPkg = CH[7]
		cfg.obfModSettings.appPkg = CH[8]
		cfg.obfModSettings.minGGVer = CH[9]
		cfg.obfModSettings.minGGBuildVer = CH[10]
		cfg.obfModSettings.allowNewGGBuildVer = CH[11]
		--
		cfg.obfModSettings.text.promoteYourself = CH[12]
		cfg.obfModSettings.text.inputPass = CH[13]
		cfg.obfModSettings.text.failInvalidPW = CH[14]
		cfg.obfModSettings.text.failAppPkgInvalid = CH[15]
		cfg.obfModSettings.text.failDatePassed = CH[16]
		cfg.obfModSettings.text.failDeniedPkgs = CH[17]
		cfg.obfModSettings.text.failGGPkgInvalid = CH[18]
		cfg.obfModSettings.text.failGGVerBelow = CH[19]
		cfg.obfModSettings.text.failHookDetected = CH[20]
		cfg.obfModSettings.text.failIllegalMod = CH[21]
		cfg.obfModSettings.text.failLogDetected = CH[22]
		cfg.obfModSettings.text.failRenamed = CH[23]
		cfg.obfModSettings.text.warnPeeking = CH[24]
		encryptLua()
		print("[✔] Finished encrypting "..cfg.fileChoice.."!\n[+] Input File: "..cfg.fileChoice..".lua\n[+] Output File: "..cfg.fileChoice..".enc.lua")
		gg.toast("[✔] Encryption complete.")
	end
end
function wrapper_compileLua()
	-- Ask user for file...
	local CH = gg.prompt({
		'📂️ Input File (make sure the extension is .lua):',
		'Strip debugging symbol (not recommended)',
		'Preserve namespaces',
		'Decompile (TODO-LoPrio,Waiting)'
	},{cfg.fileChoice,false,true,false},{'file','checkbox','checkbox','checkbox'});
	if CH and CH[1] then
		gg.toast("Compiling, Please wait... this will take maximum of couple seconds")
		CH[1] = CH[1]:gsub(".lua$",'')
		cfg.fileChoice = CH[1]
		compileLua(".luac",CH[2],CH[3])
		print("[✔] Finished Compiling "..CH[1].."!\n[+] Input File: "..CH[1]..".lua\n[+] Output File: "..CH[1]..".luac")
		gg.toast("Compiling complete.")
	end
end
function wrapper_luacAssembly()
	-- Ask user for file...
	local CH = gg.prompt({
		'📂️ Input File (make sure the extension is either .luac/.lasm):',
		'Assemble'
	},{cfg.fileChoice,false},{'file','checkbox'});
	if CH and CH[1] then
		CH[1] = CH[1]:gsub("%.luac$",''):gsub("%.lasm$",'')
		if CH[2] == true then
			gg.toast("Assembling, please wait... this may take couple seconds")
			cfg.fileChoice = CH[1]
			assembleLua(false)
			print("[✔] Finished Assembling "..CH[1].."!\n[+] Input File: "..CH[1]..".lasm\n[+] Output File: "..CH[1]..".luac")
			gg.toast("Assembling complete.")
		else
			gg.toast("Disassembling, please wait... this may take couple seconds")
			cfg.fileChoice = CH[1]
			disassembleLua('.luac',false)
			print("[✔] Disassembled "..CH[1].."!\n[+] Input File: "..CH[1]..".luac\n[+] Output File: "..CH[1]..".lasm")
			gg.toast("Disassembling complete.")
		end
	end
end
function wrapper_fixLuacHeader()
	-- Ask user for file...
	local CH = gg.prompt({'📂️ Input File (make sure the extension is .enc.lua, BTW i recommend reassemble the script instead of fixing the header):'},{cfg.fileChoice},{'file'});
	if CH and CH[1] then
		gg.toast("Fixing Lua header, Please wait...\nWarning: still in experimentation phase")
		cfg.fileChoice = CH[1]:gsub(".enc.lua$",'')
		modFileHeader('LuaFixHeader')
		gg.toast("Lua header fixed.")
	end
end
function wrapper_patches()
	-- Ask user for file...
	local CH = gg.prompt({
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
		cfg.fileChoice,
		false,true,false,
		false,false,false,
		false,false
	},{
		'file',
		'checkbox','checkbox','checkbox',
		'checkbox','checkbox','checkbox',
		'checkbox','checkbox'
	});
	if CH and CH[1] then
		isAsmFile = CH[1]:match('.lasm$')
		if isAsmFile then
			CH[1] = CH[1]:gsub(".lasm$",'')
		else
			CH[1] = CH[1]:gsub(".enc.lua$",'')
		end


		gg.toast("Running selected operations... 1/10")
		cfg.fileChoice = CH[1]
		if CH[2] and not isAsmFile then removeBigLasm() print("[✔] BigLASM Removed!")end

 -- Assembly Patching (dissasemble if luac,read assembly,patch for each,write changes to assembly,assemble back)
		gg.toast("Running selected operations... 1.3/10")
		if isAsmFile then
			print('[i] Lua Assembly file format detected, patching assembly files without recompiling...')
			DATA = io.readFile(cfg.fileChoice..".lasm")
		else
			DATA = disassembleLua('.enc.lua',true)
		end
		gg.toast("Running selected operations... 1.75/10") patchAssembly("EssentialMinify")

	--Make sure the 2nd argument of `patchAssembly(file,patchName)` is also on `deobfMod[patchName]` or crashed.
		io.writeFile(cfg.fileChoice..".dbg.lasm",DATA) -- debug lol
		if CH[8] then gg.toast("Running selected operations... 2/10") patchAssembly("selfDecrypt") print("[✔] Self decrypted! (some)")end
		if CH[3] then gg.toast("Running selected operations... 3/10") patchAssembly("RemoveGarbage") print("[✔] Garbages removed!")end
		if CH[4] then gg.toast("Running selected operations... 4/10") patchAssembly("RemoveHideCodes") print("[✔] Hide codes removed!")end
		if CH[5] then gg.toast("Running selected operations... 5/10") patchAssembly("RemoveLasmBlock") print("[✔] LasmBlock Removed!")end
		if CH[6] then gg.toast("Running selected operations... 6/10") patchAssembly("RemoveBlocker1") print("[✔] Blockers patched!")end
		if CH[7] then gg.toast("Running selected operations... 7/10") patchAssembly("RemoveNonsenses") print("[✔] Removed nonsenses!")end
	--8
		if CH[9] then gg.toast("Running selected operations... 8/10") patchAssembly("RemoveSWATChunkProtector") print("[✔] Removed SWAT chunk!")end

		gg.toast("Running selected operations... 9.25/10")
		io.writeFile(cfg.fileChoice..".lasm",DATA)
		gg.toast("Running selected operations... 9.5/10")
		if isAsmFile then print('[i] Lua Assembly file format detected, patching assembly files without recompiling...') else assembleLua(true) end
		gg.toast("Running selected operations... 9.75/10")

 -- Completed
		print("\n[+] Input File: "..cfg.fileChoice..".enc.lua\n[+] Output File: "..cfg.fileChoice..".luac")
		gg.toast("Operation completed!")
	end
end
function wrapper_secureRun()
	local opts = gg.prompt({
		"📂️ Script:", -- 1
		"📂️ Wrapper script (commonly used for other modifications):", -- 2
		"❌️ Disable mallicious functions", -- 3
		"🛡️ Run security tests (if 3rd option enabled)", -- 4
		"⚠️ Exit if security tests fail (if 3rd + 4th option enabled)", -- 5
		"📜️ Dump function calls", -- 6
		"📜️ Dump load calls", -- 7
		"📜️ Dump input strings (commonly used to extract password, leave blank to disable)", -- 8
		"🖊️ GG Version", -- 9
		"🖊️ GG Version int", -- 10
		"🖊️ GG Build", -- 11
		"🖊️ GG Package", -- 12
		"🖊️ GG Target Package", -- 13
		"📜️ Minimum size for log call `load()`:", -- 14
		"📜 Verbose log (TODO)", -- 15
		"📜 Quieten log (TODO)", -- 16
		"📜 Dump log (TODO)", -- 17
		"📜 Print log (TODO)", -- 18
	},{
		cfg.fileChoice, -- 1
		nil, -- 2
		true, -- 3
		true, -- 4
		true, -- 5
		false, -- 6
		false, -- 7
		false, -- 8
		gg.VERSION, -- 9
		gg.VERSION_INT, -- 10
		gg.BUILD, -- 11
		gg.PACKAGE, -- 12
		gg.getTargetPackage(), -- 13
		400, -- 14
		false, -- 15
		false, -- 16
		cfg.scriptPath.."/ScriptLog_"..os.date'%d.%m.%Y_%H.%M.%S'..".log", -- 17
		true, -- 18
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
		"number", -- 11
		"text", -- 12
		"text", -- 13
		"number", -- 14
		"checkbox", -- 15
		"checkbox", -- 16
		"text", -- 17
		"checkbox", -- 18
	})
	if opts and opts[1] then
		secureRun({
			targetScript=opts[1],
			wrapScript=opts[2],
			disableMalFn=opts[3],
			runTests=opts[4],
			exitIfTestsFail=opts[5],
			dumpCalls=opts[6],
			dumpLoadCalls=opts[7],
			dumpInputStr=opts[8],
			ggVer=opts[9],
			ggVerInt=opts[10],
			ggVerBuild=opts[11],
			ggPkgName=opts[12],
			ggTargetPkgName=opts[13],
			minLogSizeLoad=opts[14],
			verboseLog=opts[15],
			quietLog=opts[16],
			dumpLogTo=opts[17],
			printLog=opts[18],
		})
	end
end

function encryptLua()
	-- Wrap the decryptor script
	print("[i] Wrapping decryptor...")
	cfg.obfModSettings.pwHash = randstr() -- separate XOR key for password (TODO: but we need to implement another decryptor..., or change the whole decryptor)
	cfg.enc = cfg.enc(cfg.obfModSettings.pwHash) -- add key
	cfg.dec_wrap = "local function decode"..cfg.dec_wrap(cfg.obfModSettings.pwHash).." end\n"

	-- Put the input file content to buffer
	print("[i] Reading file contents to buffer...")
	collectgarbage()
	DATA = io.readFile(cfg.fileChoice..'.lua')

	if cfg.obfModSettings.encryptStrings then
		print("[i] Encrypting strings...")
		collectgarbage()
		DATA = DATA:gsub('os%.exit%(%)','os.exit()print("[AntiExitDetect] Anti exit detected, forcing script to crash")return(nil)()') -- force exit
		local all_string = {
			'%"%\\"([^\n]-)%\\"%"',
			"%'%\\'([^\n]-)%\\'%'",
			'%"([^\n]-)%"',
			"%'([^\n]-)%'",
			'%[===%[(.-)%]===%]',
			'%[=%[(.-)%]=%]',
			'%[%[(.-)%]%]',
		}
		for i=1,#all_string do
			DATA = string.gsub(DATA,all_string[i],cfg.enc) -- untested
		end
	--DATA = DATA:gsub('%(decode%((.-)%)%)',function(i)return'('..cfg.enc(i)..')'end) garbage?
	--DATA = DATA:gsub('%[([%[=]*)(.-)([%]=]*)%]',function(i)return'('..cfg.enc(i)..')'end) buggy
	end

	if cfg.obfModSettings.encryptTables then
	-- below can be buggy (in case of function decode([==[ENCRYPTED]==])[CONTENT]end.
	-- replace any `function bla.bla()` > `bla.bla = function()` to prevent such bug from occuring
		print("[i] Encrypting table functions...")
		print(" |  Developer note: please make sure your script doesn't --")
		print(" |  have any of the syntaxes like `function a.b()...end`")
		print(" |  The encryptor had a known bug where it throws error when compiling")
		print(" |  an obfuscated script with the said code")
		collectgarbage()
		for _,v in ipairs{"gg","io","os","string","math","table","debug","bit32","utf8"} do
			print(" |  "..v)
			DATA = DATA:gsub(v.."%.(%a+)%(",function(s)return v..'['..cfg.enc(s)..']('end)
		end
	end

	print("[i] Wrapping main function to mainPayload()...")
	collectgarbage()
	DATA = "local function mainPayload()local gg,os,io=gg,os,io "..DATA.."\nend mainPayload()"

	print("[i] Configuring Obfuscations...")
	collectgarbage()
	for i in pairs(obfMod) do
		obfMod[i] = obfMod[i]()
	end

	-- Append obfuscation module before script starts, and put decryptor at very beginning (applied in reverse order)
	print("[i] Applying Obfuscations... (sorted Z-A/bottom-top)")
	collectgarbage()
	for i,v in pairs_sorted(obfMod) do
		print(" |  "..(i):gsub('^[A-Z]_',''))
		DATA = 'do '..v..' end\n'..DATA
	end
	print('———')
	DATA = cfg.dec_wrap..DATA

	-- Encryption done, "Compile" the file (in a hacky way lol)
	cfg.enc = enc_wrap_XOR -- Restore original function
	collectgarbage()
	io.writeFile(cfg.fileChoice..".debug.lua",DATA) -- debugging lol
	compileLua(".enc.lua",true,false)

	-- Post-compile. Corrupt the Lua file header to prevent unluac from decompiling
	modFileHeader('LuaBreakHeader')
end
function decryptLua()
	DATA = io.readFile(cfg.fileChoice..'.enc.lua')

	local dec_XOR_RandomKey=function(iv,key)local i,iv_,key_=0,{string.byte(iv,0,-1)},{string.byte(key,0,-1)} r=iv:gsub(".",function()i=i+1 return string.char(iv_[i]~key_[i])end)return r end

	DATA = DATA:gsub('%(decode%(%[==%[(.-)%]==%],"(.-)"%)%)',function(i)return'"'..cfg.enc(i)..'"'end)
	DATA = DATA:gsub([['gg%[decode%(%[==%[(.-)%]==%],"(.-)"%)%]%(']],function(i)return'gg.'..dec_XOR_RandomKey(i)..'('end)

	io.writeFile(cfg.fileChoice..".dec.lua",DATA)
end
function compileLua(fileExt,stripDebugSymbols,useNames)
	print("[i] Compiling "..cfg.fileChoice.."...")
	DATA,tmp = load(DATA or io.readFile(cfg.fileChoice..'.lua'))
	stripDebugSymbols = stripDebugSymbols or false
	useNames = useNames or true
	if tmp or not DATA then
		gg.setVisible(true)
		gg.toast("[!] Error occured!")
		print("[!] Error occured. There's something wrong with your script or this tool configuration.\n[!] try to enable debug mode, redo again, check and run "..cfg.fileChoice..".debug.lua to find out why")
		if tmp then print("[!] "..tmp.."\n==========\n")end
	end
	io.writeFile(cfg.fileChoice..fileExt,string.dump(DATA,stripDebugSymbols,useNames)) -- 3rd arg of strDump: use_names: A boolean value that specifies whether or not to include local variable names in the dumped function. If true, the resulting string will include local variable names. If false (default), the resulting string will not include local variable names.
end
function decompileLua(fileExt,stripDebugSymbols)
	print("[i] Decompiling "..cfg.fileChoice.."...")
	DATA = DATA or io.readFile(cfg.fileChoice..'.lua')
	if tmp or not DATA then print("[!] Error occured. There's something wrong with your script or this tool configuration.\n[!] "..tmp.."\n==========\n") end
end
function assembleLua(stripDebugSymbols)
	print("[i] Assembling "..cfg.fileChoice.."...")
	local fileBuffer,err = loadfile(cfg.fileChoice..".lasm")
	if err or not fileBuffer then
		print("[!] Failed to load lua assembly, more information:\n\n",err)
	end
	io.writeFile(cfg.fileChoice..".luac",string.dump(fileBuffer,stripDebugSymbols))
end
function disassembleLua(fileExt,stripDebugSymbols)
	print("[i] Disassembling "..cfg.fileChoice.."...")
	fileExt = fileExt or ".luac"
	stripDebugSymbols = stripDebugSymbols or false

	local fileBuffer,err = loadfile(cfg.fileChoice..fileExt)
	if err or not fileBuffer then
		print("[!] Failed to load lua script, more information:\n\n",err)
	end
--Strip the file debug symbols (with string.dump's 2nd argument)
--then do the disassemble
--gg.internal9("OutFile","","Hello") ??
	gg.internal2(load(string.dump(fileBuffer,stripDebugSymbols)),cfg.fileChoice..".lasm")
	return io.readFile(cfg.fileChoice..".lasm")
end
function modFileHeader(headerTypes)
	local DATA = io.open(cfg.fileChoice..".enc.lua",'r+')
	DATA:seek('set')
--Grab the first 4 bytes and check if the header is a valid Lua header
	local sigCur = DATA:read(4)
	local sigFix
	if sigCur ~= '\x1BLua' then
		print('[!] The input file is not a Lua binary script (expected file header: "1B 4C 75 61")')
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
				DATA:seek('set') io.writeFile(cfg.fileChoice..'.bak.lua',DATA:read('*a'))
				print("[✔] Fixed Lua header!\n[+] Modified File: "..cfg.fileChoice..".enc.lua\n[+] Backup File: "..cfg.fileChoice..".bak.lua")
			end
		end
		DATA:seek('set',4)
		DATA:write(sigFix)
	end
	DATA:close()
	DATA = nil
end
function removeBigLasm()
-- Read file, remove the BigLASM, load() and dump() it, and write to output
	collectgarbage()
	io.writeFile(cfg.fileChoice..".enc.lua",string.dump(
		load(
			io.readFile(cfg.fileChoice..'.enc.lua'):gsub(
				'\4\17\39\0\0'..('\0\99\53\131\82\116\66\115\67\53'):rep(1e3),
				'\4\1\0\0\0' -- can also be 4,9,0,0,0 sequence
			):gsub(
				'\4\17\39\0\0'..('\0\99\53\66\82\116\66\115\67\53'):rep(1e3),
				'\4\1\0\0\0'
			):gsub(
				'\4\17\39\0\0'..('\0'):rep(1e3),
				'\4\1\0\0\0'
			):gsub(
				'\4\17\39\0\0'..('\72'):rep(1e3),
				'\4\1\0\0\0'
			):gsub(
				'\4\17\39\0\0'..('\90'):rep(1e3),
				'\4\1\0\0\0'
			):gsub(
				'\4\17\39\0\0'..('\0a'):rep(1e3),
				'\4\1\0\0\0'
			):gsub(
				('\0\99\53\151\82\116\66\115\67\53'):rep(1e3),
				'\4\1\0\0\0'
			):gsub(
				('\0\99\53\66\82\116\66\115\67\53'):rep(1e3),
				'\4\1\0\0\0'
			):gsub(
				('\0\99\145\151\23\130\37\115\67\53'):rep(1e3),
				'\4\1\0\0\0'
			):gsub(
				('\0\103\53\151\82\116\70\115\67\69'):rep(1e3),
				'\4\1\0\0\0'
			):gsub(
				('\48\120\48\48'):rep(1e3),
				'\4\1\0\0\0'
			):gsub(
				('\48\120\114'):rep(1e3),
				'\4\1\0\0\0'
			)--[[:gsub(
				'\4\17\39\0\0'..('.').rep(1e3),
				'\4\9\0\0\0'
			)]]
		),
		true,false
	))
end
function patchAssembly(patchName) -- make sure DATA is loaded first before running the patcher
	collectgarbage()
	local r
	if type(deobfPatch[patchName]) == 'table' then -- patchset
		for j=1,#deobfPatch[patchName] do
			gg.toast("Applying "..patchName.." patch... ("..j.."/"..#deobfPatch[patchName]..")")
			DATA,r = DATA:gsub(deobfPatch[patchName][j][1],deobfPatch[patchName][j][2])
			print(patchName.." "..j.." Applied! replaced: "..r)
		end
	elseif type(deobfPatch[patchName]) == 'function' then -- function (allows blackbox scripts)
		DATA = deobfPatch[patchName](DATA)
		print(patchName.." Applied!")
	end
end
function secureRun(opts)
	cfg.fileChoice = opts.targetScript:gsub(".lua$",'')
	local ScriptResult,err = loadfile(opts.targetScript) -- load target script
	if not ScriptResult or err then -- Error detection
		gg.toast("[!] Failed to load the script, see print log for more details.")
		return print("[!] Failed to load the script, more details:\n\n",err)
	end
	if opts.wrapScript ~= '' then -- if wrapper script given, load it
		local ScriptWrapper,err = loadfile(opts.wrapScript) -- load wrapper script
		if not ScriptWrapper or err then -- Error detection
			gg.toast("[!] Failed to load the wrapper script, see print log for more details.")
			print("[!] Failed to load the wrapper script, more details:\n\n",err)
		end
	end
	gg.toast('[i] This script is still WIP, (for now) the script will be executed with basic modification')
	--if not gg.alert("[!] The script will be executed, if you sure to continue, press OK") then return end

	do -- Prepare isolated container
		gg.toast("[i] Preparing isolated container...")
		print("[i] Preparing isolated container...")
		local Repl

		do -- Prepare fricked variables (contain it so it doesnt get leaked and be read by script by indexing _G)



			Repl = {
				["print"]=print,
				["io"]=table.copy(io),
				["os"]=table.copy(os),
				["gg"]=table.copy(gg),
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
			local origRef = {} -- original reference, queried using fake function, returns real ones (mostly used by fake debug thing).
			local ContainmentFiles = {}
			ContainmentFiles.pwd = cfg.scriptPath
			ContainmentFiles.containmentdir = ContainmentFiles.pwd.."/ContainmentDir"
			ContainmentFiles.luascript = ContainmentFiles.containmentdir.."/ContainedLua.lua"
			ContainmentFiles.txtfile = ContainmentFiles.containmentdir.."/ContainedText.txt"
			ContainmentFiles.dumplogfile = ContainmentFiles.pwd.."/ScriptLog_"..os.date'%d.%m.%Y_%H.%M.%S'..".log"
			gg.getFile = (function()local _=ContainmentFiles.luascript return function()return _ end end)() -- fix bug
			gg.VERSION = opts.ggVer
			gg.VERSION_INT = opts.ggVerInt
			gg.BUILD = opts.ggVerBuild
			gg.PACKAGE = opts.ggPkgName
			if opts.disableMalFn then -- Disable mallicious functions
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
					if opts.dumpCalls then Repl.print("[Dump] gg.makeRequest("..uri..","..Repl.table.tostring(header)..","..Repl.table.tostring(data)..")") end
					return {
						url=uri,
						requestMethod=nil,
						code=300,
						message="Success",
						headers={
							["cache-control"] = "max-age=1",
							["content-encoding"] = "br",
							["content-type"] = "text/html; charset=UTF-8",
							["date"] = "Sun, 01 Jan 2023 00:00:00 GMT",
							["expect-ct"] = "max-age=0",
							["expires"] = "Sun, 01 Jan 2023 00:00:00 GMT",
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
			--TODO: voiding IO variable caused failure on some script
				os.date = function(dateFormat)
					if dateFormat == "%Y%m%d" then return "19991230" end
					return Repl.os.date(dateFormat)
				end
				os.execute = function(cmd)
					if type(cmd) ~= 'string' then cmd = 'MalformedType:'..type(cmd) end
					Repl.print('[Warn] Intercepted os.execute("'..cmd..'")')
				end
				os.remove = function(path)
					if type(path) ~= 'string' then path = 'MalformedType:'..type(path) end
					Repl.print('[Warn] Intercepted os.remove("'..path..'")')
				end
				io.open    = function(file,opmodes) -- only log because orig io.open returns file/type userdata
					if not file then return nil end
					Repl.print('[Malicious] something tries to open "'..file..'" with opmode '..tostring(opmodes))
				--return Repl.io.open(ContainmentFiles.txtfile,"r") cant do this because stuckk on loop
					return Repl.io.open(file,opmodes)
				end
				io.close   = void("io.close")
				io.input   = void("io.input")
			--io.input    = function(...)
				--Repl.print('[Malicious] io.input',...)
				--return Repl.io.input(ContainmentFiles.txtfile,"r")
				--return Repl.io.input(...)
			--end
				io.output  = void("io.output")
				io.read  	 = void("io.read")
			--io.read    = function(...)
				--Repl.print('[Malicious] io.read',...)
				--return Repl.io.read(ContainmentFiles.txtfile,"r")
				--return Repl.io.read(...)
			--end
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
					print("debug.gethook")
					return nil, 0
				end
				debug.getinfo = function(f,a,b) -- prevent anti-hook
					print("debug.getinfo")
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
				debug.getlocal = function(a,b)
					print("debug.getlocal")
				--prevent another anti-hook
					local name,value = Repl.debug.getlocal(a,b)
					--local name,value = Repl.debug.getlocal(true)
					--name = name or string.char(({math.random(65,90),math.random(97,122)})[math.random(1,2)]):rep(math.random(1,10))
					--value = value or string.char(({math.random(65,90),math.random(97,122)})[math.random(1,2)]):rep(math.random(1,10))
					return name,value
				end
				debug.sethook = function(f,a,b) -- prevent anti-hook
					print("debug.sethook")
					return
				end
				debug.traceback = function(m,a,b) -- prevent log spam
					local res = Repl.debug.traceback(m,a,b)
					print("debug.traceback",m,a,b,'->',res)
					--if m then m = m.."\n" else m = "" end
					--return m.."stack traceback:\n	"..ContainmentFiles.luascript..": in main chunk\n	[Java]: in ?"
					return res
				end
				string.rep = function(s,a) -- reduce log spam size
					print("string.rep")
					if a > 99 then a = 2 end
					return Repl.string.rep(s,a)
				end
				print = function(...)
					Repl.print("[Script] ",...)
				end

			--others





			--Prevent possible errors caused by modifications
				string.sub = function(str,from,to)
					if type(str) == 'string' and type(from) == 'number' and type(to) == 'number' then
						return Repl.string.sub(str,from,to)
					end
					return ''
				end
				string.match = function(str,match)
					if type(str) == 'string' and type(match) == 'string' then
						return Repl.string.match(str,match)
					end
					return ''
				end
				os.exit=function()
					local CH = gg.alert("The script tries to exit, are you sure you want to exit?","Yes","No, dont ask again","No")
					if CH == 1 then Repl.os.exit()
					elseif CH == 2 then os.exit=function()end end
				end
			end
			if opts.runTests then -- Run security tests
				Repl.print('[i] Running security tests...')
				if os.execute("echo os.execute test passed") == "os.execute passed" then Repl.print("OS.EXECUTE INTERCEPT TEST FAILED, CONTINUE AT YOUR OWN RISK!") end
				os.remove(ContainmentFiles.txtfile..".sampleremove")
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
			if opts.dumpCalls then -- Dump function calls
				gg.require=function(ver,build)
					if opts.dumpCalls then Repl.print('[Dump] gg.require('..ver..','..build..')') end
					return nil
				end
				gg.isVisible=function()
					gg.sleep(1e3)
					return Repl.gg.isVisible()
				end
				gg.alert=function(t,o1,o2,o3)
					Repl.print('[Dump] gg.alert('..t..')')
					return Repl.gg.alert(t,o1,o2,o3)
				end
				gg.toast=function(text,fastmode)
					fastmode = fastmode or true
					Repl.print('[Dump] gg.toast('..text..')')
					return Repl.gg.toast(text,fastmode)
				end
				gg.prompt=function(text,placeholder,types)
					local tmp = {}
					if type(text) == "table" then
						for k,v in pairs(text) do
							if (types and types[k] == 'checkbox') then
								if (placeholder and placeholder[k]) then
									print('[gg.prompt] '..v..' ['..placeholder[k]..']')
								else
									print('[gg.prompt] '..v)
								end
							end
						end
					end
					return Repl.gg.prompt(text,placeholder,types)
				end
				gg.getLocale=function()
					if opts.dumpCalls then Repl.print('[Dump] gg.getLocale()') end
					return "en_US"
				end
				gg.getTargetInfo=function()
					return nil
				end
				gg.getTargetPackage=function()
					return "com.bruh"
				end
				gg.choice=function(items,selected,msg)
					Repl.print('[gg.choice] '..msg)
					if type(items) == "table" then
						i = 1
						for k,v in pairs(items) do
							if i == selected then
								Repl.print('[Choice] •'..k..':'..v)
							else
								Repl.print('[Choice]  '..k..':'..v)
							end
							i = i + 1
						end
					end
					return Repl.gg.choice(items,selected,msg)
				end
				gg.multiChoice=function(items,selected,msg)
					Repl.print('[gg.choice] '..msg)
					if type(items) == "table" then
						i = 1
						for k,v in pairs(items) do
							if (selected and selected[k]) then
								Repl.print('[Choice] ✓'..k..':'..v)
							else
								Repl.print('[Choice]  '..k..':'..v)
							end
							i = i + 1
						end
					end
					return Repl.gg.multiChoice(items,selected,msg)
				end
				gg.searchNumber=function(n,t,e,s,f,o,l,...)
					n=n or ""
					t=t or gg.TYPE_AUTO
					s=s or gg.SIGN_EQUAL
					if type(n) == "table" then return nil end -- Prevent Log Spam
					if opts.dumpCalls then Repl.print("[Dump] gg.searchNumber("..n..","..parseGGVarTypes("TYPE",t)..","..parseGGVarTypes("SIGN",s)..")") end
					return Repl.gg.searchNumber(n,t,e,s,f,o,l,...)
				end
				gg.refineNumber=function(n,t,e,s,f,o,l,...)
					n=n or ""
					t=t or "nil"
					s=s or "nil"
					if type(n) == "table" then return nil end -- Prevent Log Spam
					if opts.dumpCalls then Repl.print("[Dump] gg.refineNumber("..n..","..parseGGVarTypes("TYPE",t)..","..parseGGVarTypes("SIGN",s)..")") end
					return Repl.gg.refineNumber(n,t,e,s,f,o,l,...)
				end
				gg.refineAddress=function(n,m,t,s,f,o,l,...)
					n=n or ""
					m=m or -1
					t=t or "nil"
					s=s or "nil"
					if opts.dumpCalls then Repl.print("[Dump] gg.refineAddress("..n..","..parseGGVarTypes("TYPE",t)..","..parseGGVarTypes("SIGN",s)..")") end
					return Repl.gg.refineAddress(n,m,t,s,f,o,l,...)
				end
				gg.getResults=function(c,a,b,d,e,f,t,...)
					local tbl = {}
					c = tonumber(c) or 0
					t = t or gg.TYPE_AUTO
					if opts.dumpCalls then Repl.print("[Dump] gg.getResults("..c..","..parseGGVarTypes("TYPE",t)..")") end
					return Repl.gg.getResults(c,a,b,d,e,f,t,...)
				end
				gg.setValues=function(t,...)
					if type(t) == "table" and t[1] and not t[1].flags then
						return Repl.print("[Dump] gg.setValues(Invalid table!)")
					end
					Repl.gg.setValues(t,...)
					for i=1,#t do
						if t[i] then t[i].address = string.format("%x",t[i].address) end
					end
					if opts.dumpCalls then Repl.print("[Dump] gg.setValues("..table.tostring(t)..")") end
					return true
				end
				gg.addListItems=function(t,...)
					if type(t) == "table" and t[1] and not t[1].flags then
						return Repl.print("[Dump] gg.addListItems(Invalid table!)")
					end
					Repl.gg.addListItems(t,...)
					for i=1,#t do
						if t[i] then t[i].address = string.format("%x",t[i].address) end
					end
					if opts.dumpCalls then Repl.print("[Dump] gg.addListItems("..table.tostring(t)..")") end
					return true
				end
				gg.editAll=function(v,t,...)
					v = v or ""
					t = t or gg.TYPE_AUTO
					if opts.dumpCalls then Repl.print("[Dump] gg.editAll("..v..","..parseGGVarTypes("TYPE",t)..")") end
					return Repl.gg.editAll(v,t,...)
				end
				gg.setRanges=function(r)
					r = r or gg.REGION_AUTO
					if opts.dumpCalls then Repl.print("[Dump] gg.setRanges("..parseGGVarTypes("REGION",r)..")") end
					return Repl.gg.setRanges(r)
				end
				gg.isPackageInstalled=function(p)
					p = tostring(p)
					if opts.dumpCalls then Repl.print("[Dump] gg.isPackageInstalled("..p..")") end
					return false
				end
			end
			if opts.dumpLoadCalls and opts.minLogSizeLoad ~= '' then -- Dump load calls

			end
			if opts.dumpInputStr then -- Dump input strings
				local pass = math.random(1000,9999)
				local f = io.open(ContainmentFiles.dumplogfile,'w')
				Repl.gg.alert('You chose dump input string option. Displays possible passwords. Works only if the plain password is in the code. On the offer to put password, type '..pass)
				local cache = {}
				cache[pass] = true
				Repl.debug.sethook(function()
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
			Repl.gg.toast("[i] Running script In isolated container...")
			Repl.print("[i] Running "..cfg.fileChoice.." In isolated container...\n==========\n\n")




		end
		do -- Prepare another Isolated container to run the script (prevents leaked outside/inside variables)
			local Repl,opts,CH,cfg = nil,nil,nil,nil -- prevent other value from getting accesed
			collectgarbage()
			if ScriptWrapper then ScriptWrapper()ScriptWrapper=nil end
			ScriptResult = ScriptResult()
		end
	 -- Cleanup some fricked variables
		for i,v in pairs(Repl)do _G[i]=v end
		Repl = nil
		print("\n\n==========\n\n")
		debug.sethook(nil,'',1)
		collectgarbage()
	end
	return print("[+] Clean exit ---\n",ScriptResult)
end
--————————————————————————————————--

--— Dependency & init ————————————--
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
pairs_sorted = function(t) -- A hacky way to loop tables in sorted order
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
logOutput = function(content,toPrint,toFile,verbosenessLevel)
	toPrint = toPrint or true
	toFile = toFile or false
	verbosenessLevel = verbosenessLevel or 6 -- Following Linux printk log rule
	if verbosenessLevel > cfg.logLevel then return end -- return if above an certain set level
	if toPrint then print(table.unpack(content)) end -- print if told so
	if toFile then print('[LogFile]',table.unpack(content)) end -- print if told so
end
--
cfg.fileChoice = cfg.scriptPath
while true do while not gg.isVisible()do gg.sleep(100)end gg.setVisible(false)MENU()end
--————————————————————————————————--

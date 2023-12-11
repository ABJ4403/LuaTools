--[[

	ABJ4403's LuaTools
	(C) 2022-2023 ABJ4403

	WARNING: Sharing this script in any encrypted form (either by self-encrypt, or encrypted by other tools) is violating GPL v3 license,
	and restricts users freedom of changing the hard-coded configuration.
	Any violation will result in DMCA Takedown Notice.

]]
--— Predefining stuff ————————————--
local gg,io,os = gg,io,os -- precache the usual call function (faster function call)
local tmp,CH,DATA = {} -- blank stuff for who knows...
local randstr = function(len,byteFrom,byteTo)
	local len=len or 8
	local byteFrom=byteFrom or 128
	local byteTo=byteTo or 255
	local e=""
	for i=1,len do
		e=e..string.char(math.random(byteFrom,byteTo))
	end
	return e
end
--XOR encryption
local xdenc_XOR = function(iv,key)local iv_,key_,i,stringChar={iv:byte(0,-1)},{key:byte(0,-1)},0,string.char local r=iv:gsub(".",function()i=i+1 return stringChar(iv_[i]~key_[(i%#key_)+1])end)return r end
local dec_wrap_XOR = (function(key)return'(iv)local iv,key,stringChar={iv:byte(0,-1)},{([==['..key..']==]):byte(0,-1)},string.char for i=1,#iv do iv[i]=stringChar(iv[i]~key[(i%#key)+1]) end return table.concat(iv)'end)
local enc_wrap_XOR = function(key)
	dec_wrap_XOR = dec_wrap_XOR(key)
	local key = {key:byte(0,-1)}
	return function(str)
		-- dont encrypt if nothing gets passed
		if type(str) ~= 'string' or str == '' then return [[""]] end
		str = {str:byte(0,-1)}
		for i=1,#str do
			str[i] = string.char(str[i] ~ key[(i % #key) + 1])
		end
		-- parenthesis around decode is to prevent parsing error in cases like: `return'a'` > `returndecode(..)`
		return '(decode([==['..table.concat(str)..']==]))'
	end
end
--————————————————————————————————--



--— Configuration ————————————————--
-- Allow user freedom of changing whatever they want
-- Please DO NOT encrypt this script, because we like to change configuration like below
-- if you encrypt this script, then you can't customize stuff here.
-- you will need a code editor (preferably the one that has syntax-highlighting & code-folding, like Acode), and Lua knowledge for customizing these stuff below...
local cfg = {
	VERSION = "2.6", -- you can ignore this, its just for defining script version :)
	enc = enc_wrap_XOR, -- useless anyway lol, handled on the bottom
	xdenc = xdenc_XOR, -- this means XOR Enc.. Dec..
	dec_wrap_factory = dec_wrap_XOR,
	scriptPath = gg.getFile():gsub('.lua$',''), -- strip the .lua for .conf and stuff,
	fileChoice = '/sdcard/Notes/test', -- dummy, replaced whenever any file is selected within the GUI
	debugMode = true,
	obfModSettings = {
		minGGVer = gg.VERSION, -- GG version required
		minGGBuildVer = gg.BUILD, -- minimal GG build version required
		allowNewGGBuildVer = true, -- whether to allow newer GG version or not (uses gg.BUILD variable only)
		ggPkg = "", -- what only gg package script will run
		appPkg = "com.android.calculator", -- what only target package script will run
		scriptExpiry = "20301111", -- YYYYMMDD order
		scriptPW = "__P@$$w0rd123__", -- script password
		stripAnnotations = false,
		savePW = true, -- when enabled, the hashed password (not the actual pw) will be exported to a file with '.lt.cfg' extension
		encryptStrings = false,
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
			failRenamed       = "[FileWatcher] Renaming detected! sorry but you need to rename the script back to:",
			yourFilename       = "your script name is: ",
			errLTCfgFile			= "[Auth] Error when trying to execute LuaTools configuration file:",
			promoteYourself   = "\tFollow me!\n\tGitHub: https://github.com/ABJ4403\n\tYouTube: https://youtube.com/@AyamGGoreng",
			inputPass         = "[Auth] Input Password:",
			warnPeeking       = "[NoPeek] Caught peeking values",
		}
	}
}
-- Put your obfuscation module here (sorted by name)
local obfMod = {
	A_EncryptorSignature = function()return "local _=[[\n\n——————————————————————————————————————————————————\n|\n|  🛡 Encrypted by ABJ4403's Lua encryptor v"..cfg.VERSION.." (https://github.com/ABJ4403/LuaTools)\n|  Features:\n|  + Simple, no bloat.\n|  + Free & Open-Source, Licensed under GPL v3\n|  + Modable.\n|  + Table/string encryption.\n|  + Fast (No arbitrary slowdown, great optimization, local variables, isolated obfuscator modules makes sure global variables not polluted).\n|  + Optional Hard-Password requirement (with XOR encryption, we can use the password itself as a decryption key :) TODO...\n|  + Respects both the author & end user.\n|\n|  If you trying to open this encrypted file,\n|  well uhh... GL to even decrypt this XD (if you do)\n|  Otherwise if you think this isn't safe, Don't worry, the encryptor is open-source :D\n|  Go to https://github.com/ABJ4403/LuaTools for the source code\n|\n——————————————————————————————————————————————————\n\n\n]]"end,
	B_PromoteYourself    = function()return "local _=[[\n\n"..cfg.obfModSettings.text.promoteYourself.."\n\n]]"end,
	C_RestrictGGVer      = function()
		local matcher,verTxt = 'gg.BUILD < GGPacBuildVer'
		if not cfg.obfModSettings.allowNewGGBuildVer then
			verTxt = 'version'
			matcher = matcher..' or gg.VERSION ~= GGPacVer'
		else
			verTxt = 'minimum version'
		end
		if cfg.obfModSettings.minGGVer ~= '' and cfg.obfModSettings.minGGBuildVer ~= '' then
		--TODO - BUG: when encrypting a script 2nd time with this mod, it throws an error that it tries to `gg.BUILD < GGPacBuildVer` (when decrypted returned a whole different unreadable garbage, i think its caused by cfg.enc not reconfigured)
			return 'local GGPacVer,GGPacBuildVer,verTxt='..cfg.enc(cfg.obfModSettings.minGGVer)..',tonumber('..cfg.enc(cfg.obfModSettings.minGGBuildVer)..'),"'..verTxt..'" if '..matcher..' then print("'..cfg.obfModSettings.text.failGGVerBelow..'")os.exit()end GGPacVer,GGPacBuildVer,verTxt=nil,nil,nil'
		end
	end,
--[[D_RestrictGGPkg      = function()
	if cfg.obfModSettings.ggPkg ~= '' then
		return 'local GGPkgNm="'..cfg.enc(cfg.obfModSettings.ggPkg)..'" if gg.PACKAGE ~= GGPkgNm then print("'..cfg.obfModSettings.text.failGGPkgInvalid..'")os.exit()end GGPkgNm=nil'
	end
end,]]
--[[E_RestrictAppPkg     = function()
	if cfg.obfModSettings.appPkg ~= '' then
		return 'local GGAppPkg="'..cfg.enc(cfg.obfModSettings.appPkg)..'" if gg.getTargetPackage() ~= GGAppPkg then print("'..cfg.obfModSettings.text.failAppPkgInvalid..'")return end GGAppPkg=nil'
	end
end,]]
	F_RestrictExpire     = function()
		if cfg.obfModSettings.scriptExpiry ~= '' then
			return 'local GGPacDtm='..cfg.enc(cfg.obfModSettings.scriptExpiry)..'if tonumber(os.date"%Y%m%d") > tonumber(GGPacDtm) then print("'..cfg.obfModSettings.text.failDatePassed..'")os.exit()end GGPacDtm=nil'
		end
	end,
	G_RestrictPkgs       = function()return 'for _,v in ipairs{"sstool.only.com.sstool","com.hckeam.mjgql"} do if gg.isPackageInstalled(v)or gg.PACKAGE == v then print("'..cfg.obfModSettings.text.failDeniedPkgs..'"..v)os.exit()end end'end,
	H_NoIllegalMod       = function()return 'if string.rep("a",2)~="aa" then print("'..cfg.obfModSettings.text.failIllegalMod..'")os.exit()end'end,
	I_NoRename           = function()return 'local origFileName,fileName="'..cfg.fileChoice:gsub('^/.+/','')..'.enc.lua",gg.getFile():gsub("^/.+/","")if fileName ~= origFileName then print("'..cfg.obfModSettings.text.failRenamed..' "..origFileName..". '..cfg.obfModSettings.text.yourFilename..'"..fileName)os.exit()end'end,
	J_AntiSSTool				 = function()return [[while nil do local i={}if(i.i)then;i.i=i.i(i)end end]]end,
	K_HBXVpnObf					 = function()return [[while nil do local obf_srE6={nil,-nil % -nil,nil,-nil,nil,nil % -nil,-nil % nil,-nil}if #obf_srE6<0 then break end if obf_srE6[#obf_srE6]<0 then break end if obf_srE6[-nil] ~= #obf_srE6 & ~obf_srE6 then obf_srE6[#obf_srE6]=obf_srE6[-nil]()end if #obf_srE6<nil then obf_srE6[#obf_srE6]=obf_srE6[-nil%nil]()end goto X1 if nil or 0 then return end::X0::obf_P3oU()::X1::function obf_P3oU()goto X2 if nil or 0 then return end::X3::obf_P3oU:_()::X2::goto X3 end goto X0 for i=1,0 do obf_srE6="TQUILA1"end for i=1,0 do if nil then obf_srE6="obf"end end if nil then if true then else goto obf_s4df end if nil then else goto obf_s4df end if nil then else goto obf_s4df end::obf_s4df::end end]]end,
	L_HookDetect				 = function()return 'local tmp if debug.getinfo(1).istailcall then print("'..cfg.obfModSettings.text.failHookDetected..'")os.exit()end for _,t in ipairs{gg,io,os,string,math,table,bit32,utf8}do if type(t) == "table" then for _,f in pairs(t)do if type(f) == "function" then tmp = debug.getinfo(f)if tmp.short_src ~= "[Java]" or tmp.source ~= "=[Java]" or tmp.what ~= "Java" or tmp.namewhat ~= "" or tmp.linedefined ~= -1 or tmp.lastlinedefined ~= -1 or tmp.currentline ~= -1 or tostring(f):match("function: @(.-):")then print("'..cfg.obfModSettings.text.failHookDetected..'")os.exit()end end end end end tmp=nil'end,
	M_Password           = function()
		if cfg.obfModSettings.scriptPW ~= '' then
		--base code only have askPw function
			local pwCode = 'askPw=function()CH=gg.prompt({"'..cfg.obfModSettings.text.inputPass..'"},nil,{"text"})if not CH or decode(CH[1])~=pwHash then print("'..cfg.obfModSettings.text.failInvalidPW..'")os.exit()end '
			if cfg.obfModSettings.savePW then
			--add pw file handler
				pwCode = 'local ltFile,ltOutput=gg.getFile():gsub("%.enc%.lua$",".lua"):gsub("%.lua$",".lt.cfg")'..pwCode..' io.open(ltFile,"w"):write([====[-- ABJ4403 LuaTools Encryptor configuration\n-- Please do not edit this file just in case there is an encoding error while doing it\n-- If you really want to edit this file, use a good code editor that respects the encoding of a file\nreturn {\n--Password hash (to avoid typing the same password again)\n	password_hash = "]====]..pwHash..[====["\n}]====]):close()end ltOutput,err=loadfile(ltFile)if ltOutput and not err then ltOutput=ltOutput()if type(ltOutput)~="table"or ltOutput.password_hash~=pwHash then print("'..cfg.obfModSettings.text.failInvalidPWFile..'")askPw()end else if err then print("'..cfg.obfModSettings.text.errLTCfgFile..'",err)end askPw()end'
			else
			--just ask pw
				pwCode = pwCode..'end askPw()'
			end
			pwCode = 'local pwHash,askPw,CH,err="'..cfg.xdenc(cfg.obfModSettings.scriptPW,cfg.obfModSettings.pwHash)..'" '..pwCode..' CH,askPw,pwHash,err=nil,nil,nil,nil' -- code to clear everything
			return pwCode
		end
	end,
	N_Welcome            = function()return [[gg.toast("🛡 Encrypted by ABJ4403's Lua encryptor v]]..cfg.VERSION..[[. Please wait...")]]end,
	O_AntiLoad           = function()return 'local load,str=load,function()local _=nil end for i=1,1e3 do load(str)end'end,
	P_NoPeek             = function()return 'gg.searchNumber=(function()local ggSearchNumber=gg.searchNumber return function(...)if gg.isVisible()then gg.setVisible(false)gg.clearList()print("'..cfg.obfModSettings.text.warnPeeking..'")end ggSearchNumber(...)if gg.isVisible()then gg.setVisible(false)gg.clearList()print("'..cfg.obfModSettings.text.warnPeeking..'")end end end)()'end,
	Q_SpamLog            = function()return 'local ot,dt,LOG,t1,t2=os.time,debug.traceback,("\0\4\8\255"):rep(1e3)t1=ot()for i=1,2e3 do dt(1,nil,LOG)end t2=ot()if t2-t1>1 then print("'..cfg.obfModSettings.text.failLogDetected..'")os.exit()end ot,dt,t1,t2,LOG=nil,nil,nil,nil,nil'end,
--R_BigLASM            = function()return "local "..('_="<<===---- Chunk Obfuscator ----===>>" '):rep(30000)..('goto _ '):rep(30000)..("(function()end)() "):rep(30000)..'::_:: _=nil'end, -- Makes assembly file really big. Chunk obfuscator?
--x_cHeaphumanVerify   = function()return "local tmp=math.random(1000,9999)local CH=gg.prompt({'[cHeapumanVerification] Input this number to make sure that you\\'re human: '..tmp},nil,{'text'})if not CH or tonumber(CH[1]) ~= tmp then print('"..cfg.obfModSettings.text.failInvalidPW.."')os.exit()end CH=nil"end,
--x_cHeaphumanVerify2  = function()return 'local t,r,c={"Apple","Banana","Island","Cat","Dog","Octopus","Bird","Penguin","Panda","Pizza","Donut","Candy","Tea","Shrimp","Car","House","Rocket","Orange","Lemon","Mushroom","Fox","Flower"},{math.random(1,22),math.random(1,22),math.random(1,22),math.random(1,3)}c=gg.alert("[cHeapumanVerification] Choose the corrent answer by pressing the buttons below.\\nWhat is the meaning of this emoji: "..({"🍎","🍌","🏝","🐈","🐕","🐙","🐦","🐧","🐼","🍕","🍩","🍬","🍵","🍤","🚗","🏘","🚀","🍊","🍋","🍄","🦊","🌻"})[r[r[4]]],t[r[1]],t[r[2]],t[r[3]])if not c or r[4]~=c then print("'..cfg.obfModSettings.text.failInvalidPW..'")os.exit()end'end,
}
-- Put your deobfuscation patches here (name can be whatever. when you modify below, you might want to modify `wrapper_patches()` if you add/remove entries in here)
-- Important: lua doesnt use RegEx. More info: https://www.lua.org/manual/5.1/manual.html#5.4.1
-- Also, ^$()%.[]*+-? is magic char, escape those using % instead of \
local deobfPatch = {
	selfDecrypt = {
 -- For self-decrypt

 -- Anti hook (not work??)
		{'LOADNIL v%d+%.%.v%d+\nGETTABUP v%d+ u0 "debug"\nGETTABLE v%d+ v%d+ "getinfo"\nLOADK v%d+ 1\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nGETTABLE v%d+ v%d+ "istailcall"\nTEST v%d+ 0\nJMP :goto_%d+  ; %+6 ↓\nGETTABUP v%d+ u0 "print"\nLOADK v%d+ "[^\n]-"\nCALL v%d+%.%.v%d+\nGETTABUP v%d+ u0 "os"\nGETTABLE v%d+ v%d+ "exit"\nCALL v%d+%.%.v%d+\n:goto_%d+\nGETTABUP v%d+ u0 "ipairs"\nNEWTABLE v%d+ 8 0\nGETTABUP v%d+ u0 "gg"\nGETTABUP v%d+ u0 "io"\nGETTABUP v%d+ u0 "os"\nGETTABUP v%d+ u0 "string"\nGETTABUP v%d+ u0 "math"\nGETTABUP v%d+ u0 "table"\nGETTABUP v%d+ u0 "bit32"\nGETTABUP v%d+ u0 "utf8"\nSETLIST v%d+%.%.v%d+ 1\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nJMP :goto_%d+  ; %+56 ↓\n:goto_%d+\nGETTABUP v%d+ u0 "type"\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nEQ 0 v%d+ "table"\nJMP :goto_%d+  ; %+51 ↓\nGETTABUP v%d+ u0 "pairs"\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nJMP :goto_%d+  ; %+45 ↓\n:goto_%d+\nGETTABUP v%d+ u0 "type"\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nEQ 0 v%d+ "function"\nJMP :goto_%d+  ; %+40 ↓\nGETTABUP v%d+ u0 "debug"\nGETTABLE v%d+ v%d+ "getinfo"\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nMOVE v%d+ v%d+\nGETTABLE v%d+ v%d+ "short_src"\nEQ 0 v%d+ "[Java]"\nJMP :goto_%d+  ; %+26 ↓\nGETTABLE v%d+ v%d+ "source"\nEQ 0 v%d+ "=[Java]"\nJMP :goto_%d+  ; %+23 ↓\nGETTABLE v%d+ v%d+ "what"\nEQ 0 v%d+ "Java"\nJMP :goto_%d+  ; %+20 ↓\nGETTABLE v%d+ v%d+ "namewhat"\nEQ 0 v%d+ ""\nJMP :goto_%d+  ; %+17 ↓\nGETTABLE v%d+ v%d+ "linedefined"\nEQ 0 v%d+ %-1\nJMP :goto_%d+  ; %+14 ↓\nGETTABLE v%d+ v%d+ "lastlinedefined"\nEQ 0 v%d+ %-1\nJMP :goto_%d+  ; %+11 ↓\nGETTABLE v%d+ v%d+ "currentline"\nEQ 0 v%d+ %-1\nJMP :goto_%d+  ; %+8 ↓\nGETTABUP v%d+ u0 "tostring"\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSELF v%d+ v%d+ "match"\nLOADK v%d+ "function: @%(%.%-%):"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nTEST v%d+ 0\nJMP :goto_%d+  ; %+6 ↓\n:goto_%d+\nGETTABUP v%d+ u0 "print"\nLOADK v%d+ "[^\n]-"\nCALL v%d+%.%.v%d+\nGETTABUP v%d+ u0 "os"\nGETTABLE v%d+ v%d+ "exit"\nCALL v%d+%.%.v%d+\n:goto_%d+\nTFORCALL v%d+%.%.v%d+\nTFORLOOP v%d+ :goto_%d+  ; %-47 ↑\n; %.end local v%d+ "%(for generator%)"\n; %.end local v%d+ "%(for state%)"\n; %.end local v%d+ "%(for control%)"\n; %.end local v%d+ "%(for key%)"\n:goto_%d+\nTFORCALL v%d+%.%.v%d+\nTFORLOOP v%d+ :goto_%d+  ; %-58 ↑\n; %.end local v%d+ "%(for generator%)"\n; %.end local v%d+ "%(for state%)"\n; %.end local v%d+ "%(for control%)"\n; %.end local v%d+ "%(for key%)"\nLOADNIL v%d+%.%.v%d+\n',''},

 -- Remove Password (failed: weird inst/func placements; 1.regular,2.exportpw)
		{'LOADK v%d+ "[^\n]-"\nLOADNIL v%d+%.%.v%d+\nCLOSURE v%d+ F%d+\nMOVE v%d+ v%d+\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+\nLOADNIL v%d+%.%.v%d+\nMOVE v%d+ v%d+\nMOVE v%d+ v%d+\nMOVE v%d+ v%d+\nRETURN\nGETTABUP v%d+ u1 "gg"\nGETTABLE v%d+ v%d+ "prompt"\nNEWTABLE v%d+ 1 0\nLOADK v%d+ "[^\n]-"\nSETLIST v%d+%.%.v%d+ 1\nLOADNIL v%d+%.%.v%d+\nNEWTABLE v%d+ 1 0\nLOADK v%d+ "text"\nSETLIST v%d+%.%.v%d+ 1\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSETUPVAL v%d+ u0\nGETUPVAL v%d+ u0\nTEST v%d+ 0\nJMP :goto_%d+  ; %+6 ↓\nGETTABUP v%d+ u1 "decode"\nGETTABUP v%d+ u0 1\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nGETUPVAL v%d+ u2\nEQ 1 v%d+ v%d+\nJMP :goto_%d+  ; %+6 ↓\n:goto_%d+\nGETTABUP v%d+ u1 "print"\nLOADK v%d+ "[^\n]-"\nCALL v%d+%.%.v%d+\nGETTABUP v%d+ u1 "os"\nGETTABLE v%d+ v%d+ "exit"\nCALL v%d+%.%.v%d+\n:goto_%d+\n',''},
		{'LOADK v%d+ "[^\n]-"\nLOADNIL v%d+%.%.v%d+\nGETTABUP v%d+ u0 "gg"\nGETTABLE v%d+ v%d+ "getFile"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSELF v%d+ v%d+ "gsub"\nLOADK v%d+ "%%.enc%%.lua$"\nLOADK v%d+ "%.lua"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSELF v%d+ v%d+ "gsub"\nLOADK v%d+ "%%.lua$"\nLOADK v%d+ "%.lt%.cfg"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nCLOSURE v%d+ F%d+\nMOVE v%d+ v%d+\nGETTABUP v%d+ u0 "loadfile"\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nMOVE v%d+ v%d+\nMOVE v%d+ v%d+\nTEST v%d+ 0\nJMP :goto_%d+  ; %+19 ↓\nTEST v%d+ 1\nJMP :goto_%d+  ; %+17 ↓\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nMOVE v%d+ v%d+\nGETTABUP v%d+ u0 "type"\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nEQ 0 v%d+ "table"\nJMP :goto_%d+  ; %+3 ↓\nGETTABLE v%d+ v%d+ "password_hash"\nEQ 1 v%d+ v%d+\nJMP :goto_%d+  ; %+14 ↓\n:goto_%d+\nGETTABUP v%d+ u0 "print"\nLOADK v%d+ "[^\n]-"\nCALL v%d+%.%.v%d+\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+\nJMP :goto_%d+  ; %+8 ↓\n:goto_%d+\nTEST v%d+ 0\nJMP :goto_%d+  ; %+4 ↓\nGETTABUP v%d+ u0 "print"\nLOADK v%d+ "[^\n]-"\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+\n:goto_%d+\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+\n:goto_%d+\nLOADNIL v%d+%.%.v%d+\nLOADNIL v%d+%.%.v%d+\nMOVE v%d+ v%d+\nMOVE v%d+ v%d+\nMOVE v%d+ v%d+\nRETURN\n%.func F%d+ ; 4 upvalues, 0 locals, 17 constants, 0 funcs\n%.source ""\n%.linedefined 0\n%.lastlinedefined 0\n%.numparams 0\n%.is_vararg 0\n%.maxstacksize 5\n%.upval v%d+ nil ; u0\n%.upval u0 nil ; u1\n%.upval v%d+ nil ; u2\n%.upval v%d+ nil ; u3\n%.upval v%d+ nil ; u4\nGETTABUP v%d+ u1 "gg"\nGETTABLE v%d+ v%d+ "prompt"\nNEWTABLE v%d+ 1 0\nLOADK v%d+ "[^\n]-"\nSETLIST v%d+%.%.v%d+ 1\nLOADNIL v%d+%.%.v%d+\nNEWTABLE v%d+ 1 0\nLOADK v%d+ "text"\nSETLIST v%d+%.%.v%d+ 1\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSETUPVAL v%d+ u0\nGETUPVAL v%d+ u0\nTEST v%d+ 0\nJMP :goto_%d+  ; %+6 ↓\nGETTABUP v%d+ u1 "decode"\nGETTABUP v%d+ u0 1\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nGETUPVAL v%d+ u2\nEQ 1 v%d+ v%d+\nJMP :goto_%d+  ; %+6 ↓\n:goto_%d+\nGETTABUP v%d+ u1 "print"\nLOADK v%d+ "[^\n]-"\nCALL v%d+%.%.v%d+\nGETTABUP v%d+ u1 "os"\nGETTABLE v%d+ v%d+ "exit"\nCALL v%d+%.%.v%d+\n:goto_%d+\nGETTABUP v%d+ u1 "io"\nGETTABLE v%d+ v%d+ "open"\nGETUPVAL v%d+ u3\nLOADK v%d+ "w"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSELF v%d+ v%d+ "write"\nLOADK v%d+ "[^\n]-"\nGETUPVAL v%d+ u2\nLOADK v%d+ "[^\n]-"\nCONCAT v%d+ v%d+%.%.v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSELF v%d+ v%d+ "close"\nCALL v%d+%.%.v%d+\n',''},

 -- No rename (kinda worked? if used, this will make script stuck...)
		{'LOADK v%d+ "[^\n]-"\nGETTABUP v%d+ u0 "gg"\nGETTABLE v%d+ v%d+ "getFile"\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSELF v%d+ v%d+ "gsub"\nLOADK v%d+ "%^/%.%+/"\nLOADK v%d+ ""\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nEQ 1 v%d+ v%d+\nJMP :goto_%d+  ; %+10 ↓\nGETTABUP v%d+ u0 "print"\nLOADK v%d+ "[^\n]-"\nMOVE v%d+ v%d+\nLOADK v%d+ "[^\n]-"\nMOVE v%d+ v%d+\nCONCAT v%d+ v%d+%.%.v%d+\nCALL v%d+%.%.v%d+\nGETTABUP v%d+ u0 "os"\nGETTABLE v%d+ v%d+ "exit"\nCALL v%d+%.%.v%d+\n',''},
 -- Spam log (not work???)
		{'GETTABUP v%d+ u0 "os"\nGETTABLE v%d+ v%d+ "time"\nGETTABUP v%d+ u0 "debug"\nGETTABLE v%d+ v%d+ "traceback"\nLOADK v%d+ "\x00\x04\b\xFF"\nSELF v%d+ v%d+ "rep"\nLOADK v%d+ 1000\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nMOVE v%d+ v%d+\nLOADK v%d+ 1\nLOADK v%d+ 2000\nLOADK v%d+ 1\n; %.local v%d+ "%(for index%)"\n; %.local v%d+ "%(for limit%)"\n; %.local v%d+ "%(for step%)"\n; %.local v%d+ "%(for iterator%)"\nFORPREP v%d+ :goto_%d+  ; %+5 ↓\n:goto_%d+\nMOVE v%d+ v%d+\nLOADK v%d+ 1\nLOADNIL v%d+%.%.v%d+\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+\n:goto_%d+\nFORLOOP v%d+ :goto_%d+  ; %-6 ↑\n; %.end local v%d+ "%(for index%)"\n; %.end local v%d+ "%(for limit%)"\n; %.end local v%d+ "%(for step%)"\n; %.end local v%d+ "%(for iterator%)"\nMOVE v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nMOVE v%d+ v%d+\nSUB v%d+ v%d+ v%d+\nLT 0 1 v%d+\nJMP :goto_%d+  ; %+6 ↓\nGETTABUP v%d+ u0 "print"\nLOADK v%d+ "[^\n]-"\nCALL v%d+%.%.v%d+\nGETTABUP v%d+ u0 "os"\nGETTABLE v%d+ v%d+ "exit"\nCALL v%d+%.%.v%d+\n:goto_%d+\nLOADNIL v%d+%.%.v%d+\nLOADNIL v%d+%.%.v%d+\nMOVE v%d+ v%d+\nMOVE v%d+ v%d+\nMOVE v%d+ v%d+\nMOVE v%d+ v%d+\n"',''},
 -- HackerBoyXVPN Obfuscation (works)
		{'LOADBOOL v%d+ 0\nTEST v%d+ 0\nJMP :goto_%d+  ; %+86 ↓\nNEWTABLE v%d+ 8 0\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nMOD v%d+ v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nSETLIST v%d+%.%.v%d+ 1\nLEN v%d+ v%d+\nLT 1 v%d+ 0\nJMP :goto_%d+  ; %+66 ↓\nLEN v%d+ v%d+\nGETTABLE v%d+ v%d+ v%d+\nLT 1 v%d+ 0\nJMP :goto_%d+  ; %+62 ↓\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nGETTABLE v%d+ v%d+ v%d+\nLEN v%d+ v%d+\nEQ 1 v%d+ v%d+\nJMP :goto_%d+  ; %+6 ↓\nLEN v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nGETTABLE v%d+ v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSETTABLE v%d+ v%d+ v%d+\n:goto_%d+\nLEN v%d+ v%d+\nLT 0 v%d+ nil\nJMP :goto_%d+  ; %+11 ↓\nLEN v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nUNM v%d+ v%d+\nLOADNIL v%d+%.%.v%d+\nGETTABLE v%d+ v%d+ v%d+\nCALL v%d+%.%.v%d+ v%d+%.%.v%d+\nSETTABLE v%d+ v%d+ v%d+\nJMP :goto_%d+  ; %+3 ↓\n:goto_%d+\nGETTABUP v%d+ u0 "obf_P3oU"\nCALL v%d+%.%.v%d+\n:goto_%d+\nCLOSURE v%d+ F%d+\nSETTABUP u0 "obf_P3oU" v%d+\nJMP :goto_%d+  ; %-5 ↑\n:goto_%d+\n',''},
	},
	RemoveGarbage = {
	--All this was original by @ABJ4403
		{'[^\n]*; garbage\n',''},
	--{'[^\n]*; unused\n',''}, -- disabled cuz removing RETURN after TAILCALL, and this f'ed unluac
	--{'\nRETURN (.-)\nRETURN  ; unused\n','\nRETURN %1\n'}, -- somehow removed RETURN ..\n:label\nRETURN, idk if this will f'ed unluac too or not
	--{'\nTAILCALL (.-)\nRETURN .- ; unused\n','\nTAILCALL %1\n'}, -- disabled cuz removing RETURN after TAILCALL, and this f'ed unluac
		{'[^\n]*; variable v%d- out of stack %(%.maxstacksize = %d- for this func%)\n',''},
		{'\nJMP :goto_%d-  ; %-0 ↑\n','\n'},
		{'\nJMP :goto_%d-  ; %+0 ↓\n','\n'},
		{'\nOP%[%d%d%] 0x[0-9a-f]-\n','\n'},
	--{'\n[^\n]* CONST%[.-%]',''}, -- untested

	--remove null loop
		{'\n:goto_(%d-)\nJMP :goto_(%d-)\n',function(a,b)return (a == b) and''or'\n:goto_'..a..'\nJMP :goto_'..b..'\n'end}, -- while true do end/infinite loop
		{'FORLOOP v%d- GOTO%[%-%d-%]  ; %-%d- ↑\n; %.end local v%d- "%(for index%)"\n; %.end local v%d- "%(for limit%)"\n; %.end local v%d- "%(for step%)"\n; %.end local v%d- "%(for iterator%)"',''},
		{'FORLOOP v%d- GOTO%[%d-%]  ; %+%d- ↓\n; %.end local v%d- "%(for index%)"\n; %.end local v%d- "%(for limit%)"\n; %.end local v%d- "%(for step%)"\n; %.end local v%d- "%(for iterator%)"',''},
		{'LOADK v%d- %d-\nLOADK v%d- %d-\nLOADK v%d- %d-\n; %.local v%d- "%(for index%)"\n; %.local v%d- "%(for limit%)"\n; %.local v%d- "%(for step%)"\n; %.local v%d- "%(for iterator%)"\nFORPREP v%d- :goto_%d-  ; %+0 ↓\n:goto_%d-\nFORLOOP v%d- :goto_%d-  ; %-1 ↑\n; %.end local v%d- "%(for index%)"\n; %.end local v%d- "%(for limit%)"\n; %.end local v%d- "%(for step%)"\n; %.end local v%d- "%(for iterator%)"',''},

	--anti-unluac (BOR,BNOT,BAND,BXOR is OP41,OP42,OP43,OP44 if lua version is 5.2, which makes unluac confused)
		{'\nBAND v%d- v%d- v%d-\n','\n'},
	--{'\nBOR v(%d-) v(%d-) v(%d-)\n','\nADD v%1 v%2 v%3\n'}, -- in cases like gg.setRanges(gg.REGION_* | gg.REGION_*)
		{'\nBNOT v%d- v%d-\n','\n'},
	--{'\nBXOR v%d- v%d- v%d-\n','\n'},

	--anti-unluac but also corrupted math that is when executed, crashed the script
		{'\nBAND v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nBAND v'..a..' '..b..' '..c..'\n'end}, -- a & b
		{'\nBXOR v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nBXOR v'..a..' '..b..' '..c..'\n'end}, -- a ~ b
		{'\nBOR v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nBOR v'..a..' '..b..' '..c..'\n'end}, -- a | b
		{'\nADD v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nADD v'..a..' '..b..' '..c..'\n'end}, -- a + b
		{'\nSUB v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nSUB v'..a..' '..b..' '..c..'\n'end}, -- a - b
		{'\nMUL v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nMUL v'..a..' '..b..' '..c..'\n'end}, -- a * b
		{'\nDIV v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nDIV v'..a..' '..b..' '..c..'\n'end}, -- a / b
		{'\nIDIV v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nIDIV v'..a..' '..b..' '..c..'\n'end}, -- a // b
		{'\nMOD v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nMOD v'..a..' '..b..' '..c..'\n'end}, -- a % b
		{'\nPOW v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nPOW v'..a..' '..b..' '..c..'\n'end}, -- a ^ b
		{'\nSHR v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nSHR v'..a..' '..b..' '..c..'\n'end}, -- a >> b
		{'\nSHL v(%d-) (.-) (.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nSHL v'..a..' '..b..' '..c..'\n'end}, -- a << b
		{'\nCONCAT v(%d-) (.-)%.%.(.-)\n',function(a,b,c)return (b=='nil'or b=='true'or b=='false'or c=='nil'or c=='true'or c=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nCONCAT v'..a..' '..b..'..'..c..'\n'end}, -- a .. b
		{'\nUNM v(%d-) (.-)\n',function(a,b)return (b=='nil'or b=='true'or b=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nUNM v'..a..' '..b..'\n'end}, -- -a
		{'\nLEN v(%d-) (.-)\n',function(a,b)return (b=='nil'or b=='true'or b=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nLEN v'..a..' '..b..'\n'end}, -- #a
		{'\nBNOT v(%d-) (.-)\n',function(a,b)return (b=='nil'or b=='true'or b=='false') and'\nLOADNIL v'..a..'..v'..a..'\n'or'\nBNOT v'..a..' '..b..'\n'end}, -- ~a

	--Unnecessary calls
	--convert checks against same variable to `nil == nil`/`nil ~= nil`
		{'\nLT 1 (.-) (.-)\n',function(b,c)return (b == c) and'\nEQ 0 nil nil\n'or'\nLT 1 '..b..' '..c..'\n'end},
		{'\nLE 1 (.-) (.-)\n',function(b,c)return (b == c) and'\nEQ 1 nil nil\n'or'\nLE 1 '..b..' '..c..'\n'end},
	--literally moves nothing
		{'\nMOVE v(%d-) v(%d-)\n',function(b,c)return (b == c) and'\n'or'\nMOVE v'..b..' v'..c..'\n'end},
	--{'\nEQ (.-) (.-) (.-)\n',function(a,b,c)if b == c then b,c='nil','nil'end return'\nEQ '..a..' '..b..' '..c..'\n'end},

	--another possible anti-unluac
	--{'\n%.upval v%d- [^\n]* ; u%d-\n','\n'},

 -- TODO: these adds extra .upval/RETURN values
 -- function with no upval (crashes assembler)
		{'\n%.source (.-\n%.maxstacksize %d-)\n','\n.source %1\n.upval u0 nil\n'},
 -- function with no RETURN (crashes assembler and causes vm error)
		{'\n%.source (.-\n)%.end',function(srcinst)return'\n.source '..srcinst:gsub('\nRETURN[^\n]*','')..'RETURN\n.end'end},


	--[[
TODO: make sure no garbage bytecode passes on
		{'\nLOADK v%d+ CONST[%d+]\n','\n'},
also
.func wuteverrr
.source ..
.linedefined ..
.lastlinedefined ..
.numparams ..
.is_vararg ..
.maxstacksize ..
 ; make sure either one of these exist in a func
.upval u0 nil
.upval v0 "_ENV"

and oddly gg asm leaves one whitespace before newline on some codes
add the trimming on EssentialMinify ? (do we already done that?)

	]]
	},
	RemoveLasmBlock = {
 -- Lasm block, known as Anti reassemble
 -- Original by SwinX Tools. some numbers were modified to work...
		{
			'[^\n]*%.source ".-"\n%.linedefined %d-\n%.lastlinedefined %d-\n%.numparams (%d-)\n%.is_vararg (%d-)\n%.maxstacksize (%d-)\n',
			function(a,b,c)return'.source ""\n.linedefined 0\n.lastlinedefined 0\n.numparams '..math.min(21,tonumber(a))..'\n.is_vararg '..b..'\n.maxstacksize '..math.min(21,tonumber(c))..'\n'end
		},
	},
	RemoveCodeHider = {
		{' SET_TOP\n','\n'}, -- CALL v?..v? SET_TOP. some code fails, `print((function()return 1 end)()` returns nil instead of 1)
		{'\nSETTABLE v%d- "[^\n]*" v%d-\n','\n'}, -- looks like this removes important code dont use this (a.b = nil)
	--{'\nSETTABLE v%d- "[^\n]*" nil\n','\n'},
	--{'\nSETTABLE v%d- v%d- nil\n','\n'},
	},
	RemoveBlocker1 = {
 -- Kudos to Daddyaaaaaaa for this
		{'\nCALL v%d-..v%d-\n','\n'}, -- os.clock()
		{'\nCALL v%d-..v%d- v%d-..v%d-\n','\n'}, -- os.clock(123) -- (Unverified)
		{'\nEQ 1 v%d- v%d-\n','\n'}, -- v1 == v2
		{'\nEQ 1 v%d- nil\n','\n'}, -- EQ0 = `v1 ~= nil`,EQ1 = `v1 == nil`,
		{'\nGETTABLE v%d- v%d- nil\n','\n'}, -- table[nil]
		{'\nGETTABLE v%d- v%d- "d"\n','\n'}, -- table.d
		{'\nGETTABLE v%d- v%d- "clearResults"\n','\n'}, -- gg.clearResults() ???
		{'\nGETTABUP v%d- u%d- "ipairs"\n','\n'}, -- _G.ipairs() ?
		{'\nGETTABUP v%d- u%d- "i"\n','\n'}, -- _G.i
	--{'\nLOADBOOL v%d- 0\n','\n'}, -- bruh = 1:true/0:false
		{'\nLOADNIL v%d-..v%d-\n','\n'}, -- a,b=nil,nil
		{'\nNEWTABLE v%d- 0 0\n','\n'}, -- new table with no items
		{'\nSELF v%d- v%d- "Z"\n','\n'}, -- ?:Z()
		{'\nSELF v%d- v%d- "_"\n','\n'}, -- ?:_()
		{'\nSETTABUP u%d- ".-" ".-"\n','\n'}, -- _ENV.obf_bla = ...
		{'\nSETTABUP u%d- v%d- v%d-\n','\n'}, -- _ENV.obf_bla = ...
		{'\nSETTABUP u%d- v%d- ".-"\n','\n'}, -- _ENV.obf_bla = ...
		{'\nSETTABUP u%d- ".-" v%d-\n','\n'}, -- _ENV.obf_bla = ...
		{'\nTEST v%d- [01]\n','\n'}, -- a and/or b
		{'\nUNM v%d- v%d-\n','\n'},
		{'\nCLOSURE v%d- F%d-\nSETTABUP u%d- "fxs" v%d-\n','\n'}, -- function fxs()...end
		{'\nCLOSURE v%d- F%d-\nSETTABUP u%d- "SearchWrite" v%d-\n','\n'}, -- function SearchWrite()...end
		{'\nCLOSURE v%d- F%d-\nSETTABUP u%d- "setvalue" v%d-\n','\n'}, -- function setvalue()...end
		{'\nGETTABUP v%d- u%d- "tonumber"\nLOADK v%d-.-%d$\nCALL v%d-..v%d- v%d-..v%d-\nGETTABUP v%d- u%d- "tonumber"\nLOADK v%d-.-%d$\nCALL v%d-..v%d- v%d-..v%d-\nLT 0 v%d- v%d-\nJMP :goto_%d-  ; %+0 ↓\n','\n'},
		{'\nGETTABUP v%d- u0 "_____"\nLOADK v%d- 37\n','\n'},
		{'\nGETTABUP v%d- u0 "_____"\nGETTABLE v%d- v%d- 37\n','\n'},
		{'\nLOADK v%d- "fxs"\nCLOSURE v%d- F%d-\nSETTABUP u%d- v%d- v%d-\n','\n'},
		{'\nLOADK v%d- "SearchWrite"\nCLOSURE v%d- F%d-\nSETTABUP u%d- v%d- v%d-\n','\n'},
		{'\nLOADK v%d- "setvalue"\nCLOSURE v%d- F%d-\nSETTABUP u%d- v%d- v%d-\n','\n'},
		{'\nLOADK v%d- 1\nLOADK v%d- 0\nLOADK v%d- 1\n; %.local v%d- "%(for index%)"\n; %.local v%d- "%(for limit%)"\n; %.local v%d- "%(for step%)"\n; %.local v%d- "%(for iterator%)"\nFORPREP v%d- :goto_%d-  ; %+%d- ↓\n','\n'},
		{'\nNEWTABLE v%d- %d 0\n','\nGETTABUP v0 u0 "GARBAGE"\n'}, -- A = {..} > A = _ENV.GARBAGE
		{'\nTFORCALL v%d-..v%d-\n','\n'},
		{'\nTFORLOOP v%d- :goto_%d-* ; %-%d- ↑\n','\n'},
	-- by thanh dieu
		{"\nTEST [^\n]* v%d- v%d-\n","\n"},
		{"\nTEST [^\n]* v%d- [^\n]*\n","\n"},
		{"\nTEST [^\n]* [^\n]* v%d-\n","\n"},
		{"\nTEST v%d- [^\n]* v%d-\n","\n"},
		{"\nTEST v%d- [^\n]* [^\n]*\n","\n"},
		{"\nTEST v%d- v%d- v%d-\n","\n"},
		{"\nTEST v%d- v%d- [^\n]*\n","\n"},
		{"\nSETLIST v%d-..v%d- [^\n]*\n","\n"},
		{"\nCALL v%d- SET_TOP[^\n]*\n","\n"},
		{"\nCALL v%d-..v%d- SET_TOP[^\n]*\n","\n"},
		{"\nEQ [^\n]* v%d- v%d-\n","\n"},
		{"\nEQ [^\n]* [^\n]* [^\n]*\n","\n"},
		{"\nEQ [^\n]* v%d- [^\n]*\n","\n"},
		{"\nEQ [^\n]* [^\n]* v%d-\n","\n"},
		{"\nEQ v%d- [^\n]* v%d-\n","\n"},
		{"\nEQ v%d- [^\n]* [^\n]*\n","\n"},
		{"\nEQ v%d- v%d- v%d-\n","\n"},
		{"\nEQ v%d- v%d- [^\n]*\n","\n"},
		{"\nLOADBOOL [^\n]* v%d- v%d-\n","\n"},
		{"\nLOADBOOL [^\n]* v%d- [^\n]*\n","\n"},
		{"\nLOADBOOL [^\n]* [^\n]* v%d-\n","\n"},
		{"\nLOADBOOL v%d- [^\n]* v%d-\n","\n"},
		{"\nLOADBOOL v%d- [^\n]* [^\n]*\n","\n"},
		{"\nLOADBOOL v%d- v%d- v%d-\n","\n"},
		{"\nLOADBOOL v%d- v%d- [^\n]*\n","\n"},
		{"\nLT [^\n]* v%d- v%d-\n","\n"},
		{"\nLT [^\n]* [^\n]* [^\n]*\n","\n"},
		{"\nLT [^\n]* v%d- [^\n]*\n","\n"},
		{"\nLT [^\n]* [^\n]* v%d-\n","\n"},
		{"\nLT v%d- [^\n]* v%d-\n","\n"},
		{"\nLT v%d- [^\n]* [^\n]*\n","\n"},
		{"\nLT v%d- v%d- v%d-\n","\n"},
		{"\nLT v%d- v%d- [^\n]*\n","\n"},
		{"\nLEN [^\n]* v%d- v%d-\n","\n"},
		{"\nLEN [^\n]* v%d- [^\n]*\n","\n"},
		{"\nLEN [^\n]* [^\n]* v%d-\n","\n"},
		{"\nLEN v%d- [^\n]* v%d-\n","\n"},
		{"\nLEN v%d- [^\n]* [^\n]*\n","\n"},
		{"\nLEN v%d- v%d- v%d-\n","\n"},
		{"\nLEN v%d- v%d- [^\n]*\n","\n"},
		{"\nLE [^\n]* v%d- v%d-\n","\n"},
		{"\nLE [^\n]* v%d- [^\n]*\n","\n"},
		{"\nLE [^\n]* [^\n]* v%d-\n","\n"},
		{"\nLE v%d- [^\n]* v%d-\n","\n"},
		{"\nLE v%d- [^\n]* [^\n]*\n","\n"},
		{"\nLE v%d- v%d- v%d-\n","\n"},
		{"\nLE v%d- v%d- [^\n]*\n","\n"},
		{"\nMOD [^\n]* v%d- v%d-\n","\n"},
		{"\nMOD [^\n]* v%d- [^\n]*\n","\n"},
		{"\nMOD [^\n]* [^\n]* v%d-\n","\n"},
		{"\nMOD v%d- [^\n]* v%d-\n","\n"},
		{"\nMOD v%d- [^\n]* [^\n]*\n","\n"},
		{"\nMOD v%d- v%d- v%d-\n","\n"},
		{"\nMOD v%d- v%d- [^\n]*\n","\n"},
		{"\nMUL [^\n]* v%d- v%d-\n","\n"},
		{"\nMUL [^\n]* v%d- [^\n]*\n","\n"},
		{"\nMUL [^\n]* [^\n]* v%d-\n","\n"},
		{"\nMUL v%d- [^\n]* v%d-\n","\n"},
		{"\nMUL v%d- [^\n]* [^\n]*\n","\n"},
		{"\nMUL v%d- v%d- v%d-\n","\n"},
		{"\nMUL v%d- v%d- [^\n]*\n","\n"},
		{"\nCONCAT [^\n]* v%d- v%d-\n","\n"},
		{"\nCONCAT [^\n]* v%d- [^\n]*\n","\n"},
		{"\nCONCAT [^\n]* [^\n]* v%d-\n","\n"},
		{"\nCONCAT v%d- [^\n]* v%d-\n","\n"},
		{"\nCONCAT v%d- [^\n]* [^\n]*\n","\n"},
		{"\nCONCAT v%d- v%d- v%d-\n","\n"},
		{"\nCONCAT v%d- v%d- [^\n]*\n","\n"},
		{"\nLOADBOOL v%d- [^\n]*\n","\n"},
		{"\nEQ [^\n]* v%d- v%d-\n","\n"},
		{"\nTEST v%d- [^\n]*\n","\n"},
		{"\nVARARG [^\n]* v%d- v%d-\n","\n"},
		{"\nVARARG [^\n]* v%d- [^\n]*\n","\n"},
		{"\nVARARG [^\n]* [^\n]* v%d-\n","\n"},
		{"\nVARARG v%d- [^\n]* v%d-\n","\n"},
		{"\nVARARG v%d- [^\n]* [^\n]*\n","\n"},
		{"\nVARARG v%d- v%d- v%d-\n","\n"},
		{"\nVARARG v%d- v%d- [^\n]*\n","\n"},
		{"\nLOADK v%d- -[^\n]*\n","\n"},
		{"\nBOR [^\n]* v%d- v%d-\n","\n"},
		{"\nBOR [^\n]* v%d- [^\n]*\n","\n"},
		{"\nBOR [^\n]* [^\n]* v%d-\n","\n"},
		{"\nBOR v%d- [^\n]* v%d-\n","\n"},
		{"\nBOR v%d- [^\n]* [^\n]*\n","\n"},
		{"\nBOR v%d- v%d- v%d-\n","\n"},
		{"\nBOR v%d- v%d- [^\n]*\n","\n"}
	},
	EssentialMinify = {
 -- Some regex fails, this can help by trimming spaces/tabs, and blank lines...
		{'\n%s*(.-)%s*\n','\n%1\n'}, -- trim tabs
		{'%s*\n%s*','\n'}, -- trim tabs
		{'\n\n','\n'}, --remove blank line (doesnt do anything?)
-- useless gg assembly annotation (untested)
	--{'\n; %.end local v%d- "%(for generator%)"\n','\n'},
	--{'\n; %.end local v%d- "%(for state%)"\n','\n'},
	--{'\n; %.end local v%d- "%(for control%)"\n','\n'},
	--{'\n; %.end local v%d- "%(for key%)"\n','\n'},
	},
	JmpObf = {
	--tries to remove some JMP obfuscations (this wont work on JMP obfuscated instruction though)
	--{'\nJMP :goto_(%d-)  ; (%-%d-) ↑\n',function(l,o)l,o=tonumber(l),tonumber(o) return l > 0 or l < -999 and""or"JMP :goto_"..l.."  ; "..o.." ↑\n"end},
	--{'\nJMP :goto_(%d-)  ; (%d-) ↓\n'  ,function(l,o)l,o=tonumber(l),tonumber(o) return l < 0 or l >  999 and""or"JMP :goto_"..l.."  ; "..o.." ↓\n"end},
		{'\nJMP :goto_(%d-)  ; 0 ↓\n:goto_(%d-)',function(l,o)return a==b and''or'\nJMP :goto_'..a..'  ; 0 ↓\n:goto_'..b end},
	--{'\nJMP :goto_(%d-)  ; 0 ↓\n:goto_(%d-)',function(l,o)return a==b and'\n:goto_'..b or'\nJMP :goto_'..a..'  ; 0 ↓\n:goto_'..b end},
	},
}
--————————————————————————————————--




--— Core functions ———————————————--
function MENU()
-- TODO: maybe make remove biglasm in patches menu a separate option in main menu
	local CH = gg.choice({
		"🔐 1. Encrypt Lua",
		"🔨 2. (De)compile Lua",
		"⛏️ 3. (Dis)assemble Lua",
		"🔧 4. Fix corrupted Lua header",
		"🔧 5. Remove BigLASM",
		"🩹️ 6. Patches to decrypt files",
		"💉 7. Inject code to compiled script",
		"📦 8. Run script in isolated container (uses VirtGG)",
		"__about__",
		"__exit__",
	},nil,"ABJ4403's LuaTools "..cfg.VERSION)
	if CH == 1 then wrapper_encryptLua()
	elseif CH == 2 then wrapper_compileLua()
	elseif CH == 3 then wrapper_luacAssembly()
	elseif CH == 4 then wrapper_fixLuacHeader()
	elseif CH == 5 then wrapper_removeBigLASM()
	elseif CH == 6 then wrapper_patches()
	elseif CH == 7 then wrapper_injectCodeToLuac()
	elseif CH == 8 then wrapper_secureRun()
	elseif CH == 9 then MENU_about()
	elseif CH == 10 then
		gg.setVisible(true)
		print("[+] Script quit safely.")os.exit()
	end
	CH = nil
end
function MENU_about()
	local CH = gg.choice({
		"__about__",
		"Features",
		"License",
		"Credits",
		"Encryption test",
		"__back__"
	},nil,"ABJ4403's LuaTools "..cfg.VERSION)
	if CH == 1 then
		gg.alert("ABJ4403's LuaTools v"..cfg.VERSION..[[ © 2022-2023
Manage your Lua scripts on the go!

Why did i make this?
Just to make my life (maybe yours too) easier. and not having to install other proprietary APKs, executables, or even proprietary decryptor/encryptor that can only do one thing and its worst at the same time (eg: PG Encrypt, but no way to decrypt it in the same place, and vice versa. And also there's lots of proprietary gg Lua script out there. maybe you want to clean its garbage code so it can run faster? or run in in secure isolated environment so you can have a peace of mind knowing the files on your phone wont get removed by mallicious `os.remove` API call, or overwriting your files using `io.open/write/read` API call, or executing mallicious commands using `os.execute` API, or you dont want your data to get stolen using `gg.makeRequest` API? Maybe you also wanted to encrypt the script in the correct way because you wanted to share a script, but also realized that your script is too much risky to share to public because you dont want bad cheater (aka. the abuser) uses too much out of your script to hurt other online players? Or you need that little extra tiny SPEED by precompiling the source script and removing its hidden garbage code too.

I created this under 24 hour (on a phone btw!) as a challenge :D So it would be really appreciated if you can contribute to LuaTools GitHub repository (once the script has been open-sourced: https://github.com/ABJ4403/LuaTools) or give a star to my project on GitHub. or simply credit my work (by not removing mentions about me and others in this script :) Thank you :D
]]) MENU_about()
	elseif CH == 2 then gg.alert([[Features:
+ Simple, no bloat (no blingy nonsense, no fake loading).
+ Always FOSS (Free and Open-source), Licensed under GPL v3
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
	+ Remove Code hider? (unstable).
	+ Remove blocker.
	+ Remove nonsenses (experiment).
+ Run script in isolated environment.
	+ Powered by VirtGG and some Script Compiler 3.7.
	+ Protect your device from unwanted script modification (os.execute,os.remove,gg.makeRequest,etc).
	. Grab a password from basic pwall script (untested).
	. Run script with different version/package name.
+ Remove BigLASM (untested, because i got no real example to test against).]]) MENU_about()
	elseif CH == 3 then gg.alert("License:\nLuaTools is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.\n\nLuaTools is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of\nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with LuaTools.	If not, see https://gnu.org/licenses\n\n"..[[VirtGG License (proprietary for an early development version for abuse reason):
VirtGG © 2022-2023 ABJ4403, End User License Agreement.
You are allowed to:
- Use it in a respectful manner and good intentions.
You are NOT ALLOWED TO:
- Redistribute the code.
- Reverse-engineer the code.
- Include it in your project.
All rights reserved.]]) MENU_about()
	elseif CH == 4 then gg.alert("Credits:\n• ABJ4403 - Original creator.\n• Veyron, HBXVPN - Obfuscation codes.\n• Enyby - For some portion of Script Compiler 3.7 source codes (specifically the dump input field).\n• SwinXTools - for Remove LASM Block deobfuscation codes.\n• Daddyaaaaaaa - for Remove blocker 1 deobfuscation codes.\n• LuaGGEG, Angela, MafiaWar - for Remove BigLASM code.") MENU_about()
	elseif CH == 5 then gg.alert([=====[ ——— Encryption test ———
Texts below shouldn't look jumbled up.

Encrypted table queries test:
- gg.searchNumber(5,gg.TYPE_WORD)
- gg.getResults(9)

Anti exit detection test:
- os.exit()

String encryption test:
- 'Hello world!'
- \"Hello world!\"
- [[Test]]
- [=[Test]=]
- [==[Test]==]
- [===[Test]===]
- [====[Test]====]

Annotation test:
-- Hello World!
--[[Hello World!]]
--[==[Hello World!]==]

 ——— End of encryption test ———]=====]) MENU_about()
	elseif CH == 6 then CH = nil MENU() end
end

function wrapper_encryptLua()
	local CH = gg.prompt(
	{
		'📂 Input File (make sure the extension is .lua):', -- 1
		'🧹 Strip annotations (ONLY enable if you encountered an Error and your script has Annotations/Comments --[[like this]])',
		'🔀️ Encrypt strings (Experimental, possible parsing error could happen)',
		'🔀️ Encrypt table queries (rarely quirky)',
		'🔐 ️Password:', -- 5
		'🔐️ Only ask password for once',
		'🗓️ Script Expiry Date (in YYYYMMDD format)',
		'⚙️ GG package name',
		'⚙️ GG target package name',
		'⚙️ GG version requirement', -- 10
		'⚙️ Minimum GG build version requirement',
		'⚙️ Allow newer versions (only works with build number)',
		'===== ADVANCED OPTIONS: =====\n\n\n\n\n💬️️ Promotional text (eg. Follow, Sub to YT channel), shown in Lua binary', -- 13
		'💬️️ Ask password:',
		'💬️️ Wrong password:', -- 15
		'💬️️ Target Package Invalid:',
		'💬️️ Expired message:',
		'💬️️ Denied packages:',
		'💬️️ Wrong GG Version:',
		'💬️️ GG Version below:', -- 20
		'💬️️ Hook Detected:',
		'💬️️ Illegal Modification:',
		'💬️️ Log Detected:',
		'💬️️ Renamed:',
		'💬️️ Warn Value Peeking:', --25
	},
	{
		cfg.fileChoice,-- 1
		cfg.obfModSettings.stripAnnotations,
		cfg.obfModSettings.encryptStrings,
		cfg.obfModSettings.encryptTables,
		cfg.obfModSettings.scriptPW, -- 5
		cfg.obfModSettings.savePW,
		cfg.obfModSettings.scriptExpiry,
		cfg.obfModSettings.ggPkg,
		cfg.obfModSettings.appPkg,
		cfg.obfModSettings.minGGVer, -- 10
		cfg.obfModSettings.minGGBuildVer,
		cfg.obfModSettings.allowNewGGBuildVer,
		--
		cfg.obfModSettings.text.promoteYourself,
		cfg.obfModSettings.text.inputPass,
		cfg.obfModSettings.text.failInvalidPW, -- 15
		cfg.obfModSettings.text.failAppPkgInvalid,
		cfg.obfModSettings.text.failDatePassed,
		cfg.obfModSettings.text.failDeniedPkgs,
		cfg.obfModSettings.text.failGGPkgInvalid,
		cfg.obfModSettings.text.failGGVerBelow, -- 20
		cfg.obfModSettings.text.failHookDetected,
		cfg.obfModSettings.text.failIllegalMod,
		cfg.obfModSettings.text.failLogDetected,
		cfg.obfModSettings.text.failRenamed,
		cfg.obfModSettings.text.warnPeeking, -- 25
	},
	{
		'file', -- 1
		'checkbox',
		'checkbox',
		'checkbox',
		'text', -- 5
		'checkbox',
		'text',
		'text',
		'text',
		'text', -- 10
		'text',
		'checkbox',
		--
		'text',
		'text',
		'text', -- 15
		'text',
		'text',
		'text',
		'text',
		'text', -- 20
		'text',
		'text',
		'text',
		'text',
		'text', -- 25
	}
	);
	if CH and CH[1] then
		gg.toast("Encrypting, Please wait... this will take maximum of couple seconds")
		cfg.fileChoice = CH[1]:gsub(".lua$",'')
		cfg.obfModSettings.stripAnnotations = CH[2]
		cfg.obfModSettings.encryptStrings = CH[3]
		cfg.obfModSettings.encryptTables = CH[4]
		cfg.obfModSettings.scriptPW = CH[5]
		cfg.obfModSettings.savePW = CH[6]
		cfg.obfModSettings.scriptExpiry = CH[7]
		cfg.obfModSettings.ggPkg = CH[8]
		cfg.obfModSettings.appPkg = CH[9]
		cfg.obfModSettings.minGGVer = CH[10]
		cfg.obfModSettings.minGGBuildVer = CH[11]
		cfg.obfModSettings.allowNewGGBuildVer = CH[12]
		--
		cfg.obfModSettings.text.promoteYourself = CH[13]
		cfg.obfModSettings.text.inputPass = CH[14]
		cfg.obfModSettings.text.failInvalidPW = CH[15]
		cfg.obfModSettings.text.failAppPkgInvalid = CH[16]
		cfg.obfModSettings.text.failDatePassed = CH[17]
		cfg.obfModSettings.text.failDeniedPkgs = CH[18]
		cfg.obfModSettings.text.failGGPkgInvalid = CH[19]
		cfg.obfModSettings.text.failGGVerBelow = CH[20]
		cfg.obfModSettings.text.failHookDetected = CH[21]
		cfg.obfModSettings.text.failIllegalMod = CH[22]
		cfg.obfModSettings.text.failLogDetected = CH[23]
		cfg.obfModSettings.text.failRenamed = CH[24]
		cfg.obfModSettings.text.warnPeeking = CH[25]
		encryptLua()
		print("[✔] Finished encrypting "..cfg.fileChoice.."!\n[+] Input File: "..cfg.fileChoice..".lua\n[+] Output File: "..cfg.fileChoice..".enc.lua")
		gg.toast("[✔] Encryption complete.")
	end
end
function wrapper_compileLua()
	-- Ask user for file...
	local CH = gg.prompt({
		'📂 Input File (make sure the extension is .lua):',
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
		'📂 Input File (make sure the extension is either .luac/.lasm):',
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
	local CH = gg.prompt({'📂 Input File (make sure the extension is .enc.lua, BTW i recommend reassemble the script instead of fixing the header):'},{cfg.fileChoice},{'file'});
	if CH and CH[1] then
		gg.toast("Fixing Lua header, Please wait...")
		cfg.fileChoice = CH[1]:gsub(".enc.lua$",'')
		modFileHeader('LuaFixHeader')
		gg.toast("Lua header fixed.")
	end
end
function wrapper_removeBigLASM()
	-- Ask user for file...
	local CH = gg.prompt({'📂 Input File (make sure the extension is .enc.lua):'},{cfg.fileChoice},{'file'});
	if CH and CH[1] then
		gg.toast("Fixing Lua header, Please wait...")
		cfg.fileChoice = CH[1]:gsub(".enc.lua$",'')
		removeBigLasm()
		gg.toast("BigLASM Removed!")
	end
end
function wrapper_patches()
	local CH = gg.prompt({
		'📂 Input File (make sure the extension is .enc.lua/.lasm, will directly write to lasm if using that extension):', -- 1
		'Remove Garbage (recommended)', -- 3
		'Remove "Code Hider" (TODO: still poor translation)', -- 4
		'Remove Lasm Block (enable if you cant disassemble the script, disable if you got ArrayOutOfBound error when running the script)', -- 5
		'Unblock 1 (by Daddyaaaaaaa)', -- 6
		"Remove some JMP Obfuscations", -- 7
		'Remove ABJ4403\'s encryption to some extent', -- 8
	},{
		cfg.fileChoice,
		true,false,false, -- 234
		false,false,false -- 567
	},{
		'file',
		'checkbox','checkbox','checkbox',
		'checkbox','checkbox','checkbox'
	});
	if CH and CH[1] then
		local isAsmFile = CH[1]:match('.lasm$')
		CH[1] = isAsmFile and CH[1]:gsub(".lasm$",'') or CH[1]:gsub(".enc.lua$",'')
		cfg.fileChoice = CH[1]

 -- Assembly Patching
		DATA = isAsmFile and io.readFile(cfg.fileChoice..".lasm") or disassembleLua('.enc.lua',true)
		gg.toast("Running selected operations... 1/10") patchAssembly("EssentialMinify")
		if cfg.debugMode then io.writeFile(cfg.fileChoice..".dbg.lasm",DATA) end
		if CH[2] then gg.toast("Running selected operations... 2/10") patchAssembly("RemoveGarbage") print("[✔] Garbages removed!")end
		if CH[7] then gg.toast("Running selected operations... 3/10") patchAssembly("selfDecrypt") print("[✔] Self decrypted! (some)")end
		if CH[3] then gg.toast("Running selected operations... 4/10") patchAssembly("RemoveCodeHider") print("[✔] Hide codes removed!")end
		if CH[4] then gg.toast("Running selected operations... 5/10") patchAssembly("RemoveLasmBlock") print("[✔] LasmBlock Removed!")end
		if CH[5] then gg.toast("Running selected operations... 6/10") patchAssembly("RemoveBlocker1") print("[✔] Blockers patched!")end
		if CH[6] then gg.toast("Running selected operations... 8/10") patchAssembly("JmpObf") print("[✔] Removed JMP Obfuscations!")end
	--8
		gg.toast("Running selected operations... 9/10")
		io.writeFile(cfg.fileChoice..".lasm",DATA)
		if isAsmFile then print('[i] Lua Assembly file format detected, script will not be compiled.') else assembleLua(true) end
		print("\n[+] Input File: "..cfg.fileChoice..".enc.lua\n[+] Output File: "..cfg.fileChoice..".luac")
		gg.toast("Operation completed!")
	end
end
function wrapper_injectCodeToLuac()
	-- Warning: Unstable PoC
	-- And lots of things didnt work
	local CH = gg.prompt({
		'📂 Input Target script (make sure the extension is .lua/.lasm, and make sure to backup your script because this may overwrite the script you chosen):',
		'📂 Input Injected code (make sure the extension is .lua/.lasm):',
		'Set max stack size to 250 (fixes ArrayOutOfBound error)'
	},{
		cfg.fileChoice,
		cfg.fileChoice,
		false
	},{
		'file','file','checkbox',
	})
	if CH and CH[1] and CH[2] then
		-- detect assembly
		local isTargetAsmFile = CH[1]:match('.lasm$')
		local isInjectAsmFile = CH[2]:match('.lasm$')
		-- strip names and stuff
		CH[1] = isTargetAsmFile and CH[1]:gsub(".lasm$",'') or CH[1]:gsub(".lua$",'')
		CH[2] = isInjectAsmFile and CH[2]:gsub(".lasm$",'') or CH[2]:gsub(".lua$",'')
		local INJECTED_CODE = ''

		-- Disassemble
		gg.toast("Disassembling...")
		cfg.fileChoice = CH[1]
		DATA = isTargetAsmFile and io.readFile(CH[1]..".lasm") or disassembleLua('.lua',true)
		cfg.fileChoice = CH[2]
		INJECTED_CODE = isInjectAsmFile and io.readFile(CH[2]..".lasm") or disassembleLua('.lua',true)
		cfg.fileChoice = CH[1]

		-- Cleanup assembly code
		gg.toast("Cleaning assembly codes...")
		for j=1,#deobfPatch.EssentialMinify do
			DATA          = DATA:gsub(deobfPatch.EssentialMinify[j][1],deobfPatch.EssentialMinify[j][2])
			INJECTED_CODE = INJECTED_CODE:gsub(deobfPatch.EssentialMinify[j][1],deobfPatch.EssentialMinify[j][2])
		end

		-- stuff
		local ggAssemblyHeader = {
			'; --[=========[ Lua assembler file generated by GameGuardian '..gg.VERSION..' ('..gg.BUILD..')\n',
			"; ]=========] gg.require('"..gg.VERSION.."', "..gg.BUILD..")"
		}

		-- remove comments, beginning .line, avoid variable collision
		gg.toast("Removing comments, beginning .line, avoid collision...")
		INJECTED_CODE = INJECTED_CODE:gsub(' ;.-\n','\n'):gsub(';.-\n','\n')
		INJECTED_CODE = INJECTED_CODE:gsub('\n%.line %d-\n','\n')
		INJECTED_CODE = INJECTED_CODE:gsub(':goto_',':inject_')
		INJECTED_CODE = INJECTED_CODE:gsub(' F(%d-)',' Injected%1')

		-- Split instructions and functions
		gg.toast("Splitting instruction & funcs...1")
		DATA = splitLuaAssembly(DATA)
		gg.toast("Splitting instruction & funcs...2")
		INJECTED_CODE = splitLuaAssembly(INJECTED_CODE)

		-- Fix ArrayOutOfBounds error (TODO: can we calculate the real value instead??)
		if CH[3] then DATA[1] = DATA[1]:gsub('\n%.maxstacksize %d-\n','\n.maxstacksize 250\n',1) end

		-- remove RETURN after function (if not removed, the script will just quit :/)
		gg.toast("Fixes...")
		INJECTED_CODE[2] = INJECTED_CODE[2]:gsub('\nRETURN','',1)
		-- Code optimization (only if the codes starts with `FunctionName()`)
		INJECTED_CODE[2] = INJECTED_CODE[2]:gsub(
			'\nCLOSURE v(%d-) (.-)\nSETTABUP u(%d-) (.-) v(%d-)\nGETTABUP v(%d-) u(%d-) (.-)\nCALL v(%d-)..v(%d-)\n',
			function(v1,f, u1,f1,v2, v3,u2,f2, v4,v5)
				return (f1 == f2 and u1 == u2 and (v1 == v2 and v1 == v3 and v1 == v4 and v1 == v5)) and
					('\nCLOSURE v%d %s\nCALL v%d..v%d\n'):format(v1,f,v4,v5) or
					('\nCLOSURE v%d %s\nSETTABUP u%d %s v%d\nGETTABUP v%d u%d %s\nCALL v%d..v%d\n'):format(v1,f,u1,f1,v1,v3,u2,f2,v4,v5)
			end
		)

		-- Combine the script in these orders:
		-- GG LASM Header, Source, Injected instructions, Target instructions, Target functions, Injected functions, GG LASM Header
		local DATA =
			ggAssemblyHeader[1]..'\n'..
			DATA[1]..'\n'..
			INJECTED_CODE[2]..'\n'..
			DATA[2]..'\n'..
			DATA[3]..'\n'..
			INJECTED_CODE[3]..'\n'..
			ggAssemblyHeader[2]
		ggAssemblyHeader = nil
		INJECTED_CODE = nil

		-- Assemble Lua
		io.writeFile(cfg.fileChoice..".lasm",DATA)
		if isTargetAsmFile then print('[i] Lua Assembly file format detected, script will not be compiled.') else assembleLua(true) end

 -- Completed
		print("\n[+] Input File: "..cfg.fileChoice..".lua\n[+] Output File: "..cfg.fileChoice..".luac")
		gg.toast("Operation completed!")
	end
end
function wrapper_secureRun()
	local opts = gg.prompt({
		"📂 Script:", -- 1
		"📂 Wrapper script (commonly used for other modifications):", -- 2
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
		"📜 Print log (TODO)", -- 17
		"📜 Dump log (TODO)", -- 18
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
		true, -- 17
		cfg.scriptPath..os.date'/ScriptLog_%y%m%d_%H%M%S.log', -- 18
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
		"checkbox", -- 17
		"text", -- 18
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
			printLog=opts[17],
			dumpLogTo=opts[18],
		})
	end
end

function encryptLua()
	-- Wrap the decryptor script
	print("[i] Wrapping decryptor...")
	cfg.obfModSettings.pwHash = randstr() -- separate XOR key for password (TODO: but we need to implement another decryptor..., or change the whole decryptor)
	cfg.enc = cfg.enc(cfg.obfModSettings.pwHash) -- add key
	cfg.dec_wrap = "local function decode"..cfg.dec_wrap_factory(cfg.obfModSettings.pwHash).." end\n"

	-- Put the input file content to buffer
	gg.toast("[i] Reading file contents to buffer...")
	print("[i] Reading file contents to buffer...")
	collectgarbage()
	DATA = io.readFile(cfg.fileChoice..'.lua')

	if cfg.obfModSettings.stripAnnotations then
		print("[i] Removing annotations to prevent parsing error...")
		local totalReplaced,all_string,tmp = 0,{
			'%-%-%[%[.-%]%]',
			'%-%-[^\n]*'
		}
		collectgarbage()
		for i=1,#all_string do
			gg.toast("[i] Removing annotations to prevent parsing error... ("..i..'/'..#all_string..')')
			DATA,tmp = string.gsub(DATA,all_string[i],'')
			totalReplaced = totalReplaced + tmp
		end
		print("[i] "..totalReplaced.." annotations/comments removed!")
	end

	print("[i] Injecting anti os.exit detection...")
	DATA = DATA:gsub('os%.exit%(%)','os.exit()print("[AntiExitDetect] Anti exit detected, forcing script to crash")return(nil)()') -- force exit

	if cfg.obfModSettings.encryptStrings then
		gg.toast("[i] Encrypting strings...")
		print("[i] Encrypting strings...")
		print(" |  Developer note: String encryption is experimental! you might encounter errors when compiling the script.")
		collectgarbage()
		local totalReplaced,all_string,tmp = 0,{
		--'%[=*%[(.-)%]=*%]', -- quirky
			'%"%\\"([^\n]-)%\\"%"',
			"%'%\\'([^\n]-)%\\'%'",
			'%"([^\n]-)%"',
			"%'([^\n]-)%'",
			'%[===%[(.-)%]===%]',
		--'%[==%[(.-)%]==%]', bug: collision with decode function
			'%[=%[(.-)%]=%]',
			'%[%[(.-)%]%]',
		}
		for i=1,#all_string do
			DATA,tmp = string.gsub(DATA,all_string[i],cfg.enc) -- untested
			totalReplaced = totalReplaced + tmp
		end
		print("[i] "..totalReplaced.." strings encrypted!")
		totalReplaced,all_string,tmp = nil,nil,nil
	end

	if cfg.obfModSettings.encryptTables then
	-- below can be buggy (in case of function decode([==[ENCRYPTED]==])[CONTENT]end.
	-- replace any `function bla.bla()` > `bla.bla = function()` to prevent such bug from occuring
		gg.toast("[i] Encrypting common table queries...")
		print("[i] Encrypting common table queries...")
		print(" |  Developer note: please make sure your script doesn't --")
		print(" |  have any of the syntaxes like `function a.b()...end`")
		print(" |  The encryptor had a known bug where it throws error when compiling")
		print(" |  an obfuscated script with the said code")
		local totalReplaced,tmp = 0
		collectgarbage()
		for _,v in ipairs{"gg","io","os","string","math","table","debug","bit32","utf8"} do
			print(" |  "..v)
		--DATA,tmp = DATA:gsub(v..'%.(%a+)%(', function(s)return v..'['..cfg.enc(s)..'](' end) -- table.insert()
		--EXPERIMENTAL
		--DATA     = DATA:gsub(v..'%.(%a+)%{', function(s)return v..'['..cfg.enc(s)..']{' end) -- table.insert{}
		--DATA     = DATA:gsub(v..'%.(%a+)%"', function(s)return v..'['..cfg.enc(s)..']"' end) -- table.insert""
		--DATA     = DATA:gsub(v..'%.(%a+)%\'',function(s)return v..'['..cfg.enc(s)..']\''end) -- table.insert''
			DATA,tmp = DATA:gsub(v..'%.(%a+)%(', function(s)return '_ENV['..cfg.enc(v)..']['..cfg.enc(s)..'](' end) -- table.insert()
			DATA     = DATA:gsub(v..'%.(%a+)%{', function(s)return '_ENV['..cfg.enc(v)..']['..cfg.enc(s)..']{' end) -- table.insert{}
			DATA     = DATA:gsub(v..'%.(%a+)%"', function(s)return '_ENV['..cfg.enc(v)..']['..cfg.enc(s)..']"' end) -- table.insert""
			DATA     = DATA:gsub(v..'%.(%a+)%\'',function(s)return '_ENV['..cfg.enc(v)..']['..cfg.enc(s)..']\''end) -- table.insert''
			totalReplaced = totalReplaced + tmp
		end
		print("[i] "..totalReplaced.." common table queries encrypted!")
		totalReplaced,all_string,tmp = nil,nil,nil
	end

	print("[i] Wrapping main function to mainPayload()...")
	collectgarbage()
	DATA = "local function mainPayload()local gg,os,io=gg,os,io "..DATA.."\nend mainPayload()"

	gg.toast("[i] Configuring Obfuscations...")
	print("[i] Configuring Obfuscations...")
	collectgarbage()
	for i,v in pairs(obfMod) do
		if type(v) == 'function' then obfMod[i] = v() end
	end

	-- Append obfuscation module before script starts, and put decryptor at very beginning (applied in reverse order)
	gg.toast("[i] Applying Obfuscations...")
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
	if cfg.debugMode then io.writeFile(cfg.fileChoice..".debug.lua",DATA) end
	compileLua(".enc.lua",true,false)

	-- Post-compile. Corrupt the Lua file header to prevent unluac from decompiling
	modFileHeader('LuaBreakHeader')

	-- Restore everything back
	dec_wrap_XOR = cfg.dec_wrap_factory
	cfg.dec_wrap = nil
end
function decryptLua()
	DATA = io.readFile(cfg.fileChoice..'.enc.lua')

	local dec_XOR_RandomKey=function(iv,key)local i,iv_,key_=0,{string.byte(iv,0,-1)},{string.byte(key,0,-1)} r=iv:gsub(".",function()i=i+1 return string.char(iv_[i]~key_[i])end)return r end

	DATA = DATA:gsub('%(decode%(%[==%[(.-)%]==%],"(.-)"%)%)',function(i)return'"'..cfg.enc(i)..'"'end)
	DATA = DATA:gsub([['gg%[decode%(%[==%[(.-)%]==%],"(.-)"%)%]%(']],function(i)return'gg.'..dec_XOR_RandomKey(i)..'('end)

	io.writeFile(cfg.fileChoice..".dec.lua",DATA)
end
function compileLua(fileExt,stripDebugSymbols,useNames)
	gg.toast("[i] Compiling...")
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
	local defaultByteReplacement = '\4\1\0\0\0'
	local byteReplace = {
		-- Credit: LuaGGEG
		-- btw 4,1,0,0,0 can also be 4,9,0,0,0 sequence
		-- and most of these can also be repeat 1e4 instead of 1e3
		-- I think i know how these works, this is the example: (PROTECTEDLASM = "\0...(repeated 10k times)") (repeated 60k times)
		{'\4\17\39\0\0'..('\0\99\53\131\82\116\66\115\67\53'):rep(1e3),defaultByteReplacement},
		{'\4\17\39\0\0'..('\0\99\53\66\82\116\66\115\67\53'):rep(1e3),defaultByteReplacement},
		{'\4\17\39\0\0'..('\0'):rep(1e3),defaultByteReplacement},
		{'\4\17\39\0\0'..('\72'):rep(1e3),defaultByteReplacement},
		{'\4\17\39\0\0'..('\90'):rep(1e3),defaultByteReplacement},
		{'\4\17\39\0\0'..('\10'):rep(1e3),defaultByteReplacement},
		{('\0\99\53\151\82\116\66\115\67\53'):rep(1e3),defaultByteReplacement},
		{('\0\99\53\66\82\116\66\115\67\53'):rep(1e3),defaultByteReplacement},
		{('\0\99\145\151\23\130\37\115\67\53'):rep(1e3),defaultByteReplacement},
		{('\0\103\53\151\82\116\70\115\67\69'):rep(1e3),defaultByteReplacement},
		{('\48\120\48\48'):rep(1e3),defaultByteReplacement},
		{('\48\120\114'):rep(1e3),defaultByteReplacement},
--[[{'\4\17\39\0\0'..('.').rep(1e3),'\4\9\0\0\0'},]]
		{'\4\17\39\0\0'..('\0\63\35\83\52\74\42\73\43\35'):rep(1e3),defaultByteReplacement},
		{'\4\17\39\0\0'..('\0\63\35\42\52\74\42\73\43\35'):rep(1e3),defaultByteReplacement},
		{'\4\17\39\0\0'..('\0\63\91\83\17\82\25\73\43\35'):rep(1e3),defaultByteReplacement},
		{'\4\17\39\0\0'..('\0\67\35\83\52\74\46\73\43\45'):rep(1e3),defaultByteReplacement},
		{'\4\17\39\0\0'..('\30\78\30\30'):rep(1e3),defaultByteReplacement},
		{'\4\17\39\0\0'..('\72'):rep(1e3),defaultByteReplacement},
		{'\4\17\39\0\0'..('\30\78\72'):rep(1e3),defaultByteReplacement},
	}
	local luacData = io.readFile(cfg.fileChoice..'.enc.lua')
	for j=1,#byteReplace do
		luacData,r = luacData:gsub(byteReplace[j][1],byteReplace[j][2])
		print(j.." Applied! replaced: "..r)
	end
	local outputBuffer,err = load(luacData)
	if err or not outputBuffer then
		print("[!] Failed to reassemble the script, more information:\n\n",err)
		print("[!] Result script is dumped, but it might not run at all")
		io.writeFile(
			cfg.fileChoice..".dump.lua",
			luacData
		)
	else
		io.writeFile(
			cfg.fileChoice..".enc.lua",
			string.dump(outputBuffer,true,false) -- TODO: do we even need this?
		)
	end
end
function patchAssembly(patchName) -- make sure DATA is loaded first before running the patcher
	collectgarbage()
	local r
	local patch = deobfPatch[patchName]
	local patchType = type(patch)
	local patchLen = #patch
	if patchType == 'table' then -- patchset
		for j=1,patchLen do
			gg.toast("Applying "..patchName.." patch... "..j.."/"..patchLen)
			DATA,r = DATA:gsub(patch[j][1],patch[j][2])
			print(patchName.." "..j.." Applied! replaced "..r)
		end
	elseif patchType == 'function' then -- function (allows blackbox scripts)
		DATA = patch(DATA)
		print(patchName.." Applied!")
	end
end
function secureRun(opts)
	cfg.fileChoice = opts.targetScript:gsub(".lua$",'')
	gg.toast('[i] Click "__yes__" if you get a popup __about__ corrupted header, __load__ __script__...')
	local ScriptResult,err = loadfile(opts.targetScript) -- load target script
	if not ScriptResult or err then -- Error detection
		gg.toast("[!] __fail__ to load the __script__, see print log for more details.")
		return print("[!] __fail__ to load the __script__, more details:\n\n",err)
	end
	if opts.wrapScript ~= '' then -- if wrapper script given, load it
		local ScriptWrapper,err = loadfile(opts.wrapScript) -- load wrapper script
		if not ScriptWrapper or err then -- Error detection
			gg.toast("[!] Failed to load the wrapper script, see print log for more details.")
			print("[!] Failed to load the wrapper script, more details:\n\n",err)
		end
	end
	--if not gg.alert("[!] The script will be executed, if you sure to continue, press OK") then return end

	do -- Prepare isolated container
		gg.toast("[i] Preparing isolated container...")
		print("[VirtGG] Preparing isolated container...")
		local Repl

		do -- Prepare fricked variables (contain it so it doesnt get leaked and be read by script by indexing _ENV)



			Repl = {
				["io"]=table.copy(io),
				["os"]=table.copy(os),
				["gg"]=table.copy(gg),
				["debug"]=table.copy(debug),
				["string"]=table.copy(string),
				["math"]=table.copy(math),
				["table"]=table.copy(table),
				["utf8"]=table.copy(utf8),
				["print"]=print,
				["env"]=_ENV,
				["loadfile"]=loadfile,
				["loadstring"]=loadstring,
				["load"]=load,
				["dofile"]=dofile,
				["pcall"]=pcall,
				["xpcall"]=xpcall,
				["tostring"]=tostring,
				["select"]=select,
				["type"]=type,
				["pairs"]=pairs,
				["ipairs"]=ipairs,
				["next"]=next,
			}
			local origRef = {} -- original reference, queried using fake function, returns real ones (mostly used by fake debug thing).
			local ContainmentFiles = {}
		--TODO: if the said folder not exist, any io.open:write request will crash
			ContainmentFiles.pwd = cfg.scriptPath.."_ContainmentDir"
			ContainmentFiles.luascript = ContainmentFiles.pwd..'/'..opts.targetScript:gsub('.+/','')
			ContainmentFiles.txtfile = ContainmentFiles.pwd.."/ContainedText.txt"
			ContainmentFiles.dumplogfile = ContainmentFiles.pwd.."/ScriptLog_"..os.date('%d.%m.%Y_%H.%M.%S')..".log"

			opts.logFileSocket = io.open(ContainmentFiles.dumplogfile,'w')
			Repl.dump = function(...)
				local arg = {...}
				Repl.print(arg[1])
				opts.logFileSocket:write(arg[1])
			end
			if not opts.quietLog then Repl.print("[Info] Initializing virtual GameGuardian API methods...") end
			Repl.print("[Info] Using contained directory for script:",ContainmentFiles.pwd)
			local function parseGGVarTypes(typ,val)
				return ({
					TYPE={
						[127]="gg.TYPE_AUTO",
						[1]="gg.TYPE_BYTE",
						[64]="gg.TYPE_DOUBLE",
						[4]="gg.TYPE_DWORD",
						[16]="gg.TYPE_FLOAT",
						[32]="gg.TYPE_QWORD",
						[2]="gg.TYPE_WORD",
						[8]="gg.TYPE_XOR"
					},
					REGION={
						[32]="gg.REGION_ANONYMOUS",
						[524288]="gg.REGION_ASHMEM",
						[131072]="gg.REGION_BAD",
						[16384]="gg.REGION_CODE_APP",
						[32768]="gg.REGION_CODE_SYS",
						[4]="gg.REGION_C_ALLOC",
						[16]="gg.REGION_C_BSS",
						[8]="gg.REGION_C_DATA",
						[1]="gg.REGION_C_HEAP",
						[65536]="gg.REGION_JAVA",
						[2]="gg.REGION_JAVA_HEAP",
						[-2080896]="gg.REGION_OTHER",
						[262144]="gg.REGION_PPSSPP",
						[64]="gg.REGION_STACK",
						[1048576]="gg.REGION_VIDEO"
					},
					SIGN={
						[536870912]='gg.SIGN_EQUAL',
						[67108864]='gg.SIGN_GREATER_OR_EQUAL',
						[134217728]='gg.SIGN_LESS_OR_EQUAL',
						[268435456]='gg.SIGN_NOT_EQUAL'
					}
				})[tostring(typ)][tonumber(val)] or tostring(val)
			end

			gg.getFile = (function()local _=ContainmentFiles.luascript return function()return _ end end)() -- fix bug
			gg.ANDROID_SDK_INT = 33
			gg.BUILD = opts.ggVerBuild
			gg.CACHE_DIR = ContainmentFiles.pwd..'/cache'
			gg.EXT_CACHE_DIR = ContainmentFiles.pwd..'/extCache'
			gg.EXT_FILES_DIR = ContainmentFiles.pwd..'/internalData'
			gg.EXT_STORAGE = ContainmentFiles.pwd..'/extStorage'
			gg.FILES_DIR = ContainmentFiles.pwd..'/internalData'
			gg.PACKAGE = opts.ggPkgName
			gg.VERSION = opts.ggVer
			gg.VERSION_INT = opts.ggVerInt
		--can't fool us, enc plebs
			gg.setVisible(true)
			table.tostring = nil
			table.copy = nil
			table.merge = nil
			io.readFile = nil
			io.writeFile = nil
		--string.char = Repl.string.char -- uhh why this here?
			if opts.disableMalFn then -- Disable mallicious functions
				local void = function(name)
					return function(...)
						Repl.print("[Warn] Intercepted: " .. name)
						return nil
					end
				end
				local nullFn = function()end -- null function
		--[[local genFakeUserdata = (function()
					local defOpts = {__index = { -- defaults
						file = nil,
						content = "Privacy preserved! you can't just read user private data like that!",
						apiType = "fake", -- fake,tmpfile
					}}
					return function(opts)
						if type(opts) ~= 'table' then opts = {} end
						setmetatable(opts,defOpts)
						local ud
						if opts.apiType == 'tmpfile' then -- tmpfile
							ud = io.tmpfile()
							if opts.file then
								local tmpyeet = io.open(opts.file,'r')
								ud:write(tmpyeet:read('a*')):seek('set',0)
								ud:flush()
								tmpyeet:close()
								tmpyeet = nil
							elseif opts.content then
								ud:write(opts.content):seek('set',0)
								ud:flush()
							end
						else -- fake
							ud = {} -- null
							function ud:write(DATA)
								print('io.write',DATA,self.file)
								return self
							end
							function ud:close()
								self,ud = nil,nil
								return true
							end
							function ud:input()

								return
							end
							function ud:output()

								return
							end
							function ud:read()
								return self.content
							end
						end
						return ud
					end
				end)()]]
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
				os.date    = function(dateFormat)
					if dateFormat == "%Y%m%d" then return "19991230" end
					return Repl.os.date(dateFormat)
				end
				os.execute = function(cmd)
					if type(cmd) ~= 'string' then cmd = 'MalformedType:'..type(cmd) end
					Repl.print('[Warn] Intercepted os.execute("'..cmd..'")')
				end
				os.remove  = function(path)
					if type(path) ~= 'string' then path = 'MalformedType:'..type(path) end
					Repl.print('[Warn] Intercepted os.remove("'..path..'")')
				end
				io.open    = function(file,opmode)
				 --only log because orig io.open returns file/type userdata
					if not file then return nil,': No such file or directory',2 end
					opmode = tostring(opmode or "r")
					file = ContainmentFiles.pwd..'/'..file:gsub('.+/','') -- strip everything except filename
					Repl.print('[Malicious] io.open',file,opmode)
					return Repl.io.open(file,opmode) or io.tmpfile()
				--return
				end
				io.close   = function()
					Repl.print("[Warn] Intercepted: io.close")
					return true
				end
				io.output  = void("io.output")
				io.read  	 = void("io.read")
				io.write   = void("io.write")
				io.popen   = io.tmpfile -- same as os.execute
				io.stdin   = io.tmpfile()
				io.stderr	 = io.tmpfile()
				io.stdout	 = io.tmpfile()
		--[[io.input	 = function(...)
					Repl.print('[Malicious] io.input',...)
					return Repl.io.input(ContainmentFiles.txtfile,"r")
					return Repl.io.input(...)
				end]]
		--[[io.read		 = function(...)
					Repl.print('[Malicious] io.read',...)
					return Repl.io.read(ContainmentFiles.txtfile,"r")
					return Repl.io.read(...)
				end]]
				_VERSION = "Lua 5.0"
				load = function()
				--Repl.print("[Warn] Intercepted: load")
					return nullFn
				end
				loadfile = function(f)
					Repl.print("[Warn] Intercepted: loadfile",f)
				--return nullFn
					if f == ContainmentFiles.luascript then return nullFn end
					return Repl.loadfile(f)
				end
				loadstring = function()
					Repl.print("[Warn] Intercepted: loadstring")
					return nullFn
				end
				dofile = function(file)
					if type(file) ~= "string" then return end
					Repl.print("[Warn] Intercepted: dofile: "..file)
					return Repl.dofile(file)
				end
				pcall = function(...)
					local args = {...}
					if type(args[1]) ~= "function" then return end
					Repl.print("[Warn] Intercepted: pcall,",table.unpack(args))
					return Repl.pcall(table.unpack(args))
				end
				xpcall = function(fn)
					if type(fn) ~= "function" then return end
					Repl.print("[Warn] Intercepted: xpcall")
					return Repl.xpcall(fn)
				end
				tostring = (function(a,...)
					local currentHash = math.random(0x100000000000,0xffffffffffff) -- just in case the script calculates the memory address difference somehow using proprietary algo
					local hashesOfRandomFn = {} -- remember hashes of random functions in case the script checks same variable twice
					return function(a,...) -- prevent anti-hook, especially with function
						if type(a) == "function" then
							if not hashesOfRandomFn[a] then
								currentHash = currentHash + math.random(0x100,0xfff)
								hashesOfRandomFn[a] = currentHash
							end
							return "function: 0x"..string.format("%x",hashesOfRandomFn[a])
						elseif type(a) == "table" then
							if not hashesOfRandomFn[a] then
								currentHash = currentHash + math.random(0x100,0xfff)
								hashesOfRandomFn[a] = currentHash
							end
							return "table: 0x"..string.format("%x",hashesOfRandomFn[a])
						end
						return Repl.tostring(a,...)
					end
				end)()
				debug.gethook = function() -- f,a,b. prevent anti-hook
					Repl.print("[Warn] Intercepted: debug.gethook")
					return nil, 0
				end
				debug.getinfo = function(f) -- ...,a,b. prevent anti-hook
				--Repl.print("[Warn] Intercepted: debug.getinfo")
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
					Repl.print("[Warn] Intercepted: debug.getlocal")
				--prevent another anti-hook
					if type(a) == "function" and tonumber(b) == 1 then return end
					local name,value = Repl.debug.getlocal(a,b)
					--local name,value = Repl.debug.getlocal(true)
					--name = name or string.char(({math.random(65,90),math.random(97,122)})[math.random(1,2)]):rep(math.random(1,10))
					--value = value or string.char(({math.random(65,90),math.random(97,122)})[math.random(1,2)]):rep(math.random(1,10))
					return name,value
				end
				debug.sethook = function(f,a,b) -- prevent anti-hook
				--Repl.print("[Warn] Intercepted: debug.sethook")
					return
				end
				debug.traceback = function(m,a,b) -- prevent log spam, but can also be used for log detection when used
				--local res = Repl.debug.traceback(m,a,b)
				--Repl.print("[Warn] Intercepted: debug.traceback")
					if m then m = m.."\n" else m = "" end
					return m.."stack traceback:\n	"..ContainmentFiles.luascript..": in main chunk\n	[Java]: in ?"
				--return res
				end
				string.rep = function(s,a) -- reduce log spam size
					if a > 55 then a = 2 end -- in case u ask, this is faster than math.min (already tested it: 1.2s vs 0.4s)
					return Repl.string.rep(s,a)
				end
				print = function(...)
					Repl.print("[Script] ",...)
				end

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
					elseif CH == 2 then os.exit=nullFn end
				end
			end
			if opts.runTests then -- Run security tests
				Repl.print('[VirtGG] Running security tests...')
				local isTestsFailed = false

			--os.execute test
				if os.execute("echo os.execute test passed") == "os.execute test passed" then Repl.print("[!] os.execute intercept test FAILED") isTestsFailed = true end
				os.remove(ContainmentFiles.txtfile..".sampleremove")

			--io.popen test
				local tempIoPopenTest = io.popen("echo io.popen test passed")
				if tempIoPopenTest:read('*a') == "io.popen test passed" then Repl.print("[!] io.popen intercept test FAILED") isTestsFailed = true end
				tempIoPopenTest:close()
				tempIoPopenTest = nil

			--other tests
			--if type(io.open(ContainmentFiles.txtfile..".sampleremove",'r')) == 'userdata' then Repl.print("[!] io.open intercept test FAILED") isTestsFailed = true end
			--io.input(ContainmentFiles.txtfile..".sampleremove") -- orig API throws error
				io.output(ContainmentFiles.txtfile..".sampleremove")
				io.read()
				io.write()
				if ({io.close()})[2] == "cannot close standard file" then Repl.print("[i] io.close intercept test failed, but this API is SAFE") end
				if gg.getFile() ~= ContainmentFiles.luascript then Repl.print("[!] gg.getFile intercept test FAILED") isTestsFailed = true end
				if gg.makeRequest().url ~= "http://127.0.0.1" then Repl.print("[!] gg.makeRequest intercept test FAILED") isTestsFailed = true end
				gg.getResults(123)
				if _VERSION ~= "Lua 5.0" or _ENV._VERSION ~= "Lua 5.0" or _G._VERSION ~= "Lua 5.0" then Repl.print("[i] _VERSION query test failed, but this API is SAFE")  end
				print('If you see [Script] after this text, it works')
				if isTestsFailed then
					if opts.exitIfTestsFail then
						gg.toast('[-] Some tests are failed. Exiting for security reason...')
						Repl.print('[-] Some security tests are failed. Exiting for security reason...')
						Repl.os.exit()
					else
						gg.toast('[!] Some Security tests are failed. Continue at your own risk!')
						Repl.print('[!] Some security tests are failed.')
					end
				else
					Repl.print('[+] Security test PASSED! safe to continue...')
				end
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
					if not t or t == "" then return end
					Repl.print('[Dump] gg.alert('..t..','..o1..','..o2..','..o3..')')
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
								Repl.print('[gg.choice] •'..k..':'..v)
							else
								Repl.print('[gg.choice]  '..k..':'..v)
							end
							i = i + 1
						end
					end
					local tmp = Repl.gg.choice(items,selected,msg)
					Repl.print("[gg.choice] > "..tostring(tmp))
					return tmp
				end
				gg.multiChoice=function(items,selected,msg)
					Repl.print('[gg.multiChoice] '..msg)
					if type(items) == "table" then
						i = 1
						for k,v in pairs(items) do
							if (selected and selected[k]) then
								Repl.print('[gg.multiChoice] ✓'..k..':'..v)
							else
								Repl.print('[gg.multiChoice]  '..k..':'..v)
							end
							i = i + 1
						end
					end
					local tmp = Repl.gg.multiChoice(items,selected,msg)
					Repl.print("[gg.multiChoice] > "..tostring(table_tostring(tmp)))
					return tmp
				end
				gg.searchNumber=function(n,t,e,s,f,o,l)
					n=n or ""
					t=t or gg.TYPE_AUTO
					e=e or false
					s=s or gg.SIGN_EQUAL
					-- Prevent Log Spam
					if
						not (type(t) == "string" and #t < 600 or type(t) == "number") or
						type(t) ~= "number" or
						type(e) ~= "boolean" or
						type(s) ~= "number" or
						not (type(f) == "nil" or type(f) == "number") or
						not (type(o) == "nil" or type(o) == "number") or
						not (type(l) == "nil" or type(l) == "number")
					then return true end
					if opts.dumpCalls then Repl.print("[Dump] gg.searchNumber(\""..n.."\","..parseGGVarTypes("TYPE",t)..","..parseGGVarTypes("SIGN",s)..")") end
					return Repl.gg.searchNumber(n,t,e,s,f,o,l)
				end
				gg.refineNumber=function(n,t,e,s,f,o,l)
					n=n or ""
					t=t or gg.TYPE_AUTO
					s=s or gg.SIGN_EQUAL
					-- Prevent Log Spam
					if
						not (type(t) == "string" and #t < 600 or type(t) == "number") or
						type(t) ~= "number" or
						type(e) ~= "boolean" or
						type(s) ~= "number" or
						not (type(f) == "nil" or type(f) == "number") or
						not (type(o) == "nil" or type(o) == "number") or
						not (type(l) == "nil" or type(l) == "number")
					then return true end
					if opts.dumpCalls then Repl.print("[Dump] gg.refineNumber(\""..n.."\","..parseGGVarTypes("TYPE",t)..","..parseGGVarTypes("SIGN",s)..")") end
					return Repl.gg.refineNumber(n,t,e,s,f,o,l)
				end
				gg.refineAddress=function(n,m,t,s,f,o,l)
					n=n or ""
					m=m or -1
					if opts.dumpCalls then Repl.print("[Dump] gg.refineAddress("..n..","..parseGGVarTypes("TYPE",t)..","..parseGGVarTypes("SIGN",s)..")") end
					return Repl.gg.refineAddress(n,m,t,s,f,o,l)
				end
				gg.getResults=function(c,s,a,b,t,f,p)
					local tbl = {}
					c = tonumber(c) or 0
					t = t or gg.TYPE_AUTO
					if opts.dumpCalls then Repl.print("[Dump] gg.getResults("..c..","..parseGGVarTypes("TYPE",t)..")") end
					return Repl.gg.getResults(c,s,a,b,t,f,p)
				end
				gg.setValues=function(t)
					if type(t) == "table" and t[1] and not t[1].flags then
						return Repl.print("[Dump] gg.setValues(Invalid table!)")
					end
					Repl.gg.setValues(t)
					for i=1,#t do
						if t[i] then t[i].address = string.format("%x",t[i].address) end
					end
					if opts.dumpCalls then Repl.print("[Dump] gg.setValues("..table_tostring(t)..")") end
					return true
				end
				gg.addListItems=function(t)
					if type(t) == "table" and t[1] and not t[1].flags then
						return Repl.print("[Dump] gg.addListItems(Invalid table!)")
					end
					Repl.gg.addListItems(t)
					for i=1,#t do
						if t[i] then t[i].address = string.format("%x",t[i].address) end
					end
					if opts.dumpCalls then Repl.print("[Dump] gg.addListItems("..table_tostring(t)..")") end
					return true
				end
				gg.editAll=function(v,t)
					v = v or ""
					t = t or gg.TYPE_AUTO
					if opts.dumpCalls then Repl.print("[Dump] gg.editAll("..v..","..parseGGVarTypes("TYPE",t)..")") end
					return Repl.gg.editAll(v,t)
				end
				gg.setRanges=function(r)
					r = r or gg.REGION_AUTO
					if opts.dumpCalls then Repl.print("[Dump] gg.setRanges("..parseGGVarTypes("REGION",r)..")") end
					return Repl.gg.setRanges(r)
				end
				gg.isPackageInstalled = function(p) -- prevent querying of certain packages
					p = tostring(p)
					if opts.dumpCalls then Repl.print("[Dump] gg.isPackageInstalled("..p..")") end
					local packages = {
					-- Good old SSTool
						"sstool.only.com.sstool",
						"com.hckeam.mjgql",
					-- Some scripts is really weird, why Termux was considered a "decryptor" ?
						"com.termux",
					}
					for i=1,#packages do if p == packages[i] then return false end end -- return false if certain pkgs queries detected
					if p == Repl.gg.PACKAGE then return true end -- return true if gg pkg is queried
					if #p > 50 then return false end -- return false if string is too long
					return Repl.gg.isPackageInstalled(p) -- let gg API do the rest
				end

			--TODO: loadResults, processKill ?

			end
			if opts.dumpInputStr then -- Dump input strings
				local pass = math.random(1000,9999)
				local f = Repl.io.open(opts.dumpLogTo,'w')
				Repl.gg.alert('You chose dump input string option. Displays possible passwords. Works only if the plain password is in the code. On the offer to put password, type '..pass)
				local cache = {}
				local debugGetLocal = Repl.debug.getlocal
				local debugGetInfo = Repl.debug.getinfo
				local origPrint = Repl.print
				cache[pass] = true
				Repl.debug.sethook(function()
					local stack = {}
					for j = 1,250 do
						local _,v = debugGetLocal(ScriptResult,j)
						if v then
							local t = type(v)
							if t == 'string' or t == 'number' then stack[v] = true
							elseif t == 'table' then
								for _,vv in pairs(v) do
									t = type(vv)
									if t == 'string' or t == 'number' then stack[vv] = true end
								end
							end
						end
					end
				--if stack[pass] then -- useless
						local buffer = '' -- temporary to hold some strings
						for i,_ in pairs(stack) do
							if not cache[i] then
								cache[i] = true
								buffer = buffer..i.."\n"
							end
						end
						if buffer ~= '' then
							origPrint('[dumpInputStr]',buffer)
							if f then f:write(buffer)end
						end
						buffer = nil
				--end
				end,'cl',1)





			end
			Repl.gg.toast("[i] Running script In isolated container...")
			Repl.print("[i] Running script In isolated container...\n==========\n\n")




		end
		do -- Prepare another Isolated container to run the script (prevents leaked outside/inside variables)
			local Repl,opts,CH,cfg = nil,nil,nil,nil -- prevent other value from getting accesed
			collectgarbage()
			if ScriptWrapper then ScriptWrapper()ScriptWrapper=nil end
			ScriptResult = ScriptResult()
		--also there is an other encryptor checks like `debug.getinfo(1).istailcall` that can be bypassed with `dofile()`
		end
	 -- Cleanup some fricked variables
		Repl.debug.sethook(nil,'cl',1)
		for i,v in pairs(Repl)do
			_ENV[i]=v
			if Repl.type(v) == 'tables' then
				for ii,vv in pairs(v)do
					_ENV[i][ii]=vv
				end
			end
		end
	--Repl = nil
		print("\n\n==========")
		collectgarbage()
	end
	return print("[+] Clean exit ---\n",ScriptResult or '')
end
function splitLuaAssembly(input)
-- TODO - BUG:
-- instructions failed when:
-- BLABLABLA
-- JMP :goto_148  ; +1 ↓
-- RETURN
-- :goto_148
-- INSTUCTION CONTINUES...
-- FUNCTIONS IS ALL THE WAY ON THE BOTTOM
-- 2nd BUG AFTER FIXED:
-- STUCK AT PARSING INSTRUCTIONS
gg.toast(1) -- DEBUGGING
	local sourceContent = input:match('(%.source .-%.upval [uv]%d- .-)\n') or ""
gg.toast(2) -- inst with func -- DEBUGGING
	local instructions = input:match("\n%.maxstacksize %d-\n(.-)\n%.func"):gsub("^%.upval [uv]%d- .-\n","",1)
--local instructions = input:match("\n%.upval .-\n(.-\nRETURN)\n%.func") or input:match("\n%.upval .-\n(.-\nRETURN)") or ""
gg.toast(3) -- DEBUGGING
	local functions = input:match("\n(%.func .+\n%.end)") or ""
	if not instructions then
gg.toast(4) -- inst without func -- DEBUGGING
		instructions = input:match("\n%.maxstacksize %d-\n(.+\nRETURN)"):gsub("^%.upval [uv]%d- .-\n","",1)
	end
	if not instructions then
gg.toast(5) -- DEBUGGING
		instructions = ""
	end
gg.toast(6) -- DEBUGGING
	return {
		sourceContent,
		instructions,
		functions
	}
end

--————————————————————————————————--

--— Dependency & init ————————————--
table.tostring = function(t,dp)
	local r,tv = '{\n'
	dp = dp or 0
	for k,v in pairs(t) do
		r = r..('\t'):rep(dp+1)
		tv = type(v)
		if type(k) == 'string' then
			r = r..k..' = '
		end
		if tv == 'table' then
			r = r..table.tostring(v,dp+1)
		elseif tv == 'boolean' or tv == 'number' then
			r = r..tostring(v)
		else
			r = r..'"'..v..'"'
		end
		r = r..',\n'
	end
	return r..('\t'):rep(dp)..'}'
end
table.copy = function(t)
  local t2={}
  for k,v in pairs(t)do
		t2[k]=type(v)=="table"and table.copy(v)or v
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
			r[k] = type(r[k]) == "table" and table.merge(r[k],v) or v
		end
	end
	return r
end
if not gg.sleep then
	gg.sleep = function(ms)
	--no true way to imitate this, the recreation below is inaccurate, its a bit faster
		local clck = os.clock
		ms = ms/5000+clck()
		while clck() < ms do end
		start,ms,clck = nil,nil,nil
	end
end
--os.sleep = gg.sleep
io.readFile = function(path,opMode,readMode)
	local file = io.open(path,opMode or 'r')
	local content = file:read(readMode or '*a')
	file:close()
	return content
end
io.writeFile = function(path,buffer,opMode)
	io.open(path,opMode or 'w'):write(buffer):close()
end
pairs_sorted = function(t) -- A hacky way to loop tables in sorted order
  local i = {} -- make a blank table
  for k in next,t do table.insert(i,k)end -- Deepclone to new blank table (next is slower for sequential tables/array/{1,2,3} but more flexible and saves couple bytes)
  table.sort(i) -- Sort out stuff
  return function() -- this will be used for loopingy stuff
    local k = table.remove(i)
    if k then
      return k,t[k]
    end
  end
end
logOutput = function(content,toPrint,toFile,verbosenessLevel,rateLimit)
	toPrint = toPrint or true
	toFile = toFile or false
	verbosenessLevel = verbosenessLevel or 6 -- Following Linux printk log rule
	rateLimit = rateLimit or 1 -- os.clock rule
	if verbosenessLevel > cfg.logLevel then return end -- return if above an certain set level
	if toPrint then print(table.unpack(content)) end -- print if told so
	if toFile then print('[LogFile]',table.unpack(content)) end -- print if told so
end
--
cfg.fileChoice = cfg.scriptPath
while true do while not gg.isVisible()do gg.sleep(1e3)end gg.setVisible(false)MENU()end
--————————————————————————————————--

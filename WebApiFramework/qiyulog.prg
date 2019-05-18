Define Class QiyuLog As Custom
	Function log
	Lparameters cMsg,cFilename
	If Empty(cFilename)
		cFilename=Dtoc(Date())+".txt"
	Endif
	cMsg=Ttoc(Datetime())+" "+cMsg+Chr(13)+Chr(10)
	Strtofile(cMsg,cFilename,1)
	Endfunc
Enddefine


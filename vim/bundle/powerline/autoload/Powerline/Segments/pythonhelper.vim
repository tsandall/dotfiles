let g:Powerline#Segments#pythonhelper#segments = Pl#Segment#Init('pythonhelper',
	\ (exists('g:loaded_pythonhelper') && g:loaded_pythonhelper == 1),
	\ Pl#Segment#Create('string', '%{pythonhelper#string()}')
\ )

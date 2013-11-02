run ::
	node ./static-here.js 8888 | jade -w index.jade | lsc -cw main.ls | compass watch

fetch ::
	wget -c https://www.moedict.tw/lab/tmuse-cc-by-nc-sa-proxteam/veryfirstdump.json
	./split.pl

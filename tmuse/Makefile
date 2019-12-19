run ::
	node ./static-here.js 8888 | npx pug -w index.jade | npx lsc -cw main.ls | bundle exec compass watch

fetch ::
	wget -c https://www.moedict.tw/lab/tmuse-cc-by-nc-sa-proxteam/veryfirstdump.json
	./split.pl

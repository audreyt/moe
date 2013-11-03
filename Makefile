run ::
	node ./static-here.js 8888 | jade -w index.jade | lsc -cw main.ls */main.ls | compass watch

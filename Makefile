run ::
	node ./static-here.js 8888 | npx pug -w *.jade | npx lsc -cw main.ls */3d.ls */main.ls | bundle exec compass watch

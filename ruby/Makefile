all ::
	npx lsc -c *ls

run ::
	npx lsc -cw *ls | node ./static-here.js 8888

wc ::
	@echo -n Lines:
	@grep -v '# \|^$$' *.ls *.html ../*css | wc -l

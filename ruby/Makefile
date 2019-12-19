all ::
	npx lsc -c *ls

run ::
	npx lsc -cw *ls | static-here

wc ::
	@echo -n Lines:
	@grep -v '# \|^$$' *.ls *.html ../*css | wc -l

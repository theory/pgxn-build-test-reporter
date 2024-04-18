dependencies: cpanfile
	@cpanm --installdeps --notest .

run: bin/build-test-reporter
	@$< -v

load: sql/load.sql
	@psql -f $<

dependencies: cpanfile
	@cpanm --installdeps --notest .

run: bin/build-test-reporter
	@$< -v

load: sql/load.sql $(wildcard data/*.log)
	@psql -f $<
